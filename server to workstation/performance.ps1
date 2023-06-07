### ---------------------------------------------------------------------------------

### https://docs.microsoft.com/en-us/windows-server/administration/performance-tuning/role/file-server/index

### ConnectionCountPerNetworkInterface - default is 1, The valid range is 1-16
Set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Services\LanmanWorkstation\Parameters" ConnectionCountPerNetworkInterfac -Force -Value 4
### ConnectionCountPerRssNetworkInterface - default is 4, The valid range is 1-16.
Set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Services\LanmanWorkstation\Parameters" ConnectionCountPerRssNetworkInterface -Force -Value 8
### ConnectionCountPerRdmaNetworkInterface - default is 2, The valid range is 1-16
Set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Services\LanmanWorkstation\Parameters" ConnectionCountPerRdmaNetworkInterface -Force -Value 4
### MaximumConnectionCountPerServer - default is 32, with a valid range from 1-64.
Set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Services\LanmanWorkstation\Parameters" MaximumConnectionCountPerServer -Force -Value 64
### DisableBandwidthThrottling - default is 0.
Set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Services\LanmanWorkstation\Parameters" DisableBandwidthThrottling -Force -Value 1
### DisableLargeMtu - default is 0 for Windows 8 only
Set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Services\LanmanWorkstation\Parameters" DisableLargeMtu -Force -Value 0
### MaxCmds - default is 15
Set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Services\LanmanWorkstation\Parameters" MaxCmds -Force -Value 32768 

### ---------------------------------------------------------------------------------