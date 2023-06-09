Get-InstalledLanguage

Install-Language zh-CN

Set-SystemPreferredUILanguage -Language zh-CN

$CapabilityList = 
@(
    "Language.Basic~~~zh-CN~0.0.1.0",
    "Language.Handwriting~~~zh-CN~0.0.1.0",
    "Language.OCR~~~zh-CN~0.0.1.0",
    "Language.Speech~~~zh-CN~0.0.1.0",
    "Language.TextToSpeech~~~zh-CN~0.0.1.0",
    "Language.Fonts.Hans~~~und-HANS~0.0.1.0"
)
foreach ($Capability in $CapabilityList) { Add-WindowsCapability -Online -Name $Capability }
Set-ItemProperty -Path "HKLM:\System\Maps" ChinaVariant -Force -Value 1
Set-Culture zh-CN
Set-WinHomeLocation -GeoId 45 # China(45)/Hong Kong(104)
Set-WinSystemLocale -SystemLocale zh-CN
$LanguageList = Get-WinUserLanguageList ; $LanguageList.Add("zh-CN")
Set-WinUserLanguageList -LanguageList $LanguageList -Force