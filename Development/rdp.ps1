### Example of download and install command line:
#iex ((New-Object System.Net.WebClient).DownloadString('https://git.io/JJ8R4'))
using namespace System.Management.Automation.Host

$Password = Get-Content .\passwd.administrator.txt | ConvertTo-SecureString
if ( $Password ) { Enable-LocalUser -name Administrator && Set-LocalUser -Name "Administrator" -Password $Password }

Function RDP {
  ### Enable/Disable Remote Desktop Service
  [CmdletBinding()] Param([ValidateSet('Enable', 'Disable')][String]$Service, [ValidateRange(1024, 49151)][Int]$Port)
	
  $Admin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]'Administrator')
  If ( $Admin ) { Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned -Force } else { Write-Host "Run as Admin"; Break }

  Switch ( $Service ) {
    Enable {
      Push-Location "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server"
      Set-ItemProperty -Path . fDenyTSConnections -Force -Value 0
      Enable-NetFirewallRule -DisplayGroup "Remote Desktop" -ErrorAction SilentlyContinue
      #Enable-NetFirewallRule -Group "@FirewallAPI.dll,-28752"
					
      if ( $Port ) {
        if ( !$(Test-Path -Path ".\WinStations\RDP-Tcp-$Port\")) 
        { Copy-Item ".\WinStations\RDP-Tcp\" ".\WinStations\RDP-Tcp-$Port\" -Recurse }
        Set-ItemProperty -Path ".\WinStations\RDP-Tcp-$Port\" PortNumber -Force -Value $Port

        $FW_RuleParameters_RDP = 
        @{
          Name        = "RemoteDesktop-$Port"
          Group       = "@FirewallAPI.dll,-28752"
          DisplayName = "Remote Desktop - Alternate Port $Port"
          Description = "Inbound rule for the Remote Desktop service to allow RDP traffic. [TCP $Port]"
          Profile     = "Domain, Private, Public"
          Direction   = "Inbound"
          Protocol    = "TCP"
          Action      = "Allow"
          LocalPort   = "$Port"
          Enable      = "True" 
          Program     = "%SystemRoot%\system32\svchost.exe" 
        }
				
        if ( !$( (Get-NetFirewallRule).Name -like $FW_RuleParameters_RDP.name ) ) 
        { New-NetFirewallRule @FW_RuleParameters_RDP } 
        #else { Get-NetFirewallRule -Name $FW_RuleParameters_RDP.name }				
      }
      Restart-Service -Force -DisplayName "Remote Desktop Services"
      Pop-Location
    }		
		
    Disable {
      Push-Location "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server"
      Set-ItemProperty -Path . fDenyTSConnections -Force -Value 1
      Disable-NetFirewallRule -DisplayGroup "Remote Desktop"
      Stop-Service -Force -DisplayName "Remote Desktop Services"
      Pop-Location
    }
		
    Default {
      Push-Location "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server"
      $Status = $(Get-ItemProperty -Path . fDenyTSConnections).fDenyTSConnections
      Switch ($Status) {
        0 { Write-Host "Enabled" }
        1 { Write-Host "Disabled" }
      }
      Pop-Location
    }
  }
}
