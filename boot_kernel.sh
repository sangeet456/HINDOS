#!/bin/bash
cd ~/Desktop/HINDOS

KERNEL=$(ls /boot/vmlinuz-* | head -1)
INITRD=$(ls /boot/initrd.img-* | head -1)

echo "Booting HINDOS with:"
echo "Kernel: $KERNEL"
echo "Initrd: $INITRD"
echo ""

qemu-system-x86_64 \
    -kernel $KERNEL \
    -initrd $INITRD \
    -drive file=hindos_final.img,format=raw \
    -append "root=/dev/sda1 rw console=ttyS0 init=/init" \
    -m 256M \
    -nographic
