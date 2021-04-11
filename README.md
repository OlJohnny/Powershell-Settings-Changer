# Powershell-Settings-Changer
Simple Powershell script to change Windows Settings in bulk.

## Usage
* Open Powershell as Administrator
* Downlaod the script: <pre>Invoke-WebRequest -Uri https://raw.githubusercontent.com/OlJohnny/Powershell-Settings-Changer/master/powershell-settings-changer.ps1 -OutFile .\powershell-settings-changer.ps1</pre>
* <code>Set-ExecutionPolicy unrestricted</code> Update Execution Policy to allow execution of downloaded powershell scripts
* <code>.\powershell-settings-changer.ps1</code> Execute the script (some error messages are expected due to updates to the registry structure)
* <code>Set-ExecutionPolicy Default</code> Reset Execution Policy to the Default
* <code>rm .\powershell-settings-changer.ps1</code> Delete the local Script
