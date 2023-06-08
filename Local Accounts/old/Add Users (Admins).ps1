### Enable Administrator and set the Password
$Password = Get-Content .\passwd.administrator.txt | ConvertTo-SecureString
if ( $Password ) 
    { Enable-LocalUser -name Administrator
        Set-LocalUser -Name "Administrator" -Password $Password }

$Computer         = [ADSI]"WinNT://$Env:COMPUTERNAME,Computer"
$UsersList        = @([pscustomobject]@{ Name="effio"; FullName="Effi Ovadia"; Description="System Administrator"; Password="P@ssw0rd"})
$ExistingAccounts = $Computer.Children | Where-Object {$_.SchemaClassName -eq 'user'}  | ForEach-Object {$_.name[0].tostring()}

Foreach ($User in $UsersList) 
{
    if ($ExistingAccounts -NotContains $User.Name) 
    {
        Write-Host -NoNewline -ForegroundColor Cyan "Creating User: "; Write-Host -ForegroundColor Red $($user.Name)
        $NewUser = $computer.Create("User", $User.Name)
        $NewUser.SetPassword($User.Password)     ; $NewUser.SetInfo()
        $NewUser.FullName = $User.FullName       ; $NewUser.SetInfo()
        $NewUser.Description = $User.Description ; $NewUser.SetInfo()
        $NewUser.UserFlags = 64 + 65536          ; $NewUser.SetInfo() # Password: Can't change + Never expire
        $Group = [ADSI]"WinNT://$Env:COMPUTERNAME/Power Users"                     ; $Group.Add($NewUser.Path)
        $Group = [ADSI]"WinNT://$Env:COMPUTERNAME/Remote Desktop Users"            ; $Group.Add($NewUser.Path)
        $Group = [ADSI]"WinNT://$Env:COMPUTERNAME/Network Configuration Operators" ; $Group.Add($NewUser.Path)
        $Group = [ADSI]"WinNT://$Env:COMPUTERNAME/Administrators"                  ; $Group.Add($NewUser.Path)
    } else
    {
        Write-Host -NoNewline -ForegroundColor Cyan "Already exist username: "; Write-Host -ForegroundColor Red $($user.Name)
    }
}