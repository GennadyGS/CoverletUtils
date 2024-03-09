param (
    $projectPath = ".",
    $framework = "net6.0",
    $configuration = "Debug",
    $resultDirectory="TestResult",
    $includeNameSpaces,
    $excludeNameSpaces,
    $arguments
)

& $PSScriptRoot\DotNetCommandWithCoverletReport.ps1 run `
    -projectPath $projectPath `
    -framework $framework `
    -configuration $configuration `
    -resultDirectory $resultDirectory `
    -includeNameSpaces $includeNameSpaces `
    -excludeNameSpaces $excludeNameSpace `
    -arguments $arguments
