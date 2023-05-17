function addEnglish {
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
}

function addHebrew {
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

}   

function addChinese {
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
}

Function Menu {
    if ( (Test-NetConnection -InformationLevel Quiet) -ne "True" ) 
    { Write-Host -ForegroundColor RED "you are not connected to the internet" ; break }
    Clear-Host        
    Do {
        Clear-Host                                                                       
        Write-Host  -Object ''
        Write-Host "================ Adding Windows 10 Capabilities/Features ================"
        Write-Host  ''
        Write-Host -NoNewline -ForegroundColor Red '  E' ; Write-Host -ForegroundColor Cyan 'nglish MUI'
        Write-Host -NoNewline -ForegroundColor Red '  C' ; Write-Host -ForegroundColor Cyan 'hinese MUI'
        Write-Host -NoNewline -ForegroundColor Red '  H' ; Write-Host -ForegroundColor Cyan 'ebrew  MUI'
        Write-Host  ''
        Write-Host -NoNewline -ForegroundColor Red '  Q' ; Write-Host -ForegroundColor Cyan 'uit'
        Write-Host  ''
        Write-Host -Object $errout
        $Menu = Read-Host -Prompt 'Choose option'
 
        switch ($Menu) {
            E { addEnglish  ; anyKey }
            H { addHebrew   ; anyKey }
            C { addChinese  ; anyKey }
            Q { break }   
            default { $errout = 'Invalid option, try again' }
        }
    }
    until ($Menu -eq 'q')
}   

Menu
