
### Create a persisted mapped network drive
if ((Test-Path \\DC1\Public)        -and (!$(Test-Path P:))) {New-PSDrive -Persist -PSProvider FileSystem -Name P -Root \\DC1\Public}
if ((Test-Path \\DC1\$env:username) -and (!$(Test-Path U:))) {New-PSDrive -Persist -PSProvider FileSystem -Name U -Root \\DC1\$env:username}


### Alternate methood
$Net = New-Object -ComObject WScript.Network

if ($(Test-Path P:)) {$Net.RemoveNetworkDrive('P:',$true)}
if ((Test-Path \\DC1\Public) -and (!$(Test-Path P:))) { $Net.MapNetworkDrive("P:","\\DC1\public",$true) } 

if ($(Test-Path U:)) {$Net.RemoveNetworkDrive('U:',$true)}
if ((Test-Path \\DC1\$env:username) -and (!$(Test-Path U:))) { $Net.MapNetworkDrive("U:","\\DC1\$env:username",$true) }
