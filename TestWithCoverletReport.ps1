param (
    $projectPath = ".",
    $framework = "net6.0",
    $resultDirectory="TestResult",
    $includeNameSpaces,
    $excludeNameSpaces
)

$testAssembly = "$projectPath\bin\Debug\$framework\*.dll"
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

coverlet $testAssembly `
    --target "dotnet" `
    --targetargs "test $projectPath --no-build" `
    --format cobertura `
    --output $resultPath\ `
    --include $includeParam `
    --exclude $excludeParam

reportgenerator "-reports:$resultPath\coverage.cobertura.xml" "-targetdir:$reportPath"
Start-Process $reportPath\index.html
