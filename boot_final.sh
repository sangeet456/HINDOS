#!/bin/bash
cd ~/Desktop/HINDOS
echo "Booting HINDOS Minimal..."
qemu-system-x86_64 -hda hindos_final.img -m 256M -nographic
