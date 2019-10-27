#Requires -RunAsAdministrator
Set-StrictMode -Version Latest

# github.com/OlJohnny | 2019


Write-Host -ForegroundColor Cyan "Welcome to Powershell-Settings-Changer."
Write-Host ""


Write-Host -ForegroundColor Cyan "Updating Search Settings..."
$key = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Search'
Set-ItemProperty $key BingSearchEnabled 0       # disable bing search results
Set-ItemProperty $key SearchboxTaskbarMode 0    # show the search symbol (not the bar) on taskbar


Write-Host -ForegroundColor Cyan "Updating: Disabling Cortana..."
$key = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search'
Set-ItemProperty $key AllowCortana 0            # disable cortana in 1803
Set-ItemProperty $key CortanaConsent 0          # turn off consent for cortana
$key = 'HKLM:\SOFTWARE\Microsoft\PolicyManager\current\device\Experience'
Set-ItemProperty $key AllowCortana 0            # disable cortana in 1607
$key = 'HKLM:\SOFTWARE\WOW6432Node\Policies\Microsoft\Windows\Windows Search'
Set-ItemProperty $key AllowCortana 0            # disable cortana


Write-Host ""
Write-Host -ForegroundColor Cyan "Restarting Explorer Process, for changes to take effect..."
Write-Host -ForegroundColor Gray "For a precise changelog, view the commented code"
Stop-Process -processname explorer


Write-Host ""
Write-Host -ForegroundColor Cyan "Exiting..."
