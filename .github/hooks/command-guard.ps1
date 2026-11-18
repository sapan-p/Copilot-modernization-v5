# command-guard.ps1: a PreToolUse agent hook (preview), loaded by command-guard.json.
#
# Asks before git changes, publishing, deploying and cloud commands, in every permission mode,
# including Allow all. The terminal rules in .vscode/settings.json do the same in Manual
# permissions: keep the two pattern lists in step.
#
# Input (stdin): the hook payload. Copilot harness: toolName and toolArgs (an object or a JSON
# string). Local harness and the PreToolUse alias: tool_name and tool_input.
# Output (stdout): {} for no decision (the normal permission flow continues), or an "ask"
# decision, written in both the Copilot form (top level) and the Local form
# (hookSpecificOutput).
# Always exits 0: a non-zero exit makes the Copilot harness deny every tool call.
#
# command-guard.json has no matcher, so this runs for every tool call. Once the agent debug log
# shows the terminal tool's name, add  "matcher": "<that name>"  to each entry there.
# Errors show in Output > "GitHub Copilot Chat Hooks" and in the agent debug logs.
#
# Test it: '{"toolName":"powershell","toolArgs":{"command":"git push"}}' |
#   powershell -NoProfile -ExecutionPolicy Bypass -File .github/hooks/command-guard.ps1

$ErrorActionPreference = 'Stop'

# Git changes. Matched anywhere in the command line, so wrapped calls (cmd /c "git push") count.
$gitChange = '\bgit(\.exe)?\b[^;&|\r\n]*\s(add|am|apply|branch|checkout|cherry-pick|clean|clone|commit|config|fetch|gc|init|merge|mv|notes|pull|push|rebase|reflog|remote|reset|restore|revert|rm|stash|submodule|switch|tag|update-ref|worktree)\b'

# Publishing, deploying and cloud. Matched at the start of each command in the line.
$publishCloud = @(
    '^(dotnet\s+nuget|nuget(\.exe)?)\s+(push|delete)\b',
    '^(npm|pnpm|yarn)\s+(npm\s+)?(publish|unpublish|deprecate|dist-tag|owner|login|adduser)\b',
    '^docker\s+((image|manifest)\s+)?(push|login)\b',
    '^docker\s+buildx\b.*\s--push\b',
    '^(mvn|(\.[\\/])?mvnw(\.cmd)?)\b.*\sdeploy\b',
    '^(gradle|(\.[\\/])?gradlew(\.bat)?)\b.*\spublish\w*\b',
    '^(az|azd|aws|gcloud|gh|terraform|tofu|pulumi|kubectl|helm)(\.exe|\.cmd)?(\s|$)',
    '^func\s+azure\b',
    '^twine\s+upload\b',
    '^Publish-(Module|Script|PSResource)\b'
)

$askGit = 'Git change: the kit always asks before git changes, publishing and cloud commands (.github/hooks/command-guard.ps1).'
$askCloud = 'Publishing, deploying or cloud: the kit always asks before git changes, publishing and cloud commands (.github/hooks/command-guard.ps1).'
$askUnreadable = 'The command guard could not read this tool call, so it asks (.github/hooks/command-guard.ps1).'

function Write-Decision([string]$reason) {
    if (-not $reason) {
        [Console]::Out.Write('{}')
        return
    }
    $out = [ordered]@{
        permissionDecision       = 'ask'
        permissionDecisionReason = $reason
        hookSpecificOutput       = [ordered]@{
            hookEventName            = 'PreToolUse'
            permissionDecision       = 'ask'
            permissionDecisionReason = $reason
        }
    }
    [Console]::Out.Write(($out | ConvertTo-Json -Compress -Depth 4))
}

function Get-Field($obj, [string[]]$names) {
    if ($null -eq $obj -or $obj -is [string]) { return $null }
    foreach ($name in $names) {
        $prop = $obj.PSObject.Properties[$name]
        if ($prop -and $null -ne $prop.Value) { return $prop.Value }
    }
    return $null
}

# Splits a command line into the commands it runs, without wrappers: & dotnet build,
# cmd /c "...", powershell -Command "...", Start-Process az -ArgumentList login.
function Get-Segments([string]$line) {
    $clean = $line -replace '\d?\*?>&\d', ' '
    foreach ($part in ($clean -split '\r?\n|&&|\|\||[;|&(){}]')) {
        $segment = $part.Trim()
        $previous = $null
        while ($segment -ne $previous) {
            $previous = $segment
            $segment = $segment -replace '^[\s"''`]+', ''
            $segment = $segment -replace '^(cmd(\.exe)?\s+/[ck]|(powershell|pwsh)(\.exe)?(\s+-\w+)*?\s+-(c|command)|start-process(\s+-filepath)?)\s+', ''
            $segment = $segment.Trim()
        }
        if ($segment) { $segment }
    }
}

function Get-Reason([string]$line) {
    if ($line -match $gitChange) { return $askGit }
    foreach ($segment in (Get-Segments $line)) {
        if ($segment -match $gitChange) { return $askGit }
        foreach ($pattern in $publishCloud) {
            if ($segment -match $pattern) { return $askCloud }
        }
    }
    return $null
}

try {
    $reader = New-Object System.IO.StreamReader([Console]::OpenStandardInput(), [Text.Encoding]::UTF8)
    $raw = $reader.ReadToEnd()
    $payload = $raw | ConvertFrom-Json
    if ($null -eq $payload) { throw 'empty payload' }

    $tool = [string](Get-Field $payload @('toolName', 'tool_name'))
    $toolArgs = Get-Field $payload @('toolArgs', 'tool_input')
    $isShell = $tool -match 'bash|powershell|pwsh|shell|terminal'

    $command = $null
    if ($toolArgs -is [string]) {
        try { $toolArgs = $toolArgs | ConvertFrom-Json }
        catch { if ($isShell) { $command = $toolArgs } }
    }
    if ($null -eq $command) { $command = Get-Field $toolArgs @('command') }

    if ($command -is [string] -and $command.Trim()) {
        Write-Decision (Get-Reason $command)
    }
    elseif ($isShell) {
        Write-Decision $askUnreadable
    }
    else {
        Write-Decision $null
    }
}
catch {
    Write-Decision $askUnreadable
}
exit 0
