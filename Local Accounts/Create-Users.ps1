#$credential = Get-Credential
#$credential.Password | ConvertFrom-SecureString | Set-Content .\passwd.txt

### Enable Administrator and set the Password
Enable-LocalUser -name "Administrator"
$Password = Get-Content .\passwd.administrator.txt | ConvertTo-SecureString
Set-LocalUser -Name "Administrator" -Password $Password
if ( $(Get-LocalGroup).name -NotContains "OpenVPN Administrators" ) 
{ New-LocalGroup -Name "OpenVPN Administrators" }

$Computer = [ADSI]"WinNT://$Env:COMPUTERNAME,Computer"
$Password = Get-Content .\passwd.effio.txt | ConvertTo-SecureString
$NewUser = $computer.Create("User", "effio")
$NewUser.SetPassword($Password)     ; $NewUser.SetInfo()
$NewUser.FullName = "Effi Ovadia"   ; $NewUser.SetInfo()
$NewUser.Description = "IT Manager" ; $NewUser.SetInfo()
$NewUser.UserFlags = 64 + 65536     ; $NewUser.SetInfo() # Password: Can't change + Never expire
$Group = [ADSI]"WinNT://$Env:COMPUTERNAME/Power Users"            ; $Group.Add($NewUser.Path)
$Group = [ADSI]"WinNT://$Env:COMPUTERNAME/Remote Desktop Users"   ; $Group.Add($NewUser.Path)
$Group = [ADSI]"WinNT://$Env:COMPUTERNAME/OpenVPN Administrators" ; $Group.Add($NewUser.Path)
$Group = [ADSI]"WinNT://$Env:COMPUTERNAME/Administrators"         ; $Group.Add($NewUser.Path)

$User = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name

if ( $(Get-LocalGroupMember -Group "Power Users").Name -notcontains $User ) 
{ Add-LocalGroupMember -Group "Power Users" -Member $User }

if ( $(Get-LocalGroupMember -Group "Remote Desktop Users").Name -notcontains $User ) 
{ Add-LocalGroupMember -Group "Remote Desktop Users" -Member $User }

if ( $(Get-LocalGroupMember -Group "OpenVPN Administrators").Name -notcontains $User ) 
{ Add-LocalGroupMember -Group "OpenVPN Administrators" -Member $User }

if ( $(Get-LocalGroupMember -Group "Administrators").name -contains $User ) 
{ Remove-LocalGroupMember -Group "Administrators" -Member $User }