
;------------------------------------------------------------------------------------------
DataStart:

; STATIC Data located here.  (HEY!! it IS in ROM!)

MEMCheckPattern:
	dc.l	$ffffffff,$aaaaaaaa,$55555555,$f0f0f0f0,$0f0f0f0f,$0f0ff0f0,0,0
MEMCheckPatternFast:
	dc.l	$aaaaaaaa,$55555555,$f0f0f0f0,$0f0f0f0f,0,0

RomFont:
	incbin	"TopazFont.bin"
EndRomFont:
	EVEN

RomMenuCopper:
MenuSprite:
	dc.l	$01200000,$01220000,$01240000,$01260000,$01280000,$012a0000,$012c0000,$012e0000,$01300000,$01320000,$01340000,$01360000,$01380000,$013a0000,$013c0000,$013e0000

	dc.l	$0100b200,$0092003c,$009400d4,$008e2c81,$00902cc1,$01020000,$01080000,$010a0000
	dc.l	$01800000,$01820f00,$018400f0,$01860ff0,$0188000f,$018a0f0f,$018c00ff,$018e0fff,$01900ff0

MenuBplPnt:
	dc.l	$00e00000,$00e20000,$00e40000,$00e60000,$00e80000,$00ea0000
	dc.l	$fffffffe	;End of copperlist
EndRomMenuCopper:
RomMenuCopperSize = EndRomMenuCopper-RomMenuCopper


RomEcsCopper:
	dc.l	$01200000,$01220000,$01240000,$01260000,$01280000,$012a0000,$012c0000,$012e0000,$01300000,$01320000,$01340000,$01360000,$0138000,$013a0000,$013c0000,$013e0000
	dc.l	$01005200,$00920038,$009400d0,$008e2c81,$00902cc1,$01020000,$01080000,$010a0000

	blk.l	32,0
;MenuBplPnt2:
	dc.l	$00e00000,$00e20000,$00e40000,$00e60000,$00e80000,$00ea0000,$00ec0000,$00ee0000,$00f00000,$00f20000

	dc.l	$fffffffe	;End of copperlist
EndRomEcsCopper:
RomEcsCopperSize = EndRomEcsCopper-RomEcsCopper
RomEcsCopper2:
	dc.l	$01200000,$01220000,$01240000,$01260000,$01280000,$012a0000,$012c0000,$012e0000,$01300000,$01320000,$01340000,$01360000,$0138000,$013a0000,$013c0000,$013e0000
	dc.l	$01005200,$00920038,$009400d0,$008e2c81,$00902cc1,$01020000,$01080004,$010a0004

	blk.l	32,0
;MenuBplPnt2:
	dc.l	$00e00000,$00e20000,$00e40000,$00e60000,$00e80000,$00ea0000,$00ec0000,$00ee0000,$00f00000,$00f20000

	dc.l	$fffffffe	;End of copperlist
EndRomEcsCopper2:

ECSColor32:
	dc.w	$000,$fff,$eee,$ddd,$ccc,$aaa,$999,$888,$777,$555,$444,$333,$222,$111,$f00,$800
	dc.w	$400,$0f0,$080,$040,$00f,$008,$004,$ff0,$880,$440,$f0f,$808,$404,$0ff,$088,$044
ECSTestColor:
	dc.w	$000,$aaa,$666,$777,$777,$00b,$76e,$0b0,$397,$790,$0bb,$fff,$971,$b48,$bb0,$888
	dc.w	$999,$333,$b00,$ddd,$333,$444,$555,$666,$777,$888,$999,$aaa,$ccc,$ddd,$eee,$fff
ECSColor16:
	dc.w	$000,$fff,$ddd,$aaa,$888,$555,$333,$f00
	dc.w	$400,$0f0,$040,$00f,$00f,$ff0,$440,$f0f


GFXColTestCopperStart:
	dc.l	$01200000,$01220000,$01240000,$01260000,$01280000,$012a0000,$012c0000,$012e0000,$01300000,$01320000,$01340000,$01360000,$0138000,$013a0000,$013c0000,$013e0000
	dc.l	$01002200,$00920038,$009400d0,$008e2c81,$00902cc1,$01020000,$0108ffd8,$010affd8
	dc.l	$0180000f,$01800000,$01820000,$01840000,$01860000
	dc.l	$00e00000,$00e20000,$00e40000,$00e60000
GFXColTestCopperWait:
	blk.l	8*15,0
;	blk.l	3,0
	dc.l	$01800000,$01820000,$01840000,$01860000
	dc.l	$fffffffe	;End of copperlist

GFXColTestCopperEnd:


Texts:

parfftxt:
	dc.b 	"- Parallel Code $ff - Start of ROM, CPU Seems somewhat alive",$a,$d,0
parfetxt:
	dc.b	"- Parallel Code $fe - Test UDS/LDS line",$a,$d,0
parfdtxt:
	dc.b	"- Parallel Code $fd - Start of chipmemdetection",$a,$d,0
parfctxt:
	dc.b	"- Parallel Code $fc - Trying to find some fastmem (as no chipmem found)",$a,$d,0
parfctxt2:
	dc.b	"- Parallel Code $fc - Trying to find some fastmem (as requested at powerup)",$a,$d,0
parfbtxt:
	dc.b	"- Parallel Code $fb - Memorydetection done",$a,$d,0
parfatxt:
	dc.b	"- Parallel Code $fa - Starting to use detected memory",$a,$d,0
parfatxtdebug:
	dc.b	"   - Debugdata as binary: ",0
parfatxtdebug2:
	dc.b	"  Debugdata done",$a,$d,0
parf9txt:
	dc.b	"- Parallel Code $f9 - Detected memory in use, we now have a stack etc",$a,$d,0
parf8txt:
	dc.b	"- Parallel Code $f8 - Starting up screen, text echoed to serialport",$a,$d,0

par80txt:
	dc.b	"- Parallel Code $80 - NO Chipmem detected",$a,$d,0
par81txt:
	dc.b	"- Parallel Code $fd - Not enough Chipmem detected",$a,$d,0
HALTTXT:
	dc.b	"- NO MEMORY FOUND - HALTING SYSTEM",0


WorkAdrtest:
	dc.b	"- Testing Workarea Address-access",$a,$d,0

RomAdrtest:
	dc.b	"- Testing ROM Address-access",$a,$d,0
RomAdrErr:
	dc.b	$a,$d,"   - Addresserror at: ",0
RomAdrErrors:
	dc.b	$a,$d,27,"[31m  --  Addresserror reading ROM, memoryhandling etc might be corrupt",$a,$d
	dc.b	27,"[0m",0
RamAdrErrors:
	dc.b	$a,$d,27,"[31m  --  Addresserror reading CHIPRAM, marking chipram as unusable",$a,$d
	dc.b	27,"[0m",0
ChipReducedErrors:
	dc.b	$a,$d,27,"[31m  --  Addresserror reading CHIPRAM, but there was some available",$a,$d
	dc.b	"Reducing numer of available 64Kb blocks to: "
	dc.b	27,"[0m$",0
ChipReducedErrors2:
	dc.b	$a,$d,"This might not be an issue, if memory is according to correct size of your system",$a,$d
	dc.b	"It is just an issue in DiagROM chipmemdetectroutine!",$a,$d
	dc.b	"but if not. you have issues to handle!",$a,$d,$a,$d,0

WorkAdrErrors:
	dc.b	$a,$d,27,"[31m  --  Addresserror reading WORKRAM, System is unstable!",$a,$d
	dc.b	27,"[0m",0

RamAdrTest:
	dc.b	"- Testing detected Chipmem for addresserrors",$a,$d,0
RamAdrFill:
	dc.b	"   - Filling memoryarea with addressdata",$a,$d,0
RamAdrErrTxt:
	dc.b	"There was addresserrors. GUESSING those addressbits needs a check:",0
RamAdrErrSkipTxt:
	dc.b	"    Block marked as BAD!",0
RamAdrComp:
	dc.b	$a,$d,"   - Checking block of ram that it contains the correct addressdata",$a,$d,0
writeffff:
	dc.b	"  - Test of writing word $AAAA to $400 ",0
write00ff:
	dc.b	"  - Test of writing word $00AA to $400 ",0
writeff00:
	dc.b	"  - Test of writing word $AA00 to $400 ",0
write0000:
	dc.b	"  - Test of writing word $0000 to $400 ",0
writebeven:
	dc.b	"  - Test of writing byte (even) $AA to $400 ",0
writebodd:
	dc.b	"  - Test of writing byte (odd) $AA to $401 ",0
FastFoundtxt:
	dc.b	"  - Fastmem found between: $",0
NoFastFoundtxt:
	dc.b	"  - No fastmem found, Autoconfig ram NOT checked",$a,$d,0
NoFastFoundSkippedtxt:
	dc.b	"  - Fastmemcheck skipped as we found chipmem",$a,$d,0
ChipSetupInit:
	dc.b	" - Doing Initstuff",$a,$d,0
ChipSetup1:
	dc.b	" - Setting up Chipmemdata",$a,$d,0
ChipSetup2:
	dc.b	"   - Copy Menu Copperlist from ROM to Chipmem",$a,$d,0
ChipSetup3:
	dc.b	"   - Copy ECS TestCopperlist from ROM to Chipmem",$a,$d,0
ChipSetup4:
	dc.b	"   - Copy ECS testCopperlist2 from ROM to Chipmem",$a,$d,0
ChipSetup5:
	dc.b	"   - Fixing Bitplane Pointers etc in Menu Copperlist",$a,$d,0
ChipSetup6:
	dc.b	"   - Copy Audio Data from ROM to Chipmem",$a,$d,0
ChipSetup7:
	dc.b	"   - Do final Bitplanedata in Menu Copperlist",$a,$d,0
ChipSetupDone:
	dc.b	" - Initstuff done!",$a,$d,$a,$d,0
FastOKTxt:
	dc.b	"As a very fast test of variablearea working this SHOULD read OK: ",0
	
OvlTestTxt:
	dc.b	$a,$d,"Testing if OVL is working: ",0

InitSerial:
	dc.b	$a,$d
	dc.b	12,27,"[0m"
InitTxt:
	dc.b	"Amiga DiagROM "
	VERSION
	dc.b	" - "
		incbin	"BootDate.txt"
	dc.b	" - By John (Chucky/The Gang) Hertell",$a,$d,$a,$d,0
LoopSerTest:
	dc.b	$a,$d,"Testing if serial loopbackadapter is installed: ",0

WaitReleasedTxt:
	dc.b	"Waiting for all buttons to be released",$a
	dc.b	"Release all buttons NOW or they will be disabled",$a,0

Initmousetxt:
	dc.b	"    Checking status of mousebuttons at power-on: ",$a,$d
	dc.b	"            ",0
Initmousetxt2:
	dc.b	"    - Checking status of mousebuttons for different startups, if still pressed ",$a,$d
	dc.b	"      we assume not working and ignore those in the future.",$a,$d
	dc.b	"      Green newly pressed, Yellow pressed at startup - Startupaction taken.",$a,$d
	dc.b	"      Red = Pressed at both poweron and now so it is stuck and being ignored",$a,$d,$a,$d
	dc.b	"            ",0
StartupTxt:
	dc.b	$a,$d,27,"[0m  The following special action will be taken: ",$a,$d,0

InitINTENAtxt:
	dc.b	"    Set all Interrupt enablebits (INTENA $dff09a) to Disabled: ",0
InitINTREQtxt:
	dc.b	"    Set all Interrupt requestbits (INTREQ $dff09c) to Disabled: ",0
InitDMACONtxt:
	dc.b	"    Set all DMA enablebits (DMACON $dff096) to Disabled: ",0
InitCOP1LCH:
	dc.b	"    Set Start of copper (COP1LCH $dff080): ",0
InitCOPJMP1:
	dc.b	"    Starting Copper (COPJMP1 $dff088): ",0
InitDMACON:
	dc.b	"    Set all DMA enablebits (DMACON $dff096) to Enabled: ",0
InitBEAMCON0:
	dc.b	"    Set Beam Conter control register to 32 (PAL) (BEAMCON0 $dff1dc): ",0
InitPOTGO:
	dc.b	"    Set POTGO to all OUTPUT ($FF00) (POTGO $dff034): ",0

InitDONEtxt:
	dc.b	"Done",$a,$d,0	
Donetxt:
	dc.b	"Done",$a,0
InitP1LMBtxt:
	dc.b	"P1LMB ",0
InitP2LMBtxt:
	dc.b	"P2LMB ",0
InitP1RMBtxt:
	dc.b	"P1RMB ",0
InitP2RMBtxt:
	dc.b	"P2RMB ",0
InitP1MMBtxt:
	dc.b	"P1RMB ",0
InitP2MMBtxt:
	dc.b	"P2RMB ",0
BadPaulaTXT:
	dc.b	"BADPAULA",0
OvlErrTxt:
	dc.b	"OVLERROR",0
P1LMBActTxt:
	dc.b	"P1LMB - Try to find fastmem and if found use it! if not use chipmem but no display",$a,$d,0
P1RMBActTxt:
	dc.b	"P1RMB - Use beginning of workmem instead of end.",$a,$d,0
	
InitSerial2:
	dc.b	$a,$d,"Please read the readme.txt file in the download archive for instructions"
	dc.b	$a,$d,"DiagROM is mainly for people with technical knowledge of the Amiga"
	dc.b	$a,$d,"and might not be fully 'stright forward' for all - Delivered AS IS"
	dc.b	$a,$d,$a,$d,"To use serial communication please hold down ANY key now",$a,$d
	dc.b	"OR click the RIGHT mousebutton.",$a,$d,0
EndSerial:
	dc.b	27,"[0m",$a,$d,"No key pressed, disabling any serialcommunications.",$a,$d,0

RomCheckTxt:
	dc.b	$a,$a,"Doing ROM Checksumtest: (64K blocks, Green OK, Red Failed)",$a,0


Ansi:
	dc.b	27,"[",0
AnsiNull:
	dc.b	27,"[0m",27,"[40m",27,"[37m",0
Black:
	dc.b	27,"[30m",0
StatusLine:
	dc.b	"Serial: ",1,1,1,1,1," BPS - CPU: ",1,1,1,1,1,"  - Chip: ",1,1,1,1,1,1," - kBFast: ",1,1,1,1,1,1," Base: ",0
Space3:
	dc.b	"   ",0
CPUTxt:
	dc.b	$a,"CPU: ",0
FPUTxt:
	dc.b	" FPU: ",0
MMUTxt:
	dc.b	" MMU: ",0
REVTxt:
	dc.b	" Rev: ",0

	EVEN
	
CPUString:	dc.b	"68000 ",0,"68010 ",0,"68EC20",0,"68020 ",0,"68EC30",0,"68030 ",0,"68EC40",0,"68LC40",0,"68040 ",0,"68EC60",0,"68LC60",0,"68060 ",0,"68FAIL",0,"68???? ",0,"NOCHIP",0
FPUString:	dc.b	"NONE ",0,"68881",0,"68882",0,"68040",0,"68060",0
	EVEN
PCRFlagsTxt:
	dc.b	$a,"PCR Registerflags: ",0

	EVEN
Bps:
	dc.l	BpsNone,Bps2400,Bps9600,Bps38400,Bps115200,BpsLoop
	
BpsNone:
	dc.b	"N/A   ",0
Bps2400:
	dc.b	"2400  ",0
Bps9600:
	dc.b	"9600  ",0
Bps38400:
	dc.b	"38400 ",0
Bps115200:
	dc.b	"115200",0
BpsLoop:
	dc.b	"LOOP  ",0
DOT:
	dc.b	".",0
MINUS:
	dc.b	"-",0
ON:
	dc.b	"ON ",0
OFF:
	dc.b	"OFF",0
YES:
	dc.b	"YES",0
NO:
	dc.b	"NO ",0
NONE:
	dc.b	"NONE",0
NOT:
	dc.b	"NOT",0
SPACE:
	dc.b	" ",0
MB:
	dc.b	"MB",0
KB:
	dc.b	"kB",0
DOWN:
	dc.b	"DOWN",0
UP:
	dc.b	"UP  ",0
LEFT:
	dc.b	"LEFT",0
RIGHT:
	dc.b	"RIGHT",0
FIRE:
	dc.b	"FIRE",0
FAILED:
	dc.b	"FAILED",0
TIMEOUT:
	dc.b	"TIMEOUT",0
DEEP:
	dc.b	"DEEP",0
FAST:
	dc.b	"FAST",0
SLOW:
	dc.b	"SLOW",0
SIMPLE:
	dc.b	"SIMPLE",0
ERRORS:
	dc.b	"Errors: ",0
DELLINE:
	dc.b	27,"[1M",0
SFAILED:
	dc.b	27,"[31mFAILED",27,"[0m",0
DDETECTED:
	dc.b	" DETECTED",$a,$d,0
DETECTEDTxt:
	dc.b	" DETECTED",0
DETECTED:
	dc.b	27,"[32mDETECTED",27,"[0m",0
NoLoopback:
	dc.b	" NOT DETECTED",$a,$d,0
CANCELED:
	dc.b	"CANCELED",0
NOTCHECKED:
	dc.b	"NOT CHECKED",0
II:
	dc.b	" II",0
III:
	dc.b	"III",0
UPPER:
	dc.b	"Upper",0
LOWER:
	dc.b	"Lower",0
OOK:
	dc.b	" "	; Combined with next will generate a space before OK. nothing between here
OK:
	dc.b	"OK",0
SOK:
	dc.b	27,"[32mOK",27,"[0m",0

BAD:
	dc.b	"BAD",0
EXPERIMENTAL:
	dc.b	" - Experimental: ",0
MinusTxt:
	dc.b	" - ",0	
MinusDTxt:
	dc.b	" - $",0	
SPACEOK:
	dc.b	27,"[32m   OK",27,"[0m",0
CHIPOK:
	dc.b	27,"[32m   CHIPMEM OK",27,"[0m",$a,$d,0
WORKOK:
	dc.b	27,"[32m   WORKAREA OK",27,"[0m",$a,$d,0
SPACEFAIL:
	dc.b	27,"[31m  FAILED",27,"[0m",$a,$d,0
ms:
	dc.b	"ms",0
space8:
	dc.b	"        ",0
ticks:
	dc.b	" Ticks",0
Bytes:
	dc.b	" Bytes",0
DF0:
	dc.b	"DF0:",0
DF1:
	dc.b	"DF1:",0
DF2:
	dc.b	"DF2:",0
DF3:
	dc.b	"DF3:",0

Track:
	dc.b	"Track: ",0
Side:
	dc.b	"Side: ",0
Motor:
	dc.b	"Motor: ",0
WProtect:
	dc.b	"WProtection: ",0
DiskIN:
	dc.b	"Disk: ",0
RDY:
	dc.b	"Ready: ",0
TRACK0:
	dc.b	"Track0: ",0
BFE001Txt:
	dc.b	"$bfe001: ",0
BFD100Txt:
	dc.b	"$bfd100: ",0
Det24bittxt:
	dc.b	$a,"Detecting memory in the 24-bit address-space",$a,$a,0
Det32bittxt:
	dc.b	$a,"Detecting memory in the 32-bit address-space",$a,$a,0
No32bittxt:
	dc.b	$a,"Your CPU does not allow 32-bit addressing, Skipping",$a,$a,0
Totmemtxt:
	dc.b	$a,$a,"Total amount of memory detected: ",0

DetMem:
	dc.b	"Detected ",0
DetOfmem:
	dc.b	" of memory between: ",0
EndMemTxt:
	dc.b	"End of memorydetection",$a,0
	
IfSoldTxt:
		;12345678901234567890123456789012345678901234567890123456789012345678901234567890

	dc.b	$a,$a,"IF This ROM is sold, if above 10eur+hardware cost 25% MUST be donated to",$a
	dc.b	"an LEGITIMATE charity of some kind, like curing cancer for example... ",$a
	dc.b	"If you paid more than 10Eur + Hardware + Shipping, please ask what charity you",$a
	dc.b	"have supported!!!      This software is fully open source and free to use.",$a
	dc.b	"Go to www.diagrom.com or http://github.com/ChuckyGang/DiagROM for information",$a,$a,0
	

	EVEN
SerSpeeds:		; list of Baudrates (3579545/BPS)+1
	dc.l	0,1492,373,94,32,0,0
SerText:
	dc.l	BpsNone,Bps2400,Bps9600,Bps38400,Bps115200,BpsLoop,BpsNone
	
Menus:					; Pointers to the menus
	dc.l	MainMenuItems,0,AudioMenuItems,MemtestMenuItems,IRQCIAtestMenuItems,GFXtestMenuItems,PortTestMenuItems,OtherTestItems,DiskTestMenuItems,0,0
MenuCode:				; Pointers to pointers of the menus.
	dc.l	MainMenuCode,0,AudioMenuCode,MemtestMenuCode,IRQCIAtestMenuCode,GFXtestMenuCode,PortTestMenuCode,OtherTestCode,DiskTestMenuCode,0,0
MenuKeys:
	dc.l	MainMenuKey,0,AudioMenuKey,MemtestMenuKey,IRQCIAtestMenuKey,GFXtestMenuKey,PortTestMenuKey,OtherTestKey,DiskTestMenuKey,0,0

MainMenuText:
	dc.b	"                              DiagROM "
		ifne	a1k
		dc.b	"A1000 "
		endc
	VERSION
	EDITION
	dc.b	" - "
	incbin	"BootDate.txt"
	dc.b	$a
	dc.b	"                        By John (Chucky / The Gang) Hertell",$a,$a
	dc.b	"                                       MAIN MENU",$a,$a,0

MainMenu1:
	dc.b	"0 - Systeminfo",0
MainMenu2:
	dc.b	"1 - Audiotests",0
MainMenu3:
	dc.b	"2 - Memorytests",0
MainMenu4:
	dc.b	"3 - IRQ/CIA Tests",0
MainMenu5:
	dc.b	"4 - Graphictests",0
MainMenu6:
	dc.b	"5 - Porttests",0
MainMenu7:
	dc.b	"6 - Drivetests",0
MainMenu8:
	dc.b	"7 - Keyboardtests",0
MainMenu9:
	dc.b	"8 - Other tests",0
MainMenu10:
	dc.b	"S - Setup",0
MainMenu11:
	dc.b	"A - About",0
	EVEN
MainMenuItems:
	dc.l	MainMenuText,MainMenu1,MainMenu2,MainMenu3,MainMenu4,MainMenu5,MainMenu6,MainMenu7,MainMenu8,MainMenu9,MainMenu10,MainMenu11,0,0
MainMenuCode:
	dc.l	SystemInfoTest,AudioMenu,MemtestMenu,IRQCIAtestMenu,GFXtestMenu,PortTestMenu,DiskTest,KeyBoardTest,OtherTest,Setup,About,SwapMode
MainMenuKey:	; Keys needed to choose menu. first byte keykode 2:nd byte serialcode.
	dc.b	"0","1","2","3","4","5","6","7","8","s","a"," ",0
NotImplTxt:
	dc.b	2,"This function is not implemented yet. Anyday.. soon(tm), Thursday?",$a,$a,0
NotA1kTxt:
	dc.b	2,"This function is not available on A1000 version",$a,$a,0
AnyKeyMouseTxt:
	dc.b	2,"Press any key/mouse to continue",0
SetupTxt:
	dc.b	2,"Setupmenu",$a,0


SystemInfoTxt:
	dc.b	2,"Information of this machine:",$a,$a,0
WorkTxt:
	dc.b	"Workmem: ",0
WorkSizeTxt:
	dc.b	" Size: ",0
ChipTxt:
	dc.b	$a,"Chipmem workarea: ",0
FastTxt:
	dc.b	" Fastmem workarea: ",0

RomSizeTxt:
	dc.b	"   ROM size: ",0
WorkOrderTxt:
	dc.b	"  Order: ",0
SystemInfoHWTxt:
	dc.b	2,"Dump of all readable Custom Chipset HW Registers:",$a,0

	EVEN
DriveTestMenu:
	dc.l	DriveTestMenuItems,0
	dc.l	0
DriveTestMenuItems:
	dc.l	DriveTestMenu0,DriveTestMenu1,DriveTestMenu2,DriveTestMenu3,DriveTestMenu4,DriveTestMenu5,DriveTestMenu6,DriveTestMenu7,DriveTestMenu8,DriveTestMenu9,DriveTestMenu10,DriveTestMenu11,DriveTestMenu12,0
DriveTestMenuKey:
	dc.b	"1","2","3","4","5","6","7","8","9","s","0",$1b,0
DriveTestMenu0:
	dc.b	2,"Diskdrivetesting Menu (EXPERIMENTAL Works on SOME machines)",0
DriveTestMenu1:
	dc.b	"1 - Select disk: ",0
DriveTestMenu2:
	dc.b	"2 - Motor",0
DriveTestMenu3:
	dc.b	"3 - Change side",0
DriveTestMenu4:
	dc.b	"4 - Step out",0
DriveTestMenu5:
	dc.b	"5 - Step in",0
DriveTestMenu6:
	dc.b	"6 - Step out 10 tracks",0
DriveTestMenu7:
	dc.b	"7 - Step in 10 tracks",0
DriveTestMenu8:
	dc.b	"8 - Read track to buffer",0
DriveTestMenu9:
	dc.b	"9 - Write track from buffer **DANGEROUS EXPERIMENTAL**",0
DriveTestMenu10:
	dc.b	"S - Show first read sector (random) in buffermem",0
DriveTestMenu11:
	dc.b	"0 - Automatic test of selected disk",0
DriveTestMenu12:
	dc.b	"Esc - Exit from menu",0

AudioMenuText:
	dc.b	2,"Audiotests",$a,$a,0
AudioMenu1:
	dc.b	"1 - Simple waveformtest",0
AudioMenu2:
	dc.b	"2 - Play test-module",0
AudioMenu3:
	dc.b	"9 - MainMenu",0
	EVEN
AudioMenuItems:
	dc.l	AudioMenuText,AudioMenu1,AudioMenu2,AudioMenu3,0
AudioMenuCode:
	dc.l	AudioSimple,AudioMod,MainMenu
AudioMenuKey:
	dc.b	"1","2","9",0

AudioSimpleMenu:
	dc.l	AudioSimpleWaveItems,0
	dc.l	0
AudioSimpleWaveItems:
	dc.l	AudioSimpleWaveText,AudioSimpleWaveMenu1,AudioSimpleWaveMenu2,AudioSimpleWaveMenu3,AudioSimpleWaveMenu4,AudioSimpleWaveMenu5,AudioSimpleWaveMenu6,AudioSimpleWaveMenu7,AudioSimpleWaveMenu8,0,0
AudioSimpleWaveText:
	dc.b	2,"Simple Audiowavetest",0
AudioSimpleWaveMenu1:
	dc.b	"1 - Channel 1:",0
AudioSimpleWaveMenu2:
	dc.b	"2 - Channel 2:",0
AudioSimpleWaveMenu3:
	dc.b	"3 - Channel 3:",0
AudioSimpleWaveMenu4:
	dc.b	"4 - Channel 4:",0
AudioSimpleWaveMenu5:
	dc.b	"5 - Volume:",0
AudioSimpleWaveMenu6:
	dc.b	"6 - Waveform:",0
AudioSimpleWaveMenu7:
	dc.b	"7 - Filter:",0
AudioSimpleWaveMenu8:
	dc.b	"9 - AudioMenu",0
AudioSimpleWaveKeys:
	dc.b	"1","2","3","4","5","6","7","9",0
AudioModTxt:
	dc.b	2,"Play a Protracker module",$a,$a,0
AudioModCopyTxt:
	dc.b	"Copying moduledata from ROM to Chipmem: ",0
AudioModInitTxt:
	dc.b	"Initilize module: ",0
AudioSimpleVolTxt:
	dc.b	2,"Cursor left/right or left/right mousebutton to change volume",0
AudioModPlayTxt:
		;12345678901234567890123456789012345678901234567890123456789012345678901234567890
	dc.b	2,"Starting to play music, Press any key for option (1,2,3,4,f,+,-,l,r)",$a,0
AudioModOptionTxt:	
	dc.b	$a,"         Channel 1:      Channel 2:      Channel 3:      Channel 4:    ",$a
	dc.b	"                  Audio F)ilter:       Mastervolume (+ -):   ",$a,$a,0
AudioModEndTxt:
ButtonExit:
	dc.b	2,"Press any button to exit",0
AudioModName:
	dc.b	$a,"Modulename: ",0
AudioModInst:
	dc.b	$a,"Instruments:",$a,0
	EVEN	
MemtestText:
	dc.b	2,"Memorytests",$a,$a,0
MemtestMenu1:
	dc.b	"1 - Test detected chipmem",0
MemtestMenu2:
	dc.b	"2 - Extended chipmemtest",0
MemtestMenu3:
	dc.b	"3 - Test detected fastmem",0
MemtestMenu4:
	dc.b	"4 - Fast scan of 16MB fastmem-areas",0
MemtestMenu5:
	dc.b	"5 - Slow scan of 16MB fastmem-areas",0
MemtestMenu6:
	dc.b	"6 - Complete Memorydetection",0
MemtestMenu7:
	dc.b	"7 - Manual memorytest (NEW)",0
MemtestMenu8:
	dc.b	"8 - Manual memoryedit",0
MemtestMenu9:
	dc.b	"9 - Autoconfig - Automatic",0
MemtestMenu10:
	dc.b	"0 - Mainmenu",0
	EVEN
MemtestMenuItems:
	dc.l	MemtestText,MemtestMenu1,MemtestMenu2,MemtestMenu3,MemtestMenu4,MemtestMenu5,MemtestMenu6,MemtestMenu7,MemtestMenu8,MemtestMenu9,MemtestMenu10,0
MemtestMenuCode:
	dc.l	CheckDetectedChip,CheckExtendedChip,CheckDetectedMBMem,CheckExtended16MBMem,ForceExtended16MBMem,Detectallmemory,CheckMemManual,CheckMemEdit,AutoConfig,MainMenu
MemtestMenuKey:
	dc.b	"1","2","3","4","5","6","7","8","9","0",0
	EVEN
OtherTestItems:
	dc.l	OtherTestText,OtherTestMenu1,OtherTestMenu2,OtherTestMenu3,OtherTestMenu4,OtherTestMenu5,0
OtherTestText:
	dc.b	2,"Other tests",$a,$a,0
OtherTestMenu1:
	dc.b	"1 - RTC Test",0
OtherTestMenu2:
	dc.b	"2 - Autoconfig - Detailed",0
OtherTestMenu3:
	dc.b	"3 - ShowMemAddress Content",0
OtherTestMenu4:
	dc.b	"8 - TF360/TF1260 Diag",0
OtherTestMenu5:
	dc.b	"9 - Mainmenu",0
	EVEN
OtherTestCode:
	dc.l	RTCTest,AutoConfigDetail,ShowMemAddress,TF1260,MainMenu
OtherTestKey:
	dc.b	"1","2","3","8","9",0

hextab:
	dc.b	"0123456789ABCDEF"	; For bin->hex convertion

MemtestDetChipTxt:
	dc.b	2,"Checking detected chipmem",0
MemtestExtChipTxt:
	dc.b	2,"Checking full Chipmemarea until 2MB or Shadow-Memory is detected",0
MemtestShadowTxt:
	dc.b	2,"Shadowmemory detected. Scan stopped. You can ignore the last error if any!",0
MemtestDetMBMemTxt:
	dc.b	" Detecting A3000/4000 Motherboard memory: Detected: ",0
MemtestDetMBMemTxt2:
	dc.b	" Detecting CPU Card memory: Detected: ",0
MemtestDetMBMemTxt3:
	dc.b	" Detecting Z2 memoryarea: Detected: ",0
MemtestDetMBMemTxtZ:
	dc.b	" Detecting Z3 memoryarea: Detected: ",0
MemtestExtMBMemTxt:
	dc.b	"Scanning for memory on all fastmem-areas (no autoconfig mem will be scanned)",0
MemtestNORAM:
	dc.b	2,"No memory found, Press any key/mouse!",0
MemtestManualTxt:
	dc.b	"                              Manual memoryscan",$a,$a
	dc.b	"Here you can enter a manual value of memoryadress to test, but please remember",$a
	dc.b	"that only NON Autoconfig memory will be possible to test. and if you select an",$a
	dc.b	"illegal area your machine might behave strange/crash etc.",$a,$a,"You are on your own!",$a,$a
	dc.b	"YOU HAVE BEEN WARNED!!!",$a,$a,$a
	dc.b	"Pressing a mousebutton or ESC cancels this screen",$a,$a
	dc.b	"Please enter startaddress to check from: $",0
MemtestManualEndTxt:
	dc.b	$a,$a,$a,"Please enter endadress to check to: $",0
MemtestManualBlockTxt:
	dc.b	$a,$a,$a,"Please enter how many longwords to step to next test: ",0
CheckMemCancelled:
	dc.b	"Memtest cancelled due to: ",0
CheckMemNo:
	dc.b	"Memorypass:            OK Passes:            With error:",0
CheckMemRangeTxt:
	dc.b	"Checking memory from ",1,1,1,1,1,1,1,1,1," to ",1,1,1,1,1,1,1,1,1," - Press any key/mousebutton to stop",0
CheckMemCheckAdrTxt:	
	dc.b	"Checking Address:",1,1,1,1,1,1,1,1,1,1,1,1,0
CheckMemStepSizeTxt:
	dc.b	"Bytes between tests: ",0
CheckMemBitErrTxt:
	dc.b	"|  Bit error shows max $FF errors due to space",$a,$a
CheckMemBitErrTxt2:
	dc.b	"            7|6|5|4|3|2|1|0| 7|6|5|4|3|2|1|0| 7|6|5|4|3|2|1|0| 7|6|5|4|3|2|1|0|",$a,0
CheckMemBitErrsTxt:
	dc.b	"             33222222  22221111  11111100  00000000",$a
	dc.b	"             10987654  32109876  54321098  76543210",$a,0
CheckMemAdrNone:
	dc.b	"--------  --------  --------  --------",0

CheckMemA3ktxt:
	dc.b	2,"Experimental test only! hardcoded to do 2MB Chipmem and A3k/4k 16MB Fast",0
CheckMem16bitTxt:
	dc.b	"On 16 bit system, high 16 bit is same as low 16 bit",$a,0
CheckMemAdrErrTxt:
	dc.b	"   Errors marks bits that MIGHT be bad. CAN be other bits/errors ESTIMATE ONLY",0
CheckMemDBitErrorsTxt:
	dc.b	"Data Errors: ",0
CheckMemABitErrorsTxt:
	dc.b	$a,"ADDR Errors: ",0
CheckMemBitErrorsTxt:
	dc.b	"Bit errors: ",0
	dc.b	"Byte errors:",$a,0
CheckMemCheckedTxt:
	dc.b	"Checked memory: ",0
CheckMemUsableTxt:
	dc.b	"Usable memory: ",0	
CheckMemNonUsableTxt:
	dc.b	"NONUsable memory: ",0
CheckMemNewPassTxt:
	dc.b	"Doing New pass ",0
CheckMem24bitTxt:
	dc.b	" - Issue with new memoryblock to test starting at: ",0
CheckMem24bitTxt2:
	dc.b	"Data mirrors to 24bit area, skipping block as it isn't real",0
CheckMemScanStartTxt:
	dc.b	"---   Scanblock starts at: ",0
CheckMemScanEndTxt:
	dc.b	"---   Scanblock ends at: ",0
CheckMemTotalTxt:
	dc.b	"-- Total errors: ",0
CheckMemTotal2Txt:
	dc.b	" and total addresserrors: ",0
CheckMemTotal3Txt:
	dc.b	" OK memory: ",0
CheckMemBlocksizeTxt:
	dc.b	"Blocksize: ",0
CheckMemModeTxt:
	dc.b	"Mode: ",0
CheckMemFastModeTxt:
	dc.b	"    ---   Running in Fast-Scan mode!",$a
	dc.b	"Only one longword every 1k block is tested and no errors reported",$a
	dc.b	"Result can be aproximate! No shadowmem tests! Used to scan for memoryareas",$a
	dc.b	"Dead block = ALL bits checked failed, most likly no mem at all",$a
	dc.b	"Bad block = Some bits works, most likly bad memory with biterrors",0	
CheckMemNumErrTxt:
	dc.b	"Number of errors:",0
CheckMemNumErrClearTxt:
	dc.b	"          ",0
CheckMemCodeAreaTxt:
	dc.b	"Codearea (Will be ignored in test): ",0
CheckMemWorkAreaTxt:
	dc.b	"Workarea (Will be ignored in test): ",0
CheckMemGoodEndTxt:
	dc.b	"Good Block ends, was between: ",0
CheckMemGoodTxt:
	dc.b	"Good Block start at ",0
CheckMemEndAtTxt:
	dc.b	" and ends at ",0
CheckMemSizeOfTxt:
	dc.b	" with a size of ",0
CheckMemBadTxt:
	dc.b	"Bad Block start at ",0
CheckMemBadEndTxt:
	dc.b	"Bad Block ends, was between: ",0
CheckMemGoodBlockTxt:
	dc.b	"  - Doing addresserrorcheck of 'good' block before accepting it!",0
CheckMemAdrFillTxt:
	dc.b	"Filling area with addressdata       ",0
CheckMemAdrCheckTxt:
	dc.b	"Checking area for same addressdata  ",0
;CheckMemAdrEndTxt:
	dc.b	"Addresserror ends, was between: ",0
CheckMemAdrErrorTxt:
	dc.b	"Addresserrors starts at: ",0
CheckMemDeadTxt:
	dc.b	"Dead Block start at ",0
CheckMemEditTxt:
	dc.b	"  Manual Memoryedit. BE WARNED, EVERYTHING HAPPENS IN REALTIME! NO PROTECTION!",$a
	dc.b	"G)oto address  R)efresh  H)Cache:      ESC)Main Menu   Q/Z Pdup/down  X)ecute",$a,0
CheckMemEditGotoTxt:
	dc.b	"Enter address to dump memory from: $",0
CheckMemExecuteTxt:
	dc.b	"Execute from ",0
CheckMemExecuteTxt2:
	dc.b	", Are you sure? (y/n)",0

CheckMemAdrTxt:
	dc.b	"Current address: ",0
CheckMemBinaryTxt:
	dc.b	"Current byte in binary: ",0
MousePressTxt:
	dc.b	"Mousebutton pressed",0
KeyPressTxt:
	dc.b	"Keyboard pressed",0
SerialPressTxt:
	dc.b	"Serial input",0
OtherPressTxt:
	dc.b	"HUH!? no idea!",0
IRQCIATestText:
	dc.b	2,"IRQ & CIA Tests",$a,$a,0
IRQCIATestMenu1:
	dc.b	"1 - Test IRQs",0
IRQCIATestMenu2:
	dc.b	"2 - Test CIAs",0
IRQCIATestMenu3:
	dc.b	"3 - New Experimental Test CIAs",0
IRQCIAtestMenu7:
	dc.b	"9 - Mainmenu",0
	EVEN

IRQLev1Txt:
	dc.b	"Testing IRQ Level 1: ",0
IRQLev2Txt:
	dc.b	"Testing IRQ Level 2: ",0
IRQLev3Txt:
	dc.b	"Testing IRQ Level 3: ",0
IRQLev4Txt:
	dc.b	"Testing IRQ Level 4: ",0
IRQLev5Txt:
	dc.b	"Testing IRQ Level 5: ",0
IRQLev6Txt:
	dc.b	"Testing IRQ Level 6: ",0
IRQLev7Txt:
	dc.b	"Testing IRQ Level 7 (WILL Fail unless you press a custom IRQ7 button): ",0
IRQTestDone:
	dc.b	$a,$a,$a,"IRQ Tests done",$a,0

CIATestTxt:
	dc.b	2,"CIA Tests. Check if your CIAs can time stuff. REQUIRES LEV3 IRQ!",$a,$a,0
CIATestTxt2:
	dc.b	2,"Press any key to start tests (aprox 2 sec/each), Press ESC for mainmenu",$a,$a,$a,0
CIATestTxt3:
	dc.b	2,"Flashing on screen is fully normal, indicating CIA timing. NTSC Will fail",$a,$a,0
CIATestTxt4:
	dc.b	"                                  PAL     NTSC     Result",$a,$a,0
CIATestTxt5:
	dc.b	"Result may vary of current screenmode (changeable by spacebar in mainmenu)",$a
	dc.b	"and HW settings so OK in any location is generally a good result!",$a,$a,0
CIAATestAATxt:
	dc.b	"Testing Timer A, on CIA-A (ODD) :",0
CIAATestBATxt:
	dc.b	"Testing Timer B, on CIA-A (ODD) :",0
CIATestATOD:
	dc.b	"Testing CIA-A TOD (Tick/VSync)  :",0
CIAATestABTxt:
	dc.b	"Testing Timer A, on CIA-B (EVEN):",0
CIAATestBBTxt:
	dc.b	"Testing Timer B, on CIA-B (EVEN):",0
CIATestBTOD:
	dc.b	"Testing CIA-B TOD (HSync)       :",0
CIATooSlow:
	dc.b	" Slow   ",0
CIATooFast:
	dc.b	" Fast   ",0
CIAOK:
	dc.b	"  OK    ",0
VblankOverrunTXT:
	dc.b	" - CIA Timing too slow! ",0
VblankUnderrunTXT:
	dc.b	" - CIA Timing too fast! ",0
CIATickSlowTxt:
	dc.b	" - Too slow ticksignal ",0
CIATickFastTxt:
	dc.b	" - Too fast ticksignal ",0

CIANoRasterTxt:
	dc.b	2,"CIA Tests requires a working raster, Unable to test",$a,$a,0
CIANoRasterTxt2:
	dc.b	2,"Press any key to return to Main Menu",$a,0
	

	EVEN
IRQCIAtestMenuItems:
	dc.l	IRQCIATestText,IRQCIATestMenu1,IRQCIATestMenu2,IRQCIATestMenu3,IRQCIAtestMenu7,0,0
IRQCIAtestMenuCode:
	dc.l	IRQCIAIRQTest,IRQCIACIATest,IRQCIATest,MainMenu
IRQCIAtestMenuKey:
	dc.b	"1","2","3","9",0

IRQCIAIRQTestText:
	dc.b	2,"Testing IRQ Levels. Press any key to start.   ESC or RMB to exit",$a,$a,0
IRQCIAIRQTestText2:
	dc.b	2,"Screen Flashing during test is normal, it is a sign that IRQ is executed",$a,$a,0

	EVEN
GFXtestMenuItems:
	dc.l	GFXtestText,GFXtestMenu1,GFXtestMenu2,GFXtestMenu3,GFXtestMenu4,GFXtestMenu5,GFXtestMenu6,0
GFXtestMenuCode:
	dc.l	GFXTestScreen,GFXtest320x200,GFXTestScroll,GFXTestRaster,GFXTestRGB,MainMenu,0
GFXtestMenuKey:
	dc.b	"1","2","3","4","5","9",0
GFXtestText:
	dc.b	2,"Graphicstests",$a,$a,0
GFXtestMenu1:
	dc.b	"1 - Testpicture in lowres 32Col",0
GFXtestMenu2:
	dc.b	"2 - Testscreen 320x200",0
GFXtestMenu3:
	dc.b	"3 - Test Scroll",0
GFXtestMenu4:
	dc.b	"4 - Test raster (button to exit)",0
GFXtestMenu5:
	dc.b	"5 - RGB-test",0
GFXtestMenu6:
	dc.b	"9 - Exit to mainmenu",0
GFXtestNoSerial:
	dc.b	$a,$d,$a,$d,"GRAPHICTEST IN ACTION, Serialoutput is not possible during test",$a,$d,$a,$d,0
GFXtestRasterTxt:
	dc.b	2,"CPU Busywaiting for raster, flicker is normal.",$a,0
GFXtestRasterTxt2:
	dc.b	2,"As testing keys/serial etc takes too much time.",0
PortTestText:
	dc.b	2,"Porttests",$a,$a,0
PortTestMenu1:
	dc.b	"1 - Parallel Port",0
PortTestMenu2:
	dc.b	"2 - Serial Port",0
PortTestMenu3:
	dc.b	"3 - Joystick/Mouse Ports",0
PortTestMenu4:
	dc.b	"9 - Mainmenu",0
	EVEN
PortTestMenuItems:
	dc.l	PortTestText,PortTestMenu1,PortTestMenu2,PortTestMenu3,PortTestMenu4,0
PortTestMenuCode:
	dc.l	PortTestPar,PortTestSer,PortTestJoystick,MainMenu
PortTestMenuKey:
	dc.b	"1","2","3","9",0


DiskTestText:
	dc.b	2,"Disktests",$a,$a,0
DiskTestMenu1:
	dc.b	"1 - Diskdrivetest (experimental)",0
DiskTestMenu2:
	dc.b	"2 - Gayletest (A600/1200 etc IDE)",0
DiskTestMenu3:
	dc.b	"3 - Gary-IDE test (A4000)",0
DiskTestMenu4:
	dc.b	"9 - Mainmenu",0
	EVEN
DiskTestMenuItems:
	dc.l	DiskTestText,DiskTestMenu1,DiskTestMenu2,DiskTestMenu3,DiskTestMenu4,0
DiskTestMenuCode:
	dc.l	DiskdriveTest,GayleTest,GayleExp,MainMenu
DiskTestMenuKey:
	dc.b	"1","2","3","9",0

	ifeq	a1k

PortParTest:
	dc.b	2,"Parallelport tests",$a,$a,0
PortParTest1:
	dc.b	"To start paralleltest, make sure loopback is connected and press",$a
	dc.b	"any key to start, Press ESC or Right mouse to exit!",$a,$a,0
PortParTest2:
	dc.b	"Build a loopback adapter: Connect 1-10,2-3,4-5,6-7,9-11,8-12-13",$a
	dc.b	"14[+5V] -> LED+270ohm -> 18[GND] (LED will be bright if +5V gives power!)",$a,0
	
PortParTest3:
	dc.b	$a,"Test is running, any button to exit!",0
PortParTest12:
	dc.b	$a,"Testing Bit 1->2: ",0
PortParTest21:
	dc.b	$a,"Testing Bit 2->1: ",0
PortParTest34:
	dc.b	$a,"Testing Bit 3->4: ",0
PortParTest43:
	dc.b	$a,"Testing Bit 4->3: ",0
PortParTest56:
	dc.b	$a,"Testing Bit 5->6: ",0
PortParTest65:
	dc.b	$a,"Testing Bit 6->5: ",0
PortParTest7p:
	dc.b	$a,"Testing Bit 7->Paper out: ",0
PortParTest7s:
	dc.b	$a,"Testing Bit 7->Select: ",0
PortParTestp7:
	dc.b	$a,"Testing Paper out->Bit 7: ",0
PortParTests7:
	dc.b	$a,"Testing Select->Bit 7: ",0
PortParTest8b:
	dc.b	$a,"Testing Bit 8->Busy: ",0
PortParTestb8:
	dc.b	$a,"Testing Busy->Bit 8: ",0


PortSerTest:
	dc.b	2,"Serialport tests",$a,$a,0
PortSerTest1:
	dc.b	"To start serialtest, make sure loopback is connected and press",$a
	dc.b	"any key to start, This means if you are using serialconsole",$a
	dc.b	"you need to change that cable to a loopback adapter and not use",$a
	dc.b	"Serialport for controlling DiagROM!",$a,$a
	dc.b	"Press ESC or Right mouse to exit!",$a,$a,0
PortSerTest2:
	dc.b	"Build a loopback adapter: Connect 2-3, 4-5-6, 8-20-22",$a
	dc.b	"9[+12V] -> LED+1Kohm -> 7[GND]",$a
	dc.b	"7[GND] -> LED+1Kohm -> 10[-12V]",$a
	dc.b	"LED will be bright if +12 and -12V gives power",$a,0

PortSerBps:
	dc.b	"   BPS: ",0
PortSerTest3:
	dc.b	$a,$a,"Testing sending a 60 bytes test, number of correct received chars:        ",0
PortSerTestB45:
	dc.b	$a,"Testing pin 4 (RTS) to pin 5 (CTS):",0
PortSerTestB46:
	dc.b	$a,"Testing pin 4 (RTS) to pin 6 (DSR):",0
PortSerTestB208:
	dc.b	$a,"Testing pin 20 (DTR) to pin 8 (CD):",0

PortSerString:
	;	 123	456789012345678901234567890123456789012345678901234567890"
	dc.b	"This is a serialporttest for loopbackadapter! NOT Console!",$a,$d,0

PortJoyTest:
	dc.b	2,"Joystickport tests",$a,$a,0
PortJoyTest1:
	dc.b	2,"Dumping data of hardwareregisters:",$a,$a,0
PortJoyTestHW1:
	dc.b	2,"JOY0DAT ($DFF00A):       BIN:                 ",$a,0
PortJoyTestHW2:
	dc.b	2,"JOY1DAT ($DFF00C):       BIN:                 ",$a,0
PortJoyTestHW3:
	dc.b	2,"POT0DAT ($DFF012):       BIN:                 ",$a,0
PortJoyTestHW4:
	dc.b	2,"POT1DAT ($DFF014):       BIN:                 ",$a,0
PortJoyTestHW5:
	dc.b	2,"POTINP  ($DFF016):       BIN:                 ",$a,0
PortJoyTestHW6:
	dc.b	2,"CIAAPRA ($BFE001):       BIN:                 ",$a,0

PortJoyTest2:
	dc.b	2,"Joystick positions",$a,$a,0
PortJoyTest3:
	dc.b	2,"PORT0                               PORT1",0
PortJoyTestExitTxt:
	dc.b	2,"Exit with both mousebuttons or ESC",0


	endc

KeyBoardTestText:
	dc.b	2,"Keyboardtest ESC or mouse to exit",$a,$a,0
KeyBoardTestCodeTxt:
	dc.b	"Current Scancode read from Keyboardbuffer:      Keyboardcode:      Char: ",$a,0
KeyBoardTestCodeTxt2:
	dc.b	"Scancode binary:           HEX:      Keyboardcode binary:           HEX: ",0

ByteTxt:
	dc.b 	"Byte",0
WordTxt:
	dc.b	"Word",0
LongWordTxt:
	dc.b	"Longword",0


	ifeq	a1k


RTCByteTxt:
	dc.b	"Raw RTC data in hex:",$a,0

RTCBitTxt:
	dc.b	"Raw RTC data in binary:",$a,0
RTCRicoh:
	dc.b	"Ricoh Chipset output:",$a,0
RTCOKI:
	dc.b	"OKI Chipset output:",$a,0
	EVEN
RTCMonth:
	dc.b	"Jan",0
	dc.b	"Feb",0
	dc.b	"Mar",0
	dc.b	"Apr",0
	dc.b	"May",0
	dc.b	"Jun",0
	dc.b	"Jul",0
	dc.b	"Aug",0
	dc.b	"Sep",0
	dc.b	"Oct",0
	dc.b	"Nov",0
	dc.b	"Dec",0
	dc.b	"BAD",0
RTCDay:
	dc.b	"   Sunday",0
	dc.b	"   Monday",0
	dc.b	"  Tuesday",0
	dc.b	"Wednesday",0
	dc.b	" Thursday",0
	dc.b	"   Friday",0
	dc.b	" Saturday",0	

RTCIrq:
	dc.b	2,"Press space/left mouse to enable IRQ Timing for RTC Adjusting",$a,0
RTCIrq2:
	dc.b	2,"Requires working IRQ3 Interrupt.  Both mouse to exit (or ESC)",0

RTCadjust1:
	dc.b	"Number of frames during 1 sec RTC test    (50 = PAL, 60 = NTSC): ",$a,0
RTCadjust10:
	dc.b	"Number of frames during 10 sec RTC test (500 = PAL, 600 = NTSC): ",$a,0

	endc

FastDetectTxt:
	dc.b	$a,$a,"Checking for fastmem",$a
	dc.b	"Pressing left mousebutton will cancel detection (if hanged)",$a,$a,0

	ifeq	a1k

AutoConfBoardsTxt:
	dc.b	$a,"Number of boards: ",0
AutoConfZ2Txt:
	dc.b	"Scanning Zorro II Area",$a,0
AutoConfZ3Txt:
	dc.b	"Scanning Zorro III Area",$a,0
AutoConfIllegalTxt:
	dc.b	$a,"  -- ILLEGAL CONFIGURATION, ZORROAREA OVERFLOW - SHUTTING DOWN CARD",$a,0
AutoConfAllTxt:
	dc.b	$a,"All boards done!",$a,0	
AutoConfBoardTxt:
	dc.b	$a,"Board #",0
AutoConfManuTxt:
	dc.b	$a,"  Manufacturer: ",0
AutoConfManuTxt2:
	dc.b	$a,"ID: ",0
AutoConfSerTxt:
	dc.b	"  Serialnumber: ",0
AutoConfZorTypeTxt:
	dc.b	$a,"     Zorrotype: ",0
AutoconfZorType2Txt:
	dc.b	" Zorro ",0
AutoConfLinkTxt:
	dc.b	"  Link to system free pool: ",0
AutoConfAutoBTxt:
	dc.b	"  Autoboot: ",0
AutoConfLinked2NextTxt:
	dc.b	$a,"     Linked to next board: ",0
AutoConfExtSizeTxt:
	dc.b	"  Extended size: ",0
AutoConfSizeTxt:
	dc.b	"  Size: ",0
AutoConfBufTxt:
	dc.b	$a,"  Autoconfigbuffer: ",0
AutoConfRamCardTxt:
	dc.b	$a,"    Zorro II Memory detected and assigned to: ",0
AutoConfRomCardTxt:
	dc.b	$a,"    Zorro II I/O detected and assigned to: ",0
AutoConfZ3CardTxt:
	dc.b	$a,"    Zorro III Card detected and assigned to: ",0
AutoConfEnableTxt:
	dc.b	$a,"Assign board? Y)es (LMB) N)o (RMB) (If possible) or ESC)Exit",$a,0
AutoConfAssignZ2Ram:
	dc.b	$a,"Assigning RAM from $",0
AutoConfAssignZ2IO:
	dc.b	$a,"Assigning I/O from $",0
AutoConfAssignTo:
	dc.b	" to $",0
AutoConfToomuchTxt:
	dc.b	$a,"  ** ERRROR, looping autoconfig detected. (BUG!) exiting",$a,$a,0
	EVEN

	endc

SectorErrorTxt:
	dc.b	2,"Error finding sector possibly readerror",$a,$a,0
A24BitTxt:
	dc.b	"Checking if a 24 Bit address cpu is used: ",0
A3k4kMemTxt:
	dc.b	" - Checking for A3000/A4000 Motherboardmemory",$a,0
CpuMemTxt:
	dc.b	" - Checking for CPU-Board Memory (most A3k/A4k)",$a,0
A1200CpuMemTxt:
	dc.b	" - Checking for CPU-Board Memory (most A1200)",$a,"    (WILL crash with A3640/A3660 and Maprom on)",$a,0
a24BitAreaTxt:
	dc.b	" - Checking for Memory in 24 Bit area (NON AUTOCONFIG)",$a,0
FakeFastTxt:
	dc.b	" - Checking for Memory in Ranger or Fakefast area",$a,0
WorkAreasTxt:
	dc.b	$a,"Extra workareas Chipmem: ",0
WorkAreasTxt2:
	dc.b	"  Fastmem: ",0	

BPPCtxt:
	dc.b	"   - BPPC Found, detecting in a smaller memoryarea",$a,0
S8MB:
	dc.b	"8MB",0
S64k:
	dc.b	"64KB",0
S128k:
	dc.b	"128KB",0
S256k:
	dc.b	"256KB",0
S512k:
	dc.b	"512KB",0
S1MB:
	dc.b	"1MB",0
S2MB:
	dc.b	"2MB",0
S4MB:
	dc.b	"4MB",0
S16MB:
	dc.b	"16MB",0
S32MB:
	dc.b	"32MB",0
S64MB:
	dc.b	"64MB",0
S128MB:
	dc.b	"128MB",0
S256MB:
	dc.b	"256MB",0
S512MB:
	dc.b	"512MB",0
S1GB:
	dc.b	"1GB",0
SRes:
	dc.b	"RESERVED",0
YellowTxt:
	dc.b	27,"[33m",0
GreenTxt:
	dc.b	27,"[32m",0
RedTxt:
	dc.b	27,"[31m",0
TryTxt:
	dc.b	" Try: ",0
	EVEN
SizeTxtPointer:
	dc.l	S8MB,S64k,S128k,S256k,S512k,S1MB,S2MB,S4MB
SizePointer:
	dc.l	$800000,$10000,$20000,$40000,$80000,$100000,$200000,$400000
ExtSizeTxtPointer:
	dc.l	S16MB,S32MB,S64MB,S128MB,S256MB,S512MB,S1GB,SRes
ExtSizePointer:
	dc.l	$1000000,$2000000,$4000000,$8000000,$10000000,$20000000,$40000000,$80000000


	ifeq	a1k

GayleCheckMirrorTxt:
	dc.b	"Gayle test (built-in IDE Controller check)",$a,$d,$a,$d
	dc.b	"Checking for a chipset mirror: ",0
IDEInterruptCheck:
	dc.b	"    Checking if we have a pending IDE Interrupt.",$a,$d,0
IDEInterruptDetected:
	dc.b	"    IDE Interrupt Detected",$a,$d,0
IDEInterruptCleared:
	dc.b	"    IDE Interrupt Cleared at the drive",$a,$d,0
IDEInterruptChangedReading:
	dc.b	"    Reading Gayle IntChanged: ",0
IDEInterruptStatusReading:
	dc.b	"   Reading Gayle IntStatus: ",0
GayleMirrorTxt:
	dc.b	"Mirror Detected",$a,$d,0
GayleNoMirrorTxt:
	dc.b	"Mirror Not Detected",$a,$d,0
A600Txt:
	dc.b	" - A600 Gayle",0
A1200Txt:
	dc.b	" - A1200 Gayle",0
UnknownTxt:
	dc.b	" - Unknown Gayle",0
NoDiskTxt:
	dc.b	$a,$d,$a,$d,"No disk found",$a,$d,0
NoGayleTxt:
	dc.b	$a,$d,$a,$d,"No Gayle detected",$a,$d,0
GayleIDETxt:
	dc.b	"IDE Interface found (Running IDE Tests)",$a,$d,0
GayleNoIDETxt:
	dc.b	"NO IDE Interface found",$a,$d,0
GayleVerTxt:
	dc.b	"Reading Gayleversion: ",0
GayleRDYTxt:
	dc.b	"    Waiting for Drive RDY (Mask 0xc1): ",0
GayleIDERead:
	dc.b	"    Reading data from drive: ",0
IDESurfacesTxt:
	dc.b	"Surfaces: ",0
IDESectorsTxt:
	dc.b	" Sectors: ",0
IDECylindersTxt:
	dc.b	" Cylinders: ",0
IDEBlkSize:
	dc.b	" Blocksize: ",0
IDEUnitTxt:
	dc.b	"Unitname: ",0
	endc

TF1260Txt:
	dc.b	2,"TF360 / TF1260 Diagnose",0
TF1260ControllerTxt:
	dc.b	$a,$a," - TF Controller: ",0
TF1260MemTxt:
	dc.b	$a," - TF Memory: ",0
TF1260NotTxt:
	dc.b	$a,$a,"NO TF360/1260 Found, Edit not possible",$a,0
TF1260AutoConfNotTxt:
	dc.b	"Autoconfig isn't done. Doing a scan now",$a,0
ShowMemAdrTxt:
	dc.b	2,"Constantly monitor memaddress quit with buttonpress",$a,0
ShowMemAdrTxt2:
	dc.b	2,"Only useful for dev of hardware not as a functiontest",$a,0
ShowMemAdrTxt3:
	dc.b	$a,"Memoryaddress to monitor: $",0
ShowMemTypeTxt:
	dc.b	$a,"B)yte, W)ord or L)ongword (other quit)",0
ShowMemTxt:
	dc.b	"Monitoring content of address: ",0

FlagTxt:
	dc.b	$a,"                   -----CPUID-----| CPURev|E*****DE",0

Divider2Txt:
	dc.b	$a,$d
DividerTxt:
	dc.b	"--------------------------------------------------------------------------------",0
EmptyRowTxt:
	dc.b	"                                                                                ",0

DetChipTxt:
	dc.b	"Detected Chipmem: ",0
DetMBFastTxt:
	dc.b	"Detected Motherboard Fastmem (not reliable result): ",0
BaseAdrTxt:
	dc.b	"Basememory address (Start of workarea): ",0
DetectRasterTxt:
	dc.b	"Detecting if we have a working raster: ",0
NoDrawTxt:
	dc.b	"We are in a nonchip/nodraw mode. Serialoutput is all we got. colorflash on screen",$a,$d
	dc.b	"is actually chars that should be printed on screen. telling user something happens",$a,$d,0
NewLineTxt:
	dc.b	$a,$d,0
DotTxt:
	dc.b	".",0
SpaceTxt:
	dc.b	" ",0
SpacesTxt:
	dc.b	"  ",0
FiveSpacesTxt:
	dc.b	"     ",0
TenSpacesTxt:
	dc.b	"          ",0
ColonTxt:
	dc.b	" : ",0
SlashTxt:
	dc.b	"/",0
RAMTxt:
	dc.b	"RAM",0
IOTxt:
	dc.b	"I/O",0
StartTxt:
	dc.b	" Start: ",0
EndTxt:
	dc.b	" End: ",0
StartTxt2:
	dc.b	"Start",0
EndTxt2:
	dc.b	"End",0

BLTDDATTxt:
	dc.b	"BLTDDAT ($dff000): ",0
DMACONRTxt:
	dc.b	"DMACONR  ($dff002): ",0
VPOSRTxt:
	dc.b	"VPOSR   ($dff004): ",0
VHPOSRTxt:
	dc.b	"VHPOSR  ($dff006): ",0
DSKDATRTxt:
	dc.b	"DSKDATR  ($dff008): ",0
JOY0DATTxt:
	dc.b	"JOY0DAT ($dff00a): ",0
JOY1DATTxt:
	dc.b	"JOY1DAT ($dff00c): ",0
CLXDATTxt:
	dc.b	"CLXDAT   ($dff00e): ",0
ADKCONRTxt:
	dc.b	"ADKCONR ($dff010): ",0
POT0DATTxt:
	dc.b	"POT0DAT ($dff012): ",0
POT1DATTxt:
	dc.b	"POT1DAT  ($dff014): ",0
POTINPTxt:
	dc.b	"POTINP  ($dff016): ",0
SERDATRTxt:
	dc.b	"SERDATR ($dff018): ",0
DSKBYTRTxt:
	dc.b	"DSKBYTR  ($dff01a): ",0
INTENARTxt:
	dc.b	"INTENAR ($dff01c): ",0
INTREQRTxt:
	dc.b	"INTREQR ($dff01e): ",0
DENISEIDTxt:
	dc.b	"DENISEID ($dff07c): ",0
HHPOSRTxt:
	dc.b	"HHPOSR  ($dff1dc): ",0

DoesNotWorkTxt:
	dc.b	"THIS FUNCTION IS CURRENTLY NOT RELIABLE!",0
SSPErrorTxt:
	dc.b	2,"oOoooops Something went borked",0
BusErrorTxt:
	dc.b	2,"BusError Detected",0
AddressErrorTxt:
	dc.b	2,"AddressError Detected",0
IllegalErrorTxt:
	dc.b	2,"Illegal Instruction Detected",0
DivByZeroTxt:
	dc.b	2,"Division by Zero Detected",0
ChkInstTxt:
	dc.b	2,"Chk Inst Detected",0
TrapVTxt:
	dc.b	2,"Trap V Detected",0
PrivViolTxt:
	dc.b	2,"Privilige Violation Detected",0
TraceTxt:
	dc.b	2,"Trace Detected",0
UnImplInstrTxt:
	dc.b	2,"Unimplemented instruction Detected",0
TrapTxt:
	dc.b	2,"TRAP Detected",0
DebugTxt:
	dc.b	"Debugdata (Dump of CPU Registers D0-D7/A0-A7):",0
DebugIRQ:
	dc.b	"IRQ Level ",0
DebugIRQPoint:
	dc.b	" Points to: ",0
DebugContent:
	dc.b	" Content: ",0
DebugSR:
	dc.b	"SR: ",0
DebugADR:
	dc.b	" ADR: ",0
DebugPWR:
	dc.b	$a,"Poweronflags: ",0
DebugROM:
	dc.b	"Is $1114 readable at addr $0 (ROM still at $0): ",0
DebugROM2:	
	dc.b	"Is $1114 readable at addr $f80000 (Real ROM addr): ",0
DebugROM3:
	dc.b	$a,"Is $1111 readable at addr $f00000 (expansion ROM addr): ",0	
HaltTxt:
	dc.b	$a,$d,"PANIC! System halted, not enough resources found to generate better dump",$a,$d,0
StuckButtons:
	dc.b	$a,$d,"Stuck buttons & keys etc at boot: ",0
	EVEN
HexTxt:
	dc.b	"HEX: ",0
AddrTxt:
	dc.b	$d,"Addr $",0
	EVEN
StartAddrTxt:
	dc.b	$a,$d,"Startaddr: $",0
EndAddrTxt:
	dc.b	"  Endaddr: $",0
WTxt:
	dc.b	$a,$d,"       Write: $",0
RTxt:
	dc.b	$a,$d,"        Read: $",0
Txt64KBlock:
	dc.b	"  Number of 64K blocks found: $",0
PassTxt:
	dc.b	" Pass: ",0
PinTxt:
	dc.b	$a,"Pin no: ",0
Base1Txt:
	dc.b	$a,$d,"  Using $",0
Base2Txt:
	dc.b	" as start of workmem (Base)",$a,$d,$a,$d,0
UnderDevTxt:
	dc.b	2,"This function is under development, output can be weird, strange and false",$a,$d,$a,$d,0
NoChiptxt:
	dc.b	$a,$d,"NO Chipmem detected",$a,$d,0
NotEnoughChipTxt:
	dc.b	"Not enough chipmem detected",$a,$a,0
ShadowChiptxt:
	dc.b	$a,$d,"Chipmem Shadowram detected, guess there is no more chipmem, stopping here",$a,$d,0
	ifeq	a1k
AboutTxt:
	dc.b	2,"About DiagROM",0
AboutTxt2:
	dc.b	$a,$a,"Coding by: John 'Chucky' Hertell",$a,$a
	dc.b	"Small code-example help from Stephen Leary, HighPuff",$a,$a
	dc.b	"          IMPORTANT ABOUT THIS TOOL! also: http://www.diagrom.com",$a,$a
	dc.b	"It is delivered AS-IS! No Warranty!  Mail suggestions to chucky@thegang.nu",$a,$a
	dc.b	"This is a tool for people with technical know-how of the Amiga system and it",$a
	dc.b	"will not give a pointer saying 'Chip XX is dead', So it is not for people who",$a
	dc.b	"randomly just swap chips, you need to do a proper diagnose with this tool",$a,$a
	dc.b	"However I hope you have use of this program and do please send me a mail",$a
	dc.b	"telling what you like and what you do NOT like in it",$a,$a
	dc.b	"I love all kind of suggestions possible also if you have code-examples how to",$a
	dc.b	"detect different issues etc, PLEASE contact me",$a,$a
	dc.b	"Some good-to-know facts: Pressing mousebuttons at powerup (and release after a",$a
	dc.b	"short while (or it will be misstaken as stuck and will be ignored)",$a,$a
	dc.b	"Mouseport 1: Left mouse, Disable screen output, if fastmem found use it",$a
	dc.b	"             Right mouse, Instead of using end of mem as work, use start",$a,$a
	dc.b	"Serial output HIGHLY recomended: 9600 BPS, 8N1, No handshaking used!",$a,$a
	dc.b	"Press any key or button!",0

	endc

bytehextxt:
	dc.b	"000102030405060708090A0B0C0D0E0F"
	dc.b	"101112131415161718191A1B1C1D1E1F"
	dc.b	"202122232425262728292A2B2C2D2E2F"
	dc.b	"303132333435363738393A3B3C3D3E3F"
	dc.b	"404142434445464748494A4B4C4D4E4F"
	dc.b	"505152535455565758595A5B5C5D5E5F"
	dc.b	"606162636465666768696A6B6C6D6E6F"
	dc.b	"707172737475767778797A7B7C7D7E7F"
	dc.b	"808182838485868788898A8B8C8D8E8F"
	dc.b	"909192939495969798999A9B9C9D9E9F"
	dc.b	"A0A1A2A3A4A5A6A7A8A9AAABACADAEAF"
	dc.b	"B0B1B2B3B4B5B6B7B8B9BABBBCBDBEBF"
	dc.b	"C0C1C2C3C4C5C6C7C8C9CACBCCCDCECF"
	dc.b	"D0D1D2D3D4D5D6D7D8D9DADBDCDDDEDF"
	dc.b	"E0E1E2E3E4E5E6E7E8E9EAEBECEDEEEF"
	dc.b	"F0F1F2F3F4F5F6F7F8F9FAFBFCFDFEFF"
	dc.b	0


EnglishKey:
	dc.b	"�1234567890-=| 0"
	dc.b	"qwertyuiop[] "; 1c
	dc.b	"123asdfghjkl;`" ; 2a
	dc.b	"  456 zxcvbnm,./ " ;3b
	dc.b	".789 "
	dc.b	8 ; backspace
	dc.b	9 ; Tab
	dc.b	$d ; Return
	dc.b    $a ; Enter (44)
	dc.b	27 ; esc
	dc.b	127 ; del
	dc.b	"   " ; Undefined
	dc.b	"-" ; - on numpad
	dc.b	" " ; Undefined
	dc.b	30 ; Up
	dc.b	31 ;down
	dc.b	28 ; forward
	dc.b	29 ; backward
	dc.b	"1" ;f1
	dc.b	"2" ;f2
	dc.b	"3" ;f3
	dc.b	"4" ;f4
	dc.b	"5" ;f5
	dc.b	"6" ;f6
	dc.b	"7" ;f7
	dc.b	"8" ;f8
	dc.b	"9" ;f9
	dc.b	"0" ;f10
	dc.b	"()/*+"
	dc.b	0 ; Help
EnglishKeyShifted:
	; Shifted
	dc.b	"~!@#$%^& ()_+| 0QWERTYUIOP{} 123ASDFGHJKL:",34,"  456 ZXCVBNM<>? .789          - "
	dc.b	1 ; Up
	dc.b	2 ;down
	dc.b	0 ; forward
	dc.b	0 ; backward
	dc.b	0 ;f1
	dc.b	0 ;f2
	dc.b	0 ;f3
	dc.b	0 ;f4
	dc.b	0 ;f5
	dc.b	0 ;f6
	dc.b	0 ;f7
	dc.b	0 ;f8
	dc.b	0 ;f9
	dc.b	0 ;f10
	dc.b	"()/*+"
	dc.b	0 ; Help


TTxt206:	dc.b	"Triangle 20.6Hz",0
TTxt55:		dc.b	"Triangle 55Hz  ",0
TTxt239:	dc.b	"Triangle 239Hz ",0
TTxt440:	dc.b	"Triangle 440Hz ",0
TTxt640:	dc.b	"Triangle 640Hz ",0
TTxt879:	dc.b	"Triangle 879Hz ",0
TTxt985:	dc.b	"Triangle 985Hz ",0
TTxt1295:	dc.b	"Triangle 1295Hz",0
TTxt1759:	dc.b	"Triangle 1759Hz",0
STxt206:	dc.b	"Sinus 20.6Hz   ",0
STxt55:		dc.b	"Sinus 55Hz     ",0
STxt239:	dc.b	"Sinus 239Hz    ",0
STxt440:	dc.b	"Sinus 440Hz    ",0
STxt640:	dc.b	"Sinus 640Hz    ",0
STxt879:	dc.b	"Sinus 879Hz    ",0
STxt985:	dc.b	"Sinus 985Hz    ",0
STxt1295:	dc.b	"Sinus 1295Hz   ",0
STxt1759:	dc.b	"Siuns 1759Hz   ",0

ROMAudioWaves:

ROMAudio64ByteTriangle:
	dc.b	127,119,111,103,95,87,79,71,63,55,47,39,31,23,15,6
	dc.b	-1,-9,-17,-25,-33,-41,-49,-57,-65,-73,-81,-89,-97,-105,-113,-121,-127
	dc.b	-121,-113,-105,-97,-89,-81,-73,-65,-57,-49,-41,-33,-25,-17,-9,-1
	dc.b	6,15,23,31,39,47,55,63,71,79,87,95,103,111,119,127,127,127
	EVEN
ROMAudio32ByteTriangle:
	dc.b	127,111,95,79,63,47,31,15
	dc.b	-1,-17,-33,-49,-65,-81,-97,-113,-127
	dc.b	-113,-97,-81,-65,-49,-33,-17,-1
	dc.b	15,31,47,63,79,95,111,127,127,127
	EVEN
ROMAudio16ByteTriangle:
	dc.b	127,95,63,31
	dc.b	-1,-33,-65,-97
	dc.b	-127,-97,-65,-33
	dc.b	-1,31,63,95
	EVEN
ROMAudio64ByteSinus:
	dc.b 	0,-12,-25,-37,-49,-61,-72,-82,-91,-100,-107,-113,-119,-123,-126,-127
	dc.b 	-127,-127,-124,-121,-116,-110,-103,-95,-87,-77,-66,-55,-43,-31,-19,-6
	dc.b 	6,19,31,43,55,66,77,87,95,103,110,116,121,124,127,127
	dc.b 	127,126,123,119,113,107,100,91,82,72,61,49,37,25,12,0,0,0
	EVEN
ROMAudio32ByteSinus:
	dc.b 	0,-25,-50,-73,-92,-108,-120,-126,-127,-123,-114,-101,-83,-62,-38,-12
	dc.b 	12,38,62,83,101,114,123,127,126,120,108,92,73,50,25,0,0,0
	EVEN
ROMAudio16ByteSinus:
	dc.b 	0,-52,-95,-121,-127,-110,-75,-26,26,75,110,127,121,95,52,0,0,0

	EVEN
EndROMAudioWaves:
ROMAudioWavesSize = EndROMAudioWaves-ROMAudioWaves

AudioPointers:	; Pointers to actual waveform
	dc.l	0,0,0,0
	dc.l	ROMAudio32ByteTriangle-ROMAudioWaves,ROMAudio32ByteTriangle-ROMAudioWaves
	dc.l	ROMAudio16ByteTriangle-ROMAudioWaves,ROMAudio16ByteTriangle-ROMAudioWaves,ROMAudio16ByteTriangle-ROMAudioWaves
	dc.l	ROMAudio64ByteSinus-ROMAudioWaves,ROMAudio64ByteSinus-ROMAudioWaves,ROMAudio64ByteSinus-ROMAudioWaves,ROMAudio64ByteSinus-ROMAudioWaves
	dc.l	ROMAudio32ByteSinus-ROMAudioWaves,ROMAudio32ByteSinus-ROMAudioWaves
	dc.l	ROMAudio16ByteSinus-ROMAudioWaves,ROMAudio16ByteSinus-ROMAudioWaves,ROMAudio16ByteSinus-ROMAudioWaves
	
AudioLen:	; Length of audio
	dc.w	32,32,32,32,16,16,8,8,8,32,32,32,32,16,16,8,8,8,8
AudioPer:	; Period (speed) of audio
	dc.w	2390,1007,185,126,173,126,225,159,129,2390,1007,185,126,173,126,225,159,129
AudioName:	; Pointers to string of name of wave
	dc.l	TTxt206,TTxt55,TTxt239,TTxt440,TTxt640,TTxt879,TTxt985,TTxt1295,TTxt1759
	dc.l	STxt206,STxt55,STxt239,STxt440,STxt640,STxt879,STxt985,STxt1295,STxt1759

Octant_Table:
	dc.b	0*4+1
	dc.b	4*4+1
	dc.b	2*4+1
	dc.b	5*4+1
	dc.b	1*4+1
	dc.b	6*4+1
	dc.b	3*4+1
	dc.b	7*4+1

Music:
	ifeq	a1k
	incbin	"Music.MOD"

	endc

	EVEN


	ifeq	a1k
TestPic:
	incbin	"TestPIC.raw"
EndTestPic:
	endc
	dc.b	"Checksums:"
	CNOP	0,4			; Start at even LONGWORD
Checksums:		; Numbers here fits my Kickstart 3.1 rom.
	dc.l	$88ff8999,$27445220,$bf491a45,$f83fe9c5,$1e97ca1e,$7f55b19b,$924d1d33,$67f7f730
EndChecksums:

EndMusic:
	dc.b	"This is the brutal end of this ROM, everything after this are just pure noise.    End of Code...",0
EndOfCode:
	EVEN

	cnop 0,4
EndRom:
	ifne	rommode

		ifeq	a1k
	blk.b	$80000-(EndRom-START)-26,0		; Crapdata that needs to be here
		else
	blk.b	$20000-(EndRom-START)-26,0		; Crapdata that needs to be here
		endc
EndRom2:
	dc.l	0
IRQDATA:
DefBaud:	dc.l	DB
DB:
	dc.w	373					; Default baudrate  373 (9600 BPS)	EXPERIMENT!
	dc.l	$00180019,$001a001b,$001c001d,$001e001f	; or IRQ will TOTALLY screw up on machines with 68000-68010
	endc



ROMEND:

;		ifeq	rommode


		ifeq	rommode
	section data,code_c


BeforeUsed:
		blk.b	80*512*8,0

		else

		org	$0

		endc



	EVEN



; Here you put REFERENCES to variabes in RAM. remember that you cannot know what is stored in
; this part of memory. so you have to set any default values in the code or data will be random.

