#Requires -RunAsAdministrator

<#
.DESCRIPTION 
Creates Key DisableSearchBoxSuggestions with value DWORD 1 at path HKEY_CURRENT_USER\Software\Policies\Microsoft\Windows\Explorer. This disables online search for windows explorer. 

.PARAMETER restart 
Switch parameter, if ran with restart it will instantly restart the machine after being ran. 

.PARAMETER WhatIf
What if parameter, will not set value just print out the values

.NOTES
Version 1.0
Author: Miles Singleton https://github.com/virusnetwork
#>

[CmdletBinding()]
param (
    [Parameter()]
    [Switch]
    $restart,

    [Parameter()]
    [Switch]
    $WhatIf
)


Write-Host "Creating key in Regex"
Write-Warning "WORSE CASE SCENARIO THIS MAY BREAK YOUR SYSTEM I TAKE NO RESPONSIBILITY FOR THAT"
$key = 'HKEY_CURRENT_USER\Software\Policies\Microsoft\Windows\Explorer'
$value = 'DisableSearchBoxSuggestions'
$valueData = 1
$valueType = [Microsoft.Win32.RegistryValueKind]::DWord

if ($WhatIf) {
    #TODO: what am i meant to do for a whatIf???
    write-host "Key:`t$key"
    write-host "value:`t$value"
    write-host "valueData:`t$valueData"
    write-host "valueType:`t$valueType"
}
else {
    #[Microsoft.Win32.Registry]::SetValue($key, $value, $valueData, $valueType)

    $property = Get-ItemProperty -Path "Registry::$key" -name $value
    if ($property.DisableSearchBoxSuggestions -eq 1) {
        Write-Host -ForegroundColor Green "It worked :)"

        if ($restart) {
            Restart-Computer -Force
        }
        else {
            Write-Warning "You need to restart the computer ASAP"
            Write-Information "You can use Restart-Computer in PowerShell"
        }
    }
    else { throw "Something went wrong, debug this yourself" }
}