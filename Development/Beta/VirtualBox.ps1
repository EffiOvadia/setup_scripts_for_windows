Function Set-LinuxVBOX
{
    Clear-Host ; Write-Host '' ; 
    if ($($PSVersionTable.PSVersion).major -gt 5 ) { Import-Module -Name NetAdapter -SkipEditionCheck }

    $OSList     = @(
                [pscustomobject]@{Name='Debian SID';     Type='Debian_64';    ISO='Z:\Software\Debian\unstable\mini.iso'}
                [pscustomobject]@{Name='Debian Stable';  Type='Debian_64';    ISO='Z:\Software\Debian\firmware-10.4.0-amd64-netinst.iso'}
                [pscustomobject]@{Name='Ubuntu Desktop'; Type='Ubuntu_64';    ISO='Z:\Software\Ubuntu\ubuntu-20.04-desktop-amd64.iso'}
                [pscustomobject]@{Name='Ubuntu Server';  Type='Ubuntu_64';    ISO='Z:\Software\Ubuntu\ubuntu-20.04-live-server-amd64.iso'}
                [pscustomobject]@{Name='LinuxMint';      Type='Ubuntu_64';    ISO='Z:\Software\Mint\linuxmint-20-cinnamon-64bit.iso'}
                )
    $MENU       = @{}
                for ($i=1;$i -le $OSList.count; $i++) { Write-Host "$i. $($OSList.name[$i-1])" $menu.Add($i,($OSList[$i-1])) }
                Write-Host '' ; [int]$selection = Read-Host 'Choose OS Adapter' ; Write-Host '' ; $OS = $menu.Item($selection)
    $NIC        = @( (Get-NetAdapter -Physical | Sort-Object -property name).InterfaceDescription )
    $BaseFolder = "Z:\Virtual Machines\VirtualBox\VirtualBox VMs"
    $Medium     = $BaseFolder  + "\" + $OS.name + "\" + $OS.name + ".vdi"
    $LUN_Drives = 0

    Push-Location "$env:ProgramFiles\Oracle\VirtualBox\"
    .\VBoxManage createvm      --name $OS.name --register --basefolder $BaseFolder --ostype $OS.type
    .\VBoxManage createmedium  --format VDI --variant Standard --size 20480 --filename $Medium
    .\VBoxManage storagectl    $OS.name --name USB    --add usb         --portcount 8 --bootable on --hostiocache on --controller USB
    .\VBoxManage storagectl    $OS.name --name NVMe   --add pcie        --portcount 2 --bootable on --hostiocache on --controller NVMe 
    .\VBoxManage storagectl    $OS.name --name VirtIO --add VirtIO-SCSI --portcount 2 --bootable on --hostiocache on --controller VirtIO
    .\VBoxManage storageattach $OS.name --storagectl NVMe --port 0 --device 0 --type hdd --medium $Medium --nonrotational on --discard on
    .\VBoxManage storageattach $OS.name --storagectl USB --port 0 --device 0 --type dvddrive --medium $OS.iso
    if  ($LUN_Drives -gt 0) 
    {
        .\VBoxManage storagectl  $OS.name --hostiocache on --name SAS  --add sas  --portcount 8 --controller LSILogicSAS
        foreach ($_ in 1..$LUN_Drives)
        {
            $x++ ; $Medium = $BaseFolder + "\" + $OS.name + "\" + $OS.name + " ArrayNode " + $x + ".vdi"
            .\VBoxManage createmedium --format VDI --variant Standard --size 4096 --filename $Medium
            .\VBoxManage storageattach $OS.name --storagectl SAS --port $x --type hdd --medium $Medium --nonrotational on --discard on 
        } 
    }
    .\VBoxManage modifyvm      $OS.name --clipboard bidirectional --draganddrop bidirectional
    .\VBoxManage modifyvm      $OS.name --boot1 dvd --boot2 disk --boot3 none --boot4 none --rtcuseutc on --firmware efi64
    .\VBoxManage modifyvm      $OS.name --chipset ICH9 --memory 8192 --cpus 2 --cpuhotplug on --pagefusion on --guestmemoryballoon 4096
    .\VBoxManage modifyvm      $OS.name --pae on --hwvirtex on --acpi on --ioapic on --hpet on --nestedpaging on --paravirtprovider KVM --nested-hw-virt on
    .\VBoxManage modifyvm      $OS.name --monitorcount 1 --vrde off --accelerate3d on --accelerate2dvideo on --vram 128 --graphicscontroller VMSVGA
    .\VBoxManage modifyvm      $OS.name --nic1 bridged --nictype1 virtio --nicpromisc1 deny --bridgeadapter1 $NIC[1] --cableconnected2 on
    .\VBoxManage modifyvm      $OS.name --nic2 bridged --nictype2 virtio --nicpromisc2 deny --bridgeadapter2 $NIC[1] --cableconnected2 off
    .\VBoxManage modifyvm      $OS.name --audiocontroller hda --audioout on --usb on --usbehci on --usbxhci on --keyboard usb --mouse usb
    .\VBoxManage modifyvm      $OS.name --largepages on --vtxvpid on --vtxux on # Extra settings for Intel host CPU
    .\VBoxManage modifyvm      $OS.name --bioslogofadein on --bioslogofadeout on --bioslogodisplaytime 2000 
    .\VBoxManage setextradata  $OS.name VBoxInternal2/EfiBootArgs 
    .\VBoxManage setextradata  $OS.name VBoxInternal2/EfiGraphicsResolution 1600x900
    .\VBoxManage setextradata  $OS.name VBoxInternal2/UgaHorizontalResolution 1600
    .\VBoxManage setextradata  $OS.name VBoxInternal2/UgaVerticalResolution    900
    .\VBoxManage setextradata  $OS.name CustomVideoMode1 1600x900x32
    .\VBoxManage setextradata  $OS.name GUI/MaxGuestResolution any
    .\vboxmanage setextradata  $OS.name installdate $(Get-Date)
    .\vboxmanage showvminfo    $OS.name | clip
    .\vboxmanage getextradata  $OS.name enumerate
    Pop-Location

    Write-Host ''
}

function CreateVirtualWindows
{
    Clear-Host ; Write-Host '' ; 
    if ($($PSVersionTable.PSVersion).major -gt 5 ) { Import-Module -Name NetAdapter -SkipEditionCheck }

    $OSList     = @(
                [pscustomobject]@{Name='Windows 7';    Type='Windows7_64';    ISO=$ISOFolder+'Z:\Software\Microsoft\Windows 7\SW_DVD5_Win_Pro_7w_SP1_64BIT_English_-2_MLF_X17-59279.ISO'}
                [pscustomobject]@{Name='Windows 8.1';  Type='Windows81_64';   ISO=$ISOFolder+'Z:\Software\Microsoft\Windows 8.1\debian-live-10.0.0-amd64-mate.iso'}
                [pscustomobject]@{Name='Windows 10';   Type='Windows10_64';   ISO=$ISOFolder+'Z:\Software\Microsoft\Windows 10\Win10_1903_V1_English_x64.iso'}
                [pscustomobject]@{Name='Windows 2016'; Type='Windows2016_64'; ISO=$ISOFolder+'Z:\Software\Microsoft\Windows 2016\en_windows_server_2016_x64_dvd_9718492.iso'}
                )
    $MENU       = @{}
                for ($i=1;$i -le $OSList.count; $i++) { Write-Host "$i. $($OSList.name[$i-1])" $menu.Add($i,($OSList[$i-1])) }
                Write-Host '' ; [int]$selection = Read-Host 'Choose OS Adapter' ; Write-Host '' ; $OS = $menu.Item($selection)
    $NIC        = @( (Get-NetAdapter -Physical | Sort-Object -property name).InterfaceDescription )
    $BaseFolder = "Z:\Virtual Machines\VirtualBox\VirtualBox VMs"
    $Medium     = $BaseFolder + "\" + $OS.name + "\" + $OS.name + ".vdi"
    $LUN_Drives  = 0

    Push-Location "$env:ProgramFiles\Oracle\VirtualBox\"
    .\VBoxManage createvm      --name $OS.name --register --basefolder $BaseFolder --ostype $OS.type
    .\VBoxManage createmedium  --format VDI --variant Standard --size 32768 --filename $Medium
    .\VBoxManage storagectl    $OS.name --name USB  --add usb  --portcount 8 --bootable on --hostiocache on --controller USB 
    .\VBoxManage storagectl    $OS.name --name NVMe --add pcie --portcount 2 --bootable on --hostiocache on --controller NVMe 
    .\VBoxManage storagectl    $OS.name --name SATA --add sata --portcount 2 --bootable on --hostiocache on --controller IntelAHCI
    .\VBoxManage storageattach $OS.name --storagectl SATA --port 0 --device 0 --type hdd --medium $Medium --nonrotational on --discard on
    .\VBoxManage storageattach $OS.name --storagectl USB  --port 0 --device 0 --type dvddrive --medium $OS.iso
    if  ($LUN_Drives -gt 0) 
    {
        .\VBoxManage storagectl  $OS.name --hostiocache on --name SAS  --add sas  --portcount 8 --controller LSILogicSAS
        foreach ($_ in 1..$LUN_Drives)
        {
            $x++ ; $Medium = $BaseFolder + "\" + $OS.name + "\" + $OS.name + " ArrayNode " + $x + ".vdi"
            .\VBoxManage createmedium --format VDI --variant Standard --size 4096 --filename $Medium
            .\VBoxManage storageattach $OS.name --storagectl SAS --port $x --type hdd --medium $Medium --nonrotational on --discard on 
        } 
    }
    .\VBoxManage modifyvm      $OS.name --clipboard bidirectional --draganddrop bidirectional
    .\VBoxManage modifyvm      $OS.name --boot1 dvd --boot2 disk --boot3 none --boot4 none --rtcuseutc on --firmware efi64
    .\VBoxManage modifyvm      $OS.name --chipset ICH9 --memory 8192 --cpus 2 --cpuhotplug on --pagefusion on --guestmemoryballoon 4096
    .\VBoxManage modifyvm      $OS.name --pae on --hwvirtex on --acpi on --ioapic on --hpet on --nestedpaging on --paravirtprovider hyperv
    .\VBoxManage modifyvm      $OS.name --monitorcount 1 --vrde off --accelerate3d on --accelerate2dvideo on --vram 256 --graphicscontroller vboxsvga
    .\VBoxManage modifyvm      $OS.name --nic1 bridged --nictype1 virtio --nicpromisc1 deny --bridgeadapter1 $NIC[1] --cableconnected2 on
    .\VBoxManage modifyvm      $OS.name --nic2 bridged --nictype2 virtio --nicpromisc2 deny --bridgeadapter2 $NIC[1] --cableconnected2 off
    .\VBoxManage modifyvm      $OS.name --audiocontroller hda --audioout on --usb on --usbehci on --usbxhci on --keyboard usb --mouse usb
    .\VBoxManage modifyvm      $OS.name --largepages on --vtxvpid on --vtxux on # Extra settings for Intel host CPU
    #.\VBoxManage modifyvm      $OS.name --mds-clear-on-vm-entry on --l1d-flush-on-vm-entry on --spec-ctrl on --ibpb-on-vm-exit on --ibpb-on-vm-entry on
    .\VBoxManage modifyvm      $OS.name --bioslogofadein on --bioslogofadeout on --bioslogodisplaytime 2000 
    .\VBoxManage setextradata  $OS.name VBoxInternal2/EfiGraphicsResolution 1600x900
    .\VBoxManage setextradata  $OS.name VBoxInternal2/UgaHorizontalResolution 1600
    .\VBoxManage setextradata  $OS.name VBoxInternal2/UgaVerticalResolution    900
    .\VBoxManage setextradata  $OS.name CustomVideoMode1 1600x900x32
    .\VBoxManage setextradata  $OS.name GUI/MaxGuestResolution any
    .\vboxmanage setextradata  $OS.name installdate $(Get-Date)
    .\vboxmanage showvminfo    $OS.name | clip
    .\vboxmanage getextradata  $OS.name enumerate
    Pop-Location

    Write-Host ''
}