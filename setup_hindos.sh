#!/bin/bash
# setup_hindos.sh - Complete HINDOS setup

cd ~/Desktop/HINDOS

echo "=== Setting up HINDOS ==="

# Create mount point
mkdir -p mnt

# Mount the disk image
echo "Mounting disk image..."
sudo mount -o loop hindos.img mnt

# Create necessary directories
echo "Creating directory structure..."
sudo mkdir -p mnt/{bin,sbin,etc,proc,sys,dev,home,tmp,root,var,usr,lib,lib64,etc/network,etc/init.d}

# Create network interfaces file
echo "Creating network configuration..."
sudo bash -c 'cat > mnt/etc/network/interfaces << "EOF"
# Loopback interface
auto lo
iface lo inet loopback

# Ethernet interface
auto eth0
iface eth0 inet dhcp
EOF'

# Create fstab
echo "Creating fstab..."
sudo bash -c 'cat > mnt/etc/fstab << "EOF"
# /etc/fstab
/dev/sda1 / ext2 defaults 0 1
proc /proc proc defaults 0 0
sysfs /sys sysfs defaults 0 0
devtmpfs /dev devtmpfs defaults 0 0
tmpfs /tmp tmpfs defaults 0 0
EOF'

# Create a simple init script
echo "Creating init script..."
sudo bash -c 'cat > mnt/init << "EOF"
#!/bin/sh

# Mount filesystems
mount -t proc proc /proc
mount -t sysfs sysfs /sys
mount -t devtmpfs devtmpfs /dev
mount -t tmpfs tmpfs /tmp

# Set hostname
echo "hindos" > /etc/hostname
hostname -F /etc/hostname

# Configure loopback interface
ip link set lo up

# Print welcome message
clear
echo "========================================"
echo "    HINDOS - Minimal Linux System"
echo "    Version 1.0"
echo "    Based on Debian Bullseye"
echo "========================================"
echo ""
echo "Type 'exit' to shutdown"
echo ""

# Start shell
exec /bin/sh
EOF'

# Make init executable
sudo chmod 755 mnt/init

# Create a simple profile
echo "Creating profile..."
sudo bash -c 'cat > mnt/etc/profile << "EOF"
export PATH=/bin:/sbin:/usr/bin:/usr/sbin
export PS1="\u@HINDOS:\w\$ "
echo "Welcome to HINDOS!"
echo "Available commands: busybox, ls, cd, pwd, cat, echo, mount, ps"
EOF'

# Create a simple rcS script
echo "Creating rcS script..."
sudo bash -c 'cat > mnt/etc/init.d/rcS << "EOF"
#!/bin/sh
# System initialization script
echo "HINDOS: Starting system services..."
/bin/mount -a 2>/dev/null
echo "HINDOS: System ready"
EOF'
sudo chmod 755 mnt/etc/init.d/rcS

# Copy busybox if available
if [ -f mnt/bin/busybox ]; then
    echo "Busybox found, creating symlinks..."
    cd mnt/bin
    for cmd in sh ls cp mv rm cat echo mount umount ps kill mkdir rmdir clear hostname; do
        sudo ln -sf busybox $cmd 2>/dev/null
    done
    cd ../..
fi

# Unmount
echo "Unmounting disk image..."
sudo umount mnt
rmdir mnt

echo "=== Setup Complete! ==="
echo "You can now boot HINDOS with: ./boot.sh"
