
Install-Language he-IL

Set-SystemPreferredUILanguage -Language he-IL


$CapabilityList = 
@(
    "Language.Basic~~~he-IL~0.0.1.0", 
    "Language.TextToSpeech~~~he-IL~0.0.1.0",
    "Language.Fonts.Hebr~~~und-HEBR~0.0.1.0"
)
foreach ($Capability in $CapabilityList) { Add-WindowsCapability -Online -Name $Capability }
Set-Culture he-IL
Set-WinHomeLocation -GeoId 117 # Israel
Set-WinSystemLocale -SystemLocale he-IL
$LanguageList = Get-WinUserLanguageList ; $LanguageList.Add("he-IL")
Set-WinUserLanguageList -LanguageList $LanguageList -Force