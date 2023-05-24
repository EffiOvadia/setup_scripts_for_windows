#------- WSL -------------------------------------------
### Enable/Install Linux Subsystem feature
if ( $(Get-WindowsOptionalFeature -Online -FeatureName "Microsoft-Windows-Subsystem-Linux").state -ne "Enabled" ) 
{ Enable-WindowsOptionalFeature -NoRestart -Online -FeatureName "Microsoft-Windows-Subsystem-Linux" -All }
### Add windows capability: OpenSSH Client
If ( $(Get-WindowsCapability -Online -Name OpenSSH.Client~~~~0.0.1.0).state -ne "Installed" ) 
{ Add-WindowsCapability -Online -Name OpenSSH.Client~~~~0.0.1.0 }
### Add windows capability: OpenSSH Server
If ( $(Get-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0).state -ne "Installed" )
{ Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0 }
#! set wsl default version to 2
wsl --set-default-version 2
#! update wsl subsystem
wsl --update
#! list all available distro in MS store
wsl --list --online 
#! install ubuntu distro (NO LTS)
wsl --install --distribution Ubuntu
#! install debian distro 
wsl --install --distribution Debian
#! install kali-linux
wsl --install --distribution kali-linux
#! install ubuntu 22.04 LTS
wsl --install --distribution Ubuntu-22.04
#! install Oracle Linux 9.1
wsl --install --distribution OracleLinux_9_1
#! list all installed distro on local machine
wsl --list --verbose
#----- Development -------------------------------------
#! Windows Terminal
winget install -e --id Microsoft.WindowsTerminal #Windows Terminal
#! VSCode
winget install -e --id Microsoft.VisualStudioCode #VSCode
#! Python
winget install -e --id Python.Python.3.11 #Python
#! Cygwin
winget install -e --id Cygwin.Cygwin #Cygwin
#! VIM
winget install -e --id XPFFTQ037JWMHS #VIM
#! Git
winget install -e --id Git.Git #Git
#-------- Browsers & eMail Client ----------------------
#! Brave Browser
winget install -e --id Brave.Brave #Brave
#! Edge Browser
winget install -e --id XPFFTQ037JWMHS #Edge
#! Firefox 
winget install -e --id Mozilla.Firefox #Firefox
#! Tor Browser
winget install -e --id TorProject.TorBrowser #Tor 
#! Google Chrome
winget install -e --id Google.Chrome #Google Chrome
#! Google Chrome Canary 
winget install -e --id Google.Chrome.Canary #Google Chrome Canary
#! Vivaldi Browser
winget install -e --id VivaldiTechnologies.Vivaldi #Vivaldi
#! Waterfox
winget install -e --id Waterfox.Waterfox #Waterfox
#! Opera
winget install -e --id Opera.Opera #Opera
#! Thunderbird
winget install -e --id Mozilla.Thunderbird #Thunderbird
#! BetterBird
winget install -e --id Betterbird.Betterbird #Betterbird
#! LibreWolf
#winget install -e --id LibreWolf.LibreWolf # LibreWolf
#! Yandex
#winget install -e --id Yandex.Browser # Yandex
#! K-Meleon
#winget install -e --id kmeleonbrowser.K-Meleon
#! Zoho Mail
#winget install -e --id Zoho.ZohoMail.Desktop
#! Foxmail
#winget install -e --id Tencent.Foxmail
#------------ Communications ---------------------------
#! Skype
winget install -e --id Microsoft.Skype #Skype
#! Discord
winget install -e --id Discord.Discord #Discord
#! WhatsApp
winget install -e --id WhatsApp.WhatsApp #WhatsApp
#! Telegram
winget install -e --id Telegram.TelegramDesktop #Telegram
#! Signal 
winget install -e --id OpenWhisperSystems.Signal #Signal
#! HexChat
winget install -e --id HexChat.HexChat # HexChat
#! Teams 
winget install -e --id Microsoft.Teams #Teams
#! WeChat
winget install -e --id Tencent.WeChat #WeChat
#! LINE
winget install -e --id LINE.LINE #LINE
#! Zoom
winget install -e --id Zoom.Zoom #Zoom
#-------------------------------------------------------
#! Twitter
winget install -e --id 9E2F88E3.TWITTER_wgeqdkkx372wm #Twitter
#! Facebook
winget install -e --id FACEBOOK.FACEBOOK_8xx8rvfyw5nnt #Facebook
#! Reddit
#winget install -e --id 9NCFHPQ558DN #Reddit
#-------------------------------------------------------
#! Dropbox 
winget install -e --id Dropbox.Dropbox #Dropbox
#! OneDrive
winget install -e --id Microsoft.OneDrive #OneDrive
#! Goolge Drive
winget install -e --id Google.Drive #Google Drive
#-------------------------------------------------------
#! Adobe Acrobat
winget install -e --id Adobe.Acrobat.Reader.64-bit #Acrobat
#! DNG Converter
winget install -e --id Adobe.DNGConverter # DNG Converter
#! Adobe Brackets
winget install -e --id Adobe.Brackets # Brackets
#! Inkscape
winget install -e --id 9PD9BHGLFC7H #Inkscape
#! Gimp
winget install -e --id XPDM27W10192Q0 # Gimp
#! VLC
winget install -e --id XPDM1ZW6815MQM #VLC
#! 7-Zip
winget install -e --id 7zip.7zip #7zip
#! PuTTY
winget install -e --id PuTTY.PuTTY #PuTTY
#! WinSCP
winget install -e --id WinSCP.WinSCP # WinSCP
#! PowerToys
winget install -e --id XP89DCGQ3K6VLD #PowerToys
#! FarManager
winget install -e --id FarManager.FarManager #FAR
#! Keepass
winget install -e --id DominikReichl.KeePass #KeePass
#! Teamviewer
winget install -e --id TeamViewer.TeamViewer #TeamViewer
#! RDP
winget install -e --id Microsoft.RemoteDesktopClient # RDP
#! qBittorrent
winget install -e --id qBittorrent.qBittorrent #qBittorrent
#! LibreOffice
winget install -e --id TheDocumentFoundation.LibreOffice #LibreOffice
#-------------------------------------------------------
#! Clipchamp
#winget install -e --id Clipchamp.Clipchamp_yxz26nhyzhsrt
#! Google.WebDesigner
#winget install -e --id Google.WebDesigner # Google WebDesigner
#! Translator
#winget install -e --id Microsoft.BingTranslator_8wekyb3d8bbwe
#! Blender
#winget install -e --id BlenderFoundation.Blender # Blender

#-------------------------------------------------------
#! OpenVPN 
#winget install -e --id OpenVPNTechnologies.OpenVPN # OpenVPN
#! ExpressVPN
#winget install -e --id ExpressVPN.ExpressVPN # ExpressVPN
#! MullvadVPN
#winget install -e --id MullvadVPN.MullvadVPN # MullvadVPN
#! ProtonVPN
#winget install -e --id ProtonTechnologies.ProtonVPN
#-------------------------------------------------------
#! VirtualBox
winget install -e --id Oracle.VirtualBox
#! VMware Workstation Pro
winget install -e --id VMware.WorkstationPro # VMware Workstation
#! VMware Workstation Player
winget install -e --id VMware.WorkstationPlayer # VMware Player
#! Wireshark
winget install -e --id WiresharkFoundation.Wireshark # Wireshark
#-------------------------------------------------------
winget upgrade --all --include-unknown 