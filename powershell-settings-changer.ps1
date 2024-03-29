#Requires -RunAsAdministrator
Set-StrictMode -Version Latest

# github.com/OlJohnny | 2024


Write-Host -ForegroundColor Cyan 'Welcome to Powershell-Settings-Changer'
Write-Host ''


# backup to-be-modified registry parts
Write-Host -ForegroundColor Gray 'Backup to be modified registry parts into current folder'
reg export HKCU "reg_HKCU - $(Get-Date -Format yyyy.MM.dd-HH.mm.ss).reg"
reg export 'HKLM:\SYSTEM\CurrentcontrolSet\Control\SecurityProviders\SCHANNEL' "reg_HKLM-SCHANNEL - $(Get-Date -Format yyyy.MM.dd-HH.mm.ss).reg"
reg export 'HKLM:\SOFTWARE' "reg_HKLM-SOFTWARE - $(Get-Date -Format yyyy.MM.dd-HH.mm.ss).reg"


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
	New-ItemProperty -Path $key_path -PropertyType 'DWord' -Name $item_name -Value $item_value
}


# change registry entries
Write-Host ''
Write-Host -ForegroundColor Cyan 'Updating Basic Explorer Settings...'
$key = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer'
write_registry $key 'ShowFrequent' 0            	# do not show frequently used files
write_registry $key 'ShowRecent' 0              	# do not show recently used files
$key = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
write_registry $key 'Hidden' 1                  	# show hidden files
write_registry $key 'HideFileExt' 0             	# show all file extensions
write_registry $key 'ShowSuperHidden' 0         	# do not show windows system files
write_registry $key 'LaunchTo' 1                	# launch to 'This PC'
write_registry $key 'HideDrivesWithNoMedia' 0   	# do not hide drives, which are not present
write_registry $key 'SeparateProcess' 1         	# start each explorer.exe in its own process
write_registry $key 'DontUsePowerShellOnWinX' 0 	# show powershell instead of cmd on win+x or right-click on windows logo
write_registry 'HKLM:\System\CurrentControlSet\Control\FileSystem' 'LongPathsEnabled' 1     # enable long paths
$key = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\System'
write_registry $key 'AllowClipboardHistory' 0		# disable clipboard history
write_registry $key 'EnableActivityFeed' 0			# disable activity feed
write_registry $key 'AllowCrossDeviceClipboard' 0	# disable cloud syncing of clipbaord
write_registry 'HKCU:\Software\Classes\Local Settings\Software\Microsoft\Windows\Shell\Bags\AllFolders\Shell' 'FolderType' 'NotSpecified'	# reset folder view settings, fixes long indexing times; https://x.com/timonsku/status/1764306103720989115?s=20

Write-Host ''
Write-Host -ForegroundColor Cyan 'Updating Taskbar Settings...'
write_registry 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People' 'PeopleBand' 0	# dont show "poeple bar" on taskbar
write_registry 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer' 'HideSCAMeetNow' 1		# dont show "meet now" on taskbar
write_registry 'HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer' 'DisableSearchBoxSuggestions' 1         # no bing in search
write_registry 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' 'TaskbarAl' 0            # move taskbar icons to left

Write-Host ''
Write-Host -ForegroundColor Cyan 'Applying Dark Mode...'
write_registry 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize' 'AppsUseLightTheme' 0   # apply dark theme

Write-Host ''
Write-Host -ForegroundColor Cyan 'Disabling Accessibility Features...'
write_registry 'HKCU:\Control Panel\Accessibility\On' 'On' 0					# disable general accessibility features
write_registry 'HKCU:\Control Panel\Accessibility\Blind Access' 'On' 0			# disable blind access
write_registry 'HKCU:\Control Panel\Accessibility\Keyboard Preference' 'On' 0	# disable keyboard preference
write_registry 'HKCU:\Control Panel\Accessibility\AudioDescription' 'On' 0		# disable audio description
write_registry 'HKCU:\Control Panel\Accessibility\ShowSounds' 'On' 0			# disable sound visualization
write_registry 'HKCU:\Control Panel\Accessibility\StickyKeys' 'On' 0			# disable sticky keys - part 1
write_registry 'HKCU:\Control Panel\Accessibility\ToggleKeys' 'On' 0			# disable sticky keys - part 2
$key = 'HKEY_CURRENT_USER\Keyboard Layout\Toggle'								# disable hotkeys for changing keyboard layout (all except win + space)
write_registry $key 'Layout Hotkey' 3
write_registry $key 'Language Hotkey' 3
write_registry $key 'Hotkey' 3

Write-Host ''
Write-Host -ForegroundColor Cyan 'Disabling SSLv2, SSLv3, TLSv1.0, TLSv1.1 and enabling TLSv1.2 server-side...'
write_registry 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\SSL 2.0\Server' 'DisabledByDefault' 1	# disable SSLv2   Server Side
write_registry 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\SSL 3.0\Server' 'DisabledByDefault' 1	# disable SSLv3   Server Side
write_registry 'HKLM:\SYSTEM\CurrentcontrolSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.0\Server' 'DisabledByDefault' 1	# disable TLSv1.0 Server Side - part 1
write_registry 'HKLM:\SYSTEM\CurrentcontrolSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.0\Server' 'Enabled' 0				# disable TLSv1.0 Server Side - part 2
write_registry 'HKLM:\SYSTEM\CurrentcontrolSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.1\Server' 'DisabledByDefault' 1	# disable TLSv1.1 Server Side - part 1
write_registry 'HKLM:\SYSTEM\CurrentcontrolSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.1\Server' 'Enabled' 0				# disable TLSv1.1 Server Side - part 2
write_registry 'HKLM:\SYSTEM\CurrentcontrolSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Server' 'DisabledByDefault' 0	# enable  TLSv1.2 Server Side - part 1
write_registry 'HKLM:\SYSTEM\CurrentcontrolSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Server' 'Enabled' 1				# enable  TLSv1.2 Server Side - part 2

Write-Host ''
Write-Host -ForegroundColor Cyan 'Disabling RC4 ciphers...'
# workaround for '/' in key name
$custom_key = (get-item HKLM:\).OpenSubKey('SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers', $true)
$custom_key.CreateSubKey('RC4 40/128')
$custom_key.CreateSubKey('RC4 56/128')
$custom_key.CreateSubKey('RC4 128/128')
$custom_key.Close()
# set values for created keys
write_registry 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC4 128/128' 'Enabled' 0		# disable RC4 128bit
write_registry 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC4 56/128' 'Enabled' 0		# disable RC4 56bit
write_registry 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC4 40/128' 'Enabled' 0		# disable RC4 40bit


# winget install microsoft first party codecs
$winget_first_party_codecs_install=''
while ($winget_first_party_codecs_install -ne 'y' -and $winget_first_party_codecs_install -ne 'n') {
	Write-Host -NoNewline -ForegroundColor Cyan 'Do you want to want to install Microsoft First Party Programms? (y|n): '
	$winget_first_party_codecs_install = Read-Host
}
if ($winget_first_party_codecs_install -eq 'y') {
	Write-Host -ForegroundColor Green 'Installing Microsoft First Party Codecs...'
	winget install 9N4WGH0Z6VHQ --source msstore --accept-package-agreements --accept-source-agreements		# install from microsoft-store: free HEVC codec (for device manufacturers)
	winget install 9PMMSR1CGPWG --source msstore --accept-package-agreements --accept-source-agreements		# install from microsoft-store: free HEIC & HEIF codec (for device manufacturers)
	winget install 9MVZQVXJBQ9V --source msstore --accept-package-agreements --accept-source-agreements		# install from microsoft-store: AV1 codec
	winget install 9N95Q1ZZPMH4 --source msstore --accept-package-agreements --accept-source-agreements		# install from microsoft-store: MPEG-2 codec
	winget install 9PG2DK419DRG --source msstore --accept-package-agreements --accept-source-agreements 	# install from microsoft-store: webp codec
	winget install 9N4D0MSMP0PT --source msstore --accept-package-agreements --accept-source-agreements 	# install from microsoft-store: VP9 codec
}


# winget install microsoft first party programs
$winget_first_party_programs_install=''
while ($winget_first_party_programs_install -ne 'y' -and $winget_first_party_programs_install -ne 'n') {
	Write-Host -NoNewline -ForegroundColor Cyan 'Do you want to want to install Microsoft First Party Programs? (y|n): '
	$winget_first_party_programs_install = Read-Host
}
if ($winget_first_party_programs_install -eq 'y') {
	Write-Host -ForegroundColor Green 'Installing Microsoft First Party Programs...'
	winget install 9N0DX20HK701 --source msstore --accept-package-agreements --accept-source-agreements		# install from microsoft-store: windows terminal
	winget install 9MZ1SNWT0N5D --source msstore --accept-package-agreements --accept-source-agreements		# install from microsoft-store: PowerShell 7
	Get-Service -Name ssh-agent | Set-Service -StartupType Automatic										# automatically start ssh agent on bootup
	Start-Service ssh-agent
}


# winget install microsoft first party programs
$winget_third_party_programs_install=''
while ($winget_third_party_programs_install -ne 'y' -and $winget_third_party_programs_install -ne 'n') {
	Write-Host -NoNewline -ForegroundColor Cyan 'Do you want to want to install some Third Party Programs (EarTrumpet)? (y|n): '
	$winget_third_party_programs_install = Read-Host
}
if ($winget_third_party_programs_install -eq 'y') {
	Write-Host -ForegroundColor Green 'Installing Third Party Programs...'
	winget install 9NBLGGH516XP --source msstore --accept-package-agreements --accept-source-agreements		# install from microsoft-store: eartrumpet
}


# enable wsl
$wsl_install=''
while ($wsl_install -ne 'y' -and $wsl_install -ne 'n') {
	Write-Host -NoNewline -ForegroundColor Cyan 'Do you want to want to install Windows Subsystem for Linux (WSL2)? (y|n): '
	$wsl_install = Read-Host
}
if ($wsl_install -eq 'y') {
	Write-Host -ForegroundColor Green 'Installing WSL...'
	dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart	# for wsl2 enable virtualization features
	wsl --install
}


# add scheduled task to periodically disable self reboots
Write-Host ''
$scheduletaskname = 'No Self Reboot'
$scheduledtaskexists = Get-ScheduledTask | Where-Object {$_.TaskName -like $scheduletaskname }
if ($scheduledtaskexists) {
	Write-Host -ForegroundColor Green ''No Self Reboot' Scheduled Task detected, not registering again'
} else {
	$scheduletask=''
	while ($scheduletask -ne 'y' -and $scheduletask -ne 'n') {
		Write-Host -NoNewline -ForegroundColor Cyan 'Do you want to add a scheduled task to keep Windows from Rebooting on its own? (y|n): '
		$scheduletask = Read-Host
	}

	if ($scheduletask -eq 'y') {
		Write-Host -ForegroundColor Green 'Adding Scheduled Task...'

		$scheduleaction = New-ScheduledTaskAction -Execute schtasks -Argument '/change /tn \Microsoft\Windows\UpdateOrchestrator\Reboot /DISABLE'  # disable reboot task in task-scheduler
		$scheduleprincipal = New-ScheduledTaskPrincipal -UserID 'NT AUTHORITY\SYSTEM' -LogonType ServiceAccount -RunLevel Highest                  # execute with highest system privilges
		$scheduletsettings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -StartWhenAvailable -ExecutionTimeLimit (New-TimeSpan -Hours 1)

		$scheduletrigger1 = New-ScheduledTaskTrigger -At 4:30AM -Daily
		$scheduletrigger2 = New-ScheduledTaskTrigger -At 4:30AM -Once -RepetitionInterval (New-TimeSpan -Minutes 10) -RepetitionDuration (New-TimeSpan -Days 1)
		$scheduletrigger1.Repetition = $scheduletrigger2.Repetition                                              # hacky workaround so that the trigger reads: "At 4:30 every day - After triggered, repeat every 10 minutes for a duration of 1 day"

		$scheduletask = New-ScheduledTask -Action $scheduleaction -Principal $scheduleprincipal -Trigger $scheduletrigger1 -Settings $scheduletsettings
		$scheduledtask = Register-ScheduledTask -TaskName $scheduletaskname -InputObject $scheduletask -Force  # register task
	}
}


# restart the explorer task
Write-Host ''
Write-Host -ForegroundColor Cyan 'Restarting Explorer Process for changes to take effect...'
Stop-Process -processname explorer

Write-Host ''
Write-Host -ForegroundColor Gray 'For a precise changelog, view the commented code'
Write-Host ''
Write-Host -ForegroundColor Cyan 'Exiting...'
