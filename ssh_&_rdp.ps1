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

Function OpenSSH {
  #/ Install/Remove OpenSSH service
  [cmdletbinding()] param([ValidateSet('Install', 'Set', 'Uninstall')][string]$Action)

  #/ Check if running as Administrator and setting Execution Policy for scripts
  $Admin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]'Administrator')
  If ($Admin) { Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned -Force } else { Write-Host "Run as Admin"; Break }

  Switch ($Action) {
    Install {
      #/ Enable/Install Linux Subsystem feature
      if ( $(Get-WindowsOptionalFeature -Online -FeatureName "Microsoft-Windows-Subsystem-Linux").state -ne "Enabled" ) 
      { Enable-WindowsOptionalFeature -NoRestart -Online -FeatureName "Microsoft-Windows-Subsystem-Linux" -All }
      #/ Add windows capability: OpenSSH Client
      If ( $(Get-WindowsCapability -Online -Name OpenSSH.Client~~~~0.0.1.0).state -ne "Installed" ) 
      { Add-WindowsCapability -Online -Name OpenSSH.Client~~~~0.0.1.0 }
      #/ Add windows capability: OpenSSH Server
      If ( $(Get-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0).state -ne "Installed" )
      { Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0 }
      #/  
      Clear-Host ; Write-Host "Restart Required"
    }

    Set {
      #/ Rebooting the system if needed
      if ( $(Get-PackageProvider).name -NotContains "NuGet" ) { Install-PackageProvider -Name NuGet -Force }
      if ( $(Get-Module).name -NotContains "PendingReboot" ) { Install-Module -Name PendingReboot -Force }
      if ( (Test-PendingReboot -SkipConfigurationManagerClientCheck).IsRebootPending ) 
      { Write-Host "Restart Required" ; break }
            
      #/ Set OpenSSH Service to start Automaticly
      if ( $(Get-Service -Name SSHd ) ) { Set-Service -Name SSHd -StartupType Automatic ; Restart-Service -Name SSHd }
      if ( $(Get-Service -Name SSH-Agent ) ) { Set-Service -Name SSH-Agent -StartupType disable ; Stop-Service -Name SSH-Agent }

      #/ Set PowerShell as default SSH shell
      if ( $(Test-Path HKLM:\SOFTWARE\OpenSSH) ) {
        $Path = "HKLM:\SOFTWARE\OpenSSH"
        $Shell = "$ENV:Windir\System32\WindowsPowerShell\v1.0\powershell.exe"
        
        New-ItemProperty $Path -Force -Name DefaultShell -Value "$Shell" -PropertyType String 
        New-ItemProperty $Path -Force -Name DefaultShellCommandOption -Value "/c" -PropertyType String
      }
			
      #/ Adding firewall rule if needed 
      If ( !((Get-NetFirewallRule).Name -like "*SSH*") ) {
        $FW_RuleParameters_SSH =
        @{  
          Name        = "OpenSSH-Server-In-TCP"
          Group       = "OpenSSH Server"
          DisplayName = "OpenSSH Server (sshd)"
          Program     = "$ENV:WinDir\System32\OpenSSH\sshd.exe"
          Description = "Inbound rule for OpenSSH SSH Server (sshd)"
          Profile     = "Domain, Private, Public"
          Direction   = "Inbound"
          Protocol    = "TCP"
          Action      = "Allow"
          LocalPort   = "22"
          Enable      = "True"
        }
        New-NetFirewallRule @FW_RuleParameters_SSH
      }

      #/ Remove Legacy module from previous setup (if Exist)
      If ( Get-Module -ListAvailable -Name OpenSSHUtils ) { Uninstall-Module -Name OpenSSHUtils }
    
      #@ -------------------------------------------------------
      $FileContent = 
      (
        "PubkeyAuthentication   yes",
        "AuthorizedKeysFile     .ssh/authorized_keys",
        "PasswordAuthentication No",
        "Subsystem              sftp sftp-server.exe",
        "Subsystem              powershell %SystemRoot%\system32\WindowsPowerShell\v1.0\powershell.exe -sshs -NoLogo -NoProfile",
        "Match                  Group administrators",
        "AuthorizedKeysFile     __PROGRAMDATA__/ssh/administrators_authorized_keys"
      )
      Set-Content "$ENV:ProgramData\ssh\sshd_config" -Value $FileContent
      $ACL = Get-Acl "$ENV:ProgramData\ssh\sshd_config"
      $ACL.SetSecurityDescriptorSddlForm('O:SYG:SYD:PAI(A;;FA;;;SY)(A;;FA;;;BA)')
      $ACL | Set-Acl
      #@ -------------------------------------------------------
      $FileContent = 
      (
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILNCmaqfNc79iOZbqScO8uLDWBhHRMHUAEbUq3/PR9zj b3:2e:97:e8:bb:f8:1a:20:a7:93:c7:cf:09:f2:a6:88",
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINLsYdvM7AR00BBSr+xKW90blD7wX8WRFXxr2Y6L/uHG dd:f2:f2:33:65:92:40:5b:0f:7b:07:0a:47:f4:da:c8"
      )
      Set-Content "$ENV:ProgramData\ssh\administrators_authorized_keys" -Value $FileContent
      $ACL = Get-Acl "$ENV:ProgramData\ssh\administrators_authorized_keys"
      $ACL.SetSecurityDescriptorSddlForm('O:SYG:SYD:PAI(A;;FA;;;SY)(A;;FA;;;BA)')
      $ACL | Set-Acl
      #@ -------------------------------------------------------
      Restart-Service -Name SSHd
      #Explorer.exe /SELECT,$Target
    }

    Uninstall { 
      ### Set OpenSSH Service to start Automaticly
      if ( $(Get-Service -Name SSHd ) ) 
      { Set-Service -Name SSHd -StartupType disable ; Stop-Service -Name SSHd }
    
      if ( $(Get-Service -Name SSH-Agent ) ) 
      { Set-Service -Name SSH-Agent -StartupType disable ; Stop-Service -Name SSH-Agent }
    
      Remove-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
    } 

    Default {	
      if ( $(Get-Service -Name SSHd) ) { Write-Host "SSHd service installed" } 
    }
  }
}

Function Menu {
  $Title = " - Remote Desktop - "
  $Message = "Allow remote connection to the computer?"
  $Enable = [ChoiceDescription]::new('&Enable', 'Allow RDP & SSH connection')
  $Disable = [ChoiceDescription]::new('&Disable', 'Block RDP & SSH connection')
  $Options = [ChoiceDescription[]]($Enable, $Disable)
  $Result = $Host.UI.PromptForChoice($Title, $Message, $Options, 0) 
	
  Switch ($Result) {
    0 { RDP Enable ; OpenSSH Install ; OpenSSH Set }
    1 { RDP Disable ; OpenSSH remove }
  }
}

Clear-Host ; Menu
