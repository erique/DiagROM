#!/bin/bash

set -xe

date +"%Y-%m-%d" > BootDate.txt
vasmm68k_mot  -quiet -m68851 -m68882 -m68020up -no-opt -Fbin DiagROM.s -o DiagROM.bin -L DiagROM.txt
dd if=DiagROM.bin of=DiagROM bs=1024 skip=15872
gcc checksum.c -o checksum && ./checksum DiagROM
rm DiagROM.bin

# test:
# $ fs-uae --kickstart_file=DiagROM --console_debugger=1 --serial_port=/tmp/virtual-serial-port
# serial
# $ socat pty,raw,echo=0,link=/tmp/virtual-serial-port -,raw,echo=0,crlf

vasmm68k_mot -quiet -m68851 -m68882 -m68020up -no-opt -Fhunkexe romsplit.S -o romsplit.exe
mkdir -p diagrom
mv DiagROM diagrom
vamos --ram-size 2048 romsplit.exe || true
DATE=$( cat BootDate.txt )
tar cvzf DiagROM_$DATE.tar.gz diagrom
echo "Archive created : DiagROM_$DATE.tar.gz"

# to allow usage from UAE
cp diagrom/DiagROM DiagROM
