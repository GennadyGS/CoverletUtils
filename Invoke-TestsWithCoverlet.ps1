Function Invoke-TestsWithCoverlet {
    param (
        $framework = "net6.0",
        $resultPath = "./TestResult/",
        $includeNameSpaces,
        $excludeNameSpaces
    )

    $testAssembly = ".\bin\Debug\$framework\*.dll"
    $reportPath = "$resultPath/Report"

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

    If (Test-Path $resultPath) { Remove-Item $resultPath -Recurse }

    coverlet $testAssembly `
        --target "dotnet" `
        --targetargs "test --no-build" `
        --format cobertura `
        --output $resultPath `
        --include $includeParam `
        --exclude $excludeParam

    reportgenerator "-reports:$resultPath\coverage.cobertura.xml" "-targetdir:$reportPath"
    Start-Process $reportPath\index.html
}