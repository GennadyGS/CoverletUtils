param (
    [Parameter(mandatory=$true)] $command,
    $projectPath = ".",
    $framework = "net6.0",
    $configuration = "Debug",
    $resultDirectory="TestResult",
    $includeNameSpaces,
    $excludeNameSpaces,
    $arguments
)

$targetAssembly = "$projectPath\bin\$configuration\$framework\*.dll"
$resultPath = Join-Path $projectPath $resultDirectory
$reportPath = Join-Path $resultPath "Report"

if ($includeNameSpaces) {
    $includeParam = $includeNameSpaces
}
else {
    $includeParam = "[*]*"
}

if ($excludeNameSpaces) {
    $excludeParam = $excludeNameSpaces
}
else {
    $excludeParam = "[]"
}

If (Test-Path $resultDirectory) { Remove-Item $resultDirectory -Recurse }

dotnet tool update -g coverlet.console
dotnet tool update -g dotnet-reportgenerator-globaltool

coverlet $targetAssembly `
    --target dotnet `
    --targetargs "$command $projectPath --no-build -- $arguments" `
    --format cobertura `
    --output $resultPath\ `
    --include $includeParam `
    --exclude $excludeParam

reportgenerator "-reports:$resultPath\coverage.cobertura.xml" "-targetdir:$reportPath"
Start-Process $reportPath\index.html
