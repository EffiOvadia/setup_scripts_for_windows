function DoH
{
  [cmdletbinding()] param([ValidateSet('Status','Enable','Disable')][string]$Action)
  $Build = [System.Environment]::OSVersion.Version.Build
  If ( $Build -lt 19628 ) { Write-Host "FYI: DoH reqiure build 19628 or above" }

  $Admin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]'Administrator')
  If ($Admin) {Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned -Force} else { Write-Host "Run as Admin"; Break }

  Switch ($Action) 
  {
    Status
    {
    }
    Enable
    {
      $DNSProviders = 
      @(
        [PSCustomObject]@{ Name='Cloudflare';IPv4='1.1.1.1,1.0.0.1';IPv6='2606:4700:4700::1111,2606:4700:4700::1001'; }
        [PSCustomObject]@{ Name='Google';IPv4='8.8.8.8,8.8.4.4';IPv6='2001:4860:4860::8888,2001:4860:4860::8844'; } 
        [PSCustomObject]@{ Name='Quad9';IPv4='9.9.9.9,149.112.112.112';IPv6='2620:fe::fe,2620:fe::fe:9'; }
      )
    
      $Menu = @{}; For ($i=1;$i -le $DNSProviders.Count; $i++) 
        { Write-Host "$i. $($DNSProviders.Name[$i-1])" $Menu.Add($i,($DNSProviders[$i-1])) }
      Write-Host '' ; [int]$X = Read-Host 'Choose Public DNS Provider'
    
      Foreach ( $IFace in $(Get-NetAdapter -Physical | Where-Object Status -eq 'up').IfIndex ) 
      { Set-DnsClientServerAddress -InterfaceIndex $IFace -ServerAddresses $DNSProviders[$X].IPv4,$DNSProviders[$X].IPv6 }

      Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" EnableAutoDOH -Force -Value "2"

      Clear-DnsClientCache
      ### pktmon filter remove ; pktmon filter add -p 53 ; pktmon start --etw -l real-time
      Write-Host 'In order to check if DoH is working, please run the following command:'
      Write-Host 'pktmon filter remove ; pktmon filter add -p 53 ; pktmon start --etw -l real-time'
    }
    Disable
    {
      Set-DnsClientServerAddress -InterfaceIndex $IFace -ResetServerAddresses
    }
  }
}

