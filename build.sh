#!/bin/bash

set -xe

date +"%Y-%m-%d" > BootDate.txt
vasmm68k_mot  -quiet -m68851 -m68882 -m68020up -no-opt -Fbin -Da1k=0 DiagROM.s -o DiagROM.bin    -L DiagROM.txt
vasmm68k_mot  -quiet -m68851 -m68882 -m68020up -no-opt -Fbin -Da1k=1 DiagROM.s -o DiagROMA1k.bin -L DiagROMA1k.txt

dd if=DiagROM.bin of=DiagROM.rom bs=1024 skip=15872
gcc checksum.c -o checksum && ./checksum DiagROM.rom
rm DiagROM.bin

dd if=DiagROMA1k.bin of=DiagROMA1k.rom bs=1024 skip=15872
gcc checksum.c -o checksum && ./checksum DiagROMA1k.rom
rm DiagROMA1k.bin

# test:
# $ fs-uae --kickstart_file=DiagROM.rom --console_debugger=1 --serial_port=/tmp/virtual-serial-port
# serial
# $ socat pty,raw,echo=0,link=/tmp/virtual-serial-port -,raw,echo=0,crlf

vasmm68k_mot -quiet -m68851 -m68882 -m68020up -no-opt -Fhunkexe romsplit.S -o romsplit.exe
mkdir -p diagrom
cp DiagROM.rom diagrom/DiagROM
cp DiagROMA1k.rom diagrom/DiagROMA1k
vamos --ram-size 2048 romsplit.exe || true
DATE=$( cat BootDate.txt )
tar cvzf DiagROM_$DATE.tar.gz diagrom
echo "Archive created : DiagROM_$DATE.tar.gz"
