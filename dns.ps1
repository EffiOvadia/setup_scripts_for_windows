
#@ Verification
#Get-DnsClientDohServerAddress

#@ Create an array to hold the list of DoH servers
$List = @()
$List += [PSCustomObject]@{ Name = "Cloudflare"; PrimaryIPv4 = "1.1.1.1"; SecondaryIPv4 = "1.0.0.1"; PrimaryIPv6 = "2606:4700:4700::1111"; SecondaryIPv6 = "2606:4700:4700::1001"; DoH = "https://cloudflare-dns.com/dns-query"}
$List += [PSCustomObject]@{ Name = "Google"; PrimaryIPv4 = "8.8.8.8"; SecondaryIPv4 = "8.8.4.4"; PrimaryIPv6 = "2001:4860:4860::8888"; SecondaryIPv6 = "2001:4860:4860::8844"; DoH = "https://dns.google/dns-query"}
$List += [PSCustomObject]@{ Name = "Quad9"; PrimaryIPv4 = "9.9.9.9"; SecondaryIPv4 = "149.112.112.112"; PrimaryIPv6 = "2620:fe::9"; SecondaryIPv6 = "2620:fe::fe"; DoH = "https://dns.quad9.net/dns-query"}
$List += [PSCustomObject]@{ Name = "NextDNS"; PrimaryIPv4 = "45.90.28.0"; SecondaryIPv4 = "45.90.30.0"; PrimaryIPv6 = "2a07:a8c0::7e:d392"; SecondaryIPv6 = "2a07:a8c1::7e:d392"; DoH = "https://dns.nextdns.io/7ed392"}
#$List | Format-Table -AutoSize

#@ Create menu to choose DoH Provider
Write-Host '' ; Write-Host '' 
$Menu = @{} ; $i = 0 
ForEach ( $Provider in $List.Name ) { $i++ ; Write-Host "$i. $Provider", $menu.Add($i, $Provider) }
Write-Host '' ; [int]$answer = Read-Host 'Choose DoH Provider' ; $Provider = $menu[$answer]
$S = $List | Where-Object { $_.Name  -eq $Provider }

#@ Clean all DoH template from the computer
if ( $(Get-DnsClientDohServerAddress).ServerAddress ) 
  { Remove-DnsClientDohServerAddress $(Get-DnsClientDohServerAddress).ServerAddress }

#@ Associate DoH template with DoH server IP addresses
$S.PrimaryIPv4, $S.SecondaryIPv4, $S.PrimaryIPv6, $S.SecondaryIPv6 | 
  ForEach-Object { Add-DnsClientDohServerAddress -ServerAddress $_ -DohTemplate $S.DoH -AllowFallbackToUdp $false }

#@ Create a list of all physical network interfaces
$DisabledNICs = ( Get-NetAdapter -Physical | Where-Object Status -eq Disabled )
If ( $DisabledNICs ) { Enable-NetAdapter -InterfaceDescription $DisabledNICs.InterfaceDescription }
$NICs = ( Get-NetAdapter -Physical | Where-Object Status -ne Disabled )
#$NICs | Format-Table -AutoSize
$NICs | ForEach-Object {
  Set-DnsClientServerAddress $_.InterfaceAlias -ServerAddresses @($S.PrimaryIPv4, $S.SecondaryIPv4)
  Set-DnsClientServerAddress $_.InterfaceAlias -ServerAddresses @($S.PrimaryIPv6, $S.SecondaryIPv6)
  $Path = 'HKLM:System\CurrentControlSet\Services\Dnscache\InterfaceSpecificParameters\' + $_.InterfaceGuid + '\DohInterfaceSettings\'
  $P = $Path + 'DoH\'  + $S.PrimaryIPv4   ; New-Item -Path $P -Force | New-ItemProperty -Name "DohFlags" -Value 17 -PropertyType QWORD
  $P = $Path + 'DoH\'  + $S.SecondaryIPv4 ; New-Item -Path $P -Force | New-ItemProperty -Name "DohFlags" -Value 17 -PropertyType QWORD
  $P = $Path + 'DoH6\' + $S.PrimaryIPv6   ; New-Item -Path $P -Force | New-ItemProperty -Name "DohFlags" -Value 17 -PropertyType QWORD
  $P = $Path + 'DoH6\' + $S.SecondaryIPv6 ; New-Item -Path $P -Force | New-ItemProperty -Name "DohFlags" -Value 17 -PropertyType QWORD
  }

#@ Clearing the DNS Cache
Clear-DnsClientCache

#@ Returning NICs to the original state if it was Disabled 
If ( $DisabledNICs ) { Disable-NetAdapter -InterfaceDescription $DisabledNICs -Confirm:$false }
