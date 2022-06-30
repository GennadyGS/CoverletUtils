dotnet tool update -g coverlet.console
dotnet tool update -g dotnet-reportgenerator-globaltool

#Get public and private function definition files.
$Public = Get-ChildItem $PSScriptRoot\*.ps1 -ErrorAction SilentlyContinue
#$Private = Get-ChildItem $PSScriptRoot\Private\*.ps1 -ErrorAction SilentlyContinue

#Dot source the files
Foreach ($import in @($Public)) {
    Try {
        #PS2 compatibility
        if ($import.fullname) {
            . $import.fullname
        }
    }
    Catch {
        Write-Error "Failed to import function $($import.fullname): $_"
    }
}

#Create some aliases, export public functions
Export-ModuleMember -Function $($Public | Select-Object -ExpandProperty BaseName)
