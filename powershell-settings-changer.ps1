#Requires -RunAsAdministrator
Set-StrictMode -Version Latest

# github.com/OlJohnny | 2019


Write-Host -ForegroundColor Cyan "Welcome to Powershell-Settings-Changer."
Write-Host ""

Write-Host -ForegroundColor Cyan "Updating: Show hidden Files and all File Extensions..."
$key = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
Set-ItemProperty $key Hidden 1                # show hidden filex
Set-ItemProperty $key HideFileExt 0           # show all filex extensions
Set-ItemProperty $key ShowSuperHidden 0       # do not show windows system files

Write-Host -ForegroundColor Cyan "Updating: Hide Frequently and Recently Used Files..."
$key = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer'
Set-ItemProperty $key ShowFrequent 0          # do not show frequently used files
Set-ItemProperty $key ShowRecent 0            # do not show recently used files

Write-Host -ForegroundColor Cyan "Updating: Miscellanious Explorer Settings..."
$key = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
Set-ItemProperty $key LaunchTo 1              # Launch to 'This PC'
Set-ItemProperty $key HideDrivesWithNoMedia 0 # do not hide drives, which are not present
Set-ItemProperty $key SeparateProcess 1       # start each explorer.exe in its own process

Write-Host -ForegroundColor Cyan "Updating: Applying Dark Mode..."
$key = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize'
Set-ItemProperty $key AppsUseLightTheme 0     # Apply Dark Theme


Write-Host ""
Write-Host -ForegroundColor Cyan "Restarting Explorer Process, for changes to take effect..."
Stop-Process -processname explorer


Write-Host ""
Write-Host -ForegroundColor Cyan "Exiting..."