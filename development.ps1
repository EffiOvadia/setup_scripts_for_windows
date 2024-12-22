
If ($Admin) 
{

  ## Check if running on Windows 11 pro edition
  if ((Get-WmiObject -Class Win32_OperatingSystem).Caption -like "*Windows 11 Pro")
  {
    ## Enable Windows Hyper-V feature 
    if (!(dism.exe /online /Get-FeatureInfo /FeatureName:Microsoft-Hyper-V | Select-String "State : Enabled")) 
      {dism.exe /online /Enable-Feature /FeatureName:Microsoft-Hyper-V /All /NoRestart}
    ## Enable Windows Sandbox feature 
    if (!(dism.exe /online /Get-FeatureInfo /FeatureName:Containers-DisposableClientVM | Select-String "State : Enabled")) 
      {dism.exe /online /Enable-Feature /FeatureName:Containers-DisposableClientVM /All /NoRestart}
  }
  
  ## Enable Linux Subsystem feature
  if (!(dism.exe /online /Get-FeatureInfo /FeatureName:VirtualMachinePlatform | Select-String "State : Enabled")) 
    {dism.exe /online /Enable-Feature /FeatureName:VirtualMachinePlatform /All /NoRestart}
  if (!(dism.exe /online /Get-FeatureInfo /FeatureName:Microsoft-Windows-Subsystem-Linux | Select-String "State : Enabled")) 
    {dism.exe /online /Enable-Feature /FeatureName:Microsoft-Windows-Subsystem-Linux /All /NoRestart}
  ## set wsl default version to 2  
  wsl --set-default-version 2
  ## update wsl subsystem
  wsl --update 
  ## Install selected Linux dist 
  $Distros = 
    @(
    [PSCustomObject]@{Name='Ubuntu'; ID='Ubuntu'}
    #/ [PSCustomObject]@{Name='Debian GNU/Linux'; ID='Debian'}
    #/ [PSCustomObject]@{Name='Kali Linux Rolling'; ID='kali-linux'}
    #/ [PSCustomObject]@{Name='Ubuntu 24.04 LTS'; ID='Ubuntu-24.04'}
    #/ [PSCustomObject]@{Name='Oracle Linux 9.1'; ID='OracleLinux_9_1'}
    )

  foreach ( $Dist in $Distros ) { wsl --install --no-launch -d $Dist.ID } 
  ## list all installed distros on local machine 
  wsl --list --verbose 
 
}
