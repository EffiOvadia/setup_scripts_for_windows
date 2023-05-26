#Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Kernel" obcaseinsensitive -Force -Value 0

#/ Display the cuurent windows verion on the bottom left corner of the desktop
#Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" PaintDesktopVersion -Force -Value 1
Push-Location -Path "HKCU:\Control Panel\Desktop\WindowMetrics"
Set-ItemProperty -Path . IconSpacing         -Force -Value "-1050"
Set-ItemProperty -Path . IconVerticalSpacing -Force -Value "-1050"
Set-ItemProperty -Path . CaptionWidth        -Force -Value "-330"
Set-ItemProperty -Path . CaptionHeight       -Force -Value "-330"
Set-ItemProperty -Path . SmCaptionHeight     -Force -Value "-330"
Set-ItemProperty -Path . SmCaptionWidth      -Force -Value "-330"
Set-ItemProperty -Path . MenuHeight          -Force -Value "-330"
Set-ItemProperty -Path . MenuWidth           -Force -Value "-330"
Set-ItemProperty -Path . BorderWidth         -Force -Value "-15"  
Pop-Location

Push-Location -path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion"
#/ leave file & folder name case intact
Set-ItemProperty -Path ".\Explorer\Advanced" DontPrettyPath -Force -Value 1
#/ Enable Windows 10 Dark theme 
Set-ItemProperty -Path ".\Themes\Personalize" AppsUseLightTheme -Force -Value 0 
#/ Enable bluring of the backround picture 
Set-ItemProperty -Path ".\Themes\Personalize" EnableBlurBehind -Force -Value 1
#/ Explorer Open "This PC" Instead Of Quick Access
Set-ItemProperty -Path ".\Explorer\Advanced" LaunchTo -Force -Value 1
#/ Show the secondes in the taskbar clock
Set-ItemProperty -Path ".\Explorer\Advanced" ShowSecondsInSystemClock -Force -Value 1
Pop-Location

Push-Location -path "HKLM:\SOFTWARE\Policies\Microsoft"
if ( -not(Test-Path ".\Psched\") ) { New-Item -Path ".\Psched\" }
Set-ItemProperty -Path ".\Psched" NonBestEffortLimit -Force -Value 0
Pop-Location

Push-Location -path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer"
#/ On Toggle the comment and the computer name on mapped network drive drives 
Set-ItemProperty -Path "..\policies\Explorer" ToggleCommentPosition -Force -Value 1
#/ Increase Taskbar Transparency Level
Set-ItemProperty -Path ".\Advanced" UseOLEDTaskbarTransparency -Force -Value 1
#/ On Windows explorer drive listed with drive letter at the begining of the line
Set-ItemProperty -Path "." ShowDriveLettersFirst -Force -Value 4
#/ Hide Folder DESKTOP From This PC
Set-ItemProperty -Path ".\FolderDescriptions\{B4BFCC3A-DB2C-424C-B029-7FE99A87C641}\PropertyBag" ThisPCPolicy -Force -Value Hide
#/ Hide Folder DOCUMENTS From This PC
Set-ItemProperty -Path ".\FolderDescriptions\{f42ee2d3-909f-4907-8871-4c22fc0bf756}\PropertyBag" ThisPCPolicy -Force -Value Hide
#/ Hide Folder Downloads From This PC
Set-ItemProperty -Path ".\FolderDescriptions\{7d83ee9b-2244-4e70-b1f5-5393042af1e4}\PropertyBag" ThisPCPolicy -Force -Value Hide
#/ Hide Folder MUSIC From This PC
Set-ItemProperty -Path ".\FolderDescriptions\{a0c69a99-21c8-4671-8703-7934162fcf1d}\PropertyBag" ThisPCPolicy -Force -Value Hide
#/ Hide Folder PICTURES From This PC
Set-ItemProperty -Path ".\FolderDescriptions\{0ddd015d-b06c-45d5-8c4c-f59713854639}\PropertyBag" ThisPCPolicy -Force -Value Hide
#/ Hide Folder VIDEOS From This PC
Set-ItemProperty -Path ".\FolderDescriptions\{35286a68-3c57-41a1-bbb1-0eae73d76c95}\PropertyBag" ThisPCPolicy -Force -Value Hide
#/ Hide 3D Objects from This PC
if ( Test-Path ".\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}" ) 
{ Remove-Item ".\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}" }
Pop-Location

#Push-Location "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization"
#Set-ItemProperty -Path . NoLockScreen -Force -Value 1
#Set-ItemProperty -Path . NoLockScreenCamera -Force -Value 1
#Pop-Location

#/ ### create a pseudo folder that act as advanced control panel
#- new-item -ItemType Directory "$env:userprofile\Desktop\Administration.{ED7BA470-8E54-465E-825C-99712043E01C}"
#- new-item -ItemType Directory "$env:userprofile\Desktop\AllShortcuts.{4234d49b-0245-4df3-b780-3893943456e1}"

New-PSDrive -PSProvider Registry -Name HKU -Root HKEY_USERS
Set-ItemProperty -Path "HKU:\.DEFAULT\Control Panel\Keyboard\" InitialKeyboardIndicators -Force -Value 2

#/ Change Print Screen Key to start snipping tool
Set-ItemProperty -Path "HKCU:\Control Panel\Keyboard" PrintScreenKeyForSnippingEnabled -Force -Value 1

#/ Set DELL brand in registry (for DELL laptops only)
#Push-Location -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Store"
#Set-ItemProperty -Path . OEMID -Force -Value DELL
#Set-ItemProperty -Path . StoreContentModifier -Force -Value DELL_XPS
#Pop-Location

#/ Disbale Bing Search in Windows 11
Push-Location -path "HKCU:\Software\Policies\Microsoft\Windows"
if ( -not(Test-Path ".\Explorer\") ) { New-Item -Path ".\Explorer\" }
Set-ItemProperty -Path ".\Explorer" DisableSearchBoxSuggestions -Force -Value 1
Pop-Location