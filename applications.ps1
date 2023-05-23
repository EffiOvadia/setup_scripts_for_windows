#! set wsl default version to 2
wsl --set-default-version 2
#! update wsl subsystem
wsl --update
#! list all available distro in MS store
wsl --list --online 
#! install ubuntu distro (NO LTS)
wsl --install --distribution Ubuntu
#! install deb ian distro 
wsl --install --distribution Debian
#! install kali-linux
wsl --install --distribution kali-linux
#! install ubuntu 20.04 LTS
wsl --install --distribution Ubuntu-20.04
#! install ubuntu 22.04 LTS
wsl --install --distribution Ubuntu-22.04
#! install Oracle Linux 9.1
wsl --install --distribution OracleLinux_9_1
#! list all installed distro on local machine
wsl --list --verbose
#! Cygwin
winget install -e --id Cygwin.Cygwin #Cygwin
#-------------------------------------------------------
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
#-------------------------------------------------------
#! Skype
winget install -e --id 9WZDNCRFJ364 #Skype
#! WhatsApp
winget install -e --id 9NKSQGP7F2NH #WhatsApp
#! WeChat
winget install -e --id XPFCKBRNFZQ62G #WeChat
#! Signal 
winget install -e --id OpenWhisperSystems.Signal #Signal
#! Discord
winget install -e --id XPDC2RH70K22MN #Discord
#! Teams 
winget install -e --id Microsoft.Teams #Teams
#! Zoom
winget install -e --id XP99J3KP4XZ4VV #Zoom
#-------------------------------------------------------
#! Twitter
winget install -e --id 9E2F88E3.TWITTER_wgeqdkkx372wm #Twitter
#! Facebook
winget install -e --id FACEBOOK.FACEBOOK_8xx8rvfyw5nnt #Facebook
#-------------------------------------------------------
#! Dropbox 
winget install -e --id Dropbox.Dropbox #Dropbox
#! OneDrive
winget install -e --id Microsoft.OneDrive #OneDrive
#! Goolge Drive
winget install -e --id Google.Drive #Google Drive
#-------------------------------------------------------
#! Adobe Acrobat
winget install -e --id XPDP273C0XHQH2 #Acrobat
#! Adobe Brackets
winget install -e --id Adobe.Brackets # Brackets
#! DNG Converter
winget install -e --id Adobe.DNGConverter # DNG Converter
#! Blender
#winget install -e --id BlenderFoundation.Blender # Blender
#! Google.WebDesigner
#winget install -e --id Google.WebDesigner # Google WebDesigner
#! HexChat
winget install -e --id HexChat.HexChat # HexChat
#! Git
winget install -e --id Git.Git #Git 
#! Translator
winget install -e --id Microsoft.BingTranslator_8wekyb3d8bbwe
#! PowerToys
winget install -e --id XP89DCGQ3K6VLD #PowerToys
#! LibreOffice
winget install -e --id TheDocumentFoundation.LibreOffice #LibreOffice
#! Teamviewer
winget install -e --id TeamViewer.TeamViewer #TeamViewer
#! VSCode
winget install -e --id Microsoft.VisualStudioCode #VSCode
#! VIM
winget install -e --id XPFFTQ037JWMHS #VIM
#! WinSCP
winget install -e --id WinSCP.WinSCP # WinSCP
#! PuTTY
winget install -e --id XPFNZKSKLBP7RJ #PuTTY
#! Python
winget install -e --id Python.Python.3.11
#! qBittorrent
winget install -e --id qBittorrent.qBittorrent #qBittorrent
#! 7-Zip
winget install -e --id 7zip.7zip --accept-source-agreements --accept-package-agreements
#! Reddit
winget install -e --id 9NCFHPQ558DN --accept-source-agreements --accept-package-agreements
#! FarManager
winget install -e --id FarManager.FarManager
#! Keepass
winget install -e --id DominikReichl.KeePass
#-------------------------------------------------------
#! Clipchamp
winget install -e --id Clipchamp.Clipchamp_yxz26nhyzhsrt
#! Inkscape
winget install -e --id 9PD9BHGLFC7H #Inkscape
#! Gimp
winget install -e --id XPDM27W10192Q0 # Gimp
#! VLC
winget install -e --id XPDM1ZW6815MQM #VLC
#-------------------------------------------------------
#! OpenVPN 
winget install -e --id OpenVPNTechnologies.OpenVPN # OpenVPN
#! ExpressVPN
winget install -e --id ExpressVPN.ExpressVPN # ExpressVPN
#! MullvadVPN
winget install -e --id MullvadVPN.MullvadVPN # MullvadVPN
#! ProtonVPN
winget install -e --id ProtonTechnologies.ProtonVPN
#! Wireshark
winget install -e --id WiresharkFoundation.Wireshark # Wireshark
#-------------------------------------------------------
#! VirtualBox
winget install -e --id Oracle.VirtualBox
#! VMware Workstation Pro
winget install -e --id VMware.WorkstationPro # VMware Workstation
#! VMware Workstation Player
winget install -e --id VMware.WorkstationPlayer # VMware Player
#! RDP
winget install -e --id Microsoft.RemoteDesktopClient # RDP
#-------------------------------------------------------
winget upgrade --all --include-unknown