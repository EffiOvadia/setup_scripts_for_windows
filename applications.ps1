winget install --accept-package-agreements --accept-source-agreements --exact --ID Microsoft.PowerShell
#@ ------- WSL -------------------------------------------
#/ Enable/Install Linux Subsystem feature
if ( $(Get-WindowsOptionalFeature -Online -FeatureName "Microsoft-Windows-Subsystem-Linux").state -ne "Enabled" ) 
  { Enable-WindowsOptionalFeature -NoRestart -Online -FeatureName "Microsoft-Windows-Subsystem-Linux" -All }
#/ set wsl default version to 2 & update wsl subsystem
wsl --set-default-version 2 ; wsl --update
#/ list all available distro in MS store
wsl --list --online
#/ Install selected Linux dist
$Distros = 
  @(
  [PSCustomObject]@{Name='Ubuntu'; ID='Ubuntu'}
  [PSCustomObject]@{Name='Debian GNU/Linux'; ID='Debian'}
  [PSCustomObject]@{Name='Kali Linux Rolling'; ID='kali-linux'}
  [PSCustomObject]@{Name='Ubuntu 22.04 LTS'; ID='Ubuntu-22.04'}
  [PSCustomObject]@{Name='Oracle Linux 9.1'; ID='OracleLinux_9_1'}
  )

foreach ($Dist in $Distros) { wsl --install --no-launch -d $Dist.ID }
#/ list all installed distros on local machine
wsl --list --verbose
#@ ----- SSH client & server -----------------------------
#/ Add windows capability: OpenSSH Client & Server 
If ( $(Get-WindowsCapability -Online -Name OpenSSH.Client~~~~0.0.1.0).state -ne "Installed" ) 
  { Add-WindowsCapability -Online -Name OpenSSH.Client~~~~0.0.1.0 }
If ( $(Get-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0).state -ne "Installed" )
  { Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0 }
#/ Set SSH server and SSH agent startup mode 
if ( $(Get-Service -Name SSHd) ) { Set-Service -Name SSHd -StartupType Automatic }
if ( $(Get-Service -Name SSH-Agent) ) { Set-Service -Name SSH-Agent -StartupType Disable }
#/ Set Default shell for SSH server to PowerShell 
if ( $(Test-Path "$env:ProgramFiles\PowerShell\7\pwsh.exe") ) 
  { $Shell = "$env:ProgramFiles\PowerShell\7\pwsh.exe" } else
  { $Shell = "$env:windir\System32\WindowsPowerShell\v1.0\powershell.exe" }
if ( $(Test-Path HKLM:\SOFTWARE\OpenSSH) ) 
  {
  $Path = "HKLM:\SOFTWARE\OpenSSH"
  New-ItemProperty $Path -Force -Name DefaultShell -Value "$Shell" -PropertyType String 
  New-ItemProperty $Path -Force -Name DefaultShellCommandOption -Value "/c" -PropertyType String
  }
#/ Adding firewall rule if needed 
If ( !((Get-NetFirewallRule).Name -like "*SSH*") ) 
  {
  $FW_RuleParameters_SSH =
    @{  
      Name        = "OpenSSH-Server-In-TCP"
      Group       = "OpenSSH Server"
      DisplayName = "OpenSSH Server (sshd)"
      Program     = "$ENV:windir\System32\OpenSSH\sshd.exe"
      Description = "Inbound rule for OpenSSH SSH Server (sshd)"
      Profile     = "Domain, Private, Public"
      Direction   = "Inbound"
      Protocol    = "TCP"
      Action      = "Allow"
      LocalPort   = "22"
      Enable      = "True"
    }
    New-NetFirewallRule @FW_RuleParameters_SSH
  }
#/ Configure SSH server to accept public key auth 
$FileContent = 
  (
    "PubkeyAuthentication   yes",
    "AuthorizedKeysFile     .ssh/authorized_keys",
    "PasswordAuthentication No",
    "Subsystem              sftp sftp-server.exe",
    "Subsystem              powershell %SystemRoot%\system32\WindowsPowerShell\v1.0\powershell.exe -sshs -NoLogo -NoProfile",
    "Match                  Group administrators",
    "AuthorizedKeysFile     __PROGRAMDATA__/ssh/administrators_authorized_keys"
  )
Set-Content "$env:ProgramData\ssh\sshd_config" -Value $FileContent
$ACL = Get-Acl "$env:ProgramData\ssh\sshd_config"
$ACL.SetSecurityDescriptorSddlForm('O:SYG:SYD:PAI(A;;FA;;;SY)(A;;FA;;;BA)')
$ACL | Set-Acl
#/ Add Public keys to OpenSSH server for all local administrators 
$FileContent = 
  (
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILNCmaqfNc79iOZbqScO8uLDWBhHRMHUAEbUq3/PR9zj b3:2e:97:e8:bb:f8:1a:20:a7:93:c7:cf:09:f2:a6:88",
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINLsYdvM7AR00BBSr+xKW90blD7wX8WRFXxr2Y6L/uHG dd:f2:f2:33:65:92:40:5b:0f:7b:07:0a:47:f4:da:c8"
  )
Set-Content "$env:ProgramData\ssh\administrators_authorized_keys" -Value $FileContent
$ACL = Get-Acl "$env:ProgramData\ssh\administrators_authorized_keys"
$ACL.SetSecurityDescriptorSddlForm('O:SYG:SYD:PAI(A;;FA;;;SY)(A;;FA;;;BA)') 
$ACL | Set-Acl
#/ Restart th e SSH Server
Stop-Service -Name SSH-Agent ; Restart-Service -Name SSHd
#@ ----- Development -------------------------------------
$Apps = 
  @(
  [PSCustomObject]@{Name='Windows Terminal'; ID='Microsoft.WindowsTerminal'}
  [PSCustomObject]@{Name='GitHub Desktop'; ID='GitHub.GitHubDesktop'}
  [PSCustomObject]@{Name='VSCode'; ID='Microsoft.VisualStudioCode'}
  #/  [PSCustomObject]@{Name='Python'; ID='Python.Python.3.11'}
  #/  [PSCustomObject]@{Name='Cygwin'; ID='Cygwin.Cygwin'}
  #/  [PSCustomObject]@{Name='VIM'; ID='vim.vim'}
  #/  [PSCustomObject]@{Name='Git'; ID='Git.Git'}
  #/  [PSCustomObject]@{Name='VMware Workstation Pro'; ID='VMware.WorkstationPro'}
  #/  [PSCustomObject]@{Name='VMware Workstation Player'; ID='VMware.WorkstationPlayer'}
  #/  [PSCustomObject]@{Name='Wireshark'; ID='WiresharkFoundation.Wireshark'}
  #/  [PSCustomObject]@{Name='ProtonVPN'; ID='ProtonTechnologies.ProtonVPN'}
  #/  [PSCustomObject]@{Name='OpenVPN'; ID='OpenVPNTechnologies.OpenVPN'}
  #/  [PSCustomObject]@{Name='ExpressVPN'; ID='ExpressVPN.ExpressVPN'}
  #/  [PSCustomObject]@{Name='MullvadVPN'; ID='MullvadVPN.MullvadVPN'}
  #/  [PSCustomObject]@{Name='Cloudflare Warp'; ID='Cloudflare.Warp'}
  #/  [PSCustomObject]@{Name='WireGuard'; ID='WireGuard.WireGuard'}
  #/  [PSCustomObject]@{Name='VirtualBox'; ID='Oracle.VirtualBox'}
  #/  [PSCustomObject]@{Name='Nord VPN'; ID='NordVPN.NordVPN'}
  #/  [PSCustomObject]@{Name='Mozilla VPN'; ID='Mozilla.VPN'}
  )

foreach ($App in $Apps) 
  {winget install --accept-package-agreements --accept-source-agreements --exact --ID $App.ID}

#@ ----- Browsers ----------------------------------------
$Apps = 
  @(
  [PSCustomObject]@{Name='Brave Browser'; ID='Brave.Brave'}
  [PSCustomObject]@{Name='Opera Browser'; ID='Opera.Opera'}
  [PSCustomObject]@{Name='Edge Browser'; ID='XPFFTQ037JWMHS'}
  [PSCustomObject]@{Name='Firefox Browser'; ID='Mozilla.Firefox'}
  [PSCustomObject]@{Name='Tor Browser'; ID='TorProject.TorBrowser'}
  [PSCustomObject]@{Name='Waterfox Browser'; ID='Waterfox.Waterfox'}
  [PSCustomObject]@{Name='Google Chrome Browser'; ID='Google.Chrome'}
  #/  [PSCustomObject]@{Name='Vivaldi Browser'; ID='VivaldiTechnologies.Vivaldi'}
  #/  [PSCustomObject]@{Name='Google Chrome Canary Browser'; ID='Google.Chrome.Canary'}
  #/  [PSCustomObject]@{Name='LibreWolf Browser'; ID='LibreWolf.LibreWolf'}
  #/  [PSCustomObject]@{Name='Yandex Browser'; ID='Yandex.Browser'}
  )

foreach ($App in $Apps) 
  {winget install --accept-package-agreements --accept-source-agreements --exact --ID $App.ID}

#@ ----- eMail Client ------------------------------------
$Apps =
  @(
  [PSCustomObject]@{Name='Thunderbird Mail Client'; ID='Mozilla.Thunderbird'}
  [PSCustomObject]@{Name='BetterBird Mail Client'; ID='Betterbird.Betterbird'}
  #/  [PSCustomObject]@{Name='Zoho Mail Client'; ID='Zoho.ZohoMail.Desktop'}
  #/  [PSCustomObject]@{Name='Foxmail Mail Client'; ID='Tencent.Foxmail'}
  )

foreach ($App in $Apps) 
  {winget install --accept-package-agreements --accept-source-agreements --exact --ID $App.ID}

#@ ----- Communications ----------------------------------
$Apps = 
  @(
  [PSCustomObject]@{Name='Skype'; ID='Microsoft.Skype'}
  [PSCustomObject]@{Name='Discord'; ID='Discord.Discord'}
  [PSCustomObject]@{Name='WhatsApp'; ID='WhatsApp.WhatsApp'}
  [PSCustomObject]@{Name='HexChat'; ID='HexChat.HexChat'}
  [PSCustomObject]@{Name='Teams'; ID='Microsoft.Teams'}
  [PSCustomObject]@{Name='WeChat'; ID='Tencent.WeChat'}
  [PSCustomObject]@{Name='LINE'; ID='LINE.LINE'}
  [PSCustomObject]@{Name='Zoom'; ID='Zoom.Zoom'}
  [PSCustomObject]@{Name='Reddit'; ID='9NCFHPQ558DN'}
  [PSCustomObject]@{Name='Signal'; ID='OpenWhisperSystems.Signal'}
  [PSCustomObject]@{Name='Telegram'; ID='Telegram.TelegramDesktop'}
  [PSCustomObject]@{Name='Facebook'; ID='FACEBOOK.FACEBOOK_8xx8rvfyw5nnt'}
  [PSCustomObject]@{Name='Twitter'; ID='9E2F88E3.TWITTER_wgeqdkkx372wm'}
  )

foreach ($App in $Apps) 
  {winget install --accept-package-agreements --accept-source-agreements --exact --ID $App.ID}

#@ ----- Productivity ------------------------------------
$Apps = 
  @(
  [PSCustomObject]@{Name='Microsoft Translator'; ID='Microsoft.BingTranslator_8wekyb3d8bbwe'}
  [PSCustomObject]@{Name='Adobe Acrobat Reader'; ID='Adobe.Acrobat.Reader.64-bit'}
  [PSCustomObject]@{Name='Clipchamp'; ID='Clipchamp.Clipchamp_yxz26nhyzhsrt'}
  [PSCustomObject]@{Name='Minrosoft PowerToys'; ID='Microsoft.Powertoys'}
  [PSCustomObject]@{Name='Adobe DNG Converter'; ID='Adobe.DNGConverter'}
  [PSCustomObject]@{Name='Google.WebDesigner'; ID='Google.WebDesigner'}
  [PSCustomObject]@{Name='RDP'; ID='Microsoft.RemoteDesktopClient'}
  [PSCustomObject]@{Name='IrfanView'; ID='IrfanSkiljan.IrfanView'}
  [PSCustomObject]@{Name='Teamviewer'; ID='TeamViewer.TeamViewe'}
  [PSCustomObject]@{Name='Adobe Brackets'; ID='Adobe.Brackets'}
  [PSCustomObject]@{Name='OneDrive'; ID='Microsoft.OneDrive'}
  [PSCustomObject]@{Name='Balena Etcher'; ID='Balena.Etcher'}
  [PSCustomObject]@{Name='Goolge Drive'; ID='Google.Drive'}
  [PSCustomObject]@{Name='Dropbox'; ID='Dropbox.Dropbox'}
  )

foreach ($App in $Apps) 
  {winget install --accept-package-agreements --accept-source-agreements --exact --ID $App.ID}

#@ ----- Free Software -----------------------------------
$Apps = 
  @(
  [PSCustomObject]@{Name='LibreOffice'; ID='TheDocumentFoundation.LibreOffice'}
  [PSCustomObject]@{Name='qBittorrent'; ID='qBittorrent.qBittorrent'}
  #/  [PSCustomObject]@{Name='KeepassXC'; ID='KeePassXCTeam.KeePassXC'}
  #/  [PSCustomObject]@{Name='Blender'; ID='BlenderFoundation.Blender'}
  [PSCustomObject]@{Name='AnyDesk'; ID='AnyDeskSoftwareGmbH.AnyDesk'}
  [PSCustomObject]@{Name='FarManager'; ID='FarManager.FarManager'}
  [PSCustomObject]@{Name='Keepass'; ID='DominikReichl.KeePass'}
  [PSCustomObject]@{Name='Inkscape'; ID='9PD9BHGLFC7H'}
  [PSCustomObject]@{Name='Gimp'; ID='XPDM27W10192Q0'}
  [PSCustomObject]@{Name='VLC'; ID='XPDM1ZW6815MQM'}
  [PSCustomObject]@{Name='7-Zip'; ID='7zip.7zip'}
  [PSCustomObject]@{Name='PuTTY'; ID='PuTTY.PuTTY'}
  [PSCustomObject]@{Name='WinSCP'; ID='WinSCP.WinSCP'}
  )

foreach ($App in $Apps) 
  {winget install --accept-package-agreements --accept-source-agreements --exact --ID $App.ID}

#@ -------------------------------------------------------
winget upgrade --all --include-unknown --silent --verbose