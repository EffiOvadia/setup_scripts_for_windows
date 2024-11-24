#@ Install Latest Microsoft Powershell
winget install --accept-package-agreements --accept-source-agreements --exact --ID Microsoft.PowerShell
#@ Add windows capability: OpenSSH Client & Server 
If ($(Get-WindowsCapability -Online -Name OpenSSH.Client~~~~0.0.1.0).state -ne "Installed") 
  {Add-WindowsCapability -Online -Name OpenSSH.Client~~~~0.0.1.0}
If ($(Get-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0).state -ne "Installed")
  {Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0}
#@ Set SSH server and SSH agent startup mode 
if ($(Get-Service -Name SSHd) ) {Set-Service -Name SSHd -StartupType Automatic}
if ($(Get-Service -Name SSH-Agent)) {Set-Service -Name SSH-Agent -StartupType Disable}
#@ Set Default shell for SSH server to PowerShell 
if ($(Test-Path "$env:ProgramFiles\PowerShell\7\pwsh.exe"))
  {$Shell = "$env:ProgramFiles\PowerShell\7\pwsh.exe"} else
  {$Shell = "$env:windir\System32\WindowsPowerShell\v1.0\powershell.exe"}
if ($(Test-Path HKLM:\SOFTWARE\OpenSSH)) 
  {
  $Path = "HKLM:\SOFTWARE\OpenSSH"
  New-ItemProperty $Path -Force -Name DefaultShell -Value "$Shell" -PropertyType String 
  New-ItemProperty $Path -Force -Name DefaultShellCommandOption -Value "/c" -PropertyType String
  }
#@ Adding firewall rule if needed 
If (!((Get-NetFirewallRule).Name -like "*SSH*")) 
  {
  $FW_RuleParameters_SSH =
    @{  
      Name        = "OpenSSH-Server-In-TCP"
      Group       = "OpenSSH Server"
      DisplayName = "OpenSSH Server (sshd)"
      Program     = "$ENV:windir\System32\OpenSSH\sshd.exe"
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
#@ Configure SSH server to accept public key auth 
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
Set-Content "$env:ProgramData\ssh\sshd_config" -Value $FileContent
$ACL = Get-Acl "$env:ProgramData\ssh\sshd_config"
$ACL.SetSecurityDescriptorSddlForm('O:SYG:SYD:PAI(A;;FA;;;SY)(A;;FA;;;BA)')
$ACL | Set-Acl
#@ Add Public keys to OpenSSH server for all local administrators 
$FileContent = 
  (
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILNCmaqfNc79iOZbqScO8uLDWBhHRMHUAEbUq3/PR9zj b3:2e:97:e8:bb:f8:1a:20:a7:93:c7:cf:09:f2:a6:88",
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINLsYdvM7AR00BBSr+xKW90blD7wX8WRFXxr2Y6L/uHG dd:f2:f2:33:65:92:40:5b:0f:7b:07:0a:47:f4:da:c8"
  )
Set-Content "$env:ProgramData\ssh\administrators_authorized_keys" -Value $FileContent
$ACL = Get-Acl "$env:ProgramData\ssh\administrators_authorized_keys"
$ACL.SetSecurityDescriptorSddlForm('O:SYG:SYD:PAI(A;;FA;;;SY)(A;;FA;;;BA)') 
$ACL | Set-Acl
#@ Restart the SSH Server
Restart-Service -Name SSHd
Stop-Service -Name SSH-Agent
