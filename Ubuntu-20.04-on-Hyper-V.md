# Ubuntu 20.04 on Hyper-V in N steps

## Step 1. Create virtual disk

Microsoft Hyper-V documentation [recommends][1] use 1MB BlockSizeBytes which can be done only from PowerShell:

    New-VHD -Path "C:\MyVHDs\Ubuntu 20.04.vhdx" -SizeBytes 30GB -Dynamic -BlockSizeBytes 1MB
    
## Step 2. Create Virtual machine

Use "New|Virtual Machine" in Hyper-V UI to create new machine for Ubuntu. Select "Generation 2", set "Startup memory" to 3072Mb.
It's better to give NATed access to the Network by chhosing of "Default switch" on "Configure Networking" page,
but it's not strictly needed. Choose the virtual disk created earlier for "Use an existing virtual hard disk" option on the next page.

## Step 3. Tune VM settings

Open settings for created VM.

On "Security" tab select "Microsoft UEFI Certificate Authority" for "Secure Boot | Template".

On "Processor" modify number of virtual processing to value you need.

Select "SCSI Controller" tab, add new "DVD drive". Change "Media" option to "Image file" and "Browse" for Ubuntu image.

On "Integration Services" tab add check mark "Guest services". I usually uncheck "Backup (valume shadow copy)".
In the result all but "Backup" is checked.

Apply the changes.

You may want to change boot order on "Firmware" tab after that.

# Step 4. Install Ubuntu

Power on the Virtual machine and when Ubuntu installer is loaded state that you're going to Install Ubuntu.

Microsoft recommends to set number of groups to 4096 for ext4. It cannot be done from GUI.
So press *Ctrl-Alt-2* to switch to console. Use *ubuntu* with blank password to login.

Run parted

    sudo parted /dev/sda
    
In parted issue the following commands:

    mktable gpt
    mkpart primary fat32 1MiB 513MiB
    mkpart primary ext4 513MiB -0
    set 1 boot on
    quit
    
Create file systems:

    sudo mkfs.vfat /dev/sda1
    sudo mkfs.ext4 -G 4096 /dev/sda2
    
Return back to the UI by pressing *Alt-1*. Go on till "Installation type" screen. Select "Something else" and press "Continue".
You should see the paritions created before. Select /dev/sda2 and press "Change...".
In the opened dialog select "Ext4 journaling file system" for "Use as" and */* as "Mount point".

[1]: https://docs.microsoft.com/en-us/windows-server/virtualization/hyper-v/best-practices-for-running-linux-on-hyper-v
    
    
