Write-Host "~~~~~~~~~~~~~~~~~~~~~~~~ Windows 2016 Workstation ~~~~~~~~~~~~~~~~~~~~~~~~"
$HostName = Read-Host -Prompt "Choose hostname:"
$FullName = Read-Host -Prompt "Your full name:"

### Change HostName
Rename-Computer -NewName $HostName -Force

### Disable Server Manager at logon
$regPath = "HKCU:\Software\Microsoft\ServerManager"
Set-ItemProperty -Path $regPath DoNotOpenServerManagerAtLogon -Type DWORD -Force -Value 1

### Memory Compression
Enable-MMAgent -MemoryCompression

### Disable CAD
$regPath = "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Winlogon"
Set-ItemProperty -Path $regPath -Name "DisableCAD" -Value 1 -Type DWORD
$regPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
Set-ItemProperty -Path $regPath -Name "DisableCAD" -Value 1 -Type DWORD

### Disbale Shutdown Tracker
$regPath = "HKLM:\Software\Policies\Microsoft\Windows NT\Reliability"
New-Item -Path $regPath -Force
New-ItemProperty -Path $regPath -Name "ShutdownReasonOn" -Value 0 -PropertyType DWORD

### Disable IE ESC
$regPathAdmins = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A7-37EF-4b3f-8CFC-4F3A74704073}"
Set-ItemProperty -Path $regPathAdmins -Name "IsInstalled" -Value 0 -Type DWORD 
$regPathUsers = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A8-37EF-4b3f-8CFC-4F3A74704073}"
Set-ItemProperty -Path $regPathUsers -Name "IsInstalled" -Value 0 -Type DWORD 

### Performace 
$regPathPriority = "HKLM:\SYSTEM\CurrentControlSet\Control\PriorityControl"
Set-ItemProperty -Path $regPathPriority -Name "Win32PrioritySeparation" -Value 38 -Type DWORD

### Prevent Taskbar Gruping
$regPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer"
New-Item -Path $regPath -Force
Set-ItemProperty -Path $regPath -Name "NoTaskGrouping" -Value "1" -Type DWORD

### Change Owner Info
$regPath = "HKLM:\Software\Microsoft\Windows NT\CurrentVersion"
Set-ItemProperty -Path $regPath -Name "RegisteredOwner" -Value "$FullName" -Type String 

### Enable Wireless Networking
Enable-WindowsOptionalFeature -Online -FeatureName "WirelessNetworking" -NoRestart
# Install-WindowsFeature -Name Wireless-Networking

### Enable Audio
Set-Service "Audiosrv" -StartupType Automatic
Start-Service "Audiosrv"

### Install Adobe Flash
### dism /online /add-package /packagepath:"C:\Windows\Servicing\Packages\Adobe-Flash-For-Windows-Package~31bf3856ad364e35~amd64~~10.0.14393.0.mum" /NoRestart

### VisualStyles
$regPath1 = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects"
Set-ItemProperty -Path $regPath1 -Name "VisualFXSetting" -Value 1 -Type DWORD
$regPath2 = "HKCU:\Control Panel\Desktop"
Set-ItemProperty -Path $regPath2 -Name "UserPreferencesMask" -Value ([byte[]](0x9E,0x3E,0x07,0x80,0x12,0x00,0x00,0x00)) -Type BINARY
$regPath3 = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
Set-ItemProperty -Path $regPath3 -Name "IconsOnly" -Value 0 -Type DWORD
Set-ItemProperty -Path $regPath3 -Name "TaskbarAnimations" -Value 1 -Type DWORD
Stop-Process -ProcessName explorer

### install extra features
Install-WindowsFeature -Name XPS-Viewer
Install-WindowsFeature -Name Telnet-Client
Install-WindowsFeature -Name Windows-TIFF-IFilter
Install-WindowsFeature -Name Hyper-V
Install-WindowsFeature -Name RSAT-Hyper-V-Tools
Install-WindowsFeature -Name Hyper-V-Tools
Install-WindowsFeature -Name Hyper-V-PowerShell

Read-Host -Prompt "Press 'Enter' to redirect your browser to OnDrive download page"
Start-Process -FilePath "https://onedrive.live.com/about/en-us/download/"
### Enable LUA (Limited User Account) 
$regPath3 = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
Set-ItemProperty -Path $regPath3 -Name EnableLUA -Type DWORD -Value 0 -Force

Restart-Computer