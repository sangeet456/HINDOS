#!/bin/bash
# create_disk.sh

cd $BUILD_DIR

# Create a disk image (100MB)
qemu-img create -f raw hindos.img 100M

# Format the disk
mkfs.ext2 -F hindos.img

# Mount the disk
mkdir -p mnt
sudo mount -o loop hindos.img mnt

# Copy rootfs to disk
sudo cp -a rootfs/* mnt/

# Create necessary device nodes
sudo mknod -m 600 mnt/dev/console c 5 1
sudo mknod -m 666 mnt/dev/null c 1 3
sudo mknod -m 666 mnt/dev/zero c 1 5
sudo mknod -m 666 mnt/dev/random c 1 8
sudo mknod -m 666 mnt/dev/urandom c 1 9

# Create fstab
sudo bash -c 'cat > mnt/etc/fstab << FSTAB
/dev/sda1 / ext2 defaults 0 1
proc /proc proc defaults 0 0
sysfs /sys sysfs defaults 0 0
devtmpfs /dev devtmpfs defaults 0 0
FSTAB'

# Unmount
sudo umount mnt
