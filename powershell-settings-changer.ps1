#Requires -RunAsAdministrator
Set-StrictMode -Version Latest

# github.com/OlJohnny | 2019


Write-Host -ForegroundColor Cyan "Welcome to Powershell-Settings-Changer."
Write-Host ""


# change registry entries
Write-Host -ForegroundColor Cyan "Updating Basic Explorer Settings..."
$key = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer'
Set-ItemProperty $key ShowFrequent 0            # do not show frequently used files
Set-ItemProperty $key ShowRecent 0              # do not show recently used files


Write-Host -ForegroundColor Cyan "Updating Advanced Explorer Settings..."
$key = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
Set-ItemProperty $key Hidden 1                  # show hidden filex
Set-ItemProperty $key HideFileExt 0             # show all filex extensions
Set-ItemProperty $key ShowSuperHidden 0         # do not show windows system files
Set-ItemProperty $key LaunchTo 1                # Launch to 'This PC'
Set-ItemProperty $key HideDrivesWithNoMedia 0   # do not hide drives, which are not present
Set-ItemProperty $key SeparateProcess 1         # start each explorer.exe in its own process
Set-ItemProperty $key DontUsePowerShellOnWinX 0 # show powershell instead of cmd on win+x or right-click on windows logo


Write-Host -ForegroundColor Cyan "Updating Advanced People Explorer Settings..."
$key = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People'
Set-ItemProperty $key PeopleBand 0              # hide 'contacts' region at end of taskbar


Write-Host -ForegroundColor Cyan "Updating Search Settings..."
$key = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Search'
Set-ItemProperty $key BingSearchEnabled 0       # disable bing search results
Set-ItemProperty $key SearchboxTaskbarMode 0    # show the search symbol (not the bar) on taskbar


Write-Host -ForegroundColor Cyan "Updating: Applying Dark Mode..."
$key = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize'
Set-ItemProperty $key AppsUseLightTheme 0       # Apply Dark Theme


Write-Host -ForegroundColor Cyan "Updating: Disabling Cortana..."
$key = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search'
Set-ItemProperty $key AllowCortana 0            # disable cortana in 1803
Set-ItemProperty $key CortanaConsent 0          # turn off consent for cortana
$key = 'HKLM:\SOFTWARE\Microsoft\PolicyManager\current\device\Experience'
Set-ItemProperty $key AllowCortana 0            # disable cortana in 1607
$key = 'HKLM:\SOFTWARE\WOW6432Node\Policies\Microsoft\Windows\Windows Search'
Set-ItemProperty $key AllowCortana 0            # disable cortana


Write-Host -ForegroundColor Cyan "Updating: Disabling Accessibility Features..."
$key = 'HKCU:\Control Panel\Accessibility\On'
Set-ItemProperty $key On 0						# disable general accessibility features
$key = 'HKCU:\Control Panel\Accessibility\Blind Access'
Set-ItemProperty $key On 0						# disable blind access
$key = 'HKCU:\Control Panel\Accessibility\Keyboard Preference'
Set-ItemProperty $key On 0						# disable keyboard preference
$key = 'HKCU:\Control Panel\Accessibility\AudioDescription'
Set-ItemProperty $key On 0						# disable audio description
$key = 'HKCU:\Control Panel\Accessibility\ShowSounds'
Set-ItemProperty $key On 0						# disable sound visualization
$key = 'HKCU:\Control Panel\Accessibility\StickyKeys'
Set-ItemProperty $key Flags 2					# disable sticky keys
$key = 'HKCU:\Control Panel\Accessibility\ToggleKeys'
Set-ItemProperty $key Flags 34					# disable sticky keys


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
Write-Host -ForegroundColor Gray "For a precise changelog, view the commented code"
Stop-Process -processname explorer

Write-Host ""
Write-Host -ForegroundColor Cyan "Exiting..."