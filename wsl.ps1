
#@ Enable/Install Linux Subsystem feature
if ( $(Get-WindowsOptionalFeature -Online -FeatureName "Microsoft-Windows-Subsystem-Linux").state -ne "Enabled" ) 
  { Enable-WindowsOptionalFeature -NoRestart -Online -FeatureName "Microsoft-Windows-Subsystem-Linux" -All }
#@ set wsl default version to 2  
wsl --set-default-version 2
#@ update wsl subsystem
wsl --update 
#@ Install selected Linux dist 
$Distros = 
  @(
  [PSCustomObject]@{Name='Ubuntu'; ID='Ubuntu'}
  [PSCustomObject]@{Name='Debian GNU/Linux'; ID='Debian'}
  [PSCustomObject]@{Name='Kali Linux Rolling'; ID='kali-linux'}
  [PSCustomObject]@{Name='Ubuntu 22.04 LTS'; ID='Ubuntu-22.04'}
  [PSCustomObject]@{Name='Oracle Linux 9.1'; ID='OracleLinux_9_1'}
  )

foreach ( $Dist in $Distros ) { wsl --install --no-launch -d $Dist.ID } 
#@ list all installed distros on local machine 
wsl --list --verbose 