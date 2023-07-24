
### Create a persisted mapped network drive
if ((Test-Path \\DC1\Public)        -and (!$(Test-Path P:))) {New-PSDrive -Persist -PSProvider FileSystem -Name P -Root \\DC1\Public}
if ((Test-Path \\DC1\$env:username) -and (!$(Test-Path U:))) {New-PSDrive -Persist -PSProvider FileSystem -Name U -Root \\DC1\$env:username}


### Alternate methood
$Net = New-Object -ComObject WScript.Network

if ($(Test-Path P:)) {$Net.RemoveNetworkDrive('P:',$true)}
if ((Test-Path \\DC1\Public) -and (!$(Test-Path P:))) { $Net.MapNetworkDrive("P:","\\DC1\public",$true) } 

if ($(Test-Path U:)) {$Net.RemoveNetworkDrive('U:',$true)}
if ((Test-Path \\DC1\$env:username) -and (!$(Test-Path U:))) { $Net.MapNetworkDrive("U:","\\DC1\$env:username",$true) }

#@ -----------------------------------------------------------------------

#@ Subst OneDrive 
New-PSDrive -Name M -PSProvider FileSystem -Root $env:USERPROFILE\OneDrive
Remove-PSDrive -Name M

Invoke-Expression "subst M: $env:USERPROFILE\OneDrive"
Invoke-Expression "subst M: /D"

#@ Mapping Cloud OneDrive

#   https://d.docs.live.net/2791EF2DF0F9C6DF

$cred     = get-credential 

$drive    = "M:"
$CID      = "2791EF2DF0F9C6DF"
$path     = "https://d.docs.live.net/$CID"
$userName = $cred.GetNetworkCredential().UserName
$password = $cred.GetNetworkCredential().Password

Start-Process $path 

$Network  = New-Object -ComObject WScript.Network
$Network.MapNetworkDrive($drive,$path,$true,$userName,$password)

