### Adding Hebrew laguage Windows Capability
$CapabilityList = @(
	"Language.Basic~~~he-IL~0.0.1.0", 
	"Language.Fonts.Hebr~~~und-HEBR~0.0.1.0",
	"Language.TextToSpeech~~~he-IL~0.0.1.0",
	"Language.UI.Client~~~he-IL~"  )
foreach ($Capability in $CapabilityList) { Add-WindowsCapability -Online -Name $Capability }

###   Adding Chinese language Windows Capability
$CapabilityList = @(
	"Language.Basic~~~zh-CN~0.0.1.0",
	"Language.Handwriting~~~zh-CN~0.0.1.0",
	"Language.OCR~~~zh-CN~0.0.1.0",
	"Language.Speech~~~zh-CN~0.0.1.0",
	"Language.TextToSpeech~~~zh-CN~0.0.1.0",
	"Language.UI.Client~~~zh-CN~" )
foreach ($Capability in $CapabilityList) { Add-WindowsCapability -Online -Name $Capability }
Set-ItemProperty -Path "HKLM:\System\Maps" ChinaVariant -Force -Value 1
