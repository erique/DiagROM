TheCode:
						; D0 = Number of 64k chipmemblocks found
						; D1 = total of fastmemblocks

							; A6 = Basemem found (workmem)
							; A4 = controlregister

	move.w	#$bbb,$dff180


	clr.l	d2
	clr.l	d4
	clr.l	d5
	clr.l	d6
	clr.l	d7
	move.l	#-1,d7
	lea	$0,a0
	lea	$0,a1
	lea	$0,a2
	lea	$0,a3
	lea	$0,a5




;.noserialturnoff:



	move.l	d1,FastBlocksAtBoot-V(a6)	; Store the amount of fastmemblocks found at boot

	cmp.l	#-1,d1			; if d1 was -1, fastmemtest was skipped.  clear it
	bne	.noskip
	clr.l	d1			; ok we had skipped fastmemtest, lets clear d1 to say that we didnt find anything
					; real value stored above anyway
.noskip:




	asl.l	#6,d1			; Multiply  d1 with 64 to get correct number of kilobytes of fastmem.;


	move.l	a4,d7



	move.l	d7,PowerONStatus-V(a6)	; Save the Poweronstatus. buttons etc

; Bits  0=P1LMB, 1=P2LMB, 2=P1RMB, 3=P2RMB, 4=P1MMB, 5=P2MMB, 6=NODRAW, 7=NOSERIAL, 8=OVL ERROR, 9=LOOPBACK


	btst	#0,d7
	beq	.NOP1LMB
	btst	#6,$bfe001		; Check LMB port 1
	bne	.NOP1LMB		; NOT pressed.. Skip to next
	move.b	#1,STUCKP1LMB-V(a6)
.NOP1LMB:
	btst	#1,d7
	beq	.NOP2LMB
	btst	#7,$bfe001		; Check LMB port 2
	bne	.NOP2LMB
	move.b	#1,STUCKP2LMB-V(a6)
.NOP2LMB:
	btst	#2,d7
	beq	.NOP1RMB
	btst	#10,$dff016		; Check RMB port 1
	bne	.NOP1RMB
	move.b	#1,STUCKP1RMB-V(a6)
.NOP1RMB:
	btst	#3,d7
	beq	.NOP2RMB
	btst	#14,$dff016		; Check RMB port 2
	bne	.NOP2RMB
	move.b	#1,STUCKP2RMB-V(a6)
.NOP2RMB:
	btst	#8,d7			; Check if we had OVL error
	bne	.OVLError
	move.b	#0,OVLErr-V(a6)
	bra	.noOVLError
.OVLError:
	move.b	#1,OVLErr-V(a6)
	move.b	#1,STUCKP1LMB-V(a6)
	move.b	#1,STUCKP2LMB-V(a6)

.noOVLError:
	
	btst	#6,d7			; is bit6 d7 set? then we should not draw anything onscreen
	beq	.notset
	move.b	#1,NoDraw-V(a6)

.notset:

	move.b	#0,NoSerial-V(a6)

	btst	#7,d7			; Check if noserial is to be set
	beq	.notset2
	move.b	#1,NoSerial-V(a6)	; set it

.notset2:
	move.b	#0,LoopB-V(a6)

	btst	#4,d7			; Check if loopbackadapter was attached at boot (buggy code, so will test again)
	beq	.notset3
	
	move.b	#1,LoopB-V(a6)
.notset3:

	btst	#13,d7			; is bit13 d7 set? then we had RMB pressed at poweron, reversing workorder
	beq	.notset4
	move.b	#1,WorkOrder-V(a6)

.notset4:



	move.l	d1,TotalFast-V(a6)	; Store total fastmem detected
	move.l	d1,BootMBFastmem-V(a6)
	asl.l	#6,d0			; Multiply d0 with 64 as it contains number of blocks of 64K

	cmp.l	#$200000,d3		; Check if "chipmem" is above 2MB, then set to 0 as.. well wrong
	blt	.bigger
	clr.l	d3
.bigger:


	move.l	d3,ChipStart-V(a6)	; Write where detected chipmem starts
	move.l	d0,TotalChip-V(a6)	; Write totalchipvalue so we know how much chipmem is detected



	move.l	a6,d0			; Subtract startaddress with lowest value of detected ram
	sub.l	#V-Variables,d0

	move.l	d0,ChipUnreservedAddr-V(a6)
	sub.l	d3,d0			; also subtract stacksize, now we got all usable NONUSED chipmem
	move.l	d0,ChipUnreserved-V(a6)	; Store amount of NONRESERVED chipmem




	jsr	GetHWReg		; Store HW Registers

	move.l	a6,d0
		ifne	rommode
	sub.l	#Endstack-Variables+4,d0

		endc

	asr.l	#2,d0
	asl.l	#2,d0			; Make sure start is on a even 32 bit location!

	move.l	d0,BaseStart-V(a6)	; Store start of Basememory


	add.l	#(EndData-Variables)+2047,d0


	move.l	d0,BaseEnd-V(a6)


	move.l	ChipStart-V(a6),d1	; Get startaddress of chipmem
	move.l	TotalChip-V(a6),d0	; Get total of chipmemblocks detected
	mulu	#1024,d0
	sub.l	#$401,d0		; Subtract first 1Kb
	add.l	d1,d0			; add Startaddess of chipmem, so d0 now contains last memaddress

	cmp.l	#$0,d1			; Check if start is at 0. .then we know end is 0
	bne	.bigger2
	clr.l	d0
	clr.l	TotalChip-V(a6)		; then also total chipmem is 0
.bigger2:



	move.l	d0,ChipEnd-V(a6)	; Write lastchipmemaddress into EndChip






;---------------------------------- This is more or less where it all starts and a system is up and running





	bset	#1,$bfe001

	lea	LoopSerTest,a0
	lea	.dirtyjump,a1		; TECHNICALLY we do not need to do this dirty thing anymore, but just to
	bra	DumpSerial		; reuse the code
.dirtyjump
	bsr	ClearSerial
	bsr	ClearSerial
	clr.l	d6			; Clear d6 as it a counter for how many similiar chars we got back as echo
	move.b	#"<",d2			; Char to test
	bsr	RealLoopbacktest

	move.b	#">",d2			; Char to test
	bsr	RealLoopbacktest

	cmp.b	#0,d6			; Check if we had any return, if so we have a loopbackadapter installed.
	beq	.noloopback

	move.w	#5,SerialSpeed-V(a6)	; Set serialspeed to 5 ,(same as 0 but mark loopbackadapter)
	move.b	#1,LoopB-V(a6)

	lea	DDETECTED,a0
	lea	.loopbackdone,a1
	bra	DumpSerial

.noloopback:
	lea	NoLoopback,a0
	lea	.loopbackdone,a1
	bra	DumpSerial

.loopbackdone:

	cmp.b	#1,NoSerial-V(a6)	; Check if noserial is set
	beq	.noser
	cmp.b	#1,LoopB-V(a6)		; Check if loopbackadapter was attacjhed
	beq	.noserloop		; in that case, no serial output
	move.w	#2,SerialSpeed-V(a6)	; KUKEN
	bsr	Init_Serial
	bra	.ser

.noserloop:
	move.w	#5,SerialSpeed-V(a6)	; Set serialspeed to 5 ,(same as 0 but mark loopbackadapter)
	move.b	#1,NoSerial-V(a6)
	bra	.ser
.noser:
	move.w	#0,SerialSpeed-V(a6)	; Set Serialspeed to 0
.ser:

	move.w	#$aaa,$dff180


	lea	DetectRasterTxt,a0
	bsr	SendSerial


	move.b	$dff006,d0		; Load value of raster
	jsr	WaitShort
	jsr	WaitShort
	jsr	WaitShort
	move.b	$dff006,d1		; Load value of raster again
	cmp.b	d0,d1
	beq	.noraster		; if raster was the same, We assume we have no working raster
	move.b	#1,RASTER-V(a6)		; it was different so we assume we have working raster.
	lea	DETECTED,a0
	bsr	SendSerial
	beq	.rastercheckdone

.noraster:
	move.b	#0,RASTER-V(a6)
	lea	SFAILED,a0
	bsr	SendSerial
.rastercheckdone:



	move.w	#$999,$dff180


	lea	NewLineTxt,a0
	bsr	SendSerial

	move.l	#EnglishKey,keymap-V(a6)	; Set english keymap as default

	lea	DetChipTxt,a0
	bsr	SendSerial

	move.l	TotalChip-V(a6),d0
	bsr	bindec
	bsr	SendSerial
	lea	KB,a0
	bsr	SendSerial		; Put out detected chipmem on serialport..
	lea	NewLineTxt,a0
	bsr	SendSerial

	lea	DetMBFastTxt,a0
	bsr	SendSerial
	
	nop
	move.l	BootMBFastmem-V(a6),d0
	bsr	bindec
	bsr	SendSerial
	lea	KB,a0
	bsr	SendSerial
	lea	NewLineTxt,a0
	bsr	SendSerial

	lea	BaseAdrTxt,a0
	bsr	SendSerial
	move.l	a6,d0
		ifne	rommode
	sub.l	#Endstack-Variables+4,d0
		endc
	bsr	binhex
	bsr	SendSerial
	lea	NewLineTxt,a0
	bsr	SendSerial



	move.l	#$4f4b2100,OKtxt-V(a6)
	lea 	FastOKTxt,a0
	bsr	SendSerial

	move.l	a6,a0
	add.l	#OKtxt-V,a0
	bsr	SendSerialLW

	lea	NewLineTxt,a0
	bsr	SendSerial



	move.w	#$888,$dff180



 	PAROUT	#$f9		; Set code to $81 to paralellport, NOT ENOUGH chipmem avaible
	lea	parf9txt,a0		; And explaining simliar text to serialport.
	bsr	SendSerial

	lea	ChipSetupInit,a0
	bsr	SendSerial

	move.l	#"DATA",Endstack-Variables(a6)	; Write "DATA" to first usable longword after stack


	move.l	#Endstack-Variables,StackSize-V(a6)		; write stacksize to varible for stacksize.
	move.l	a6,StartAddress-V(a6)


	move.l	a6,a5
	add.l	#Bpl1str-V,a5		; we do this way as this are in the end and big segments above 64k...
	move.l	#"BPL1",(a5)+		; Put the BPL1 string, just to be able to identify BPL1
	move.l	a5,Bpl1Ptr-V(a6)	; and store the pointer to bitplane

	move.l	a6,a5
	add.l	#Bpl2str-V,a5
	move.l	#"BPL2",(a5)+
	move.l	a5,Bpl2Ptr-V(a6)

	move.l	a6,a5
	add.l	#Bpl3str-V,a5
	move.l	#"BPL3",(a5)+
	move.l	a5,Bpl3Ptr-V(a6)
	clr.l	BplEnd-V(a6)		; make it 0, so we have a bitplanelist

	move.l	a6,a5
	add.l	#EndData-V,a5
	move.l	#"END!",(a5)

	bsr	CopyToChip

	move.w	#$777,$dff180


	bsr	InitStuff
					
	lea	ChipSetupDone,a0
	bsr	SendSerial

; Initialize the screen.


	ifeq	rommode

	clr.l	d0
	clr.l	d1
	clr.l	d2
	clr.l	d3
	clr.l	d4
	clr.l	d5
	clr.l	d6
	clr.l	d7

	move.w	#$666,$dff180

					; Code to handle stuff when NOT using rom mode. when coding/testing
		move.l	SP,STACKPOINTER		; Store stackpointer
	        move.l  4.w,a6
	        lea     graph,a1          
	        moveq   #33,d0
	        jsr     -552(a6)        	;open gfxlib    
	        move.l  d0,-(a7)        	;gfxbase!!
	        move.l  d0,a6
		jsr	-456(a6)		;OwnBlitter
		jsr	WaitLong

		jsr	-228(a6)		;WaitBlit
	        move.l  34(a6),ActiveView	;Store activeview for a clean exit
	        sub.l   a1,a1


		jsr	WaitLong
;		jsr	WaitLong
;		jsr	WaitLong
;		jsr	WaitLong
;		jsr	WaitLong
;		jsr	WaitLong
;		jsr	WaitLong



	        jsr     -222(a6)        	;loadview(NULL) hell..this only works w. a6
		jsr	-270(a6)		;WaitTOF()
		jsr	-270(a6)		;WaitTOF()

		jsr	WaitLong
;		jsr	WaitLong
;		jsr	WaitLong
;		jsr	WaitLong
;		jsr	WaitLong		; Dirty code..  to get rid of issue of screen not initilized sometimes



	        move.l  4.w,a6
		jsr     -132(a6)        	;forbid
		move.l	$4,a6			;exec.library
		jsr	-150(a6)		;Switches the processor to supervisor mode. Keeps the user stack, witch contains all
						;interrupt data.

		lea	V,a6
		move.l	d0,sysstack


	endc

	cmp.b	#0,NoDraw-V(a6)
	bne	.NoChip

	move.w	#$555,$dff180


	bsr	SetMenuCopper


	lea	InitPOTGO,a0
	bsr	SendSerial
	move.w	#$ff00,$dff034
	lea	InitDONEtxt,a0
	bsr	SendSerial

 	PAROUT	#$f8			; Set code to $81 to paralellport, NOT ENOUGH chipmem avaible
	lea	parf8txt,a0			; And explaining simliar text to serialport.
	bsr	SendSerial

	move.w	#$333,$dff180



	bsr	ClearScreenNoSerial

	lea	InitTxt,a0
	move.l	#7,d1
	bsr	Print
	bra	.Chip

.NoChip:
	lea	NoDrawTxt,a0
	bsr	SendSerial
.Chip:
	bsr	RomChecksum


	ifne	rommode
		move.l	#.cpureturn,a5
		bsr	DetectCPU
.cpureturn:

		bsr	PrintCPU


	move.l	FastBlocksAtBoot-V(a6),d1

;	cmp.l	#-1,d1
;	bne	.notskippedfast


	lea	FastDetectTxt,a0
	move.l	#3,d1
	bsr	Print
	move.b	$dff006,d0			; load d0 with a "random" number for memdetect to work
	bsr	DetFastMem
	

 	endif



					; Check and fix if memareas is within workmem
	move.l	ChipStart-V(a6),d0
	bsr	IsCollide
	cmp.l	#0,d7
	beq	.CSDone
	move.l	BaseEnd-V(a6),d0
	add.l	#1,d0
	move.l	d0,ChipStart-V(a6)
.CSDone:

	move.l	ChipEnd-V(a6),d0
	bsr	IsCollide
	cmp.l	#0,d7
	beq	.CEDone
	move.l	BaseStart-V(a6),d0
	sub.l	#1,d0
	move.l	d0,ChipEnd-V(a6)

.CEDone:
	move.l	FastStart-V(a6),d0
	bsr	IsCollide
	cmp.l	#0,d7
	beq	.FSDone
	move.l	BaseEnd-V(a6),d0
	add.l	#1,d0
	move.l	d0,FastStart-V(a6)
.FSDone:

	move.l	FastEnd-V(a6),d0
	bsr	IsCollide
	cmp.l	#0,d7
	beq	.FEDone
	move.l	BaseStart-V(a6),d0
	sub.l	#1,d0
	move.l	d0,FastEnd-V(a6)
.FEDone:


	lea	WorkAreasTxt,a0
	move.l	#7,d1
	bsr	Print

	move.l	ChipStart-V(a6),d0
	bsr	binhex
	bsr	Print

	lea	MinusTxt,a0
	bsr	Print

	move.l	ChipEnd-V(a6),d0
	bsr	binhex
	bsr	Print


	lea	WorkAreasTxt2,a0
	bsr	Print


	move.l	FastStart-V(a6),d0
	bsr	binhex
	bsr	Print

	lea	MinusTxt,a0
	bsr	Print

	move.l	FastEnd-V(a6),d0
	bsr	binhex
	bsr	Print




	move.l	FastMem-V(a6),d1
	asl.l	#6,d1
	move.l	d1,TotalFast-V(a6)




.notskippedfast:
	lea	IfSoldTxt,a0
	move.l	#5,d1
	bsr	Print


	lea	InitSerial2,a0
	move.l	#7,d1
	bsr	Print

	cmp.b	#1,NoDraw-V(a6)			; Check if we are in NoDraw Mode. if so. do not disable serialport
	beq	.nodraw

	cmp.b	#1,NoSerial-V(a6)
	beq	.serialon			; IF Noserial was set, skip this part

	cmp.b	#1,LoopB-V(a6)			; Same if loopbackadapter was attached
	beq	.serialon

	jsr	ClearBuffer

	move.l	#1200,d7			; read data for a while.. Giving user a possability of try to press a key on serialport
	clr.l	d6
.waitloop:
	move.b	d7,$dff181			; Just flash some colors. so local user can see that something is happening
	bsr	GetInput
	cmp.b	#1,RMB-V(a6)			; RMB pressed? then turn serial on
	beq	.serialon
	btst	#2,d0
	bne	.serialon			; if any key was pressed turn serial on
	btst	#3,d0
	bne	.serialon
	add.l	#1,d6
	cmp	#16,d6
	bne	.nodot
	lea	DotTxt,a0
	move.l	#7,d1
	bsr	Print
	clr.l	d6
.nodot:
	dbf	d7,.waitloop
	lea	EndSerial,a0			; Send text about "no key pressed"
	move.l	#7,d1
	bsr	SendSerial
	move.w	#0,SerialSpeed-V(a6)
	bra	.serialon

.nodraw:
	TOGGLEPWRLED
	move.w	#2,SerialSpeed-V(a6)
	lea	NoDrawTxt,a0
	bsr	SendSerial
	
.serialon:


	jsr	ClearBuffer

; Clears screen and lets go on

;	clr.w	SerialSpeed-V(a6)	; Disable Serialport

	clr.l	d7


	bsr	DefaultVars

	move.l	#Menus,Menu-V(a6)
	bra	MainMenu			; Print the mainmenu



MainLoop:
	move.l	#0,a0
	bsr	PrintMenu			; Print or update the menu

	bsr	GetInput			; Scan keyboard, mouse, buttons, serialport etc..


	clr.l	d0
	move.l	#27,d1
	bsr	SetPos
	clr.l	d0

	ifne	debug				; Print and do debugshit
		move.l	#0,d0
		move.l	#28,d1
		bsr	SetPos
		clr.l	d0
		move.b	GetCharData-V(a6),d0
		bsr	bindec
		move.l	#2,d1
		bsr	Print

		move.l	#5,d0
		move.l	#28,d1
		bsr	SetPos
		clr.l	d0
		move.w	shit-V(a6),d0
		bsr	binhexword
		move.l	#4,d1
		bsr	Print


		move.l	#15,d0
		move.l	#28,d1
		bsr	SetPos
		move.l	SerBuf-V(a6),d0
		bsr	binhex
		move.l	#2,d1
		bsr	Print
	endc


.no:
		ifeq	rommode

	cmp.b	#1,RMB
	beq.w	Exit
		endc

	bsr	HandleMenu			; ok, LMB pressed, do menuhandling

.notpressed:
	clr.l	d0
	move.l	InputRegister-V(a6),d0
	btst	#0,d0
	bra	MainLoop

IsCollide:
						; Checks if addresses collides with baseaddress. if so a
	PUSH

	move.l	BaseStart-V(a6),d1
	move.l	BaseEnd-V(a6),d2
	clr.l	d7

	cmp.l	d0,d1
	bgt	.no

	cmp.l	d0,d2
	blt	.no

	move.l	#1,d7
	bra	.done

.no:
	clr.l	d7
.done:
	move.l	d7,RETURN-V(a6)

	POP
	move.l	RETURN-V(a6),d7
	rts



						

Exit:
		ifeq	rommode

	move.l	irq1,$64
	move.l	irq2,$68
	move.l	irq3,$6c
	move.l	irq4,$70
	move.l	irq5,$74
	move.l	irq6,$78
	move.l	irq7,$7c

	move.l	SaveBusError,$8		; This time to a routine that can present more data.
	move.l	SaveAddressError,$c
	move.l	SaveIllegalError,$10
	move.l	SaveDivByZero,$14
	move.l	SaveChkInst,$18
	move.l	SaveTrapV,$1c
	move.l	SavePrivViol,$20
	move.l	SaveTrace,$24
	move.l	SaveUnimplInst,$28
	move.l	SaveUnimplInst2,$2c
	move.l	SaveTrap,$80
	move.l	SaveTrap2,$84
	move.l	SaveTrap3,$88
	move.l	SaveTrap4,$8c
	move.l	SaveTrap5,$90
	move.l	SaveTrap6,$94
	move.l	SaveTrap7,$98
	move.l	SaveTrap8,$9c
	move.l	SaveTrap9,$a0
	move.l	SaveTrap10,$a4
	move.l	SaveTrap11,$a8
	move.l	SaveTrap12,$ac
	move.l	SaveTrap13,$b0
	move.l	SaveTrap14,$b4
	move.l	SaveTrap15,$b8
	move.l	SaveTrap16,$bc


	move.b	#$40,$bfe601
	move.b	#$a0,$bfe701



	move.l	$4,a6				; Exec.library
	move.l	sysstack,d0
	jsr	-156(a6)			; Restore from supervisor mode
	jsr	-138(a6)			; Permit
	lea	graph,a1
	jsr	-408(a6)			; open graphics.library
	move.l	d0,a6
	move.l	ActiveView,a1
	move.l	38(a6),$dff080
	jsr	-222(a6)			; Restore ActiveView (original gfx mode)
	jsr	-462(a6)			;Disown Blitter

	move.l	a6,a1
	move.l	$4,a6
	jsr	-414(a6)			; Close library (graphics.library)

	move.l	STACKPOINTER,SP			; Restore Stackpointer
	rts
		endc
	rts


	
RomChecksum:
	ifeq	a1k
	lea	RomCheckTxt,a0
	move.l	#3,d1
	bsr	Print

	lea	Checksums,a1			; Load a1 with list of checksums
	lea	rom_base,a5

	move.l	#Checksums,d2			; store Checksumaddre in d1
	move.l	#EndChecksums,d3		; store end of Checksumaddr in d2
	move.l	#7,d6
	move.l	#10,$404
.romcheckloop2:
	move.l	#0,d0				; Clear D0 that calculates the checksum
	move.l	#$3fff,d7
.romcheckloop:
						; lets skip checksumcalc if we are in checksumvar area
	cmp.l	d2,a5
	bhi	.higher
	bra	.not
.higher:
	cmp.l	d3,a5
	bhi	.not
	add.l	#1,$404
						; ok we are in address of checksums. skip calc
	add.l	#4,a5
	bra	.nocalc
.not:
	add.l	(a5)+,d0
.nocalc
	dbf	d7,.romcheckloop
.endromcheck:
	cmp.l	(a1)+,d0			; Check if it fits stored checksum
	bne	.nocheckok
	move.l	#2,d1
	bra	.checkok
.nocheckok:
	move.l	#1,d1
.checkok:
	bsr	binhex
	bsr	Print
	lea	SpaceTxt,a0
	bsr	Print
	dbf	d6,.romcheckloop2
	endc
	rts


SetMenuCopper:
	lea	InitCOP1LCH,a0
	bsr	SendSerial
	move.l	a6,d0
	add.l	#MenuCopper-V,d0
	move.l	d0,$dff080			;Load new copperlist
	lea	InitDONEtxt,a0
	bsr	SendSerial

	lea	InitCOPJMP1,a0
	bsr	SendSerial
	move.w	$dff088,d0
	lea	InitDONEtxt,a0
	bsr	SendSerial

	lea	InitDMACON,a0
	bsr	SendSerial
	move.w	#$8380,$dff096
	lea	InitDONEtxt,a0
	bsr	SendSerial

	lea	InitBEAMCON0,a0
	bsr	SendSerial
	move.w	#32,$dff1dc			;Hmmm
	lea	InitDONEtxt,a0
	bsr	SendSerial
	rts

InitStuff:

	lea	ChipSetup7,a0
	bsr	SendSerial


	move.l	a6,a1
	add.l	#Bpl1Ptr-V,a1
	move.l	a6,a0
	add.l	#MenuCopper-V,a0
	add.l	#MenuBplPnt-RomMenuCopper,a0
	bsr	FixBitplane

	bset	#5,SCRNMODE-V(a6)		; Set bit in SCRNMODE, to tell that we are in PAL mode

	rts

ClearScreen:
	PUSH
	cmp.b	#0,NoDraw-V(a6)
	bne	.no
	move.l	Bpl1Ptr-V(a6),a0		; load A0 with address of BPL1
	move.l	Bpl2Ptr-V(a6),a1		; load A1 with address of BPL2
	move.l	Bpl3Ptr-V(a6),a2		; load A2 with address of BPL3

	move.l	#20*256,d0
.loop:
	clr.l	(a0)+
	clr.l	(a1)+
	clr.l	(a2)+
	dbf	d0,.loop
.no:
	lea	AnsiNull,a0
	bsr	SendSerial

	move.l	#12,d0
	bsr	rs232_out
	lea	AnsiNull,a0
	bsr	SendSerial

	clr.l	d0
	clr.l	d1
	bsr	SetPos
	POP
	rts

ClearScreenNoSerial:				; Clear screen but does not dump to serialport.
	cmp.b	#0,NoDraw-V(a6)
	bne	.no
	move.l	Bpl1Ptr-V(a6),a0		; load A0 with address of BPL1
	move.l	Bpl2Ptr-V(a6),a1		; load A1 with address of BPL2
	move.l	Bpl3Ptr-V(a6),a2		; load A2 with address of BPL3

	move.l	#20*256,d0
.loop:
	clr.l	(a0)+
	clr.l	(a1)+
	clr.l	(a2)+
	dbf	d0,.loop
.no:
	clr.l	d0
	clr.l	d1
	bsr	SetPosNoSerial
	rts



GetMouse:
	PUSH
	clr.l	d0				; Clear d0..
	move.b	#0,BUTTON-V(a6)			; Clear the generic "Button" variable
	move.b	#0,LMB-V(a6)			; I use move as clr actually does a read first
	move.b	#0,P1LMB-V(a6)
	move.b	#0,P2LMB-V(a6)
	move.b	#0,RMB-V(a6)
	move.b	#0,P1RMB-V(a6)
	move.b	#0,P2RMB-V(a6)
	move.b	#0,MBUTTON-V(a6)		; Clear the generic "Mbutton" variable
	clr.l	d1
	bsr	GetMouseData
	move.l	d0,InputRegister-V(a6)
	POP
	move.l	InputRegister-V(a6),d0
	rts


ClearInput:

	move.w	#0,CurAddX-V(a6)
	move.w	#0,CurSubX-V(a6)
	move.w	#0,CurAddY-V(a6)
	move.w	#0,CurSubY-V(a6)
	move.b	#0,MOUSE-V(a6)
	move.b	#0,BUTTON-V(a6)			; Clear the generic "Button" variable
	move.b	#0,LMB-V(a6)			; I use move as clr actually does a read first
	move.b	#0,P1LMB-V(a6)
	move.b	#0,P2LMB-V(a6)
	move.b	#0,RMB-V(a6)
	move.b	#0,P1RMB-V(a6)
	move.b	#0,P2RMB-V(a6)
	move.b	#0,key-V(a6)
	move.b	#0,Serial-V(a6)
	move.b	#0,GetCharData-V(a6)
	move.b	#0,MBUTTON-V(a6)
	rts

Random:						;  out: d0 will contain a "random" number
	add.l	d3,d0
	add.l	d4,d0
	add.b	$dff006,d0
	add.l	d1,d0
	swap	d0
	add.b	$dff007,d0
	add.l	d2,d0
	add.l	d5,d0
	add.l	d6,d0
	add.l	d7,d0
	rts
	


GetInput:
						; Check inputsignals and return actions.
						; in: none
						; out: d0 - messageflags.
						;	bits:
						;		0 = Mouse moved
						;		1 = Mouse button
						;		2 = Keyboard action happened
						;		3 = Serial action happened

	PUSH

	clr.l	d0				; Clear d0..

	bsr	ClearInput
	clr.l	d1

	clr.l	d0

	bsr	GetMouseData

	move.l	d0,d1
	cmp.b	#0,DISPAULA-V(a6)
	bne	.paulabad
	bsr	GetCharSerial
	cmp.b	#0,d0
	beq	.noserial
.paulabad:
	move.b	d0,GetCharData-V(a6)
	move.b	#1,BUTTON-V(a6)
	move.l	d1,d0
	bset	#3,d1

.noserial:

	move.l	d1,d0


.getkey:
	move.l	d0,d1
	cmp.b	#1,OVLErr-V(a6)			; If we had OVL error, CIA is most likly broke. ignore keyboard
	beq	.noovl
	bsr	GetCharKey
.noovl:
	cmp	#0,d0
	beq	.nokey

	move.b	#1,BUTTON-V(a6)

	move.b	d0,GetCharData-V(a6)
	move.l	d1,d0
	bset	#2,d0
	bra	.exit

.nokey:
	move.l	d1,d0	


	
.exit:
	move.l	d0,InputRegister-V(a6)
	POP
	move.l	InputRegister-V(a6),d0
	rts

GetSerial:					; Reads serialport and returns first char in buffer.
	cmp.w	#0,SerialSpeed-V(a6)		; if serialport is disabled.  skip all serial stuff
	beq	.exit
	cmp.w	#5,SerialSpeed-V(a6)
	beq	.exit
	move.b	#0,SerData-V(a6)
	bsr	ReadSerial
	cmp.b	#0,SerBufLen-V(a6)		; Check if we have a serialbuffer, if not, just exit
	beq	.exit
						; OK, we do have a serialbuffer, so return first char in buffer
	clr.l	d6
	move.b	SerBufLen-V(a6),d6
	lea	SerBuf-V(a6),a5
	move.b	(a5),Serial-V(a6)		; Read char in the buffer and put it to "Serial" that is the output variable
	PUSH
	move.l	#$fe,d6
.loop:
	move.b	1(a5),(a5)+
	dbf	d6,.loop
	sub.b	#1,SerBufLen-V(a6)
	move.b	#0,(a5)				; Clear the last byte in the buffer
	POP
	bset	#3,d0				; Mark that we had a serialevent
	rts
.exit:
	rts

ReadSerial:					; Read serialport, and if anything there store it in the buffer
	cmp.w	#0,SerialSpeed-V(a6)		; is serialport is disabled.  skip all serial stuff
	beq	.exit
	cmp.w	#5,SerialSpeed-V(a6)
	beq	.exit

	move.w	$dff018,d5
		ifeq	debug
		endc
	move.b	OldSerial-V(a6),d6
	cmp.b	d5,d6				; is there a change from last scan?
	bne	.serial				; yes. so. well handle it as a new char.
	btst	#14,d5				; Buffer full, we have a new char
	beq	.exit

.serial:
	move.b	#1,SerData-V(a6)
	move.b	d5,OldSerial-V(a6)
	move.w	#$0800,$dff09c			; Turn off RBF bit
	move.w	#$0800,$dff09c
	move.b	#1,BUTTON-V(a6)

	clr.l	d6
	move.b	SerBufLen-V(a6),d6
	add.b	#1,SerBufLen-V(a6)
	lea	SerBuf-V(a6),a5
	move.b	d5,(a5,d6)
.exit:
	rts

ClearBuffer:
	
	move.l	#20,d7
.loop
	bsr	GetInput
	dbf	d7,.loop
	clr.b	SerBufLen-V(a6)
	bsr	ClearInput
	move.b	#0,SerBufLen-V(a6)		; Check if we have a serialbuffer, if not, just exit

	rts
	



GetMouseData:
						; Get data from mouse.. ANY port.
	move.w	$dff016,d1			; Read POTINP to d1
	and.w	#$fe,d1				; mask out bit 0
	cmp.b	#0,d1				; ok  if d1 is 0 we should have a working paula as bit 1-7 always shold be 0
						; but a bad paula can give random numbers. so DiagROM messes up presses etc.
						; so DISABLE all paulachecks.
	beq	.paulaok
	move.b	#1,DISPAULA-V(a6)		; ok it was not 0.  so lets disable paulastuff

.paulaok:
	cmp.b	#0,DISPAULA-V(a6)
	bne	.paulabad
	;First handle Y position
	bsr	.CheckButton
	move.l	d0,d4				; Store d0 in d4 temporary

	move.b	$dff00a,d2
	move.b	OldMouse1Y-V(a6),d1
	cmp.b	d1,d2				; Check to old Y pos at mouse 1. if differs, mouse is moved.
	bne	.Mouse1YMove
.Check2Y:
	move.b	$dff00c,d2
	move.b	OldMouse2Y-V(a6),d1
	cmp.b	d1,d2
	bne	.Mouse2YMove
.CheckX:
	move.b	$dff00b,d2
	move.b	OldMouse1X-V(a6),d1
	cmp.b	d1,d2
	bne.w	.Mouse1XMove
.Check2X:
	move.b	$dff00d,d2
	move.b	OldMouse2X-V(a6),d1
	cmp.b	d1,d2
	bne.w	.Mouse2XMove


						; ok now we have a raw "mouse" data from either port.
						; but maybe time to convert it to a real X, Y cursor instead.
						; that goes between 0 and 640 on X, and 0 and 512 on Y.

	clr.l	d0
	clr.l	d1
	move.b	MouseX-V(a6),d0			; Store X pos in d0
	move.b	OldMouseX-V(a6),d1		; Store old X pos value in d1
	cmp.b	d1,d0				; Compare them to check if we have mousemovement
	bne	.XMove				; We have mousemovements in the X Axis

.CheckY:
	clr.l	d0
	clr.l	d1
	move.b	MouseY-V(a6),d0			; Store Y pos in d0
	move.b	OldMouseY-V(a6),d1		; Store old Y pos value in d1
	cmp.b	d1,d0				; Compare them to check if we have mousemovement
	bne	.YMove				; We have mousemovements in the Y Axis
.DoneM:
	move.l	d4,d0				; Restore d0 to keep flags
.paulabad:
	rts

.XMove:
	bset	#0,d4				; Set flag that we have mousemovements, d4 is temporary
	move.b	#1,MOUSE-V(a6)
	move.b	d0,OldMouseX-V(a6)		; Store current to old.
						; OK , we have a movement, but what direction?
	bsr	.GetMouseDir
	cmp.b	#1,d1				; Check what direction
	beq	.backX
	add.w	d0,CurX-V(a6)
	move.w	d0,CurAddX-V(a6)
	cmp.w	#640,CurX-V(a6)
	bge	.highX
	bra	.DoneX
.highX:
	move	#640,CurX-V(a6)
	bra	.DoneX

.backX:
	sub.w	d0,CurX-V(a6)
	move.w	d0,CurSubX-V(a6)
	cmp.w	#0,CurX-V(a6)
	blt	.MaxX
	bra	.DoneX
.MaxX:
	move.w	#0,CurX-V(a6)
	bra	.DoneX
.DoneX:
	bra	.CheckY


.YMove:
	bset	#0,d4				; Set flag that we have mousemovements, d4 is temporary
	move.b	#1,MOUSE-V(a6)
	move.b	d0,OldMouseY-V(a6)		; Store current to old.
						; OK , we have a movement, but what direction?
	bsr	.GetMouseDir
	cmp.b	#1,d1				; Check what direction
	beq	.backY
	add.w	d0,CurY-V(a6)
	move.w	d0,CurAddY-V(a6)
	cmp.w	#512,CurY-V(a6)
	bge	.highY
	bra	.DoneY
.highY:
	move	#512,CurY-V(a6)
	bra	.DoneY

.backY:
	move.w	d0,CurSubY-V(a6)
	sub.w	d0,CurY-V(a6)
	cmp.w	#0,CurY-V(a6)
	blt	.MaxY
	bra	.DoneY
.MaxY:
	move.w	#0,CurY-V(a6)
	bra	.DoneY
.DoneY:
	bra	.DoneM



.GetMouseDir:
						; INDATA:
						;	D0 = Old pos
						;	D1 = New pos
						; OUTDATA:
						;	D0 = Number of steps
						;	D1 = if 0 = "backwards"

	move.l	d0,d2
	move.l	d1,d3				; Store values

	cmp.b	d0,d1				; Check what direction mousemovement is
	blt	.Lower				; ok we have a lower value
	sub.b	d0,d1				; Calculate how big the movement was.
	move.l	d1,d0				; put it in d0
	move.b	#1,d1				; Mark as "forward" movement

	cmp.w	#128,d0				; Check if we had a BIG movement.
	bge	.highadd			; yes.  so it must be the OPPOSITE direction instead
	rts

.highadd:
	move.b	#255,d1
	sub.b	d1,d0
	clr.b	d1
	rts	

.Lower:
	sub.b	d1,d0
	clr.l	d1				; Mark as "backward"
	cmp.w	#128,d0
	bge	.highsub
	rts	
.highsub:
	move.b	#255,d1
	sub.b	d1,d0
	move.b	#1,d1
	rts




.Mouse2XMove:
	move.b	d2,OldMouse2X-V(a6)
	sub.b	d2,d1
	sub.b	d1,MouseX-V(a6)
	bset	#0,d0
	bra	.CheckButton
	
.Mouse1XMove:
	move.b	d2,OldMouse1X-V(a6)
	sub.b	d2,d1
	sub.b	d1,MouseX-V(a6)
	bset	#0,d0
	bra	.Check2X
.Mouse1YMove:
	move.b	d2,OldMouse1Y-V(a6)
	sub.b	d2,d1				; Get delta from old value
	sub.b	d1,MouseY-V(a6)
	bset	#0,d0
	bra	.Check2Y
.Mouse2YMove:
	move.b	d2,OldMouse2Y-V(a6)
	sub.b	d2,d1
	sub.b	d1,MouseY-V(a6)
	bset	#0,d0
	bra	.CheckX	


.CheckButton:					; X and Y are now checked, lets check the buttons.
	cmp.b	#0,STUCKP1LMB-V(a6)		; Check if button was marked as stuck, if so. skip it
	bne	.nolmb1
	btst	#6,$bfe001			; Check LMB
	beq	.P1LMB
.nolmb1:
	cmp.b	#0,STUCKP2LMB-V(a6)
	bne	.CheckRight
	btst	#7,$bfe001
	beq	.P2LMB
.CheckRight:
	cmp.b	#0,STUCKP1RMB-V(a6)
	bne	.normb1
	btst	#10,$dff016			; Check RMB port 1
	beq	.P1RMB
.normb1:
	cmp.b	#0,STUCKP2RMB-V(a6)
	bne	.CheckMiddle
	btst	#14,$dff016			; Check RMB port 2
	beq	.P2RMB

.CheckMiddle
	cmp.b	#0,STUCKP1MMB-V(a6)
	bne	.nommb1
	btst	#8,$dff016			; Check MMB
	beq	.MMB
.nommb1:
	cmp.b	#0,STUCKP2MMB-V(a6)
	bne	.Done
	btst	#12,$dff016
	beq	.MMB
.Done:
	rts	

.P1LMB:
	move.b	#1,P1LMB-V(a6)
	bra	.LMB
.P2LMB:
	move.b	#1,P2LMB-V(a6)
.LMB:
	move.b	#1,BUTTON-V(a6)
	move.b	#1,MBUTTON-V(a6)
	move.b	#1,LMB-V(a6)			; Mark LMB as pressed
	bset	#1,d0
	bra	.CheckRight
.P1RMB:
	move.b	#1,P1RMB-V(a6)
	bra	.RMB
.P2RMB:
	move.b	#1,P2RMB-V(a6)
.RMB:
	move.b	#1,MBUTTON-V(a6)
	move.b	#1,BUTTON-V(a6)
	move.b	#1,RMB-V(a6)
	bset	#1,d0
	rts
.MMB:
	move.b	#1,MBUTTON-V(a6)
	move.b	#1,BUTTON-V(a6)
	move.b	#1,MMB-V(a6)
	bset	#1,d0
	rts

GetChar:					; Reads keyboard and serialport and returns the value in D0
	bsr	GetCharKey
	cmp.b	#0,d0
	bne	.noserial
	bsr	GetCharSerial
.noserial:
	move.b	d0,GetCharData-V(a6)
	rts

GetCharKey:
						; Keyboard have priority

	PUSH
	move.b	#0,keyresult-V(a6)
	bsr	GetKey				; Read keyboard
	cmp.b	#1,keynew-V(a6)			; Did we have a new keypress on the keyboard?
	bne	.no				; no, do serialstuff instead

	lea	keymap-V(a6),a0
	move.l	(a0),a0				; Set wanted keymap.
	bsr	ConvertKey			; Convert keyscan to actual ASCII

	cmp.b	#0,skipnextkey-V(a6)		; Check if skipnextkey is set
	bne	.skipnextkey

.no:
	POP
	clr.l	d0
	move.b	keyresult-V(a6),d0
	rts

.skipnextkey:					; ok we are instructed to simply skip this keypress.
	move.b	#0,BUTTON-V(a6)
	move.b	#0,keyresult-V(a6)
	move.b	#0,skipnextkey-V(a6)
	beq	.no


GetCharSerial:
	PUSH
	clr.b	Serial-V(a6)
	bsr	GetSerial			; Read Serialport
	
	cmp.b	#1,SerAnsiFlag-V(a6)		; Are we in ANSI mode?
	beq	.ansimode

	POP
	clr.l	d0
	move.b	Serial-V(a6),d0			; Return what was in serial, if nothing it will be 0 (nothing happend)
	cmp.b	#$1b,d0				; is it ESC? if so. we might be in ANSI mode.
	beq	.ansion
	cmp.b	#$d,d0				; is it a linefeed?
	bne	.nolf
	move.b	#$a,d0				; convert it to CR
.nolf:
	rts
.ansion:
	move.b	#1,SerAnsiFlag-V(a6)		; Set flag that we are in ANSImode
	move.w	#0,SerAnsiChecks-V(a6)		; Clear ansicheck variable

	move.b	#0,d0				; return that nothing was recieved
	move.b	d0,Serial-V(a6)
	rts

.ansimode:
	
	move.b	Serial-V(a6),d0			; Load the serialdata to d0
	clr.l	d1				; clear d1 to make sure we do not get crapdata
	cmp.b	#0,d0				; did we get a 0 from serialport?
	beq	.sernull			; if so.. handle it
	cmp.b	#$1b,d0
	beq	.sernull

	cmp.b	#32,d0				; Strip away all nonascii chars
	blt	.noascii

	cmp.b	#1,SerAnsi35Flag-V(a6)
	beq	.ansimode35on
	cmp.b	#1,SerAnsi36Flag-V(a6)
	beq	.ansimode36on

	cmp.b	#$38,d0
	beq	.pgup

	cmp.b	#$36,d0
	beq	.pgdown

	cmp.b	#$41,d0				;UP
	beq	.up
	cmp.b	#$42,d0				;DOWN
	beq	.down
	cmp.b	#$43,d0				;RIGHT
	beq	.right
	cmp.b	#$44,d0				;LEFT
	beq	.left

	cmp.b	#$36,d0				;possible pgdwn
	beq	.ansimode36

	cmp.b	#$35,d0
	beq	.ansimode35			;possible pgup

.noascii:
	clr.b	d0
	bra	.ansiexit
.ansichar
	move.b	#0,SerAnsiFlag-V(a6)
	bra	.ansiexit

.ansimode35:
	move.b	#1,SerAnsi35Flag-V(a6)
	bra	.ansiexit

.ansimode36:
	move.b	#1,SerAnsi36Flag-V(a6)
	bra	.ansiexit

.ansimode35on:
	clr.b	SerAnsi35Flag-V(a6)
	cmp.b	#$7e,d0				; we have pgup
	beq	.pgup
	clr.b	SerAnsiFlag-V(a6)
	rts

.ansimode36on:
	clr.b	SerAnsi36Flag-V(a6)
	cmp.b	#$7e,d0				; we have pgdown
	beq	.pgdown
	clr.b	SerAnsiFlag-V(a6)
	rts
	
.pgup:
	clr.b	SerAnsiFlag-V(a6)
	move.b	#1,skipnextkey-V(a6)
	move.l	#1,d0
	bra	.ansiexit


.pgdown:
	clr.b	SerAnsiFlag-V(a6)
	move.b	#1,skipnextkey-V(a6)
	move.l	#2,d0
	bra	.ansiexit


.up:
	clr.b	SerAnsiFlag-V(a6)
	move.l	#30,d0
	bra	.ansiexit
.down:
	clr.b	SerAnsiFlag-V(a6)
	move.l	#31,d0
	bra	.ansiexit
.right:
	clr.b	SerAnsiFlag-V(a6)
	move.l	#28,d0
	bra	.ansiexit
.left:
	clr.b	SerAnsiFlag-V(a6)
	move.l	#29,d0
	bra	.ansiexit
.exitchar:
	POP
	clr.l	d0
	rts
	
.nochar:
	move.b	#$1b,d0
	move.b	#0,SerAnsiFlag-V(a6)

.ansiexit:
	move.b 	d0,Serial-V(a6)
.ansidone:
	POP
	clr.l	d0
	move.b	Serial-V(a6),d0			; Return what was in serial, if nothing it will be 0 (nothing happend)
	rts

.sernull:
	clr.b	d0				; OK we had a binary 0 as result
	add.w	#1,SerAnsiChecks-V(a6)		; add number of times we run through this
	cmp.w	#$f,SerAnsiChecks-V(a6)		; is it max?
	bne	.ansiexit			; if not. just exit with 0
	TOGGLEPWRLED
	move.w	#0,SerAnsiChecks-V(a6)		; ok we had too many checks. guess nothing happened. so exit with an ESC.
	bra	.nochar		
	

ConvertKey:					; Converts keystroke to char.
							; INDATA:
						; a0=pointer to keymap
	move.b	(a0,d0),d1
	move.b	d1,keypressed-V(a6)
	move.b	d1,keyresult-V(a6)
	move.b	EnglishKeyShifted-EnglishKey(a0,d0),d1
	move.b	d1,keypressedshifted-V(a6)
	cmp.b	#0,keyshift-V(a6)
	beq	.notshift
	move.b	d1,keyresult-V(a6)
.notshift:
	rts	

GetKey:			
	PUSH					; Read keyboard
	move.b	#$88,$bfed01
	bsr	WaitShort
	bsr	WaitShort
	bsr	WaitShort
	clr.b	keynew-V(a6)			; Clear keynew variable, will be set if we have a new keypress
	clr.b	keyup-V(a6)
	clr.b	keydown-V(a6)
	move.b	$bfec01,d0			; Read keyboard
	move.b	d0,scancode-V(a6)		; Store the original scancode
	ror.b	#1,d0
	not.b	d0
	
	move.b	d0,key-V(a6)			; after rotates etc, store the keycode
	btst	#7,d0				; Test if key is up or down
	beq	.down
	move.b	#1,keyup-V(a6)			; Set that a key was released
	clr.b	keystatus-V(a6)
	bra	.nokey				; Somewhat wrong label.. :)
.down:	
	move.b	#1,keydown-V(a6)		; Set that a key was pressed
	move.b	#1,keystatus-V(a6)
	move.b	#1,keynew-V(a6)

.nokey:
	bset	#6,$bfee01			; Set handshakebit
	sf.b	$bfec01				; Clear keyboardbuffer
	bsr	WaitShort			; Wait a short while
	Bsr	WaitShort
	bsr	WaitShort
	bsr	WaitShort
	bclr	#6,$bfee01			; Clear the handshakebit

						; OK.  we have read the buffer and also cleared it. Lets handle it.

	bclr	#7,d0				; We clear the up/down bit, so we know what key we handled

	cmp.b	#$60,d0
	beq	.shift
	cmp.b	#$61,d0
	beq	.shift
	cmp.b	#$62,d0
	beq	.capsshift			; Now we have handled shift


	cmp.b	#$64,d0
	beq	.alt
	cmp.b	#$65,d0
	beq	.alt				; Now we have handled alt

	cmp.b	#$63,d0
	beq	.ctrl
	cmp.b	#$67,d0
	beq	.ctrl				; Now we have handled ctrl

.keydone:
	POP
	move.b	key-V(a6),d0
	rts

.alt:
	move.b	keystatus-V(a6),keyalt-V(a6)
	move.b	#0,key-V(a6)
	bra	.keydone

.ctrl:
	move.b	keystatus-V(a6),keyctrl-V(a6)
	move.b	#0,key-V(a6)
	bra	.keydone

.shift:						; we have a happening on the SHIFT key
	cmp.b	#0,keycaps-V(a6)		; Check if caps is pressed
	bne	.caps
	move.b	#0,key-V(a6)
	move.b	keystatus-V(a6),keyshift-V(a6)
.caps:
	bra	.keydone
.capsshift:
	move.b	keystatus-V(a6),keycaps-V(a6)
	move.b	keystatus-V(a6),keyshift-V(a6)
	move.b	#0,key-V(a6)
	bra	.keydone


GetHex:						; Takes an ASCII and returns only valid chars for hex. (and backspace/enter)

						; Input:
						;	D0 = Char

						; Output:
						; 	D0 = Char
	cmp.b	#"0",d0
	blt	.nonumber
	cmp.b	#"9",d0
	bgt	.nonumber
	rts

.nonumber:
	bclr	#5,d0				; Make it uppercase
	cmp.b	#"A",d0
	blt	.nochar
	cmp.b	#"F",d0
	bgt	.nochar
	rts
.nochar:
	cmp.b	#8,d0
	bne	.nobackspace
	rts
.nobackspace:
	cmp.b	#$d,d0
	bne	.checkenter
						; we had linefeed? convert to an enter :)
	move.b	#$a,d0
.checkenter:
	cmp.b	#$a,d0
	bne	.noenter
	rts
.noenter:
	cmp.b	#27,d0
	bne	.noesc
	rts
.noesc:
	move.b	#0,d0
	rts
	

GetDec:						; Takes an ASCII and returns only valid chars for dec. (and backspace/enter)

						; Input:
						;	D0 = Char

						; Output:
						; 	D0 = Char
	cmp.b	#"0",d0
	blt	.nonumber
	cmp.b	#"9",d0
	bgt	.nonumber
	rts

.nonumber:
	cmp.b	#8,d0
	bne	.nobackspace
	rts
.nobackspace:
	cmp.b	#$d,d0
	bne	.checkenter
						; we had linefeed? convert to an enter :)
	move.b	#$a,d0
.checkenter:
	cmp.b	#$a,d0
	bne	.noenter
	rts
.noenter:
	cmp.b	#27,d0
	bne	.noesc
	rts
.noesc:
	move.b	#0,d0
	rts
	


FixBitplane:
; Set bitplanes in copperlist
;
; Indata
;
;	A0 = bitplanespointers in copper
;	A1 = List to bitplane pointers, 0 = End of list
;

	move.l	(a1)+,d0
	cmp.l	#0,d0
	beq.s	.Slut

	move.w	d0,6(a0)
	swap	d0
	move.w	d0,2(a0)
	add.l	#8,a0
	bra.s	FixBitplane
.Slut:
	rts


CopyToChip:					; Copy data that needs to be in Chipmem from ROM for menusystem etc.


	lea	ChipSetup1,a0
	bsr	SendSerial

	move.l	#0,DummySprite-V(a6)		; Just make sure sprite i empty

	lea	ChipSetup2,a0
	bsr	SendSerial


	lea	RomMenuCopper,a0
	move.l	a6,a1
	add.l	#MenuCopper-V,a1
	move.l	#EndRomMenuCopper-RomMenuCopper,d0
	bsr	CopyMem				; Copy the font to chipmem

	lea	ChipSetup3,a0
	bsr	SendSerial


	lea	RomEcsCopper,a0
	move.l	a6,a1
	add.l	#ECSCopper-V,a1
	move.l	#EndRomEcsCopper-RomEcsCopper,d0
	bsr	CopyMem

	lea	ChipSetup4,a0
	bsr	SendSerial


	lea	RomEcsCopper2,a0
	move.l	a6,a1
	add.l	#ECSCopper2-V,a1
	move.l	#EndRomEcsCopper2-RomEcsCopper2,d0
	bsr	CopyMem

	lea	ChipSetup5,a0
	bsr	SendSerial


	lea.l	MenuCopper-V(a6),a0
ClearSprite:
	move.w	#7,d0
	move.l	a6,d1
	add.l	#DummySprite-V,d1
.ClearS:
	swap	d1
	move.w	d1,2(a0)

	swap	d1
	move.w	d1,6(a0)

	add.l	#8,a0
	dbf	d0,.ClearS			; A empty dummysprite is now defined
	

	lea	ChipSetup6,a0
	bsr	SendSerial


	lea	ROMAudioWaves,a0
	move.l	a6,a1
	add.l	#AudioWaves-V,a1
	move.l	#EndROMAudioWaves-ROMAudioWaves,d0
	bsr	CopyMem				; Copy the font to chipmem


	ifeq	a1k
	lea	MT_Init,a0
	move.l	a6,a1
	add.l	#ptplay-V,a1
	move.l	#mt_END-MT_Init,d0
	bsr	CopyMem				; Copy the protracker replayroutine to mem

	move.l	a6,d0
	add.l	#ptplay-V,d0			; d0 now contains first address of where replayroutine is in memory
	move.l	d0,AudioModInit-V(a6)
	move.l	d0,d2				; Make a backup of it

	add.l	#MT_End-MT_Init,d0		; Add where MR_End is to a1 so we can store it aswell
	move.l	d0,AudioModEnd-V(a6)		; Store it for future use
	move.l	d2,d0				; Restore a1
	
	add.l	#MT_Music-MT_Init,d0		; Add where MR_Music is to a1 so we can store it aswell
	move.l	d0,AudioModMusic-V(a6)		; Store it

	move.l	d2,d0
	add.l	#mt_MasterVol-MT_Init,d0
	move.l	d0,AudioModMVol-V(a6)
	endc
	
	rts
	

CopyMem:
						; Copy one block memory to another
						; INDATA:
						;	A0 = Source
						;	D0 = Bytes to copy. (YES. being lazy, we do this bytestyle)
						;	A1 = Destination
	clr.l	d7
.loop:
	move.b	(a0)+,(a1)+
	add.l	#1,d7
	cmp.l	d7,d0
	bgt	.loop				; YES a DBF would do just fine. but i want to support more then 64k
	rts


Init_Serial:
	cmp.b	#1,NoSerial-V(a6)
	beq	.noser
	move.w	#$4000,$dff09a
	clr.l	d0
	move.w	SerialSpeed-V(a6),d0		; Get serialspeed
	mulu	#4,d0				; Multiply with 4 to get correct address
	lea	SerSpeeds,a0
	move.l	(a0,d0),d0			; Load d0 with the value to write to the register for the correct speed.
	move.w	d0,$dff032			; Set the speed of the serialport
	move.b	#$4f,$bfd000			; Set DTR high
	move.w	#$0801,$dff09a
	move.w	#$0801,$dff09c
.noser:
	rts
	

Clean_Serial:
	move.w	#$c000,$dff09a

rs232_out:	
	cmp.w	#0,SerialSpeed-V(a6)
	beq	.noserial
	cmp.w	#5,SerialSpeed-V(a6)
	beq	.noserial
	cmp.b	#1,NoSerial-V(a6)
	beq	.noserial
	PUSH
	bsr	ReadSerial
	move.l	#$90000,d2			; Load d2 with a timeoutvariable. only test this number of times.
						; IF CIA for serialport is dead we will not end up in a wait-forever-loop.
						; and as we cannot use timers. we have to do this dirty style of coding...
.loop:	
	move.b	$bfe001,d1			; just read crapdata, we do not care but reading from CIA is slow... for timeout stuff only
	sub.l	#1,d2				; count down timeout value
	cmp.l	#0,d2				; if 0, timeout.
	beq	.endloop

	move.w	$dff018,d1
	btst	#13,d1				; Check TBE bit
	beq.s	.loop
.endloop:
	move.w	#$0100,d1
	move.b	d0,d1
	move.w	d1,$dff030			; send it to serial
	move.w	#$0001,$dff09c			; turn off the TBE bit
	POP
.noserial:
	rts


PutChar:

	PUSH					; Puts a char on the screen.
						; INDATA: (expects longwords)
						; D0 = Char (IF color above 8, it gets reversed in that color - 8)
						; D1 = Color
						; D2 = XPos
						; D3 = YPos

	cmp.b	#1,d0				; Nonprinted char?
	beq	.noprint					

	cmp.b	#0,NoDraw-V(a6)			; Check if we should draw
	bne	.exit

	move.l	d0,d5
	sub.b	#32,d0				; Subtract 32 from the char as " " is the first char in the Font.
	clr.l	d4				; if d4 if 0. no invert of char
	cmp.b	#8,d1
	blt	.Normal				; Normal color. do not invert
	move.b	#1,d4
	sub.b	#8,d1
.Normal:

	mulu	#640,d3				; Multiply Y with 640 to get a correct Y pos on screen
	add.w	d2,d3				; Add�X pos to the d3. D3 now contains how much to add to bitplane to print

	move.l	Bpl1Ptr-V(a6),a0		; load A0 with address of BPL1
	move.l	Bpl2Ptr-V(a6),a1		; load A1 with address of BPL2
	move.l	Bpl3Ptr-V(a6),a2		; load A2 with address of BPL3
	lea	RomFont,a3

	add.l	d3,a0
	add.l	d3,a1
	add.l	d3,a2				; Add the value to the screen bitplane addresses

	mulu	#8,d0
	add.l	d0,a3
	
	cmp.b	#0,NoChar-V(a6)			; Check if we should print
	bne	.no				; nonzero. do not print


	move.l	#7,d0
.loop:
	move.b	(a3)+,d2

	cmp.b	#1,d4				; IF D4 is 1, invert char
	bne.s	.noinvert
	eor	#$ff,d2
.noinvert:
	clr.b	(a0)
	clr.b	(a1)
	clr.b	(a2)				; To be sure. delete anything
	btst	#0,d1				; Check what bitplane to print on
	beq.w	.nopl1
	move.b	d2,(a0)
.nopl1:
	btst	#1,d1
	beq.s	.nopl2
	move.b	d2,(a1)
.nopl2:
	btst	#2,d1
	beq.s	.nopl3
	move.b	d2,(a2)
.nopl3:
	add.l	#80,a0
	add.l	#80,a1
	add.l	#80,a2
	dbf	d0,.loop			; put char on the screen
.no:
	move.l	d5,d0
.exitwithserial:
	bsr	rs232_out
	POP
	rts


.noprint:
	move.l	#" ",d0
	bsr	rs232_out
	POP
	rts
.exit:
	TOGGLEPWRLED				; As we cannot put any chars on screen. flicker the powerled so user MIGHT
						; notice something is happening. as DMA etc are out. we cannot rely on colors etc.
	move.b	d3,$dff180			; but. just for the "fun" of it. push some random crap on background colotr
	move.b	d0,$dff181
	bra	.exitwithserial

SameRow:
						; Changes so we print on the same row. just clears the X column
	PUSH
	clr.b	Xpos-V(a6)
	move.b	#$d,d0
	bsr	rs232_out
	POP
	rts


PrintChar:					; Puts a char on screen and add X, Y variables depending on char etc.
						; INDATA: (Longwords expected)
						;	D0 = Char
						;	D1 = Color
	PUSH
	cmp.b	#1,d0				; check if char is $1
	beq	.Noprint			; then it is a nonprinted char
	cmp.b	#$d,d0
	beq	.ignore

	clr.l	d7
	move.b	d0,d7
	move.l	d1,d6
	move.l	d1,d0
	cmp.b	Color-V(a6),d0




	beq	.samecol			; if it is the same color as last time.. do nothing special
	move.b	d0,Color-V(a6)

						; ok we have a new color, change it to serialport
	cmp.b	#8,d0
	blt	.noinvert



	move.b	#1,Inverted-V(a6)		; set the inverted-flag

	lea	Black,a0
	bsr	SendSerial
	sub.l	#8,d1

	lea	Ansi,a0
	bsr	SendSerial			; Send ANSI esc code.
	move.b	#"4",d0
	bsr	rs232_out
	move.b	d1,d0
	bsr	oldbindec
	bsr	SendSerial
	move.l	#"m",d0
	bsr	rs232_out
	bra	.samecol

.noinvert:

	cmp.b	#0,Inverted-V(a6)		; Check if the invertedflag is 0
	beq	.notinverted			; it was 0, last char printed was not inverted

						; last char WAS inverted. we must clear it on the serialport.
	lea	AnsiNull,a0
	bsr	SendSerial			; Send the string to serialport that clears inverted.
	clr.b	Inverted-V(a6)			; clear the invertedflag aswell


.notinverted:

	lea	Ansi,a0
	bsr	SendSerial			; Send ANSI esc code.
	move.b	#"3",d0

	bsr	rs232_out
	move.b	d1,d0
	bsr	oldbindec


	bsr	SendSerial
	move.l	#"m",d0
	bsr	rs232_out
	
.samecol:
	move.l	d6,d1
	move.l	d7,d0
	move.l	#0,d2
	move.l	#0,d3

	cmp.b	#$a,d0				; IF char is $a, new line
	beq.s	.NewLine
	cmp.b	#$d,d0				; IF Char is $d, put cursor to the left
	bne.s	.No
	clr.b	Xpos-V(a6)


	PUSH
	move.b	#"A",d0
	bsr	rs232_out
	POP
.No:
	clr.l	d2
	clr.l	d3				; Clear d2 and d3 so it is all clear before printing the char
.Noprint:
	move.b	Xpos-V(a6),d2
	move.b	Ypos-V(a6),d3			; Take current X and Y positions to d2 and d3 as argument to PutChar
	bsr	PutChar				; Print the char on screen
	add.b	#1,Xpos-V(a6)			; Add one to the Xpos
	cmp.b	#79,Xpos-V(a6)			; check if we have hit the border
	bgt	.NewLine			; we have hit the border. put it on a new line instead.
.ignore:
	POP
	rts

.NewLine:
	clr.b	Xpos-V(a6)			; Put X pos to the left
	add.b	#1,Ypos-V(a6)			; Add Y pos
	PUSH
	move.l	#$a,d0
	bsr	rs232_out
	move.l	#$d,d0
	bsr	rs232_out
	POP
	cmp.b	#31,Ypos-V(a6)			; Hit the border?
	bgt	.EndOfPage			; ohyes.
	POP
	rts
.EndOfPage:
	bsr	ScrollScreen
	clr.b	Xpos-V(a6)
	sub.b	#1,Ypos-V(a6)
	POP
	rts

MakePrintable:
						; Makes the char in D0 printable. remove controlchars etc.
	cmp.b	#" ",d0
	ble	.lessthenspace			; is less then space.. make it space.
	rts
.lessthenspace:
	move.b	#" ",d0
	rts

StrLen:
						; Returns length of string
						; IN:
						;	A0 = Pointer to nullterminated string
						; OUT:
						;	D0 = Length of string
	PUSH
	clr.l	d0				; Clear d0
.loop:
	move.b	(a0)+,d7			; Load d7 with char
	cmp.b	#0,d7
	beq	.exit				; Exit if we found a null
	cmp.b	#2,d7				; if centercommand, skip char
	beq	.skip
	add.l	#1,d0				; add 1 to stringlength
.skip:
	bra	.loop
.exit:
	move.l	d0,temp-V(a6)			; Store length in temp. as we will restore all registers
	POP
	move.l	temp-V(a6),d0			; So back to D0 again
	rts
	


