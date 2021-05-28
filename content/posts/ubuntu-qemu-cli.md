---
title: "Launching Ubuntu Cloud Images with QEMU"
date: 2021-05-29
tags: ["ubuntu"]
draft: false
---

My day-to-day involves generating Ubuntu cloud images. A useful skill for
new hires is to know how to launch these cloud images locally. While
[Multipass](https://multipass.run) and
[LXD VMs](https://discuss.linuxcontainers.org/t/running-virtual-machines-with-lxd-4-0/7519)
make running Ubuntu in a VM super easy, sometimes it is necessary to launch a
custom image with specific parameters.

## Ubuntu Cloud Images

Ubuntu creates cloud images for use with a wide variety of platforms. From
images uploaded to various public clouds, like Amazon Web Services, Microsoft
Azure, and Google Cloud, to local images that are bootable with QEMU, VMware,
Vagrant, and others. These local images are published at
[https://cloud-images.ubuntu.com](https://cloud-images.ubuntu.com).

Most users will probably want to start with the daily image of their favorite
release. For example, the latest daily image for
[Ubuntu 18.04 LTS (Bionic)](https://cloud-images.ubuntu.com/bionic/current/)
or [Ubuntu 20.04 LTS (Focal)](https://cloud-images.ubuntu.com/focal/current/).

### Daily vs Release

Images are published daily when any package in the images change. In practice,
this means a new image may not be available every day. A release image is
published when one of a specific set of packages that are critical to the
image is updated, like the kernel, grub, or cloud-init. Additionally, if a
security update occurs that is critical a release image may get published.

Daily images are found on the [daily](https://cloud-images.ubuntu.com/daily/server/)
directory or under the specific release codename directory. Release images are
found under the [release](https://cloud-images.ubuntu.com/releases/)

### Minimal Images

Most of the images found on the cloud-images.ubuntu.com are the standard server
image. However, there are also a set of
[minimal Ubuntu images](https://ubuntu.com/blog/minimal-ubuntu-released), which
have a reduced package for a smaller image and reduced attack surface. These
images also come with a custom kernel for even faster operations.

All minimal images, including daily and release images, are found under the
[minimal](https://cloud-images.ubuntu.com/minimal/) directory.

### QEMU Image

On an image download page, users will find a directory listing of a
variety of files. These files include checksums, manifests for the images,
and images for a variety of architectures.

QEMU users will want to download the `.img` file, which is a QEMU QCOW2
image. Here are shortcuts to the latest images for Ubuntu 20.04 LTS (Focal):

* [Release](https://cloud-images.ubuntu.com/releases/focal/release/)
* [Daily](https://cloud-images.ubuntu.com/daily/server/focal/current/)
* [Minimal Release](https://cloud-images.ubuntu.com/minimal/releases/focal/release/)
* [Minimal Daily](https://cloud-images.ubuntu.com/minimal/daily/focal/current/)

Additionally, there is a `.manifest` file that lists the packages and snaps
that come with a particular image. Users can also use the SHA256SUMS and
SHA256SUMS.gpg files to verify the checksums of all the files.

Now that an image is in hand, it is time to set up the image.

## Image Datasource

When instances are launched in a cloud deployment
[cloud-init](https://cloudinit.readthedocs.io/en/latest/) will search for a
datasource to retrieve instance metadata. This data is used to determine what
users to create, set a hostname, networking configuration, and many other
possible configuration settings. Cloud images will take in two types of data:

* __metadata__: unique configuration data provided by the cloud platform. The
  values of this data vary depending on the cloud provider. It can include
  a hostname, networking information, SSH keys, etc.
* __user data__: provided directly by the user to configure the system. This
  data is simple as a shell script to execute or include
  [cloud-config](https://cloudinit.readthedocs.io/en/latest/topics/modules.html)
  data that the user can specify settings in a human-friendly format.

In the case of launching a local QEMU image, the user needs to provide a
local datasource for the cloud image to read from. From this datasource, the
instance can read both the metadata and/or user data to configure the system.

### Local Datasource

To provide the local datasource, users create a seed image containing the
metadata, user data, and even networking information. The `cloud-localds`
command from the cloud-image-utils package is used to generate the seed image.

First, create a metadata file with the desired instance ID and hostname:

```shell
$ cat > metadata.yaml <<EOF
instance-id: iid-local01
local-hostname: cloudimg
EOF
```

Next, create a user data file to provide the SSH key to the instance.
The example below uses cloud-init's cloud-config to pass this information to
automatically add the key to the default user. There are two cloud-config keys
that can import an SSH key:

1. `ssh_import_id`: provide a list of public SSH keys to import from GitHub or
  Launchpad
1. `ssh_authorized_keys`: provide the raw SSH public key text to add directly
  to the authorized keys file

Users can use both options, but only one is needed:

```shell
$ cat > user-data.yaml <<EOF
#cloud-config
ssh_authorized_keys:
  - ssh-rsa AAAAB3NzaC1yc2EAAAABIwJJJQEA3I7VUf3l5gSn5uavROsc5HRDpZ ...
ssh_import_id:
  - gh:<github user>
  - lp:<launchpad user>
EOF
```

Note that `#cloud-config` is required to be on the first line. For the full
list of cloud-config options checkout the
[cloud-init docs](https://cloudinit.readthedocs.io/en/latest/topics/modules.html).

Finally, generate the seed image that combines the metadata and user data
files:

```shell
cloud-localds seed.img user-data.yaml metadata.yaml
```

## Booting with SeaBIOS

The default firmware with QEMU is to boot with
[SeaBIOS](https://www.seabios.org/SeaBIOS), an open-source BIOS implementation.

Here is an example command:

```shell
qemu-system-x86_64  \
  -machine accel=kvm,type=q35 \
  -cpu host \
  -m 2G \
  -nographic \
  -device virtio-net-pci,netdev=net0 \
  -netdev user,id=net0,hostfwd=tcp::2222-:22 \
  -drive if=virtio,format=qcow2,file=focal-server-cloudimg-amd64.img \
  -drive if=virtio,format=raw,file=seed.img
```

Here is a breakdown of the above options line by line:

* `-machine accel=kvm,type=q35` enables kernel-based virtual machine (KVM)
  acceleration, which among other things results in greater performance versus
  having QEMU emulate all the hardware (i.e. tcg virtualization). The type
  option sets the machine type to use the Q35 chipset which has a PCIe root
  complex with more modern capabilities versus the older i440FX chipset, which
  only has a PCI host bridge.

* `-cpu host` pass all available host processor features to the guest. This
  option can be supplemented with the `-smp` option to specify a particular
  number of processors as well as topology via the number of sockets, cores, or
  threads.

* `-m 2G` set the amount of memory for an instance. Values ending in `G` stand
  for gigabyte and values without a suffix or `M` stands for megabyte.

* `-nographic` disables the graphical output and makes the command treat the
  QEMU command as a CLI application. This is nice since most use cases for
  cloud images do not need graphical output and it is helpful to see the serial
  console during boot. Type `<Ctrl-a> x` to quit the process. More on this
  in the QEMU Escape Keys section below.

* `-device virtio-net-pci,netdev=net0` Creates a virtio pass-through network
  device

* `-netdev user,id=net0,hostfwd=tcp::2222-:22` tells QEMU to listen
  on port 2222 and connections to that port will be relayed to the VM on port
  22. This way users can SSH to the VM without knowing the IP address of the
  system via `ssh -p 2222 localhost`

* `-drive if=virtio,format=qcow2,file=ubuntu-20.04-server-cloudimg-amd64.img`
  adds a virtio drive using the Ubuntu qcow2 image downloaded earlier

* `-drive if=virtio,format=raw,file=seed.img` adds another virtio drive for
  the created seed image that will act as the local datasource.

### Login with SSH

With the above options set, users can access the VM directly via the serial
console or in other terminal SSH to the VM. Again, the above commands set up a
redirect on the localhost from port 2222 to forward traffic to the VM's port
22.

If the user's SSH key was imported successfully, the user can then SSH to the
VM using port 2222:

```shell
ssh -o "StrictHostKeyChecking no" -p 2222 ubuntu@0.0.0.0
```

When using this option a lot, it is helpful to add the
`-o "StrictHostKeyChecking no"` option to the SSH command to not get prompted
about changing SSH host keys for every different image.

### QEMU Escape Keys and Monitor

Because the above QEMU command uses the `-nographic` option, the serial console
output will go to the terminal the user is using. To interact with the
underlying QEMU process the `<Ctrl-a>` key combination is used to send QEMU
commands.

For example, to terminate the QEMU process the user can run `<Ctrl-a> x`
rather than shutting down the VM via the CLI.

Additionally, users can access the QEMU monitor by running `<Ctrl-a> c` where
they can run additional QEMU commands. Once run the prompt will change to
`(qemu)` and users can run commands like `sendkeys` to send the VM key
combinations, type `quit` to quit, or type `help` for even more options.

## Booting with uEFI

If a user wishes to boot with uEFI instead of BIOS then a different firmware is
required. The uEFI firmware is available via the ovmf package. Similar to
the open-source SeaBIOS implementation, the ovmf package provides an
open-source firmware implementation of uEFI called
[TianoCore](https://www.tianocore.org/).

Then a user can point QEMU at the OVMF firmware by adding the following options
to the QEMU launch command:

```shell
-drive if=pflash,format=raw,readonly,file=/usr/share/OVMF/OVMF_CODE.fd
-drive if=pflash,format=raw,readonly,file=/usr/share/OVMF/OVMF_VARS.fd
```

The pflash value tells QEMU that the specified files are parallel flash images
(ROM firmware). Note that the above example specifies readonly, so any changes
a user makes to uEFI settings will be lost. If the user needs to make changes
that are persistent, then the file needs to be copied somewhere and the
readonly setting dropped.

A user can confirm that uEFI was used by checking for the existence of the
`/sys/firmware/efi` directory:

```shell
$ test -d /sys/firmware/efi && echo uefi || echo bios
uefi
```

Additionally, the `dmesg` and `efibootmgr` commands will also have EFI related
output:

```shell
$ dmesg | grep EFI
[    0.000000] efi: EFI v2.70 by EDK II
[    0.336416] fb0: EFI VGA frame buffer device
[    0.387821] EFI Variables Facility v0.08 2004-May-17
[    0.406204] integrity: Loading X.509 certificate: UEFI:MokListRT
[    0.407849] integrity: Loading X.509 certificate: UEFI:MokListRT
$ sudo efibootmgr
BootCurrent: 0002
Timeout: 0 seconds
BootOrder: 0007,0000,0001,0002,0003,0004,0005,0006
Boot0000* UiApp
Boot0001* UEFI QEMU DVD-ROM QM00005
Boot0002* UEFI Misc Device
Boot0003* UEFI Misc Device 2
Boot0004* UEFI PXEv4 (MAC:525400123456)
Boot0005* UEFI HTTPv4 (MAC:525400123456)
Boot0006* EFI Internal Shell
Boot0007* ubuntu
```

## Booting with uEFI + Secure Boot

It is also possible to boot with secure boot. The same ovmf package used for
uEFI booting includes two additional files that include support for secure boot
and system management mode (SMM) via signed packages:

```shell
-drive if=pflash,format=raw,readonly,unit=0,file=/usr/share/OVMF/OVMF_CODE_4M.secboot.fd
-drive if=pflash,format=raw,readonly,unit=1,file=/usr/share/OVMF/OVMF_VARS_4M.ms.fd
```

The "4M" in the filenames stand for 4MB OVMF images as the existing 2MB images
no longer have sufficient variable space for the current Secure Boot Forbidden
Signature Database.

On launch, the guest will boot to a uEFI shell. There are two options to boot
the system: the first is to use the shell to launch the bootx64.efi binary:

```shell
Shell> fs0:
FS0:\> \efi\boot\bootx64.efi
```

The second option is to type exit and use the boot manager to choose the hard
drive to boot from.

To verify a successful boot using Secure Boot use the mokutil command:

```shell
$ mokutil --sb-state
SecureBoot enabled
$ dmesg | grep secure
[    0.000000] secureboot: Secure boot enabled
[    0.002811] secureboot: Secure boot enabled
```

## Other Helpful QEMU CLI Options

QEMU has an extensive and very well-documented CLI. If a user needs more help
or the possible options adding help to the end of the CLI option should print
detailed support (e.g. `qemu-system-x86_64 -cpu help`).

Below are some additional helpful QEMU CLI options that I have come across
before:

`-snapshot` writes to a temporary file instead of the disk
image itself. This ensures the base disk is not modified and is great if a
user only wants to verify a file in the image or test a boot while keeping the
image pristine.

`-o backing_file=` similar to snapshot, using a backing file will let the user
keep the original image pristine, but write changes to a second file. See the
[QEMU Snapshot](https://wiki.qemu.org/Documentation/CreateSnapshot) wiki page
for an example.

`-D logfile` output log in logfile instead of to stderr

`-object rng-random,id=rng0,filename=/dev/urandom -device virtio-rng-pci,rng=rng0`
  This is an example of adding a hardware random number generator to a VM. See
  the [virtio RNG](https://wiki.qemu.org/Features/VirtIORNG) wiki page for
  more.

`-nodefaults` QEMU launches with a number of default devices. If there is a
  need to remove any device and to launch QEMU only with explicitly declared
  devices then use the nodefaults option. This will remove devices like the
  serial port, monitor device, and others. The example commands above rely on a
  number of default devices, like the serial console. However, the images will
  boot and are accessible via SSH.

## Launch a VM

Again, if you do not need lots of configuration and customization then
give [Multipass](https://multipass.run) and
[LXD VMs](https://discuss.linuxcontainers.org/t/running-virtual-machines-with-lxd-4-0/7519)
a try. They both make booting Ubuntu VMs super easy and Multipass is even
available on Windows and macOS.

Otherwise, go download an
[Ubuntu cloud image](https://cloud-images.ubuntu.com/) and give these commands
a try!

## Links

* [Ubuntu Cloud Images](https://cloud-images.ubuntu.com/)
* [QEMU Docs](https://qemu.readthedocs.io/en/latest/)
* [QEMU Image Types Overview](https://en.wikibooks.org/wiki/QEMU/Images)
* [Arch QEMU Wiki](https://wiki.archlinux.org/title/QEMU)
