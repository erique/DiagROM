

Variables:
	blk.b	8192,0			; Just reserve memory for "Stack" not used in nonrom mode
Endstack:
	EVEN
V:
	dc.l	0			; Just a string to mark first part of data
StackSize:
	dc.l	0			; Will contain size of the stack	
StartAddress:
	dc.l	0
Bpl1Ptr:
	dc.l	0			; Pointer to Bitplane 1
Bpl2Ptr:
	dc.l	0			; Pointer to Bitplane 2
Bpl3Ptr:
	dc.l	0			; Pointer to Bitplane 3
BplEnd:
	dc.l	0			; Let it be 0
Xpos:	dc.l	0			; Variable for X position on screen to print on
Ypos:	dc.l	0			; Variable for Y position on screen to print on
LogYpos:
	dc.l	0			; Variable for Y pos of logscreen

shit:	dc.l	0			; crapvariable for debugging
b2dTemp:	dc.l	0,0
b2dString:	dc.l	0,0,0
bindecoutput:
	dc.b	0,0,0,0,0,0,0,0,0,0,0,0,0,0
	EVEN
binhexoutput:
	blk.b	10,0
binstringoutput:
	blk.b	33,0

Color:	dc.b	0
	EVEN
HexBinBin:
	dc.l	0
DecBinBin:
	dc.l	0
SerialSpeed:
	dc.w	0
OldSerialSpeed:
	dc.w	0
keymap:
	dc.l	0			; Points to keymap to be used.
NoSerial:
	dc.b	0			; if other then 0, no serial output at start.
LoopB:
	dc.b	0			; if other than 0, Loopbackadapter was attached at boot
GetCharData:
	dc.b	0			; Result of GetChar
keypressed:
	dc.b	0,0			; What key is pressed
keypressedshifted:
	dc.b	0,0			; Same but without shift
keyresult:
	dc.b	0,0			; Actual result to be printed on screen
skipnextkey:
	dc.b	0			; if set to other than 0, next keypress will be ignored
scancode:
	dc.b	0			; Scancode from buffer
key:
	dc.b	0			; Keycode
keyctrl:
	dc.b	0
keyalt:
	dc.b	0
keyshift:
	dc.b	0			; if !0 = shift is pressed Will actually contain the scancode
keycaps:
	dc.b	0
keyup:
	dc.b	0			; if 1 = key is pressed
keydown:
	dc.b	0
keystatus:
	dc.b	0
keynew:
	dc.b	0			; if 1 the keypress is new
keyrepeat:
	dc.b	0			; if 1 the key is still pressed down
CPUCache:
	dc.b	0			; Status of CPU Cache, 0 = off
	EVEN
	
ChipStart:
	dc.l	0			; Start of detected chipmem
ChipEnd:
	dc.l	0			; End of chipmem
FastStart:
	dc.l	0			; Start of Detected prio Fastmem
FastEnd:
	dc.l	0			; end of fastmem
BaseStart:
	dc.l	0			; Start of Basemem (workarea)
BaseEnd:
	dc.l	0			; End of Basemem
ChipUnreserved:
	dc.l	0			; Total of UNRESERVED Chipmem detected
ChipUnreservedAddr:
	dc.l	0			; END of the Unreserved space
FastBlocksAtBoot:
	dc.l	0			; amount of fastmemblocks found at boot
GetChipAddr:
	dc.l	0			; Response from GetChip routine
MemAdr:
	dc.l	0			; Response from GetMemory routine
	
TotalChip:				; Total Chipmem detected
	dc.l	0
TotalFast:
	dc.l	0			; Total Motherboard Fastmem detected
ChipAdr:
	dc.l	0			; Where chipmem starts
oldkey:
	dc.l	0
InputRegister:
	dc.l	0	; the value of D0 of GetInput is stored here aswell
OldMouse1X:
	dc.b	0	; old value of mouseport X
OldMouse1Y:
	dc.b	0	; mouseport Y
OldMouse2X:
	dc.b	0	; old value of mouseDATA on non mouseport X
OldMouse2Y:
	dc.b	0	; Y
MouseX:
	dc.b	0	; Mouse X position
MouseY:
	dc.b	0	; Mouse Y Position
OldMouseX:
	dc.b	0
OldMouseY:
	dc.b	0
MOUSE:
	dc.b	0	; if not 0, moouse is moved
BUTTON:
	dc.b	0	; if not 0, a button is pressed
MBUTTON:
	dc.b	0	; if not 0, a mousebutton is pressed
LMB:
	dc.b	0	; if not 0, LMB pressed
RMB:
	dc.b	0	; if not 0, RMB pressed
MMB:
	dc.b	0	; if not 0, MMB pressed
P1LMB:
	dc.b	0	; if not 0, LMB port1 pressed
P2LMB:
	dc.b	0	; if not 0, LMB port2 pressed
P1RMB:
	dc.b	0	; if not 0, RMB port1 pressed
P2RMB:
	dc.b	0	; if not 0, RMB port1 pressed
P1MMB:
	dc.b	0	; if not 0, MMB port1 pressed
P2MMB:
	dc.b	0	; if not 0, MMB port1 pressed
STUCKP1LMB:
	dc.b	0	; if not 0, LMB port1 stuck and should be ignored
STUCKP2LMB:
	dc.b	0	; if not 0, LMB port2 stuck and should be ignored
STUCKP1RMB:
	dc.b	0	; if not 0, RMB port1 stuck and should be ignored
STUCKP2RMB:
	dc.b	0	; if not 0, RMB port1 stuck and should be ignored
STUCKP1MMB:
	dc.b	0	; if not 0, MMB port1 stuck and should be ignored
STUCKP2MMB:
	dc.b	0	; if not 0, MMB port1 stuck and should be ignored
DISPAULA:
	dc.b	0	; if not 0, Paula seems bad. no paulatests should be done to check keypresses etc.
OVLErr:
	dc.b	0	; Store if we had OVL Error
RASTER:
	dc.b	0	; if not 0, We have detected working raster
SCRNMODE:
	dc.b	0	; If 0, we are in PAL (50Hz) screenmode, any other we have NTSC (60Hz)
SerData:
	dc.b	0	; if 0  we had no serialdata
Serial:
	dc.b	0	; Will contain data from the serialport
OldSerial:
	dc.b	0	; Will contain the last char that was detected on the serialport
SerBufLen:
	dc.b	0	; Current length of serialbuffer
SerBuf:
	blk.b	256,0	; 256 bytes of serialbuffer
SerAnsiFlag:
	dc.b	0	; nonzero means that we are in buffermode (number is actually number of chars in buffer)
SerAnsi35Flag:
	dc.b	0
SerAnsi36Flag:
	dc.b	0
SerAnsiBufLen:
	dc.b	0	; Buffertlength used for the moment.
	EVEN
SerAnsiChecks:
	dc.w	0	; Number of checks with a result of 0 in Ansimode.
SerAnsiBuff:
	dc.l	0	; Reserve a longword for ANSI serialbuffer
PrintMenuFlag:
	dc.b	0	; if set to anything else then 0, print the menu
UpdateMenuFlag:
	dc.b	0	; if set to anything else then 0, update the menu.
UpdateMenuNumber:
	dc.b	0	; What itemnumber to update. 0 = all  (0 is the only that prints label)
MenuEntrys:
	dc.b	0	; Will contain number of entrys in the menu being displayed
MenuPos:
	dc.b	0	; What menu item to highlight
MenuChoose:
	dc.b	0	; If anything else then 0, user have chosen this item on the menu
MenuMouseAdd:
	dc.w	0	; Variable for how many mousetics have been done..
MenuMouseSub:
	dc.w	0	
PortJoy0:		; Detected directions of Joystick 0
	dc.l	0
PortJoy1:		; Detected directions of Joystick 1
	dc.l	0
P0Fire:
	dc.w	0	; Detected fire on Joystick 0
P1Fire:
	dc.w	0	; Detected fire on Joystick 1
P0FireOLD:
	dc.w	0	; just to detect changes.
P1FireOLD:
	dc.w	0
PortJoy0OLD:
	dc.l	0
PortJoy1OLD:
	dc.l	0
PowerONStatus:
	dc.l	0	; Poweron Status
SerTstBps:
	dc.w	0	; BPS of serialtest
OldMarkItem:
	dc.b	0	; Contains the item marked before
MarkItem:
	dc.b	0	; Contains the item being marked.
	EVEN
	dc.l	0
NoDraw:
	dc.b	0	; If this is other then 0, no screen is drawn, no text. for "no chipmem" modes
WorkOrder:
	dc.b	0	; If this is other than 0, use memory from start instead from end.

	dc.l	0
MenuNumber:
	dc.w	0	; Contains the menunuber to be printed, from the Menus�list
OldMenuNumber:
	dc.w	0	; Contain the old menunumber
NoChar:	dc.b	0	; if 0 print char, anything else, never do screenactions. (no chipmem avaible)
Inverted:
	dc.b	0	; if 0, former char was not inverted
	EVEN
Menu:
	dc.l	0	; What menulist to use
MenuVariable:
	dc.l	0	; List of pointers to variables to print after menuitem.

CurX:	dc.w	0	; Cursor X pos. "mouse" cursor
CurY:	dc.w	0	; Cursor Y pos
CurAddX:
	dc.w	0	; How much was added in X dir
CurSubX:
	dc.w	0	; How much was subtracted uin X dir
CurAddY:
	dc.w	0
CurSubY:
	dc.w	0
temp:	dc.l	0,0,0,0,0,0,0,0,0,0	; 10 longwords reserved for temporary crapdata
nomem:	dc.l	0
DriveTestVar:
	dc.w	0
	dc.l	0
	dc.w	0
	dc.l	0
	dc.l	0

DriveNo:
	dc.w	0	; Drivenumber to test
DriveOK:	
	dc.w	0	; Status of drive, 0=not ok, 1=OK
DriveMotor:
	dc.b	0	; 0 = Diskdrivemotor is OFF
SideNo:
	dc.b	9	; Side of disk.  0=Upper
TrackNo:
	dc.b	0	; Current tracknumber
WantedTrackNo:
	dc.b	0	; Wanted tracknumber
oldbfe001:
	dc.b	0	; Contains old value of bfe001
oldbfd100:
	dc.b	0	; Contains old value of bfd100
sector:
	dc.b	0	; Currend sector
	EVEN
trackbuff:
	dc.l	0	; Address to trackbuffer
sectorbuff:
	dc.l	0,0,0,0	; a small part of MFMdecoded sectordata.

AudSimpVar:		; Variablelist for the menusystem
	dc.w	0
	dc.l	0
	dc.w	0
	dc.l	0
	dc.w	0
	dc.l	0
	dc.w	0
	dc.l	0
	dc.w	0
	dc.l	0
	dc.w	0
	dc.l	0
	dc.w	0
	dc.l	0
	dc.w	0
	dc.l	0
	dc.w	0
	dc.l	0

AudSimpChan1:
	dc.b	0
AudSimpChan2:
	dc.b	0
AudSimpChan3:
	dc.b	0
AudSimpChan4:
	dc.b	0
AudSimpVol:
	dc.b	0
AudSimpWave:
	dc.b	0
AudSimpFilter:
	dc.b	0	
	EVEN
AudSimpVolStr:
	blk.b	10,0
	EVEN
AudioWaveNo:
	dc.w	0			; What wave to play
AudioModAddr:
	dc.l	0			; Address of module in modtest
AudioModInit:
	dc.l	0			; Address to MT_Init
AudioModEnd:
	dc.l	0			; Address to MT_End
AudioModMusic:
	dc.l	0			; Address to MT_Music
AudioModMVol:
	dc.l	0			; Address to Mastervolume
AudioModData:
	dc.l	0			; Address to mt_data (pointer to mod)
AudioVolSelect:
	dc.b	0			; Was VOL selection in menu selected
	EVEN
AudioModStatData:			; Audiomod status
	dc.b	0,0,0,0			; if channels if turned off or not (1=OFF)
	dc.b	0			; Audiofilter
	dc.b	64			; Mastervolume
	dc.b	0,0
AudioModStatFormerData:			; NO DATA IN BETWEEN HERE!!! OR YOU WILL HAVE BUGS!!
	dc.b	0,0,0,0
	dc.b	0,0			; Just a backup of former state of above.
	dc.b	0,0			; so it will not update all everytime.
	EVEN
IRQLev7:
	dc.w	0			; if 0 not lev7
IRQLevDone:
	dc.w	0
Frames:	dc.w	0			; Number of frames shown
Ticks:	dc.l	0			; Number of "ticks" in CIA test
TickFrame:
	dc.w	0			; how many frames reached when CIA test was done.
CIAPalLow:				; Low value for PAL tests
	dc.l	0
CIAPalHigh:				; igh value for PAL tests
	dc.l	0
CIANtscLow:
	dc.l	0
CIANtscHigh:
	dc.l	0
CIACtrl:
	dc.l	0
RTCsec:
	dc.w	0			; Number of seconds RTC test have been running
RTCirq:
	dc.w	0			; 0 if IRQ is off
RTC1secframe:
	dc.w	0			; Number of frames in 1 second
RTC10secframe:
	dc.w	0			; Number of frames in 10 seconds
RTCold:
	dc.l	0			; How RTC first longword was last read
RTCString:
	blk.b	14,0			; Block of RTC data
MemTestStart:
	dc.l	0
MemTestEnd:
	dc.l	0
MemTestFail:
	dc.l	0,0,0,0			; Add 1 to every byte that is wrong during check
	
GfxChipset:
	dc.b	0			; What GfxChipset is detected: 0 = OCS, 1 = ECS, 2 = AGA

	EVEN
BootMBFastmem:				; Amount of motherboard fastmem detected at bootpoint
	dc.l	0
FastMem:
	dc.l	0			; Variable for fastmem found during init with screen.
DetectMemRnd:
	dc.l	0			; used as a flag to tag for shadowram
MemDetected:
	dc.w	0			; If memory was detected
FastmemBlock:
	dc.l	0			; Number of fastmem memblocks found when doing detection in menus
CheckMemCancel:
	dc.w	0			; if not 0, we had a cancel of memorytest
CheckMemPreFail:
	dc.l	0			; shold be 0 or something failed preparing the block and do not test this block
CheckMemCancelReason:
	dc.l	0			; store reason of cancel
CheckMemStepSize:
	dc.l	0			; How many bytes to step between each memorycheck address
CheckMemPassQuit:
	dc.w	0			; if not 0, we quit this pass
CheckMemRND:
	dc.w	0			; If not 0, area will be random
CheckMemSeed:
	dc.l	0			; Random seedvariable
CheckMemQuick:
	dc.w	0			; if not 0, a quick test will be done (only one longword per block)
CheckMemRandom:
	dc.w	0			; if not 0, only random memorytest is done
CheckMemRandom1:
	dc.l	0			; Random seed 1
CheckMemRandom2:
	dc.l	0			; Random seed 2
CheckMemArea:
	dc.w	0			; If not 0, checkmem area have been changed.	
CheckMemAdrRnd:
	dc.l	0			; Store a random number for addresstest. to be sure we are not testing old data
CheckMemScanAdr:
	dc.l	0			; Address of current scan
CheckMemOldScanAdr:
	dc.l	0			; Address of current scan
CheckMemFrom:
	dc.l	0			; Startaddress of memory to check
CheckMemFrom2:
	dc.l	0
CheckMemTo:
	dc.l	0			; endaddress to check memory
CheckMemTo2:
	dc.l	0			; if not 0, endpoint have been changed.
CheckMemStatus:
	dc.w	0			; Should be 0 and this block was ok
CheckMemPass:
	dc.l	0			; Number of passes of memorycheck done
CheckMemPassOK:
	dc.l	0			; Number of OK passes
CheckMemPassFail:
	dc.l	0			; Number of failed passes
CheckMemPassOLD:
	dc.l	0			; Number of passes of memorycheck done
CheckMemPassOKOLD:
	dc.l	0			; Number of OK passes
CheckMemPassFailOLD:
	dc.l	0			; Number of failed passes
CheckMemBad:
	dc.w	0			; Should be 0 to be in a good block
CheckMemOldBad:
	dc.w	0			; Should be 0 to be in a good block
CheckAdrBad:
	dc.w	0			; Should be 0 to be in a good addressblock
CheckMemBlock: 
	dc.l	0			; Address of start of this block
CheckMemBlockEnd:
	dc.l	0			; Address of end of this block
CheckMemGoodBlock:
	dc.l	0			; Will state where good block started.
CheckMemBadBlock:
	dc.l	0			; Will state where the bad block started.
CheckMemBadAdr:
	dc.l	0			; Will sstate where the bad block of addresserrors starts.
CheckMemCurrent: 
	dc.l	0			; current address to check
CheckMemBlockDone:
	dc.l	0			; How much of the block is done
CheckMemCurrentOLD: 
	dc.l	0			; current address to check
CheckMemChecked:
	dc.l	0			; how much memory is checked
CheckMemCheckedOLD:
	dc.l	0			; how much WAS checked...
CheckMemUsable:
	dc.l	0			; how much usable memory
CheckMemUsableOLD:
	dc.l	0
CheckMemOldUsable:
	dc.l	0			; old

CheckMemOldNonUsable:
	dc.l	0			; how much non usable memory

CheckMemNonUsable:
	dc.l	0			; how much non usable memory
CheckMemNonUsableOLD:
	dc.l	0
CheckMemBitError:			; Will contain all bits with errors.  0=no error
	dc.l	0
CheckMemHighError:
	dc.l	0			; Will contain all bits with stuck 1
CheckMemLowError:
	dc.l	0			; Will contain all buts with stuck 0
CheckMemBitErrors:
	blk.b	32,0			; number of errors in each bit in a longword (max 255 errors per bit)
	dc.b	"b"
	EVEN
CheckMemAdrError:
	dc.l	0			; contain mask of addresserror
CheckMemAdrErrorOLD:
	dc.l	0
CheckMemAdrError2:
	dc.l	0			; contain numer of addresserrors
CheckMemAdrOldError2:
	dc.l	0			; contain numer of addresserrors
CheckMemByteErrors:
	dc.l	0,0,0,0			; number of errors on each byte in a longword
CheckMemErrors:
	dc.l	0			; Number of errors found
CheckMemErrorsOLD:
	dc.l	0			; Number of errors found
CheckMemNoErrors:
	dc.l	0			; total of memoryerrors
CheckMemNoErrorsBlock:
	dc.l	0			; total of memoryerrors
CheckMemOldNoErrors:
	dc.l	0			; "old" errorcount
CheckMemType:
	dc.b	0			; type of memory detected last time 0=none  1=Error 2=Good
CheckMemTypeEnd:
	dc.b	0			; if this is 0 then we can have a "end" text. 
CheckMemOldType:
	dc.b	0
CheckMemTypeChange:			; if 0, there is no change of type
	dc.b	0
CheckMemRow:
	dc.b	0			; What row to print message of type of memory on
CheckMemCol:
	dc.b	0			; What color to print row at
CheckMemFast:
	dc.b	0			; if anything else then 0, a fast scan will be perfomed
CheckMemNoShadow:
	dc.b	0			; if anything else then 0, no shadowcheck will be done
CheckMemManualX:
	dc.b	0			; Contains X cord of current text to input while asking for memadress
CheckMemManualY:
	dc.b	0			; .... and Y
CheckMemStartAdrTxt:
	dc.b	0,0,0,0,0,0,0,0,0	; String for startaddress
CheckmemEndAdrTxt:
	dc.b	0,0,0,0,0,0,0,0,0	; String for endaddress
	EVEN
CheckMemTypeStart:
	dc.l	0			; Startaddress of this "type" of memory
CheckMemEditAdr:
	dc.l	0			; Current address cursor points to in edit-mode
CheckMemEditScreenAdr:
	dc.l	0			; Startaddress of memorydump on screen in edit-mode
CheckMemEditXpos:
	dc.b	0			; Current X pos of cursor
CheckMemEditYpos:
	dc.b	0			; Current Y pos of cursor
CheckMemEditOldXpos:
	dc.b	0			; Old X pos of cursor
CheckMemEditOldYpos:
	dc.b	0			; Old Y pos of cursor
CheckMemEditCharPos:
	dc.b	0			; Current pos to edit memory.  0 or 1, 0 = high nibble, 1 = low)

	EVEN
RunCodeStart:
	dc.l	0			; Will contain address of first address of where code is in memory when copied to ram
RunCodeEnd:
	dc.l	0			; end of RunCode data

RETURN:
	dc.l	0			; Just a "return" value
MemTestPass:
	dc.l	0			; Number of passes in memorycheck

KeyBOld:
	dc.b	0			; Stores old scancode of keyboard
	EVEN

TF1260MemStart:
	dc.l	0
TF1260MemEnd:
	dc.l	0
TF1260IOStart:
	dc.l	0
TF1260IOEnd:
	dc.l	0
ShowMemAdr:
	dc.l	0			; Address to show at showmemaddr...
	even
savexpos:
	dc.b	0
saveypos:
	dc.b	0
savecol:
	dc.b	0
	EVEN
FirstMBMem:
	dc.l	0
MBMemSize:
	dc.l	0
DebugA0:
	dc.l	0			; Store A0 in here, so we have it stored.. before string overwrites it.
DebugD1:
	dc.l	0
DebD0:
	dc.l	0			; For debug..  to store registers
DebD1:
	dc.l	0			; For debug..  to store registers
DebD2:
	dc.l	0			; For debug..  to store registers
DebD3:
	dc.l	0			; For debug..  to store registers
DebD4:
	dc.l	0			; For debug..  to store registers
DebD5:
	dc.l	0			; For debug..  to store registers
DebD6:
	dc.l	0			; For debug..  to store registers
DebD7:
	dc.l	0			; For debug..  to store registers
DebA0:
	dc.l	0			; For debug..  to store registers
DebA1:
	dc.l	0			; For debug..  to store registers
DebA2:
	dc.l	0			; For debug..  to store registers
DebA3:
	dc.l	0			; For debug..  to store registers
DebA4:
	dc.l	0			; For debug..  to store registers
DebA5:
	dc.l	0			; For debug..  to store registers
DebA6:
	dc.l	0			; For debug..  to store registers
DebA7:
	dc.l	0			; For debug..  to store registers
DebSR:	dc.w	0			; For debug..  Statusregister
DebPC:	dc.l	0			; For debug..  PC for fault

MEMCHECKSIZE:
	dc.l	0			; size of block to do memcheck of
;MEMBLOCKSIZE:
	dc.l	0			; size of block to do memcheck of

; Reserved area for dumps of customregisters
BLTDDAT:
	dc.w	0
DMACONR:
	dc.w	0
VPOSR:
	dc.w	0
VHPOSR:
	dc.w	0
DSKDATR:
	dc.w	0
JOY0DAT:
	dc.w	0
JOY1DAT:
	dc.w	0
CLXDAT:
	dc.w	0
ADKCONR:
	dc.w	0
POT0DAT:
	dc.w	0
POT1DAT:
	dc.w	0
POTINP:
	dc.w	0
SERDATR:
	dc.w	0
DSKBYTR:
	dc.w	0
INTENAR:
	dc.w	0
INTREQR:
	dc.w	0
DENISEID:
	dc.w	0
HHPOSR:
	dc.w	0
CIAAPRA:
	dc.w	0
Passno:
	dc.l	0
CPU:
	dc.l	0			; Type of CPU
CPUGen:
	dc.l	0			; Generation of CPU
FPU:
	dc.l	0			; Type of FPU
PCRReg:
	dc.l	0			; Value of PCRReg IF 060, if not, this is 0
CPU060Rev:
	dc.b	0			; Revision of 060 cpu
MMU:
	dc.b	0			; if 0, there is no MMU
ADR24BIT:
	dc.b	0			; if 0 no 24 bit address cpu.
	EVEN
CPUPointer:
	dc.l	0			; Pointer to CPU String
FPUPointer:
	dc.l	0			; Pointer to FPU String

	EVEN
GayleData:
	dc.l	0			; Data from gayletest
DiskBuffer:
	dc.l	0			; Pointer to diskbuffer in disktests

GfxTestBpl:				; Pointers to bitplanes for gfxtest
	dc.l	0,0,0,0,0,0,0,0
OKtxt:	dc.l	0			; A longword, that SHOULD contain "OK!" as a VERY fast memtest
SHIT:
	dc.l	0			; SHITData
C:
	EVEN
MenuCopper:
	blk.b	EndRomMenuCopper-RomMenuCopper,0
	EVEN
ECSCopper:
	blk.b	EndRomEcsCopper-RomEcsCopper,0
ECSCopper2
	blk.b	EndRomEcsCopper-RomEcsCopper,0
JunkBuffer:
	blk.l	54,0			; Junkbuffer for 256 bytes

	; Put this data at the end of everything.


AudioWaves:
	blk.b	EndROMAudioWaves-ROMAudioWaves,0

	EVEN
DummySprite:
	dc.l	0


AutoConfDone:
	dc.b	0			; if set to anything except 0, autoconfig has been done
AutoConfFlag:
	dc.b	0
AutoConfBoards:
	dc.l	0			; How many boards are autoconfigured.
AutoConfList:				; Structure Manu.w Serial.W
	blk.l	14*33,0			; Store data for 33 boards
AutoConfMode:
	dc.b	0			; if set to anything but 0, a detailed (and more manual) autoconfig will be done.
	EVEN
AutoConfBuffer:
	blk.b	20,0			; Autoconfigbuffer.
	EVEN
AutoConfShutD:
	dc.b	0			; of not 0, we had a shutdown of a card
AutoConfZ2Ram:
	dc.b	0			; AutoConf where to config ram to next Z2 card
AutoConfZ2IO:
	dc.b	0			; AutoConf where to config rom to next Z2 card
	EVEN
AutoConfZ3:
	dc.w	0			; AutoConf where to config to next Z3 card
AutoConfType:
	dc.b	0			; If set to 0, no board was found
					; 1 = ROM
					; 2 = RAM
					; 3 = Z2Space, not RAM

BackupAutoConfZ2Ram:
	dc.b	0			; AutoConf where to config ram to next Z2 card
BackupAutoConfZ2IO:
	dc.b	0			; AutoConf where to config rom to next Z2 card
	EVEN
BackupAutoConfZ3:
	dc.w	0			; AutoConf where to config to next Z3 card


AutoConfExit:
	dc.b	0			; If anything than 0, force exit of loop
AutoConfIllegal:
	dc.b	0			; if anything than 0, cardconfig was illegal, force shutdown of card
AutoConfZorro:
	dc.b	0			; Should be set to 0 for Zorro II and 1 for Zorro III
	EVEN
AutoConfSize:
	dc.l	0			; Size of current board
AutoConfWByte:
	dc.w	0			; "Byte" to write to autoconfigboards (Word for Z3)
AutoConfAddr:
	dc.l	0			; Address to configure board to.
AutoConfFrom:
	dc.l	0
AutoConfTo:
	dc.l	0
Bpl1str:
	dc.l	0			; Space for the "BPL1" string
Bpl1:
	blk.b	80*256,2		; bitplane 1
EndBpl1:

Bpl2str:
	dc.l	0			; Space for the "BPL1" string
Bpl2:
	blk.b	80*256,33		; bitplane 2
EndBpl2:


	
Bpl3str:
	dc.l	0			; Space for the "BPL1" string
Bpl3:
	blk.b	80*256,3		; bitplane 3
EndBpl3:

	dc.l	0			; extra null-longword

	ifeq	a1k
ptplay:
	blk.b	mt_END-MT_Init,0			; Reserve memory of protracker replayroutine

	endc

	EVEN

	dc.b	"THEEND"
EndData:
	dc.l	0


; this is data for "non rom mode"..
STACKPOINTER:
	dc.l	0	
ActiveView:
	dc.l	0
sysstack:
	dc.l	0

irq1:	dc.l	0
irq2:	dc.l	0
irq3:	dc.l	0
irq4:	dc.l	0
irq5:	dc.l	0
irq6:	dc.l	0
irq7:	dc.l	0

SaveBusError:
	dc.l	0
SaveAddressError:
	dc.l	0
SaveIllegalError:
	dc.l	0
SaveDivByZero:
	dc.l	0
SaveChkInst:
	dc.l	0
SaveTrapV:
	dc.l	0
SavePrivViol:
	dc.l	0
SaveTrace:
	dc.l	0
SaveUnimplInst:
	dc.l	0
SaveUnimplInst2:
	dc.l	0
SaveTrap:
	dc.l	0
SaveTrap2:
	dc.l	0
SaveTrap3:
	dc.l	0
SaveTrap4:
	dc.l	0
SaveTrap5:
	dc.l	0
SaveTrap6:
	dc.l	0
SaveTrap7:
	dc.l	0
SaveTrap8:
	dc.l	0
SaveTrap9:
	dc.l	0
SaveTrap10:
	dc.l	0
SaveTrap11:
	dc.l	0
SaveTrap12:
	dc.l	0
SaveTrap13:
	dc.l	0
SaveTrap14:
	dc.l	0
SaveTrap15:
	dc.l	0
SaveTrap16:
	dc.l	0

graph:
	dc.b	"graphics.library",0
	even
SLASK:
	dc.l	0
	
	ifeq	rommode

	section	workspace,code_f
startwork:
	blk.b	64*1024,0
endwork:

	endc
