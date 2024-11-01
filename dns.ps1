# Verification
#Get-DnsClientDohServerAddress

#@ Create a list of all physical network interfaces
$DisabledNICs = ( Get-NetAdapter -Physical | Where-Object Status -eq Disabled )
If ( $DisabledNICs ) { Enable-NetAdapter -InterfaceDescription $DisabledNICs.InterfaceDescription }
$NICs = ( Get-NetAdapter -Physical | Where-Object Status -ne Disabled )
$NICs | Format-Table -AutoSize

#@ Create an array to hold the list of DoH servers
$List = @()
#$List += [PSCustomObject]@{ Name = "Mullvad"; PrimaryIPv4 = "194.242.2.4"; PrimaryIPv6 = "2a07:e340::4"; DoH = "https://base.dns.mullvad.net/dns-query"}
$List += [PSCustomObject]@{ Name = "Cloudflare"; PrimaryIPv4 = "1.1.1.1"; SecondaryIPv4 = "1.0.0.1"; PrimaryIPv6 = "2606:4700:4700::1111"; SecondaryIPv6 = "2606:4700:4700::1001"; DoH = "https://cloudflare-dns.com/dns-query"}
$List += [PSCustomObject]@{ Name = "Google"; PrimaryIPv4 = "8.8.8.8"; SecondaryIPv4 = "8.8.4.4"; PrimaryIPv6 = "2001:4860:4860::8888"; SecondaryIPv6 = "2001:4860:4860::8844"; DoH = "https://dns.google/dns-query"}
$List += [PSCustomObject]@{ Name = "Quad9"; PrimaryIPv4 = "9.9.9.9"; SecondaryIPv4 = "149.112.112.112"; PrimaryIPv6 = "2620:fe::9"; SecondaryIPv6 = "2620:fe::fe"; DoH = "https://dns.quad9.net/dns-query"}
$List += [PSCustomObject]@{ Name = "NextDNS"; PrimaryIPv4 = "45.90.28.0"; SecondaryIPv4 = "45.90.30.0"; PrimaryIPv6 = "2a07:a8c0::7e:d392"; SecondaryIPv6 = "2a07:a8c1::7e:d392"; DoH = "https://dns.nextdns.io/7ed392"}
$List | Format-Table -AutoSize


$Providers = $List.Name 
Write-Host '' ; Write-Host '' 
$Menu = @{} ; $i = 0 
ForEach ( $Provider in $Providers ) { $i++ ; Write-Host "$i. $Provider", $menu.Add($i, $Provider) }
Write-Host '' ; [int]$answer = Read-Host 'Choose DoH Provider' ; $Provider = $menu[$answer]; 
$SelectedProvider = $List | Where-Object { $_.Name  -eq $Provider }
ForEach ( $NIC in $NICs ) 
{
  Set-DnsClientServerAddress -InterfaceAlias $NIC.InterfaceAlias  -ServerAddresses @($SelectedProvider.PrimaryIPv4, $SelectedProvider.SecondaryIPv4)
  Set-DnsClientServerAddress -InterfaceAlias $NIC.InterfaceAlias  -ServerAddresses @($SelectedProvider.PrimaryIPv6, $SelectedProvider.SecondaryIPv6)
}

if ( $(Get-DnsClientDohServerAddress).ServerAddress ) { Remove-DnsClientDohServerAddress $(Get-DnsClientDohServerAddress).ServerAddress }
Add-DnsClientDohServerAddress -ServerAddress $SelectedProvider.PrimaryIPv4 -DohTemplate $SelectedProvider.DoH -AllowFallbackToUdp $false
Add-DnsClientDohServerAddress -ServerAddress $SelectedProvider.SecondaryIPv4 -DohTemplate $SelectedProvider.DoH -AllowFallbackToUdp $false
Add-DnsClientDohServerAddress -ServerAddress $SelectedProvider.PrimaryIPv6 -DohTemplate $SelectedProvider.DoH -AllowFallbackToUdp $false
Add-DnsClientDohServerAddress -ServerAddress $SelectedProvider.SecondaryIPv6 -DohTemplate $SelectedProvider.DoH -AllowFallbackToUdp $false
Get-DnsClientDohServerAddress

#@
If ( $DisabledNICs ) { Disable-NetAdapter -InterfaceDescription $DisabledNICs -Confirm:$false }

Clear-DnsClientCache;

push-location 'HKLM:\System\CurrentControlSet\Services\Dnscache\InterfaceSpecificParameters\' + $NICs[0].InterfaceGuid + '\DohInterfaceSettings\'

Push-Location -path HKLM:System\CurrentControlSet\Services\Dnscache\InterfaceSpecificParameters\' + $NIC.InterfaceGuid + '\DohInterfaceSettings\
if ( -not(Test-Path ".\Psched\") ) { New-Item -Path ".\Psched\" }
Set-ItemProperty -Path ".\Psched" NonBestEffortLimit -Force -Value 0
Pop-Location