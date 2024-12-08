#@ Install Latest Microsoft Powershell
if (!(Get-Command pwsh -ErrorAction SilentlyContinue)) 
  {winget install --accept-package-agreements --accept-source-agreements --exact --ID "Microsoft.PowerShell"}
#@ Add windows capability: OpenSSH Client & Server 
If ((Get-WindowsCapability -Online -Name OpenSSH.Client~~~~0.0.1.0).state -ne "Installed")
  {Add-WindowsCapability -Online -Name OpenSSH.Client~~~~0.0.1.0}
If ((Get-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0).state -ne "Installed")
  {Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0}
#@ Set SSH server and SSH agent startup mode 
Get-Service -Name SSHd -ErrorAction SilentlyContinue | Set-Service -StartupType Automatic
Get-Service -Name SSH-Agent -ErrorAction SilentlyContinue | Set-Service -StartupType Disable
#@ Set Default shell for SSH server to PowerShell 
$Shell =
@(
    "$env:ProgramFiles\PowerShell\7\pwsh.exe",
    "$env:LocalAppData\Microsoft\WindowsApps\pwsh.exe",
    "$env:WinDir\System32\WindowsPowerShell\v1.0\powershell.exe"
) | Where-Object {Test-Path $_} | Select-Object -First 1
if ($Shell) 
{
  if (Test-Path HKLM:\SOFTWARE\OpenSSH)
  {
  $Path = "HKLM:\SOFTWARE\OpenSSH"
  New-ItemProperty $Path -Force -Name DefaultShell -Value "$Shell" -PropertyType String 
  New-ItemProperty $Path -Force -Name DefaultShellCommandOption -Value "/c" -PropertyType String
  }
}
#@ Adding/Modifing firewall rule if needed 
$RuleName = "OpenSSH-Server-In-TCP"
$FWrule = Get-NetFirewallRule -Name $RuleName -ErrorAction SilentlyContinue
if ($FWrule) 
{
    Set-NetFirewallRule `
      -Name $RuleName `
      -Description "Inbound rule for OpenSSH SSH Server (sshd)" `
      -Program "$ENV:windir\System32\OpenSSH\sshd.exe" `
      -Profile Domain,Private,Public `
      -Direction Inbound `
      -Protocol TCP `
      -Action Allow `
      -LocalPort 22 `
      -Enable True 
} else 
{
  $FW_RuleParameters = 
    @{
        Name        = $RuleName
        Group       = "OpenSSH Server"
        DisplayName = "OpenSSH Server (sshd)"
        Description = "Inbound rule for OpenSSH SSH Server (sshd)"
        Program     = "$ENV:windir\System32\OpenSSH\sshd.exe"
        Profile     = "Domain, Private, Public"
        Direction   = "Inbound"
        Protocol    = "TCP"
        Action      = "Allow"
        LocalPort   = "22"
        Enable      = "True"
    }
    New-NetFirewallRule @FW_RuleParameters
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
Set-Content -Path "$env:ProgramData\ssh\sshd_config" -Value $FileContent
#@ Set ACL permission for sshd_config
$ACL = Get-Acl "$env:ProgramData\ssh\sshd_config"
$ACL.SetSecurityDescriptorSddlForm('O:SYG:SYD:PAI(A;;FA;;;SY)(A;;FA;;;BA)')
$ACL | Set-Acl
#@ Add Public keys to OpenSSH server for all local administrators 
$Key1 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILNCmaqfNc79iOZbqScO8uLDWBhHRMHUAEbUq3/PR9zj"
Add-Content -Path "$env:ProgramData\ssh\administrators_authorized_keys" -Value $Key1
$Key2 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINLsYdvM7AR00BBSr+xKW90blD7wX8WRFXxr2Y6L/uHG"
Add-Content -Path "$env:ProgramData\ssh\administrators_authorized_keys" -Value $Key2
#@ Set ACL permission Authorized_Keys file
$ACL = Get-Acl "$env:ProgramData\ssh\administrators_authorized_keys"
$ACL.SetSecurityDescriptorSddlForm('O:SYG:SYD:PAI(A;;FA;;;SY)(A;;FA;;;BA)') 
$ACL | Set-Acl
#@ Restart the SSH Server
Get-Service -Name SSHd -ErrorAction SilentlyContinue | Restart-Service
Get-Service -Name SSH-Agent -ErrorAction SilentlyContinue | Stop-Service 