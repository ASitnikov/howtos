# Ubuntu 20.04 on Hyper-V in N steps

## Step 1. Create virtual disk

Microsoft Hyper-V documentation [recommends][1] usage of 1MB BlockSizeBytes which can be done only from PowerShell:

    New-VHD -Path "C:\MyVHDs\Ubuntu 20.04.vhdx" -SizeBytes 30GB -Dynamic -BlockSizeBytes 1MB
    
## Step 2. Create Virtual machine

Use "New|Virtual Machine" in Hyper-V UI to create a new machine for Ubuntu. Select "Generation 2", set "Startup memory" to 3072Mb.
If you plan to give the Internet access to your VM configure the Networking. NATed access to the network can be given by chosing
of "Default switch" on "Configure Networking" page. Choose the virtual disk created earlier for "Use an existing virtual
hard disk" option on the next page.

## Step 3. Tune VM settings

Open settings for created VM.

On the "Security" tab select "Microsoft UEFI Certificate Authority" in the "Secure Boot | Template" dropdown.

On the "Processor" tab modify the number of virtual processing to a value you need.

Select the "SCSI Controller" tab, add new "DVD drive". Change "Media" option to "Image file" and "Browse" for the Ubuntu image.

On the "Integration Services" tab add check mark "Guest services". I usually uncheck "Backup (valume shadow copy)".
As the result everything but "Backup" is checked.

Apply the changes.

You may want to change the boot order on the "Firmware" tab after that.

## Step 4. Install Ubuntu

Power on the the Virtual machine and when Ubuntu installer is loaded start the installation wizard by pressing
the "Install Ubuntu" button.

> *Note: The following part is needed to format ext4 with parameter recommmended for Hyper-V installations by Microsoft (`-G 4096`).
> I forgot to check how Ubuntu installer formats it by default.

Microsoft recommends to set the number of groups to 4096 for ext4. It cannot be done from the installator UI.
Press *Ctrl-Alt-2* to switch to console. Use *ubuntu* with blank password to login.

Run parted:

    sudo parted /dev/sda
    
In parted issue the following commands:

    mktable gpt
    mkpart EFI fat32 1MiB 513MiB
    mkpart Ubuntu ext4 513MiB -0
    set 1 boot on
    quit
    
Create file systems:

    sudo mkfs.vfat /dev/sda1
    sudo mkfs.ext4 -G 4096 /dev/sda2
    
Return back to the UI by pressing *Alt-1*. Continue with the installation wizard till "Installation type" screen.
On this page select "Something else" and press "Continue". You should see the paritions created in parted before.
Select /dev/sda2 and press "Change...".
In the opened dialog select "Ext4 journaling file system" in "Use as" dropdown and */* as "Mount point".

Go on with installation.

## Step 5. Install Hyper-V additions

Boot into the Ubuntu. Open a terminal and install linux-azure package:

    sudo apt install linux-azure
    
## Step 6. Install xRDP (optional)

You may consider to install the xRDP support for Ubuntu. The easiest way to do it is with help of [script][2] provided by Griffon.

## Step 7. Enjoy your new Ubuntu!

[1]: https://docs.microsoft.com/en-us/windows-server/virtualization/hyper-v/best-practices-for-running-linux-on-hyper-v
[2]: http://c-nergy.be/blog/?p=14888
