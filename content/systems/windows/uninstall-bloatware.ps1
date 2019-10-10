# Try to run as admin, see https://superuser.com/a/532109
param([switch]$Elevated)

function Test-Admin {
    $currentUser = New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent())
    $currentUser.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}

if ((Test-Admin) -eq $false) {
    if (-Not $elevated) {
        Start-Process powershell.exe -Verb RunAs -ArgumentList ('-noprofile -noexit -file "{0}" -elevated' -f ($myinvocation.MyCommand.Definition))
    }

    exit
}

$ToRemove =
    "*Store.Engagement*",
    "*windowscommunications*",
    "*Advertising*",
    "*3DBuilder*",
    "*3DViewer*",
    "*Print3D*",
    "*MixedReality*",
    "*Solitaire*",
    "*Bing*",
    "*WindowsFeedbackHub*",
    "*Microsoft.GetHelp*",
    "*Microsoft.Getstarted*",
    "*Microsoft.Wallet*",
    "*Microsoft.Messaging*",
    "*Microsoft.MicrosoftOfficeHub*",
    "*Microsoft.Office*",
    "*Microsoft.OneConnect*",
    "*Microsoft.People*",
    "*OneNote*",
    "*Skype*",
    "*Xbox*",
    "*Zune*",
    "*Adobe*",
    "*Duolingo*",
    "*News*",
    "*Sway*",
    "*CandyCrush*",
    "*Wunderlist*",
    "*Netflix*",
    "*Twitter*",
    "*Facebook*",
    "*Amazon*",
    "*Pandora*",
    "*Flipboard*"

$confirmation = Read-Host "Also uninstall the Windows Store? [y/n]"
if ($confirmation -eq 'y') {
    $ToRemove +=
        "*WindowsStore*",
        "*DesktopAppInstaller*",
        "*StorePurchaseApp*"
}

Write-Host "[Benni_win10-unprovision] " -ForegroundColor Blue -NoNewline
Write-Host Unprovisioning Windows 10 bloatware...
foreach ($app in $ToRemove) {
    Write-Host "[Benni_win10-unprovision] " -ForegroundColor Blue -NoNewline
    Write-Host Unprovisioning $app...
    Get-AppxProvisionedPackage -Online | where DisplayName -like $app | Remove-AppxProvisionedPackage -Online
}
Write-Host "[Benni_win10-unprovision] " -ForegroundColor Blue -NoNewline
Write-Host Done.


Write-Host "[Benni_clean-win10] " -ForegroundColor Blue -NoNewline
Write-Host Removing Windows 10 bloatware...
foreach ($app in $ToRemove) {
    Get-AppxPackage $app | Remove-AppxPackage
}
Write-Host "[Benni_clean-win10] " -ForegroundColor Blue -NoNewline
Write-Host Done.
