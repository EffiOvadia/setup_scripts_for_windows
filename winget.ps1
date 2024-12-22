#! https://apps.microsoft.com/store/detail/app-installer/9NBLGGH4NNS1
#! https://github.com/microsoft/winget-cli/releases/latest
#! https://aka.ms/getwinget
#! ms-windows-store://pdp/?ProductId=9NBLGGH4NNS1
## ----- Development -------------------------------------
$Apps = 
  @(
  [PSCustomObject]@{Name='PowerShell'; ID='Microsoft.PowerShell'}
  [PSCustomObject]@{Name='Windows Terminal'; ID='Microsoft.WindowsTerminal'}
  #/  [PSCustomObject]@{Name='Midnight Commander'; ID='GNU.MidnightCommander'}
  [PSCustomObject]@{Name='GitHub Desktop'; ID='GitHub.GitHubDesktop'}
  [PSCustomObject]@{Name='VSCode'; ID='Microsoft.VisualStudioCode'}
  [PSCustomObject]@{Name='Python'; ID='Python.Python.3.11'}
  [PSCustomObject]@{Name='Cygwin'; ID='Cygwin.Cygwin'}
  [PSCustomObject]@{Name='Wget2'; ID='GNU.Wget2'}
  [PSCustomObject]@{Name='cURL'; ID='cURL.cURL'}
  [PSCustomObject]@{Name='VIM'; ID='vim.vim'}
  [PSCustomObject]@{Name='Git'; ID='Git.Git'}
  [PSCustomObject]@{Name='DotNet6'; ID='Microsoft.DotNet.DesktopRuntime.6'}
  [PSCustomObject]@{Name='DotNet7'; ID='Microsoft.DotNet.DesktopRuntime.7'}
  #/  [PSCustomObject]@{Name='Wireshark'; ID='WiresharkFoundation.Wireshark'}
  #/  [PSCustomObject]@{Name='ProtonVPN'; ID='ProtonTechnologies.ProtonVPN'}
  #/  [PSCustomObject]@{Name='OpenVPN'; ID='OpenVPNTechnologies.OpenVPN'}
  #/  [PSCustomObject]@{Name='Cloudflare Warp'; ID='Cloudflare.Warp'}
  #/  [PSCustomObject]@{Name='WireGuard'; ID='WireGuard.WireGuard'}
  #/  [PSCustomObject]@{Name='VirtualBox'; ID='Oracle.VirtualBox'}
  #/  [PSCustomObject]@{Name='Neovim'; ID='Neovim.Neovim'}
  )

foreach ($App in $Apps) 
  {winget install --accept-package-agreements --accept-source-agreements --exact --ID $App.ID}
## ----- Browsers & eMail Client -------------------------
$Apps = 
  @(
  [PSCustomObject]@{Name='Brave Browser'; ID='Brave.Brave'}
  [PSCustomObject]@{Name='Opera Browser'; ID='Opera.Opera'}
  [PSCustomObject]@{Name='Edge Browser'; ID='XPFFTQ037JWMHS'}
  [PSCustomObject]@{Name='Firefox Browser'; ID='Mozilla.Firefox'}
  [PSCustomObject]@{Name='Tor Browser'; ID='TorProject.TorBrowser'}
  [PSCustomObject]@{Name='Waterfox Browser'; ID='Waterfox.Waterfox'}
  [PSCustomObject]@{Name='Google Chrome Browser'; ID='Google.Chrome'}
  [PSCustomObject]@{Name='LibreWolf Browser'; ID='LibreWolf.LibreWolf'}
  [PSCustomObject]@{Name='Vivaldi Browser'; ID='VivaldiTechnologies.Vivaldi'}
  [PSCustomObject]@{Name='Google Chrome Canary Browser'; ID='Google.Chrome.Canary'}
  [PSCustomObject]@{Name='BetterBird Mail Client'; ID='Betterbird.Betterbird'}
  [PSCustomObject]@{Name='Thunderbird Mail Client'; ID='Mozilla.Thunderbird'}
  )

foreach ( $App in $Apps ) 
  { winget install --accept-package-agreements --accept-source-agreements --exact --ID $App.ID }

## ----- Communications ----------------------------------
$Apps = 
  @(
  [PSCustomObject]@{Name='Skype'; ID='Microsoft.Skype'}
  [PSCustomObject]@{Name='Discord'; ID='Discord.Discord'}
  [PSCustomObject]@{Name='WhatsApp'; ID='WhatsApp.WhatsApp'}
  [PSCustomObject]@{Name='HexChat'; ID='HexChat.HexChat'}
  [PSCustomObject]@{Name='Teams'; ID='Microsoft.Teams'}
  [PSCustomObject]@{Name='Zoom'; ID='Zoom.Zoom'}
  [PSCustomObject]@{Name='Signal'; ID='OpenWhisperSystems.Signal'}
  [PSCustomObject]@{Name='Telegram'; ID='Telegram.TelegramDesktop'}
  [PSCustomObject]@{Name='Facebook'; ID='FACEBOOK.FACEBOOK_8xx8rvfyw5nnt'}
  [PSCustomObject]@{Name='Twitter'; ID='9E2F88E3.TWITTER_wgeqdkkx372wm'}
  [PSCustomObject]@{Name='WeChat'; ID='Tencent.WeChat'}
  [PSCustomObject]@{Name='LINE'; ID='LINE.LINE'}
  )

foreach ($App in $Apps) 
  {winget install --accept-package-agreements --accept-source-agreements --exact --ID $App.ID}

## ----- Productivity ------------------------------------
$Apps = 
  @(
  [PSCustomObject]@{Name='Microsoft Translator'; ID='Microsoft.BingTranslator_8wekyb3d8bbwe'}
  [PSCustomObject]@{Name='Adobe Acrobat Reader'; ID='Adobe.Acrobat.Reader.64-bit'}
  [PSCustomObject]@{Name='VMware Workstation Pro'; ID='VMware.WorkstationPro'}
  [PSCustomObject]@{Name='Clipchamp'; ID='Clipchamp.Clipchamp_yxz26nhyzhsrt'}
  [PSCustomObject]@{Name='Microsoft PowerToys'; ID='Microsoft.Powertoys'}
  #/ [PSCustomObject]@{Name='Samsung SmartSwitch'; ID='Samsung.SmartSwitch'}
  [PSCustomObject]@{Name='Adobe DNG Converter'; ID='Adobe.DNGConverter'}
  #/ [PSCustomObject]@{Name='Samsung SmartView'; ID='Samsung.SmartView'}
  [PSCustomObject]@{Name='RDP'; ID='Microsoft.RemoteDesktopClient'}
  [PSCustomObject]@{Name='IrfanView'; ID='IrfanSkiljan.IrfanView'}
  [PSCustomObject]@{Name='Teamviewer'; ID='TeamViewer.TeamViewe'}
  [PSCustomObject]@{Name='Adobe Brackets'; ID='Adobe.Brackets'}
  [PSCustomObject]@{Name='OneDrive'; ID='Microsoft.OneDrive'}
  [PSCustomObject]@{Name='Balena Etcher'; ID='Balena.Etcher'}
  [PSCustomObject]@{Name='Google Drive'; ID='Google.Drive'}
  [PSCustomObject]@{Name='Samsung DeX'; ID='Samsung.DeX'}
  [PSCustomObject]@{Name='Dropbox'; ID='Dropbox.Dropbox'}
  )

foreach ($App in $Apps) 
  {winget install --accept-package-agreements --accept-source-agreements --exact --ID $App.ID}
## ----- Free Software -----------------------------------
$Apps = 
  @(
  [PSCustomObject]@{Name='LibreOffice'; ID='TheDocumentFoundation.LibreOffice'}
  [PSCustomObject]@{Name='YubiKey Personalization'; ID='Yubico.YubiKeyPersonalizationTool'}
  [PSCustomObject]@{Name='Yubico Authenticator'; ID='Yubico.Authenticator'}
  [PSCustomObject]@{Name='Yubikey Manager'; ID='Yubico.YubikeyManager'}
  #/ [PSCustomObject]@{Name='AnyDesk'; ID='AnyDeskSoftwareGmbH.AnyDesk'}
  [PSCustomObject]@{Name='KeepassXC'; ID='KeePassXCTeam.KeePassXC'}
  [PSCustomObject]@{Name='FarManager'; ID='FarManager.FarManager'}
  [PSCustomObject]@{Name='Keepass'; ID='DominikReichl.KeePass'}
  #/ [PSCustomObject]@{Name='VSCodium'; ID='VSCodium.VSCodium'}
  [PSCustomObject]@{Name='Inkscape'; ID='9PD9BHGLFC7H'}
  [PSCustomObject]@{Name='Gimp'; ID='XPDM27W10192Q0'}
  [PSCustomObject]@{Name='VLC'; ID='XPDM1ZW6815MQM'}
  [PSCustomObject]@{Name='7-Zip'; ID='7zip.7zip'}
  [PSCustomObject]@{Name='PuTTY'; ID='PuTTY.PuTTY'}
  [PSCustomObject]@{Name='WinSCP'; ID='WinSCP.WinSCP'}
  #/  [PSCustomObject]@{Name='qBittorrent'; ID='qBittorrent.qBittorrent'}
  )

foreach ($App in $Apps) 
  {winget install --accept-package-agreements --accept-source-agreements --exact --ID $App.ID}
## -------------------------------------------------------
winget upgrade --all --include-unknown --silent --verbose