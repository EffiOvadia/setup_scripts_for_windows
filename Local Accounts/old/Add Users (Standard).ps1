
$OrganizationName = "SMD"
$Computer         = [ADSI]"WinNT://$Env:COMPUTERNAME,Computer"
$UsersList        = @([pscustomobject]@{ Name="User"; FullName="$OrganizationName User"; Description="Standard Local User" } )
$ExistingAccounts = $Computer.Children | Where-Object {$_.SchemaClassName -eq 'user'}  | ForEach-Object {$_.name[0].tostring()}

Foreach ($User in $UsersList) 
{
    if ($ExistingAccounts -NotContains $User.Name) 
    {
        Write-Host -NoNewline -ForegroundColor Cyan "Creating User: "; Write-Host -ForegroundColor Red $User.name
        $NewUser = $computer.Create("User", $User.Name)
        $NewUser.SetPassword("")                 ; $NewUser.SetInfo()
        $NewUser.FullName = $User.FullName       ; $NewUser.SetInfo()
        $NewUser.Description = $User.Description ; $NewUser.SetInfo()
        $NewUser.UserFlags = 64 + 65536          ; $NewUser.SetInfo() # Password: Can't change + Never expire
        $Group = [ADSI]"WinNT://$Env:COMPUTERNAME/Power Users"                     ; $Group.Add($NewUser.Path)
        $Group = [ADSI]"WinNT://$Env:COMPUTERNAME/Remote Desktop Users"            ; $Group.Add($NewUser.Path)
        $Group = [ADSI]"WinNT://$Env:COMPUTERNAME/Network Configuration Operators" ; $Group.Add($NewUser.Path)
    } else
    {
        Write-Host -NoNewline -ForegroundColor Cyan "Already exist username: "; Write-Host -ForegroundColor Red $($user.Name)
        Set-LocalUser -AccountNeverExpires -PasswordNeverExpires:$true -FullName "$OrganizationName User" -Name $User.name 
        Set-LocalUser -Description "Standard Local User" -Name $User.name

        $GroupUsers = $(Get-LocalGroupMember -Group "Power Users").Name
        if ($GroupUsers -notcontains "$Env:COMPUTERNAME\$($User.name)" ) { Add-LocalGroupMember -Group "Power Users" -Member $User.name }
        $GroupUsers = $(Get-LocalGroupMember -Group "Remote Desktop Users").Name
        if ($GroupUsers -notcontains "$Env:COMPUTERNAME\$($User.name)" ) { Add-LocalGroupMember -Group "Remote Desktop Users" -Member $User.name }
        $GroupUsers = $(Get-LocalGroupMember -Group "Network Configuration Operators").Name
        if ($GroupUsers -notcontains "$Env:COMPUTERNAME\$($User.name)"  ) { Add-LocalGroupMember -Group "Network Configuration Operators" -Member $User.name }
        $GroupUsers = $(Get-LocalGroupMember -Group "Administrators").name 
        if ($GroupUsers -contains "$Env:COMPUTERNAME\$($User.name)" ) { Remove-LocalGroupMember -Group "Administrators" -Member $User.name }
    }
}
