#!/bin/bash
# simple_init.sh - Minimal init for testing

cat > ~/Desktop/HINDOS/simple_init.sh << 'EOF'
#!/bin/sh

# Minimal init script for HINDOS

echo "HINDOS: Booting..."
echo "Mounting filesystems..."

# Mount proc
mount -t proc proc /proc 2>/dev/null
echo "Mounted proc"

# Mount sysfs
mount -t sysfs sysfs /sys 2>/dev/null
echo "Mounted sysfs"

# Mount devtmpfs
mount -t devtmpfs devtmpfs /dev 2>/dev/null
echo "Mounted devtmpfs"

echo ""
echo "╔════════════════════════════════╗"
echo "║         HINDOS v1.0            ║"
echo "║     Minimal Debian-based OS    ║"
echo "╚════════════════════════════════╝"
echo ""
echo "Type 'exit' to shutdown"
echo ""

# Start shell
exec /bin/sh
EOF

chmod +x ~/Desktop/HINDOS/simple_init.sh
