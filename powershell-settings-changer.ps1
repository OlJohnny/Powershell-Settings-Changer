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
		New-Item -Path $key_path
	}
	# Set Key Property
	New-ItemProperty -Path $key_path -PropertyType "DWord" -Name $item_name -Value $item_value
}



# change registry entries
Write-Host ""
Write-Host -ForegroundColor Cyan "Updating Basic Explorer Settings..."
$key = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer'
write_registry $key "ShowFrequent" 0            # do not show frequently used files
write_registry $key "ShowRecent" 0              # do not show recently used files


Write-Host ""
Write-Host -ForegroundColor Cyan "Updating Advanced Explorer Settings..."
$key = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
write_registry $key "Hidden" 1                  # show hidden files
write_registry $key "HideFileExt" 0             # show all file extensions
write_registry $key "ShowSuperHidden" 0         # do not show windows system files
write_registry $key "LaunchTo" 1                # launch to 'This PC'
write_registry $key "HideDrivesWithNoMedia" 0   # do not hide drives, which are not present
write_registry $key "SeparateProcess" 1         # start each explorer.exe in its own process
write_registry $key "DontUsePowerShellOnWinX" 0 # show powershell instead of cmd on win+x or right-click on windows logo
write_registry 'HKLM:\System\CurrentControlSet\Control\FileSystem' 'LongPathsEnabled' 1 # enable long paths


Write-Host ""
Write-Host -ForegroundColor Cyan "Updating Advanced People Explorer Settings..."
write_registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People" PeopleBand 0              # hide 'contacts' region at end of taskbar


Write-Host ""
Write-Host -ForegroundColor Cyan "Updating Search Settings..."
$key = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Search'
write_registry $key "BingSearchEnabled" 0       # disable bing search results
write_registry $key "SearchboxTaskbarMode" 0    # show the search symbol (not the bar) on taskbar


Write-Host ""
Write-Host -ForegroundColor Cyan "Applying Dark Mode..."
write_registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" "AppsUseLightTheme" 0       # apply dark theme


Write-Host ""
Write-Host -ForegroundColor Cyan "Disabling Cortana..."
$key = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search'
write_registry $key "AllowCortana" 0            # disable cortana in 1803
write_registry $key "CortanaConsent" 0          # turn off consent for cortana
write_registry "HKLM:\SOFTWARE\Microsoft\PolicyManager\current\device\Experience" "AllowCortana" 0            # disable cortana in 1607
write_registry "HKLM:\SOFTWARE\WOW6432Node\Policies\Microsoft\Windows\Windows Search" "AllowCortana" 0        # disable cortana


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
write_registry "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC4 128/128" Enabled 0				# disable RC4 128bit
write_registry "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC4 56/128" Enabled 0					# disable RC4 56bit
write_registry "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC4 40/128" Enabled 0					# disable RC4 40bit


# winget install microsoft first party codecs
$winget_first_party_codecs_install=""
while ($winget_first_party_codecs_install -ne "y" -and $winget_first_party_codecs_install -ne "n") {
	Write-Host -NoNewline -ForegroundColor Cyan "Do you want to want to install Microsoft First Party Programms? (y|n): "
	$winget_first_party_codecs_install = Read-Host
}
if ($winget_first_party_codecs_install -eq "y") {
	Write-Host -ForegroundColor Green "Installing Microsoft First Party Codecs..."
	winget install 9N4WGH0Z6VHQ --source msstore --accept-package-agreements --accept-source-agreements		# install from microsoft-store: free HEVC codec (for device manufacturers)
	winget install 9PMMSR1CGPWG --source msstore --accept-package-agreements --accept-source-agreements		# install from microsoft-store: free HEIC & HEIF codec (for device manufacturers)
	winget install 9MVZQVXJBQ9V --source msstore --accept-package-agreements --accept-source-agreements		# install from microsoft-store: AV1 codec
	winget install 9N95Q1ZZPMH4 --source msstore --accept-package-agreements --accept-source-agreements		# install from microsoft-store: MPEG-2 codec
	winget install 9PG2DK419DRG --source msstore --accept-package-agreements --accept-source-agreements 	# install from microsoft-store: webp codec
	winget install 9N4D0MSMP0PT --source msstore --accept-package-agreements --accept-source-agreements 	# install from microsoft-store: VP9 codec

} elseif ($winget_first_party_codecs_install -eq "n") {
	Write-Host -ForegroundColor Red "Not Installing Microsoft First Party Codecs"
}


# winget install microsoft first party programs
$winget_first_party_programs_install=""
while ($winget_first_party_programs_install -ne "y" -and $winget_first_party_programs_install -ne "n") {
	Write-Host -NoNewline -ForegroundColor Cyan "Do you want to want to install Microsoft First Party Programs? (y|n): "
	$winget_first_party_programs_install = Read-Host
}
if ($winget_first_party_programs_install -eq "y") {
	Write-Host -ForegroundColor Green "Installing Microsoft First Party Programs..."
	winget install 9N0DX20HK701 --source msstore --accept-package-agreements --accept-source-agreements		# install from microsoft-store: windows terminal
	winget install Microsoft.PowerToys --accept-package-agreements --accept-source-agreements				# install from winget: microsoft powertoys
	winget install Microsoft.VisualStudioCode --accept-package-agreements --accept-source-agreements		# install from winget: microsoft visual studio code, TODO: manual setup
	winget install Microsoft.OpenSSH --accept-package-agreements --accept-source-agreements             	# install from winget: OpenSSH
} elseif ($winget_first_party_programs_install -eq "n") {
	Write-Host -ForegroundColor Red "Not Installing Microsoft First Party Programs"
}


# winget install third party programs
winget install 9NBLGGH516XP --source msstore --accept-package-agreements --accept-source-agreements		# install from microsoft-store: eartrumpet
# install chrome
# install thunderbird
# install notepad++
# install keepass



# Windows 11 Tweaks
$win11_tweaks=""
while ($win11_tweaks -ne "y" -and $win11_tweaks -ne "n") {
	Write-Host -NoNewline -ForegroundColor Cyan "Do you want to want to use Registry Tweaks for Windows 11? (y|n): "
	$win11_tweaks = Read-Host
}
if ($win11_tweaks -eq "y") {
	Write-Host -ForegroundColor Green "Applying Registry Tweaks for Windows 11..."
    HKEY_CURRENT_USER\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32     # old context menu: double click on "Default"?
    HKEY_CURRENT_USER\SOFTWARE\Policies\Microsoft\Windows\Explorer DisableSearchBoxSuggestions 1       # no bing in search
    HKEY_CURRENT_USER\Software\Microsoft\ Windows\CurrentVersion\Explorer\Advanced TaskbarAl 0         # move taskbar icons to left
    # dont show contacts
    # dont show "jetzt besprechen"

} elseif ($win11_tweaks -eq "n") {
	Write-Host -ForegroundColor Red "Not Applying Registry Tweaks for Windows 11"
}




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
