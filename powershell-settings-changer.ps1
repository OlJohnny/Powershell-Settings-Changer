#Requires -RunAsAdministrator
Set-StrictMode -Version Latest

# github.com/OlJohnny | 2020


Write-Host -ForegroundColor Cyan "Welcome to Powershell-Settings-Changer."
Write-Host ""


# backup to-be-modified registry parts
reg export HKCU "reg_HKCU - $(Get-Date -Format yyyy.MM.dd-HH.mm.ss).reg"
reg export "HKLM:\SYSTEM\CurrentcontrolSet\Control\SecurityProviders\SCHANNEL" "reg_HKLM-SCHANNEL - $(Get-Date -Format yyyy.MM.dd-HH.mm.ss).reg"
reg export "HKLM:\SOFTWARE" "reg_HKLM-SOFTWARE - $(Get-Date -Format yyyy.MM.dd-HH.mm.ss).reg"



# write a path to the registry and create parent-path, if not present
function write_registry($key_path, $item_name, $item_value){
	# Test if the key path already exists
	if (Test-Path $key_path) {
		Write-Verbose 'Key already exists' -Verbose
	} else {
		# If not create new key
		New-Item -Path $key_path -Force
	}
	# Set Key Property
	New-ItemProperty -Path $key_path -PropertyType "DWord" -Name $item_name -Value $item_value
}



# change registry entries
Write-Host ""
Write-Host -ForegroundColor Cyan "Updating Basic Explorer Settings..."
$key = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer'
Set-ItemProperty $key ShowFrequent 0            # do not show frequently used files
Set-ItemProperty $key ShowRecent 0              # do not show recently used files


Write-Host ""
Write-Host -ForegroundColor Cyan "Updating Advanced Explorer Settings..."
$key = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
Set-ItemProperty $key Hidden 1                  # show hidden files
Set-ItemProperty $key HideFileExt 0             # show all file extensions
Set-ItemProperty $key ShowSuperHidden 0         # do not show windows system files
Set-ItemProperty $key LaunchTo 1                # launch to 'This PC'
Set-ItemProperty $key HideDrivesWithNoMedia 0   # do not hide drives, which are not present
Set-ItemProperty $key SeparateProcess 1         # start each explorer.exe in its own process
Set-ItemProperty $key DontUsePowerShellOnWinX 0 # show powershell instead of cmd on win+x or right-click on windows logo


Write-Host ""
Write-Host -ForegroundColor Cyan "Updating Advanced People Explorer Settings..."
$key = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People'
Set-ItemProperty $key PeopleBand 0              # hide 'contacts' region at end of taskbar


Write-Host ""
Write-Host -ForegroundColor Cyan "Updating Search Settings..."
$key = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Search'
Set-ItemProperty $key BingSearchEnabled 0       # disable bing search results
Set-ItemProperty $key SearchboxTaskbarMode 0    # show the search symbol (not the bar) on taskbar


Write-Host ""
Write-Host -ForegroundColor Cyan "Applying Dark Mode..."
$key = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize'
Set-ItemProperty $key AppsUseLightTheme 0       # apply dark theme


Write-Host ""
Write-Host -ForegroundColor Cyan "Disabling Cortana..."
$key = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search'
Set-ItemProperty $key AllowCortana 0            # disable cortana in 1803
Set-ItemProperty $key CortanaConsent 0          # turn off consent for cortana
$key = 'HKLM:\SOFTWARE\Microsoft\PolicyManager\current\device\Experience'
Set-ItemProperty $key AllowCortana 0            # disable cortana in 1607
$key = 'HKLM:\SOFTWARE\WOW6432Node\Policies\Microsoft\Windows\Windows Search'
Set-ItemProperty $key AllowCortana 0            # disable cortana


Write-Host ""
Write-Host -ForegroundColor Cyan "Disabling Accessibility Features..."
write_registry "HKCU:\Control Panel\Accessibility\On" "On" 0					# disable general accessibility features
write_registry "HKCU:\Control Panel\Accessibility\Blind Access" "On" 0			# disable blind access
write_registry "HKCU:\Control Panel\Accessibility\Keyboard Preference" "On" 0	# disable keyboard preference
write_registry "HKCU:\Control Panel\Accessibility\AudioDescription" "On" 0		# disable audio description
write_registry "HKCU:\Control Panel\Accessibility\ShowSounds" "On" 0			# disable sound visualization
write_registry "HKCU:\Control Panel\Accessibility\StickyKeys" "On" 0			# disable sticky keys - part 1
write_registry "HKCU:\Control Panel\Accessibility\ToggleKeys" "On" 0			# disable sticky keys - part 2


Write-Host ""
Write-Host -ForegroundColor Cyan "Disabling SSLv2, SSLv3, TLSv1.0, TLSv1.1 and enabling TLSv1.2 server-side..."
write_registry "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\SSL 2.0\Server" "DisabledByDefault" 1	# disable SSLv2   Server Side
write_registry "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\SSL 3.0\Server" "DisabledByDefault" 1	# disable SSLv3   Server Side
write_registry "HKLM:\SYSTEM\CurrentcontrolSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.0\Server" "DisabledByDefault" 1	# disable TLSv1.0 Server Side - part 1
write_registry "HKLM:\SYSTEM\CurrentcontrolSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.0\Server" "Enabled" 0				# disable TLSv1.0 Server Side - part 2
write_registry "HKLM:\SYSTEM\CurrentcontrolSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.1\Server" "DisabledByDefault" 1	# disable TLSv1.1 Server Side - part 1
write_registry "HKLM:\SYSTEM\CurrentcontrolSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.1\Server" "Enabled" 0				# disable TLSv1.1 Server Side - part 2
write_registry "HKLM:\SYSTEM\CurrentcontrolSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Server" "DisabledByDefault" 0	# enable  TLSv1.2 Server Side - part 1
write_registry "HKLM:\SYSTEM\CurrentcontrolSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Server" "Enabled" 1				# enable  TLSv1.2 Server Side - part 2


Write-Host ""
Write-Host -ForegroundColor Cyan "Disabling RC4 ciphers..."
# workaround for '/' in key name
$custom_key = (get-item HKLM:\).OpenSubKey("SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers", $true)
$custom_key.CreateSubKey('RC4 40/128')
$custom_key.CreateSubKey('RC4 56/128')
$custom_key.CreateSubKey('RC4 128/128')
$custom_key.Close()
# set values for created keys
$key = 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC4 128/128'
Set-ItemProperty $key Enabled 0					# disable RC4 128bit
$key = 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC4 56/128'
Set-ItemProperty $key Enabled 0					# disable RC4 56bit
$key = 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC4 40/128'
Set-ItemProperty $key Enabled 0					# disable RC4 40bit



# add scheduled task to periodically disable self reboots
Write-Host ""
$scheduletaskname = "No Self Reboot"
$scheduledtaskexists = Get-ScheduledTask | Where-Object {$_.TaskName -like $scheduletaskname }
if ($scheduledtaskexists) {
	Write-Host -ForegroundColor Green "'No Self Reboot' Scheduled Task detected, not registering again"
} else {
	$scheduletask=""
	while ($scheduletask -ne "y" -and $scheduletask -ne "n") {
		Write-Host -NoNewline -ForegroundColor Cyan "Do you want to add a scheduled task to keep Windows from Rebooting on its own? (y|n): "
		$scheduletask = Read-Host
	}

	if ($scheduletask -eq "y") {
		Write-Host -ForegroundColor Green "Adding Scheduled Task..."

		$scheduleaction = New-ScheduledTaskAction -Execute schtasks -Argument "/change /tn \Microsoft\Windows\UpdateOrchestrator\Reboot /DISABLE"  # disable reboot task in task-scheduler
		$scheduleprincipal = New-ScheduledTaskPrincipal -UserID "NT AUTHORITY\SYSTEM" -LogonType ServiceAccount -RunLevel Highest                  # execute with highest system privilges
		$scheduletsettings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -StartWhenAvailable -ExecutionTimeLimit (New-TimeSpan -Hours 1)

		$scheduletrigger1 = New-ScheduledTaskTrigger -At 4:30AM -Daily
		$scheduletrigger2 = New-ScheduledTaskTrigger -At 4:30AM -Once -RepetitionInterval (New-TimeSpan -Minutes 10) -RepetitionDuration (New-TimeSpan -Days 1)
		$scheduletrigger1.Repetition = $scheduletrigger2.Repetition                                              # hacky workaround so that the trigger reads: "At 4:30 every day - After triggered, repeat every 10 minutes for a duration of 1 day"

		$scheduletask = New-ScheduledTask -Action $scheduleaction -Principal $scheduleprincipal -Trigger $scheduletrigger1 -Settings $scheduletsettings
		$scheduledtask = Register-ScheduledTask -TaskName $scheduletaskname -InputObject $scheduletask -Force  # register task
	} elseif ($scheduletask -eq "n") {
		Write-Host -ForegroundColor Red "Not Adding Scheduled Task"
	}
}


# restart the explorer task
Write-Host ""
Write-Host -ForegroundColor Cyan "Restarting Explorer Process, for changes to take effect..."
Stop-Process -processname explorer

Write-Host ""
Write-Host -ForegroundColor Gray "For a precise changelog, view the commented code"
Write-Host ""
Write-Host -ForegroundColor Cyan "Exiting..."
