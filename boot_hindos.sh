#!/bin/bash
cd ~/Desktop/HINDOS
echo "Booting HINDOS..."
qemu-system-x86_64 \
    -drive file=hindos.img,format=raw \
    -m 256M \
    -nographic \
    -serial mon:stdio
