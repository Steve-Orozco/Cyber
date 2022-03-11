<#

Hello!!
This script is meant to install WSL, Windows-Terminal, Linux Distro and enable VMP/WSL

Feel free to ask how this works, and more importantly, improve on this code if you would like!

#>

Write-Host "If you are getting this error:" -ForegroundColor Red

Write-Host "`n`n .\install.ps1 : File C:\Users\usr1\Download\install.ps1 cannot be loaded because running scripts is disabled on this
system. For more information, see about_Execution_Policies at https:/go.microsoft.com/fwlink/?LinkID=135170.
At line:1 char:1
+ .\install.ps1
+ ~~~~~~~~~~~~~
    + CategoryInfo          : SecurityError: (:) [], PSSecurityException
    + FullyQualifiedErrorId : UnauthorizedAccess" -ForegroundColor Yellow `n`n

Write-Host "It is due to ExecutionPolicy, run the following command as Administrator `n`n Set-ExecutionPolicy -ex Bypass `n`nNOTE: When install is finished it will set ExecutionPolicy back to default." -ForegroundColor Red `n`n

$WSL_enabled = (((Get-WindowsOptionalFeature -online -FeatureName Microsoft-Windows-Subsystem-Linux | Select-object -Property State) | Select-String -Pattern "State") -like "@{State=Enabled}")

$VMP_enabled = (((Get-WindowsOptionalFeature -online -FeatureName VirtualMachinePlatform | Select-object -Property State) | Select-String -Pattern "State") -like "@{State=Enabled}")

$WSL_restart = ((Get-WindowsOptionalFeature -online -FeatureName Microsoft-Windows-Subsystem-Linux | Select-object -Property RestartNeeded) -like "@{RestartNeeded=True}")

$VMP_restart = ((Get-WindowsOptionalFeature -online -FeatureName VirtualMachinePlatform | Select-object -Property RestartNeeded) -like "@{RestartNeeded=True}")

try {
    If($WSL_enabled -ccontains $False) {
    Write-Host "WSL is NOT installed!" -ForegroundColor Red; Write-Host "Installing now" -ForegroundColor Green; Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux -NoRestart;
}   else {
	Write-Host "WSL Does not need Reboot." -ForegroundColor Green
}   If($VMP_enabled -ccontains $False) {
    Write-Host "VMP is NOT installed!" -ForegroundColor Red; Write-Host "Installing now" -ForegroundColor Green; Enable-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform -NoRestart;
}   else {
	Write-Host "VMP Does not need Reboot." -ForegroundColor Green
}
} catch { 
    If($WSL_restart -ccontains $True) {
	Write-Host "WSL will need a reboot" -ForegroundColor Red
} else {
	Write-Host "WSL Does not need Reboot." -ForegroundColor Green
} If($VMP_restart -ccontains $True) {
    Write-Host "VMP will need a reboot" -ForegroundColor Red
} else {
    Write-Host "VMP Does not need Reboot." -ForegroundColor Green;
}
}

Start-Sleep -Seconds 5
function Menu
{
    param ([string]$Title = 'Only reboot, after WSl and VPM are installed..')
    param ([string]$Exit = 'If WSL and VPM and installed, type "c"')

    Clear-Host
    Write-Host "================ $Title ====================" 
    "`n"
    Write-Host "Press 'r' to reboot."
    Write-Host "Press 'c' to continue.."
    "`n"
    Write-Host "================ $Exit ================" ` -ForegroundColor Red
}
function reboot_host
{
        Restart-Computer -Confirm -force

}

do
{
    Menu
    $inputs = Read-Host "Make a Selection.." 
    switch ($inputs)
    {
        'r' {               
                reboot_host
            }
        'c' {
                Write-Host "Press 'c' to continue.."
            }
    }
}
until ($inputs -eq 'c')

#Install Linux Distro
#Would be nice to run a task that kicks off script where you left off after executing..

#Logic to if kali install or ubuntu installed run, else skip
function Menu
{
    param ([string]$Title = 'Pick a Linux Distro to install on wsl')
    param ([string]$Exit = 'Make sure to press C to continue this install after linux is done installing')

    Clear-Host
    Write-Host "================ $Title ====================" 
    "`n"
    Write-Host "1: Press '1' Install Kali."
    Write-Host "2: Press '2' Install Ubuntu"
    Write-Host "C: Press 'C' to continue..."
    "`n"
    Write-Host "================ $Exit ================" ` -ForegroundColor Red
}
function Install-Kali
{
        Start-Process -FilePath "C:\windows\system32\cmd.exe" -ArgumentList "/c wsl.exe --install -d kali-linux"

}
function Install-Ubuntu
{
        Start-Process -FilePath "C:\windows\system32\cmd.exe" -ArgumentList "/c wsl.exe --install -d ubuntu-20.04"
}

do
{
    Menu
    $inputs = Read-Host "Make a Selection" 
    switch ($inputs)
    {
        '1' {               
                Install-Kali
            }
        '2' {
                Install-Ubuntu
            }
        'C' {
                 Write-Host "Press 'C' to continue.."
            }
    }
}
until ($inputs -eq 'C')



#Installs Windows-Terminal from Github
Add-AppxPackage https://github.com/microsoft/terminal/releases/download/v1.12.10393.0/Microsoft.WindowsTerminal_1.12.10393.0_8wekyb3d8bbwe.msixbundle


$kali_install = ((Get-AppxPackage -Name "*kali*" | Select-Object -Property PackageFullName) -and "*kali*")

$ubuntu_install = ((Get-AppxPackage -Name "*ubuntu*" | Select-Object -Property PackageFullName) -and "*ubuntu*")

If(-Not $kali_install) {
Write-Host "Kali is not installed.." -ForegroundColor Red; exit
} else {
Write-Host "Kali will be starting shortly..."; wt.exe kali
} If(-Not $ubuntu_install) {
    Write-Host "Ubuntu is not installed" -ForegroundColor Red; exit
} else {
    Write-Host "Ubuntu will be starting shortly..."; wt.exe ubuntu2004
}
Start-sleep 3

Write-Host "Installation Complete, goodbye.." -ForegroundColor Green

Start-sleep 3

# Setting ExecutionPolicy to Default (Restricted)

Set-ExecutionPolicy -ExecutionPolicy Restricted

exit

