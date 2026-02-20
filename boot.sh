#!/bin/bash
cd ~/Desktop/HINDOS

echo "Starting HINDOS in QEMU..."
echo "Press Ctrl+A then X to exit"
echo ""

qemu-system-x86_64 \
    -drive file=hindos.img,format=raw \
    -m 256M \
    -nographic
