#@ ------- Winget ----------------------------------------

#- $progressPreference = 'silentlyContinue'
#- $latestWingetMsixBundleUri = $(Invoke-RestMethod https://api.github.com/repos/microsoft/winget-cli/releases/latest).assets.browser_download_url | Where-Object {$_.EndsWith(".msixbundle")}
#- $latestWingetMsixBundle = $latestWingetMsixBundleUri.Split("/")[-1]
#- Write-Information "Downloading winget to artifacts directory..."
#- Invoke-WebRequest -Uri $latestWingetMsixBundleUri -OutFile "./$latestWingetMsixBundle"
#- Invoke-WebRequest -Uri https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx -OutFile Microsoft.VCLibs.x64.14.00.Desktop.appx
#- Add-AppxPackage Microsoft.VCLibs.x64.14.00.Desktop.appx
#- Add-AppxPackage $latestWingetMsixBundle

#@ ------- WSL -------------------------------------------

#/ Enable/Install Linux Subsystem feature
if ( $(Get-WindowsOptionalFeature -Online -FeatureName "Microsoft-Windows-Subsystem-Linux").state -ne "Enabled" ) 
{ Enable-WindowsOptionalFeature -NoRestart -Online -FeatureName "Microsoft-Windows-Subsystem-Linux" -All }
#/ Add windows capability: OpenSSH Client
If ( $(Get-WindowsCapability -Online -Name OpenSSH.Client~~~~0.0.1.0).state -ne "Installed" ) 
{ Add-WindowsCapability -Online -Name OpenSSH.Client~~~~0.0.1.0 }
#/ Add windows capability: OpenSSH Server
If ( $(Get-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0).state -ne "Installed" )
{ Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0 }
#/ set wsl default version to 2
wsl --set-default-version 2
#/ update wsl subsystem
wsl --update
#/ list all installed distros on local machine
wsl --list --verbose
#/ list all available distro in MS store
wsl --list --online

$Distros = @(
  [PSCustomObject]@{Name='Ubuntu'; ID='Ubuntu'}
  [PSCustomObject]@{Name='Debian GNU/Linux'; ID='Debian'}
  [PSCustomObject]@{Name='Kali Linux Rolling'; ID='kali-linux'}
  [PSCustomObject]@{Name='Ubuntu 22.04 LTS'; ID='Ubuntu-22.04'}
  [PSCustomObject]@{Name='Oracle Linux 9.1'; ID='OracleLinux_9_1'}
  )

foreach ($Dist in $Distros) { wsl --install --no-launch -d $Dist.ID }
  
#@ ----- Development -------------------------------------

$Apps = @(
  [PSCustomObject]@{Name='Windows Terminal'; ID='Microsoft.WindowsTerminal'}
  [PSCustomObject]@{Name='VSCode'; ID='Microsoft.VisualStudioCode'}
  [PSCustomObject]@{Name='Python'; ID='Python.Python.3.11'}
  [PSCustomObject]@{Name='Cygwin'; ID='Cygwin.Cygwin'}
  [PSCustomObject]@{Name='VIM'; ID='XPFFTQ037JWMHS'}
  [PSCustomObject]@{Name='Git'; ID='Git.Git'}
  )
#/  [PSCustomObject]@{Name='VirtualBox'; ID='Oracle.VirtualBox'}
#/  [PSCustomObject]@{Name='VMware Workstation Pro'; ID='VMware.WorkstationPro'}
#/  [PSCustomObject]@{Name='VMware Workstation Player'; ID='VMware.WorkstationPlayer'}
#/  [PSCustomObject]@{Name='Wireshark'; ID='WiresharkFoundation.Wireshark'}
#/  [PSCustomObject]@{Name='ProtonVPN'; ID='ProtonTechnologies.ProtonVPN'}
#/  [PSCustomObject]@{Name='OpenVPN'; ID='OpenVPNTechnologies.OpenVPN'}
#/  [PSCustomObject]@{Name='ExpressVPN'; ID='ExpressVPN.ExpressVPN'}
#/  [PSCustomObject]@{Name='MullvadVPN'; ID='MullvadVPN.MullvadVPN'}
#/  [PSCustomObject]@{Name='Cloudflare Warp'; ID='Cloudflare.Warp'}
#/  [PSCustomObject]@{Name='WireGuard'; ID='WireGuard.WireGuard'}
#/  [PSCustomObject]@{Name='Nord VPN'; ID='NordVPN.NordVPN'}
#/  [PSCustomObject]@{Name='Mozilla VPN'; ID='Mozilla.VPN'}

foreach ($App in $Apps) {winget install --accept-package-agreements --accept-source-agreements --exact --ID $App.ID}

#@ -------- Browsers -------------------------------------

$Apps = @(
  [PSCustomObject]@{Name='Brave Browser'; ID='Brave.Brave'}
  [PSCustomObject]@{Name='Opera Browser'; ID='Opera.Opera'}
  [PSCustomObject]@{Name='Edge Browser'; ID='XPFFTQ037JWMHS'}
  [PSCustomObject]@{Name='Firefox Browser'; ID='Mozilla.Firefox'}
  [PSCustomObject]@{Name='Tor Browser'; ID='TorProject.TorBrowser'}
  [PSCustomObject]@{Name='Waterfox Browser'; ID='Waterfox.Waterfox'}
  [PSCustomObject]@{Name='Google Chrome Browser'; ID='Google.Chrome'}
  [PSCustomObject]@{Name='Vivaldi Browser'; ID='VivaldiTechnologies.Vivaldi'}
  )
#/  [PSCustomObject]@{Name='Google Chrome Canary Browser'; ID='Google.Chrome.Canary'}
#/  [PSCustomObject]@{Name='K-Meleon Browser'; ID='kmeleonbrowser.K-Meleon'}
#/  [PSCustomObject]@{Name='LibreWolf Browser'; ID='LibreWolf.LibreWolf'}
#/  [PSCustomObject]@{Name='Yandex Browser'; ID='Yandex.Browser'}

foreach ($App in $Apps) {winget install --accept-package-agreements --accept-source-agreements --exact --ID $App.ID}

#@ -------- eMail Client ---------------------------------

$Apps = @(
  [PSCustomObject]@{Name='Thunderbird Mail Client'; ID='Mozilla.Thunderbird'}
  [PSCustomObject]@{Name='BetterBird Mail Client'; ID='Betterbird.Betterbird'}
  )
#/  [PSCustomObject]@{Name='Zoho Mail Client'; ID='Zoho.ZohoMail.Desktop'}
#/  [PSCustomObject]@{Name='Foxmail Mail Client'; ID='Tencent.Foxmail'}

foreach ($App in $Apps) {winget install --accept-package-agreements --accept-source-agreements --exact --ID $App.ID}

#@ ------- Communications -------------------------------

$Apps = @(
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

foreach ($App in $Apps) {winget install --accept-package-agreements --accept-source-agreements --exact --ID $App.ID}

#@ -------------------------------------------------------

$Apps = @(
  [PSCustomObject]@{Name='Microsoft Translator'; ID='Microsoft.BingTranslator_8wekyb3d8bbwe'}
  [PSCustomObject]@{Name='Adobe Acrobat Reader'; ID='Adobe.Acrobat.Reader.64-bit'}
  [PSCustomObject]@{Name='Clipchamp'; ID='Clipchamp.Clipchamp_yxz26nhyzhsrt'}
  [PSCustomObject]@{Name='Minrosoft PowerToys'; ID='Microsoft.Powertoys'}
  [PSCustomObject]@{Name='Adobe DNG Converter'; ID='Adobe.DNGConverter'}
  [PSCustomObject]@{Name='Google.WebDesigner'; ID='Google.WebDesigner'}
  [PSCustomObject]@{Name='RDP'; ID='Microsoft.RemoteDesktopClient'}
  [PSCustomObject]@{Name='Teamviewer'; ID='TeamViewer.TeamViewe'}
  [PSCustomObject]@{Name='Adobe Brackets'; ID='Adobe.Brackets'}
  [PSCustomObject]@{Name='OneDrive'; ID='Microsoft.OneDrive'}
  [PSCustomObject]@{Name='Goolge Drive'; ID='Google.Drive'}
  [PSCustomObject]@{Name='Dropbox'; ID='Dropbox.Dropbox'}
  )

foreach ($App in $Apps) {winget install --accept-package-agreements --accept-source-agreements --exact --ID $App.ID}

#@ -------------------------------------------------------

$Apps = @(
  [PSCustomObject]@{Name='LibreOffice'; ID='TheDocumentFoundation.LibreOffice'}
  [PSCustomObject]@{Name='qBittorrent'; ID='qBittorrent.qBittorrent'}
  [PSCustomObject]@{Name='Blender'; ID='BlenderFoundation.Blender'}
  [PSCustomObject]@{Name='FarManager'; ID='FarManager.FarManager'}
  [PSCustomObject]@{Name='Keepass'; ID='DominikReichl.KeePass'}
  [PSCustomObject]@{Name='Inkscape'; ID='9PD9BHGLFC7H'}
  [PSCustomObject]@{Name='Gimp'; ID='XPDM27W10192Q0'}
  [PSCustomObject]@{Name='VLC'; ID='XPDM1ZW6815MQM'}
  [PSCustomObject]@{Name='7-Zip'; ID='7zip.7zip'}
  [PSCustomObject]@{Name='PuTTY'; ID='PuTTY.PuTTY'}
  [PSCustomObject]@{Name='WinSCP'; ID='WinSCP.WinSCP'}
  )
#/  [PSCustomObject]@{Name='KeepassXC'; ID='KeePassXCTeam.KeePassXC'}

foreach ($App in $Apps) {winget install --accept-package-agreements --accept-source-agreements --exact --ID $App.ID}

#@ -------------------------------------------------------

winget upgrade --all --include-unknown
