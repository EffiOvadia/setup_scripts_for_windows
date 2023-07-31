
$URI = "https://github.com/tonsky/FiraCode/releases/download/6.2/Fira_Code_v6.2.zip"

#$URI = "https://github.com/microsoft/cascadia-code/releases/download/v2111.01/CascadiaCode-2111.01.zip"
Invoke-WebRequest -Uri $URI -OutFile $env:temp\fonts.zip
Expand-Archive -Path $env:temp\fonts.zip -DestinationPath $env:temp -Force
$fonts = Get-ChildItem -Path $env:temp\ttf -Filter *.ttf
foreach ($font in $fonts) 
    { Copy-Item $font.FullName -Destination $env:windir\Fonts -Force }
Remove-Item -Path $env:temp\fonts.zip -Force
Remove-Item -Path $env:temp\ttf -Recurse -Force







C:\Users\effio\AppData\Local\Microsoft\Windows\Fonts

New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts" -Name "$fontName (TrueType)" -Value $fontFile