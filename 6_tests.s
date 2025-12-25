AudioMenu:
	bsr	InitScreen
	move.w	#2,MenuNumber-V(a6)
	move.b	#1,PrintMenuFlag-V(a6)
	bra	MainLoop

AudioSimple:
FAN:
	bsr	ClearScreen
	move.w	#0,MenuNumber-V(a6)
	move.b	#1,PrintMenuFlag-V(a6)
	move.l	#AudioSimpleMenu,Menu-V(a6)	; Set different menu

						;	OK we have variables to handle here
	move.l	a6,d0
	lea	AudSimpChan1-V(a6),a0

	add.l	#AudSimpVar-V,d0
	move.l	d0,MenuVariable-V(a6)

						; ok lets populate this with default values.
	move.b	#0,(a0)+
	move.b	#0,(a0)+
	move.b	#0,(a0)+
	move.b	#0,(a0)+
	move.b	#64,(a0)+
	move.b	#12,(a0)+
	move.b	#1,(a0)+
	move.b	#0,(a0)+

	bsr	.setvar

.loop:
	bsr	.Playaudio

	bsr	PrintMenu
	bsr	GetInput
	bsr	WaitLong
	cmp.b	#0,d0
	beq	.no


	move.b	keyresult-V(a6),d1		; Read value from last keyboardread
	cmp.b	#$a,d1				; if it was enter, select this item
	beq	.action
	move.b	Serial-V(a6),d2			; Read value from last serialread
	cmp.b	#$a,d2
	beq	.action
	cmp.b	#1,LMB-V(a6)
	beq	.action
	cmp.b	#1,RMB-V(a6)
	beq	.action
	
	lea	AudioSimpleWaveKeys,a5		; Load list of keys in menu
	clr.l	d0				; Clear d0, this is selected item in list



.keyloop:
	move.b	(a5)+,d3				; Read item
	cmp.b	#0,d3				; Check if end of list
	beq	.nokey
	cmp.b	d1,d3				; fits with keyboardread?
	beq	.goaction
	cmp.b	d2,d3				; fits with serialread?
	beq	.goaction				; if so..  do it
	add.l	#1,d0				; Add one to d0, selecting next item
	bra	.keyloop
.goaction:
	move.b	d0,MenuPos-V(a6)
	bra	.action

.nokey:	
	cmp.b	#1,RMB
	beq	Exit
	btst	#1,d0
	beq	.no

.action:
	clr.l	d0
	move.b	MenuPos-V(a6),d0
	cmp.b	#0,d0
	beq	.chan1
	cmp.b	#1,d0
	beq	.chan2
	cmp.b	#2,d0
	beq	.chan3
	cmp.b	#3,d0
	beq	.chan4
	cmp.b	#4,d0
	beq	.vol
	cmp.b	#5,d0
	beq	.wave
	cmp.b	#6,d0
	beq	.filter
	cmp.b	#7,d0
	beq	.exit

	


.no:
	move.b	MenuPos-V(a6),d0
	cmp.b	#4,d0				; Check if we are on the line for volume
	bne.w	.novol
.volume:
	cmp.b	#0,AudioVolSelect-V(a6)		; Have volume been selected before?
	bne	.yesselected
	move.b	#1,AudioVolSelect-V(a6)
	move.l	#0,d0
	move.l	#22,d1
	bsr	SetPos
	lea	AudioSimpleVolTxt,a0
	move.l	#2,d1
	bsr	Print
.yesselected
	cmp.b	#29,GetCharData-V(a6)
	bne	.noleft
	bsr	.voldown
	move.b	#5,UpdateMenuNumber-V(a6)
	move.b	#2,PrintMenuFlag-V(a6)
	bsr	.setvar
	bra	.volset
.noleft:
	cmp.b	#28,GetCharData-V(a6)
	bne	.volset
	bsr	.volup
	move.b	#5,UpdateMenuNumber-V(a6)
	move.b	#2,PrintMenuFlag-V(a6)
	bsr	.setvar
	bra	.volset


.novol:
	cmp.b	#0,AudioVolSelect-V(a6)		; Have volume been selected before?
	beq	.volset				; if 0, it haven't
	clr.b	AudioVolSelect-V(a6)
	move.l	#0,d0
	move.l	#22,d1
	bsr	SetPos
	lea	EmptyRowTxt,a0
	move.l	#0,d1
	bsr	Print
	
.volset:
	bra	.loop



.setvar:
	move.l	a6,a0
	move.l	a6,a1
	add.l	#AudSimpChan1-V,a0	
	add.l	#AudSimpVar-V,a1

	bsr	CheckOnOff
	move.w	d0,(a1)+			; Write color
	move.l	d1,(a1)+			; Write Stringpointer
	bsr	CheckOnOff
	move.w	d0,(a1)+			; Write color
	move.l	d1,(a1)+			; Write Stringpointer
	bsr	CheckOnOff
	move.w	d0,(a1)+			; Write color
	move.l	d1,(a1)+			; Write Stringpointer
	bsr	CheckOnOff
	move.w	d0,(a1)+			; Write color
	move.l	d1,(a1)+			; Write Stringpointer

	clr.l	d0
	move.b	(a0)+,d0			; Get Volume

	lea	AudSimpVolStr-V(a6),a2
	move.w	#3,(a1)+
	move.l	a2,(a1)+	
	PUSH	

	bsr	bindec
	move.l	#7,d0				; Lets copy output to a safe location
	move.l	#"    ",(a2)

.setvarloop:
	move.b	(a0)+,d7
	cmp.b	#0,d7				; end of string?
	beq	.decdone
	move.b	d7,(a2)+
	dbf	d0,.setvarloop
.decdone:
	POP

	add.l	#1,a0	
	move.w	#2,(a1)+			; Write color
	lea	AudSimpWave-V(a6),a2
	clr.l	d1
	move.b	(a2),d1
	asl.l	#2,d1
	lea.l	AudioName,a2
	move.l	(a2,d1.w),(a1)+			; Write Stringpointer


	bsr	CheckOnOff
	move.w	d0,(a1)+			; Write color
	move.l	d1,(a1)+			; Write Stringpointer
	rts

.Playaudio:
	clr.l	d0
	move.b	AudSimpWave-V(a6),d0
	move.l	d0,d1
	mulu	#2,d1
	mulu	#4,d0
	
	lea	AudioPointers,a2
	move.l	a6,a0
	add.l	#AudioWaves-V,a0
	add.l	(a2,d0.l),a0

	lea	AudSimpChan1-V(a6),a1
	move.l	a0,$dff0a0			;Wave
	move.l	a0,$dff0b0			;Wave
	move.l	a0,$dff0c0			;Wave
	move.l	a0,$dff0d0			;Wave


	cmp.b	#0,(a1)+
	beq	.noch1

	clr.l	d7
	move.b	AudSimpVol-V(a6),d7
	move.w	d7,$dff0a8			;volume
	lea	AudioLen,a2
	move.w	(a2,d1),$dff0a4			;number of words
	lea	AudioPer,a2
	move.w	(a2,d1),$dff0a6
	move.w	#$8201,$dff096
	bra	.checkch2
.noch1:
	move.w	#$1,$dff096
	
.checkch2:

	cmp.b	#0,(a1)+
	beq	.noch2

	clr.l	d7
	move.b	AudSimpVol-V(a6),d7
	move.w	d7,$dff0b8			;volume
	lea	AudioLen,a2
	move.w	(a2,d1),$dff0b4			;number of words
	lea	AudioPer,a2
	move.w	(a2,d1),$dff0b6			;frequency
	move.w	#$8202,$dff096
	bra	.checkch3
.noch2:
	move.w	#$2,$dff096
	
.checkch3:
	cmp.b	#0,(a1)+
	beq	.noch3

	clr.l	d7
	move.b	AudSimpVol-V(a6),d7
	move.w	d7,$dff0c8			;volume
	lea	AudioLen,a2
	move.w	(a2,d1),$dff0c4			;number of words
	lea	AudioPer,a2
	move.w	(a2,d1),$dff0c6			;frequency
	move.w	#$8204,$dff096
	bra	.checkch4
.noch3:
	move.w	#$4,$dff096
	
.checkch4:

	cmp.b	#0,(a1)+
	beq	.noch4

	clr.l	d7
	move.b	AudSimpVol-V(a6),d7
	move.w	d7,$dff0d8			;volume
	lea	AudioLen,a2
	move.w	(a2,d1),$dff0d4			;number of words
	lea	AudioPer,a2
	move.w	(a2,d1),$dff0d6			;frequency
	move.w	#$8208,$dff096
	bra	.checkdone
.noch4:
	move.w	#$8,$dff096
	
.checkdone:

	rts


.chan1:
	bchg	#0,AudSimpChan1-V(a6)
	move.b	#1,UpdateMenuNumber-V(a6)
	move.b	#2,PrintMenuFlag-V(a6)
	bsr	CheckKeyReleased
	bsr	.setvar
	bra	.loop



.chan2:
	bchg	#0,AudSimpChan2-V(a6)
	move.b	#2,UpdateMenuNumber-V(a6)
	move.b	#2,PrintMenuFlag-V(a6)
	bsr	CheckKeyReleased
	bsr	.setvar
	bra	.loop



.chan3:
	bchg	#0,AudSimpChan3-V(a6)
	move.b	#3,UpdateMenuNumber-V(a6)
	move.b	#2,PrintMenuFlag-V(a6)
	bsr	CheckKeyReleased
	bsr	.setvar
	bra	.loop




.chan4:
	bchg	#0,AudSimpChan4-V(a6)
	move.b	#4,UpdateMenuNumber-V(a6)
	move.b	#2,PrintMenuFlag-V(a6)
	bsr	CheckKeyReleased
	bsr	.setvar
	bra	.loop

.vol:
	move.l	a6,a0
	cmp.b	#1,LMB-V(a6)		;Check if Left mousebutton was pressed
	bne	.nolmb			;if not skip
	bsr	.volup

.nolmb:
	cmp.b	#1,RMB-V(a6)		;Check if Right mousebutton was pressed
	bne	.normb
	bsr	.voldown
.normb:
	move.w	#4,(a0)+
	move.l	#OFF,(a0)+
	move.b	#5,UpdateMenuNumber-V(a6)
	move.b	#2,PrintMenuFlag-V(a6)
	bsr	CheckKeyReleased
	bsr	.setvar
	bra	.volume

.wave:
	TOGGLEPWRLED
	clr.l	d7
	move.b	AudSimpWave-V(a6),d7

	cmp.b	#17,d7
	beq	.notmax
	add.b	#1,d7
	bra	.wave2
.notmax:
	clr.l	d7
.wave2:
	move.b	d7,AudSimpWave-V(a6)

	move.b	#6,UpdateMenuNumber-V(a6)
	move.b	#2,PrintMenuFlag-V(a6)
	bsr	CheckKeyReleased
	bsr	.setvar
	bra	.loop

.filter:
	bchg	#0,AudSimpFilter-V(a6)
	btst	#0,AudSimpFilter-V(a6)
	beq	.off
	bclr	#1,$bfe001
	bra	.on
.off:
	bset	#1,$bfe001
.on:
	move.b	#7,UpdateMenuNumber-V(a6)
	move.b	#2,PrintMenuFlag-V(a6)
	bsr	CheckKeyReleased
	bsr	.setvar
	bra	.loop

.volup:
	cmp.b	#64,AudSimpVol-V(a6)	;	are we ar maxvol?
	beq	.atmax
	add.b	#1,AudSimpVol-V(a6)
.atmax:
	rts
.voldown:
	cmp.b	#0,AudSimpVol-V(a6)	;	are we ar lowvol?
	beq	.atmax
	sub.b	#1,AudSimpVol-V(a6)
	rts

.exit:
	move.w	#15,$dff096
	bsr	WaitReleased

	move.l	#Menus,Menu-V(a6)		; Set Menus as default menu. if different set another manually
	move.l	#0,MenuVariable-V(a6)
	bra	AudioMenu

CheckKeyReleased:
	bsr	GetInput
	btst	#1,d0
	bne.s	CheckKeyReleased
	rts

CheckOnOff:					; Checks if a0 is pointing to a variable that is on or off
						; OUTPUT =   D0 = Color
						;	     D1 = Address of String
			
	cmp.b	#0,(a0)+
	bne	.on
	move.l	#1,d0
	move.l	#OFF,d1
	rts
.on:
	move.l	#2,d0
	move.l	#ON,d1
	rts
	

AudioMod:
	ifeq a1k

	bsr	FilterOFF


	bsr	ClearScreen
	lea	AudioModStatData-V(a6),a1	; Get statusvariable

	clr.l	(a1)+

	bset	#1,(a1)+			; Set Default filter off
	move.b	#64,(a1)+			; Set Default MasterVolume
	clr.w	(a1)+

	move.l	#-1,(a1)+
	move.l	#-1,(a1)			; and the "former" values aswell


						; but to something that never can happen
						; forcing an update first run
	lea	AudioModTxt,a0
	move.l	#2,d1
	bsr	Print




	move.l	#EndMusic-Music,d0
	bsr	GetChip				; Get memory for module

	cmp.l	#0,d0				; if it is 0, no chipmem avaible
	bne	.chip

	move.l	#1,d1
	lea	NoChiptxt,a0
	bsr	Print				; We did not have enough chipmem
	bra	.exit

.chip:

	cmp	#1,d0
	bne	.enough

	move.l	#1,d1
	lea	NotEnoughChipTxt,a0
	bsr	Print
	bra	.exit

.enough:



	move.l	d0,AudioModAddr-V(a6)		; Store address of module
	move.l	d0,AudioModData-V(a6)

	lea	AudioModCopyTxt,a0
	move.l	#3,d1
	bsr	Print


	move.l	AudioModAddr-V(a6),a0
	move.l	#EndMusic-Music,d0		; get size of module
	asr.l	#2,d0				; Divide by 4 to get number of longwords
	lea	Music,a1			; Get address where module is in ROM
.loop:
	move.l	(a1)+,(a0)+
	dbf	d0,.loop			; Copy module into chipmem



	move.l	#2,d1
	lea	Donetxt,a0
	bsr	Print

	lea	AudioModInitTxt,a0
	move.l	#3,d1
	bsr	Print

	move.l	AudioModAddr-V(a6),a0
	
	move.l	AudioModInit-V(a6),a1
	lea	$dff000,a5
	jsr	(a1)				; Call MT_Init

	lea	Donetxt,a0
	move.l	#2,d1
	bsr	Print

	move.l	AudioModMVol-V(a6),a0
	move.b	#4,(a0)				; Set Mastervolume

	lea	AudioModName,a0
	move.l	#3,d1
	bsr	Print

	move.l	AudioModAddr-V(a6),a0
	move.l	#5,d1
	bsr	Print

	lea	AudioModInst,a0
	move.l	#3,d1
	bsr	Print

	move.l	AudioModAddr-V(a6),a1
	add.l	#20,a1
	move.l	#1,d7
	move.l	#15,d6
	move.l	#7,d5
.instloop:
	clr.l	d0
	move.l	d5,d1
	bsr	SetPos
	move.l	d7,d0
	bsr	binhexbyte
	move.l	#2,d1
	bsr	Print

	lea	SpaceTxt,a0
	bsr	Print

	move.l	a1,a0
	move.l	#5,d1
	bsr	Print
	add.l	#30,a1
	add.l	#1,d7

.noprint:
	lea	NewLineTxt,a0
	bsr	Print
	add.l	#1,d5
	dbf	d6,.instloop

	move.l	#15,d6
	move.l	#7,d5
.instloop2:
	move.l	#40,d0
	move.l	d5,d1
	bsr	SetPos
	move.l	d7,d0
	cmp.l	#$20,d0
	beq	.noprint2
	bsr	binhexbyte
	move.l	#2,d1
	bsr	Print
	lea	SpaceTxt,a0
	bsr	Print

	move.l	a1,a0
	move.l	#5,d1
	bsr	Print

	add.l	#30,a1
	add.l	#1,d7
.noprint2:
	lea	NewLineTxt,a0
	bsr	Print
	add.l	#1,d5
	dbf	d6,.instloop2


	lea	NewLineTxt,a0
	bsr	Print

	lea	AudioModPlayTxt,a0
	move.l	#3,d1
	bsr	Print

	lea	AudioModOptionTxt,a0
	move.l	#3,d1
	bsr	Print

	lea	AudioModEndTxt,a0
	move.l	#3,d1
	bsr	Print

	bsr	AudioModStatus

.loopa:
	cmp.b	#$e0,$dff006
	bne.s	.loopa

	move.l	AudioModMusic-V(a6),a1
	lea	$dff000,a5
	jsr	(a1)				; Call MT_Music

	bsr	GetInput
	
	lea	AudioModStatData-V(a6),a1	; Get statusvariable

	cmp.b	#"1",GetCharData-V(a6)
	beq	.chan1
	cmp.b	#"2",GetCharData-V(a6)
	beq	.chan2
	cmp.b	#"3",GetCharData-V(a6)
	beq	.chan3
	cmp.b	#"4",GetCharData-V(a6)
	beq	.chan4
	cmp.b	#"f",GetCharData-V(a6)
	beq	.filter
	cmp.b	#"+",GetCharData-V(a6)
	beq	.volup
	cmp.b	#"-",GetCharData-V(a6)
	beq	.voldown
	cmp.b	#"l",GetCharData-V(a6)
	beq	.left
	cmp.b	#"r",GetCharData-V(a6)
	beq	.right
	cmp.b	#$1b,GetCharData-V(a6)
	beq	.exitit

.keydone:

	bsr	AudioModStatus
	cmp.b	#1,LMB-V(a6)
	bne.w	.loopa
.exitit:


	move.l	AudioModEnd-V(a6),a1
	lea	$dff000,a5
	jsr	(a1)				; Call MT_End

.exit:
	bra	AudioMenu

.chan1:
	bchg	#1,(a1)
	clr.b	BUTTON-V(a6)
	bra	.keydone
.chan2:
	bchg	#1,1(a1)
	clr.b	BUTTON-V(a6)
	bra	.keydone
.chan3:
	bchg	#1,2(a1)
	clr.b	BUTTON-V(a6)
	bra	.keydone
.chan4:
	bchg	#1,3(a1)
	clr.b	BUTTON-V(a6)
	bra	.keydone
.filter:
	bchg	#1,4(a1)
	clr.b	BUTTON-V(a6)
	bra	.keydone
.volup:
	cmp.b	#64,5(a1)			; Check if volume is already at max
	beq	.volmax
	add.b	#1,5(a1)
.volmax:
	clr.b	BUTTON-V(a6)
	bra	.keydone
		
.voldown:
	cmp.b	#0,5(a1)
	beq	.volmin
	sub.b	#1,5(a1)
.volmin:
	clr.b	BUTTON-V(a6)
	bra	.keydone
.left:
	bchg	#1,6(a1)			; Toggle left. copy it to chan1 & 4
	move.b	6(a1),(a1)
	move.b	6(a1),3(a1)
	clr.b	BUTTON-V(a6)
	bra	.keydone
.right:
	bchg	#1,7(a1)
	move.b	7(a1),1(a1)
	move.b	7(a1),2(a1)
	clr.b	BUTTON-V(a6)
	bra	.keydone
	
AudioModStatus:
	PUSH
	lea	AudioModStatData-V(a6),a1	; Get statusvariable
	lea	AudioModStatFormerData-V(a6),a2	; Get statusvariable
	move.l	#3,d7
	move.l	#20,d6
.loop:
	move.b	(a1),d2
	cmp.b	(a2),d2			; Compare 2 data, if we had a change
	beq	.done			; if no change do not do anything
	move.b	d2,(a2)			; Store the real value into former data

	move.l	d6,d0
	move.l	#26,d1
	bsr	SetPos

	cmp.b	#0,(a1)			; if it is 0, channel is on
	bne	.off
	lea	ON,a0			; Print ON
	move.l	#2,d1
	bsr	Print
	beq	.done
.off:
	lea	OFF,a0			; Print OFF
	move.l	#1,d1
	bsr	Print
.done:
	add.l	#1,a2			; add 1 to fomerdatapos
	add.l	#1,a1
	add.l	#16,d6			; change variable to put next string 16 chars away
	dbf	d7,.loop	


	move.b	(a1),d2
	cmp.b	(a2),d2			; Compare 2 data, if we had a change
	beq	.donefilter		; if no change do not do anything
	move.b	d2,(a2)			; Store the real value into former data

	move.l	#33,d0
	move.l	#27,d1
	bsr	SetPos

	cmp.b	#0,(a1)			; if it is 0, channel is on
	bne	.filteroff
	bsr	FilterON
	lea	ON,a0			; Print ON
	move.l	#2,d1
	bsr	Print
	beq	.donefilter
.filteroff:
	bsr	FilterOFF
	lea	OFF,a0			; Print OFF
	move.l	#1,d1
	bsr	Print
.donefilter:	

	add.l	#1,a2			; add 1 to fomerdatapos
	add.l	#1,a1


	move.b	(a1),d2
	cmp.b	(a2),d2			; Compare 2 data, if we had a change
	beq	.donevol		; if no change do not do anything
	move.b	d2,(a2)			; Store the real value into former data
	
	move.l	#59,d0
	move.l	#27,d1
	bsr	SetPos

	clr.l	d0
	move.b	d2,d0
	bsr	bindec
	move.l	#2,d1
	bsr	Print
	lea	Space3,a0
	bsr	Print
.donevol:
	move.l	AudioModMVol-V(a6),a0
	move.b	(a1),(a0)+				; Set Mastervolume
	lea	AudioModStatData-V(a6),a1	; Get statusvariable
	move.b	(a1)+,(a0)+	
	move.b	(a1)+,(a0)+	
	move.b	(a1)+,(a0)+	
	move.b	(a1)+,(a0)+			; Copy data to protrackerroutine.
						; move.l WILL crash on non 020+ machines
	POP
	rts


	else

	bra	Not1K

	endc

;------------------------------------------------------------------------------------------

MemtestMenu:
	bsr	ClearBuffer
	bsr	InitScreen
	move.w	#3,MenuNumber-V(a6)
	move.b	#1,PrintMenuFlag-V(a6)
	bra	MainLoop

CheckDetectedChip:
	bsr	ClearScreen
	lea	MemtestDetChipTxt,a0
	move.l	#2,d1
	bsr	Print

	move.b	#0,CheckMemNoShadow-V(a6)

	ifne	rommode
		move.l	ChipStart-V(a6),d0
		lea	TotalChip-V(a6),a0	; Total Chipmem detected
		move.l	(a0),d1

		mulu	#1024,d1
		add.l	d0,d1
		sub.l	#$400,d1

	else
		move.l	#$1a0000,d0
		move.l	#$200000,d1
	endc

	move.l	d0,CheckMemFrom-V(a6)
	move.l	d1,CheckMemTo-V(a6)

	move.b	#14,LogYpos-V(a6)		; Store first row of log
	move.l	#0,CheckMemStepSize-V(a6)	; Set how many bytes to step between every memorytest
	bsr	MemTesterInit


.loop:

	bsr	MemTesterNewBlock
	bsr	MemoryTester
	cmp.w	#1,CheckMemCancel-V(a6)
	beq	.cancel
	bsr	MemTesterNewPass
	bra	.loop

.cancel:



;		move.l	#0,d2
;		clr.b	CheckMemRow-V(a6)
;		bsr	CheckMemory

	bsr	WaitButton
	bra	MemtestMenu



CheckDetectedMBMem:
	jsr	ClearScreen
	clr.w	MemDetected-V(a6)
	move.w	#"DE",DetectMemRnd-V(a6)	; "put in RN" at detectMemRnd to have some data
	add.w	#1,DetectMemRnd+2-V(a6)		; Increase by 1 to have a number that changes every call
	
	clr.l	FastmemBlock-V(a6)

	lea	$200000,a1
	lea	$d00000,a4	; endaddress of this pass
	bsr	.memloop	

	cmp.b	#1,ADR24BIT-V(a6)	; Check if we had 24 bit cpu...
	bne	.no24bit

	bra	.24bit
.no24bit:

	cmp.l	#" PPC",$f00090	; Check if the string "PPC" is located in rom at this address. if so we have a BPPC
				; that will disable the 68k cpu onboard if memory  below $40000000 is tested.
	bne	.nobppc
	lea	$40000000,a1	; Strangly enough.  bppc detected memory will be totally just plain WRONG! I guess it does stuff in rom
	bra	.bppc		; that makes a more decent memorymap. Now it just finds lots of smaller shadows..
	
.nobppc:
	lea	$1000000,a1
.bppc:
	lea	$f0000000,a4	; endaddress of this pass
	bsr	.memloop	
.24bit:

	jsr	LogLine
	lea	AnyKeyMouseTxt,a0
	move.l	#5,d1
	jsr	Print

	bsr	WaitPressed
	bsr	WaitReleased
	bra	MemtestMenu

.memloop:
	clr.l	d1
	move.l	a4,a2		; Set a2 to endaddress of scan
	lea	.leadone,a3
	move.l	DetectMemRnd-V(a6),d0	; store a "random" data in d0 for shadowcontrol

	bra	DetectMemory

.leadone:
	add.l	d1,FastmemBlock-V(a6)

	cmp.l	#0,a0
	bne	.mem
	bra	.end
.mem:
	cmp.l	#0,d1		; check if size was 0, that means this memory is "illegal" and should be skipped
	beq	.blockdone
	
	move.l	a0,a2		; Store address of first mem found into a2
	move.l	d1,d2		; copy size to d2
	

	cmp.w	#0,MemDetected-V(a6)	; did we have any detected ram yet?
	bne	.yesdetected		; if it wasn't null we had mem
	move.w	#1,MemDetected-V(a6)
	jsr	.initmemtest

.yesdetected
	PUSH

	clr.l	d0
	clr.l	d1
	bsr	SetPos
	lea	EmptyRowTxt,a0
	jsr	Print
	clr.l	d0
	clr.l	d1
	bsr	SetPos


	POP

	lea	DetMem,a0
	move.l	#2,d1
	jsr	Print
	move.l	d2,d0		; copy size to d0

	bsr	.PrintSize
	lea	DetOfmem,a0
	jsr	Print
	move.l	a2,d0		; Print first memaddress
	move.l	a2,CheckMemFrom-V(a6)

	bsr	binhex
	jsr	Print
	lea	MinusTxt,a0
	jsr	Print
	move.l	a1,d0		; Print end memaddress
	bsr	binhex
	jsr	Print
	lea	NewLineTxt,a0
	jsr	Print

	PUSH
	bsr	LogLine
	lea	DetMem,a0
	move.l	#2,d1
	jsr	Print

	move.l	d2,d0		; copy size to d0
	bsr	.PrintSize
	lea	DetOfmem,a0
	jsr	Print
	move.l	a2,d0		; Print first memaddress
	bsr	binhex
	jsr	Print
	lea	MinusTxt,a0
	jsr	Print
	move.l	a1,d0		; Print end memaddress
	bsr	binhex
	move.l	a1,CheckMemTo-V(a6)

	jsr	Print
	lea	NewLineTxt,a0
	jsr	Print

	bsr	MemTesterNewBlock
	bsr	MemoryTester



	POP

				; ok we now had the endaddress at the same register Detectmemory uses as START. so lets check if we are at end of
.blockdone
				; memarea and if not, just loop until we are done.
	add.l	#64*1024,a1	; Add 64k for next block to test, just in case

	cmp.l	a4,a1
	blo	.memloop
.end:
	rts

.PrintSize:
	cmp.l	#32,d0		; Check if we had more than 4 blocks (2048k)  if so.. lets show in MB instead.
	bge	.showMB
	asl.l	#6,d0		; convert number of 16k blocks to real value of kb
	bsr	bindec
	move.l	#2,d1
	jsr	Print		; print it
	lea	KB,a0
	jsr	Print
	bra	.donesize

.showMB:			; convert number of 16k blocks to real value of mb
	asr.l	#4,d0
	bsr	bindec
	move.l	#2,d1
	jsr	Print		; print it
	lea	MB,a0
	jsr	Print
.donesize:
	rts


.initmemtest:
	PUSH
	move.l	#$7000000,CheckMemFrom-V(a6)
	move.l	#$7ffffff,CheckMemTo-V(a6)

	move.b	#14,LogYpos-V(a6)		; Store first row of log
	move.l	#0,CheckMemStepSize-V(a6)	; Set how many bytes to step between every memorytest
	bsr	MemTesterInit


	POP
	rts

CheckMemManual:
	bsr	ClearScreen
	lea	MemtestManualTxt,a0
	move.l	#6,d1
	bsr	Print

	move.b	#41,d0
	move.b	#13,d1


	lea	$0,a0
	bsr	InputHexNum
	cmp.l	#-1,d0
	beq	.exit

	move.l	d0,d6

	lea	MemtestManualEndTxt,a0
	move.l	#6,d1
	bsr	Print

	lea	$0,a0
	bsr	InputHexNum
	cmp.l	#-1,d0
	beq	.exit

	move.l	d0,d7

	lea	MemtestManualBlockTxt,a0
	move.l	#6,d1
	bsr	Print
	

	lea	1,a0
	bsr	InputDecNum
	cmp.l	#-1,d0
	beq	.exit

	cmp.l	#0,d0
	bne	.nonull
	move.l	#1,d0			; ok someone was funny and entered 0, change to 1
.nonull:

	cmp.l	#512,d0
	blt	.nomax
	move.l	#512,d0			; ok someone entered more than 512. lets put that to a limit..
.nomax:

	cmp.l	d6,d7	
	beq	.exit			; end and start was the same, skip all

	cmp.l	d6,d7			; check if start is higher than end
	bgt	.nothigher

					; OK that was it. lets swap result

	move.l	d6,d5
	move.l	d7,d6
	move.l	d5,d7


.nothigher:


	move.l	d6,CheckMemFrom-V(a6)
	move.l	d7,CheckMemTo-V(a6)
	mulu	#4,d0
	move.l	d0,CheckMemStepSize-V(a6)	; Set how many bytes to step between every memorytest


	move.b	#14,LogYpos-V(a6)		; Store first row of log
	lea	MemoryTestManual,a0
	move.l	#MemTestEndcode-MemoryTestManual,d0
	jsr	RunCode
	bsr	ClearBuffer
	bsr	WaitPressed
	bsr	WaitReleased
.exit:
	bra	MemtestMenu

CheckMemEdit:
	bsr	ClearScreen
	lea	CheckMemEditTxt,a0
	move.l	#2,d1
	bsr	Print

	move.l	#34,d0
	move.l	#1,d1
	bsr	SetPos
	lea	OFF,a0
	move.l	#3,d1
	bsr	Print
;	clr.b	CpuCache-V(a6)			; Set status to off

	move.b	#0,CheckMemEditXpos-V(a6)
	move.b	#0,CheckMemEditYpos-V(a6)	; Clear X and Y positions
	move.b	#0,CheckMemEditOldXpos-V(a6)
	move.b	#0,CheckMemEditOldYpos-V(a6)	; Clear X and Y positions

	clr.l	d0
	move.l	#3,d1
	bsr	SetPos

	move.l	CheckMemEditScreenAdr-V(a6),d0
	move.l	d0,a0
	bsr	CheckMemEditUpdateScreen

.loop:

	bsr	.putcursor

	bsr	GetMouse
	cmp.b	#1,RMB-V(a6)
	beq	.exit

.ansimode:
	bsr	GetChar

	cmp.b	#$1b,d0
	beq	.exit
	
	cmp.b	#1,d0
	beq	.pgup

	cmp.b	#2,d0
	beq	.pgdown

	cmp.b	#30,d0
	beq	.up	

	cmp.b	#31,d0
	beq	.down
	
	cmp.b	#28,d0
	beq	.right

	cmp.b	#29,d0
	beq	.left

	move.b	d0,d1				; Copy char to d1, so we do not trash for hexnumbers
	bclr	#5,d1				; make it uppercase

	cmp.b	#"q",d0
	beq.w	.pgup

	cmp.b	#"z",d0
	beq.w	.pgdown


	cmp.b	#"G",d1
	beq	.GotoMem			; G was pressed, let user enter address to dump


	cmp.b	#"R",d1
	beq	.Refresh

	cmp.b	#"H",d1
	beq	.Cache

	cmp.b	#"X",d1
	beq	.Execute


	bsr	GetHex				; OK, convert it to hex. if anything is left now, we have a hexdigit that
	cmp.b	#"0",d0
	blt	.nohex

.tobin:
	cmp.b	#"A",d0				; Check if it is "A"
	blt	.nochar				; Lower then A, this is not a char
	sub.l	#7,d0				; ok we have a char, subtract 7
.nochar:
	sub.l	#$30,d0				; Subtract $30, converting it to binary.

	move.l	d0,d2				; Store d0 into d2 temporary

	move.b	CheckMemEditXpos-V(a6),d0
	move.b	CheckMemEditYpos-V(a6),d1
	bsr	.getcursoradr			; a0 will now contain the address of memoryadress where cursor is
	clr.l	d7
	move.b	(a0),d7				; and D7 will contain what that address contains

	move.l	d2,d0				; Restore d2

	cmp.b	#0,CheckMemEditCharPos-V(a6)
	bne	.nocurleft

	and.b	#$f,d7				; Strip out high nibble from d7
	asl	#4,d0				; rotate input data to high nibble
	add.b	d0,d7				; add them together
	move.b	d7,(a0)				; store in memory
	add.b	#1,CheckMemEditCharPos-V(a6)	; add 1 to pos, for next nibble
	bra	.editdone
.nocurleft:
	and.b	#$f0,d7				; Strip out low nibble
	add.b	d0,d7				; add indata with the rest of d7
	move.b	d7,(a0)				; store in memory
	clr.b	CheckMemEditCharPos-V(a6)	; Clear charpos
	cmp.b	#15,CheckMemEditXpos-V(a6)
	beq	.noright
	add.b	#1,CheckMemEditXpos-V(a6)	; move one step to the right

.editdone:

						; Should go into memory. (Whaa.  BANGING on da shit here)

.nohex:
.keydone:
	bra	.loop

.getcursoradr:					; Get memoryaddress of X, Y pos
						; INDATA:
						;	d0 = xpos
						;	d1 = ypos
						;
						; OUTDATA:
						;	a0 = memoryaddress
	and.l	#$ff,d0
	and.l	#$ff,d1
	move.l	CheckMemEditScreenAdr-V(a6),a0
	add.l	d0,a0
	asl.l	#4,d1
	add.l	d1,a0
	rts

.putcursor:
	clr.l	d2
	clr.l	d3
	clr.l	d4
	clr.l	d5
	move.b	CheckMemEditXpos-V(a6),d2
	move.b	CheckMemEditYpos-V(a6),d3
	move.b	CheckMemEditOldXpos-V(a6),d4
	move.b	CheckMemEditOldYpos-V(a6),d5
	cmp.b	d2,d4
	bne	.notequal
	cmp.b	d3,d5
	bne	.notequal			; ok cursorpos have changed.. lets put a nonrevesed char in spot
.equal:
	move.l	#10,d0
	move.l	#4,d1

	mulu	#3,d2


	add.l	d2,d0
	add.l	d3,d1
	bsr	SetPos				; First byte


	move.b	CheckMemEditXpos-V(a6),d0
	move.b	CheckMemEditYpos-V(a6),d1
	bsr	.getcursoradr

	clr.l	d0

	move.b	(a0),d0
	move.l	d0,d7				; Store d0 to d7 temporary
	bsr	binhexbyte
	move.l	#11,d1
	bsr	Print				; Print what is in current memorypos as a HEX digit and yellow.

	move.l	#60,d0
	move.l	#4,d1

	add.b	CheckMemEditXpos-V(a6),d0
	add.b	CheckMemEditYpos-V(a6),d1

	bsr	SetPos
	

	move.b	CheckMemEditXpos-V(a6),d0
	move.b	CheckMemEditYpos-V(a6),d1
	bsr	.getcursoradr

	clr.l	d0
	move.b	(a0),d0
	bsr	MakePrintable
	move.l	#11,d1
	bsr	PrintChar

	move.l	#17,d0
	move.l	#25,d1
	bsr	SetPos

	move.l	a0,d0
	bsr	binhex
	move.l	#3,d1
	bsr	Print	


	move.l	#52,d0
	move.l	#25,d1
	bsr	SetPos

	move.l	d7,d0				; restore d0 with value from current pos
	bsr	binstringbyte
	move.l	#3,d1
	bsr	Print


	rts

.notequal:					; We had movement.  lets put stuff to "normal" case
	clr.b	CheckMemEditCharPos-V(a6)	; Clear charpos
	move.b	d2,CheckMemEditOldXpos-V(a6)
	move.b	d3,CheckMemEditOldYpos-V(a6)	; Set current pos to "old" pos

	move.l	d4,d7				; Copy d4 to d7 so we do not screw up data for later
	move.l	#10,d0
	move.l	#4,d1
	mulu	#3,d7				; Multiply X pos with 3 so we have space for 2 hexchars and a space
	add.l	d7,d0
	add.l	d5,d1

	PUSH					; Store this in stack, we will need it later
	bsr	SetPos				; Put cursor on screen
	move.l	d4,d0
	move.l	d5,d1
	bsr	.getcursoradr			; Get what memoryaddress we are pointing on
	clr.l	d0
	move.b	(a0),d0
	bsr	binhexbyte
	move.l	#7,d1
	bsr	Print				; Print that byte.
	POP					; ok roll back stack, we will need this data again

	move.l	d4,d0
	move.l	d5,d1
	add.l	#60,d0
	add.l	#4,d1
	bsr	SetPos
	move.l	d4,d0
	move.l	d5,d1
	bsr	.getcursoradr
	clr.l	d0
	move.b	(a0),d0
	bsr	MakePrintable
	move.l	#7,d1
	bsr	PrintChar

	bra	.equal


	PUSH					; Store in stack
	bsr	SetPos
	POP					; ok. d4 and d5 still contains x and y

	move.l	d4,d0
	move.l	d5,d1
	bsr	.getcursoradr
	add.l	#10,d0
	add.l	#4,d1
	bsr	SetPos

	move.b	(a0),d0
	bsr	binhexbyte
	move.l	#7,d1
	bsr	Print

	bra	.equal


.GotoMem:
	clr.b	CheckMemEditCharPos-V(a6)	; Clear charpos
	move.l	#0,d0
	move.l	#3,d1
	bsr	SetPos
	lea	CheckMemEditGotoTxt,a0
	move.l	#2,d1
	bsr	Print

	move.l	CheckMemEditScreenAdr-V(a6),d0	; Read the screenaddress currently showed
	add.l	#$150,d0			; Add $150 to that, (next screen)
	move.l	d0,a0
	bsr	InputHexNum
	cmp.l	#-1,d0
	beq	.exit
	move.l	d0,CheckMemEditScreenAdr-V(a6)	; Store address in memory
	move.l	d0,a0
	bsr	CheckMemEditUpdateScreen	; Update the screen
	bsr	.ClearCommandRow		; Clear the "goto" row.
	bra	.loop

.Cache:
	cmp.b	#1,CPUGen-V(a6)			; Check if CPUGen is 010 or less
	ble	.Refresh
	bchg	#1,CPUCache-V(a6)		; Change status of Cacheflag
	clr.l	d0

	move.l	#34,d0
	move.l	#1,d1
	bsr	SetPos

	move.b	CPUCache-V(a6),d0
	cmp.b	#0,d0				; is it off?
	beq	.CacheOff
						; no, it is on
	lea	ON,a0
	move.l	#2,d1
	bsr	Print
	bsr	EnableCache
	bra	.Refresh
.CacheOff:
	lea	OFF,a0
	move.l	#3,d1
	bsr	Print
	bsr	DisableCache
	bra	.Refresh

.Execute:

	clr.b	CheckMemEditCharPos-V(a6)	; Clear charpos
	move.l	#0,d0
	move.l	#3,d1
	bsr	SetPos
	lea	CheckMemExecuteTxt,a0
	move.l	#2,d1
	bsr	Print

	move.l	CheckMemEditScreenAdr-V(a6),d0
	bsr	binhex
	move.l	#3,d1
	bsr	Print

	lea	CheckMemExecuteTxt2,a0
	move.l	#2,d1
	bsr	Print

.Execloop:
	bsr	GetChar

	bclr	#5,d0				; Make it uppercase
	cmp.b	#"Y",d0
	beq	.Executeit
	cmp.b	#"N",d0
	bne.s	.Execloop
	bra	.ExecuteExit

.Executeit:
	move.l	CheckMemEditScreenAdr-V(a6),a0
	PUSH
	jsr	(a0)				; Doing HARDCORE crash?
	POP
.ExecuteExit:
	
.Refresh:
	clr.b	CheckMemEditCharPos-V(a6)	; Clear charpos
	move.l	CheckMemEditScreenAdr-V(a6),a0	; Get address
	bsr	CheckMemEditUpdateScreen	; Update the screen
	bsr	.ClearCommandRow		; Clear the "goto" row.
	bra	.loop
	

.exit:
	bra	MemtestMenu

.pgup:
	move.l	CheckMemEditScreenAdr-V(a6),d0	; Read the screenaddress currently showed
	sub.l	#$150,d0
	move.l	d0,CheckMemEditScreenAdr-V(a6)	; Store address in memory
	move.l	d0,a0
	bsr	CheckMemEditUpdateScreen
	bra	.keydone
.pgdown:
	move.l	CheckMemEditScreenAdr-V(a6),d0	; Read the screenaddress currently showed
	add.l	#$150,d0
	move.l	d0,CheckMemEditScreenAdr-V(a6)	; Store address in memory
	move.l	d0,a0
	bsr	CheckMemEditUpdateScreen
	bra	.keydone

.up:
	cmp.b	#0,CheckMemEditYpos-V(a6)
	beq	.noup
	sub.b	#1,CheckMemEditYpos-V(a6)
	bra	.keydone
.noup:
	move.l	CheckMemEditScreenAdr-V(a6),d0	; Read the screenaddress currently showed
	sub.l	#$10,d0
	move.l	d0,CheckMemEditScreenAdr-V(a6)	; Store address in memory
	move.l	d0,a0
	bsr	CheckMemEditUpdateScreen
	bra	.keydone
	
.down:
	cmp.b	#20,CheckMemEditYpos-V(a6)
	beq	.nodown
	add.b	#1,CheckMemEditYpos-V(a6)
	bra	.keydone
.nodown:
	move.l	CheckMemEditScreenAdr-V(a6),d0	; Read the screenaddress currently showed
	add.l	#$10,d0
	move.l	d0,CheckMemEditScreenAdr-V(a6)	; Store address in memory
	move.l	d0,a0
	bsr	CheckMemEditUpdateScreen
	bra	.keydone


.right:
	cmp.b	#15,CheckMemEditXpos-V(a6)
	beq	.noright
	add.b	#1,CheckMemEditXpos-V(a6)
.noright:
	bra	.keydone

.left:
	cmp.b	#0,CheckMemEditXpos-V(a6)
	beq	.noleft
	sub.b	#1,CheckMemEditXpos-V(a6)
.noleft:
	bra	.keydone
	
.ClearCommandRow:
	move.l	#0,d0
	move.l	#3,d1
	bsr	SetPos
	lea	EmptyRowTxt,a0
	bsr	Print
	rts

CheckMemEditUpdateScreen:			; Updates the whole screen with memorydump
						; INDATA:
						;	A0 = Startaddress
	move.l	#1,d0
	move.l	#20,d7
.loop:
	bsr	CheckMemEditUpdateRow
	add.l	#16,a0
	add.l	#1,d0
	dbf	d7,.loop			; Print 21 rows of memorydump on screen

	move.l	#0,d0
	move.l	#25,d1
	bsr	SetPos

	lea	CheckMemAdrTxt,a0
	move.l	#2,d1
	bsr	Print

	move.l	#28,d0
	move.l	#25,d1
	bsr	SetPos
	lea	CheckMemBinaryTxt,a0
	move.l	#2,d1
	bsr	Print

	rts


CheckMemEditUpdateRow:
	;	Show memoryadress on screen
	;	INDATA:
	;		a0 = memory address
	;		d0 = row to update

	PUSH
	move.l	a0,a1				; store a0 in a1 for usage here.. as a0 is used
	add.l	#3,d0				; Add 3 to line to work on.
	move.l	d0,d1				; copy d0 to d1 to use it as Y adress
	clr.l	d0				; clear X pos
	bsr	SetPos				; Set position
	
	move.l	a0,d0
	bsr	binhex
	move.l	#6,d1
	bsr	Print				; Print address

	clr.l	d2				; Column to print
	move.l	#15,d7
.loop:
	lea	SpaceTxt,a0
	bsr	Print
	clr.l	d0				; Clear d0 just to be sure
	move.b	(a1,d2),d0
	bsr	binhexbyte			; Convert that byte to hex
	move.l	#7,d1
	bsr	Print				; Print it
	add.l	#1,d2
	dbf	d7,.loop
	lea	ColonTxt,a0			; Print a Colon
	move.l	#3,d1
	bsr	Print

	move.l	#15,d7				; Now print the same bytes.  as chars instead	
	clr.l	d2
.loop2:
	clr.l	d0
	move.b	(a1,d2),d0
	bsr	MakePrintable			; make the char printable.  strip controlstuff..
	add.l	#1,d2
	move.l	#7,d1
	bsr	PrintChar
	dbf	d7,.loop2
	POP
	rts


;------------------------------------------------------------------------------------------

IRQCIAtestMenu:
	bsr	InitScreen
	move.w	#4,MenuNumber-V(a6)
	move.b	#1,PrintMenuFlag-V(a6)
	bra	MainLoop

IRQCIAIRQTest:
	bsr	InitScreen
	lea	IRQCIAIRQTestText,a0
	move.w	#2,d1
	bsr	Print

.loop:
	bsr	GetInput
	clr.w	IRQLev7-V(a6)
	cmp.b	#$1b,GetCharData-V(a6)
	beq	.exit
	cmp.b	#1,RMB-V(a6)
	beq	.exit
	cmp.b	#1,BUTTON-V(a6)
	bne	.loop

	lea	IRQCIAIRQTestText2,a0
	move.w	#7,d1
	bsr	Print

	bsr	WaitReleased
	
	move.w	#$2000,sr			; Set SR to allow IRQs
	
	lea	IRQLev1Txt,a0
	move.l	#6,d1
	bsr	Print
	move.l	#IRQLevTest,d0
	move.l	d0,$64			; Set up IRQ Level 1
	clr.w	IRQLevDone-V(a6)		; Clear variable, we let the IRQ set it. if it gets set. we have working IRQ
	move.w	#$9000,$dff09c
	move.w	#$c004,$dff09a			; Enable IRQ
	move.w	#$c004,$dff09a			; Enable IRQ
	move.w	#$8004,$dff09c			; Trigger IRQ
	bsr	TestIRQ
	move.w	#$7fff,$dff09c			; Disable all INTREQ
	move.w	#$7fff,$dff09a			; Disable all INTREQ
	cmp.b	#2,d0
	bne	.done1

	bsr	WaitReleased
	
.done1:
	lea	NewLineTxt,a0
	bsr	Print
	lea	IRQLev2Txt,a0
	move.l	#6,d1
	bsr	Print


	clr.w	IRQLevDone-V(a6)		; Clear variable, we let the IRQ set it. if it gets set. we have working IRQ
	move.l	#IRQLevTest,$68			; Set up IRQ Level 2
	move.w	#$c008,$dff09a			; Enable IRQ
	move.w	#$c008,$dff09a			; Enable IRQ
	move.w	#$8008,$dff09c			; Trigger IRQ
	bsr	TestIRQ
	move.w	#$7fff,$dff09c			; Disable all INTREQ
	move.w	#$7fff,$dff09a			; Disable all INTREQ

	cmp.b	#2,d0
	beq	.done2

	bsr	WaitReleased

.done2:
	lea	NewLineTxt,a0
	bsr	Print
	lea	IRQLev3Txt,a0
	move.l	#6,d1
	bsr	Print


	clr.w	IRQLevDone-V(a6)		; Clear variable, we let the IRQ set it. if it gets set. we have working IRQ
	move.l	#IRQLevTest,$6c			; Set up IRQ Level 3
	move.w	#$c020,$dff09a			; Enable IRQ
	move.w	#$c020,$dff09a			; Enable IRQ
	move.w	#$8020,$dff09c			; Trigger IRQ
	bsr	TestIRQ
	move.w	#$7fff,$dff09c			; Disable all INTREQ
	move.w	#$7fff,$dff09a			; Disable all INTREQ
	cmp.b	#2,d0
	beq	.done3

	bsr	WaitReleased

.done3:
	lea	NewLineTxt,a0
	bsr	Print
	lea	IRQLev4Txt,a0
	move.l	#6,d1
	bsr	Print


	clr.w	IRQLevDone-V(a6)		; Clear variable, we let the IRQ set it. if it gets set. we have working IRQ
	move.l	#IRQLevTest,$70			; Set up IRQ Level 4
	move.w	#$c080,$dff09a			; Enable IRQ
	move.w	#$c080,$dff09a			; Enable IRQ
	move.w	#$8080,$dff09c			; Trigger IRQ
	bsr	TestIRQ
	move.w	#$7fff,$dff09c			; Disable all INTREQ
	move.w	#$7fff,$dff09a			; Disable all INTREQ
	cmp.b	#2,d0
	beq	.done4

	bsr	WaitReleased

.done4:
	lea	NewLineTxt,a0
	bsr	Print
	lea	IRQLev5Txt,a0
	move.l	#6,d1
	bsr	Print


	clr.w	IRQLevDone-V(a6)		; Clear variable, we let the IRQ set it. if it gets set. we have working IRQ
	move.l	#IRQLevTest,$74			; Set up IRQ Level 5
	move.w	#$c800,$dff09a			; Enable IRQ
	move.w	#$c800,$dff09a			; Enable IRQ
	move.w	#$8800,$dff09c			; Trigger IRQ
	bsr	TestIRQ
	move.w	#$7fff,$dff09c			; Disable all INTREQ
	move.w	#$7fff,$dff09a			; Disable all INTREQ
	cmp.b	#2,d0
	beq	.done5

	bsr	WaitReleased

.done5:
	lea	NewLineTxt,a0
	bsr	Print
	lea	IRQLev6Txt,a0
	move.l	#6,d1
	bsr	Print

	clr.w	IRQLevDone-V(a6)		; Clear variable, we let the IRQ set it. if it gets set. we have working IRQ
	move.l	#IRQLevTest,$78			; Set up IRQ Level 6
	move.w	#$e000,$dff09a			; Enable IRQ
	move.w	#$e000,$dff09a			; Enable IRQ
	move.w	#$a000,$dff09c			; Trigger IRQ
	bsr	TestIRQ
	move.w	#$7fff,$dff09c			; Disable all INTREQ
	move.w	#$7fff,$dff09a			; Disable all INTREQ
	cmp.b	#2,d0
	beq	.done6

	bsr	WaitReleased

.done6:
	lea	NewLineTxt,a0
	bsr	Print
	lea	IRQLev7Txt,a0
	move.l	#6,d1
	bsr	Print
	move.w	#1,IRQLev7-V(a6)

	clr.w	IRQLevDone-V(a6)		; Clear variable, we let the IRQ set it. if it gets set. we have working IRQ
	move.l	#IRQLevTest,$78			; Set up IRQ Level 7
	bsr	TestIRQ
	move.w	#$7fff,$dff09c			; Disable all INTREQ
	move.w	#$7fff,$dff09a			; Disable all INTREQ
	cmp.b	#2,d0
	beq	.done7

	bsr	WaitReleased

.done7:

	jsr	ClearBuffer


	lea	IRQTestDone,a0
	move.l	#2,d1
	bsr	Print


	

	bsr	WaitButton

.exit:
	bsr	IRQCIAtestMenu


TestIRQ:				; Test if IRQ was triggered
					; OUT:
					;	d0 = 0	== Everything sucessful
					;	d0 = 1	== We have failure
					;	d0 = 2	== User pressed cancel
	clr.l	d0
	move.w	#100,d7
.loop:
	bsr	GetInput			; Check for input from user
	cmp.b	#1,BUTTON-V(a6)			; If button is pressed, exit
	beq	.exitloop
	bsr	WaitLong
	cmp.w	#1,IRQLevDone-V(a6)		; Check if IRQLevDone is set, done in IRQ routine
	beq	.yes
	dbf	d7,.loop
	lea	FAILED,a0
	move.l	#1,d1
	cmp.w	#1,IRQLev7-V(a6)
	bne	.no7
	move.w	#2,d1
	lea	NONE,a0
.no7

	bsr	Print
	move.b	#1,d0				; we exited loop, test failed
	rts
.yes:
	lea	OK,a0
	move.l	#2,d1
	bsr	Print
	rts
.exitloop:
	lea	CANCELED,a0
	move.l	#3,d1
	bsr	Print
	rts

	move.b	#2,d0
	rts
	

IRQLevTest:					; Small IRQ Rouine, all it does is to set IRQLevDone to 1
	move.w	#$fff,$dff180
	move.w	#1,IRQLevDone-V(a6)
	move.w	#$7fff,$dff09c			; Disable all INTREQ
	move.w	#$7fff,$dff09a			; Disable all INTREQ
	rte


CIATIME	EQU	174
;	equ	174			(10000ms / 1.3968255 for PAL)

IRQCIATest:
;	cmp.b	#1,RASTER-V(a6)			; Check if we have a working raster, if not we are unable to
;	bne	.noraster			; count frames (for timing) so not possible to perform tests

	bsr	InitScreen

	lea	CIATestTxt,a0
	move.w	#2,d1
	bsr	Print
	lea	CIATestTxt2,a0
	move.w	#2,d1
	bsr	Print
	lea	DoesNotWorkTxt,a0
	move.w	#1,d1
	bsr	Print
	bra	.done
.loop:
	bsr	GetInput
	cmp.b	#$1b,GetCharData-V(a6)
	beq	IRQCIAtestMenu
	cmp.b	#1,RMB-V(a6)
	beq	IRQCIAtestMenu

	cmp.b	#1,BUTTON-V(a6)
	bne.s	.loop



	clr.l	d7
	clr.l	d6


.aa:
	cmp.b	#$40,$dff006
	bne.s	.aa
	move.w	#$fff,$dff180

	move.b	$dff006,d7

.l1:
	cmp.b	$dff006,d7
	bne.s	.l1
	add.l	#1,d6


	bchg	#1,$bfe001

.ab:
	cmp.b	#$80,$dff006
	bls.s	.l1
	move.w	#$000,$dff180


	btst	#6,$bfe001
	bne.s	.aa
.ac:
	bra	.kuk


	move.b	$bfee01,d0
	and.b	#%11000000,d0
	or.b	#%00001000,d0
	move.b	d0,$bfee01
	move.b	#%01111111,$bfed01

	clr.l	d6
	clr.l	d5
	move.l	#600,d7

.TIME:	equ	7050/2
	move.b	#(.TIME&$FF),$bfe401
	move.b	#(.TIME>>8),$bfe501

	move.b	$dff006,d4
.busy_wait:
	cmp.b	$dff006,d4
	bne.s	.notyet
	cmp.b	#0,d5
	bne	.rowdone
	add.l	#1,d6
	move.b	#1,d5
	bra	.rowdone

.notyet:	
	cmp.b	#0,d5
	bne	.nonew
	clr.b	d5
.rowdone:
	
.nonew:
	btst	#0,$bfed01
	beq.s	.busy_wait
	move.b	d4,$dff181

	bchg	#1,$bfe001
	bset.b	#0,$bfee01
	dbf	d7,.busy_wait
;	dbf	d7,busy_wait

.kuk:

	move.l	d6,d0
	bsr	bindec
	move.l	#2,d1
	bsr	Print
	bra	.done


;	lea	CIATestTxt3,a0
;	move.w	#4,d1
;	bsr	Print
	lea	CIATestTxt5,a0
	move.w	#4,d1
	bsr	Print

	lea	CIATestTxt4,a0
	move.w	#6,d1
	bsr	Print

	lea	CIAATestAATxt,a0
	move.l	#3,d1
	bsr	Print
	lea	$bfe401,a0			; load a0 with timerreg
	lea	$bfee01,a1			; load a1 with controlreg
	move.l	#1680400,CIAPalLow-V(a6)
	move.l	#1686200,CIAPalHigh-V(a6)
	move.l	#1411000,CIANtscLow-V(a6)
	move.l	#1417000,CIANtscHigh-V(a6)
	bsr	.CiaTest
	bsr	.CiaResult

	bra	.done	

	lea	CIAATestBATxt,a0
	move.l	#3,d1
	bsr	Print
	lea	$bfe601,a0
	lea	$bfef01,a1

	bsr	.CiaTest
	bsr	.CiaResult

	move.l	#98,CIAPalLow-V(a6)
	move.l	#102,CIAPalHigh-V(a6)
	move.l	#98,CIANtscLow-V(a6)
	move.l	#121,CIANtscHigh-V(a6)


	lea	CIATestATOD,a0
	move.l	#3,d1
	bsr	Print
	bsr	.TestTODA
	move.l	d0,d5
	bsr	.CiaResult

	move.l	#1680400,CIAPalLow-V(a6)
	move.l	#1686200,CIAPalHigh-V(a6)
	move.l	#1411000,CIANtscLow-V(a6)
	move.l	#1417000,CIANtscHigh-V(a6)



	lea	CIAATestABTxt,a0
	move.l	#3,d1
	bsr	Print
	lea	$bfd400,a0
	lea	$bfde00,a1
	bsr	.CiaTest
	bsr	.CiaResult


	lea	CIAATestBBTxt,a0
	move.l	#3,d1
	bsr	Print
	lea	$bfd600,a0
	lea	$bfdf00,a1
	bsr	.CiaTest
	bsr	.CiaResult


	move.l	#780000,CIAPalLow-V(a6)
	move.l	#800000,CIAPalHigh-V(a6)
	move.l	#780000,CIANtscLow-V(a6)
	move.l	#800000,CIANtscHigh-V(a6)


	lea	CIATestBTOD,a0
	move.l	#3,d1
	bsr	Print
	bsr	.TestTODB
	move.l	d0,d5
	bsr	.CiaResult

.done:

	jsr	ClearBuffer

.keyloop:
	bsr	GetInput
	cmp.b	#1,BUTTON-V(a6)
	bne.s	 .keyloop
	bra	IRQCIAtestMenu

.CiaResult:
	bsr	.CiaVerbose	

	move.l	d5,d0
	bsr	bindec
	move.l	#3,d1
	bsr	Print


	lea	NewLineTxt,a0
	bsr	Print

	rts

.CiaVerbose:
	move.l	CIAPalLow-V(a6),d6
	cmp.l	d5,d6
	bge	.pallow
	bra	.palnotlow
.pallow:
	bsr	.CiaVerboseLow
	bra	.palnotok
.palnotlow:
	move.l	CIAPalHigh-V(a6),d6
	cmp.l	d5,d6
	ble	.palhigh
	bra	.palnothigh
.palhigh:
	bsr	.CiaVerboseHigh
	bra	.palnotok
.palnothigh:;

	bsr	.CiaVerboseOK
.palnotok:

	move.l	CIANtscLow-V(a6),d6
	cmp.l	d5,d6
	bge	.CiaVerboseLow
	move.l	CIANtscHigh-V(a6),d6
	cmp.l	d5,d6
	ble	.CiaVerboseHigh
	bsr	.CiaVerboseOK

	rts


.CiaVerboseLow:
	lea	CIATooSlow,a0
	move.l	#1,d1
	bsr	Print
	rts	
.CiaVerboseHigh:
	lea	CIATooFast,a0
	move.l	#1,d1
	bsr	Print
	rts	
.CiaVerboseOK:
	lea	CIAOK,a0
	move.l	#2,d1
	bsr	Print
	rts

.CiaTest:
	cmp.b	#$ff,$dff006
	bne.s	.CiaTest


	clr.l	d0
	moveq	#-1,d0
	move.b	d0,(a0)
	move.b	d0,$100(a0)
	move.b	#%00011001,(a1)

	clr.l	d5
	move.l	#29,d6
.loopb:
	move.l	#3,d7
.loopa:


	move.w	#$00f,$dff180
.waitframe2:
	cmp.b	#$f0,$dff006
	bne.s	.waitframe2
.waitframe3:
	cmp.b	#$f1,$dff006
	bne.s	.waitframe3


	move.w	#$0,$dff180
	dbf	d7,.loopa
	move.b	#$0,(a1)
	move.b	$100(a0),d1
	move.b	(a0),d2
	moveq	#-1,d0
	lsl	#8,d1
	move.b	d2,d1
	sub.w	d1,d0
	swap	d0
	clr.w	d0
	swap	d0
	add.l	d0,d5
	dbf	d6,.loopb

	rts

.TestTODA:
	cmp.b	#$ff,$dff006
	bne.s	.TestTODA

	bclr	#7,$bfef01
	move.b	#0,$bfea01
	move.b	#0,$bfe901
	move.b	#0,$bfe801
		
	move.l	#99,d7
.loopaa:

	move.w	#$00f,$dff180
.todwaitframe2:
	cmp.b	#$f0,$dff006
	bne.s	.todwaitframe2
.todwaitframe3:
	cmp.b	#$f1,$dff006
	bne.s	.todwaitframe3
	move.w	#$0,$dff180
	dbf	d7,.loopaa


	moveq	#0,d6
	move.b	$bfea01,d6
	lsl.l	#8,d6
	move.b	$bfe901,d6
	lsl.l	#7,d6
	move.b	$bfe801,d6
	move.l	d6,d0
	rts


.TestTODB:
	cmp.b	#$ff,$dff006
	bne.s	.TestTODB

	bclr	#7,$bfdf00
	move.b	#0,$bfda00
	move.b	#0,$bfd900
	move.b	#0,$bfd800
		
	move.l	#99,d7
	clr.l	d0
.loopab:

	move.w	#$00f,$dff180
.todbwaitframe2:
	cmp.b	#$f0,$dff006
	bne.s	.todbwaitframe2
.todbwaitframe3:
	cmp.b	#$f1,$dff006
	bne.s	.todbwaitframe3
	move.w	#$0,$dff180

	moveq	#0,d6
	move.b	$bfda00,d6
	lsl.l	#8,d6
	move.b	$bfd900,d6
	lsl.l	#7,d6
	move.b	$bfd800,d6
	add.l	d6,d0
	dbf	d7,.loopab

	rts




IRQCIACIATest:
	cmp.b	#1,RASTER-V(a6)			; Check if we have a working raster, if not we are unable to
	bne	.noraster			; count frames (for timing) so not possible to perform tests

	bsr	InitScreen


	lea	CIATestTxt,a0
	move.w	#2,d1
	bsr	Print
	lea	CIATestTxt2,a0
	move.w	#2,d1
	bsr	Print
.loop:
	bsr	GetInput
	cmp.b	#$1b,GetCharData-V(a6)
	beq	IRQCIAtestMenu
	cmp.b	#1,RMB-V(a6)
	beq	IRQCIAtestMenu

	cmp.b	#1,BUTTON-V(a6)
	bne.s	.loop

	lea	CIATestTxt3,a0
	move.w	#4,d1
	bsr	Print


	move.w	#$7fff,$dff09a			; Kill all chip interrupts


	lea	CIAATestAATxt,a0
	lea	$bfe001,a5			; load a5 with a base
	lea	$bfe001,a4			; load a5 with a base
	lea	$bfee01,a3			; load a5 with a base
	move.l	#0,d2
	move.l	#7,d5	
	bsr	.TestCIA


	lea	CIAATestBATxt,a0
	lea	$bfe201,a5			; load a5 with a base
	lea	$bfe001,a4			; load a5 with a base
	lea	$bfef01,a3			; load a5 with a base
	move.l	#1,d2
	move.l	#8,d5	
	bsr	.TestCIA

	bsr	TestATOD

	lea	CIAATestABTxt,a0
	lea	$bfd000,a5			; load a5 with a base
	lea	$bfd000,a4			; load a5 with a base
	lea	$bfde00,a3			; load a5 with a base
	move.l	#0,d2
	move.l	#10,d5	
	bsr	.TestCIA


	lea	CIAATestBBTxt,a0
	lea	$bfd200,a5			; load a5 with a base
	lea	$bfd000,a4			; load a5 with a base
	lea	$bfdf00,a3			; load a5 with a base
	move.l	#1,d2
	move.l	#11,d5	
	bsr	.TestCIA

	bsr	TestBTOD


	jsr	ClearBuffer

	lea	ButtonExit,a0
	move.l	#1,d0
	bsr	Print


.keyloop:
	bsr	GetInput
	cmp.b	#1,BUTTON-V(a6)
	bne.s	 .keyloop

	bra	IRQCIAtestMenu
	
.noraster:					; We had no working raster, print errormessage
	bsr	InitScreen			; and prompt for keypress to go back to mainmenu.
	lea	CIANoRasterTxt,a0
	move.w	#1,d1
	bsr	Print
	lea	CIANoRasterTxt2,a0
	move.w	#2,d1
	bsr	Print
.nrloop:
	bsr	GetInput
	cmp.b	#1,BUTTON-V(a6)
	bne.s	.nrloop
	bra	MainMenu



.TestCIA:

	clr.l	d0
	move.l	d5,d1
	bsr	SetPos
	
	move.l	#3,d1
	bsr	Print


	clr.w	Frames-V(a6)			; Clear number frames
	clr.w	TickFrame-V(a6)
	clr.l	Ticks-V(a6)

	move.l	#CIALevTst,$6c			; Set up IRQ Level 3
	move.w	#$c020,$dff09a			; Enable IRQ
	move.w	#$c020,$dff09a			; Enable IRQ

	move.w	#$2000,sr			; Set SR to allow IRQs


	move.b	(a3),d0				; Set control register A on CIAA
	move.b	d0,CIACtrl-V(a6)
	andi.b	#$c0,d0				; Do not touch bits we are not
	ori.b	#8,d0				; Using...
	move.b	d0,(a3)



	move.w	#7812,d6
	clr.l	d7


.loopa:
	move.l	#$f0,$dff180

	move.b	$400(a5),CIACtrl-V+1(a6)
	move.b	$500(a5),CIACtrl-V+2(a6)

	move.b	#(CIATIME&$FF),$400(a5)
	move.b	#(CIATIME>>8),$500(a5)			; Set registers to wait for 10000ms

.wait:
	move.w	#$0,$dff180

	cmp.w	#120,Frames-V(a6)
	bge	.vblankoverrun

	btst	d2,$d00(a4)
	beq	.wait
	add.l	#1,Ticks-V(a6)
	move.w	#$f,$dff180
.no:

	dbf	d6,.loopa				; Repeat this so we are doing it for a while
	bset	#0,(a3)
	clr.l	d6				; Clear D6, meaning we have executed this without Vblank overrun

	bra	.exit

.vblankoverrun:	
	move.l	#1,d6				; Set it as 1, to mark we had a overrun

.exit:

	move.w	#$7fff,$dff09c			; Disable all INTREQ
	move.w	#$7fff,$dff09a			; Disable all INTREQ

	move.l	#RTEcode,$6c			; Restore IRC Vector to empty code

	move.b	CIACtrl-V(a6),(a3)
	move.b	CIACtrl-V+1(a6),$400(a5)
	move.b	CIACtrl-V+2(a6),$500(a5)
	

	move.w	Frames-V(a6),TickFrame-V(a6)

	move.l	#35,d0
	move.l	d5,d1
	bsr	SetPos

	move.l	Ticks-V(a6),d0
	asl.l	#8,d0

	bsr	bindec
	move.w	#2,d1
	bsr	Print
	lea	ms,a0
	bsr	Print


	move.w	TickFrame-V(a6),d0

;	cmp.w	#105,d0
;	bge	.underrun
	cmp.w	#95,d0
	ble	.underrun
	bra	.nounderrun

.underrun:
	lea	VblankUnderrunTXT,a0
	move.l	#1,d1
	bsr	Print
	move.l	#2,d6
	bra	.nooverrun

.nounderrun:

	cmp.b	#1,d6
	bne	.nooverrun
	lea	VblankOverrunTXT,a0
	move.l	#1,d1
	bsr	Print
	
.nooverrun:

	cmp.b	#0,d6				; Check d6, if it isnt 0, we had a failure
	beq	.nooverrun2

	move.l	#70,d0
	move.l	d5,d1
	bsr	SetPos

	lea	FAILED,a0
	move.w	#1,d1
	bsr	Print
	rts
		
.nooverrun2:
	move.l	#70,d0
	move.l	d5,d1
	bsr	SetPos
	lea	OK,a0
	move.l	#2,d1
	bsr	Print



	rts
	
	clr.l	d0
	move.l	#1,d1
	bsr	SetPos
	clr.l	d0
	move.w	TickFrame-V(a6),d0
	bsr	bindec
	move.l	#3,d1
	bsr	Print

	rts

CIALevTst:
	move.w	#$020,$dff09c			; Enable IRQ
	move.w	#$020,$dff09c			; Enable IRQ
	add.w	#1,Frames-V(a6)				; Add 1 to Frames so we can keep count of frames shown.

							; (or VBlanks)
	TOGGLEPWRLED
.no:
	rte





TestATOD:
	lea	CIATestATOD,a0
	clr.l	d0
	move.l	#9,d1
	bsr	SetPos
	
	move.l	#3,d1
	bsr	Print


	clr.w	Frames-V(a6)			; Clear number frames
	clr.l	Ticks-V(a6)

	move.l	#CIALevTst,$6c			; Set up IRQ Level 3
	move.w	#$c020,$dff09a			; Enable IRQ
	move.w	#$c020,$dff09a			; Enable IRQ;
;	move.w	$dff01c,$d7
	bclr	#7,$bfef01
	move.b	#0,$bfea01
	move.b	#0,$bfe901
	move.b	#0,$bfe801

.loopa:

	moveq	#0,d6
	move.b	$bfea01,d6
	lsl.l	#8,d6
	move.b	$bfe901,d6
	lsl.l	#7,d6
	move.b	$bfe801,d6


	cmp.l	Ticks-V(a6),d6
	beq.s	.no
	move.w	#$f,$dff180
.no:

	move.l	d6,Ticks-V(a6)

	clr.l	d0
	move.l	#10,d1
	bsr	SetPos
	clr.l	d0

	cmp.w	#100,Frames-V(a6)		; Check if we have tested for 200 VBlanks
	blt	.loopa


	move.w	#$7fff,$dff09c			; Disable all INTREQ
	move.w	#$7fff,$dff09a			; Disable all INTREQ

	move.l	#RTEcode,$6c			; Restore IRC Vector to empty code



	move.l	#35,d0
	move.l	#9,d1
	bsr	SetPos

	move.l	Ticks-V(a6),d0

	bsr	bindec
	move.w	#2,d1
	bsr	Print
	lea	ticks,a0
	bsr	Print



	cmp.l	#95,d6
	ble	.tooslow
	cmp.l	#105,d6
	bge	.toofast

	move.l	#70,d0
	move.l	#9,d1
	bsr	SetPos

	lea	OK,a0
	move.w	#2,d1
	bsr	Print
	rts

.tooslow:
	move.l	#1,d1
	lea	CIATickSlowTxt,a0
	bsr	Print
	move.l	#70,d0
	move.l	#9,d1
	bsr	SetPos
	lea	FAILED,a0
	move.l	#1,d1
	bsr	Print

	rts
.toofast:
	move.l	#1,d1
	lea	CIATickFastTxt,a0
	bsr	Print
	move.l	#70,d0
	move.l	#9,d1
	bsr	SetPos
	lea	FAILED,a0
	move.l	#1,d1
	bsr	Print

	rts




TestBTOD:
	lea	CIATestBTOD,a0
	clr.l	d0
	move.l	#12,d1
	bsr	SetPos
	
	move.l	#3,d1
	bsr	Print


	clr.w	Frames-V(a6)			; Clear number frames
	clr.l	Ticks-V(a6)

	move.l	#CIALevTst,$6c			; Set up IRQ Level 3
	move.w	#$c020,$dff09a			; Enable IRQ
	move.w	#$c020,$dff09a			; Enable IRQ;
;	move.w	$dff01c,$d7
	bclr	#7,$bfdf00
	move.b	#0,$bfda00
	move.b	#0,$bfd900
	move.b	#0,$bfd800

.loopa:

	moveq	#0,d6
	move.b	$bfda00,d6
	lsl.l	#8,d6
	move.b	$bfd900,d6
	lsl.l	#8,d6
	move.b	$bfd800,d6


	cmp.l	Ticks-V(a6),d6
	beq.s	.no
	move.w	#$f,$dff180
.no:

	move.l	d6,Ticks-V(a6)

	clr.l	d0
	move.l	#12,d1
	bsr	SetPos
	clr.l	d0

	cmp.w	#100,Frames-V(a6)		; Check if we have tested for 200 VBlanks
	ble	.loopa


	move.w	#$7fff,$dff09c			; Disable all INTREQ
	move.w	#$7fff,$dff09a			; Disable all INTREQ

	move.l	#RTEcode,$6c			; Restore IRC Vector to empty code



	move.l	#35,d0
	move.l	#12,d1
	bsr	SetPos

	move.l	Ticks-V(a6),d0

	bsr	bindec
	move.w	#2,d1
	bsr	Print
	lea	ticks,a0
	bsr	Print



	cmp.l	#30000,d6
	ble	.tooslow
	cmp.l	#32000,d6
	bge	.toofast
	
	move.l	#70,d0
	move.l	#12,d1
	bsr	SetPos

	lea	OK,a0
	move.w	#2,d1
	bsr	Print
	rts

.tooslow:
	move.l	#1,d1
	lea	CIATickSlowTxt,a0
	bsr	Print
	move.l	#70,d0
	move.l	#12,d1
	bsr	SetPos
	lea	FAILED,a0
	move.l	#1,d1
	bsr	Print

	rts
.toofast:
	move.l	#1,d1
	lea	CIATickFastTxt,a0
	bsr	Print
	move.l	#70,d0
	move.l	#12,d1
	bsr	SetPos
	lea	FAILED,a0
	move.l	#1,d1
	bsr	Print

	rts





;------------------------------------------------------------------------------------------




GFXtestMenu:
	bsr	InitScreen
	move.w	#5,MenuNumber-V(a6)
	move.b	#1,PrintMenuFlag-V(a6)
	bra	MainLoop

GFXTestScreen:
	ifeq	a1k
	
	bsr	ClearScreen
	move.l	#EndTestPic-TestPic,d0
	move.l	d0,d2
	bsr	GetChip
	cmp.l	#0,d0
	beq	.exit
	cmp.l	#1,d0
	beq	.exit
	move.l	#LOWRESSize,d1
	lea	ECSCopper-V(a6),a0			; Location of copperlist in memory
	lea	ECSTestColor,a1
	bsr	FixECSCopper


	move.l	d0,a0					; Copy the address of start of screen to a0
	lea	TestPic,a1				; Set a1 to where testscreen is in ROM
.loop:
	move.b	(a1)+,(a0)+				; Copy testimage to Chipmem
	dbf	d2,.loop

.exit:
	bsr	WaitButton

	bsr	SetMenuCopper
	bra	GFXtestMenu

	else

	bra	Not1K

	endc

GFXtest320x200:

	move.w	#$83f0,$dff096				; Turn on all DMA required


	bsr	ClearScreen
	move.l	#HIRESSize*5,d0
	bsr	GetChip
	cmp.l	#0,d0
	beq	.exit
	cmp.l	#1,d0
	beq	.exit
	move.l	#HIRESSize,d1
	lea	ECSCopper-V(a6),a0			; Location of copperlist in memory
	lea	ECSColor32,a1

	bsr	FixECSCopper

	clr.l	d0
	clr.l	d1
	move.l	#640,d2
	move.l	#512,d3
	move.l	#6,d4
	bsr	DrawLine

	move.l	#640,d0
	clr.l	d1
	clr.l	d2
	move.l	#512,d3
	move.l	#6,d4
	bsr	DrawLine



	move.l	#640,d7
	move.l	#1,d2
	clr.l	d0
.loop6:
	move.l	#236,d1
	move.l	#40,d6
.loop5:
	bsr	PlotPixel
	add.l	#1,d1
	dbf	d6,.loop5
	move.l	d7,d2
	asr	#4,d2

	add.l	#1,d0
	dbf	d7,.loop6



	clr.l	d0
	move.l	#511,d1
.loop:
	move.l	#1,d2
	bsr	PlotPixel
	dbf	d1,.loop
	move.l	#640,d0
.loop2:
	move.l	#511,d1
	move.l	#1,d2
	bsr	PlotPixel
	dbf	d0,.loop2

	move.l	#639,d0
	move.l	#511,d1
.loop3:
	move.l	#1,d2
	bsr	PlotPixel
	dbf	d1,.loop3

	move.l	#639,d0
	clr.l	d1
.loop4:
	move.l	#1,d2
	bsr	PlotPixel
	dbf	d0,.loop4






	



	bsr	WaitButton

	move.w	#$3ff,$dff096				; Turn off all DMA
	
.exit:
	bsr	SetMenuCopper
	bsr	GFXtestMenu



GFXTestScroll:
	ifeq	a1k
	
	bsr	ClearScreen
	move.l	#EndTestPic-TestPic+4096,d0
	move.l	d0,d2
	bsr	GetChip
	cmp.l	#0,d0
	beq	.exit
	cmp.l	#1,d0
	beq	.exit
	move.l	#LOWRESSize+1024,d1
	lea	ECSCopper2-V(a6),a0			; Location of copperlist in memory
	lea	ECSTestColor,a1
	bsr	FixECSCopper2


	move.l	d0,a0					; Copy the address of start of screen to a0
	move.l	d0,d7					; Make a backup of address
	lea	TestPic,a1				; Set a1 to where testscreen is in ROM


	move.w	#1279,d4
.loop2:
	move.w	#39,d3
.loop:
	move.b	(a1)+,(a0)+				; Copy testimage to Chipmem
	dbf	d3,.loop
	add.l	#4,a0
	dbf	d4,.loop2



	add.l	#62*44,d7
.scrollloop:
	cmp.b	#$bf,$dff006
	bne	.scrollloop
	bsr	.blit

	bsr	GetInput
	cmp.b	#1,BUTTON-V(a6)
	bne	.scrollloop
	
.exit:
	bsr	SetMenuCopper
	bra	GFXtestMenu


.blit:
	PUSH
	move.w	#4,d6
.blitloop:
	move.w	#113,d4
	move.l	d7,a0
	lea	JunkBuffer-V(a6),a1
.copyloop:
	move.b	(a0),d5
	and.b	#%10000000,d5
	lsr.l	#7,d5
	move.b	d5,(a1)+
	add.l	#44,a0
	dbf	d4,.copyloop
	
	clr.w	$dff042
	move.w	#$ffff,$dff044
	move.w	#$ffff,$dff046
	move.w	#$8040,$dff096
	move.w	#$f9f0,$dff040
	move.l	d7,d0
	sub.l	#2,d0
	move.l	d0,d1
	add.l	#2,d1
	move.l	d1,$dff050
	move.l	d0,$dff054
	move.w	#0,$dff066
	move.w	#0,$dff064	
	move.w	#114*64+22,$dff058
	move.b	d5,40(a0)
	VBLT

	move.w	#113,d4
	move.l	d7,a0
	lea	JunkBuffer-V(a6),a1
.copyloop2:
	move.b	(a1)+,d5
	and.b	#254,39(a0)
	or.b	d5,39(a0)
	add.l	#44,a0
	dbf	d4,.copyloop2


	add.l	#LOWRESSize+1024,d7
	dbf	d6,.blitloop

	POP
	rts


	else

	bra	Not1K

	endc




GFXTestRaster:
	bsr	ClearScreen
	move.l	#3,d1
	lea	GFXtestRasterTxt,a0
	bsr	Print
	lea	GFXtestRasterTxt2,a0
	bsr	Print

.loopa:
	bsr	GetInput
	move.l	#70,d0
	move.l	#160,d1
.loop:
	cmp.b	$dff006,d0
	bne	.loop
	add.b	#1,d0			; Wait for next rasterline
	move.b	d0,$dff181
	dbf	d1,.loop
	move.w	#0,$dff180
	cmp.b	#1,BUTTON-V(a6)
	bne	.loopa
	bra	GFXtestMenu


GFXTestRGB:
	bsr	ClearScreen

	move.l	#257*40,d0					; Amount of memory needed for one bitplan
	add.l	#GFXColTestCopperEnd-GFXColTestCopperStart,d0	; Add for size of copperlist
	bsr	GetChip						; Get chipmem needed.
	cmp.l	#2,d0						; Check if 2 or lower
	ble	GFXtestMenu					; if so just exit (I know. bad move not to tell user)


	move.l	d0,a2						; Put start of memory in A2

	move.l	#$ffffffff,10(a2)
	move.l	#$ffffffff,22(a2)


	add.l	#40,a2

	move.l	#$ffffffff,16(a2)
	move.l	#$ffffffff,22(a2)



	move.l	d0,d5						; Make a backup of this address


	add.l	#80,d0						; Add 80 to d0, so we put copperlist after the "bitplane"
	move.l	d0,a2
	move.l	d0,d6




	lea	GFXColTestCopperStart,a1
	add.l	#GFXColTestCopperEnd-GFXColTestCopperStart,d7	; Add for size of copperlist
.loop:
	move.b	(a1)+,(a2)+
	dbf	d7,.loop					; Copy in copperlist to start of memory


	move.l	d0,a0
	add.l	#GFXColTestCopperWait-GFXColTestCopperStart,a0	; Fix a0 to where the wait block in copper list starts
	clr.l	d2						; Clear the testcolor

	move.l	a0,a1
	sub.l	#4*4-2,a1					; a1 will now contain address of bitplanepointers

	move.l	d5,d4
	swap	d4
	move.w	d4,(a1)
	add.l	#4,a1
	move.w	d5,(a1)
	add.l	#4,a1

	add.l	#40,d5						; Add for next bitplane

	move.l	d5,d4
	swap	d4
	move.w	d4,(a1)
	add.l	#4,a1
	move.w	d5,(a1)
	add.l	#4,a1


	
	move.b	#$18,d1						; What ROW to start colors at
	move.l	#15,d7						; Number of colors
	move.l	a0,SHIT-V(a6)
.createloop:

	move.l	#$0001ff00,(a0)					; Write the wait command to copperlist
	move.b	d1,(a0)						; Replace first byte with the real row
	add.l	#4,a0
	move.w	#$0180,(a0)+
	move.w	#$fff,(a0)+
	
	move.w	#$0182,(a0)+
	move.w	d2,d3
	asl.w	#8,d3						; Make color red
	move.w	d3,(a0)+

	move.w	#$0184,(a0)+
	move.w	d2,d3
	asl.w	#4,d3						; Make color green
	move.w	d3,(a0)+

	move.w	#$0186,(a0)+
	move.w	d2,(a0)+					; Write color as blue

	add.b	#1,d1

	move.l	#$0001ff00,(a0)					; Write the wait command to copperlist
	move.b	d1,(a0)						; Replace first byte with the real row
	add.l	#4,a0
	move.w	#$0180,(a0)+
	move.w	#$0,(a0)+



	add.w	#1,d2
	add.b	#$e,d1
	dbf	d7,.createloop


	move.l	#$0001ff00,(a0)					; Write the wait command to copperlist
	move.b	d1,(a0)						; Replace first byte with the real row
	add.l	#4,a0
	move.w	#$0180,(a0)+
	move.w	#$fff,(a0)+

	add.b	#1,d1
	move.l	#$0001ff00,(a0)					; Write the wait command to copperlist
	move.b	d1,(a0)						; Replace first byte with the real row
	add.l	#4,a0
	move.w	#$0180,(a0)+
	move.w	#$0,(a0)+

	add.b	#$e,d1

	move.l	#$0001ff00,(a0)					; Write the wait command to copperlist
	move.b	d1,(a0)						; Replace first byte with the real row
	add.l	#4,a0
	move.w	#$0180,(a0)+
	move.w	#$fff,(a0)+

	add.b	#1,d1
	move.l	#$0001ff00,(a0)					; Write the wait command to copperlist
	move.b	d1,(a0)						; Replace first byte with the real row
	add.l	#4,a0
	move.w	#$0180,(a0)+
	move.w	#$0,(a0)+


;	move.l	#$0001ff00,(a0)					; Write the wait command to copperlist
;	move.b	d1,(a0)						; Replace first byte with the real row


	lea	InitCOP1LCH,a0
	bsr	SendSerial

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
	move.w	#32,$dff1dc
	lea	InitDONEtxt,a0
	bsr	SendSerial

	lea	GFXtestNoSerial,a0
	bsr	SendSerial

.loopa:
	bsr	GetInput

	cmp.b	#1,BUTTON-V(a6)
	bne	.loopa


	bsr	SetMenuCopper

	bra	GFXtestMenu


							; INDATA:
							;	a0 = ECSCopperlist
							;	a1 = List of colors to be set
							;	d0 = Startaddress of space
							;	d1 = Size of bytes of one screen

FixECSCopper:
	PUSH
	add.l	#96,a0					; Add so we get to the spot where palette starts.
	move.l	#31,d7
	move.w	#$180,d6				; Start with $180
.loop:
	move.w	d6,(a0)+
	move.w	(a1)+,(a0)+
	add.w	#2,d6
	dbf	d7,.loop				; Loop around and do all colors
	


	move.l	d0,d6

	lea	GfxTestBpl-V(a6),a2

	move.l	#4,d7
.loop2:
	move.l	d6,(a2)+
	move.w	d6,6(a0)
	swap	d6
	move.w	d6,2(a0)
	swap	d6
	add.l	#8,a0
	add.l	d1,d6
	dbf	d7,.loop2				; Set all bitplanepointers




.Slut:


	lea	InitCOP1LCH,a0
	bsr	SendSerial
	move.l	a6,d0
	add.l	#ECSCopper-V,d0
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

	lea	GFXtestNoSerial,a0
	bsr	SendSerial
;.exit:
	POP
	rts


FixECSCopper2:
	PUSH
	add.l	#96,a0					; Add so we get to the spot where palette starts.
	move.l	#31,d7
	move.w	#$180,d6				; Start with $180
.loop:
	move.w	d6,(a0)+
	move.w	(a1)+,(a0)+
	add.w	#2,d6
	dbf	d7,.loop				; Loop around and do all colors
	


	move.l	d0,d6

	lea	GfxTestBpl-V(a6),a2

	move.l	#4,d7
.loop2:
	move.l	d6,(a2)+
	move.w	d6,6(a0)
	swap	d6
	move.w	d6,2(a0)
	swap	d6
	add.l	#8,a0
	add.l	d1,d6
	dbf	d7,.loop2				; Set all bitplanepointers




.Slut:


	lea	InitCOP1LCH,a0
	bsr	SendSerial
	move.l	a6,d0
	add.l	#ECSCopper2-V,d0
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

	lea	GFXtestNoSerial,a0
	bsr	SendSerial
;.exit:
	POP
	rts




DrawLine:							
	PUSH
	asr	#1,d0
	asr	#1,d1
	asr	#1,d2
	asr	#1,d3
	lea	GfxTestBpl-V(a6),a5		; Load pointerlist for bitplanes
	move.l	#4,d7				; number of bitplanes to handle - 1
	clr.l	d6				; Clear d6, d6 is bit to test for palette
	move.l	#40,a1
.loop:
	move.l	(a5)+,a0				; A0 now contains address of bitplane
	btst	d6,d4				; Check if pixel is to be set of cleared
	bne.s	.set				; it is to be set
	bra.s	.clear				; if not, clear it

		
.set:
	move.l	#$ffffffff,a2
	bsr	.DrawLine
	bra	.done
.clear:
	move.l	#$0,a2
	bsr	.DrawLine
.done:
	add.l	#1,d6
	dbf	d7,.loop

	POP

	rts


.DrawLine:
	; d0 = x1
	; d1 = y1
	; d2 = x2
	; d3 = y2
	; a0 = Bitplanr
	; a1 = bitplanewidth in bytes
	; a2 = word written directly to mast register
	PUSH
;	asr.l	#1,d0
;	asr.l	#1,d1
;	asr.l	#1,d2
;	asr.l	#1,d3
	clr.l	d5	
	cmp.w	#320,d0
	ble	.nohighx1
	rts
.nohighx1:	
	cmp.w	#256,d1
	ble	.nohighy1
	rts
.nohighy1:	
	cmp.w	#640,d2
	ble	.nohighx2
	rts
.nohighx2:	
	cmp.w	#256,d3
	ble	.nohighy2
	rts
.nohighy2:	
	clr.l	d4
	add.w	d4,d2
	add.w	d4,d3

	move.l	a1,d4			; Width in work register
	mulu	d1,d4			;Y1 * byte per line
	moveq	#-$10,d5		; No leading characters $f0
	and.w	d0,d5			; Bottom four bits masked from x1
	lsr.w	#3,d5			; Reminder divided by 8
	add.w	d5,d4			; Y1 * bytes per line + x1/8
	add.l	a0,d4			; Plus startong adress of the bitplanes

	clr.l	d5
	sub.w	d1,d3			; Y2-Y1 DeltaY from D3
	roxl.b	#1,d5			; Shift leading char from DeltaY in D5
	tst.w	d3			; Restore N-Flag
	bge.s	.y2gy1			; When DeltaY positive, goto g2gy1
	neg.w	d3			; DeltaY invert (if not positive)

.y2gy1:
	sub.w	d0,d2			; X2-X1 DeltaX to D2
	roxl.b	#1,d5			; move leading char in DeltaX to d5
	tst.w	d2			; Restore N-Flag
	bge.s	.x2gx1			; When Delta X positive
	neg.w	d2			; DeltaX invert

.x2gx1:
	move.w	d3,d1			; DeltaY to d1
	sub.w	d2,d1			; DeltaY-DeltaX
	bge.s	.dygdx			; When DeltaY > DeltaX
	exg	d2,d3			; Smaller delta goto d2
.dygdx:	
	roxl.b	#1,d5			; D5 contains result of 3 comparisons
	lea	Octant_Table,a5
	move.b	(a5,d5),d5		; Get matching octants
	add.w	d2,d2			; Smaller Delta * 2

	VBLT

	move.w	d2,$dff062		;2*Smaller delta tp BLTBMOD
	sub.w	d3,d2			; 2*smaller delta - larger delta
	ble.s	.signn1			;When 2*small delta > largedelta to signn1

	or.b	#$40,d5			;Sign flag set
.signn1:
	move.w	d2,$dff052		; 2*smal delta - large delta in BLTAPTL
	sub.w	d3,d2			; 2*smaller delta -2*larger delta
	move.w	d2,$dff064		; tp BLTAMOD

	move.w	#$8000,$dff074		; BLTADAT
	move.w	a2,$dff072		; mask from a2 in BLTBDAT
	move.w	#$ffff,$dff044		; BLTAFWM
	and.w	#$000f,d0		; Bottom 4 bits from X1
	ror.w	#4,d0			; to START0-3
	or.w	#$0bca,d0		; USEx and LFx set
	move.w	d0,$dff040		; BLTCON0
	move.w	d5,$dff042		; Octant ib blitter BLTCON1
	move.l	d4,$dff048		; Start adress of line  BLTCPTH
	move.l	d4,$dff054		; BLTDPTH
	move.w	a1,$dff060		; Width of bitplanes i both BLTCMOD
	move.w	a1,$dff066		; and BLTDMOD registers

	lsl.l	#6,d3			; Length * 64
	addq.w	#2,d3			; Plus wodth=2
	move.w	d3,$dff058		; set size and start blit
	POP
	rts

PlotPixel:						; Plots a pixel
							; INDATA:
							;	D0 = XPos
							;	D1 = YPos
							;	D2 = Color
							
	PUSH

	asr.l	#1,d0
	asr.l	#1,d1

	move.l	d0,d4				; Make a copy of the X Cordinate
	asr	#3,d0				; Divide te XCordinate with 8 to get what byte to do stuff on
	move.l	d0,d3				; Make a copy of this byte
	asl	#3,d3				; multiply it with 8
	sub.l	d3,d4				; Diff it, so we know what BIT to set

	move.l	#7,d5				; But as it is "reversed" put 7 into d5 and
	sub.l	d4,d5				; Subtract but to do stuff in, d5 now contains bit

	mulu	#40,d1				; Multiply with 40 to get Y position

	add.l	d1,d0				; Add d1 to d0. so d0 now contains how much to add for the pixel

	lea	GfxTestBpl-V(a6),a2		; Load pointerlist for bitplanes
	move.l	#4,d7				; number of bitplanes to handle - 1
	clr.l	d6				; Clear d6, d6 is bit to test for palette

.loop:
	move.l	(a2)+,a0				; A0 now contains address of bitplane
	btst	d6,d2				; Check if pixel is to be set of cleared
	bne.s	.set				; it is to be set
	bra.s	.clear				; if not, clear it

		
.set:
	bset	d5,(a0,d0)
	bra	.done
.clear:
	bclr	d5,(a0,d0)
.done:
	add.l	#1,d6
	dbf	d7,.loop

	POP
	rts



;--------------------------------------------------
;
; Clear screen with blitter..
;
;--------------------------------------------------



BlitterClear:
	; Clears area with blitter
	; INDATA
	; D0 = Pointer to plane.
	; D1 = Number of rows
	; D2 = Number of Words in width
	; D3 = Modulo
	
	PUSH
	VBLT					;Wait for blitter to finish before using the blitter again
	move.w	#$100,$dff040			;Use D,A Set minterm D=A
	clr.w	$dff042				;O=BLTCON1
	move.w	#$ffff,$dff044
	move.w	#$ffff,$dff046
	move.w	#$8040,$dff096			;Turn on blitter DMA
	move.l	d0,$dff054
	move.w	d3,$dff066			;Modulo D
	asl.l	#6,d1
	add.l	d2,d1
	move.w	d1,$dff058			;Set Size and start blitter
	POP
	rts

EnableCache:
	PUSH
	move.l	#$0808,d1
	movec	d1,CACR
	move.l	#$0101,d1
	movec	d1,CACR
	POP
	rts

DisableCache:
	PUSH
	move.l	#$0808,d1
	movec	d1,CACR
	move.l	#0,d1
	movec	d1,CACR
	POP
	rts

;------------------------------------------------------------------------------------------



SystemInfoTest:
	bsr	InitScreen
	lea	SystemInfoTxt,a0
	move.w	#2,d1
	bsr	Print
	lea	SystemInfoHWTxt,a0
	move.w	#2,d1
	bsr	Print

	bsr	GetHWReg
	bsr	PrintHWReg

	lea	NewLineTxt,a0
	bsr	Print


	lea	WorkTxt,a0
	move.l	#6,d1
	bsr	Print

	move.l	BaseStart-V(a6),d0			; Get startaddress of chipmem
	bsr	binhex
	move.l	#2,d1
	bsr	Print

	lea	MinusTxt,a0
	bsr	Print


	move.l	BaseEnd-V(a6),d0			; Get startaddress of chipmem
	bsr	binhex
	move.l	#2,d1
	bsr	Print


	lea	WorkSizeTxt,a0
	move.l	#6,d1
	bsr	Print


	move.l	BaseEnd-V(a6),d0
	sub.l	BaseStart-V(a6),d0
	divu	#1024,d0
	swap	d0
	clr.w	d0
	swap	d0

	bsr	bindec
	move.l	#2,d1
	bsr	Print


	lea	KB,a0
	move.l	#2,d1
	bsr	Print

	lea	RomSizeTxt,a0
	move.l	#6,d1
	bsr	Print


	move.l	EndRom,d0
	sub.l	#rom_base,d0
	divu	#1024,d0
	swap	d0
	clr.w	d0
	swap	d0

	bsr	bindec
	move.l	#2,d1
	bsr	Print

	lea	KB,a0
	bsr	Print


	lea	WorkOrderTxt,a0
	move.l	#6,d1
	bsr	Print

	cmp.b	#0,WorkOrder-V(a6)
	beq	.normalorder


	lea	StartTxt2,a0
	bsr	Print
	bra	.orderdone
	
.normalorder:
	lea	EndTxt2,a0
	bsr	Print

.orderdone:

	lea	ChipTxt,a0
	move.l	#6,d1
	bsr	Print

	move.l	ChipStart-V(a6),d0
	bsr	binhex
	move.l	#2,d1
	bsr	Print
	lea	MinusTxt,a0
	bsr	Print
	move.l	ChipEnd-V(a6),d0
	bsr	binhex
	bsr	Print


	lea	FastTxt,a0
	move.l	#6,d1
	bsr	Print


	move.l	FastStart-V(a6),d0
	bsr	binhex
	move.l	#2,d1
	bsr	Print
	lea	MinusTxt,a0
	bsr	Print
	move.l	FastEnd-V(a6),d0
	bsr	binhex
	bsr	Print


	bsr	RomChecksum

	lea	.CpuDone,a5
	bsr	DetectCPU
.CpuDone:
	bsr	PrintCPU

	clr.l	d0
	move.b	CPUGen-V(a6),d0
	cmp.b	#5,d0
	bne	.no060

	lea	FlagTxt,a0
	bsr	Print
	lea	PCRFlagsTxt,a0
	move.l	#2,d1
	bsr	Print
	move.l	PCRReg-V(a6),d0
	bsr	binstring
	move.l	#3,d1
	bsr	Print



;	move.l	#2,d1
;	lea	EXPERIMENTAL,a0
;	bsr	Print
;	move.l	#DetMMU,$80
;	trap	#0
;	move.l	d6,d0
;	move.l	#3,d1
;	bsr	bindec
;	bsr	Print

.no060


	move.l	#BusError,$8		; This time to a routine that can present more data.
	move.l	#UnimplInst,$2c
	move.l	#Trap,$80

	lea	NewLineTxt,a0
	bsr	Print
	lea	DebugROM,a0
	move.l	#3,d1
	bsr	Print

	cmp.w	#$1114,$0
	bne	.no1114at0
	lea	YES,a0
	move.l	#1,d1
	bsr	Print
	bra	.yes1114at0

.no1114at0:
	lea	NO,a0
	move.l	#2,d1
	bsr	Print
.yes1114at0

	lea	NewLineTxt,a0
	bsr	Print
	lea	DebugROM2,a0
	move.l	#3,d1
	bsr	Print

	cmp.w	#$1114,$f80000
	bne	.no1114atf8
	lea	YES,a0
	move.l	#2,d1
	bsr	Print
	bra	.yes1114atf8

.no1114atf8:
	lea	NO,a0
	move.l	#1,d1
	bsr	Print
.yes1114atf8:
	lea	DebugROM3,a0
	move.l	#3,d1
	bsr	Print

	cmp.w	#$1111,$f00000
	bne	.no1111atf0
	lea	YES,a0
	move.l	#2,d1
	bsr	Print
	bra	.donerom

.no1111atf0:
	lea	NO,a0
	move.l	#2,d1
	bsr	Print
.donerom:	

	lea	StuckButtons,a0
	move.l	#3,d1
	bsr	Print

	clr.l	d7				; Clear d7.  set it to 1 if a button was stuck.

	cmp.b	#0,STUCKP1LMB-V(a6)
	beq	.nop1lmb
	lea	InitP1LMBtxt,a0
	move.l	#1,d7
	move.l	#1,d1
	bsr	Print
.nop1lmb:
	cmp.b	#0,STUCKP2LMB-V(a6)
	beq	.nop2lmb
	lea	InitP2LMBtxt,a0
	move.l	#1,d1
	move.l	#1,d7
	bsr	Print
.nop2lmb:
	cmp.b	#0,STUCKP1RMB-V(a6)
	beq	.nop1rmb
	lea	InitP1RMBtxt,a0
	move.l	#1,d1
	move.l	#1,d7
	bsr	Print
.nop1rmb:
	cmp.b	#0,STUCKP2RMB-V(a6)
	beq	.nop2rmb
	lea	InitP2RMBtxt,a0
	move.l	#1,d1
	move.l	#1,d7
	bsr	Print
.nop2rmb:
	cmp.b	#0,DISPAULA-V(a6)
	beq	.nobadpaula
	lea	BadPaulaTXT,a0
	move.l	#1,d1
	move.l	#1,d7
	bsr	Print
.nobadpaula:
	cmp.b	#0,OVLErr-V(a6)
	beq	.noovlerr
	lea	OvlErrTxt,a0
	move.l	#1,d1
	move.l	#1,d7
	bsr	Print
.noovlerr:

	cmp.l	#0,d7
	bne	.stuck
	lea	NONE,a0
	move.l	#2,d1
	bsr	Print
.stuck:
	lea	NewLineTxt,a0
	bsr	Print

	bsr	WaitButton
	bra	MainMenu
	

PrintCPU:
						; Prints CPU Information
	lea	CPUTxt,a0
	move.l	#2,d1
	bsr	Print

	move.l	CPUPointer-V(a6),a0
	move.l	#2,d1
	bsr	Print

	clr.l	d7
	cmp.b	#5,CPUGen-V(a6)			; Check if we had 060 gen of CPU, if so, print revisionnumber
	bne	.no060
	move.b	CPU060Rev-V(a6),d7

	lea	REVTxt,a0
	bsr	Print
	move.l	d7,d0
	bsr	bindec
	bsr	Print
.no060:

	lea	FPUTxt,a0
	move.l	#2,d1
	bsr	Print
	move.l	FPUPointer-V(a6),a0
	move.l	#2,d1
	bsr	Print

	lea	MMUTxt,a0
	move.l	#2,d1
	bsr	Print
	clr.l	d0
	move.b	MMU-V(a6),d0
	cmp.b	#0,d0
	beq	.nommu
	lea	NOTCHECKED,a0
	bra	.mmuprint
.nommu:
	lea	NO,a0
.mmuprint:
	bsr	Print
	rts


DetMMU:
		; code by Toni Wilen
	lea	.exit,a3
	clr.l	d0
	move.w	#$4000,d0
	movec	d0,TC
	nop
	nop
	movec	TC,d1
	move.l	d1,d0
	bsr	binhex
	move.l	#1,d1
	bsr	Print

	moveq	#0,d7
	moveq	#0,d6

	move.l	#.bus,$8
	move.l	#.fline,$2c
	;lower 16M: do not cache anything
	;(Compability for ACA500/plus with A1200 68040+ accelerators)
	move.l	#$c040,d0
	movec	d0,dtt0
	movec	d0,itt0
	movec	d0,dtt1
	movec	d0,itt1

	moveq	#1,d6
	move.b	#1,$1000000	;should not case bus error
	move.l	#$100e044,d0	;writeprotect 16M-32M, ignore supervisorbit
	movec	d0,dtt0
	moveq	#2,d6
	move.b	#1,$1000000	;should cause bus error
	moveq	#3,d6
.exit:
	move.l	#$c040,d0
	movec	d0,dtt0
	rte

.fline:
	; shouldtnt happen
	move.l	a3,2(sp)
	rte
.bus:
	move.l	a3,2(sp)
	rte

;------------------------------------------------------------------------------------------

DetectCPU:				; Detects CPU, FPU etc.
					; Code more or less from romanworkshop.blutu.pl/menu/amiasm.htm
					
					; IB!  a5 Contains address to instruction after branch to here. so it can exit there
					; if not correct cpu

	move.l	#"TEST",$700		; Put "TEST" into $700
	clr.l	PCRReg-V(a6)		; Clear PCRReg value
	clr.b	CPU060Rev-V(a6)		; Clear 060 CPU Rev value
	clr.b	MMU-V(a6)		; Clear the MMU Flag
	clr.b	ADR24BIT-V(a6)		; Clear the 24Bit addressmode flag
	cmp.l	#"TEST",$700		; Check if $700 is "TEST" if not.  we assume having memoroissues at lower chipmem.
					; so CPU detection will just fail and crash.  put 680x0 as string of cpu.
	bne	.nochip
	clr.l	$700			; Clear $700

	move.l	#"24AD",$4000700	; Write "24AD" to highmem $700
	cmp.l	#"24AD",$700		; IF memory is readable at $700 instead. we are using a cpu with 24 bit address.
	bne	.no24bit
	move.b	#1,ADR24BIT-V(a6)
.no24bit:
	moveq	#$0,d1			; Set CPU detected.  begin with "0" as 68000
	move.l	#.notabove68k,$10	; Set illegal instruction to this

	movec	VBR,d3			; Supported by 010+	dc.l	$4e7a3801		;movec VBR,d3	- move VBR to d3

	moveq	#$10,d2
	move.l	d2,a1
	add.l	d3,a1
	move.l	(a1),d2			; take a backup of current value
	lea	.notabove68k,a0
	move.l	a0,(a1)


	moveq	#$1,d1			; Set 68010


	moveq	#$10,d2
	move.l	d2,a1
	add.l	d3,a1
	move.l	(a1),d2
	lea	.cpu3,a0
	move.l	a0,(a1)
	move.l	d3,a2
	moveq	#$2c,d3
	add.l	d3,a2
	move.l	(a2),d3			; Line 111 will happen when illegal instruction happens.

	lea	.above010,a0
	move.l	a0,(a2)
	move.l	a7,a3


	movec	CACR,d1			;dc.l	$4e7a1002		;movec CACR,d1	; 020-060?
	moveq	#$2,d1			; Set 68020

	movec	ITT0,d1			; Supported in 040-060
	moveq	#$4,d1			; Set 68040
	movec	pcr,d1			;dc.l	$4e7a1808		; movec pcr,dq	; Supported by 060
	move.l	d1,PCRReg-V(a6)		; Store the value for future use
	move.l	d1,d7
	moveq	#$5,d1			; Set 68060

					; OK We have 060, this cpu have some nice features, like the PCR register that shows its config.
					; and we just read it.. so lets.. use it

	movec	PCR,d4
	bclr	#1,d4
	movec	d4,PCR			; Make sure FPU is enabled
	
	and.l	#$0000ff00,d7
	asr.l	#8,d7
	move.b	d7,CPU060Rev-V(a6)	; Store the 060 Revisionnumber

	movec	PCR,d4
	swap	d4
	cmp.l	#$0440,d4
	bne	.novamp
					; Ohnooez..  someone is running this on a fake cpu..  a "080"
	moveq	#$6,d1			; Set 68080  YUKK  or well   68FAIL as it is no real stuff...   
.novamp:


.above010:
	move.l	d2,(a1)
	move.l	d3,(a2)
	move.l	a3,a7

.notabove68k:
	move.l	#BusError,$8
	move.l	#IllegalError,$10
	move.l	#UnimplInst,$2c

	move.b	d1,CPUGen-V(a6)		; Store generation of CPU

	cmp.b	#3,d1
	blt	.lower020		; check if we have 020 or lower then skip next instruction
	clr.b	ADR24BIT-V(a6)		; Clear the 24Bit addressmode flag
					; as some blizzards seem to screw up my 24 bit adr. detection

.lower020:


	move.l	#0,d1
	move.l	#.chkfpu,$10
	
	move.l	#$2c,d2
	move.l	d2,a1
	move.l	(a1),d2
	lea	.nofpu,a0
	move.l	a0,(a1)
	move.l	a7,a2


	cmp.b	#0,CPUGen-V(a6)		; Check if we had 68000
	beq	.nofpu			; YUP!.  we had

	move.l	d2,(a1)
	dc.l	$4e7a3801		; movec VBR,d3	(crash on 68k)
	add.l	d3,a1
	move.l	(a1),d2
	move.l	a0,(a1)

	

	dc.l	$f201583a		; ftst.b,d1
	dc.w	$f327			; FSAVE
.chkfpu:



	move.l	a2,d3
	sub.l	a7,d3


	moveq	#1,d1			; Set 68881
	cmp.b	#$1c,d3
	beq	.nofpu
	moveq	#2,d1			; Set 68882
	cmp.b	#$3c,d3
	beq	.nofpu
	moveq	#3,d1			; Set 68040
	cmp.b	#4,d3
	beq	.nofpu
	moveq	#4,d1			; Set 68060


	
	move.l	d2,(a1)
	


.nofpu:
	move.l	d1,FPU-V(a6)



	lea	FPUString,a0
	move.b	d1,FPU-V(a6)
	mulu	#6,d1
	add.l	d1,a0
	move.l	a0,FPUPointer-V(a6)


	move.l	#BusError,$8		; This time to a routine that can present more data.
	move.l	#IllegalError,$10
	move.l	#UnimplInst,$2c



.mmutest:

	move.b	#4,MMU-V(a6)		; Lets set a fake value of "MMU Detected"
	bra	.nommu			; Lets skipthat MMU detection,  it is buggy
	
	cmp.b	#0,CPUGen-V(a6)		; Check if 68000
	beq	.nommu			; skip mmutest
	bra	.no040mmu				; OK  CPU is detected, lets detect the MMU		
	move.l	#.test030mmu,$80
	trap	#0
	bra	.tested030		; We NEED to be in supervisormode for this
.test030mmu:
	move.l	SP,d1
	move.l	#.no030mmu,$2c
	move.l	#.no030mmu,$10
	pmove.l	tc,d0
	move.b	#1,MMU-V(a6)		; We did not have a crash, set that we got an MMU!
	rte
.no030mmu:
	move.l	d1,SP
	rte

.tested030:

.test040mmu:
	move.l	#.no040mmu,$10
	move.l	#.no040mmu,$2c

;	move.b	(a7),d0
;	movec	d0,dfc
;	move.l	(a7),a0
;	ptestw	(a0)
	movec	mmusr,d0
	cmp.l	#0,d0
	beq	.no040mmu
	move.b	#2,MMU-V(a6)		; We did not have a crash, set that we got an MMU!
.no040mmu:
	
	move.l	#.nommu,$10
	move.l	#.nommu,$2c
	move.l	#.mmu060,$8		; we WILL get an BUSERROR if we do have an mmu of the next instruction so...

;	pflush d0,a0
	dc.w	$f5c8			; PLPAR A0	; gives illegal instruction if no MMU, and buserror IF MMU
	bra	.nommu
.mmu060:
	move.b	#3,MMU-V(a6)		; We did not have a crash, set that we got an MMU!

.nommu:

	move.l	#BusError,$8		; This time to a routine that can present more data.
	move.l	#IllegalError,$10
	move.l	#UnimplInst,$2c
	move.l	#Trap,$80		; Restored all exceptions etc touched here


	clr.l	d1
	move.b	CPUGen-V(a6),d1		; Get CPU Gen from memory, lets find out the real string

	cmp.b	#1,d1			; Check if we had 010
	ble	.cpudone		; if equal or lover than. skip the rest




	cmp.b	#2,d1			; Check if we have a 020
	bne	.no020
	cmp.b	#0,ADR24BIT-V(a6)	; check if we have 24bit adr mode
	beq	.full020
	move.b	#2,d1			; Set 68EC20
	bra	.cpudone
.full020:
	move.b	#3,d1			; Set 68020
	bra	.cpudone
.no020:
	cmp.b	#3,d1			; Check if we have a 030
	bne	.no030

	cmp.b	#0,MMU-V(a6)		; Check if we have a MMU
	bne	.full030
	move.b	#4,d1			; Set 68EC30
	bra	.cpudone	
.full030:
	move.b	#5,d1			; Set 68030
	bra	.cpudone

.no030:
	cmp.b	#4,d1			; Check if we have a 040
	bne	.no040

	cmp.b	#0,MMU-V(a6)		; Check if we have a MMU
	bne	.mmu040
	move.b	#6,d1			; no mmu, so no FPu so set 68EC40
	bra	.cpudone

.mmu040:
	cmp.b	#0,FPU-V(a6)		; Check if we have a FPU
	bne	.full040
	move.b	#7,d1			; Set 68LC40
	bra	.cpudone
.full040:
	move.b	#8,d1			; Set 68040
	bra	.cpudone
.no040:
	cmp.b	#5,d1			; Check if we have a 060
	bne	.no060
	cmp.b	#0,MMU-V(a6)
	bne	.mmu060yes
	move.b	#9,d1			; no mmu no fpu so set 68EC60
	bra	.cpudone
.mmu060yes:
	cmp.b	#0,FPU-V(a6)
	bne	.full060
	move.b	#10,d1			; Set 68LC60
	cmp.b	#3,CPU060Rev-V(a6)	; Check if we had rev 3.
	bne.s	.noEC
	move.b	#9,d1			; set 68EC60

.noEC
	bra	.cpudone
.full060:
	move.b	#11,d1			; set 68060
	bra	.cpudone

.no060:					;DQFUQ?  ok something went nuts we did not have ANY CPU?
	cmp.b	#6,d1
	bne	.novampcrap
	move.b	#12,d1
	bra	.cpudone
.novampcrap:
	move.b	#13,d1			;So set 68???

.cpudone:

;	move.l	#0,d1
	move.b	d1,CPU-V(a6)		; Store CPU model
	lea	CPUString,a0
	mulu	#7,d1			; Multiply with 7 to point at correct part of string
	add.l	d1,a0
	move.l	a0,CPUPointer-V(a6)

	jmp	(a5)

.cpu3:
	cmp.b	#2,d1
	bne.w	.notabove68k
	dc.w	$f02f,$6200,$fffe	;Pmove I-PSR 
	moveq	#$3,d1			; Set 68030
	bra	.notabove68k

.nochip:
	move.b	#0,FPU-V(a6)
	move.b	#0,MMU-V(a6)
	move.b	#0,CPUGen-V(a6)
	clr.l	d1
	move.b	#13,d1			; set 68060
	bra	.cpudone

PortTestMenu:
	bsr	InitScreen
	move.w	#6,MenuNumber-V(a6)
	move.b	#1,PrintMenuFlag-V(a6)
	bra	MainLoop

PortTestPar:
	ifeq	a1k

	bsr	ClearScreen
	lea	PortParTest,a0
	move.l	#7,d1
	bsr	Print

	lea	PortParTest1,a0
	move.l	#3,d1
	bsr	Print

	lea	PortParTest2,a0
	move.l	#2,d1
	bsr	Print

.loop:
	bsr	GetInput
	cmp.b	#1,RMB-V(a6)
	beq	.exit
	move.b	GetCharData-V(a6),d0
	cmp.b	#$1b,d0	
	beq	.exit


	cmp.b	#0,BUTTON-V(a6)
	beq	.loop


	lea	PortParTest3,a0
	move.l	#6,d1
	bsr	Print

	move.b	#$ff,$bfe301
	bsr	WaitLong
	move.b	#0,$bfe101
	bsr	WaitLong
	move.b	#%11111111,$bfe301	; set pins output
	bsr	WaitLong
	move.b	#0,$bfe101		; Set all pins to 0
	move.b	#0,$bfd200
	clr.l	Passno-V(a6)

.loopa:
	clr.l	d0
	move.l	#10,d1
	bsr	SetPos
	lea	PassTxt,a0
	move.l	#4,d1
	bsr	Print
	clr.l	d0
	add.l	#1,Passno-V(a6)
	move.l	Passno-V(a6),d0
	bsr	bindec
	move.l	#6,d1
	bsr	Print			; Print out passnumber


	bsr	WaitLong
	move.b	#%00000101,$bfe301
	bsr	WaitLong
	move.b	#0,$bfe101		; Set all pins to 0
	lea	PortParTest12,a0
	move.l	#3,d1
	bsr	Print
	move.b	#0,d0
	move.b	#1,d1
	bsr	.TestPin



	bsr	WaitLong
	move.b	#%00000010,$bfe301
	bsr	WaitLong
	lea	PortParTest21,a0
	move.l	#3,d1
	bsr	Print
	move.b	#1,d0
	move.b	#0,d1
	bsr	.TestPin


	bsr	WaitLong
	move.b	#%00000100,$bfe301
	bsr	WaitLong
	move.b	#0,$bfe101		; Set all pins to 0
	lea	PortParTest34,a0
	move.l	#3,d1
	bsr	Print
	move.b	#2,d0
	move.b	#3,d1
	bsr	.TestPin


	bsr	WaitLong
	move.b	#%00001000,$bfe301
	bsr	WaitLong
	move.b	#0,$bfe101		; Set all pins to 0
	lea	PortParTest43,a0
	move.l	#3,d1
	bsr	Print
	move.b	#3,d0
	move.b	#2,d1
	bsr	.TestPin


	bsr	WaitLong
	move.b	#%00010000,$bfe301
	bsr	WaitLong
	move.b	#0,$bfe101		; Set all pins to 0
	lea	PortParTest56,a0
	move.l	#3,d1
	bsr	Print
	move.b	#4,d0
	move.b	#5,d1
	bsr	.TestPin

	bsr	WaitLong
	move.b	#%00100000,$bfe301
	bsr	WaitLong
	move.b	#0,$bfe101		; Set all pins to 0
	lea	PortParTest65,a0
	move.l	#3,d1
	bsr	Print
	move.b	#5,d0
	move.b	#4,d1
	bsr	.TestPin


	bsr	WaitLong
	move.b	#%01000000,$bfe301
	move.b	#0,$bfd200
	move.b	#%00000000,$bfe101
	bsr	WaitLong
	lea	PortParTest7p,a0
	move.l	#3,d1
	bsr	Print
	move.b	#1,d1
	move.b	#6,d0
	bsr	.TestPins



	bsr	WaitLong
	move.b	#2,$bfd200
	move.b	#0,$bfd000
	move.b	#0,$bfe301
	bsr	WaitLong
	lea	PortParTestp7,a0
	move.l	#3,d1
	bsr	Print
	move.b	#6,d1
	move.b	#1,d0
	bsr	.TestPins2




	bsr	WaitLong
	move.b	#%01000000,$bfe301
	move.b	#0,$bfd200
	move.b	#%00000000,$bfe101
	bsr	WaitLong
	lea	PortParTest7s,a0
	move.l	#3,d1
	bsr	Print
	move.b	#2,d1
	move.b	#6,d0
	bsr	.TestPins


	bsr	WaitLong
	move.b	#4,$bfd200
	move.b	#0,$bfd000
	move.b	#0,$bfe301
	bsr	WaitLong
	lea	PortParTests7,a0
	move.l	#3,d1
	bsr	Print
	move.b	#6,d1
	move.b	#2,d0
	bsr	.TestPins2

	bsr	WaitLong
	move.b	#%10000000,$bfe301
	bsr	WaitShort
	move.b	#0,$bfd000
	move.b	#%00000000,$bfe101
	bsr	WaitLong
	lea	PortParTest8b,a0
	move.l	#3,d1
	bsr	Print
	move.b	#0,d1
	move.b	#7,d0
	bsr	.TestPins


	bsr	WaitLong
	move.b	#1,$bfd200
	move.b	#0,$bfd000
	move.b	#0,$bfe301
	bsr	WaitLong
	lea	PortParTestb8,a0
	move.l	#3,d1
	bsr	Print
	move.b	#7,d1
	move.b	#0,d0
	bsr	.TestPins2



	bsr	GetInput

.nolmb:
	cmp.b	#1,BUTTON-V(a6)
	beq	.exit

	bne	.loopa
	
.exit:

	bra	PortTestMenu


.TestPin:					;	Test pin of par port
						; IN:
						;	d0 = bit to write
						;	d1 = bit to read
						; OUT:
						;	d2 = 0 = OK, 1=Fail

	clr.l	d2				; Clear errorregister
	bsr	WaitLong
	btst	d1,$bfe101			; First test that bit is 0, if not something is wrong
						; (like missing dongle! but something else can also be a problem)
	beq	.null
	bra	.fail
.null:						; bit was 0, lets set bit and test that it got high
	bset	d0,$bfe101
	bsr	WaitLong
	btst	d1,$bfe101
	beq	.was0
	lea	OOK,a0
	move.b	#2,d1
	bsr	Print
	rts
						; bit was 1, we are OK
.was0:						; ok bit was 0, something is wrong, exit with fail
	bra	.fail
	rts

.fail:
	lea	BAD,a0
	move.b	#1,d1
	bsr	Print
	rts


.TestPins:					; Same as testpin but checks CIAB instead

	clr.l	d2				; Clear errorregister
	bsr	WaitLong
	btst	d1,$bfd000			; First test that bit is 0, if not something is wrong
						; (like missing dongle! but something else can also be a problem)
	beq	.nulls
	bra	.fail
.nulls:						; bit was 0, lets set bit and test that it got high
	bset	d0,$bfe101
	bsr	WaitLong
	btst	d1,$bfd000
	beq	.was0
	lea	OOK,a0
	move.b	#2,d1
	bsr	Print
	rts

.TestPins2:					; Same as testpins but sets CIAB instead

	clr.l	d2				; Clear errorregister
	bsr	WaitLong
	btst	d1,$bfe101			; First test that bit is 0, if not something is wrong
						; (like missing dongle! but something else can also be a problem)
	beq	.nulls2
	bra	.fail
.nulls2						; bit was 0, lets set bit and test that it got high
	bset	d0,$bfd000
	bsr	WaitLong
	btst	d1,$bfe101
	beq	.was0
	lea	OOK,a0
	move.b	#2,d1
	bsr	Print
	rts

	else
	bra	Not1K
	endc

PortTestSer:
	ifeq	a1k

	bsr	ClearScreen
	lea	PortSerTest,a0
	move.l	#7,d1
	bsr	Print

	lea	PortSerTest1,a0
	move.l	#3,d1
	bsr	Print

	lea	PortSerTest2,a0
	move.l	#2,d1
	bsr	Print

.loop:
	bsr	GetInput
	cmp.b	#1,RMB-V(a6)
	beq	.exit
	move.b	GetCharData-V(a6),d0
	cmp.b	#$1b,d0	
	beq	.exit


	cmp.b	#0,BUTTON-V(a6)
	beq	.loop

	clr.l	Passno-V(a6)
	move.w	#0,SerTstBps-V(a6)

.loopa:
;	bsr	ClearScreen
	lea	PortParTest3,a0			; Lets steal that string
	move.l	#6,d1
	bsr	Print


.testloop:
	clr.l	d0
	move.l	#16,d1
	bsr	SetPos
	lea	PassTxt,a0
	move.l	#4,d1
	bsr	Print
	clr.l	d0
	add.l	#1,Passno-V(a6)
	move.l	Passno-V(a6),d0
	bsr	bindec
	move.l	#6,d1
	bsr	Print			; Print out passnumber

	lea	PortSerBps,a0
	move.l	#4,d1
	bsr	Print

	move.b	#$ff,$bfd200
	move.b	#0,$bfd000

	add.w	#1,SerTstBps-V(a6)
	cmp.w	#5,SerTstBps-V(a6)
	bne	.notmax
	move.w	#1,SerTstBps-V(a6)

.notmax:
	move.w	SerTstBps-V(a6),d0		; Get SerialSpeed value
	mulu	#4,d0				; Multiply with 4
	lea	SerText,a0			; Load table of pointers to different texts
	move.l	(a0,d0.l),a0			; load a0 with the value that a0+d0 points to (text of speed)
	move.l	#7,d1
	bsr	Print

	lea	SerSpeeds,a0
	move.l	(a0,d0),d0			; Load d0 with the value to write to the register for the correct speed.
	move.w	d0,$dff032			; Set the speed of the serialport


	lea	PortSerTest3,a0
	move.l	#3,d1
	bsr	Print

	move.l	#67,d0
	move.l	#18,d1
	bsr	SetPos


	clr.l	d6
	lea	PortSerString,a0
.serloop:
	move.b	(a0)+,d2
	cmp.b	#0,d2
	beq	.donetest

	bsr	RealLoopbacktest
	bra	.serloop

.donetest:

	move.l	d6,d0
	move.l	#2,d1
	bsr	bindec
	bsr	Print

	lea	PortSerTestB45,a0		; Test RTS->CTS
	move.l	#3,d1
	bsr	Print
	move.b	#$c0,$bfd200
	move.b	#6,d0
	move.b	#4,d1
	bsr	.TestPin

	lea	PortSerTestB46,a0		; Test RTS -> DSR
	move.l	#3,d1
	bsr	Print
	move.b	#$c0,$bfd200
	move.b	#0,$bfd000
	bsr	WaitLong
	move.b	#6,d0
	move.b	#3,d1
	bsr	.TestPin


	lea	PortSerTestB208,a0		; Test DTR -> CD
	move.l	#3,d1
	bsr	Print
	move.b	#$c0,$bfd200
	move.b	#0,$bfd000
	bsr	WaitLong
	move.b	#%10000000,$bfd200		; Set what pin is output
	move.b	#7,d0
	move.b	#5,d1
	bsr	.TestPin

	bsr	GetInput
	cmp.b	#1,BUTTON-V(a6)
	bne	.testloop



;	bsr	WaitReleased

.exit:
.loopend:
	bsr	GetInput
	cmp.b	#1,BUTTON-V(a6)
	bne.s	.loopend
	bsr	Init_Serial
	bra	PortTestMenu


.TestPin:
						; Sets a bit and checks is a bit is set�at CIAB Register
						; IN
						;	D0 = Bit to set
						;	D1 = Bit to test

	clr.l	d3
	bset	d0,d3
	clr.l	d2
	move.b	d3,$bfd000
	bsr	WaitLong

	btst	d1,$bfd000
	bne	.bitset
	bra	.bitclrtst
.bitset:
	add.b	#1,d2
.bitclrtst:
	bclr	d0,d3
	move.b	d3,$bfd000
	bsr	WaitLong

	btst	d1,$bfd000
	beq	.bitclear
	bra	.showresult
.bitclear:
	add.b	#1,d2
.showresult:

	cmp.b	#2,d2
	bne	.testfail
	lea	OOK,a0
	move.b	#2,d1
	bsr	Print
	rts
.testfail:
	lea	BAD,a0
	move.b	#1,d1
	bsr	Print
	rts


	else
	bra	Not1K
	endc


ClearSerial:					; Just read serialport, to empty it
	move.l	#1,d6				; load d6 with 1, so we run this, twice to be sure serialbuffer is cleared
.loop:
	move.w	#$4000,$dff09a
	move.w	#373,$dff032			; Set the speed of the serialport (9600BPS)
	move.b	#$4f,$bfd000			; Set DTR high
	move.w	#$0801,$dff09a
	move.w	#$0801,$dff09c

	move.l	#10000,d7
.timeoutloop2
	move.b	$bfe001,d0			;nonsenseread
	cmp.l	#0,d7
	beq	.exitloop
	sub.l	#1,d7
	move.w	$dff018,d0
	btst	#14,d0				; Buffer full, we have a new char
	beq	.timeoutloop2
.exitloop:
	dbf	d6,.loop
	rts



RealLoopbacktest:				; Test if we have a loopbackadapter connected.
						; Simply by outputing the char in D2 and check if the same char comes back.
						; if so, 1 is added to D6
	move.w	#$4000,$dff09a
	move.w	#373,$dff032			; Set the speed of the serialport (9600BPS)
	move.b	#$4f,$bfd000			; Set DTR high
	move.w	#$0801,$dff09a
	move.w	#$0801,$dff09c

	move.l	#10000,d7			; Load d7 with a timeoutvariable
.timeoutloop:	
	move.b	$bfe001,d1			; just read crapdata, we do not care but reading from CIA is slow... for timeout stuff only
	sub.l	#1,d7				; count down timeout value
	cmp.l	#0,d7				; if 0, timeout.
	beq	.endloop
	move.w	$dff018,d0
	btst	#13,d0				; Check TBE bit
	beq.s	.timeoutloop			; Loop until all is ok to send or until timeout hits
.endloop:

	move.w	#$0100,d1
	move.b	d2,d1
	move.w	d1,$dff030			; send it to serial
	move.w	#$0001,$dff09c			; turn off the TBE bit


	move.l	#10000,d7
.timeoutloop2
	move.b	$bfe001,d0			;nonsenseread
	cmp.l	#0,d7
	beq	.exitloop
	sub.l	#1,d7
	move.w	$dff018,d0
	btst	#14,d0				; Buffer full, we have a new char
	beq	.timeoutloop2
	bra	.check
.exitloop:
	clr.l	d0
.check:
	cmp.b	d0,d2				; Check if in and out was the same char

	bne.w	.exittest				; no so lets exit
	add.b	#1,d6				; Yes, add 1 to d6
.exittest:
	rts



PortTestJoystick:
	ifeq	a1k
	
	bsr	ClearScreen

	move.w	#$ffff,JOY0DAT-V(a6)
	move.w	#$ffff,JOY1DAT-V(a6)
	move.w	#$ffff,POT0DAT-V(a6)
	move.w	#$ffff,POT1DAT-V(a6)
	move.w	#$ffff,POTINP-V(a6)	
	move.b	#$ff,CIAAPRA-V(a6)
	clr.l	PortJoy0-V(a6)
	clr.l	PortJoy1-V(a6)
	move.w	#$fff,PortJoy0OLD-V(a6)
	move.w	#$fff,PortJoy1OLD-V(a6)
	clr.w	P0Fire-V(a6)
	clr.w	P1Fire-V(a6)
	move.w	#$fff,P0FireOLD-V(a6)
	move.w	#$fff,P1FireOLD-V(a6)
	
	lea	PortJoyTest,a0
	move.l	#7,d1
	bsr	Print
	lea	PortJoyTest1,a0
	move.l	#6,d1
	bsr	Print
	lea	PortJoyTestHW1,a0
	move.l	#3,d1
	bsr	Print
	lea	PortJoyTestHW2,a0
	move.l	#3,d1
	bsr	Print
	lea	PortJoyTestHW3,a0
	move.l	#3,d1
	bsr	Print
	lea	PortJoyTestHW4,a0
	move.l	#3,d1
	bsr	Print
	lea	PortJoyTestHW5,a0
	move.l	#3,d1
	bsr	Print
	lea	PortJoyTestHW6,a0
	move.l	#3,d1
	bsr	Print


	move.l	#0,d0
	move.l	#11,d1
	bsr	SetPos

	lea	PortJoyTest2,a0
	move.l	#6,d1
	bsr	Print
	lea	PortJoyTest3,a0
	move.l	#6,d1
	bsr	Print


	move.l	#0,d0
	move.l	#23,d1
	bsr	SetPos

	lea	PortJoyTestExitTxt,a0
	move.l	#7,d1
	bsr	Print




.loop:
	move.w	$dff00a,d7
	lea	JOY0DAT-V(a6),a0
	cmp.w	(a0),d7
	beq	.samejoy0dat
	move.w	d7,(a0)
	move.w	d7,PortJoy0-V(a6)
	move.l	#36,d0
	move.l	#4,d1
	bsr	SetPos
	clr.l	d0
	move.l	d7,d0
	bsr	binhexword
	move.l	#2,d1
	bsr	Print
	move.l	#47,d0
	move.l	#4,d1
	bsr	SetPos
	move.l	d7,d0
	bsr	binstring
	add.l	#16,a0
	move.l	#2,d1
	bsr	Print
.samejoy0dat:

	move.w	$dff00c,d7
	lea	JOY1DAT-V(a6),a0
	cmp.w	(a0),d7
	beq	.samejoy1dat
	move.w	d7,(a0)
	move.w	d7,PortJoy1-V(a6)

	move.l	#36,d0
	move.l	#5,d1
	bsr	SetPos
	clr.l	d0
	move.l	d7,d0
	bsr	binhexword
	move.l	#2,d1
	bsr	Print
	move.l	#47,d0
	move.l	#5,d1
	bsr	SetPos
	move.l	d7,d0
	bsr	binstring
	PUSH
	add.l	#16,a0
	move.l	#2,d1
	bsr	Print

	POP

.samejoy1dat:
	move.w	$dff012,d7
	lea	POT0DAT-V(a6),a0
	cmp.w	(a0),d7
	beq	.samepot0dat
	move.w	d7,(a0)
	move.l	#36,d0
	move.l	#6,d1
	bsr	SetPos
	clr.l	d0
	move.l	d7,d0
	bsr	binhexword
	move.l	#2,d1
	bsr	Print
	move.l	#47,d0
	move.l	#6,d1
	bsr	SetPos
	move.l	d7,d0
	bsr	binstring
	add.l	#16,a0
	move.l	#2,d1
	bsr	Print

.samepot0dat:

	move.w	$dff014,d7
	lea	POT1DAT-V(a6),a0
	cmp.w	(a0),d7
	beq	.samepot1dat
	move.w	d7,(a0)


	move.l	#36,d0
	move.l	#7,d1
	bsr	SetPos
	clr.l	d0
	move.l	d7,d0
	bsr	binhexword
	move.l	#2,d1
	bsr	Print
	move.l	#47,d0
	move.l	#7,d1
	bsr	SetPos
	move.l	d7,d0
	bsr	binstring
	add.l	#16,a0
	move.l	#2,d1
	bsr	Print
.samepot1dat:


	move.w	$dff016,d7
	lea	POTINP-V(a6),a0
	cmp.w	(a0),d7
	beq	.samepotinp
	move.w	d7,(a0)

	move.l	#36,d0
	move.l	#8,d1
	bsr	SetPos
	clr.l	d0
	move.l	d7,d0
	bsr	binhexword
	move.l	#2,d1
	bsr	Print
	move.l	#47,d0
	move.l	#8,d1
	bsr	SetPos
	move.l	d7,d0
	bsr	binstring
	add.l	#16,a0
	move.l	#2,d1
	bsr	Print
.samepotinp:
	clr.l	d7
	move.b	$bfe001,d7
	lea	CIAAPRA-V(a6),a0
	cmp.w	(a0),d7
	beq	.samefire
	move.w	d7,(a0)

	btst	#6,$bfe001
	bne	.noport0
	move.w	#1,P0Fire-V(a6)
	bra	.p1
.noport0:
	move.w	#0,P0Fire-V(a6)
.p1:
	btst	#7,$bfe001
	bne	.noport1
	move.w	#1,P1Fire-V(a6)
	bra	.nop
.noport1:
	move.w	#0,P1Fire-V(a6)
.nop:
	move.l	#36,d0
	move.l	#9,d1
	bsr	SetPos
	clr.l	d0
	move.l	d7,d0
	bsr	binhexword
	move.l	#2,d1
	bsr	Print
	move.l	#47,d0
	move.l	#9,d1
	bsr	SetPos
	move.l	d7,d0
	bsr	binstring
	add.l	#16,a0
	move.l	#2,d1
	bsr	Print
.samefire:
	clr.l	d0
	move.w	PortJoy0-V(a6),d0
	cmp.w	PortJoy0OLD-V(a6),d0
	beq	.samejoy0
	move.w	d0,PortJoy0OLD-V(a6)
	bsr	GetJoy
	move.l	d0,d7
	move.l	#0,d2
	bsr	PrintJoy

.samejoy0:

	clr.l	d0
	move.w	PortJoy1-V(a6),d0
	cmp.w	PortJoy1OLD-V(a6),d0
	beq	.samejoy1


	move.w	d0,PortJoy1OLD-V(a6)

	clr.l	d0
	move.w	PortJoy1-V(a6),d0
	bsr	GetJoy
	move.l	d0,d7
	move.l	#37,d2
	bsr	PrintJoy
.samejoy1:


	clr.l	d0
	move.w	P0Fire-V(a6),d0
	cmp.w	P0FireOLD-V(a6),d0
	beq	.samefire0
	move.w	d0,P0FireOLD-V(a6)


	move.l	#19,d0
	move.l	#17,d1
	bsr	SetPos
	lea	FIRE,a0
	cmp.w	#0,P0Fire-V(a6)
	bne	.nop0
	move.l	#6,d1
	bra	.p0
.nop0:
	move.l	#1,d1
.p0:
	bsr	Print

.samefire0:


	clr.l	d0
	move.w	P1Fire-V(a6),d0
	cmp.w	P1FireOLD-V(a6),d0
	beq	.samefire1

	move.w	d0,P1FireOLD-V(a6)


	move.l	#56,d0
	move.l	#17,d1
	bsr	SetPos
	lea	FIRE,a0
	cmp.w	#0,P1Fire-V(a6)
	bne	.nop1
	move.l	#6,d1
	bra	.p2
.nop1:
	move.l	#1,d1
.p2:
	bsr	Print

.samefire1:



	bsr	GetInput

	cmp.b	#$1b,GetCharData-V(a6)
	beq	.exit

	cmp.b	#1,RMB-V(a6)
	bne	.loop
	cmp.b	#1,LMB-V(a6)
	bne	.loop

	bsr	WaitReleased
	
.exit:
	bra	PortTestMenu



PrintJoy:				; Print Joystatus
					; IN =	d7 = joydata
					;	d2 = how much to add in X axis
	move.l	#20,d0
	add.l	d2,d0
	move.l	#15,d1
	bsr	SetPos
	lea.l	UP,a0

	btst	#2,d7
	beq	.noup
	move.l	#1,d1				; 4 blue   6 cyan
	bra	.up
.noup:
	move.l	#6,d1
.up:
	bsr	Print


	move.l	#19,d0
	add.l	d2,d0
	move.l	#19,d1
	bsr	SetPos

	lea.l	DOWN,a0

	btst	#0,d7
	beq	.nodown
	move.l	#1,d1
	bra	.down
.nodown:
	move.l	#6,d1
.down:	
	bsr	Print


	move.l	#13,d0
	add.l	d2,d0
	move.l	#17,d1
	bsr	SetPos
	lea	LEFT,a0

	btst	#3,d7
	beq	.noleft
	move.l	#1,d1
	bra	.left
.noleft:
	move.l	#6,d1
.left:
	bsr	Print


	move.l	#25,d0
	add.l	d2,d0
	move.l	#17,d1
	bsr	SetPos
	lea	RIGHT,a0
	btst	#1,d7
	beq	.noright
	move.l	#1,d1
	bra	.right
.noright:
	move.l	#6,d1
.right:
	bsr	Print
	rts


GetJoy:
	;			IN d0=joy data
	;			OUT: D0   bits =  0=down, 1=right, 2=up, 3=left
	PUSH
	clr.l	d7
	move.l	d0,d6
	move.l	d0,d1
	and.w	#1,d1
	and.w	#2,d0
	asr.w	#1,d0
	eor.w	d1,d0
	btst	#0,d0
	beq	.nodown
	bset	#0,d7
.nodown:
	move.l	d6,d0
	btst	#1,d0
	beq	.noright
	bset	#1,d7
.noright:
	move.l	d0,d1
	and.w	#256,d1
	asr	#8,d1
	and.w	#512,d0
	asr	#8,d0

	asr.w	#1,d0
	eor.w	d1,d0
	btst	#0,d0
	beq	.noup
	bset	#2,d7
.noup:
	move.l	d6,d0
	asr.l	#8,d0
	btst	#1,d0
	beq	.noleft
	bset	#3,d7
.noleft:

	move.l	d7,temp-V(a6)
	POP
	move.l	temp-V(a6),d0
	rts

	else
	bra	Not1K
	endc


;------------------------------------------------------------------------------------------


Loopbacktest:					; Test if we have a loopbackadapter connected.
						; Simply by outputing the char in D2 and check if the same char comes back.
						; if so, 1 is added to D6
	move.w	#$4000,$dff09a
	move.w	#373,$dff032			; Set the speed of the serialport (9600BPS)
	move.b	#$4f,$bfd000			; Set DTR high
	move.w	#$0801,$dff09a
	move.w	#$0801,$dff09c

	move.l	#10000,d7			; Load d7 with a timeoutvariable
.timeoutloop:	
	move.b	$bfe001,d1			; just read crapdata, we do not care but reading from CIA is slow... for timeout stuff only
	sub.l	#1,d7				; count down timeout value
	cmp.l	#0,d7				; if 0, timeout.
	beq	.endloop
	move.w	$dff018,d0

	btst	#13,d0				; Check TBE bit
	beq.s	.timeoutloop			; Loop until all is ok to send or until timeout hits
.endloop:




	move.w	#$0100,d1
	move.b	d2,d1
	move.w	d1,$dff030			; send it to serial
	move.w	#$0001,$dff09c			; turn off the TBE bit


	move.l	#10000,d7

.timeoutloop2
	move.b	$bfe001,d0			; Nonsenseread
	cmp.l	#0,d7
	beq	.exitloop
	sub.l	#1,d7
	move.w	$dff018,d0
	btst	#14,d0				; Buffer full, we have a new char
	beq	.timeoutloop2
	bra	.check
.exitloop:
	clr.l	d0
.check:
	cmp.b	d0,d2				; Check if in and out was the same char
	bne.s	.exit				; no so lets exit
	add.b	#1,d6				; Yes, set d6 to 1
.exit:
	jmp	(a0)





KeyBoardTest:
	bsr	InitScreen
	lea	KeyBoardTestText,a0
	move.l	#7,d1
	bsr	Print
	lea	KeyBoardTestCodeTxt,a0
	move.l	#6,d1
	bsr	Print
	lea	KeyBoardTestCodeTxt2,a0
	move.l	#6,d1
	bsr	Print
	move.b	#0,KeyBOld-V(a6)

.loop:
	bsr	GetInput
	bsr	WaitShort			; just wait a short time
	move.b	scancode-V(a6),d0
	cmp.b	#0,d0
	beq	.null				; If scancode was 0 we had noting

	move.b	KeyBOld-V(a6),d1
	cmp.b	d0,d1				; Check if it is the same as last scan
	beq	.samecode
	move.b	d0,KeyBOld-V(a6)


	move.l	#43,d0
	move.l	#2,d1
	bsr	SetPos
	lea	Space3,a0
	bsr	Print
	move.l	#43,d0
	move.l	#2,d1
	bsr	SetPos
	clr.l	d0
	move.b	scancode-V(a6),d0
	cmp.b	#116,d0				; is it 116? (esc released)
	beq	.exit
	bsr	bindec
	move.l	#3,d1
	bsr	Print

	move.l	#17,d0
	move.l	#3,d1
	bsr	SetPos

	move.b	scancode-V(a6),d0
	bsr	binstringbyte
	move.l	#3,d1
	bsr	Print

	move.l	#32,d0
	move.l	#3,d1
	bsr	SetPos

	move.b	scancode-V(a6),d0
	move.l	#3,d1
	bsr	binhexbyte
	bsr	Print
	
	move.l	#62,d0
	move.l	#2,d1
	bsr	SetPos

	clr.l	d0
	move.b	key-V(a6),d0
	bsr	bindec
	move.l	#3,d1
	bsr	Print

	move.l	#58,d0
	move.l	#3,d1
	bsr	SetPos

	move.b	key-V(a6),d0
	bsr	binstringbyte
	move.l	#3,d1
	bsr	Print

	move.l	#73,d0
	move.l	#3,d1
	bsr	SetPos

	move.b	key-V(a6),d0
	bsr	binhexbyte
	move.l	#3,d1
	bsr	Print


	move.l	#73,d0
	move.l	#2,d1
	bsr	SetPos
	move.l	#2,d1

	lea	keyresult-V(a6),a0
	move.b	(a0),d0
	cmp.b	#0,d0				; Check if it was no char, then do not print
	beq	.samecode
	move.l	#3,d1
	bsr	MakePrintable
	bsr	PrintChar
.null:
.samecode:
	cmp.b	#$1b,Serial-V(a6)
	beq	.exit
	cmp.b	#1,MBUTTON-V(a6)
	bne.w	.loop
.exit:

	bra	MainMenu



DetFastMem:
	clr.l	FastMem-V(a6)		; Clear amount of fastmem

	lea	A24BitTxt,a0
	move.l	#7,d1
	bsr	Print


	clr.l	d1
	lea	$0,a0
	lea	$0,a0
	lea	$0,a3

					; as d0 is used as a "random" number in memcheck.  but d0 is also detected chipmem.
					; lets eor this to make it more... "random"
					; this detection is quite.. "poor" as it will stop when finding one block of ram. so fragmented memory only first block
					; will be found


	clr.l	d2			; We set d2 to 0.  if it is anything else than 0 after 24bit tests, we have32bit cpu



	cmp.l	#" PPC",$f00090		; Check if the string "PPC" is located in rom at this address. if so we have a BPPC
					; that will disable the 68k cpu onboard if memory  below $40000000 is tested.
	beq	.bppc


	move.l	#"NONE",$700
	move.l	#"24BT",$40000700	; Write "24BT" to highmem
	cmp.l	#"24BT",$700		; IF memory is readable at $700 instead. we are using a cpu with 24 bit adress. no memory to detect in next routines
	beq	.nop5
	move.l	#1,d2			; blizzards etc will set this to 1..  apollo etc will not

.nop5



	move.l	#"NONE",$700
	move.l	#"24BT",$2000700	; Write "24BT" to highmem
	cmp.l	#"24BT",$700		; IF memory is readable at $700 instead. we are using a cpu with 24 bit adress. no memory to detect in next routines
	beq	.no24
	move.l	#1,d2			; other cards will trigger here
	
.no24
	move.l	#"NONE",$700
	move.l	#"24BT",$4000700	; Write "24BT" to highmem
	cmp.l	#"24BT",$700		; IF memory is readable at $700 instead. we are using a cpu with 24 bit adress. no memory to detect in next routines
	beq	.no24a
	move.l	#1,d2			; blizzards etc will set this to 1..  apollo etc will not

.no24a:

	cmp.l	#0,d2			; if d2 is 0, we have 24 bit addressing
	beq	.no32bit

	PUSH
	lea	NO,a0
	move.l	#2,d1
	bsr	Print
	lea	NewLineTxt,a0
	bsr	Print
	POP

	PUSH
	lea	A3k4kMemTxt,a0
	move.l	#7,d1
	bsr	Print
	POP


	
	eor.l	#$01110000,d0
	lea	$1000000,a1		; Detect motherboardmem on A3000/4000
	lea	$7ffffff,a2

	lea	.a3k4kdone,a3
	bra	DetectMemory
.a3k4kdone:				; Again, the wonders without stack.  pasta-code.. :)


	move.l	a0,d5			; Backup startaddress of memory found
	move.l	a1,d4			; Backup endaddress of memory found
	move.l	d1,d3			; Backup data of addresses found to registers not used
	add.l	d1,FastMem-V(a6)




	cmp.l	#0,a0			; was a0 0?  if so. no memory was found
	beq	.det16


	move.l	a0,FastStart-V(a6)	; Store startaddress of fastmem
	move.l	a1,FastEnd-V(a6)	; Store endadress of fastmem


	bsr	.PrintDetected


.det16:

	move.l	d3,d1


	PUSH
	lea	CpuMemTxt,a0
	move.l	#7,d1
	bsr	Print
	POP


	eor.l	#$01110000,d0

	lea	$8000000,a1		; Detect cpuboard on A3000/4000
	lea	$10000000,a2


	lea	.a3k4kcpudone,a3
	bra	DetectMemory
.a3k4kcpudone:
	move.l	a0,d5			; Backup startaddress of memory found
	move.l	a1,d4			; Backup endaddress of memory found
	move.l	d1,d3			; Backup data of addresses found to registers not used

	cmp.l	#0,a0			; was a0 0?  if so. no memory was found
	beq	.det26

	add.l	d1,FastMem-V(a6)

	move.l	a0,FastStart-V(a6)	; Store startaddress of fastmem
	move.l	a1,FastEnd-V(a6)	; Store endadress of fastmem
					; As this memory is usually faster than "onboard" memory, replace start and end addresses of fastem.

	bsr	.PrintDetected

.det26:

	PUSH

	cmp.l	#0,FastStart-V(a6)	; Check if stored start of fastmem is 0. if not we skip this part as most likly we are not a A1200
	bne	.skipA1200cpu



	lea	A1200CpuMemTxt,a0
	move.l	#7,d1
	bsr	Print
	POP


	eor.l	#$01010000,d0
	bra	.nobppc


.bppc:

	PUSH
	lea	BPPCtxt,a0
	move.l	#6,d1
	bsr	Print
	POP


.nobppc:
	lea	$40000000,a1
	lea	$ee000000,a2
	lea	.det1200cpu,a3

	eor.l	#$11010000,d0


	bra	DetectMemory
.det1200cpu:

	move.l	a0,d5			; Backup startaddress of memory found
	move.l	a1,d4			; Backup endaddress of memory found
	move.l	d1,d3			; Backup data of addresses found to registers not used


	cmp.l	#0,a0			; was a0 0?  if so. no memory was found
	beq	.det36

	move.l	a0,FastStart-V(a6)	; Store startaddress of fastmem
	move.l	a1,FastEnd-V(a6)	; Store endadress of fastmem
					; As this memory is usually faster than "onboard" memory, replace start and end addresses of fastem.



	add.l	d1,FastMem-V(a6)
	bsr	.PrintDetected

.det36:

	bra	.yes32bit
	
.no32bit:

	PUSH
	lea	YES,a0
	move.l	#2,d1
	bsr	Print
	lea	NewLineTxt,a0
	bsr	Print
	POP


.yes32bit:
	PUSH
.skipA1200cpu:

	lea	a24BitAreaTxt,a0
	move.l	#7,d1
	bsr	Print
	POP



	lea	$200000,a1		; Detect memory on 24 bit range
	lea	$9fffff,a2
	lea	.24bitdone,a3
	eor.l	#$10010000,d0

	bra	DetectMemory
.24bitdone:



	move.l	a0,d5			; Backup startaddress of memory found
	move.l	a1,d4			; Backup endaddress of memory found
	move.l	d1,d3			; Backup data of addresses found to registers not used

	cmp.l	#0,a0			; was a0 0?  if so. no memory was found
	beq	.det46

	cmp.l	#0,FastStart-V(a6)	; Check if stored start of fastmem is 0.. if so start this as start
	bne	.NoFastStored

	move.l	a0,FastStart-V(a6)	; Store startaddress of fastmem
	move.l	a1,FastEnd-V(a6)	; Store endadress of fastmem
					; As this memory is usually faster than "onboard" memory, replace start and end addresses of fastem.
.NoFastStored:



	add.l	d1,FastMem-V(a6)
	bsr	.PrintDetected


.det46:

	PUSH
	lea	FakeFastTxt,a0
	move.l	#7,d1
	bsr	Print
	POP

	eor.l	#$10010000,d0


	lea	$c00000,a1		; Detect memory on 24 bit range
	lea	$c80000,a2


	eor.l	#$10110000,d0

	lea	.fakefastdone,a3
	bra	DetectMemory
.fakefastdone:

	move.l	a0,d5			; Backup startaddress of memory found
	move.l	a1,d4			; Backup endaddress of memory found
	move.l	d1,d3			; Backup data of addresses found to registers not used


	cmp.l	#0,a0			; was a0 0?  if so. no memory was found
	beq	.det56

	cmp.l	#0,FastStart-V(a6)	; Check if stored start of fastmem is 0.. if so start this as start
	bne	.NoFastStored2

	move.l	a0,FastStart-V(a6)	; Store startaddress of fastmem
	move.l	a1,FastEnd-V(a6)	; Store endadress of fastmem
					; As this memory is usually faster than "onboard" memory, replace start and end addresses of fastem.
.NoFastStored2:


	add.l	d1,FastMem-V(a6)
	bsr	.PrintDetected




.det56:

	move.l	FastMem-V(a6),d0

	rts



.PrintDetected:

	PUSH
	lea	FastFoundtxt,a0
	move.l	#6,d1
	bsr	Print
	POP


	PUSH	
	move.l	d5,d0
	bsr	binhex
	add.l	#1,a0
	move.l	#6,d1
	bsr	Print
	POP

	PUSH
	lea	MinusDTxt,a0
	move.l	#6,d1
	bsr	Print
	

	move.l	d4,d0
	bsr	binhex
	add.l	#1,a0
	move.l	#6,d1
	bsr	Print


	lea	NewLineTxt,a0
	bsr	Print
	POP
	rts



SSPError:
	move.l	a0,DebugA0-V(a6)		; Store a0 to DebugA0 so we have it saved. as next line will overwrite it
	lea	SSPErrorTxt,a0
	bra	ErrorScreen

BusError:
	move.l	a0,DebugA0-V(a6)
	lea	BusErrorTxt,a0
	bra	ErrorScreen

AddressError:
	move.l	a0,DebugA0-V(a6)
	lea	AddressErrorTxt,a0
	bra	ErrorScreen

IllegalError:
	move.l	a0,DebugA0-V(a6)
	lea	IllegalErrorTxt,a0
	bra	ErrorScreen

DivByZero:
	move.l	a0,DebugA0-V(a6)
	lea	DivByZeroTxt,a0
	bra	ErrorScreen

ChkInst:
	move.l	a0,DebugA0-V(a6)
	lea	ChkInstTxt,a0
	bra	ErrorScreen

TrapV:
	move.l	a0,DebugA0-V(a6)
	lea	TrapVTxt,a0
	bra	ErrorScreen

PrivViol:
	move.l	a0,DebugA0-V(a6)
	lea	PrivViolTxt,a0
	bra	ErrorScreen

Trace:
	move.l	a0,DebugA0-V(a6)
	lea	TraceTxt,a0
	bra	ErrorScreen

UnimplInst:
	move.l	a0,DebugA0-V(a6)
	lea	UnImplInstrTxt,a0
	bra	ErrorScreen
	
Trap:
	move.l	a0,DebugA0-V(a6)
	lea	TrapTxt,a0
	bra	ErrorScreen





POSTBusError:
	lea	BusErrorTxt,a0
	move.w	#$f00,d5
	move.l	#$fff,d6
	bra	POSTErrorScreen

POSTAddressError:
	lea	AddressErrorTxt,a0
	move.w	#$f00,d5
	move.l	#$f0f,d6
	bra	POSTErrorScreen

POSTIllegalError:
	lea	IllegalErrorTxt,a0
	move.w	#$f00,d5
	move.l	#$0ff,d6
	bra	POSTErrorScreen

POSTDivByZero:
	lea	DivByZeroTxt,a0
	move.w	#$f00,d5
	move.l	#$ff0,d6
	bra	POSTErrorScreen

POSTChkInst:
	lea	ChkInstTxt,a0
	move.w	#$f00,d5
	move.l	#$00f,d6
	bra	POSTErrorScreen

POSTTrapV:
	lea	TrapVTxt,a0
	move.w	#$000,d5
	move.l	#$fff,d6
	bra	POSTErrorScreen

POSTPrivViol:
	lea	PrivViolTxt,a0
	move.w	#$000,d5
	move.l	#$f0f,d6
	bra	POSTErrorScreen

POSTTrace:
	lea	TraceTxt,a0
	move.w	#$000,d5
	move.l	#$0ff,d6
	bra	POSTErrorScreen

POSTUnimplInst:
	lea	UnImplInstrTxt,a0
	move.w	#$000,d5
	move.l	#$ff0,d6
	bra	POSTErrorScreen

POSTErrorScreen:
	move.w	#$200,$dff100
	move.w	#0,$dff110

	move.l	a0,a2
	
	lea	NewLineTxt,a0		; Tell user on serialport that we are totally halted.
	lea	.post1,a1
	bra	DumpSerial
.post1:
	move.l	a2,a0
	add.l	#1,a0			; Skip first char as we do not use it in this routine.
	lea	.post2,a1
	bra	DumpSerial

.post2:
	lea	HaltTxt,a0
	lea	.loop,a1
	bra	DumpSerial
	

.loop:
	TOGGLEPWRLED		; Change value of Powerled.
	bne	.not
	move.w	d6,$dff180		; Set Screencolor to d6 (usual chipmemproblem color)
	bra	.yes
.not:
	move.w	d5,$dff180		; just every 2:nd turn, show a DARK green color instead. making the screen flash some.
.yes:
	move.l	#$ffff,d7		; Do a nonsense loop
.loopa:
	move.b	$bfe001,d5		; Actually a nonsense read. but CIA space is slow to read from.
	move.b	$bfd400,d5		; Actually a nonsense read. but CIA space is slow to read from.
	move.b	$400,d5
	dbf	d7,.loopa
	bra.w	.loop			; Loop forever



bitcheck:
						;IN:
						;	d0 = Written value
						;	d1 = Read value
						;	d2 = errorlongword (errors will be set)
						;	a0 = as no stack. return JUMP value
	move.l	#31,d6				; We will check 31+1 bits (longword)
	clr.l	d7
.bitloop:
	btst	d6,d0
	bne	.set
						; ok read bit should be 0
	btst	d6,d1
	beq	.correct
	bset	d6,d2				; Set bit at d2 as error
	bra	.correct			; Well not true. but reusing labels

.set:						; ok read but should be 1
	btst	d6,d1
	bne	.correct
	bset	d6,d2
						; ok read bit should be 1
.correct:
	dbf	d6,.bitloop
	jmp	(a0)


ErrorScreen:
	move.w	(a7),DebSR-V(a6)		; Store what was in stack as first word is a copy of SR at crash
	move.l	2(a7),DebPC-V(a6)		; and next longword is PC
	move.l	d0,DebD0-V(a6)			; first store everything in registers
	move.l	d1,DebD1-V(a6)			; and for visability etc.. I do several move instead of movem. dunno why :)
	move.l	d2,DebD2-V(a6)
	move.l	d3,DebD3-V(a6)
	move.l	d4,DebD4-V(a6)
	move.l	d5,DebD5-V(a6)
	move.l	d6,DebD6-V(a6)
	move.l	d7,DebD7-V(a6)
	move.l	a0,DebA0-V(a6)
	move.l	a1,DebA1-V(a6)
	move.l	a2,DebA2-V(a6)
	move.l	a3,DebA3-V(a6)
	move.l	a4,DebA4-V(a6)
	move.l	a5,DebA5-V(a6)
	move.l	a6,DebA6-V(a6)
	move.l	a7,DebA7-V(a6)			; OK now everything is stored.
	bsr	ClearScreen
	move.l	d1,DebugD1-V(a6)
	move.l	#1,d1
	bsr	Print
	move.l	DebugA0-V(a6),a0
	move.l	DebugD1-V(a6),d1
	bsr	DebugScreen

	lea	NewLineTxt,a0
	jsr	Print
	lea	NewLineTxt,a0
	jsr	Print

	lea	AnyKeyMouseTxt,a0
	move.l	#5,d1
	bsr	Print

	bsr	ClearBuffer

	bsr	WaitButton
	bra	MainMenu

;------------------------------------------------------------------------------------------


SwapMode:
	move.w	#$fff,$dff180
	bchg	#5,SCRNMODE-V(a6)
	clr.l	d0
	move.b	SCRNMODE-V(a6),d0
	move.w	d0,$dff1dc		; Set BEAMCON90
	bra	MainMenu

Setup:
	bsr	ClearScreen
	lea	SetupTxt,a0
	move.l	#1,d1
	bsr	Print
	lea	NotImplTxt,a0
	move.l	#1,d1
	bsr	Print

	bsr	WaitPressed
	bsr	WaitReleased
	bra	MainMenu

About:
		ifeq	a1k

	bsr	ClearScreen
	lea	AboutTxt,a0
	move.l	#1,d1
	bsr	Print

	lea	AboutTxt2,a0
	move.l	#7,d1
	bsr	Print

	bsr	ClearBuffer

	bsr	WaitPressed
	bsr	WaitReleased
	bra	MainMenu
	else
	bra	Not1K
	endc




;------------------------------------------------------------------------------------------

WaitShort:					; Wait a short time, aprox 10 rasterlines. (or exact IF we have detected working raster)
	PUSH
	cmp.b	#1,RASTER-V(a6)			; Check if we have a confirmed working raster
	beq	.raster
	move.l	#$1000,d0			; if now.  lets try to wait some anyway.
	bsr	ReadSerial			; as we have no IRQs..  read serialport just in case
.loop:
	move.b	$bfe001,d1			; Dummyread from slow memory
	move.b	$dff006,d1
	dbf	d0,.loop
	POP
	rts
.raster:
	bsr	ReadSerial			; as we have no IRQs..  read serialport just in case
	move.b	$dff006,d0			; Get what rasterline we are at now
	add.b	#10,d0				; Add 10
.rasterloop:
	cmp.b	$dff006,d0
	bne.s	 .rasterloop
	POP
	rts


WaitLong:					; Wait a short time, aprox 10 rasterlines. (or exact IF we have detected working raster)
	PUSH
	cmp.b	#1,RASTER-V(a6)			; Check if we have a confirmed working raster
	beq	.raster
	move.w	#3,d1
	bsr	ReadSerial			; as we have no IRQs..  read serialport just in case
.loop2
	move.l	#$fff,d0			; if now.  lets try to wait some anyway.
.loop:
	move.b	$bfe001,d2			; Dummyread from slow memory
	move.b	$dff006,d2
	dbf	d0,.loop
	dbf	d1,.loop2
	POP
	rts

.raster:
	cmp.b	#$90,$dff006
	bne.s	.raster				; Wait for rasterline $90

	bsr	ReadSerial			; as we have no IRQs..  read serialport just in case

.rasterloop:
	cmp.b	#$8f,$dff006
	bne.s	 .rasterloop			; Wait for rasterline $8f, meaning we have waited for one frame
	POP
	rts



OtherTest:
	bsr	InitScreen
	move.w	#7,MenuNumber-V(a6)
	move.b	#1,PrintMenuFlag-V(a6)
	jmp	MainLoop

ShowMemAddress:
	bsr	InitScreen

	lea	ShowMemAdrTxt,a0
	move.l	#6,d1
	bsr	Print


	lea	ShowMemAdrTxt2,a0
	move.l	#6,d1
	bsr	Print


	lea	ShowMemAdrTxt3,a0
	move.l	#6,d1
	bsr	Print

	lea	$0,a0
	bsr	InputHexNum
	cmp.l	#-1,d0
	beq	.exit
	move.l	d0,ShowMemAdr-V(a6)
	bsr	binhex
	move.l	#2,d1
	bsr	Print

	lea	ShowMemTypeTxt,a0
	move.l	#6,d1
	bsr	Print

.Inploop:
	jsr	GetInput
	cmp.b	#1,BUTTON-V(a6)
	bne	.Inploop

	clr.l	d6				; clear d6 setting what type of read to do

	move.b	keypressed-V(a6),d0
	bclr	#5,d0				; make result uppercase
	cmp.b	#"B",d0
	beq	.byte

	cmp.b	#"W",d0
	beq	.word

	cmp.b	#"L",d0
	beq	.longword

	beq	.exit
.byte:
	lea	ByteTxt,a0
	bsr	Print
	move.l	#1,d6				; Set byte read
	bra	.next

.word:
	lea	WordTxt,a0
	bsr	Print
	move.l	#2,d6				; Set word read

	bra	.next

.longword:
	lea	LongWordTxt,a0
	bsr	Print
	move.l	#3,d6				; Set longword read

.next:

	lea	NewLineTxt,a0
	bsr	Print

	move.l	#0,d0
	move.l	#10,d1
	bsr	SetPos

	lea	ShowMemTxt,a0
	move.l	#5,d1
	bsr	Print

.loopa:
	move.l	#31,d0
	move.l	#10,d1
	bsr	SetPos
	move.l	ShowMemAdr-V(a6),a0		; Get memadress and put in a0
	clr.l	d0				; Clear d0 to be sure
	cmp.l	#1,d6				; are we in bytemode
	beq	.bytemode
	cmp.l	#2,d6
	beq	.wordmode
	move.l	(a0),d0
	bra	.modedone
.bytemode:
	move.b	(a0),d0
	bra	.modedone
.wordmode:
	move.w	(a0),d0

.modedone:
	cmp.l	d0,d7				; is it same as old value?
	beq	.same
	move.l	d0,d7
	cmp.l	#1,d6
	beq	.printbyte
	cmp.l	#2,d6
	beq	.printword
	bsr	binhex
	bra	.printdone
.printbyte:
	bsr	binhexbyte
	bra	.printdone
.printword:
	bsr	binhexword	
.printdone:
	move.w	#3,d1
	bsr	Print
.same:
	jsr	GetInput
	cmp.b	#1,BUTTON-V(a6)
	bne	.loopa
.exit:
	bra	OtherTest	



TF1260:						; Some TF360/TF1260 Diag tests
	ifeq	a1k

	cmp.b	#0,AutoConfDone-V(a6)		; Check if we had autoconfig done.
	bne	.done
	
	bsr	ClearScreen
	lea	TF1260Txt,a0
	move.l	#6,d1
	bsr	Print

	lea	NewLineTxt,a0
	bsr	Print


	lea	TF1260AutoConfNotTxt,a0
	move.l	#1,d1
	bsr	Print

	move.b	#0,AutoConfMode-V(a6)		; Set that we do not want a more detailed autoconfig mode
	bsr	DoAutoconfig



.done:						; Yes.. autoconfig is done..
	jsr	ClearScreen
	clr.l	TF1260IOStart-V(a6)
	clr.l	TF1260IOEnd-V(a6)
	clr.l	TF1260MemStart-V(a6)
	clr.l	TF1260MemEnd-V(a6)


	lea	TF1260Txt,a0
	move.l	#6,d1
	bsr	Print

	bsr	PrintCPU
	lea	FlagTxt,a0
	bsr	Print

	lea	PCRFlagsTxt,a0
	move.l	#2,d1
	bsr	Print
	move.l	PCRReg-V(a6),d0
	bsr	binstring
	move.l	#3,d1
	bsr	Print


	lea	AutoConfList-V(a6),a1
	move.l	AutoConfBoards-V(a6),d7
	sub.l	#1,d7
.loop:
	cmp.w	#5080,(a1)			; Check if we have correct manufacurer no.
	bne	.notright
						; ok we found one entry that seems correct
	clr.l	d0
	move.b	5(a1),d0			; Read flags to d0
	btst	#5,d0
	beq	.io

	move.l	6(a1),TF1260MemStart-V(a6)
	move.l	10(a1),TF1260MemEnd-V(a6)
	bra	.notright
.io:
	move.l	6(a1),TF1260IOStart-V(a6)
	move.l	10(a1),TF1260IOEnd-V(a6)
.notright:
	add.l	#14,a1				; go to nextblock in list

	dbf	d7,.loop			; loop through all cards.
	

	lea	TF1260ControllerTxt,a0
	move.l	#3,d1
	bsr	Print
	cmp.l	#0,TF1260IOStart-V(a6)
	bne	.TFCont

	lea	NOT,a0
	move.l	#1,d1
	bsr	Print
	lea	DDETECTED,a0
	bsr	Print
	bra	.CheckMem

.TFCont:
	lea	DETECTEDTxt,a0
	move.l	#2,d1
	bsr	Print

	lea	SpaceTxt,a0
	bsr	Print

	move.l	TF1260IOStart-V(a6),d0
	bsr	binhex
	move.l	#3,d1
	bsr	Print
	
	lea	MinusTxt,a0
	bsr	Print


	move.l	TF1260IOEnd-V(a6),d0
	bsr	binhex
	move.l	#3,d1
	bsr	Print


.CheckMem:
	lea	TF1260MemTxt,a0
	move.l	#3,d1
	bsr	Print

	cmp.l	#0,TF1260MemStart-V(a6)
	bne	.TFram

	lea	NOT,a0
	move.l	#1,d1
	bsr	Print
	lea	DDETECTED,a0
	bsr	Print
	bra	.Ramdone

.TFram:
	lea	DETECTEDTxt,a0
	move.l	#2,d1
	bsr	Print

	lea	SpaceTxt,a0
	bsr	Print

	move.l	TF1260MemStart-V(a6),d0
	bsr	binhex
	move.l	#3,d1
	bsr	Print
	
	lea	MinusTxt,a0
	bsr	Print


	move.l	TF1260MemEnd-V(a6),d0
	bsr	binhex
	move.l	#3,d1
	bsr	Print


.Ramdone:

	cmp.l	#0,TF1260IOStart-V(a6)
	bne	.ContFound

	lea	TF1260NotTxt,a0
	move.l	#1,d0
	bsr	Print
	bra	.loopa

.ContFound:

.loopa:
	jsr	GetInput
	cmp.b	#1,BUTTON-V(a6)
	bne	.loopa

;	bsr	WaitButton
	bra	OtherTest
	
	else
	bra	Not1K
	endc




RTCTest:
	ifeq	a1k

	jsr	ClearScreen

	bsr	DevPrint


	move.l	#0,d0
	move.l	#17,d1
	jsr	SetPos

	lea	RTCadjust1,a0
	move.l	#7,d1
	bsr	Print
	lea	RTCadjust10,a0
	move.l	#7,d1
	bsr	Print


	move.l	#0,d0
	move.l	#20,d1
	jsr	SetPos

	move.b	#$8,$dc0039	; do some reset

	lea	RTCIrq,a0
	move.l	#2,d1
	bsr	Print
	lea	RTCIrq2,a0
	move.l	#2,d1
	bsr	Print

	move.b	#$8,$dc0035	; more reset


	clr.l	RTCold-V(a6)
	clr.w	RTC1secframe-V(a6)
	clr.w	RTC10secframe-V(a6)
	clr.w	RTCsec-V(a6)
	clr.w	RTCirq-V(a6)
.loopa:
	move.b	#8,$dc0037
	bsr	WaitShort
	lea	$dc0003,a1
	clr.l	d0
	move.b	(a1),d0
	asl.l	#8,d0
	add.b	1(a1),d0
	asl.l	#8,d0
	add.b	2(a1),d0
	asl.l	#8,d0
	add.b	3(a1),d0			; Now we have read a longword. 68k friendly from odd address

;	move.b	$dff006,$dff181


	cmp.l	RTCold-V(a6),d0			; Check if first byte have changed.
	beq.w	.nochange
	move.l	d0,RTCold-V(a6)


	add.w	#1,RTCsec-V(a6)
	cmp.w	#10,RTCsec-V(a6)
	bne	.sec10				; do this every 10 second

	clr.w	RTCsec-V(a6)

	move.w	RTC10secframe-V(a6),d0
	cmp.w	#0,.skip10			; if we had a 0, we just started

	move.w	Frames-V(a6),d1
	move.w	d1,RTC10secframe-V(a6)
	sub.w	d0,d1
	clr.l	d7
	move.w	d1,d7

	move.l	#65,d0
	move.l	#18,d1
	jsr	SetPos
	clr.l	d1
	lea	FiveSpacesTxt,a0
	bsr	Print

	move.l	#65,d0
	move.l	#18,d1
	jsr	SetPos

	move.l	d7,d0
	bsr	bindec
	move.l	#3,d1
	bsr	Print


.sec10:

.skip10:
	move.w	RTC1secframe-V(a6),d0
	cmp.w	#0,.skip			; if we had a 0, we just started

	move.w	Frames-V(a6),d1
	move.w	d1,RTC1secframe-V(a6)
	sub.w	d0,d1
	clr.l	d7
	move.w	d1,d7

	move.l	#65,d0
	move.l	#17,d1
	jsr	SetPos
	clr.l	d1
	lea	FiveSpacesTxt,a0
	bsr	Print

	move.l	#65,d0
	move.l	#17,d1
	jsr	SetPos

	move.l	d7,d0
	bsr	bindec
	move.l	#3,d1
	bsr	Print
.skip:


	clr.l	d0
	clr.l	d1
	bsr	SetPos

	lea	RTCByteTxt,a0
	lea	RTCString-V(a6),a2
	move.l	#3,d1
	bsr	Print

	move.l	#13,d7
.loop:
	move.b	#8,$dc0037
	bsr	WaitShort
	clr.l	d0
	move.b	(a1),d0
	move.b	d0,d1
	and.b	#$f,d1				;Strip away top 4 bits
	move.b	d1,(a2)+
	bsr	binhexbyte
	move.l	#2,d1
	bsr	Print
	add.l	#4,a1
	dbf	d7,.loop

	lea	NewLineTxt,a0
	bsr	Print
	lea	NewLineTxt,a0
	bsr	Print


	lea	RTCBitTxt,a0
	move.l	#3,d1
	bsr	Print

	move.b	#8,$dc0037
	bsr	WaitShort

	lea	RTCString-V(a6),a1
	move.l	#13,d7
.loop1:
	clr.l	d0
	move.b	(a1)+,d0
	bsr	binstringbyte
	move.l	#2,d1
	bsr	Print
	lea	SpaceTxt,a0
	bsr	Print
	cmp.b	#7,d7
	bne	.nope
	lea	NewLineTxt,a0
	bsr	Print
.nope:
	dbf	d7,.loop1

	lea	NewLineTxt,a0
	bsr	Print
	lea	NewLineTxt,a0
	bsr	Print

	lea	RTCString-V(a6),a0		; load a0 to string from RTC
	

	bsr	ricoh
	bsr	oki


	clr.l	d0

.nochange:
	jsr	GetInput
	cmp.b	#1,LMB-V(a6)
	beq.s	.irq
	cmp.b	#" ",keyresult-V(a6)
	beq.s	.irq
	cmp.b	#1,BUTTON-V(a6)
	bne	.loopa
.end:
	cmp.w	#0,RTCirq-V(a6)			; did we run the IRQ code?
	beq	.noirq

	move.w	#$7fff,$dff09c			; Disable all INTREQ
	move.w	#$7fff,$dff09a			; Disable all INTREQ

	move.l	#RTEcode,$6c			; Restore IRC Vector to empty code

.noirq:
	bsr	WaitButton
	bra	OtherTest

.irq:
	cmp.b	#1,RMB-V(a6)
	beq.s	.end
	cmp.w	#0,RTCirq-V(a6)			; check if no IRQ is running
	bne	.running			; if it is go to running

	move.w	#1,RTCirq-V(a6)			; set it to 1
	
	clr.w	Frames-V(a6)			; Clear number frames
	clr.w	TickFrame-V(a6)
	clr.l	Ticks-V(a6)

	move.l	#CIALevTst,$6c			; Set up IRQ Level 3
	move.w	#$c020,$dff09a			; Enable IRQ
	move.w	#$c020,$dff09a			; Enable IRQ

	move.w	#$2000,sr			; Set SR to allow IRQs

	move.w	#$fff,$dff180



.running:
	bra	.loopa


ricoh:						; RICOH chipset detected.
	lea	RTCRicoh,a0
	move.l	#6,d1
	bsr	Print
	move.l	#2,d1
	lea	RTCString-V(a6),a0		; load a0 to string from RTC
	lea	RTCDay,a1
	clr.l	d0
	move.b	6(a0),d0
	mulu	#10,d0
	move.l	a1,a0
	add.l	d0,a0
	bsr	Print

	move.b	#" ",d0
	bsr	PrintChar


	lea	RTCString-V(a6),a0		; load a0 to string from RTC
	clr.l	d0
	move.b	12(a0),d0
	mulu	#10,d0
	add.b	11(a0),d0			; We have now the year, 2 digits

	cmp.b	#78,d0				; Check for 78
	bge	.r19				; more or equal to 78. we are in 19xx

	add.l	#2000,d0
	bra	.rno19
.r19:
	add.l	#1900,d0

.rno19
	bsr	bindec
	bsr	Print
						; Now year is printed
	move.b	#"-",d0
	bsr	PrintChar

	lea	RTCString-V(a6),a0		; load a0 to string from RTC

	clr.l	d0
	move.b	10(a0),d0
	mulu	#10,d0
	add.b	9(a0),d0			; We have now the month

	sub.l	#1,d0


	cmp.b	#12,d0
	blt	.rnoover
	move.l	#12,d0
.rnoover:
	mulu	#4,d0				; Multiply with 4 to get where string start

	lea	RTCMonth,a5
	move.l	a5,a0
	add.l	d0,a0
	bsr	Print

	move.b	#"-",d0
	bsr	PrintChar

	lea	RTCString-V(a6),a0		; load a0 to string from RTC
	clr.l	d0
	
	move.b	8(a0),d0
	add.b	#$30,d0
	bsr	PrintChar

	move.b	7(a0),d0
	add.b	#$30,d0
	bsr	PrintChar

	move.b	#" ",d0
	bsr	PrintChar

	lea	RTCString-V(a6),a0		; load a0 to string from RTC
	add.l	#6,a0
	move.l	#5,d7
	clr.l	d6				; Clear d6 as it is a counter when to print a :
.rloop:
	cmp.b	#2,d6				; time to print : ?
	bne	.rnocolon
	move.b	#":",d0
	bsr	PrintChar
	clr.l	d6
.rnocolon:
	add.l	#1,d6

	move.b	-(a0),d0
	add.b	#$30,d0
	bsr	PrintChar
	dbf	d7,.rloop


	lea	NewLineTxt,a0
	bsr	Print
	lea	NewLineTxt,a0
	bsr	Print
	rts

oki:
	lea	RTCOKI,a0
	move.l	#6,d1
	bsr	Print
	move.l	#2,d1
	lea	RTCString-V(a6),a0		; load a0 to string from RTC
	lea	RTCDay,a1
	clr.l	d0
	move.b	6(a0),d0
	mulu	#10,d0
	move.l	a1,a0
	add.l	d0,a0
	bsr	Print

	move.b	#" ",d0
	bsr	PrintChar


	lea	RTCString-V(a6),a0		; load a0 to string from RTC
	clr.l	d0
	move.b	11(a0),d0
	mulu	#10,d0
	add.b	10(a0),d0			; We have now the year, 2 digits

	add.l	#1900,d0
	bsr	bindec
	move.l	#2,d1
	bsr	Print


	move.b	#"-",d0
	bsr	PrintChar

	lea	RTCString-V(a6),a0		; load a0 to string from RTC

	clr.l	d0
	move.b	9(a0),d0
	mulu	#10,d0
	add.b	8(a0),d0			; We have now the month
	sub.l	#1,d0

	cmp.b	#11,d0
	blt	.okinoover
	move.l	#12,d0
.okinoover:
	mulu	#4,d0				; Multiply with 4 to get where string start


	lea	RTCMonth,a5
	move.l	a5,a0
	add.l	d0,a0
	bsr	Print

	move.b	#"-",d0
	bsr	PrintChar

	lea	RTCString-V(a6),a0		; load a0 to string from RTC
	clr.l	d0
	
	move.b	7(a0),d0
	add.b	#$30,d0
	bsr	PrintChar

	move.b	6(a0),d0
	add.b	#$30,d0
	bsr	PrintChar

	move.b	#" ",d0
	bsr	PrintChar

	lea	RTCString-V(a6),a0		; load a0 to string from RTC
	clr.l	d0
	clr.l	d7				; if d7 is not 0, we are in PM
	move.b	5(a0),d0
	btst	#2,d0
	beq	.ono
	move.b	#1,d7				; Set that we are in PM
	bclr	#2,d0

.ono:
	mulu	#10,d0
	add.b	4(a0),d0
	cmp.b	#0,d7
	beq.w	.ono1
	sub.b	#2,d0

	cmp.b	#254,d0
	beq.b	.oki8
	cmp.b	#255,d0
	beq.b	.oki9
	bra	.ono2
.oki8:
	move.b	#8,d0
	bra.s	.ono2
.oki9:
	move.b	#9,d0
	bra.w	.ono2
.ono2:
	add.b	#12,d0
.ono1:
	cmp.b	#9,d0
	bgt	.okilow
	PUSH
	move.b	#"0",d0
	bsr	PrintChar
	POP
.okilow:
	bsr	bindec
	bsr	Print

	move.b	#":",d0
	bsr	PrintChar

	lea	RTCString-V(a6),a0		; load a0 to string from RTC
	move.b	3(a0),d0
	add.b	#"0",d0
	bsr	PrintChar
	lea	RTCString-V(a6),a0		; load a0 to string from RTC
	move.b	2(a0),d0
	add.b	#"0",d0
	bsr	PrintChar
	move.b	#":",d0
	bsr	PrintChar

	lea	RTCString-V(a6),a0		; load a0 to string from RTC
	move.b	1(a0),d0
	add.b	#"0",d0
	bsr	PrintChar
	lea	RTCString-V(a6),a0		; load a0 to string from RTC
	move.b	(a0),d0
	add.b	#"0",d0
	bsr	PrintChar
	rts


	else
	bra	Not1K
	endc


;------------------------------------------------------------------------------------------


AutoConfig:	
	ifeq	a1k
				; Do Autoconfigmagic
	jsr	ClearScreen
	move.b	#0,AutoConfMode-V(a6)		; Set that we do not want a more detailed autoconfig mode
	bsr	DoAutoconfig
	bsr	PrintBoards
	lea	NewLineTxt,a0
	bsr	Print
	lea	NewLineTxt,a0
	bsr	Print
	jsr	ClearBuffer

	lea	AnyKeyMouseTxt,a0
	move.l	#3,d1
	bsr	Print
	bsr	WaitButton
	bra	MainMenu
	else
	bra	Not1K
	endc


AutoConfigDetail:				; Do Autoconfigmagic
	ifeq	a1k
	jsr	ClearScreen
	move.b	#1,AutoConfMode-V(a6)		; Set that we want a more detailed autoconfig mode
	bsr	DoAutoconfig

	bsr	PrintBoards
	lea	NewLineTxt,a0
	bsr	Print
	lea	NewLineTxt,a0
	bsr	Print
	jsr	ClearBuffer


	lea	AnyKeyMouseTxt,a0
	move.l	#3,d1
	bsr	Print
	bsr	WaitButton
	bra	MainMenu


; Autoconfigcode.  based much Terriblefires code, Added support for several cards
; and more information.

E_EXPANSIONBASE		EQU	$e80000
EZ3_EXPANSIONBASE	EQU	$ff000000

ERT_TYPEMASK		EQU	$c0	;Bits 7-6
ERT_TYPEBIT		EQU	6
ERT_TYPESIZE		EQU	2
ERT_NEWBOARD		EQU	$c0
ERT_ZORROII		EQU	ERT_NEWBOARD
ERT_ZORROIII		EQU	$80
; ** other bits defined in er_Type **
; ** er_Type field memory size bits ** 
ERT_MEMMASK		EQU	$07	;Bits 2-0
ERT_MEMBIT		EQU	0
ERT_MEMSIZE		EQU	3
	
			rsreset
er_Type 		rs.b	1	;Board type, size and flags
er_Product		rs.b	1	;Product number, assigned by manufacturer
er_Flags		rs.b	1	;Flags
er_Reserved03		rs.b	1	;Must be zero ($ff inverted)
er_Manufacturer 	rs.w	1	;Unique ID,ASSIGNED BY COMMODORE-AMIGA!
er_SerialNumber 	rs.l	1	;Available for use by manufacturer
er_InitDiagVec		rs.w	1	;Offset to optional "DiagArea" structure
er_Reserved0c		rs.b	1
er_Reserved0d		rs.b	1
er_Reserved0e		rs.b	1
er_Reserved0f		rs.b	1
ExpansionRom_SIZEOF	rs.b	0

			rsreset
ec_Interrupt		rs.b	1	;Optional interrupt control register
ec_Z3_HighBase		rs.b	1	;Zorro III   : Bits 24-31 of config address
ec_BaseAddress		rs.b	1	;Zorro II/III: Bits 16-23 of config address
ec_Shutup		rs.b	1	;The system writes here to shut up a board
ec_Reserved14		rs.b	1
ec_Reserved15		rs.b	1
ec_Reserved16		rs.b	1
ec_Reserved17		rs.b	1
ec_Reserved18		rs.b	1
ec_Reserved19		rs.b	1
ec_Reserved1a		rs.b	1
ec_Reserved1b		rs.b	1
ec_Reserved1c		rs.b	1
ec_Reserved1d		rs.b	1
ec_Reserved1e		rs.b	1
ec_Reserved1f		rs.b	1
ExpansionControl_SIZEOF rs.b	0

DoAutoconfig:
	lea	AutoConfBuffer-V(a6),a2
	move.b	#$20,AutoConfZ2Ram-V(a6)
	move.w	#$4000,AutoConfZ3-V(a6)	; Set defaultvalues for different cardtypes
	move.b	#$20,AutoConfZ2Ram-V(a6)
	move.b	#$e9,AutoConfZ2IO-V(a6)

	lea	AutoConfZ2Txt,a0
	move.l	#6,d1
	bsr	Print


	move.l	#1,d6			; Clear boardnumber
.loopz2:
	lea	E_EXPANSIONBASE,a0
	bsr	.ReadRom
	cmp.b	#0,AutoConfType-V(a6)	; Check type of card, if 0, no card found
	beq	.noz2	
	lea	E_EXPANSIONBASE,a0
	bsr	.WriteByte

	add.l	#1,d6
	cmp.l	#32,d6			; if we hit 32 boards.. something is wrong, exit
	bgt	.toomuch
	cmp.b	#0,AutoConfExit-V(a6)	; Check the force exitflag
	bne	.noz3
	bra	.loopz2
.noz2:


	lea	AutoConfZ3Txt,a0
	move.l	#6,d1
	bsr	Print

.loopz3:
	lea	EZ3_EXPANSIONBASE,a0
	bsr	.ReadRom
	cmp.b	#0,AutoConfType-V(a6)	; Check type of card, if 0, no card found
	beq	.noz3	
	bsr	.WriteByte
	add.l	#1,d6
	cmp.l	#32,d6			; if we hit 32 boards.. something is wrong, exit
	bgt	.toomuch
	cmp.b	#0,AutoConfExit-V(a6)	; Check the force exitflag
	bne	.noz3

	bra	.loopz3
.noz3:

	lea	AutoConfAllTxt,a0
	move.l	#6,d1
	bsr	Print

	rts	
.toomuch:
	lea	AutoConfToomuchTxt,a0
	move.l	#1,d1
	bra	Print

.ReadRom:
	clr.b	AutoConfType-V(a6)	; Set type to 0 (no card found)
	clr.b	AutoConfZorro-V(a6)	; Set zorrotype to 2 (0)
	clr.l	AutoConfSize-V(a6)	; Clear the size of the board

	clr.l	d0
	move.l	a0,a3			; Backup of card
	move.l	a2,a4			; Backup of zorrobuffer
	bsr	.ReadByte

	move.b	d0,(a2)+
	; All other bytes are inverted
	moveq.l	#1,d2
.ReadRomLoop:
	move.l	d2,d0
	move.l	a3,a0			; Huh
	bsr	.ReadByte
	not.b	d0
	move.b	d0,(a2)+
	addq.w	#1,d2
	cmp.w	#ExpansionRom_SIZEOF,d2	; check if we read enough data
	bls.s	.ReadRomLoop

	move.l	a4,a2			; Restore zorrobuffer

	tst.b	er_Reserved03(a2)	; Check if it is 0, if not, we have no card
	bne	.NoCard

	tst	er_Manufacturer(a2)	; Check if it is 0, if so, we have no card
	beq	.NoCard

	move.b	er_Flags(a2),AutoConfFlag-V(a6)


	cmp.b	#0,AutoConfMode-V(a6)
	beq	.nodetail


	PUSH
	lea	AutoConfBoardTxt,a0
	move.l	#5,d1
	bsr	Print
	move.l	d6,d0			; Take boardnumber to d0
	bsr	bindec
	move.l	#2,d1
	bsr	Print

	lea	AutoConfManuTxt,a0
	move.l	#3,d1
	bsr	Print

	move.w	er_Manufacturer(a2),d0
	bsr	bindec
	move.w	#2,d1
	bsr	Print

	lea	AutoConfSerTxt,a0
	move.l	#3,d1
	bsr	Print

	move.w	er_SerialNumber(a2),d0
	bsr	bindec
	move.w	#2,d1
	bsr	Print

	lea	AutoConfZorTypeTxt,a0
	move.l	#3,d1
	bsr	Print	

	clr.l	d0			; Print if it is Zorro II or III
	move.b	er_Type(a2),d0
	and.b	#$c0,d0			; Strip out all except top 2 bits
	cmp.b	#$c0,d0
	beq	.readz2
	lea	III,a0
	move.l	#6,d1
	bsr	Print
	bra	.readz3
.readz2:
	lea	II,a0
	move.l	#6,d1
	bsr	Print

.readz3:

	lea	AutoConfLinkTxt,a0
	move.l	#3,d1
	bsr	Print	

	btst	#5,er_Type(a2)		; Check if it is Linked to system pool (RAM)
	beq	.readnomem
	bsr	PrintYes
	bra	.readmem
.readnomem:
	bsr	PrintNo
.readmem:
	lea	AutoConfAutoBTxt,a0
	move.l	#3,d1
	bsr	Print	

	btst	#4,er_Type(a2)		; Check if there is any Autobootstuff
	bne	.readnoboot
	bsr	PrintNo
	bra	.readboot
.readnoboot:
	bsr	PrintYes
.readboot:


	lea	AutoConfLinked2NextTxt,a0
	move.l	#3,d1
	bsr	Print	

	btst	#4,er_Type(a2)		; Check if linked to next card
	beq	.readnolink
	bsr	PrintYes
	bra	.readlink
.readnolink:
	bsr	PrintNo
.readlink:

	lea	AutoConfExtSizeTxt,a0
	move.l	#3,d1
	bsr	Print

	clr.l	d7			; Clear d7 to have as a variable. if changed we have extended size

	btst	#5,er_Flags(a2)		; Check if Extended sizes will be used
	beq	.readnoextsize
	moveq.l	#1,d7			; Set d7 to 1, we have extended sizes
	bsr	PrintYes
	bra	.readextsize
.readnoextsize:
	bsr	PrintNo
.readextsize:
	lea	AutoConfSizeTxt,a0
	move.l	#3,d1
	bsr	Print	

	clr.l	d0
	move.b	er_Type(a2),d0
	move.b	d0,AutoConfFlag-V(a6)
	and.b	#7,d0			; D0 now contains sizebits
	asl	#2,d0			; Multiply with 4, to get correct location in pointerlist
	lea	SizeTxtPointer,a0
	cmp.b	#0,d7			; Check if d7 is 0, if so we have not extended size
	beq	.readnoext
	lea	ExtSizeTxtPointer,a0
.readnoext:
	move.l	(a0,d0.l),a0		; A0 now points to the correct textstring
	move.l	#2,d1
	bsr	Print

	lea	AutoConfBufTxt,a0
	move.l	#6,d1
	bsr	Print
	move.l	a2,a1
	move.l	#ExpansionRom_SIZEOF-1,d7
.printloop:
	move.b	(a1)+,d0
	bsr	binhexbyte
	move.l	#2,d1
	bsr	Print
	lea	SpaceTxt,a0
	bsr	Print
	dbf	d7,.printloop

	move.l	a4,a2			; Restore backup of zorrobuffer
	POP
.nodetail:

					; ok detailed VERBOSE output done, lets do it "again" quiet and set variables.



	btst	#5,er_Type(a2)		; Check if it is Linked to system pool (RAM)
	beq	.readsetnomem
	move.b	#2,AutoConfType-V(a6)	; Set type to 2 = RAM
	bra	.readsetmem
.readsetnomem:
	clr.l	d0
	move.b	er_Type(a2),d0
	and	#7,d0
	
	cmp	#2,d0			; Check if space is more than 128K then allocate it to Z2 area instead. (but not ram)
	bge	.readsetz2space


	move.b	#1,AutoConfType-V(a6)	; Set type to 1 = ROM
.readsetmem:


	clr.l	d0			; Check if it is Zorro II or III
	move.b	er_Type(a2),d0
	and.b	#$c0,d0			; Strip out all except top 2 bits
	cmp.b	#$c0,d0
	beq	.readsetz2
	move.b	#1,AutoConfZorro-V(a6)
	bra	.readsetz3
.readsetz2space:			; To be assigned in Z2 space, but not RAM
	move.b	#3,AutoConfType-V(a6)	; Set type to 3 = Z2Space no ram
	bra	.readsetz3

.readsetz2:
	move.b	#0,AutoConfZorro-V(a6)
	bra	.noz3force
.readsetz3:

	move.b	#1,AutoConfZorro-V(a6)
.noz3force:

	clr.l	d7			; Clear d7 to have as a variable. if changed we have extended size
	btst	#5,er_Flags(a2)		; Check if Extended sizes will be used
	beq	.readsetnoextsize
	moveq.l	#1,d7			; Set d7 to 1, we have extended sizes
.readsetnoextsize:

	clr.l	d0
	move.b	er_Type(a2),d0
	and.b	#7,d0			; D0 now contains sizebits
	asl	#2,d0			; Multiply with 4, to get correct location in pointerlist


	lea	SizePointer,a0
	cmp.b	#0,d7			; Check if d7 is 0, if so we have not extended size
	beq	.readsetnoext
	lea	ExtSizePointer,a0
.readsetnoext:
	move.l	(a0,d0.l),d0		; D0 now contains the size of the card.

	move.l	d0,AutoConfSize-V(a6)	; Write the size to the buffer
	rts
.NoCard:
	move.b	#0,AutoConfType-V(a6)	; Ser that we have no card
	rts

.ReadByte:			; Reads one byte from Cardexpansion.

	bsr	WaitLong	; Put in some wait here, so slow boards can wake up aswell
	bsr	WaitLong	; Put in some wait here, so slow boards can wake up aswell


				; IN:
				; 	D0 = Location into buffer to read
				;	A0 = Card
				;	A2 = Destionationbuffer
				; OUT:
				;	D0 = Byte read

	lsl.w	#2,d0		;	Multiply with 4
	lea.l	0(a0,d0.w),a0	; a0 now contain pointer to real card.

	move.l	a0,d1
	bmi	.Z3		; Check for Z3
	move.b	$2(a0),d1
	bra	.doRead
.Z3:
	move.b	$100(a0),d1
.doRead:
	lsr.b	#4,d1		; Strip away so we just keep a nibble
	moveq.l	#0,d0
	move.b	(a0),d0
	and.b	#$f0,d0		; Strip away so we just keep a nibble
	or.b	d1,d0		; Put those 2 nibbles together, and we get a byte read.
	rts

.WriteByte:				; Write configbyte to configure card. (ok WORD for Z3!)
	clr.b	AutoConfIllegal-V(a6)	; Clear the illegalflag
	clr.l	d0
	lea	NewLineTxt,a0
	bsr	Print

	move.b	AutoConfType-V(a6),d0	; Get what type of card
	cmp.b	#0,d0			; No card found
	beq	.exit
	cmp.b	#1,AutoConfZorro-V(a6)	; Check if Z3 Card
	beq	.WriteZ3
	cmp.b	#1,d0			; Check if Z2 ROM
	beq	.WriteZ2IO
	cmp.b	#3,d0			; Check if Z3 Area card (NO RAM)
	beq	.WriteZ2noram

	lea	AutoConfRamCardTxt,a0	; We got a Z2 RAM Card
	clr.l	d1
	move.b	AutoConfZ2Ram-V(a6),d1
	move.w	d1,AutoConfWByte-V(a6)
	move.l	d1,d0
	swap	d0
	move.l	d0,AutoConfAddr-V(a6)
	add.l	AutoConfSize-V(a6),d0
	cmp.l	#$a00002,d0
	blo	.writenoz2illegal
	PUSH
	lea	AutoConfIllegalTxt,a0
	move.l	#1,d1
	bsr	Print
	move.b	#1,AutoConfIllegal-V(a6)	; Set the illegal flag
	POP
.writenoz2illegal:
	swap	d0
	move.b	d0,AutoConfZ2Ram-V(a6)
	move.l	a3,a1			; Copy backup of expansionbase to a1.
	bra	.Write

.WriteZ2noram:
	lea	AutoConfRomCardTxt,a0	; We got a Z2 RAM Card
	clr.l	d1
	move.b	AutoConfZ2Ram-V(a6),d1
	move.w	d1,AutoConfWByte-V(a6)
	move.l	d1,d0
	swap	d0
	move.l	d0,AutoConfAddr-V(a6)
	add.l	AutoConfSize-V(a6),d0
	cmp.l	#$c0000002,d0
	blo	.writenoz3illegal
	PUSH
	lea	AutoConfIllegalTxt,a0
	move.l	#1,d1
	bsr	Print
	move.b	#1,AutoConfIllegal-V(a6)	; Set the illegal flag
	POP
.writenoz3illegal:


	swap	d0
	move.b	d0,AutoConfZ2Ram-V(a6)
	move.l	a3,a1
	bra	.Write


.WriteZ3:
	lea	AutoConfZ3CardTxt,a0	; We got a Z3 Card
	clr.l	d1
	move.w	AutoConfZ3-V(a6),d1	; Get address to assign to
	move.w	d1,AutoConfWByte-V(a6)	; Write that info to the byte to be written
	move.l	d1,d0
	swap	d0
	move.l	d0,AutoConfAddr-V(a6)	; Write it to the register to keep info about adr
	add.l	AutoConfSize-V(a6),d0
	swap	d0
	move.w	d0,AutoConfZ3-V(a6)	; Set the size?
	move.l	a3,a1
	bra	.Write			; write the data

.WriteZ2IO:
	lea	AutoConfRomCardTxt,a0	; We got a Z2 ROM Card
	clr.l	d1

	move.b	AutoConfZ2IO-V(a6),d1
	clr.l	d1
	move.b	AutoConfZ2IO-V(a6),d1
	move.w	d1,AutoConfWByte-V(a6)
	move.l	d1,d0
	swap	d0
	move.l	d0,AutoConfAddr-V(a6)
	add.l	AutoConfSize-V(a6),d0
	swap	d0
	move.b	d0,AutoConfZ2IO-V(a6)
	move.l	a3,a1
	bra	.Write

.Write:					; OK! we have a card, not Z3 or Z2io. it must be Z2 RAM!

	move.b	#1,AutoConfDone-V(a6)		; Set that we have done autoconfig
	cmp.b	#0,AutoConfIllegal-V(a6)	; Check if the illegalfag was set
	bne	.WriteNoAssign			; it was not 0, so it is set, shutdown card

	move.l	AutoConfBoards-V(a6),d3
	mulu	#14,d3
	lea	AutoConfList-V(a6),a5
	add.l	d3,a5
	add.l	#1,AutoConfBoards-V(a6)
	move.w	er_Manufacturer(a2),(a5)+
	move.w	er_SerialNumber(a2),(a5)+
	move.b	er_Type(a2),(a5)+
	move.b	er_Flags(a2),(a5)+


	move.l	d1,d3				; Store the address into d3 as backup
	move.l	#2,d1
	bsr	Print				; print the string stored in a0

					; IN now:
					; A0 = String to output
					; D0 = Startadr of Autoconfig, cleartext
					; D2 = Endadr
					; D3 = Startadr of Autoconfig, short
					; A1 = Expansionbase

	move.l	AutoConfAddr-V(a6),d0	; Get address to assign board to
	move.l	d0,d2			; Store size in D2
	move.l	d0,(a5)+
	bsr	binhex
	move.l	#6,d1
	bsr	Print			; Prints the address to write
	lea	MinusTxt,a0
	move.l	#3,d1
	bsr	Print			; Prints " - "

	move.l	d2,d0			; move back size to D0
	add.l	AutoConfSize-V(a6),d0	; Add the size, to get the endaddress
	sub.l	#1,d0
	move.l	d0,(a5)+
	bsr	binhex
	move.l	#6,d1
	bsr	Print			; Prints the and address

	lea	NewLineTxt,a0
	bsr	Print			; Makes a new line

	cmp.b	#0,AutoConfMode-V(a6)
	beq	.WriteFast		; ok we are in "fast" mode.. so no verbose...
	lea	AutoConfEnableTxt,a0
	move.l	#2,d1
	bsr	Print

	clr.b	AutoConfExit-V(a6)	; Clear the force exitflag
.WriteLoop:
	jsr	GetInput		; Get inputdata
	cmp.b	#0,BUTTON-V(a6)
	beq	.WriteLoop
	cmp.b	#1,LMB-V(a6)
	beq	.WriteFast
	cmp.b	#1,RMB-V(a6)	
	beq	.WriteNoAssign
	move.b	GetCharData-V(a6),d7	; Get chardata
	bclr	#5,d7			; Make it uppercase
	cmp.b	#"Y",d7
	beq	.WriteFast
	cmp.b	#"N",d7
	beq	.WriteNoAssign
	cmp.b	#$1b,d7
	beq	.forceexit
	bra	.WriteLoop		; Simply we have now printed all data, and asked user what to do. and loop until answered.

.WriteFast:
	move.l	a1,a0			; Set correct Expansionbase
	move.l	d3,d1
	move.l	#ec_BaseAddress+ExpansionRom_SIZEOF,d0
	bsr	.WriteCard
	bra	.EndWrite

.WriteNoAssign:
	move.l	a1,a0			; Set correct Expansionbase
	moveq	#ec_Shutup+ExpansionRom_SIZEOF,d0
	bsr	.WriteCard		; Send shutup
	move.l	#-2,d0

.exit:
	bra	.EndWrite
.forceexit:
	move.b	#1,AutoConfExit-V(a6)	; Set force exit flag
.EndWrite:
	rts				; Card is written and we are done!


.WriteCard:
	clr.l	d1
	move.w	AutoConfWByte-V(a6),d1	; Get data to write

;	cmp.b	#0,AutoConfMode-V(a6)	; Check if we want a more verbose config-
;	beq	.WriteCardFast		; Why the F..  did I do this?? kinda pointless..  humm
	
.WriteCardFast:
	lsl.l	#2,d0			; Multiply with 4

	move.l	a0,a1
	lea.l	0(a0,d0.w),a0

	cmp.b	#1,AutoConfZorro-V(a6)	; Check if the board is Z3
	beq	.writez3

	move.l	d1,d0			; take the byte to write
	lsl.b	#4,d0			; Split it up to nibbles
	move.b	d0,$2(a0)
	move.b	d1,(a0)			; Write the byte to the card (as 2 nibbles)
	rts

.writez3:
	move.l	d1,d2
	move.l	d1,d0
	lsl.b	#4,d0
	move.b	d0,$100(a0)
	move.b	d1,(a0)
	move.l	a1,a0
	move.l	#$48,d0
	lea	0(a0,d0.w),a0
	move.b	d2,(a0)


	move.l	a1,a0
	move.l	#$44,d0
	lea	0(a0,d0.w),a0
	move.w	d2,(a0)

.dowrite:
	rts


PrintBoards:
	lea	AutoConfBoardsTxt,a0
	move.l	#6,d1
	bsr	Print

	lea	AutoConfList-V(a6),a1
	move.l	AutoConfBoards-V(a6),d0		; Get number of boards

	move.l	d0,d6
	bsr	bindec
	move.l	#2,d1
	bsr	Print

	move.l	d6,d0


	cmp.l	#0,d0
	beq	.printdone

	sub.l	#1,d6
	
.loop:
	lea	AutoConfManuTxt2,a0
	bsr	Print
	clr.l	d0
	move.w	(a1)+,d0			; Get manufacturer
	bsr	bindec
	bsr	Print

	lea	SlashTxt,a0
	bsr	Print

	move.w	(a1)+,d0			; Get Serialno
	bsr	bindec
	bsr	Print

	lea	AutoconfZorType2Txt,a0
	bsr	Print

	clr.l	d0
	move.b	(a1)+,d0			; Get type
	move.b	(a1)+,d5			;get Flag

	move.b	d0,d7			; Store d0 into d7 for future use

	and.b	#$c0,d0			; Strip out all except top 2 bits
	cmp.b	#$c0,d0
	beq	.readz2
	lea	III,a0
	move.l	#6,d1
	bset	#2,d7			; to fool print that we are not io
	bsr	Print
	bra	.readz3
.readz2:
	lea	II,a0
	move.l	#6,d1
	bsr	Print

.readz3:
	lea	SpaceTxt,a0
	bsr	Print

	btst	#2,d7
	beq	.readnomem
	lea	RAMTxt,a0
	bsr	Print
	bra	.readmem
.readnomem:
	lea	IOTxt,a0
	bsr	Print
.readmem:

	lea	SpaceTxt,a0
	bsr	Print


	move.l	d7,d0			; Restore d7 to d0 to handle what size we have
	clr.l	d7			; Clear d7 to have as a variable. if changed we have extended size
	btst	#5,d5			; Check if Extended sizes will be used
	beq	.readnoextsize
	moveq.l	#1,d7			; Set d7 to 1, we have extended sizes
.readnoextsize:


	and.b	#7,d0			; D0 now contains sizebits
	asl	#2,d0			; Multiply with 4, to get correct location in pointerlist


	lea	SizeTxtPointer,a0
	cmp.b	#0,d7			; Check if d7 is 0, if so we have not extended size
	beq	.readnoext
	lea	ExtSizeTxtPointer,a0
.readnoext:
	move.l	(a0,d0.l),a0		; A0 now points to the correct textstring
	move.l	#2,d1
	bsr	Print



	lea	StartTxt,a0
	bsr	Print

	move.l	(a1)+,d0
	bsr	binhex
	bsr	Print
	lea	EndTxt,a0
	bsr	Print
	move.l	(a1)+,d0
	bsr	binhex
	bsr	Print	
	
	dbf	d6,.loop
.printdone:
	rts
	else
	bra	Not1K
	endc
	



Detectallmemory:
	jsr	ClearScreen
	move.w	#"RN",DetectMemRnd-V(a6)	; "put in RN" at detectMemRnd to have some data
	add.w	#1,DetectMemRnd+2-V(a6)		; Increase by 1 to have a number that changes every call
	lea	Det24bittxt,a0
	move.l	#5,d1
	jsr	Print

	clr.l	FastmemBlock-V(a6)

	lea	$200000,a1
	lea	$d00000,a4	; endaddress of this pass
	bsr	.memloop	

	lea	Det32bittxt,a0
	move.l	#5,d1
	jsr	Print

	cmp.b	#1,ADR24BIT-V(a6)	; Check if we had 24 bit cpu...
	bne	.no24bit

	lea	No32bittxt,a0
	move.l	#1,d1
	jsr	Print
	bra	.24bit
.no24bit:

	cmp.l	#" PPC",$f00090	; Check if the string "PPC" is located in rom at this address. if so we have a BPPC
				; that will disable the 68k cpu onboard if memory  below $40000000 is tested.
	bne	.nobppc
	lea	$40000000,a1	; Strangly enough.  bppc detected memory will be totally just plain WRONG! I guess it does stuff in rom
	bra	.bppc		; that makes a more decent memorymap. Now it just finds lots of smaller shadows..
	
.nobppc:
	lea	$1000000,a1
.bppc:
	lea	$f0000000,a4	; endaddress of this pass
	bsr	.memloop	
.24bit:

	lea	Totmemtxt,a0
	move.l	#6,d1
	jsr	Print

	move.l	FastmemBlock-V(a6),d0
	move.l	d0,d1
	asl.l	#6,d1
	move.l	d1,TotalFast-V(a6)
	bsr	.PrintSize

	lea	NewLineTxt,a0
	jsr	Print
	lea	NewLineTxt,a0
	jsr	Print



	lea	AnyKeyMouseTxt,a0
	move.l	#5,d1
	jsr	Print

	bsr	WaitPressed
	bsr	WaitReleased
	bra	MemtestMenu

.memloop:
	clr.l	d1
	move.l	a4,a2		; Set a2 to endaddress of scan
	lea	.leadone,a3
	move.l	DetectMemRnd-V(a6),d0	; store a "random" data in d0 for shadowcontrol

	bra	DetectMemory

.leadone:
	add.l	d1,FastmemBlock-V(a6)

	cmp.l	#0,a0
	bne	.mem
	
	lea	EndMemTxt,a0
	move.l	#3,d1
	jsr	Print
	bra	.end
.mem:
	cmp.l	#0,d1		; check if size was 0, that means this memory is "illegal" and should be skipped
	beq	.blockdone
	
	move.l	a0,a2		; Store address of first mem found into a2
	move.l	d1,d2		; copy size to d2
	
	lea	DetMem,a0
	move.l	#2,d1
	jsr	Print

	move.l	d2,d0		; copy size to d0


	bsr	.PrintSize
	
	lea	DetOfmem,a0
	jsr	Print

	move.l	a2,d0		; Print first memaddress
	bsr	binhex
	jsr	Print

	lea	MinusTxt,a0
	jsr	Print

	move.l	a1,d0		; Print end memaddress
	bsr	binhex
	jsr	Print

	lea	NewLineTxt,a0
	jsr	Print

				; ok we now had the endaddress at the same register Detectmemory uses as START. so lets check if we are at end of
.blockdone
				; memarea and if not, just loop until we are done.
	add.l	#64*1024,a1	; Add 64k for next block to test, just in case

	cmp.l	a4,a1
	blo	.memloop
.end:
	rts

.PrintSize:
	cmp.l	#32,d0		; Check if we had more than 4 blocks (2048k)  if so.. lets show in MB instead.
	bge	.showMB
	asl.l	#6,d0		; convert number of 16k blocks to real value of kb
	bsr	bindec
	move.l	#2,d1
	jsr	Print		; print it
	lea	KB,a0
	jsr	Print
	bra	.donesize

.showMB:			; convert number of 16k blocks to real value of mb
	asr.l	#4,d0
	bsr	bindec
	move.l	#2,d1
	jsr	Print		; print it
	lea	MB,a0
	jsr	Print
.donesize:
	rts



DetectMemory:
					; D1 Total block of known working ram in 16K blocks (clear before first use)
					; A0 first usable addr
					; a1 First addr to scan
					; a2 Addr to end
					; a3 Addr to jump after done (as this does not use any stack
					; only OK registers to use as write: (d1), d2,d3,d4,d5,d6,d7, a0,a1,a2,a5


					; D0 is a special "in" never to be modified but taken as a "random" generator for shadowcontrol

					; OUT:	d1 = blocks of found mem
					;	a0 = first usable address
					;	a1 = last usable address


	move.l	a1,d7
	and.l	#$fffffffc,d7		; just strip so we always work in longword area (just to be sure)
	move.l	d7,a1

	move.l	a3,d7			; Store jumpaddress in D7
	lea	$0,a0			; clear a0
.Detect:
	lea	MEMCheckPattern,a3
	move.l	(a1),d3			; Take a backup of content in memory to D3

.loop:

	cmp.l	a1,a2			; check if we tested all memory
	blo	.wearedone		; we have, we are done!

	move.l	(a3)+,d2		; Store value to test for in D2	

	move.l	d2,(a1)			; Store testvalue to a1
	move.l	#"CRAP",4(a1)		; Just to put crap at databus. so if a stuck buffer reads what is last written will get crap
	
	nop
	nop
	nop
	move.l	(a1),d4			; read value from a1 to d4
	move.l	(a1),d4			; read value from a1 to d4
	move.l	(a1),d4			; read value from a1 to d4
	move.l	(a1),d4			; read value from a1 to d4
	move.l	(a1),d4			; read value from a1 to d4
	move.l	(a1),d4			; read value from a1 to d4
	move.l	(a1),d4			; read value from a1 to d4
	move.l	(a1),d4			; read value from a1 to d4
	move.l	(a1),d4			; read value from a1 to d4
	move.l	(a1),d4			; read value from a1 to d4
					; Reading several times.  as sometimes reading once will give the correct answer on bad areas.

	cmp.l	d4,d2			; Compare values
	bne	.failed			; ok failed, no working ram here.


	cmp.l	#0,d2			; was value 0? ok end of list
	bne	.loop			; if not, lets do this test again
					; we had 0, we have working RAM

	move.l	a1,a5			; OK lets see if this is actual CORRECT ram and now just a shadow.

	move.l	a5,(a1)			; So we store the address we found in that location.
	move.l	#32,d6			; ok we do test 31 bits
	move.l	a5,d5

.loopa:


	cmp.l	#0,d6
	beq	.done			; we went all to bit 0.. we are done I guess

	sub.l	#1,d6
	cmp.l	#0,d6
	beq	.done			; we went all to bit 0.. we are done I guess	---------


	btst	d6,d5			; scan until it isnt a 0
	beq.s	.loopa
.bitloop:

	bclr	d6,d5			; ok. we are at that address, lets clear first bit of that address
	move.l	d5,a3


	cmp.l	(a3),a5			; ok check if that address contains the address we detected, if so. we have a "shadow"
	beq	.shadow

	cmp.l	#0,a3			; it was 0, so we "assume" we got memory
	beq	.mem

					; ok we didnt have a shadow here
					; a5 will contain address if there was detected ram
	sub.l	#1,d6

	cmp.l	#4,d6
	beq	.mem			; ok we was at 4 bits away..  we can be PRETTY sure we do not have a shadow here.  we found mem

	bra	.bitloop

.mem:
	move.l	d3,(a1)			; restore backup of data

	cmp.l	(a1),d0			; check if value at a1 is the same as d0. this means we have a shadow on top and we have already tested
	beq	.shadowdone			; this memory.  basically: we are done


	cmp.l	#0,a0			; check if a0 was 0, if so, this is the first working address
	bne	.wehadmem
	move.l	a5,a0			; so a5 contained the address we found, copy it to a0
	move.l	d7,16(a1)		; ok store d7 into what a1 points to.. to say that this is a block of mem)

.wehadmem:

	add.l	#4,d1			; OK we found mem, lets add 4 do d1(as old routine was 64K blocks  now 256.  being lazy)
	bra	.next

.wearedone:
	bra	.done

.shadow:
	TOGGLEPWRLED			; Flash with powerled doing this.. 

.failed:


	move.l	d3,(a1)			; restore backup of data
	cmp.l	#0,a0			; ok was a0 0? if so, we havent found memory that works yet, lets loop until all area is tested
	bne	.done

.next:

	move.l	d0,(a1)			; put a note at the first found address. to mark this as already tagged
	move.l	a0,4(a1)		; put a note of first block found
	move.l	a1,8(a1)		; where this block was
	move.l	d1,12(a1)		; total amount of 64k blocks found
					; Strangly enough. this seems to also write onscreen at diagrom?

	add.l	#256*1024,a1		; Add 256k for next block to test
	bra	.Detect
.shadowdone:
	TOGGLEPWRLED			; Flash with powerled doing this.. 
.done:

	move.l	d7,a3			; Restore jumpaddress
	sub.l	#1,a1
	jmp	(a3)



GetHWReg:					; Dumps all readable HW registers to memory
	move.w	$dff000,BLTDDAT-V(a6)
	move.w	$dff002,DMACONR-V(a6)
	move.w	$dff004,VPOSR-V(a6)
	move.w	$dff006,VHPOSR-V(a6)
	move.w	$dff008,DSKDATR-V(a6)
	move.w	$dff00a,JOY0DAT-V(a6)
	move.w	$dff00c,JOY1DAT-V(a6)
	move.w	$dff00e,CLXDAT-V(a6)
	move.w	$dff010,ADKCONR-V(a6)
	move.w	$dff012,POT0DAT-V(a6)
	move.w	$dff014,POT1DAT-V(a6)
	move.w	$dff016,POTINP-V(a6)
	move.w	$dff018,SERDATR-V(a6)
	move.w	$dff01a,DSKBYTR-V(a6)
	move.w	$dff01c,INTENAR-V(a6)
	move.w	$dff01e,INTREQR-V(a6)
	move.w	$dff07c,DENISEID-V(a6)
	move.w	$dff1da,HHPOSR-V(a6)
	rts





;------------------------------------------------------------------------------------------

DiskTest:
	bsr	InitScreen
	move.w	#8,MenuNumber-V(a6)
	move.b	#1,PrintMenuFlag-V(a6)
	jmp	MainLoop




DiskdriveTest:
	move.l	#12980,d0			; Size of a track
	bsr	GetChip				; get chipmemaddress for this block
	cmp.l	#0,d0
	beq	.exit
	move.l	d0,trackbuff-V(a6)
	bsr	.Initdisk

.DiskdriveTester:
	jsr	ClearScreen
	clr.b	oldbfe001-V(a6)
	clr.b	oldbfd100-V(a6)

	move.w	#0,MenuNumber-V(a6)
	move.b	#1,PrintMenuFlag-V(a6)
	move.l	#DriveTestMenu,Menu-V(a6)	; Set different menu




	move.l	a6,d0
	add.l	#DriveTestVar-V,d0		; Pointer to variables
	move.l	d0,a0
	move.l	d0,MenuVariable-V(a6)


.loop:
	bsr	.StepToTrack			; Check if drivestepping is needed, if so do it
	move.l	MenuVariable-V(a6),a0		; Load a0 with pointer to where variable is
	clr.l	d0
	move.w	DriveNo-V(a6),d0		; Load with drivenumber
	mulu	#5,d0				; Multiply it with 4 to get to correct drivetext
	lea	DF0,a1
	add.l	d0,a1
	move.w	DriveOK-V(a6),d0
	cmp.b	#0,d0
	bne	.driveok
	move.w	#1,(a0)+
	bra	.okdone
.driveok:
	move.w	#2,(a0)+
.okdone:
	move.l	a1,(a0)+
	
	move.l	#6,d0				; Show Tracknumber
	move.l	#2,d1
	jsr	SetPos
	lea	Track,a0
	move.l	#3,d1
	jsr	Print
	lea	Space3,a0
	jsr	Print
	move.l	#13,d0
	move.l	#2,d1
	jsr	SetPos

	clr.l	d0
	move.b	TrackNo-V(a6),d0
	jsr	bindec
	move.l	#5,d1
	jsr	Print

	clr.l	d7				; Clear d7, if still clear after those 2 tests, nothing to update
	move.b	$bfe001,d0
	cmp.b	oldbfe001-V(a6),d0
	beq	.nobfe001change
	move.b	d0,oldbfe001-V(a6)
	move.b	#1,d7				; just set d7 to something
.nobfe001change:
	move.b	$bfd100,d0
	cmp.b	oldbfd100-V(a6),d0
	beq	.nobfd100change
	move.b	d0,oldbfd100-V(a6)
	move.b	#1,d7
.nobfd100change:
	cmp.b	#0,d7
	beq	.noupdate			; we had no update. skip to print it
	

	move.l	#18,d0				; Show diskside
	move.l	#2,d1
	jsr	SetPos
	lea	Side,a0
	move.l	#3,d1
	jsr	Print
	cmp.b	#0,SideNo-V(a6)
	bne	.Lower
	lea	UPPER,a0
	move.l	#5,d1
	jsr	Print
;	bclr.b	#2,$bfd100

	bra	.SideDone
.Lower:
	lea	LOWER,a0
	move.l	#5,d1
	jsr	Print
;	bset.b	#2,$bfd100

.SideDone:

	move.l	#32,d0				; Show motorstatus
	move.l	#2,d1
	jsr	SetPos
	lea	Motor,a0
	move.l	#3,d1
	jsr	Print
	btst	#7,$bfd100
	beq	.MotorIsOn
	lea	OFF,a0
	move.l	#5,d1
	jsr	Print
	bra	.MotorDone
.MotorIsOn:
	lea	ON,a0
	move.l	#5,d1
	jsr	Print

.MotorDone:


	move.l	#45,d0				; Show writeprotectionstatus
	move.l	#2,d1
	jsr	SetPos
	lea	WProtect,a0
	move.l	#3,d1
	jsr	Print
	btst	#3,$bfe001
	beq	.nowrite
	lea	OFF,a0
	move.l	#2,d1
	jsr	Print
	bra	.writedone
.nowrite:
	lea	ON,a0
	move.l	#1,d1
	jsr	Print
.writedone:
	move.l	#64,d0				; Show disk status
	move.l	#2,d1
	jsr	SetPos
	lea	DiskIN,a0
	move.l	#3,d1
	jsr	Print
	btst	#2,$bfe001
	beq	.nochange
	lea	YES,a0
	move.l	#2,d1
	jsr	Print
	bra	.changedone
.nochange:
	lea	NO,a0
	move.l	#1,d1
	jsr	Print
.changedone:


	move.l	#6,d0				; Show Tracknumber
	move.l	#3,d1
	jsr	SetPos
	lea	RDY,a0
	move.l	#3,d1
	jsr	Print

	btst	#5,$bfe001
	bne	.nordy
	lea	YES,a0
	move.l	#2,d1
	jsr	Print
	bra	.rdydone
.nordy:
	lea	NO,a0
	move.l	#1,d1
	jsr	Print
.rdydone:

	move.l	#18,d0				; Show Tracknumber
	move.l	#3,d1
	jsr	SetPos
	lea	TRACK0,a0
	move.l	#3,d1
	jsr	Print

	btst	#4,$bfe001
	bne	.notrk0
	lea	YES,a0
	move.l	#2,d1
	jsr	Print
	bra	.trk0done
.notrk0:
	lea	NO,a0
	move.l	#1,d1
	jsr	Print

.trk0done:
	move.l	#36,d0
	move.l	#3,d1
	jsr	SetPos
	lea	BFE001Txt,a0
	move.l	#3,d1
	jsr	Print
	move.b	$bfe001,d0
	jsr	binstringbyte
	move.l	#6,d1
	jsr	Print


	move.l	#56,d0
	move.l	#3,d1
	jsr	SetPos
	lea	BFD100Txt,a0
	move.l	#3,d1
	jsr	Print

	move.b	$bfd100,d0
	jsr	binstringbyte
	move.l	#6,d1
	jsr	Print

.noupdate:
	jsr	PrintMenu
	jsr	GetInput
	bsr	WaitLong
	cmp.b	#0,d0
	beq	.no


	move.b	keyresult-V(a6),d1		; Read value from last keyboard read
	cmp.b	#$a,d1				; if it was enter, select this item
	beq	.action
	move.b	Serial-V(a6),d2			; Read value from last serialread
	cmp.b	#$a,d2
	beq	.action
	cmp.b	#1,LMB-V(a6)
	beq	.action

	lea	DriveTestMenuKey,a5		; Load list of keys in menu
	clr.l	d0				; Clear d0, this is selected item in list

.keyloop:
	move.b	(a5)+,d3			; Read item
	cmp.b	#0,d3				; Check if end of list
	beq	.nokey
	cmp.b	d1,d3				; fits with keyboardread?
	beq	.goaction
	cmp.b	d2,d3				; fits with serialread?
	beq	.goaction			; if so..  do it
	add.l	#1,d0				; Add one to d0, selecting next item
	bra	.keyloop
.goaction:
	move.b	d0,MenuPos-V(a6)
	bra	.action

.nokey:	
	cmp.b	#1,RMB
	beq	.Exitjump
	bra	.no
.Exitjump:
	jmp	Exit

.action:
	bsr	WaitReleased

	clr.l	d0
	move.b	MenuPos-V(a6),d0

	cmp.b	#0,d0				; Check if it is item 0, meaning change drive ID
	beq	.ChangeDrive

	cmp.b	#1,d0
	beq	.Motor

	cmp.b	#2,d0
	beq	.Side

	cmp.b	#3,d0
	beq	.TrackOut

	cmp.b	#4,d0
	beq	.TrackIn

	cmp.b	#5,d0
	beq	.Track10Out

	cmp.b	#6,d0
	beq	.Track10In

	cmp.b	#7,d0
	beq	.ReadTrack

	cmp.b	#8,d0
	beq	.WriteTrack

	cmp.b	#9,d0
	beq	.ShowMem

	cmp.b	#11,d0
	beq	MainMenu


.no:
	bra	.loop

.ChangeDrive:
	move.b	#1,UpdateMenuNumber-V(a6)
	move.b	#2,PrintMenuFlag-V(a6)

	add.w	#1,DriveNo-V(a6)		; Bump up drivenumber with 1
	cmp.w	#4,DriveNo-V(a6)		; if it is too high
	bne	.nowrap
	clr.w	DriveNo-V(a6)			; Reset the counter
.nowrap
	bsr	.SelectDrive
	bsr	.GotoZero
	bra	.no


.Motor:
	bchg	#0,DriveMotor-V(a6)
	cmp.b	#0,DriveMotor-V(a6)
	bne	.SetMotorOn
	bsr	.MotorOff
	bra	.MotorSetDone
.SetMotorOn:
	lea	ON,a0
	move.l	#5,d1
	jsr	Print
	bsr	.MotorOn
.MotorSetDone:
	bra	.no


.Side:
	bchg	#0,SideNo-V(a6)
	bra	.no

.TrackOut:
	add.b	#1,WantedTrackNo-V(a6)
	cmp.b	#84,WantedTrackNo-V(a6)
	beq	.outover
	bra	.no
.outover:
	move.b	#83,WantedTrackNo-V(a6)
	bra	.no


.TrackIn:
	sub.b	#1,WantedTrackNo-V(a6)
	cmp.b	#255,WantedTrackNo-V(a6)
	beq	.outless
	bra	.no
.outless
	move.b	#0,WantedTrackNo-V(a6)
	bra	.no

.Initdisk:
	move.w	#$4489,$dff07e			; Disk sync pattern register for disk read
	move.w	#$7f00,$dff09e			; Audio, Disk, UART Control
	move.w	#$9500,$dff09e			; Check later what it does... MEMPREC, FAST, WORDSYNC set
	clr.w	DriveNo-V(a6)			; Set drivenumber to 0
	bsr	.SelectDrive			; Select the drive
	bsr	.GotoZero			; Step to track 0
	bsr	.UnSelectDrive
	rts
		
.Track10Out:
	add.b	#10,WantedTrackNo-V(a6)
	cmp.b	#83,WantedTrackNo-V(a6)
	bge	.outover
	bra	.no

.Track10In:
	sub.b	#10,WantedTrackNo-V(a6)
	cmp.b	#255,WantedTrackNo-V(a6)
	ble	.outless
	bra	.no

.GotoZero:					; Steps back to track 0
	move.w	#1,DriveOK-V(a6)		; Set Drive as OK
	move.l	#84,d7				; Do this for 85 times (meaning more tracks than on a disk)
.ZeroLoop
	bsr	WaitLong			; Wait for a while

	btst	#4,$bfe001			; Are we at track 0?
	bne	.nozero
	clr.b	TrackNo-V(a6)			; Clear trackno
	clr.b	WantedTrackNo-V(a6)		; Also clear the wanted trackno, or it will just step there.
	rts
.nozero:
	move.w	#$ff,$dff180
	bset.b	#1,$bfd100			; CIAB_DSKDIREC
	bclr.b	#0,$bfd100			; Step
	tst	$dff1fe
	bset	#0,$bfd100
	dbf	d7,.ZeroLoop			; do this until all "tracks" are done, if this loop goes to an end. we have for sure no diskdrive
	clr.w	DriveOK-V(a6)			; Set that drive was NOT ok

	rts

.StepToTrack:					; Check the WantedTrackNo and steps one step to that direction
	clr.l	d0
	move.b	WantedTrackNo-V(a6),d0		; Load D0 with the wanted track
	cmp.b	TrackNo-V(a6),d0
	beq	.AlreadyThere			; ok we are already at wanted position. do nothing
	blt	.GoIn				; Lets step in
	bgt	.GoOut
.AlreadyThere:
	rts

.GoOut:
	bsr	.SelectDrive
	bsr	WaitLong
	bclr.b	#1,$bfd100			; CIAB_DSKDIREC
	bclr.b	#0,$bfd100			; Step
	tst	$dff1fe
	bset	#0,$bfd100
	add.b	#1,TrackNo-V(a6)
	bsr	WaitLong
	bsr	.UnSelectDrive
	rts

.GoIn:
	bsr	.SelectDrive
	bsr	WaitLong
	bset.b	#1,$bfd100			; CIAB_DSKDIREC
	bclr.b	#0,$bfd100			; Step
	tst	$dff1fe
	bset	#0,$bfd100
	sub.b	#1,TrackNo-V(a6)
	bsr	WaitLong
	bsr	.UnSelectDrive
	rts


.MotorOff:
	bsr	.SelectDrive
	or.b	#$78,$bfd100			; Deselect all drives
	bsr	WaitLong
	clr.l	d0
	move.w	DriveNo-V(a6),d0		; load A6 with drive to select
	add.w	#3,d0				; Add 3 to it.  now we know what bit to clear to select drive
	bset.b	#7,$bfd100			; CIAB_DSKMOTOR
	bsr	WaitLong
	bclr.b	d0,$bfd100			; CIAB_DSKSEL0	Select that drive
	bsr	.UnSelectDrive

	rts

.MotorOn:
	bsr	.SelectDrive
	bsr	WaitLong
	clr.l	d0
	move.w	DriveNo-V(a6),d0		; load A6 with drive to select
	add.w	#3,d0				; Add 3 to it.  now we know what bit to clear to select drive
	bclr.b	#7,$bfd100			; CIAB_DSKMOTOR
	bsr	WaitLong
	bclr.b	d0,$bfd100			; CIAB_DSKSEL0	Select that drive
	rts

.SelectDrive:
	bsr	.UnSelectDrive
	clr.l	d0
	move.w	DriveNo-V(a6),d0		; load D0 with drive to select
	add.w	#3,d0				; Add 3 to it.  now we know what bit to clear to select drive
	bclr.b	d0,$bfd100			; Select that drive
	bsr	WaitLong
	rts

.UnSelectDrive:
	or.b	#$78,$bfd100			; Deselect all drives
	bsr	WaitLong
	rts

.ReadTrack:
	bsr	.SelectDrive
	bsr	WaitLong
	bsr	.MotorOn
	bsr	.WaitReady
	bsr	.SelectDrive			; YEAH!  again
	
	move.w	#$4000,$dff024
	move.l	trackbuff-V(a6),$dff020
	move.w	#$4489,$dff07e
	move.w	#$7f00,$dff09e
	move.w	#$9500,$dff09e
	move.w	#2,$dff09c	
	move.w	#$8210,$dff096

	move.w	#$8000+$1900,d1
	move.w	d1,$dff024
	move.w	d1,$dff024

	move.w	#$fff,$dff180
	move.l	#$ffffff,d7
.waittrack:
	move.b	$bfe001,d0			; Nonsenseread, to just make loop slower
	sub.l	#1,d7
	cmp.l	#0,d7
	beq	.timeout
	btst	#1,$dff01f
	beq	.waittrack
.timeout:
	move.w	#$4000,$dff024
	bsr	WaitLong
	bsr	.MotorOff
	bsr	WaitLong
	bsr	.UnSelectDrive
	bra	.no


.WriteTrack:
	bsr	.SelectDrive
	bsr	WaitLong
	bsr	.MotorOn
	bsr	.WaitReady
	bsr	.SelectDrive			; YEAH!  again!

;	move.w	#$4000,$dff024
	move.l	trackbuff-V(a6),$dff020
;	move.w	#$4489,$dff07e
	move.w	#$7f00,$dff09e
	move.w	#$8100,$dff09e
	move.w	#2,$dff09c	
	move.w	#$8210,$dff096

	move.w	#$d978,$dff024
	move.w	#$d978,$dff024

	move.w	#$f00,$dff180
	move.l	#$ffffff,d7
.waittrack2:
	move.b	$bfe001,d0			; Nonsenseread, to just make loop slower
	sub.l	#1,d7
	cmp.l	#0,d7
	beq	.timeout2
	btst	#1,$dff01f
	beq	.waittrack2
.timeout2:
	move.w	#$4000,$dff024
	bsr	.UnSelectDrive
	bra	.no



.WaitReady:
	move.l	#$ffff,d7
.waitrdy:
	move.b	$bfe001,d0
	sub.l	#1,d7
	cmp.l	#0,d7
	beq	.readytimeout
	btst	#5,$bfe001
	beq	.waitrdy
.readytimeout:
	rts
	
.ShowMem:
	clr.l	d3				; Sector to find
.Showmems:
	jsr	ClearScreen

	PUSH


	bsr	.FindSector
	cmp.l	#-1,d0				; Was d0 -1, then we had an error
	beq	.sectorerror

	lea	$38(a1),a1
	clr.l	d6				; Clear rowcounter
	clr.l	d5				; clear "address" of how far into buffer we are

	

.secloop:
	lea	sectorbuff-V(a6),a2
	bsr	.decodebuffer
	PUSH
	move.l	d6,d0
	lea	sectorbuff-V(a6),a0
	bsr	.Showdata
	POP
	add.l	#$10,d5
	add.l	#1,d6
	cmp.l	#20,d6
	bne	.secloop	
	POP

	lea	AnyKeyMouseTxt,a0
	move.l	#4,d1
	jsr	Print
.exloop:
	jsr	GetInput
	cmp.b	#0,BUTTON-V(a6)
	beq	.exloop


	cmp.b	#1,RMB-V(a6)

; 	bne.w	.Showmems
	
	bra	.DiskdriveTester



.exit:
	jmp	MainMenu

.decodebuffer:					; Decodes a small part of the MFM buffer to be able to print it.
	move.l	#$55555555,d7
	move.l	#3,d4
.decode:
	move.l	$200(a1),d1
	move.l	(a1)+,d0
	and.l	d7,d0
	asl.l	#1,d0
	and.l	d7,d1
	or.l	d1,d0
	move.l	d0,(a2)+			; Store it in the small buffer

	dbra	d4,.decode
	rts

.sectorerror
	jsr	ClearScreen
	lea	SectorErrorTxt,a0
	move.l	#1,d1
	jsr	Print
	lea	AnyKeyMouseTxt,a0
	move.l	#4,d1
	jsr	Print
	bsr	WaitButton
	bra	.DiskdriveTester


.FindSector
	move.l	trackbuff-V(a6),a0		; A0 now contains pointer to where the MFM data is
	move.l	a0,a1
	move.w	#$4489,d5			; Syncword
	move.l	#$55555555,d7

	clr.l	d3
;	move.b	sector-V(a6),d3			; Load d3 with the wanted sector
	move.l	a0,d6
	add.l	#12980,d6			; D6 now contains the last address of trackbuffer
.getsync:
	cmp.l	a1,d6
	blt	.overflow			; ok we went too far
	cmp.w	(a1)+,d5
	bne.s	.getsync
;	cmp.w	(a1),d5				; Another syncword?
;	beq.s	.getsync




;	add.l	#6,a1
	move.l	(a1),d0
	move.l	4(a1),d1

	and.l	d7,d0
	asl.l	#1,d0
	and.l	d7,d1
	or.l	d1,d0
	ror.l	#8,d0

	PUSH
	jsr	binhex
	move.l	#3,d1
	jsr	Print
	clr.l	d0
	move.b	#" ",d0
	jsr	PrintChar

	move.l	a1,d0
	jsr	binhex
	move.l	#5,d1
	jsr	Print
	clr.l	d0
	move.b	#" ",d0
	jsr	PrintChar


	POP
 
;	cmp.b	d3,d0				; Are we on correct sector?
;	beq	.sectorOK			; Yes
	move.b	d0,sector-V(a6)

.sectorOK:	
	clr.l	d0
	rts

.overflow:
	move.l	#-1,d0				; Set d0 to -1 to show that we had an error.
	rts


.Showdata:
	PUSH
	move.l	a0,a1				; store a0 in a1 for usage here.. as a0 is used
	add.l	#3,d0				; Add 3 to line to work on.
	move.l	d0,d1				; copy d0 to d1 to use it as Y adress
	clr.l	d0				; clear X pos
	jsr	SetPos				; Set position
	
	move.l	d5,d0
	jsr	binhex
	move.l	#6,d1
	jsr	Print				; Print address

	clr.l	d2				; Column to print
	move.l	#15,d7
.showloop:
	lea	SpaceTxt,a0
	jsr	Print
	clr.l	d0				; Clear d0 just to be sure
	move.b	(a1,d2),d0
	jsr	binhexbyte			; Convert that byte to hex
	move.l	#7,d1
	jsr	Print				; Print it
	add.l	#1,d2
	dbf	d7,.showloop
	lea	ColonTxt,a0			; Print a Colon
	move.l	#3,d1
	jsr	Print

	move.l	#15,d7				; Now print the same bytes.  as chars instead	
	clr.l	d2
.showloop2:
	clr.l	d0
	move.b	(a1,d2),d0
	jsr	MakePrintable			; make the char printable.  strip controlstuff..
	add.l	#1,d2
	move.l	#7,d1
	jsr	PrintChar
	dbf	d7,.showloop2
	POP
	rts

GAYLE_ADDR: 	equ	$da8000
GAYLE_ID_ADDR:	equ	$de1000


; Gaylecodehelp from Stephen Leary

GayleExp:
	ifeq	a1k
	
	jsr	ClearScreen


	lea	$dd201c,a5
	bsr	WaitRDY


	lea	NewLineTxt,a0
	jsr	Print

	cmp.b	#0,d2
	beq	.exit			; we had a timeout.  go to nointexit

	lea	NewLineTxt,a0
	jsr	Print


	move.b	#$ec,d0				; Read the drive ID
	move.b	d0,$dd201c




	move.l	$dd2020,a2			; IDE_Slow
	move.b	$1c(a2),d1			; AT_Status. clears interrupt (IDE)

	PUSH
	lea	IDEInterruptCleared,a0
	move.l	#3,d1
	jsr	Print
	POP

	bsr	IDECheckStatus

	move.w	SR,d2				; Save current SR
	ori.w	#$700,sr			; Raise int priority to level 7
	move.b	$1000(a0),d1			; Gayle_intchange

	PUSH
	lea	IDEInterruptChangedReading,a0
	move.l	#3,d1
	jsr	Print
	POP

	move.w	d1,d0
	PUSH
	jsr	binhex
	move.l	#3,d1
	jsr	Print
	lea	NewLineTxt,a0
	jsr	Print
	POP




	lea	$dd2020,a2			; IDE_Slow
	bsr	IDEReadData

	move.l	DiskBuffer-V(a6),d0
	move.l	d0,a4				; A4 now contains pointer to diskbuffer


	lea	IDESurfacesTxt,a0
	move.l	#3,d1
	jsr	Print

	clr.l	d0
	move.w	$6a(a4),d0
	jsr	bindec
	move.l	#2,d1
	jsr	Print

	
	lea	IDESectorsTxt,a0
	move.l	#3,d1
	jsr	Print

	move.w	$6c(a4),d0
	jsr	bindec
	move.l	#2,d1
	jsr	Print



	lea	IDECylindersTxt,a0
	move.l	#3,d1
	jsr	Print

	move.w	$68(a4),d0
	jsr	bindec
	move.l	#2,d1
	jsr	Print


	lea	IDEBlkSize,a0
	move.l	#3,d1
	jsr	Print

	move.w	$6(a4),d0
	jsr	bindec
	move.l	#2,d1
	jsr	Print

	lea	NewLineTxt,a0
	jsr	Print


	lea	IDEUnitTxt,a0
	move.l	#3,d1
	jsr	Print


	move.l	a4,a5
	add.l	#$32,a5				; step to unitname  (2d)

	move.l	#31,d7
.unitloop:
	clr.l	d0
	move.b	(a5)+,d0
	jsr	MakePrintable
	move.l	#2,d1
	jsr	PrintChar
	dbf	d7,.unitloop

	lea	REVTxt,a0
	move.l	#3,d1
	jsr	Print

	move.l	a4,a5
	add.l	#$2d,a5				; step to unitname  (2d)

	move.l	#4,d7
.unitrevloop:
	clr.l	d0
	move.b	(a5)+,d0
	jsr	MakePrintable
	move.l	#2,d1
	jsr	PrintChar
	dbf	d7,.unitrevloop



	lea	NewLineTxt,a0
	jsr	Print



	bsr	IDECheckStatus

.exit:

	lea	AnyKeyMouseTxt,a0
	move.l	#4,d1
	jsr	Print

	bsr	WaitPressed
.no_hw:
	jmp	MainMenu

	else
	bra	Not1K
	endc


GayleTest:
	ifeq	a1k

	jsr	ClearScreen

	lea	GayleCheckMirrorTxt,a0
	move.l	#6,d1
	jsr	Print


	lea	GAYLE_ID_ADDR,a1			; Read Gayle address
	move.w	$dff01c,-(sp)			; Store value if intena in stack
	move.w	#$bfff,$9a(a1)			; set all enables
	move.w	#$3fff,d2			; also flag for no mirror
	cmp.w	$dff01c,d2
	bne	.nomirror
	move.w	d2,$9a(a1)			; Clear all enables
	tst	$dff01c
	bne.s	.nomirror
	moveq	#0,d2				; Mirrored

	lea	GayleMirrorTxt,a0
	move.l	#3,d1
	jsr	Print

.nomirror:
	move.w	#$3fff,$dff09c			; Clear bits
	ori.w	#$8000,(sp)			; add setbit
	move.w	(sp)+,$dff09c			; Reset values
	tst.w	d2				; Did we find mirroring
	beq	.no_hw				; yes we did. quit

	lea	GayleNoMirrorTxt,a0
	move.l	#3,d1
	jsr	Print

	lea	GayleVerTxt,a0
	move.l	#7,d1
	jsr	Print


	moveq	#0,d2
	move.b	d2,(a1)				; Value doesnt matter, just a write needed
	
	bsr	.get_gid_bit			; Get 4 bits
	bsr	.get_gid_bit
	bsr	.get_gid_bit
	bsr	.get_gid_bit
	bsr	.get_gid_bit			; Get 4 bits
	bsr	.get_gid_bit
	bsr	.get_gid_bit
	bsr	.get_gid_bit


	move.w	d2,d0
	jsr	binhexbyte
	move.l	#2,d1
	jsr	Print

	cmp.b	#$d1,d2				; Check for version $d1 (A1200 Gayle)
	beq.w	.A1200

	cmp.b	#$d0,d2				; Check for version $d0 (A600 Gayle)
	beq.s	.A600

	and.b	#$d0,d2				; mask out numbers.. so we can find if there are any other Dx versions..

	cmp.b	#$d0,d2				; Check for version $d0 can now be any Dx version.. so lets call it "unknown" if found
	beq.s	.Other
	

	lea	NoGayleTxt,a0
	move.l	#2,d1
	jsr	Print

	lea	AnyKeyMouseTxt,a0
	move.l	#4,d1
	jsr	Print

.done:
	bsr	WaitPressed
	jmp	MainMenu

.no_hw:
	lea	GayleNoIDETxt,a0
	move.w	#1,d1
	jsr	Print
	bra	.done

.Other:
	lea	UnknownTxt,a0
	move.l	#3,d1
	jsr	Print

	lea	NewLineTxt,a0
	jsr	Print
	bra	.GayleFound


.A600:
	lea	A600Txt,a0
	move.l	#3,d1
	jsr	Print

	lea	NewLineTxt,a0
	jsr	Print
	bra	.GayleFound

.A1200:
	lea	A1200Txt,a0
	move.l	#3,d1
	jsr	Print

	lea	NewLineTxt,a0
	jsr	Print
	bra	.GayleFound

.GayleFound:
	lea	GayleIDETxt,a0
	move.w	#2,d1
	jsr	Print

	lea	$da001c,a5
	bsr	WaitRDY

	lea	NewLineTxt,a0
	jsr	Print

	cmp.b	#0,d2
	beq	.nointexit			; we had a timeout.  go to nointexit

	move.b	#$ec,d0				; Read the drive ID
	bsr	.IDECommand

.BoardServer:
	PUSH
	lea	IDEInterruptCheck,a0
	move.l	#3,d1
	jsr	Print
	POP

	moveq.l	#0,d0				; Assume it is not out interrupt
	lea	GAYLE_ADDR,a0			; Point to the board
	move.b	$1000(a0),d1			; IntChange check for int!
	bpl	.nointexit			; not ours

	PUSH
	lea	IDEInterruptDetected,a0
	move.l	#3,d1
	jsr	Print
	POP

	bsr	IDECheckStatus
						; Our interrupt, clear it
						; must clear drive first, then gayle
	move.l	$da0000,a2			; IDE_Slow
	move.b	$1c(a2),d1			; AT_Status. clears interrupt (IDE)

	PUSH
	lea	IDEInterruptCleared,a0
	move.l	#3,d1
	jsr	Print
	POP

	bsr	IDECheckStatus

	move.w	SR,d2				; Save current SR
	ori.w	#$700,sr			; Raise int priority to level 7
	move.b	$1000(a0),d1			; Gayle_intchange

	PUSH
	lea	IDEInterruptChangedReading,a0
	move.l	#3,d1
	jsr	Print
	POP

	move.w	d1,d0
	PUSH
	jsr	binhex
	move.l	#3,d1
	jsr	Print
	lea	NewLineTxt,a0
	jsr	Print
	POP

	move.b	d1,$1000(a0)			; Clear latch in gayle
	move.w	d2,sr				; Reenable normal int level

	lea	$da2002,a2			; IDE_Slow
	bsr	IDEReadData

	move.l	DiskBuffer-V(a6),d0
	move.l	d0,a4				; A4 now contains pointer to diskbuffer


	lea	IDESurfacesTxt,a0
	move.l	#3,d1
	jsr	Print

	clr.l	d0
	move.w	$6a(a4),d0
	jsr	bindec
	move.l	#2,d1
	jsr	Print

	
	lea	IDESectorsTxt,a0
	move.l	#3,d1
	jsr	Print

	move.w	$6c(a4),d0
	jsr	bindec
	move.l	#2,d1
	jsr	Print



	lea	IDECylindersTxt,a0
	move.l	#3,d1
	jsr	Print

	move.w	$68(a4),d0
	jsr	bindec
	move.l	#2,d1
	jsr	Print


	lea	IDEBlkSize,a0
	move.l	#3,d1
	jsr	Print

	move.w	$6(a4),d0
	jsr	bindec
	move.l	#2,d1
	jsr	Print

	lea	NewLineTxt,a0
	jsr	Print


	lea	IDEUnitTxt,a0
	move.l	#3,d1
	jsr	Print


	move.l	a4,a5
	add.l	#$32,a5				; step to unitname  (2d)

	move.l	#31,d7
.unitloop:
	clr.l	d0
	move.b	(a5)+,d0
	jsr	MakePrintable
	move.l	#2,d1
	jsr	PrintChar
	dbf	d7,.unitloop

	lea	REVTxt,a0
	move.l	#3,d1
	jsr	Print

	move.l	a4,a5
	add.l	#$2d,a5				; step to unitname  (2d)

	move.l	#4,d7
.unitrevloop:
	clr.l	d0
	move.b	(a5)+,d0
	jsr	MakePrintable
	move.l	#2,d1
	jsr	PrintChar
	dbf	d7,.unitrevloop



	lea	NewLineTxt,a0
	jsr	Print



	bsr	IDECheckStatus


.nointexit:

.endIDTests:
	

	bra	.done

.get_gid_bit:					; Read a gary/Gayle bit
	move.b	(a1),d0
	lsl.b	#1,d0
	roxl.b	#1,d2
	rts


.IDECommand:
	move.b	d0,$da001c
	rts

IDECheckStatus:
	PUSH
	lea	IDEInterruptStatusReading,a0
	move.l	#3,d1
	jsr	Print
	POP

	move.b	$da8000,d0
	PUSH
	jsr	binhex
	move.l	#3,d1
	jsr	Print
	lea	NewLineTxt,a0
	jsr	Print
	POP
	rts

IDEReadData:

	move.l	#4096,d0
	bsr	GetChip				; Get block of 4K

	move.l	d0,DiskBuffer-V(a6)

	move.l	d0,a4				; move memoryaddress to a4 so we can use it


	; print about ide rea

	PUSH
	lea	GayleIDERead,a0
	move.l	#3,d1
	jsr	Print
	POP
	
	move.l	#0,d3
.loopide:
	move.w	0(a2),d0			; AT_Data;

	move.l	d0,d1
	asr.l	#8,d1
	asl.l	#8,d0
	add.b	d1,d0				; now word is byteswapped


	move.w	d0,(a4)+
	add.l	#1,d3
	cmp.l	#1024,d3
	ble	.loopide

	lea	Donetxt,a0
	move.l	#3,d1
	jsr	Print

.nomem:
	rts



WaitRDY:
	move.w	#50,d0
	move.w	d0,GayleData-V(a6)
	move.l	#1,d7				; retrycounter
.loop:
	move.w	GayleData-V(a6),d2
	sub.w	#1,d2
	move.w	d2,GayleData-V(a6)

	PUSH
	lea	GayleRDYTxt,a0
	move.l	#2,d1
	jsr	Print
	POP


	move.b	(a5),d0			; Statuscommand
	and.b	#$c1,d0
	move.b	d0,d4
		
	PUSH
	jsr	binhexbyte
	move.w	#3,d1
	jsr	Print

	move.l	#32,d0
	jsr	PrintChar
	move.l	#40,d0
	jsr	PrintChar

	POP

	move.w	(a5),d0
	PUSH
	jsr	binhexword
	move.l	#3,d1
	jsr	Print
	move.l	#41,d0
	jsr	PrintChar

	lea	TryTxt,a0
	jsr	Print
	move.l	d7,d0
	jsr	bindec
	jsr	Print
	jsr	SameRow
	POP	

	add.l	#1,d7

	move.w	GayleData-V(a6),d2
	cmp.w	#0,d2
	beq	.nodisk


	cmp.b	#$40,d4
	bne	.loop
	bra	.exit
.nodisk:
	lea	NoDiskTxt,a0
	move.l	#3,d1
	jsr	Print
.exit:
	rts

	
PrintYes:
	lea	YES,a0
	move.l	#2,d1
	jsr	Print
	rts

PrintNo:
	lea	NO,a0
	move.l	#1,d1
	jsr	Print
	rts

	else
	bra	Not1K
	endc


;------------------------------------------------------------------------------------------



DevPrint:
	clr.l	d0
	move.l	#25,d1
	jsr	SetPos
	lea	UnderDevTxt,a0
	move.l	#1,d1
	jsr	Print
	clr.l	d0
	clr.l	d1
	jsr	SetPos
	rts


NotImplemented:
	jsr	ClearScreen
	lea	NotImplTxt,a0
	move.l	#1,d1
	jsr	Print

	lea	AnyKeyMouseTxt,a0
	move.l	#2,d1
	jsr	Print
	
	bsr	DebugScreen
	bsr	WaitButton
	jmp	MainMenu


Not1K:
	jsr	ClearScreen
	lea	NotA1kTxt,a0
	move.l	#1,d1
	jsr	Print
	bsr	WaitButton
	jmp	MainMenu


DebugScreen:					; This dumps out registers..

	PUSH

	clr.l	d0
	move.l	#2,d1
	jsr	SetPos
	lea	DebugTxt,a0
	move.l	#3,d1
	jsr	Print

	clr.l	d0
	move.l	#3,d1
	jsr	SetPos
	move.l	DebD0-V(a6),d0
	jsr	binhex
	move.l	#2,d1
	jsr	Print
	lea	SPACE,a0
	jsr	Print
	move.l	DebD1-V(a6),d0
	jsr	binhex
	jsr	Print
	lea	SPACE,a0
	jsr	Print
	move.l	DebD2-V(a6),d0
	jsr	binhex
	jsr	Print
	lea	SPACE,a0
	jsr	Print
	move.l	DebD3-V(a6),d0
	jsr	binhex
	jsr	Print
	lea	SPACE,a0
	jsr	Print
	move.l	DebD4-V(a6),d0
	jsr	binhex
	jsr	Print
	lea	SPACE,a0
	jsr	Print
	move.l	DebD5-V(a6),d0
	jsr	binhex
	jsr	Print
	lea	SPACE,a0
	jsr	Print
	move.l	DebD6-V(a6),d0
	jsr	binhex
	jsr	Print
	lea	SPACE,a0
	jsr	Print
	move.l	DebD7-V(a6),d0
	jsr	binhex
	jsr	Print
	lea	SPACE,a0
	jsr	Print
	move.l	DebA0-V(a6),d0
	jsr	binhex
	move.l	#3,d1
	jsr	Print
	lea	SPACE,a0
	jsr	Print
	move.l	DebA1-V(a6),d0
	jsr	binhex
	jsr	Print
	lea	SPACE,a0
	jsr	Print
	move.l	DebA2-V(a6),d0
	jsr	binhex
	jsr	Print
	lea	SPACE,a0
	jsr	Print
	move.l	DebA3-V(a6),d0
	jsr	binhex
	jsr	Print
	lea	SPACE,a0
	jsr	Print
	move.l	DebA4-V(a6),d0
	jsr	binhex
	jsr	Print
	lea	SPACE,a0
	jsr	Print
	move.l	DebA5-V(a6),d0
	jsr	binhex
	jsr	Print
	lea	SPACE,a0
	jsr	Print
	move.l	DebA6-V(a6),d0
	jsr	binhex
	jsr	Print
	lea	SPACE,a0
	jsr	Print
	move.l	DebA7-V(a6),d0
	jsr	binhex
	jsr	Print
	lea	SPACE,a0
	jsr	Print
	clr.l	d0


	lea	NewLineTxt,a0
	jsr	Print
	lea	DebugSR,a0
	jsr	Print

	clr.l	d0
	move.w	DebSR-V(a6),d0
	jsr	binhexword
	move.l	#2,d1
	jsr	Print

	lea	DebugADR,a0
	move.l	#3,d1
	jsr	Print

	clr.l	d0
	move.l	DebPC-V(a6),d0
	move.l	d0,a4
	jsr	binhex
	move.l	#2,d1
	jsr	Print


	lea	DebugContent,a0
	move.l	#3,d1
	jsr	Print

	move.l	#19,d6
	clr.l	d5
.contentloop2:
	clr.l	d0
	move.b	(a4)+,d0
	jsr	binhexbyte
	jsr	Print
	add.b	#1,d5
	cmp.b	#4,d5				; 4th byte?
	bne	.not42
	move.b	#" ",d0
	jsr	PrintChar
	clr.l	d5
.not42:
	dbf	d6,.contentloop2
	add.l	#4,a5



	lea	NewLineTxt,a0
	jsr	Print



	clr.l	d7
	lea	$64,a5				; Level1 pointer

.irqloop:
	add.b	#1,d7
	cmp.b	#8,d7
	beq	.endloop

	lea	NewLineTxt,a0
	jsr	Print
	lea	DebugIRQ,a0
	move.l	#3,d1
	jsr	Print

	move.l	d7,d0
	jsr	bindec
	move.l	#3,d1
	jsr	Print

	lea	DebugIRQPoint,a0
	jsr	Print

	move.l	(a5),d0				; Get where IRQ points to
	move.l	d0,a4				; Store a copy of it in A4, to be able to print content
	jsr	binhex
	jsr	Print
	lea	DebugContent,a0
	jsr	Print

	move.l	#15,d6
	clr.l	d5
.contentloop:
	clr.l	d0
	move.b	(a4)+,d0
	jsr	binhexbyte
	jsr	Print
	add.b	#1,d5
	cmp.b	#4,d5				; 4th byte?
	bne	.not4
	move.b	#" ",d0
	jsr	PrintChar
	clr.l	d5
.not4:
	dbf	d6,.contentloop
	add.l	#4,a5


	bra	.irqloop
	
.endloop:

	lea	NewLineTxt,a0
	jsr	Print
	lea	NewLineTxt,a0
	jsr	Print
	lea	DebugROM,a0
	jsr	Print

	cmp.w	#$1114,$0
	bne	.no1114at0
	lea	YES,a0
	move.l	#1,d1
	jsr	Print
	bra	.yes1114at0

.no1114at0:
	lea	NO,a0
	move.l	#2,d1
	jsr	Print
.yes1114at0

	lea	NewLineTxt,a0
	jsr	Print
	lea	DebugROM2,a0
	move.l	#3,d1
	jsr	Print

	cmp.w	#$1114,$f80000
	bne	.no1114atf8
	lea	YES,a0
	move.l	#2,d1
	jsr	Print
	bra	.yes1114atf8

.no1114atf8:
	lea	NO,a0
	move.l	#1,d1
	jsr	Print
.yes1114atf8:


	lea	NewLineTxt,a0
	jsr	Print
	bsr	PrintCPU

	lea	DebugPWR,a0
	move.l	#3,d1
	jsr	Print
	
	move.l	PowerONStatus-V(a6),d0
	jsr	binstring
	jsr	Print

	POP
	rts


DebugSerial:					; This dumps out registers..
	PUSH
	move.l	d0,DebD0-V(a6)			; first store everything in registers
	move.l	d1,DebD1-V(a6)			; and for visability etc.. I do several move instead of movem. dunno why :)
	move.l	d2,DebD2-V(a6)
	move.l	d3,DebD3-V(a6)
	move.l	d4,DebD4-V(a6)
	move.l	d5,DebD5-V(a6)
	move.l	d6,DebD6-V(a6)
	move.l	d7,DebD7-V(a6)
	move.l	a0,DebA0-V(a6)
	move.l	a1,DebA1-V(a6)
	move.l	a2,DebA2-V(a6)
	move.l	a3,DebA3-V(a6)
	move.l	a4,DebA4-V(a6)
	move.l	a5,DebA5-V(a6)
	move.l	a6,DebA6-V(a6)
	move.l	a7,DebA7-V(a6)			; OK now everything is stored.

	lea	DebugTxt,a0
	bsr	ForceSer

	lea	NewLineTxt,a0
	bsr	ForceSer
	lea	NewLineTxt,a0
	bsr	ForceSer
	move.l	DebD0-V(a6),d0
	jsr	binhex
	bsr	ForceSer
	lea	SPACE,a0
	bsr	ForceSer
	move.l	DebD1-V(a6),d0
	jsr	binhex
	bsr	ForceSer
	lea	SPACE,a0
	bsr	ForceSer
	move.l	DebD2-V(a6),d0
	jsr	binhex
	bsr	ForceSer
	lea	SPACE,a0
	bsr	ForceSer
	move.l	DebD3-V(a6),d0
	jsr	binhex
	bsr	ForceSer
	lea	SPACE,a0
	bsr	ForceSer
	move.l	DebD4-V(a6),d0
	jsr	binhex
	bsr	ForceSer
	lea	SPACE,a0
	bsr	ForceSer
	move.l	DebD5-V(a6),d0
	jsr	binhex
	bsr	ForceSer
	lea	SPACE,a0
	bsr	ForceSer
	move.l	DebD6-V(a6),d0
	jsr	binhex
	bsr	ForceSer
	lea	SPACE,a0
	bsr	ForceSer
	move.l	DebD7-V(a6),d0
	jsr	binhex
	bsr	ForceSer
	lea	NewLineTxt,a0
	bsr	ForceSer
	move.l	DebA0-V(a6),d0
	jsr	binhex
	bsr	ForceSer
	lea	SPACE,a0
	bsr	ForceSer
	move.l	DebA1-V(a6),d0
	jsr	binhex
	bsr	ForceSer
	lea	SPACE,a0
	bsr	ForceSer
	move.l	DebA2-V(a6),d0
	jsr	binhex
	bsr	ForceSer
	lea	SPACE,a0
	bsr	ForceSer
	move.l	DebA3-V(a6),d0
	jsr	binhex
	bsr	ForceSer
	lea	SPACE,a0
	bsr	ForceSer
	move.l	DebA4-V(a6),d0
	jsr	binhex
	bsr	ForceSer
	lea	SPACE,a0
	bsr	ForceSer
	move.l	DebA5-V(a6),d0
	jsr	binhex
	bsr	ForceSer
	lea	SPACE,a0
	bsr	ForceSer
	move.l	DebA6-V(a6),d0
	jsr	binhex
	bsr	ForceSer
	lea	SPACE,a0
	bsr	ForceSer
	move.l	DebA7-V(a6),d0
	jsr	binhex
	bsr	ForceSer
	lea	NewLineTxt,a0
	
	POP
	rts




ForceSer:					; For debug. print stuff on serialport. if port disabled force 9600BPS


						; Indata a0=string to send to serialport
						; nullterminated

	cmp.w	#0,SerialSpeed-V(a6)
	beq	.noserial
	cmp.w	#5,SerialSpeed-V(a6)
	beq	.noserial
.serial:

	PUSH
	clr.l	d0				; Clear d0
.loop:
	move.b	(a0)+,d0
	cmp.b	#0,d0				; end of string?
	beq	.nomore				; yes
	bsr	.out

	bra.s	.loop
.nomore:
	POP
	rts


.out:						; Send what is in d0 to serialport
	PUSH
	move.l	#10000,d2			; Load d2 with a timeoutvariable. only test this number of times.
						; IF CIA for serialport is dead we will not end up in a wait-forever-loop.
						; and as we cannot use timers. we have to do this dirty style of coding...
.timeoutloop:	
	move.b	$bfe001,d1			; just read crapdata, we do not care but reading from CIA is slow... for timeout stuff only
	sub.l	#1,d2				; count down timeout value
	cmp.l	#0,d2				; if 0, timeout.
	beq	.endloop
	move.w	$dff018,d1
	btst	#13,d1				; Check TBE bit
	beq.s	.timeoutloop
.endloop:
	move.w	#$0100,d1
	move.b	d0,d1
	move.w	d1,$dff030			; send it to serial
	move.w	#$0001,$dff09c			; turn off the TBE bit
	POP
	rts
.noserial:
	move.w	#$4000,$dff09a
	move.w	#373,$dff032			; Set the speed of the serialport (9600BPS)
	move.b	#$4f,$bfd000			; Set DTR high
	move.w	#$0801,$dff09a
	move.w	#$0801,$dff09c
	bra	.serial
	



InputHexNum:					; Inputs a 32 bit hexnumber
						; INDATA
						;	A0 = Defualtaddress
	PUSH
	move.b	Xpos-V(a6),CheckMemManualX-V(a6)
	move.b	Ypos-V(a6),CheckMemManualY-V(a6); Store X and Y positions

	move.l	a0,d0				; Store the defaultaddress in d0
	jsr	binhex				; Convert it to hex
	add.l	#1,a0				; Skip first $ sign in string
	move.l	#8,d0
	lea	CheckMemStartAdrTxt-V(a6),a1	; Clear workspace
.clearloop:
	clr.b	(a1,d0)
	dbf	d0,.clearloop
	move.l	#7,d0
	
	clr.l	d7				; Clear d7, if this is 0 later we had not had any 0 yet
.hexloop:
	move.b	(a0)+,d1			; Store char in d1
	cmp.b	#"0",d1				; is it a 0?
	bne	.nozero
	cmp.b	#0,d7				; Check if d7 is 0. if so, we will skip this
	beq	.zero
.nozero:
	move.b	d1,(a1)+			; Copy to where a1 points to
	move.b	#1,d7				; We had a nonzero.  set d7 to 1 so we handle 0 in the future
.zero:
	dbf	d0,.hexloop			; Copy string to defaultadress to be shown

	lea	CheckMemStartAdrTxt-V(a6),a5	; Store pointer to string at a5
	move.l	a5,a0

	move.l	#7,d1
	jsr	Print				; Print it
	jsr	StrLen				; Get Stringlength
	move.l	d0,d6


	clr.l	d7				; Clear d7, this is the current position of the string
	sub.b	#1,d7				; Change d7 so we will force a update of cursor first time
.loop:
	jsr	GetMouse
	cmp.b	#1,RMB-V(a6)
	beq	.exit
	cmp.b	#1,LMB-V(a6)
	beq	.exit
	bsr	WaitShort
	jsr	GetChar				; Get a char from keyboard/serial
	bsr	WaitLong
	cmp.b	#"x",d0				; did user press X?
	beq	.xpressed

	cmp.b	#$7f,d0				; did we have backspace from serial?
	beq	.backspace


.gethex:
	jsr	GetHex				; Strip it to hexnumbers
	cmp.b	#0,d0				; if returned value is 0, we had no keypress
	beq	.no
	cmp.b	#$1b,d0				; Was ESC pressed?
	beq	.exit				; if so, Exit
	cmp.b	#$a,d0				; did user press enter?
	beq	.enter				; if so, we are done


	cmp.b	#$8,d0				; Did we have a backspace?
	bne	.nobackspace			; no
						; oh. we had. lets erase one char
.backspace:
	move.b	#$0,(a5,d6)			; Store a null at that position
	cmp.b	#0,d6				; check if we are at the back?
	beq	.backmax			; yes, do not remove
	move.b	#" ",d0
	sub.b	#1,d6				; Subtract one
	move.b	d0,(a5,d6)			; Put char in memory
	bra	.back
.nobackspace:
	cmp.b	#8,d6				; Check if we have max number of chars
	beq	.nomore
	move.b	d0,(a5,d6)			; Put char in memory
	add.b	#1,d6

.back:
	move.l	#7,d1
	jsr	PrintChar			; Print the char
.backmax:
.nomore:

.no:	cmp.b	d6,d7				; Check if d6 and d7 is same, if not, update cursor
	beq	.same
	move.b	d6,d7
	bsr	.putcursor			; Put cursor
.same:
	bra	.loop

.exit:
	POP
	move.l	#-1,d0				; Show we had an exit
	rts


.xpressed:					; X is pressed, lets clear the whole area.
	clr.l	d6

	move.l	#7,d0
.xloop:
	move.b	#" ",(a5,d0)
	dbf	d0,.xloop
	clr.l	d7
	bsr	.putcursor
	lea	space8,a0
	move.l	#7,d1
	jsr	Print
	clr.l	d7
	bsr	.putcursor
	clr.l	d6
	clr.l	d0
	bra.w	.gethex

.enter:
	cmp.b	#0,d6				; was cursor at 0? then we had nothing
	beq	.exit
	bsr	.putcursor
	move.l	#" ",d0
	jsr	PrintChar			; Print a space to remove the old cursor

	clr.l	d6				; Clear d6, we need to check how many numbers we have

.countloop:
	move.b	(a5,d6),d0			; load char in string
	cmp.b	#0,d0				; is it a null?
	beq	.null
	cmp.b	#" ",d0				; same with space
	beq	.null
	add.b	#1,d6				; nope, so lets add 1 to the counter
	cmp.b	#8,d6				; Check if we actually DID have 8 chars, then no rotate of data is needed
	beq	.norotate
	bra	.countloop			; do it all over again

.null:						; ok we had a null, before doing 8 chars.
						; We had less then 8 chars, meaning we need to trimp it to 8 chars.
	move.l	d6,d7
	sub.b	#1,d7
	move.l	#7,d0
.copyloop2:
	move.b	(a5,d7),(a5,d0)
	sub.b	#1,d0
	dbf	d7,.copyloop2
						; ok now we have moved the data to the end of the string, lets fill up with 0
	move.l	#8,d0
	sub.b	d6,d0				; d0 now contains of how many 0 to put in
	sub.b	#1,d0
.fill:
	move.b	#"0",(a5,d0)
	dbf	d0,.fill
.norotate:
	move.b	CheckMemManualX-V(a6),d0
	move.b	CheckMemManualY-V(a6),d1
	sub.l	#1,d0				; Set cursor to the first adress, minus pone

	jsr	SetPos
	lea	CheckMemStartAdrTxt-V(a6),a0
	jsr	hexbin
	POP
	move.l	HexBinBin-V(a6),d0		; return the value
	rts

.putcursor:
	PUSH
	move.b	CheckMemManualX-V(a6),d0
	add.b	d7,d0				; Add postion to X pos to get correct position
	move.b	CheckMemManualY-V(a6),d1
	jsr	SetPos
	clr.l	d0
	move.b	(a5,d7),d0			; Load current char from string
	move.l	#11,d1
	jsr	PrintChar			; Print it reversed
	move.b	CheckMemManualX-V(a6),d0
	add.b	d7,d0				; Add postion to X pos to get correct position
	move.b	CheckMemManualY-V(a6),d1
	jsr	SetPos
	POP
	rts	



InputDecNum:					; Inputs a 32 bit hexnumber
						; INDATA
						;	A0 = Defualtaddress
	PUSH
	move.b	Xpos-V(a6),CheckMemManualX-V(a6)
	move.b	Ypos-V(a6),CheckMemManualY-V(a6); Store X and Y positions

	move.l	a0,d0				; Store the defaultaddress in d0
	jsr	bindec				; Convert it to hex



	move.l	#8,d0
	lea	CheckMemStartAdrTxt-V(a6),a1	; Clear workspace

.clearloop:
	clr.b	(a1,d0)
	dbf	d0,.clearloop
	move.l	#7,d0



.decloop:
	move.b	(a0)+,d1			; Store char in d1
	cmp.b	#0,d1				; Check if d7 is 0. if so, we will skip this
	beq	.zero
	move.b	d1,(a1)+			; Copy to where a1 points to
	dbf	d0,.decloop
.zero:
	lea	CheckMemStartAdrTxt-V(a6),a5	; Store pointer to string at a5


	move.l	a5,a0
	move.l	#7,d1
	jsr	Print				; Print it
	jsr	StrLen				; Get Stringlength

	move.l	d0,d6


	clr.l	d7				; Clear d7, this is the current position of the string
	sub.b	#1,d7				; Change d7 so we will force a update of cursor first time
.loop:
	jsr	GetMouse
	cmp.b	#1,RMB-V(a6)
	beq	.exit
	cmp.b	#1,LMB-V(a6)
	beq	.exit
	bsr	WaitShort
	jsr	GetChar				; Get a char from keyboard/serial
	bsr	WaitLong
	cmp.b	#"x",d0				; did user press X?
	beq	.xpressed

	cmp.b	#$7f,d0				; did we have backspace from serial?
	beq	.backspace

.getdec:
	jsr	GetDec				; Strip it to hexnumbers
	cmp.b	#0,d0				; if returned value is 0, we had no keypress
	beq	.no
	cmp.b	#$1b,d0				; Was ESC pressed?
	beq	.exit				; if so, Exit
	cmp.b	#$a,d0				; did user press enter?
	beq	.enter				; if so, we are done


	cmp.b	#$8,d0				; Did we have a backspace?
	bne	.nobackspace			; no
						; oh. we had. lets erase one char
.backspace:
	move.b	#$0,(a5,d6)			; Store a null at that position
	cmp.b	#0,d6				; check if we are at the back?
	beq	.backmax			; yes, do not remove
	move.b	#" ",d0
	sub.b	#1,d6				; Subtract one
	move.b	d0,(a5,d6)			; Put char in memory
	bra	.back
.nobackspace:
	cmp.b	#8,d6				; Check if we have max number of chars
	beq	.nomore
	move.b	d0,(a5,d6)			; Put char in memory
	add.b	#1,d6

.back:
	move.l	#7,d1
	jsr	PrintChar			; Print the char
.backmax:
.nomore:

.no:	cmp.b	d6,d7				; Check if d6 and d7 is same, if not, update cursor
	beq	.same
	move.b	d6,d7
	bsr	.putcursor			; Put cursor
.same:
	bra	.loop

.exit:
	POP
	move.l	#-1,d0				; Show we had an exit
	rts


.xpressed:					; X is pressed, lets clear the whole area.
	clr.l	d6

	move.l	#7,d0
.xloop:
	move.b	#" ",(a5,d0)
	dbf	d0,.xloop
	clr.l	d7
	bsr	.putcursor
	lea	space8,a0
	move.l	#7,d1
	jsr	Print
	clr.l	d7
	bsr	.putcursor
	clr.l	d6
	clr.l	d0
	bra.w	.getdec

.enter:
	cmp.b	#0,d6				; was cursor at 0? then we had nothing
	beq	.exit
	bsr	.putcursor
	move.l	#" ",d0
	jsr	PrintChar			; Print a space to remove the old cursor

	clr.l	d6				; Clear d6, we need to check how many numbers we have


	move.l	a5,a0
	jsr	decbin
	POP
	move.l	DecBinBin-V(a6),d0		; return the value
	rts

.putcursor:
	PUSH
	move.b	CheckMemManualX-V(a6),d0
	add.b	d7,d0				; Add postion to X pos to get correct position
	move.b	CheckMemManualY-V(a6),d1
	jsr	SetPos
	clr.l	d0
	move.b	(a5,d7),d0			; Load current char from string
	move.l	#11,d1
	jsr	PrintChar			; Print it reversed
	move.b	CheckMemManualX-V(a6),d0
	add.b	d7,d0				; Add postion to X pos to get correct position
	move.b	CheckMemManualY-V(a6),d1
	jsr	SetPos
	POP
	rts	






PrintHWReg:
	lea	BLTDDATTxt,a0
	move.w	#7,d1
	jsr	Print
	move.w	BLTDDAT-V(a6),d0
	jsr	binhexword
	move.w	#3,d1
	jsr	Print
	lea	Space3,a0
	jsr	Print
	lea	DMACONRTxt,a0
	move.w	#7,d1
	jsr	Print
	move.w	DMACONR-V(a6),d0
	jsr	binhexword
	move.w	#3,d1
	jsr	Print
	lea	Space3,a0
	jsr	Print
	lea	VPOSRTxt,a0
	move.w	#7,d1
	jsr	Print
	move.w	VPOSR-V(a6),d0
	jsr	binhexword
	move.w	#3,d1
	jsr	Print
	lea	NewLineTxt,a0
	jsr	Print
	lea	VHPOSRTxt,a0
	move.w	#7,d1
	jsr	Print
	move.w	VHPOSR-V(a6),d0
	jsr	binhexword
	move.w	#3,d1
	jsr	Print
	lea	Space3,a0
	jsr	Print
	lea	DSKDATRTxt,a0
	move.w	#7,d1
	jsr	Print
	move.w	DSKDATR-V(a6),d0
	jsr	binhexword
	move.w	#3,d1
	jsr	Print
	lea	Space3,a0
	jsr	Print
	lea	JOY0DATTxt,a0
	move.w	#7,d1
	jsr	Print
	move.w	JOY0DAT-V(a6),d0
	jsr	binhexword
	move.w	#3,d1
	jsr	Print
	lea	NewLineTxt,a0
	jsr	Print
	lea	POT0DATTxt,a0
	move.w	#7,d1
	jsr	Print
	move.w	POT0DAT-V(a6),d0
	jsr	binhexword
	move.w	#3,d1
	jsr	Print
	lea	Space3,a0
	jsr	Print
	lea	POT1DATTxt,a0
	move.w	#7,d1
	jsr	Print
	move.w	POT1DAT-V(a6),d0
	jsr	binhexword
	move.w	#3,d1
	jsr	Print
	lea	Space3,a0
	jsr	Print
	lea	POTINPTxt,a0
	move.w	#7,d1
	jsr	Print
	move.w	POTINP-V(a6),d0
	jsr	binhexword
	move.w	#3,d1
	jsr	Print
	lea	NewLineTxt,a0
	jsr	Print
	lea	SERDATRTxt,a0
	move.w	#7,d1
	jsr	Print
	move.w	SERDATR-V(a6),d0
	jsr	binhexword
	move.w	#3,d1
	jsr	Print
	lea	Space3,a0
	jsr	Print
	lea	DSKBYTRTxt,a0
	move.w	#7,d1
	jsr	Print
	move.w	DSKBYTR-V(a6),d0
	jsr	binhexword
	move.w	#3,d1
	jsr	Print
	lea	Space3,a0
	jsr	Print
	lea	INTENARTxt,a0
	move.w	#7,d1
	jsr	Print
	move.w	INTENAR-V(a6),d0
	jsr	binhexword
	move.w	#3,d1
	jsr	Print
	lea	NewLineTxt,a0
	jsr	Print
	lea	INTREQRTxt,a0
	move.w	#7,d1
	jsr	Print
	move.w	INTREQR-V(a6),d0
	jsr	binhexword
	move.w	#3,d1
	jsr	Print
	lea	Space3,a0
	jsr	Print
	lea	DENISEIDTxt,a0
	move.w	#7,d1
	jsr	Print
	move.w	DENISEID-V(a6),d0
	jsr	binhexword
	move.w	#3,d1
	jsr	Print
	lea	Space3,a0
	jsr	Print
	lea	HHPOSRTxt,a0
	move.w	#7,d1
	jsr	Print
	move.w	HHPOSR-V(a6),d0
	jsr	binhexword
	move.w	#3,d1
	jsr	Print
	lea	NewLineTxt,a0
	jsr	Print

	rts


RTEcode:					; Just to have something to point IRQ to.. doing nothing
	move.w	#$444,$dff180
	rte




RunCode:					; Copy a routine to RAM, run it from there and return.
						; IN =	A0 = link to routine
						; 	D0 = length of routine (max 64K)

	PUSH

	add.l	#4,d0				; add 4 bytes to be sure
	move.l	a0,a1				; copy link to routine to a0
	move.l	a0,a5
	move.l	d0,d7
	bsr	GetMemory			; get memory
	cmp.l	#0,a0				; if A0 is 0, we was out of memory, exit
	beq	RunCodeInRom

	move.l	a0,d1				; store memaddress to d0
	add.l	#4,d1				; add 4 to be sure
	asr.l	#2,d1				; as this migight put start 2 bytes before
	asl.l	#2,d1				; Make sure start is on a even 32 bit location!

	move.l	d1,a0
						; A0 now contains pointer where to copy routine

	move.l	a0,RunCodeStart-V(a6)		; Store first address of where code is

	move.l	a0,a2				; make a backup of address
	move.l	a1,a3
	move.l	d0,d3

.loop:
	move.b	(a1)+,(a0)+
	dbf	d0,.loop			; copy routine to RAM
						; lets verify so the data is readable (working mem)

	move.l	a2,a0
	move.l	a3,a1
	sub.l	#4,d3


.loopa:
	move.b	(a0)+,d6
	move.b	(a1)+,d5
	cmp.b	d5,d6				; Compare memory
	bne	RunCodeInRom			; we failed
	dbf	d3,.loopa
						; memtest succeeded.  so lets run in ram.
	move.l	a0,RunCodeEnd-V(a6)		; Store where end of code is

.run:
	jsr	(a2)				; jump to routine
	POP
	rts

RunCodeInRom:
	move.l	a5,RunCodeStart-V(a6)
	move.l	a5,a4
	add.l	d7,a4
	move.l	a4,RunCodeEnd-V(a6)

	jsr	(a5)	
	POP
	rts



GetMemory:					; Get memory from workmem.  Fastmem prio.
						; IN:
						;	D0 = size wanted
						; OUT:
						;	A0 = startaddress of memory, if 0=no memory
	PUSH
	move.l	d0,d6				; We move size to d6...
	clr.l	d7

	move.l	FastStart-V(a6),d0		; D0 now contains start of fastmem
	move.l	FastEnd-V(a6),d1		; D1 now contains end of fastmem
	move.l	d1,d2
	sub.l	d0,d2				; D2 now contains fastmemsize
	move.l	ChipStart-V(a6),d3		; D3 now contains start of chipmem
	move.l	ChipEnd-V(a6),d4		; D4 now contains end of chipmem
	move.l	d4,d5
	sub.l	d3,d5				; D6 now contains chipmemsize


	cmp.l	#0,d0
	beq	.nofast
	cmp.l	d6,d2				; Check if we had enough
	blt	.nofast				; we did not have enough fast..
	
						; ok we had enough ram..
	bra	.hadmem				; so go to "hadmem" to handle last part

.nofast:
	
	cmp.l	#0,d3
	beq	.nochip				; we had nochip! out of mem!
	cmp.l	d6,d5
	blt	.nochip				; we had not enough chip!  out of mem!

						; ok we had mem. to be lazy we copy over chipmem registers to where fastmem regs was
	move.l	d3,d0
	move.l	d4,d1				; Start and end is all we need
	bra	.hadmem

.nochip:					; ok sorry!  out of memory!we are screwed return 0 as memory
	clr.l	MemAdr-V(a6)
	bra	.memdone


.hadmem:					; We had memory, just figure out if we should give from start or end of ram

	move.b	WorkOrder-V(a6),d7		; if d7 is 0=work from back, if not work from start.
	cmp.b	#0,d7				; Check status
	beq	.FromBack
	move.l	d0,MemAdr-V(a6)
	bra	.memdone


.FromBack:
	sub.l	d6,d1
	sub.l	#1,d1				; Subtract with 1 more or it will be an odd address

	ifeq	rommode

		move.l	#startwork,d1		; if not in rommode, say workmem is at allocated area

	endif



	move.l	d1,MemAdr-V(a6)			; Store it and return it
.memdone:
	POP
	move.l	MemAdr-V(a6),a0			; Return answer

	rts




GetChip:					; Gets extra chipmem below the reserved workarea.
						; IN = D0=Size requested
						; OUT = D0=Startaddress of chipmem.  1=not enough, 0=no chipmem
	PUSH


	clr.l	GetChipAddr-V(a6)		; Clear the address returned.
	cmp.l	#0,TotalChip-V(a6)		; if there are no chipmem, exit
	beq	.exit	

	move.l	ChipUnreserved-V(a6),d1		; Get total amount of nonused chipmem
	cmp.l	d0,d1				; Compare it with amount of mem wanted
	blt	.low				; we did not have enough. exit

	move.l	ChipUnreservedAddr-V(a6),d1	; ok load d1 with value of last usable noreserved chipmemarea
	sub.l	d0,d1				; Subtract with amount of memory wanted
	move.l	d1,GetChipAddr-V(a6)		; Store it to returnvalue

	move.l	d1,a0				; Now lets clear the ram
	asr.l	#2,d0
.loop:
	clr.l	(a0)+
	dbf	d0,.loop	



	bra	.exit

.low:
	move.l	#1,GetChipAddr-V(a6)		; put 1 into returnvalue, telling we did not have enough mem.
.exit: 
 
	POP
	move.l	GetChipAddr-V(a6),d0		; Return the value
	rts

FilterOFF:
	bset	#1,$bfe001
	rts
FilterON:
	bclr	#1,$bfe001
	rts



