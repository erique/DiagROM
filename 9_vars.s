

s_Variables:
	blk.b	8192,0			; Just reserve memory for "Stack" not used in nonrom mode
s_Endstack:
	EVEN
s_V:
	dc.l	0			; Just a string to mark first part of data
s_StackSize:
	dc.l	0			; Will contain size of the stack	
s_StartAddress:
	dc.l	0
s_Bpl1Ptr:
	dc.l	0			; Pointer to Bitplane 1
s_Bpl2Ptr:
	dc.l	0			; Pointer to Bitplane 2
s_Bpl3Ptr:
	dc.l	0			; Pointer to Bitplane 3
s_BplEnd:
	dc.l	0			; Let it be 0
s_Xpos:	dc.l	0			; Variable for X position on screen to print on
s_Ypos:	dc.l	0			; Variable for Y position on screen to print on
s_LogYpos:
	dc.l	0			; Variable for Y pos of logscreen

s_shit:	dc.l	0			; crapvariable for debugging
s_b2dTemp:	dc.l	0,0
s_b2dString:	dc.l	0,0,0
s_bindecoutput:
	dc.b	0,0,0,0,0,0,0,0,0,0,0,0,0,0
	EVEN
s_binhexoutput:
	blk.b	10,0
s_binstringoutput:
	blk.b	33,0

s_Color:	dc.b	0
	EVEN
s_HexBinBin:
	dc.l	0
s_DecBinBin:
	dc.l	0
s_SerialSpeed:
	dc.w	0
s_OldSerialSpeed:
	dc.w	0
s_keymap:
	dc.l	0			; Points to keymap to be used.
s_NoSerial:
	dc.b	0			; if other then 0, no serial output at start.
s_LoopB:
	dc.b	0			; if other than 0, Loopbackadapter was attached at boot
s_GetCharData:
	dc.b	0			; Result of GetChar
s_keypressed:
	dc.b	0,0			; What key is pressed
s_keypressedshifted:
	dc.b	0,0			; Same but without shift
s_keyresult:
	dc.b	0,0			; Actual result to be printed on screen
s_skipnextkey:
	dc.b	0			; if set to other than 0, next keypress will be ignored
s_scancode:
	dc.b	0			; Scancode from buffer
s_key:
	dc.b	0			; Keycode
s_keyctrl:
	dc.b	0
s_keyalt:
	dc.b	0
s_keyshift:
	dc.b	0			; if !0 = shift is pressed Will actually contain the scancode
s_keycaps:
	dc.b	0
s_keyup:
	dc.b	0			; if 1 = key is pressed
s_keydown:
	dc.b	0
s_keystatus:
	dc.b	0
s_keynew:
	dc.b	0			; if 1 the keypress is new
s_keyrepeat:
	dc.b	0			; if 1 the key is still pressed down
s_CPUCache:
	dc.b	0			; Status of CPU Cache, 0 = off
	EVEN
	
s_ChipStart:
	dc.l	0			; Start of detected chipmem
s_ChipEnd:
	dc.l	0			; End of chipmem
s_FastStart:
	dc.l	0			; Start of Detected prio Fastmem
s_FastEnd:
	dc.l	0			; end of fastmem
s_BaseStart:
	dc.l	0			; Start of Basemem (workarea)
s_BaseEnd:
	dc.l	0			; End of Basemem
s_ChipUnreserved:
	dc.l	0			; Total of UNRESERVED Chipmem detected
s_ChipUnreservedAddr:
	dc.l	0			; END of the Unreserved space
s_FastBlocksAtBoot:
	dc.l	0			; amount of fastmemblocks found at boot
s_GetChipAddr:
	dc.l	0			; Response from GetChip routine
s_MemAdr:
	dc.l	0			; Response from GetMemory routine
	
s_TotalChip:				; Total Chipmem detected
	dc.l	0
s_TotalFast:
	dc.l	0			; Total Motherboard Fastmem detected
s_ChipAdr:
	dc.l	0			; Where chipmem starts
s_oldkey:
	dc.l	0
s_InputRegister:
	dc.l	0	; the value of D0 of GetInput is stored here aswell
s_OldMouse1X:
	dc.b	0	; old value of mouseport X
s_OldMouse1Y:
	dc.b	0	; mouseport Y
s_OldMouse2X:
	dc.b	0	; old value of mouseDATA on non mouseport X
s_OldMouse2Y:
	dc.b	0	; Y
s_MouseX:
	dc.b	0	; Mouse X position
s_MouseY:
	dc.b	0	; Mouse Y Position
s_OldMouseX:
	dc.b	0
s_OldMouseY:
	dc.b	0
s_MOUSE:
	dc.b	0	; if not 0, moouse is moved
s_BUTTON:
	dc.b	0	; if not 0, a button is pressed
s_MBUTTON:
	dc.b	0	; if not 0, a mousebutton is pressed
s_LMB:
	dc.b	0	; if not 0, LMB pressed
s_RMB:
	dc.b	0	; if not 0, RMB pressed
s_MMB:
	dc.b	0	; if not 0, MMB pressed
s_P1LMB:
	dc.b	0	; if not 0, LMB port1 pressed
s_P2LMB:
	dc.b	0	; if not 0, LMB port2 pressed
s_P1RMB:
	dc.b	0	; if not 0, RMB port1 pressed
s_P2RMB:
	dc.b	0	; if not 0, RMB port1 pressed
s_P1MMB:
	dc.b	0	; if not 0, MMB port1 pressed
s_P2MMB:
	dc.b	0	; if not 0, MMB port1 pressed
s_STUCKP1LMB:
	dc.b	0	; if not 0, LMB port1 stuck and should be ignored
s_STUCKP2LMB:
	dc.b	0	; if not 0, LMB port2 stuck and should be ignored
s_STUCKP1RMB:
	dc.b	0	; if not 0, RMB port1 stuck and should be ignored
s_STUCKP2RMB:
	dc.b	0	; if not 0, RMB port1 stuck and should be ignored
s_STUCKP1MMB:
	dc.b	0	; if not 0, MMB port1 stuck and should be ignored
s_STUCKP2MMB:
	dc.b	0	; if not 0, MMB port1 stuck and should be ignored
s_DISPAULA:
	dc.b	0	; if not 0, Paula seems bad. no paulatests should be done to check keypresses etc.
s_OVLErr:
	dc.b	0	; Store if we had OVL Error
s_RASTER:
	dc.b	0	; if not 0, We have detected working raster
s_SCRNMODE:
	dc.b	0	; If 0, we are in PAL (50Hz) screenmode, any other we have NTSC (60Hz)
s_SerData:
	dc.b	0	; if 0  we had no serialdata
s_Serial:
	dc.b	0	; Will contain data from the serialport
s_OldSerial:
	dc.b	0	; Will contain the last char that was detected on the serialport
s_SerBufLen:
	dc.b	0	; Current length of serialbuffer
s_SerBuf:
	blk.b	256,0	; 256 bytes of serialbuffer
s_SerAnsiFlag:
	dc.b	0	; nonzero means that we are in buffermode (number is actually number of chars in buffer)
s_SerAnsi35Flag:
	dc.b	0
s_SerAnsi36Flag:
	dc.b	0
s_SerAnsiBufLen:
	dc.b	0	; Buffertlength used for the moment.
	EVEN
s_SerAnsiChecks:
	dc.w	0	; Number of checks with a result of 0 in Ansimode.
s_SerAnsiBuff:
	dc.l	0	; Reserve a longword for ANSI serialbuffer
s_PrintMenuFlag:
	dc.b	0	; if set to anything else then 0, print the menu
s_UpdateMenuFlag:
	dc.b	0	; if set to anything else then 0, update the menu.
s_UpdateMenuNumber:
	dc.b	0	; What itemnumber to update. 0 = all  (0 is the only that prints label)
s_MenuEntrys:
	dc.b	0	; Will contain number of entrys in the menu being displayed
s_MenuPos:
	dc.b	0	; What menu item to highlight
s_MenuChoose:
	dc.b	0	; If anything else then 0, user have chosen this item on the menu
s_MenuMouseAdd:
	dc.w	0	; Variable for how many mousetics have been done..
s_MenuMouseSub:
	dc.w	0	
s_PortJoy0:		; Detected directions of Joystick 0
	dc.l	0
s_PortJoy1:		; Detected directions of Joystick 1
	dc.l	0
s_P0Fire:
	dc.w	0	; Detected fire on Joystick 0
s_P1Fire:
	dc.w	0	; Detected fire on Joystick 1
s_P0FireOLD:
	dc.w	0	; just to detect changes.
s_P1FireOLD:
	dc.w	0
s_PortJoy0OLD:
	dc.l	0
s_PortJoy1OLD:
	dc.l	0
s_PowerONStatus:
	dc.l	0	; Poweron Status
s_SerTstBps:
	dc.w	0	; BPS of serialtest
s_OldMarkItem:
	dc.b	0	; Contains the item marked before
s_MarkItem:
	dc.b	0	; Contains the item being marked.
	EVEN
	dc.l	0
s_NoDraw:
	dc.b	0	; If this is other then 0, no screen is drawn, no text. for "no chipmem" modes
s_WorkOrder:
	dc.b	0	; If this is other than 0, use memory from start instead from end.

	dc.l	0
s_MenuNumber:
	dc.w	0	; Contains the menunuber to be printed, from the Menus�list
s_OldMenuNumber:
	dc.w	0	; Contain the old menunumber
s_NoChar:	dc.b	0	; if 0 print char, anything else, never do screenactions. (no chipmem avaible)
s_Inverted:
	dc.b	0	; if 0, former char was not inverted
	EVEN
s_Menu:
	dc.l	0	; What menulist to use
s_MenuVariable:
	dc.l	0	; List of pointers to variables to print after menuitem.

s_CurX:	dc.w	0	; Cursor X pos. "mouse" cursor
s_CurY:	dc.w	0	; Cursor Y pos
s_CurAddX:
	dc.w	0	; How much was added in X dir
s_CurSubX:
	dc.w	0	; How much was subtracted uin X dir
s_CurAddY:
	dc.w	0
s_CurSubY:
	dc.w	0
s_temp:	dc.l	0,0,0,0,0,0,0,0,0,0	; 10 longwords reserved for temporary crapdata
s_nomem:	dc.l	0
s_DriveTestVar:
	dc.w	0
	dc.l	0
	dc.w	0
	dc.l	0
	dc.l	0

s_DriveNo:
	dc.w	0	; Drivenumber to test
s_DriveOK:	
	dc.w	0	; Status of drive, 0=not ok, 1=OK
s_DriveMotor:
	dc.b	0	; 0 = Diskdrivemotor is OFF
s_SideNo:
	dc.b	9	; Side of disk.  0=Upper
s_TrackNo:
	dc.b	0	; Current tracknumber
s_WantedTrackNo:
	dc.b	0	; Wanted tracknumber
s_oldbfe001:
	dc.b	0	; Contains old value of bfe001
s_oldbfd100:
	dc.b	0	; Contains old value of bfd100
s_sector:
	dc.b	0	; Currend sector
	EVEN
s_trackbuff:
	dc.l	0	; Address to trackbuffer
s_sectorbuff:
	dc.l	0,0,0,0	; a small part of MFMdecoded sectordata.

s_AudSimpVar:		; Variablelist for the menusystem
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

s_AudSimpChan1:
	dc.b	0
s_AudSimpChan2:
	dc.b	0
s_AudSimpChan3:
	dc.b	0
s_AudSimpChan4:
	dc.b	0
s_AudSimpVol:
	dc.b	0
s_AudSimpWave:
	dc.b	0
s_AudSimpFilter:
	dc.b	0	
	EVEN
s_AudSimpVolStr:
	blk.b	10,0
	EVEN
s_AudioWaveNo:
	dc.w	0			; What wave to play
s_AudioModAddr:
	dc.l	0			; Address of module in modtest
s_AudioModInit:
	dc.l	0			; Address to MT_Init
s_AudioModEnd:
	dc.l	0			; Address to MT_End
s_AudioModMusic:
	dc.l	0			; Address to MT_Music
s_AudioModMVol:
	dc.l	0			; Address to Mastervolume
s_AudioModData:
	dc.l	0			; Address to mt_data (pointer to mod)
s_AudioVolSelect:
	dc.b	0			; Was VOL selection in menu selected
	EVEN
s_AudioModStatData:			; Audiomod status
	dc.b	0,0,0,0			; if channels if turned off or not (1=OFF)
	dc.b	0			; Audiofilter
	dc.b	64			; Mastervolume
	dc.b	0,0
s_AudioModStatFormerData:			; NO DATA IN BETWEEN HERE!!! OR YOU WILL HAVE BUGS!!
	dc.b	0,0,0,0
	dc.b	0,0			; Just a backup of former state of above.
	dc.b	0,0			; so it will not update all everytime.
	EVEN
s_IRQLev7:
	dc.w	0			; if 0 not lev7
s_IRQLevDone:
	dc.w	0
s_Frames:	dc.w	0			; Number of frames shown
s_Ticks:	dc.l	0			; Number of "ticks" in CIA test
s_TickFrame:
	dc.w	0			; how many frames reached when CIA test was done.
s_CIAPalLow:				; Low value for PAL tests
	dc.l	0
s_CIAPalHigh:				; igh value for PAL tests
	dc.l	0
s_CIANtscLow:
	dc.l	0
s_CIANtscHigh:
	dc.l	0
s_CIACtrl:
	dc.l	0
s_RTCsec:
	dc.w	0			; Number of seconds RTC test have been running
s_RTCirq:
	dc.w	0			; 0 if IRQ is off
s_RTC1secframe:
	dc.w	0			; Number of frames in 1 second
s_RTC10secframe:
	dc.w	0			; Number of frames in 10 seconds
s_RTCold:
	dc.l	0			; How RTC first longword was last read
s_RTCString:
	blk.b	14,0			; Block of RTC data
s_MemTestStart:
	dc.l	0
s_MemTestEnd:
	dc.l	0
s_MemTestFail:
	dc.l	0,0,0,0			; Add 1 to every byte that is wrong during check
	
s_GfxChipset:
	dc.b	0			; What GfxChipset is detected: 0 = OCS, 1 = ECS, 2 = AGA

	EVEN
s_BootMBFastmem:				; Amount of motherboard fastmem detected at bootpoint
	dc.l	0
s_FastMem:
	dc.l	0			; Variable for fastmem found during init with screen.
s_DetectMemRnd:
	dc.l	0			; used as a flag to tag for shadowram
s_MemDetected:
	dc.w	0			; If memory was detected
s_FastmemBlock:
	dc.l	0			; Number of fastmem memblocks found when doing detection in menus
s_CheckMemCancel:
	dc.w	0			; if not 0, we had a cancel of memorytest
s_CheckMemPreFail:
	dc.l	0			; shold be 0 or something failed preparing the block and do not test this block
s_CheckMemCancelReason:
	dc.l	0			; store reason of cancel
s_CheckMemStepSize:
	dc.l	0			; How many bytes to step between each memorycheck address
s_CheckMemPassQuit:
	dc.w	0			; if not 0, we quit this pass
s_CheckMemRND:
	dc.w	0			; If not 0, area will be random
s_CheckMemSeed:
	dc.l	0			; Random seedvariable
s_CheckMemQuick:
	dc.w	0			; if not 0, a quick test will be done (only one longword per block)
s_CheckMemRandom:
	dc.w	0			; if not 0, only random memorytest is done
s_CheckMemRandom1:
	dc.l	0			; Random seed 1
s_CheckMemRandom2:
	dc.l	0			; Random seed 2
s_CheckMemArea:
	dc.w	0			; If not 0, checkmem area have been changed.	
s_CheckMemAdrRnd:
	dc.l	0			; Store a random number for addresstest. to be sure we are not testing old data
s_CheckMemScanAdr:
	dc.l	0			; Address of current scan
s_CheckMemOldScanAdr:
	dc.l	0			; Address of current scan
s_CheckMemFrom:
	dc.l	0			; Startaddress of memory to check
s_CheckMemFrom2:
	dc.l	0
s_CheckMemTo:
	dc.l	0			; endaddress to check memory
s_CheckMemTo2:
	dc.l	0			; if not 0, endpoint have been changed.
s_CheckMemStatus:
	dc.w	0			; Should be 0 and this block was ok
s_CheckMemPass:
	dc.l	0			; Number of passes of memorycheck done
s_CheckMemPassOK:
	dc.l	0			; Number of OK passes
s_CheckMemPassFail:
	dc.l	0			; Number of failed passes
s_CheckMemPassOLD:
	dc.l	0			; Number of passes of memorycheck done
s_CheckMemPassOKOLD:
	dc.l	0			; Number of OK passes
s_CheckMemPassFailOLD:
	dc.l	0			; Number of failed passes
s_CheckMemBad:
	dc.w	0			; Should be 0 to be in a good block
s_CheckMemOldBad:
	dc.w	0			; Should be 0 to be in a good block
s_CheckAdrBad:
	dc.w	0			; Should be 0 to be in a good addressblock
s_CheckMemBlock: 
	dc.l	0			; Address of start of this block
s_CheckMemBlockEnd:
	dc.l	0			; Address of end of this block
s_CheckMemGoodBlock:
	dc.l	0			; Will state where good block started.
s_CheckMemBadBlock:
	dc.l	0			; Will state where the bad block started.
s_CheckMemBadAdr:
	dc.l	0			; Will sstate where the bad block of addresserrors starts.
s_CheckMemCurrent: 
	dc.l	0			; current address to check
s_CheckMemBlockDone:
	dc.l	0			; How much of the block is done
s_CheckMemCurrentOLD: 
	dc.l	0			; current address to check
s_CheckMemChecked:
	dc.l	0			; how much memory is checked
s_CheckMemCheckedOLD:
	dc.l	0			; how much WAS checked...
s_CheckMemUsable:
	dc.l	0			; how much usable memory
s_CheckMemUsableOLD:
	dc.l	0
s_CheckMemOldUsable:
	dc.l	0			; old

s_CheckMemOldNonUsable:
	dc.l	0			; how much non usable memory

s_CheckMemNonUsable:
	dc.l	0			; how much non usable memory
s_CheckMemNonUsableOLD:
	dc.l	0
s_CheckMemBitError:			; Will contain all bits with errors.  0=no error
	dc.l	0
s_CheckMemHighError:
	dc.l	0			; Will contain all bits with stuck 1
s_CheckMemLowError:
	dc.l	0			; Will contain all buts with stuck 0
s_CheckMemBitErrors:
	blk.b	32,0			; number of errors in each bit in a longword (max 255 errors per bit)
	dc.b	"b"
	EVEN
s_CheckMemAdrError:
	dc.l	0			; contain mask of addresserror
s_CheckMemAdrErrorOLD:
	dc.l	0
s_CheckMemAdrError2:
	dc.l	0			; contain numer of addresserrors
s_CheckMemAdrOldError2:
	dc.l	0			; contain numer of addresserrors
s_CheckMemByteErrors:
	dc.l	0,0,0,0			; number of errors on each byte in a longword
s_CheckMemErrors:
	dc.l	0			; Number of errors found
s_CheckMemErrorsOLD:
	dc.l	0			; Number of errors found
s_CheckMemNoErrors:
	dc.l	0			; total of memoryerrors
s_CheckMemNoErrorsBlock:
	dc.l	0			; total of memoryerrors
s_CheckMemOldNoErrors:
	dc.l	0			; "old" errorcount
s_CheckMemType:
	dc.b	0			; type of memory detected last time 0=none  1=Error 2=Good
s_CheckMemTypeEnd:
	dc.b	0			; if this is 0 then we can have a "end" text. 
s_CheckMemOldType:
	dc.b	0
s_CheckMemTypeChange:			; if 0, there is no change of type
	dc.b	0
s_CheckMemRow:
	dc.b	0			; What row to print message of type of memory on
s_CheckMemCol:
	dc.b	0			; What color to print row at
s_CheckMemFast:
	dc.b	0			; if anything else then 0, a fast scan will be perfomed
s_CheckMemNoShadow:
	dc.b	0			; if anything else then 0, no shadowcheck will be done
s_CheckMemManualX:
	dc.b	0			; Contains X cord of current text to input while asking for memadress
s_CheckMemManualY:
	dc.b	0			; .... and Y
s_CheckMemStartAdrTxt:
	dc.b	0,0,0,0,0,0,0,0,0	; String for startaddress
s_CheckmemEndAdrTxt:
	dc.b	0,0,0,0,0,0,0,0,0	; String for endaddress
	EVEN
s_CheckMemTypeStart:
	dc.l	0			; Startaddress of this "type" of memory
s_CheckMemEditAdr:
	dc.l	0			; Current address cursor points to in edit-mode
s_CheckMemEditScreenAdr:
	dc.l	0			; Startaddress of memorydump on screen in edit-mode
s_CheckMemEditXpos:
	dc.b	0			; Current X pos of cursor
s_CheckMemEditYpos:
	dc.b	0			; Current Y pos of cursor
s_CheckMemEditOldXpos:
	dc.b	0			; Old X pos of cursor
s_CheckMemEditOldYpos:
	dc.b	0			; Old Y pos of cursor
s_CheckMemEditCharPos:
	dc.b	0			; Current pos to edit memory.  0 or 1, 0 = high nibble, 1 = low)

	EVEN
s_RunCodeStart:
	dc.l	0			; Will contain address of first address of where code is in memory when copied to ram
s_RunCodeEnd:
	dc.l	0			; end of RunCode data

s_RETURN:
	dc.l	0			; Just a "return" value
s_MemTestPass:
	dc.l	0			; Number of passes in memorycheck

s_KeyBOld:
	dc.b	0			; Stores old scancode of keyboard
	EVEN

s_TF1260MemStart:
	dc.l	0
s_TF1260MemEnd:
	dc.l	0
s_TF1260IOStart:
	dc.l	0
s_TF1260IOEnd:
	dc.l	0
s_ShowMemAdr:
	dc.l	0			; Address to show at showmemaddr...
	even
s_savexpos:
	dc.b	0
s_saveypos:
	dc.b	0
s_savecol:
	dc.b	0
	EVEN
s_FirstMBMem:
	dc.l	0
s_MBMemSize:
	dc.l	0
s_DebugA0:
	dc.l	0			; Store A0 in here, so we have it stored.. before string overwrites it.
s_DebugD1:
	dc.l	0
s_DebD0:
	dc.l	0			; For debug..  to store registers
s_DebD1:
	dc.l	0			; For debug..  to store registers
s_DebD2:
	dc.l	0			; For debug..  to store registers
s_DebD3:
	dc.l	0			; For debug..  to store registers
s_DebD4:
	dc.l	0			; For debug..  to store registers
s_DebD5:
	dc.l	0			; For debug..  to store registers
s_DebD6:
	dc.l	0			; For debug..  to store registers
s_DebD7:
	dc.l	0			; For debug..  to store registers
s_DebA0:
	dc.l	0			; For debug..  to store registers
s_DebA1:
	dc.l	0			; For debug..  to store registers
s_DebA2:
	dc.l	0			; For debug..  to store registers
s_DebA3:
	dc.l	0			; For debug..  to store registers
s_DebA4:
	dc.l	0			; For debug..  to store registers
s_DebA5:
	dc.l	0			; For debug..  to store registers
s_DebA6:
	dc.l	0			; For debug..  to store registers
s_DebA7:
	dc.l	0			; For debug..  to store registers
s_DebSR:	dc.w	0			; For debug..  Statusregister
s_DebPC:	dc.l	0			; For debug..  PC for fault

s_MEMCHECKSIZE:
	dc.l	0			; size of block to do memcheck of
;MEMBLOCKSIZE:
	dc.l	0			; size of block to do memcheck of

; Reserved area for dumps of customregisters
s_BLTDDAT:
	dc.w	0
s_DMACONR:
	dc.w	0
s_VPOSR:
	dc.w	0
s_VHPOSR:
	dc.w	0
s_DSKDATR:
	dc.w	0
s_JOY0DAT:
	dc.w	0
s_JOY1DAT:
	dc.w	0
s_CLXDAT:
	dc.w	0
s_ADKCONR:
	dc.w	0
s_POT0DAT:
	dc.w	0
s_POT1DAT:
	dc.w	0
s_POTINP:
	dc.w	0
s_SERDATR:
	dc.w	0
s_DSKBYTR:
	dc.w	0
s_INTENAR:
	dc.w	0
s_INTREQR:
	dc.w	0
s_DENISEID:
	dc.w	0
s_HHPOSR:
	dc.w	0
s_CIAAPRA:
	dc.w	0
s_Passno:
	dc.l	0
s_CPU:
	dc.l	0			; Type of CPU
s_CPUGen:
	dc.l	0			; Generation of CPU
s_FPU:
	dc.l	0			; Type of FPU
s_PCRReg:
	dc.l	0			; Value of PCRReg IF 060, if not, this is 0
s_CPU060Rev:
	dc.b	0			; Revision of 060 cpu
s_MMU:
	dc.b	0			; if 0, there is no MMU
s_ADR24BIT:
	dc.b	0			; if 0 no 24 bit address cpu.
	EVEN
s_CPUPointer:
	dc.l	0			; Pointer to CPU String
s_FPUPointer:
	dc.l	0			; Pointer to FPU String

	EVEN
s_GayleData:
	dc.l	0			; Data from gayletest
s_DiskBuffer:
	dc.l	0			; Pointer to diskbuffer in disktests

s_GfxTestBpl:				; Pointers to bitplanes for gfxtest
	dc.l	0,0,0,0,0,0,0,0
s_OKtxt:	dc.l	0			; A longword, that SHOULD contain "OK!" as a VERY fast memtest
s_SHIT:
	dc.l	0			; SHITData
s_C:
	EVEN
s_MenuCopper:
	blk.b	EndRomMenuCopper-RomMenuCopper,0
	EVEN
s_ECSCopper:
	blk.b	EndRomEcsCopper-RomEcsCopper,0
s_ECSCopper2
	blk.b	EndRomEcsCopper-RomEcsCopper,0
s_JunkBuffer:
	blk.l	54,0			; Junkbuffer for 256 bytes

	; Put this data at the end of everything.


s_AudioWaves:
	blk.b	EndROMAudioWaves-ROMAudioWaves,0

	EVEN
s_DummySprite:
	dc.l	0


s_AutoConfDone:
	dc.b	0			; if set to anything except 0, autoconfig has been done
s_AutoConfFlag:
	dc.b	0
s_AutoConfBoards:
	dc.l	0			; How many boards are autoconfigured.
s_AutoConfList:				; Structure Manu.w Serial.W
	blk.l	14*33,0			; Store data for 33 boards
s_AutoConfMode:
	dc.b	0			; if set to anything but 0, a detailed (and more manual) autoconfig will be done.
	EVEN
s_AutoConfBuffer:
	blk.b	20,0			; Autoconfigbuffer.
	EVEN
s_AutoConfShutD:
	dc.b	0			; of not 0, we had a shutdown of a card
s_AutoConfZ2Ram:
	dc.b	0			; AutoConf where to config ram to next Z2 card
s_AutoConfZ2IO:
	dc.b	0			; AutoConf where to config rom to next Z2 card
	EVEN
s_AutoConfZ3:
	dc.w	0			; AutoConf where to config to next Z3 card
s_AutoConfType:
	dc.b	0			; If set to 0, no board was found
					; 1 = ROM
					; 2 = RAM
					; 3 = Z2Space, not RAM

s_BackupAutoConfZ2Ram:
	dc.b	0			; AutoConf where to config ram to next Z2 card
s_BackupAutoConfZ2IO:
	dc.b	0			; AutoConf where to config rom to next Z2 card
	EVEN
s_BackupAutoConfZ3:
	dc.w	0			; AutoConf where to config to next Z3 card


s_AutoConfExit:
	dc.b	0			; If anything than 0, force exit of loop
s_AutoConfIllegal:
	dc.b	0			; if anything than 0, cardconfig was illegal, force shutdown of card
s_AutoConfZorro:
	dc.b	0			; Should be set to 0 for Zorro II and 1 for Zorro III
	EVEN
s_AutoConfSize:
	dc.l	0			; Size of current board
s_AutoConfWByte:
	dc.w	0			; "Byte" to write to autoconfigboards (Word for Z3)
s_AutoConfAddr:
	dc.l	0			; Address to configure board to.
s_AutoConfFrom:
	dc.l	0
s_AutoConfTo:
	dc.l	0
s_Bpl1str:
	dc.l	0			; Space for the "BPL1" string
s_Bpl1:
	blk.b	80*256,2		; bitplane 1
s_EndBpl1:

s_Bpl2str:
	dc.l	0			; Space for the "BPL1" string
s_Bpl2:
	blk.b	80*256,33		; bitplane 2
s_EndBpl2:


	
s_Bpl3str:
	dc.l	0			; Space for the "BPL1" string
s_Bpl3:
	blk.b	80*256,3		; bitplane 3
s_EndBpl3:

	dc.l	0			; extra null-longword

	ifeq	a1k
s_ptplay:
	blk.b	mt_END-MT_Init,0			; Reserve memory of protracker replayroutine

	endc

	EVEN

	dc.b	"THEEND"
s_EndData:
	dc.l	0
