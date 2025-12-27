;
; Global Variables Structure 
; Auto-generated from 9_vars.s
;
    include "exec/types.i"

    STRUCTURE    Globals,0

        STRUCT    Variables,8192               ; Just reserve memory for "Stack" not used in nonrom mode
        LABEL     Endstack
        LONG      V                            ; Just a string to mark first part of data
        LONG      StackSize                    ; Will contain size of the stack
        LONG      StartAddress
        LONG      Bpl1Ptr                      ; Pointer to Bitplane 1
        LONG      Bpl2Ptr                      ; Pointer to Bitplane 2
        LONG      Bpl3Ptr                      ; Pointer to Bitplane 3
        LONG      BplEnd                       ; Let it be 0
        LONG      Xpos                         ; Variable for X position on screen to print on
        LONG      Ypos                         ; Variable for Y position on screen to print on
        LONG      LogYpos                      ; Variable for Y pos of logscreen
        LONG      shit                         ; crapvariable for debugging
        STRUCT    b2dTemp,2*4
        STRUCT    b2dString,3*4
        STRUCT    bindecoutput,14
        ALIGNWORD
        STRUCT    binhexoutput,10
        STRUCT    binstringoutput,33
        BYTE      Color
        ALIGNWORD
        LONG      HexBinBin
        LONG      DecBinBin
        WORD      SerialSpeed
        WORD      OldSerialSpeed
        LONG      keymap                       ; Points to keymap to be used.
        BYTE      NoSerial                     ; if other then 0, no serial output at start.
        BYTE      LoopB                        ; if other than 0, Loopbackadapter was attached at boot
        BYTE      GetCharData                  ; Result of GetChar
        STRUCT    keypressed,2                 ; What key is pressed
        STRUCT    keypressedshifted,2          ; Same but without shift
        STRUCT    keyresult,2                  ; Actual result to be printed on screen
        BYTE      skipnextkey                  ; if set to other than 0, next keypress will be ignored
        BYTE      scancode                     ; Scancode from buffer
        BYTE      key                          ; Keycode
        BYTE      keyctrl
        BYTE      keyalt
        BYTE      keyshift                     ; if !0 = shift is pressed Will actually contain the scancode
        BYTE      keycaps
        BYTE      keyup                        ; if 1 = key is pressed
        BYTE      keydown
        BYTE      keystatus
        BYTE      keynew                       ; if 1 the keypress is new
        BYTE      keyrepeat                    ; if 1 the key is still pressed down
        BYTE      CPUCache                     ; Status of CPU Cache, 0 = off
        ALIGNWORD
        LONG      ChipStart                    ; Start of detected chipmem
        LONG      ChipEnd                      ; End of chipmem
        LONG      FastStart                    ; Start of Detected prio Fastmem
        LONG      FastEnd                      ; end of fastmem
        LONG      BaseStart                    ; Start of Basemem (workarea)
        LONG      BaseEnd                      ; End of Basemem
        LONG      ChipUnreserved               ; Total of UNRESERVED Chipmem detected
        LONG      ChipUnreservedAddr           ; END of the Unreserved space
        LONG      FastBlocksAtBoot             ; amount of fastmemblocks found at boot
        LONG      GetChipAddr                  ; Response from GetChip routine
        LONG      MemAdr                       ; Response from GetMemory routine
        LONG      TotalChip                    ; Total Chipmem detected
        LONG      TotalFast                    ; Total Motherboard Fastmem detected
        LONG      ChipAdr                      ; Where chipmem starts
        LONG      oldkey
        LONG      InputRegister                ; the value of D0 of GetInput is stored here aswell
        BYTE      OldMouse1X                   ; old value of mouseport X
        BYTE      OldMouse1Y                   ; mouseport Y
        BYTE      OldMouse2X                   ; old value of mouseDATA on non mouseport X
        BYTE      OldMouse2Y                   ; Y
        BYTE      MouseX                       ; Mouse X position
        BYTE      MouseY                       ; Mouse Y Position
        BYTE      OldMouseX
        BYTE      OldMouseY
        BYTE      MOUSE                        ; if not 0, moouse is moved
        BYTE      BUTTON                       ; if not 0, a button is pressed
        BYTE      MBUTTON                      ; if not 0, a mousebutton is pressed
        BYTE      LMB                          ; if not 0, LMB pressed
        BYTE      RMB                          ; if not 0, RMB pressed
        BYTE      MMB                          ; if not 0, MMB pressed
        BYTE      P1LMB                        ; if not 0, LMB port1 pressed
        BYTE      P2LMB                        ; if not 0, LMB port2 pressed
        BYTE      P1RMB                        ; if not 0, RMB port1 pressed
        BYTE      P2RMB                        ; if not 0, RMB port1 pressed
        BYTE      P1MMB                        ; if not 0, MMB port1 pressed
        BYTE      P2MMB                        ; if not 0, MMB port1 pressed
        BYTE      STUCKP1LMB                   ; if not 0, LMB port1 stuck and should be ignored
        BYTE      STUCKP2LMB                   ; if not 0, LMB port2 stuck and should be ignored
        BYTE      STUCKP1RMB                   ; if not 0, RMB port1 stuck and should be ignored
        BYTE      STUCKP2RMB                   ; if not 0, RMB port1 stuck and should be ignored
        BYTE      STUCKP1MMB                   ; if not 0, MMB port1 stuck and should be ignored
        BYTE      STUCKP2MMB                   ; if not 0, MMB port1 stuck and should be ignored
        BYTE      DISPAULA                     ; if not 0, Paula seems bad. no paulatests should be done to check keypresses etc.
        BYTE      OVLErr                       ; Store if we had OVL Error
        BYTE      RASTER                       ; if not 0, We have detected working raster
        BYTE      SCRNMODE                     ; If 0, we are in PAL (50Hz) screenmode, any other we have NTSC (60Hz)
        BYTE      SerData                      ; if 0  we had no serialdata
        BYTE      Serial                       ; Will contain data from the serialport
        BYTE      OldSerial                    ; Will contain the last char that was detected on the serialport
        BYTE      SerBufLen                    ; Current length of serialbuffer
        STRUCT    SerBuf,256                   ; 256 bytes of serialbuffer
        BYTE      SerAnsiFlag                  ; nonzero means that we are in buffermode (number is actually number of chars in buffer)
        BYTE      SerAnsi35Flag
        BYTE      SerAnsi36Flag
        BYTE      SerAnsiBufLen                ; Buffertlength used for the moment.
        ALIGNWORD
        WORD      SerAnsiChecks                ; Number of checks with a result of 0 in Ansimode.
        LONG      SerAnsiBuff                  ; Reserve a longword for ANSI serialbuffer
        BYTE      PrintMenuFlag                ; if set to anything else then 0, print the menu
        BYTE      UpdateMenuFlag               ; if set to anything else then 0, update the menu.
        BYTE      UpdateMenuNumber             ; What itemnumber to update. 0 = all  (0 is the only that prints label)
        BYTE      MenuEntrys                   ; Will contain number of entrys in the menu being displayed
        BYTE      MenuPos                      ; What menu item to highlight
        BYTE      MenuChoose                   ; If anything else then 0, user have chosen this item on the menu
        WORD      MenuMouseAdd                 ; Variable for how many mousetics have been done..
        WORD      MenuMouseSub
        LONG      PortJoy0                     ; Detected directions of Joystick 0
        LONG      PortJoy1                     ; Detected directions of Joystick 1
        WORD      P0Fire                       ; Detected fire on Joystick 0
        WORD      P1Fire                       ; Detected fire on Joystick 1
        WORD      P0FireOLD                    ; just to detect changes.
        WORD      P1FireOLD
        LONG      PortJoy0OLD
        LONG      PortJoy1OLD
        LONG      PowerONStatus                ; Poweron Status
        WORD      SerTstBps                    ; BPS of serialtest
        BYTE      OldMarkItem                  ; Contains the item marked before
        BYTE      MarkItem                     ; Contains the item being marked.
        ALIGNWORD
        LONG      _pad0
        BYTE      NoDraw                       ; If this is other then 0, no screen is drawn, no text. for "no chipmem" modes
        BYTE      WorkOrder                    ; If this is other than 0, use memory from start instead from end.
        LONG      _pad1
        WORD      MenuNumber                   ; Contains the menunuber to be printed, from the Menus�list
        WORD      OldMenuNumber                ; Contain the old menunumber
        BYTE      NoChar                       ; if 0 print char, anything else, never do screenactions. (no chipmem avaible)
        BYTE      Inverted                     ; if 0, former char was not inverted
        ALIGNWORD
        LONG      Menu                         ; What menulist to use
        LONG      MenuVariable                 ; List of pointers to variables to print after menuitem.
        WORD      CurX                         ; Cursor X pos. "mouse" cursor
        WORD      CurY                         ; Cursor Y pos
        WORD      CurAddX                      ; How much was added in X dir
        WORD      CurSubX                      ; How much was subtracted uin X dir
        WORD      CurAddY
        WORD      CurSubY
        STRUCT    temp,10*4                    ; 10 longwords reserved for temporary crapdata
        LONG      nomem
        WORD      DriveTestVar
        LONG      _pad2
        WORD      _pad3
        LONG      _pad4
        LONG      _pad5
        WORD      DriveNo                      ; Drivenumber to test
        WORD      DriveOK                      ; Status of drive, 0=not ok, 1=OK
        BYTE      DriveMotor                   ; 0 = Diskdrivemotor is OFF
        BYTE      SideNo                       ; Side of disk.  0=Upper
        BYTE      TrackNo                      ; Current tracknumber
        BYTE      WantedTrackNo                ; Wanted tracknumber
        BYTE      oldbfe001                    ; Contains old value of bfe001
        BYTE      oldbfd100                    ; Contains old value of bfd100
        BYTE      sector                       ; Currend sector
        ALIGNWORD
        LONG      trackbuff                    ; Address to trackbuffer
        STRUCT    sectorbuff,4*4               ; a small part of MFMdecoded sectordata.
        WORD      AudSimpVar                   ; Variablelist for the menusystem
        LONG      _pad6
        WORD      _pad7
        LONG      _pad8
        WORD      _pad9
        LONG      _pad10
        WORD      _pad11
        LONG      _pad12
        WORD      _pad13
        LONG      _pad14
        WORD      _pad15
        LONG      _pad16
        WORD      _pad17
        LONG      _pad18
        WORD      _pad19
        LONG      _pad20
        WORD      _pad21
        LONG      _pad22
        BYTE      AudSimpChan1
        BYTE      AudSimpChan2
        BYTE      AudSimpChan3
        BYTE      AudSimpChan4
        BYTE      AudSimpVol
        BYTE      AudSimpWave
        BYTE      AudSimpFilter
        ALIGNWORD
        STRUCT    AudSimpVolStr,10
        ALIGNWORD
        WORD      AudioWaveNo                  ; What wave to play
        LONG      AudioModAddr                 ; Address of module in modtest
        LONG      AudioModInit                 ; Address to MT_Init
        LONG      AudioModEnd                  ; Address to MT_End
        LONG      AudioModMusic                ; Address to MT_Music
        LONG      AudioModMVol                 ; Address to Mastervolume
        LONG      AudioModData                 ; Address to mt_data (pointer to mod)
        BYTE      AudioVolSelect               ; Was VOL selection in menu selected
        ALIGNWORD
        STRUCT    AudioModStatData,4           ; if channels if turned off or not (1=OFF)
        BYTE      _pad23
        BYTE      _pad24
        STRUCT    _pad25,2
        STRUCT    AudioModStatFormerData,4     ; NO DATA IN BETWEEN HERE!!! OR YOU WILL HAVE BUGS!!
        STRUCT    _pad26,2
        STRUCT    _pad27,2
        ALIGNWORD
        WORD      IRQLev7                      ; if 0 not lev7
        WORD      IRQLevDone
        WORD      Frames                       ; Number of frames shown
        LONG      Ticks                        ; Number of "ticks" in CIA test
        WORD      TickFrame                    ; how many frames reached when CIA test was done.
        LONG      CIAPalLow                    ; Low value for PAL tests
        LONG      CIAPalHigh                   ; igh value for PAL tests
        LONG      CIANtscLow
        LONG      CIANtscHigh
        LONG      CIACtrl
        WORD      RTCsec                       ; Number of seconds RTC test have been running
        WORD      RTCirq                       ; 0 if IRQ is off
        WORD      RTC1secframe                 ; Number of frames in 1 second
        WORD      RTC10secframe                ; Number of frames in 10 seconds
        LONG      RTCold                       ; How RTC first longword was last read
        STRUCT    RTCString,14                 ; Block of RTC data
        LONG      MemTestStart
        LONG      MemTestEnd
        STRUCT    MemTestFail,4*4              ; Add 1 to every byte that is wrong during check
        BYTE      GfxChipset                   ; What GfxChipset is detected: 0 = OCS, 1 = ECS, 2 = AGA
        ALIGNWORD
        LONG      BootMBFastmem                ; Amount of motherboard fastmem detected at bootpoint
        LONG      FastMem                      ; Variable for fastmem found during init with screen.
        LONG      DetectMemRnd                 ; used as a flag to tag for shadowram
        WORD      MemDetected                  ; If memory was detected
        LONG      FastmemBlock                 ; Number of fastmem memblocks found when doing detection in menus
        WORD      CheckMemCancel               ; if not 0, we had a cancel of memorytest
        LONG      CheckMemPreFail              ; shold be 0 or something failed preparing the block and do not test this block
        LONG      CheckMemCancelReason         ; store reason of cancel
        LONG      CheckMemStepSize             ; How many bytes to step between each memorycheck address
        WORD      CheckMemPassQuit             ; if not 0, we quit this pass
        WORD      CheckMemRND                  ; If not 0, area will be random
        LONG      CheckMemSeed                 ; Random seedvariable
        WORD      CheckMemQuick                ; if not 0, a quick test will be done (only one longword per block)
        WORD      CheckMemRandom               ; if not 0, only random memorytest is done
        LONG      CheckMemRandom1              ; Random seed 1
        LONG      CheckMemRandom2              ; Random seed 2
        WORD      CheckMemArea                 ; If not 0, checkmem area have been changed.
        LONG      CheckMemAdrRnd               ; Store a random number for addresstest. to be sure we are not testing old data
        LONG      CheckMemScanAdr              ; Address of current scan
        LONG      CheckMemOldScanAdr           ; Address of current scan
        LONG      CheckMemFrom                 ; Startaddress of memory to check
        LONG      CheckMemFrom2
        LONG      CheckMemTo                   ; endaddress to check memory
        LONG      CheckMemTo2                  ; if not 0, endpoint have been changed.
        WORD      CheckMemStatus               ; Should be 0 and this block was ok
        LONG      CheckMemPass                 ; Number of passes of memorycheck done
        LONG      CheckMemPassOK               ; Number of OK passes
        LONG      CheckMemPassFail             ; Number of failed passes
        LONG      CheckMemPassOLD              ; Number of passes of memorycheck done
        LONG      CheckMemPassOKOLD            ; Number of OK passes
        LONG      CheckMemPassFailOLD          ; Number of failed passes
        WORD      CheckMemBad                  ; Should be 0 to be in a good block
        WORD      CheckMemOldBad               ; Should be 0 to be in a good block
        WORD      CheckAdrBad                  ; Should be 0 to be in a good addressblock
        LONG      CheckMemBlock                ; Address of start of this block
        LONG      CheckMemBlockEnd             ; Address of end of this block
        LONG      CheckMemGoodBlock            ; Will state where good block started.
        LONG      CheckMemBadBlock             ; Will state where the bad block started.
        LONG      CheckMemBadAdr               ; Will sstate where the bad block of addresserrors starts.
        LONG      CheckMemCurrent              ; current address to check
        LONG      CheckMemBlockDone            ; How much of the block is done
        LONG      CheckMemCurrentOLD           ; current address to check
        LONG      CheckMemChecked              ; how much memory is checked
        LONG      CheckMemCheckedOLD           ; how much WAS checked...
        LONG      CheckMemUsable               ; how much usable memory
        LONG      CheckMemUsableOLD
        LONG      CheckMemOldUsable            ; old
        LONG      CheckMemOldNonUsable         ; how much non usable memory
        LONG      CheckMemNonUsable            ; how much non usable memory
        LONG      CheckMemNonUsableOLD
        LONG      CheckMemBitError             ; Will contain all bits with errors.  0=no error
        LONG      CheckMemHighError            ; Will contain all bits with stuck 1
        LONG      CheckMemLowError             ; Will contain all buts with stuck 0
        STRUCT    CheckMemBitErrors,32         ; number of errors in each bit in a longword (max 255 errors per bit)
        BYTE      _pad28
        ALIGNWORD
        LONG      CheckMemAdrError             ; contain mask of addresserror
        LONG      CheckMemAdrErrorOLD
        LONG      CheckMemAdrError2            ; contain numer of addresserrors
        LONG      CheckMemAdrOldError2         ; contain numer of addresserrors
        STRUCT    CheckMemByteErrors,4*4       ; number of errors on each byte in a longword
        LONG      CheckMemErrors               ; Number of errors found
        LONG      CheckMemErrorsOLD            ; Number of errors found
        LONG      CheckMemNoErrors             ; total of memoryerrors
        LONG      CheckMemNoErrorsBlock        ; total of memoryerrors
        LONG      CheckMemOldNoErrors          ; "old" errorcount
        BYTE      CheckMemType                 ; type of memory detected last time 0=none  1=Error 2=Good
        BYTE      CheckMemTypeEnd              ; if this is 0 then we can have a "end" text.
        BYTE      CheckMemOldType
        BYTE      CheckMemTypeChange           ; if 0, there is no change of type
        BYTE      CheckMemRow                  ; What row to print message of type of memory on
        BYTE      CheckMemCol                  ; What color to print row at
        BYTE      CheckMemFast                 ; if anything else then 0, a fast scan will be perfomed
        BYTE      CheckMemNoShadow             ; if anything else then 0, no shadowcheck will be done
        BYTE      CheckMemManualX              ; Contains X cord of current text to input while asking for memadress
        BYTE      CheckMemManualY              ; .... and Y
        STRUCT    CheckMemStartAdrTxt,9        ; String for startaddress
        STRUCT    CheckmemEndAdrTxt,9          ; String for endaddress
        ALIGNWORD
        LONG      CheckMemTypeStart            ; Startaddress of this "type" of memory
        LONG      CheckMemEditAdr              ; Current address cursor points to in edit-mode
        LONG      CheckMemEditScreenAdr        ; Startaddress of memorydump on screen in edit-mode
        BYTE      CheckMemEditXpos             ; Current X pos of cursor
        BYTE      CheckMemEditYpos             ; Current Y pos of cursor
        BYTE      CheckMemEditOldXpos          ; Old X pos of cursor
        BYTE      CheckMemEditOldYpos          ; Old Y pos of cursor
        BYTE      CheckMemEditCharPos          ; Current pos to edit memory.  0 or 1, 0 = high nibble, 1 = low)
        ALIGNWORD
        LONG      RunCodeStart                 ; Will contain address of first address of where code is in memory when copied to ram
        LONG      RunCodeEnd                   ; end of RunCode data
        LONG      RETURN                       ; Just a "return" value
        LONG      MemTestPass                  ; Number of passes in memorycheck
        BYTE      KeyBOld                      ; Stores old scancode of keyboard
        ALIGNWORD
        LONG      TF1260MemStart
        LONG      TF1260MemEnd
        LONG      TF1260IOStart
        LONG      TF1260IOEnd
        LONG      ShowMemAdr                   ; Address to show at showmemaddr...
        ALIGNWORD
        BYTE      savexpos
        BYTE      saveypos
        BYTE      savecol
        ALIGNWORD
        LONG      FirstMBMem
        LONG      MBMemSize
        LONG      DebugA0                      ; Store A0 in here, so we have it stored.. before string overwrites it.
        LONG      DebugD1
        LONG      DebD0                        ; For debug..  to store registers
        LONG      DebD1                        ; For debug..  to store registers
        LONG      DebD2                        ; For debug..  to store registers
        LONG      DebD3                        ; For debug..  to store registers
        LONG      DebD4                        ; For debug..  to store registers
        LONG      DebD5                        ; For debug..  to store registers
        LONG      DebD6                        ; For debug..  to store registers
        LONG      DebD7                        ; For debug..  to store registers
        LONG      DebA0                        ; For debug..  to store registers
        LONG      DebA1                        ; For debug..  to store registers
        LONG      DebA2                        ; For debug..  to store registers
        LONG      DebA3                        ; For debug..  to store registers
        LONG      DebA4                        ; For debug..  to store registers
        LONG      DebA5                        ; For debug..  to store registers
        LONG      DebA6                        ; For debug..  to store registers
        LONG      DebA7                        ; For debug..  to store registers
        WORD      DebSR                        ; For debug..  Statusregister
        LONG      DebPC                        ; For debug..  PC for fault
        LONG      MEMCHECKSIZE                 ; size of block to do memcheck of
        LONG      _pad29
        WORD      BLTDDAT
        WORD      DMACONR
        WORD      VPOSR
        WORD      VHPOSR
        WORD      DSKDATR
        WORD      JOY0DAT
        WORD      JOY1DAT
        WORD      CLXDAT
        WORD      ADKCONR
        WORD      POT0DAT
        WORD      POT1DAT
        WORD      POTINP
        WORD      SERDATR
        WORD      DSKBYTR
        WORD      INTENAR
        WORD      INTREQR
        WORD      DENISEID
        WORD      HHPOSR
        WORD      CIAAPRA
        LONG      Passno
        LONG      CPU                          ; Type of CPU
        LONG      CPUGen                       ; Generation of CPU
        LONG      FPU                          ; Type of FPU
        LONG      PCRReg                       ; Value of PCRReg IF 060, if not, this is 0
        BYTE      CPU060Rev                    ; Revision of 060 cpu
        BYTE      MMU                          ; if 0, there is no MMU
        BYTE      ADR24BIT                     ; if 0 no 24 bit address cpu.
        ALIGNWORD
        LONG      CPUPointer                   ; Pointer to CPU String
        LONG      FPUPointer                   ; Pointer to FPU String
        ALIGNWORD
        LONG      GayleData                    ; Data from gayletest
        LONG      DiskBuffer                   ; Pointer to diskbuffer in disktests
        STRUCT    GfxTestBpl,8*4               ; Pointers to bitplanes for gfxtest
        LONG      OKtxt                        ; A longword, that SHOULD contain "OK!" as a VERY fast memtest
        LONG      SHIT                         ; SHITData
        LABEL     C
        STRUCT    MenuCopper,RomMenuCopperSize
        ALIGNWORD
        STRUCT    ECSCopper,RomEcsCopperSize
        STRUCT    ECSCopper2,RomEcsCopperSize
        STRUCT    JunkBuffer,(54)*4            ; Junkbuffer for 256 bytes
        STRUCT    AudioWaves,ROMAudioWavesSize
        ALIGNWORD
        LONG      DummySprite
        BYTE      AutoConfDone                 ; if set to anything except 0, autoconfig has been done
        BYTE      AutoConfFlag
        LONG      AutoConfBoards               ; How many boards are autoconfigured.
        STRUCT    AutoConfList,(14*33)*4       ; Store data for 33 boards
        BYTE      AutoConfMode                 ; if set to anything but 0, a detailed (and more manual) autoconfig will be done.
        ALIGNWORD
        STRUCT    AutoConfBuffer,20            ; Autoconfigbuffer.
        ALIGNWORD
        BYTE      AutoConfShutD                ; of not 0, we had a shutdown of a card
        BYTE      AutoConfZ2Ram                ; AutoConf where to config ram to next Z2 card
        BYTE      AutoConfZ2IO                 ; AutoConf where to config rom to next Z2 card
        ALIGNWORD
        WORD      AutoConfZ3                   ; AutoConf where to config to next Z3 card
        BYTE      AutoConfType                 ; If set to 0, no board was found
        BYTE      BackupAutoConfZ2Ram          ; AutoConf where to config ram to next Z2 card
        BYTE      BackupAutoConfZ2IO           ; AutoConf where to config rom to next Z2 card
        ALIGNWORD
        WORD      BackupAutoConfZ3             ; AutoConf where to config to next Z3 card
        BYTE      AutoConfExit                 ; If anything than 0, force exit of loop
        BYTE      AutoConfIllegal              ; if anything than 0, cardconfig was illegal, force shutdown of card
        BYTE      AutoConfZorro                ; Should be set to 0 for Zorro II and 1 for Zorro III
        ALIGNWORD
        LONG      AutoConfSize                 ; Size of current board
        WORD      AutoConfWByte                ; "Byte" to write to autoconfigboards (Word for Z3)
        LONG      AutoConfAddr                 ; Address to configure board to.
        LONG      AutoConfFrom
        LONG      AutoConfTo
        LONG      Bpl1str                      ; Space for the "BPL1" string
        STRUCT    Bpl1,80*256                  ; bitplane 1
        LABEL     EndBpl1
        LONG      Bpl2str                      ; Space for the "BPL1" string
        STRUCT    Bpl2,80*256                  ; bitplane 2
        LABEL     EndBpl2
        LONG      Bpl3str                      ; Space for the "BPL1" string
        STRUCT    Bpl3,80*256                  ; bitplane 3
        LABEL     EndBpl3
        LONG      _pad30
    ifeq	a1k
        STRUCT    ptplay,PTReplaySize          ; Reserve memory of protracker replayroutine
    endc
        ALIGNWORD
        STRUCT    _pad31,6
        LONG      EndData

    LABEL     Globals_SIZEOF
