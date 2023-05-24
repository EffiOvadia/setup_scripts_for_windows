#------- Winget ----------------------------------------

#$progressPreference = 'silentlyContinue'
#$latestWingetMsixBundleUri = $(Invoke-RestMethod https://api.github.com/repos/microsoft/winget-cli/releases/latest).assets.browser_download_url | Where-Object {$_.EndsWith(".msixbundle")}
#$latestWingetMsixBundle = $latestWingetMsixBundleUri.Split("/")[-1]
#Write-Information "Downloading winget to artifacts directory..."
#Invoke-WebRequest -Uri $latestWingetMsixBundleUri -OutFile "./$latestWingetMsixBundle"
#Invoke-WebRequest -Uri https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx -OutFile Microsoft.VCLibs.x64.14.00.Desktop.appx
#Add-AppxPackage Microsoft.VCLibs.x64.14.00.Desktop.appx
#Add-AppxPackage $latestWingetMsixBundle

#------- WSL -------------------------------------------

#! Enable/Install Linux Subsystem feature
if ( $(Get-WindowsOptionalFeature -Online -FeatureName "Microsoft-Windows-Subsystem-Linux").state -ne "Enabled" ) 
{ Enable-WindowsOptionalFeature -NoRestart -Online -FeatureName "Microsoft-Windows-Subsystem-Linux" -All }
#! Add windows capability: OpenSSH Client
If ( $(Get-WindowsCapability -Online -Name OpenSSH.Client~~~~0.0.1.0).state -ne "Installed" ) 
{ Add-WindowsCapability -Online -Name OpenSSH.Client~~~~0.0.1.0 }
#!Add windows capability: OpenSSH Server
If ( $(Get-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0).state -ne "Installed" )
{ Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0 }
#! set wsl default version to 2
wsl --set-default-version 2
#! update wsl subsystem
wsl --update
#! list all available distro in MS store
wsl --list --online 

$Distros = @(
  [pscustomobject]@{Name='Ubuntu'; ID='Ubuntu'}
  [pscustomobject]@{Name='Debian'; ID='Debian'}
  [pscustomobject]@{Name='Kali Linux'; ID='kali-linux'}
  [pscustomobject]@{Name='Ubuntu 22.04 LTS'; ID='Ubuntu-22.04'}
  [pscustomobject]@{Name='OracleLinux 9.1'; ID='OracleLinux_9_1'}
  )

foreach ($Dist in $Distros) { wsl --list --verbose $Dist.ID }

#----- Development -------------------------------------

$Apps = @(
  [pscustomobject]@{Name='Windows Terminal'; ID='Microsoft.WindowsTerminal'}
  [pscustomobject]@{Name='VSCode'; ID='Microsoft.VisualStudioCode'}
  [pscustomobject]@{Name='Python'; ID='Python.Python.3.11'}
  [pscustomobject]@{Name='Cygwin'; ID='Cygwin.Cygwin'}
  [pscustomobject]@{Name='VIM'; ID='XPFFTQ037JWMHS'}
  [pscustomobject]@{Name='Git'; ID='Git.Git'}
#  [pscustomobject]@{Name='VirtualBox'; ID='Oracle.VirtualBox'}
#  [pscustomobject]@{Name='VMware Workstation Pro'; ID='VMware.WorkstationPro'}
#  [pscustomobject]@{Name='VMware Workstation Player'; ID='VMware.WorkstationPlayer'}
#  [pscustomobject]@{Name='Wireshark'; ID='WiresharkFoundation.Wireshark'}
#  [pscustomobject]@{Name='ProtonVPN'; ID='ProtonTechnologies.ProtonVPN'}
#  [pscustomobject]@{Name='OpenVPN'; ID='OpenVPNTechnologies.OpenVPN'}
#  [pscustomobject]@{Name='ExpressVPN'; ID='ExpressVPN.ExpressVPN'}
#  [pscustomobject]@{Name='MullvadVPN'; ID='MullvadVPN.MullvadVPN'}
#  [pscustomobject]@{Name='Cloudflare Warp'; ID='Cloudflare.Warp'}
  [pscustomobject]@{Name='WireGuard'; ID='WireGuard.WireGuard'}
#  [pscustomobject]@{Name='Nord VPN'; ID='NordVPN.NordVPN'}
#  [pscustomobject]@{Name='Mozilla VPN'; ID='Mozilla.VPN'}
  )

foreach ($App in $Apps) {winget install --accept-package-agreements --accept-source-agreements --exact --ID $App.ID}

#-------- Browsers -------------------------------------

$Apps = @(
  [pscustomobject]@{Name='Brave Browser'; ID='Brave.Brave'}
  [pscustomobject]@{Name='Opera Browser'; ID='Opera.Opera'}
  [pscustomobject]@{Name='Edge Browser'; ID='XPFFTQ037JWMHS'}
  [pscustomobject]@{Name='Firefox Browser'; ID='Mozilla.Firefox'}
  [pscustomobject]@{Name='Tor Browser'; ID='TorProject.TorBrowser'}
  [pscustomobject]@{Name='Waterfox Browser'; ID='Waterfox.Waterfox'}
  [pscustomobject]@{Name='Google Chrome Browser'; ID='Google.Chrome'}
  [pscustomobject]@{Name='Google Chrome Canary Browser'; ID='Google.Chrome.Canary'}
  [pscustomobject]@{Name='Vivaldi Browser'; ID='VivaldiTechnologies.Vivaldi'}
#  [pscustomobject]@{Name='K-Meleon Browser'; ID='kmeleonbrowser.K-Meleon'}
#  [pscustomobject]@{Name='LibreWolf Browser'; ID='LibreWolf.LibreWolf'}
#  [pscustomobject]@{Name='Yandex Browser'; ID='Yandex.Browser'}
  )

foreach ($App in $Apps) {winget install --accept-package-agreements --accept-source-agreements --exact --ID $App.ID}

#-------- eMail Client ---------------------------------

$Apps = @(
  [pscustomobject]@{Name='Thunderbird Mail Client'; ID='Mozilla.Thunderbird'}
  [pscustomobject]@{Name='BetterBird Mail Client'; ID='Betterbird.Betterbird'}
#  [pscustomobject]@{Name='Zoho Mail Client'; ID='Zoho.ZohoMail.Desktop'}
#  [pscustomobject]@{Name='Foxmail Mail Client'; ID='Tencent.Foxmail'}
  )

foreach ($App in $Apps) {winget install --accept-package-agreements --accept-source-agreements --exact --ID $App.ID}

#-------- Communications -------------------------------

$Apps = @(
  [pscustomobject]@{Name='Skype'; ID='Microsoft.Skype'}
  [pscustomobject]@{Name='Discord'; ID='Discord.Discord'}
  [pscustomobject]@{Name='WhatsApp'; ID='WhatsApp.WhatsApp'}
  [pscustomobject]@{Name='HexChat'; ID='HexChat.HexChat'}
  [pscustomobject]@{Name='Teams'; ID='Microsoft.Teams'}
  [pscustomobject]@{Name='WeChat'; ID='Tencent.WeChat'}
  [pscustomobject]@{Name='LINE'; ID='LINE.LINE'}
  [pscustomobject]@{Name='Zoom'; ID='Zoom.Zoom'}
  [pscustomobject]@{Name='Reddit'; ID='9NCFHPQ558DN'}
  [pscustomobject]@{Name='Signal'; ID='OpenWhisperSystems.Signal'}
  [pscustomobject]@{Name='Telegram'; ID='Telegram.TelegramDesktop'}
  [pscustomobject]@{Name='Facebook'; ID='FACEBOOK.FACEBOOK_8xx8rvfyw5nnt'}
  [pscustomobject]@{Name='Twitter'; ID='9E2F88E3.TWITTER_wgeqdkkx372wm'}
  )

foreach ($App in $Apps) {winget install --accept-package-agreements --accept-source-agreements --exact --ID $App.ID}

#-------------------------------------------------------

$Apps = @(
  [pscustomobject]@{Name='Clipchamp'; ID='Clipchamp.Clipchamp_yxz26nhyzhsrt'}
  [pscustomobject]@{Name='Microsoft Translator'; ID='Microsoft.BingTranslator_8wekyb3d8bbwe'}
  [pscustomobject]@{Name='Adobe Acrobat Reader'; ID='Adobe.Acrobat.Reader.64-bit'}
  [pscustomobject]@{Name='Minrosoft PowerToys'; ID='Microsoft.Powertoys'}
  [pscustomobject]@{Name='Adobe DNG Converter'; ID='Adobe.DNGConverter'}
  [pscustomobject]@{Name='Google.WebDesigner'; ID='Google.WebDesigner'}
  [pscustomobject]@{Name='RDP'; ID='Microsoft.RemoteDesktopClient'}
  [pscustomobject]@{Name='Teamviewer'; ID='TeamViewer.TeamViewe'}
  [pscustomobject]@{Name='Adobe Brackets'; ID='Adobe.Brackets'}
  [pscustomobject]@{Name='OneDrive'; ID='Microsoft.OneDrive'}
  [pscustomobject]@{Name='Goolge Drive'; ID='Google.Drive'}
  [pscustomobject]@{Name='Dropbox'; ID='Dropbox.Dropbox'}
  
  )

foreach ($App in $Apps) {winget install --accept-package-agreements --accept-source-agreements --exact --ID $App.ID}

#-------------------------------------------------------

$Apps = @(
  [pscustomobject]@{Name='LibreOffice'; ID='TheDocumentFoundation.LibreOffice'}
  [pscustomobject]@{Name='qBittorrent'; ID='qBittorrent.qBittorrent'}
  [pscustomobject]@{Name='Blender'; ID='BlenderFoundation.Blender'}
#  [pscustomobject]@{Name='KeepassXC'; ID='KeePassXCTeam.KeePassXC'}
  [pscustomobject]@{Name='FarManager'; ID='FarManager.FarManager'}
  [pscustomobject]@{Name='Keepass'; ID='DominikReichl.KeePass'}
  [pscustomobject]@{Name='Inkscape'; ID='9PD9BHGLFC7H'}
  [pscustomobject]@{Name='Gimp'; ID='XPDM27W10192Q0'}
  [pscustomobject]@{Name='VLC'; ID='XPDM1ZW6815MQM'}
  [pscustomobject]@{Name='7-Zip'; ID='7zip.7zip'}
  [pscustomobject]@{Name='PuTTY'; ID='PuTTY.PuTTY'}
  [pscustomobject]@{Name='WinSCP'; ID='WinSCP.WinSCP'}
  )

foreach ($App in $Apps) {winget install --accept-package-agreements --accept-source-agreements --exact --ID $App.ID}

#-------------------------------------------------------

winget upgrade --all --include-unknown