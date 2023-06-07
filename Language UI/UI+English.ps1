$CapabilityList = 
@(
    "Language.Basic~~~en-US~0.0.1.0",
    "Language.Handwriting~~~zh-CN~0.0.1.0",
    "Language.OCR~~~en-US~0.0.1.0",
    "Language.Speech~~~en-US~0.0.1.0",
    "Language.TextToSpeech~~~en-US~0.0.1.0"
    "Language.Fonts.PanEuropeanSupplementalFonts~~~~0.0.1.0"
)
foreach ($Capability in $CapabilityList) { Add-WindowsCapability -Online -Name $Capability }
Set-Culture en-US
Set-WinHomeLocation -GeoId 244 # US
Set-WinSystemLocale -SystemLocale en-US
$LanguageList = Get-WinUserLanguageList ; $LanguageList.Add("en-US")
Set-WinUserLanguageList -LanguageList $LanguageList -Force
Set-WinDefaultInputMethodOverride -InputTip "0409:00000409"