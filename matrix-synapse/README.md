# Configuration

## 0 - VM Prep

1. Clone the guest template
1. Log in and update the IP and hostname in `/etc/nixos/configuration.nix`.

## 1 - Partitioning

As root for all of this I think.

1. 
1. Begin partitioning the device

    ```bash
    DISK="/dev/sda"
    parted -a optimal "${DISK}"
    ```
1. Within parted created a few normal block devices.

    ```bash
    unit mib
    mklabel gpt

    # Grub partition
    mkpart primary 1 3
    name 1 grub-0
    set 1 bios_grub on

    # Root VG partition
    mkpart primary 3 -1
    name 2 root
    toggle 2 lvm
    ```

## 2 - File systems

1. Install grub on the grub partition
1. Create the rootvg

    ```bash
    VG="rootvg"
    DISK="/dev/sda"
    vgcreate "${VG}" "${DISK}3"
    ```
1. Create a swap LV

    ```bash
    # Create LV
    LV="lv_swap"
    lvcreate -L 2G -n "${LV}" "${VG}"

    # Make it swap
    mkswap "/dev/${VG}/${LV}"
    ```
1. Turn on the swap

    ```bash
    swapon "/dev/${VG}/${LV}"
    ```
1. Create the root LV and file system

    ```bash
    LV="lv_root"
    lvcreate -L 24G -n "${LV}" "${VG}"

    # Make it ext4
    mkfs.ext4 "/dev/${VG}/${LV}"
    ```

## 3 - Installing

1. Mount the new rootvg

    ```bash
    mount "/dev/${VG}/${LV}" /mnt
    ```
1. Generate an initial configuration file.

    ```bash
    nixos-generate-config --root /mnt
    ```
1. Make any necessary changes.
1. Run the install

    ```bash
    nixos-install
    ```
1. Set root's password at the end.

## 4 - Matrix Prep

1. Create the matrix filesystem.

    ```bash
    LV="lv_matrix"
    lvcreate -L 16G -n "${LV}" "${VG}"

    # Make it ext4
    mkfs.ext4 "/dev/${VG}/${LV}"
    ```
1. Generate the registration key.

    ```bash
    pwgen -s 64 1
    ```
1. 

Note that if you need to rebuild the config it's `nixos-rebuild switch`.

# External References

* [nixos Manual - Synapse Homeserver](https://nixos.org/manual/nixos/stable/index.html#module-services-matrix)
* [nixos Matrix](https://nixos.wiki/wiki/Matrix)
* [nixos Options](https://nixos.org/nixos/manual/options.html)
* [nixos Configuration](https://nixos.org/nixos/manual/#sec-configuration-syntax)
* [nixos Manual](https://nixos.org/nixos/manual/)
