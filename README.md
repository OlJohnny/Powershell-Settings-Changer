# Powershell-Settings-Changer
Simple Powershell script to change many Windows Settings in bulk to my liking.

## Usage
* Open Powershell as Administrator
* Downlaod the script: <pre>Invoke-WebRequest -Uri https://raw.githubusercontent.com/OlJohnny/Powershell-Settings-Changer/master/powershell-settings-changer.ps1 -OutFile .\powershell-settings-changer.ps1</pre>
* <code>Set-ExecutionPolicy unrestricted -Scope Process</code> Update Execution Policy to allow execution of downloaded powershell scripts in current process (basically gets reset after closing current powershell window)
* <code>.\powershell-settings-changer.ps1</code> Execute the script (some error messages are expected due to updates to the registry structure)
* <code>rm .\powershell-settings-changer.ps1</code> Delete the local Script
