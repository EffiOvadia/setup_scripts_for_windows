Function PrintColorPallet {
    Clear-Host
    Write-Host ''
    Write-Host " Solarized color codes: 
 
 | SOLARIZED | HEX     | ANSI      | TERMCOL   | cmd.exe     | PowerShell  | ColorTable | DWORD    |
 |-----------|---------|-----------|-----------|-------------|-------------|------------|----------|
 | base03    | #002b36 | ESC[0;30m | brblack   | Black       | Black       | 00         | 00362b00 |
 | base02    | #073642 | ESC[1;30m | black     | Gray        | DarkGray    | 08         | 00423607 |
 | base01    | #586e75 | ESC[0;32m | brgreen   | Green       | DarkGreen   | 02         | 00756e58 |
 | base00    | #657b83 | ESC[0;33m | bryellow  | Yellow      | DarkYellow  | 06         | 00837b65 |
 | base0     | #839496 | ESC[0;34m | brblue    | Blue        | DarkBlue    | 01         | 00969483 |
 | base1     | #93a1a1 | ESC[0;36m | brcyan    | Aqua        | DarkCyan    | 03         | 00a1a193 |
 | base2     | #eee8d5 | ESC[0;37m | white     | White       | Gray        | 07         | 00d5e8ee |
 | base3     | #fdf6e3 | ESC[1;37m | brwhite   | BrightWhite | White       | 15         | 00e3f6fd |
 | yellow    | #b58900 | ESC[1;33m | yellow    | LightYellow | Yellow      | 14         | 000089b5 |
 | orange    | #cb4b16 | ESC[0;31m | brred     | Red         | DarkRed     | 04         | 00164bcb |
 | red       | #dc322f | ESC[1;31m | red       | LightRed    | Red         | 12         | 002f32dc |
 | magenta   | #d33682 | ESC[1;35m | magenta   | LightPurple | Magenta     | 13         | 008236d3 |
 | violet    | #6c71c4 | ESC[0;35m | brmagenta | Purple      | DarkMagenta | 05         | 00c4716c |
 | blue      | #268bd2 | ESC[1;34m | blue      | LightBlue   | Blue        | 09         | 00d28b26 |
 | cyan      | #2aa198 | ESC[1;36m | cyan      | LightAqua   | Cyan        | 11         | 0098a12a |
 | green     | #859900 | ESC[1;32m | green     | LightGreen  | Green       | 10         | 00009985 |
 
"
}
Function ConsoleProperties { ### Console Settings
    Set-ItemProperty . -Force -Name ForceV2                   -Value 1
    Set-ItemProperty . -Force -Name ExtendedEditKey           -Value 1
    Set-ItemProperty . -Force -Name CurrentPage               -Value 1
    Set-ItemProperty . -Force -Name InsertMode                -Value 1
    Set-ItemProperty . -Force -Name QuickEdit                 -Value 1
    Set-ItemProperty . -Force -Name ScreenBufferSize          -Value 1638510
    Set-ItemProperty . -Force -Name WindowSize                -Value 1638510
    Set-ItemProperty . -Force -Name WindowPosition            -Value 1310740
    Set-ItemProperty . -Force -Name FontSize                  -Value 1572864
    Set-ItemProperty . -Force -Name FontFamily                -Value 54
    Set-ItemProperty . -Force -Name FontWeight                -Value 700
    Set-ItemProperty . -Force -Name FaceName                  -Value Consolas
    Set-ItemProperty . -Force -Name CursorSize                -Value 100
    Set-ItemProperty . -Force -Name HistoryBufferSize         -Value 700
    Set-ItemProperty . -Force -Name NumberOfHistoryBuffers    -Value 4
    Set-ItemProperty . -Force -Name HistoryNoDup              -Value 1
    Set-ItemProperty . -Force -Name LineWrap                  -Value 1
    Set-ItemProperty . -Force -Name FilterOnPaste             -Value 1
    Set-ItemProperty . -Force -Name CtrlKeyShortcutsDisabled  -Value 0
    Set-ItemProperty . -Force -Name LineSelection             -Value 1
    Set-ItemProperty . -Force -Name WindowAlpha               -Value 231
}
Function SolarizedColor { ### Solarized Color Palette 
    Write-Host "use color 81 for dark or color F6 for light"
    Set-ItemProperty . -Force -Name ColorTable00 -Value 03549952
    Set-ItemProperty . -Force -Name ColorTable01 -Value 09868419
    Set-ItemProperty . -Force -Name ColorTable02 -Value 07695960
    Set-ItemProperty . -Force -Name ColorTable03 -Value 10592659
    Set-ItemProperty . -Force -Name ColorTable04 -Value 01461195
    Set-ItemProperty . -Force -Name ColorTable05 -Value 12874092
    Set-ItemProperty . -Force -Name ColorTable06 -Value 08616805
    Set-ItemProperty . -Force -Name ColorTable07 -Value 14018798
    Set-ItemProperty . -Force -Name ColorTable08 -Value 04339207
    Set-ItemProperty . -Force -Name ColorTable09 -Value 13798182
    Set-ItemProperty . -Force -Name ColorTable10 -Value 00039301
    Set-ItemProperty . -Force -Name ColorTable11 -Value 10002730
    Set-ItemProperty . -Force -Name ColorTable12 -Value 03093212
    Set-ItemProperty . -Force -Name ColorTable13 -Value 08533715
    Set-ItemProperty . -Force -Name ColorTable14 -Value 00035253
    Set-ItemProperty . -Force -Name ColorTable15 -Value 14939901
}
Function DefaultColor { ### Windows Default Color Pallete 
    Set-ItemProperty . -Force -Name ColorTable00 -Value 00000000
    Set-ItemProperty . -Force -Name ColorTable01 -Value 00800000
    Set-ItemProperty . -Force -Name ColorTable02 -Value 00008000
    Set-ItemProperty . -Force -Name ColorTable03 -Value 00808000
    Set-ItemProperty . -Force -Name ColorTable04 -Value 00000080
    Set-ItemProperty . -Force -Name ColorTable05 -Value 00800080
    Set-ItemProperty . -Force -Name ColorTable06 -Value 00008080
    Set-ItemProperty . -Force -Name ColorTable07 -Value 00c0c0c0
    Set-ItemProperty . -Force -Name ColorTable08 -Value 00808080
    Set-ItemProperty . -Force -Name ColorTable09 -Value 00ff0000
    Set-ItemProperty . -Force -Name ColorTable10 -Value 0000ff00
    Set-ItemProperty . -Force -Name ColorTable11 -Value 00ffff00
    Set-ItemProperty . -Force -Name ColorTable12 -Value 000000ff
    Set-ItemProperty . -Force -Name ColorTable13 -Value 00ff00ff
    Set-ItemProperty . -Force -Name ColorTable14 -Value 0000ffff
    Set-ItemProperty . -Force -Name ColorTable15 -Value 00ffffff
}
Function DarkTheme { ### Set Solarized Dark Theme
    #Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Command Processor" DefaultColor -Force 81
    Set-ItemProperty . -Force -Name ScreenColors -Value 1
    Set-ItemProperty . -Force -Name PopupColors  -Value 00000246
}
Function LightTheme { ### Set Solarized Light Theme
    #Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Command Processor" DefaultColor -Force F6
    Set-ItemProperty . -Force -Name ScreenColors -Force 00000246
    Set-ItemProperty . -Force -Name PopupColors -Force 1
}

Push-Location 
Set-Location "HKCU:\Console"
ConsoleProperties ; SolarizedColor ; DarkTheme
Set-Location "HKCU:\Console\%SystemRoot%_System32_WindowsPowerShell_v1.0_powershell.exe"
ConsoleProperties ; SolarizedColor ; DarkTheme
Set-Location "HKCU:\Console\%SystemRoot%_SysWOW64_WindowsPowerShell_v1.0_powershell.exe"
ConsoleProperties ; SolarizedColor ; DarkTheme
Pop-Location

### DefaultTheme
### Set-ItemProperty . -Force -Name ScreenColors 00000007
### Set-ItemProperty . -Force -Name PopupColors 000000f5