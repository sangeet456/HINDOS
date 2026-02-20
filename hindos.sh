#!/bin/bash
# create_hindos.sh

# Set variables
export HINDOS_VERSION="1.0"
export HINDOS_NAME="HINDOS"
export BUILD_DIR="$HOME/hindos-build"
export ROOTFS_DIR="$BUILD_DIR/rootfs"
export ISO_DIR="$BUILD_DIR/iso"

# Create build directories
mkdir -p $ROOTFS_DIR
mkdir -p $ISO_DIR

# Create minimal Debian rootfs
sudo debootstrap --arch=amd64 \
                 --variant=minbase \
                 bullseye \
                 $ROOTFS_DIR \
                 http://deb.debian.org/debian

# Chroot into the system
sudo chroot $ROOTFS_DIR /bin/bash << 'EOF'
# Update system
apt-get update

# Install only essential packages
apt-get install -y --no-install-recommends \
    linux-image-amd64 \
    systemd-sysv \
    initramfs-tools \
    kmod \
    busybox

# Set hostname
echo "hindos" > /etc/hostname

# Set up network
cat > /etc/network/interfaces << 'NET'
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet dhcp
NET

# Create HINDOS welcome message
cat > /etc/issue << 'WELCOME'
HINDOS v1.0 - Minimal Debian-based OS
Login: root (no password)
WELCOME

# Set root password (empty for testing)
passwd -d root

# Create basic directory structure
mkdir -p /home /mnt /media /opt /srv

# Create a simple startup script
cat > /etc/profile.d/hindos-welcome.sh << 'SCRIPT'
#!/bin/bash
echo "======================================"
echo "Welcome to HINDOS - Minimal Linux OS"
echo "Version: 1.0"
echo "Based on: Debian Bullseye"
echo "======================================"
echo "Available commands: busybox, ls, cd, pwd, etc."
SCRIPT
chmod +x /etc/profile.d/hindos-welcome.sh

# Clean up
apt-get clean
rm -rf /var/lib/apt/lists/*
EOF
