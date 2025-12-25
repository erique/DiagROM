MainMenu:
	jsr	FilterON
	bsr	ClearScreen			; Clear the screen
	bsr	PrintStatus			; Print the statusline
	bsr	UpdateStatus			; Update "static" data of statusline
	clr.l	d0
	clr.l	d1
	bsr	SetPos
	move.l	#Menus,Menu-V(a6)		; Set Menus as default menu. if different set another manually
	move.l	#0,MenuVariable-V(a6)
	move.w	#0,MenuNumber-V(a6)
	move.b	#1,PrintMenuFlag-V(a6)


	bra	MainLoop


InitScreen:
	bsr	ClearScreen
	bsr	PrintStatus
	bsr	UpdateStatus
	clr.l	d0
	clr.l	d1
	bsr	SetPos
	rts

DumpClearSerial:				; Just read serialport, to empty it, this is pre-memory, so no return.
						; a0 contains jumpaddress where to go after exiting
	move.l	#1,d1				; load d6 with 1, so we run this, twice to be sure serialbuffer is cleared
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
	dbf	d1,.loop
	jmp	(a0)				; Jump to a0




DumpSerialChar2:
	move.w	#$4000,$dff09a
	move.w	#373,$dff032			; Set the speed of the serialport (9600BPS)
	move.b	#$4f,$bfd000			; Set DTR high
	move.w	#$0801,$dff09a
	move.w	#$0801,$dff09c
	swap	d7				; Lets save registers..  d7 is only 16 bit. so lets use both halves
	move.w	#40000,d7			; Load d2 (ehm.. d7)  with a timeoutvariable. only test this number of times.
						; IF CIA for serialport is dead we will not end up in a wait-forever-loop.
						; and as we cannot use timers. we have to do this dirty style of coding...
.tsttimeoutloop1:	
	move.b	$bfe001,d4			; just read crapdata, we do not care but reading from CIA is slow... for timeout stuff only
	sub.w	#1,d7				; count down timeout value
	cmp.w	#0,d7				; if 0, timeout.
	beq	.tstendloop1
	move.w	$dff018,d4
	btst	#13,d4				; Check TBE bit
	beq.s	.tsttimeoutloop1
.tstendloop1:
	swap	d7				; swap back.  and we used d7 as bth the old "d7" variable and d2 in old routine. so d2 can be used to other stuff
	move.w	#$0100,d4
	move.b	d7,d4
	move.w	d4,$dff030			; send it to serial
	move.w	#$0001,$dff09c			; turn off the TBE bit
	jmp	(a7)

DumpSerial:
					; This is only for PRE-Memory usage. Dumps a string to serialport.
					; IN:
					; a0 = String to put out on serial port.
					; a1 = where to jump after code is run. Remember we have NO stack
					; meaning that there is no place to store returnadresses for bsr/jsr


	move.l	a4,d7				; Copy the value in A4 (temporary data of mousebutttons pressed) to d7
	btst	#7,d7				; Check if serial should be disabled
	bne	.exit				; if so, exit this


	move.w	#$4000,$dff09a
	move.w	#373,$dff032			; Set the speed of the serialport (9600BPS)
	move.b	#$4f,$bfd000			; Set DTR high
	move.w	#$0801,$dff09a
	move.w	#$0801,$dff09c

	clr.l	d7				; Clear d7
.loop:
	move.b	(a0)+,d7
	cmp.b	#0,d7				; end of string?
	beq	.nomore				; yes

	move.l	#40000,d2			; Load d2 with a timeoutvariable. only test this number of times.
						; if paula cannot tell if serial is output we will not end up in a wait-forever-loop.
						; and as we cannot use timers. we have to do this dirty style of coding...
.timeoutloop:	
	move.b	$bfe001,d1			; just read crapdata, we do not care but reading from CIA is slow... for timeout stuff only
	sub.l	#1,d2				; count down timeout value
	cmp.l	#0,d2				; if 0, timeout.
	beq	.endloop
	move.w	$dff018,d1
	btst	#13,d1				; Check TBE bit
	beq.s	.timeoutloop
	bra	.notimeout
	
.endloop:

	move.l	a4,d2
	swap	d2
	add.w	#1,d2
	cmp.w	#70,d2				; If we had enough timeouts, lets cancel serial output
	blt	.notenough

	move.w	#$fff,$dff180
	swap	d2
	bset	#7,d2
	bra	.enough
.notenough:
	swap	d2
.enough

	move.l	d2,a4				; We had a timeout. add 1 to higher word of A4 to show counter of timeouts

	clr.l	d2
.notimeout:
	move.w	#$0100,d1
	move.b	d7,d1
	move.w	d1,$dff030			; send it to serial
	move.w	#$0001,$dff09c			; turn off the TBE bit

	bra.s	.loop
.exit:
	jmp	(a1)				; AS we cannot use RTS (and bsr/jsr) jump here after we are done.
.nomore:
						; ok apparentlty fire on port1 was pressed. if port0 was also pressed. we assume bad CIA and ignore
	btst	#0,d7
	bra	.exit


DumpSerialChar:

	move.l	a4,d7				; Copy the value in A4 (temporary data of mousebutttons pressed) to d7
	btst	#7,d7				; Check if serial should be disabled
	bne	.exit				; if so, exit this


	move.w	#$4000,$dff09a
	move.w	#373,$dff032			; Set the speed of the serialport (9600BPS)
	move.b	#$4f,$bfd000			; Set DTR high
	move.w	#$0801,$dff09a
	move.w	#$0801,$dff09c

	clr.l	d7				; Clear d7
.loop:
	move.b	(a0)+,d7

	move.l	#40000,d2			; Load d2 with a timeoutvariable. only test this number of times.
						; if paula cannot tell if serial is output we will not end up in a wait-forever-loop.
						; and as we cannot use timers. we have to do this dirty style of coding...
.timeoutloop:	
	move.b	$bfe001,d1			; just read crapdata, we do not care but reading from CIA is slow... for timeout stuff only
	sub.l	#1,d2				; count down timeout value
	cmp.l	#0,d2				; if 0, timeout.
	beq	.endloop
	move.w	$dff018,d1
	btst	#13,d1				; Check TBE bit
	beq.s	.timeoutloop
	bra	.notimeout
	
.endloop:

	move.l	a4,d2
	swap	d2
	add.w	#1,d2
	cmp.w	#100,d2				; If we had enough timeouts, lets cancel serial output
	blt	.notenough

	move.w	#$fff,$dff180
	swap	d2
	bset	#7,d2
	bra	.enough
.notenough:
	swap	d2
.enough

	move.l	d2,a4				; We had a timeout. add 1 to higher word of A4 to show counter of timeouts

	clr.l	d2
.notimeout:
	move.w	#$0100,d1
	move.b	d7,d1
	move.w	d1,$dff030			; send it to serial
	move.w	#$0001,$dff09c			; turn off the TBE bit
.exit:
	jmp	(a1)				; AS we cannot use RTS (and bsr/jsr) jump here after we are done.



DumpSerialCharacter:				; Same as above. except that char is in D1

	move.l	a4,d7				; Copy the value in A4 (temporary data of mousebutttons pressed) to d7
	btst	#7,d7				; Check if serial should be disabled
	bne	.exit				; if so, exit this

	move.w	d1,d7
	move.w	#$4000,$dff09a
	move.w	#373,$dff032			; Set the speed of the serialport (9600BPS)
	move.b	#$4f,$bfd000			; Set DTR high
	move.w	#$0801,$dff09a
	move.w	#$0801,$dff09c
	swap	d7				; Lets save registers. using d7 for both chardata and timeoutloop

.loop:
	move.w	#40000,d7			; Load d7 with a timeoutvariable. only test this number of times.
						; if paula cannot tell if serial is output we will not end up in a wait-forever-loop.

						; and as we cannot use timers. we have to do this dirty style of coding...
.timeoutloop:	
	move.b	$bfe001,d1			; just read crapdata, we do not care but reading from CIA is slow... for timeout stuff only
	sub.w	#1,d7				; count down timeout value
	cmp.w	#0,d7				; if 0, timeout.
	beq	.endloop
	move.w	$dff018,d1
	btst	#13,d1				; Check TBE bit
	beq.s	.timeoutloop
	bra	.notimeout
	
.endloop:
	swap	d7
	
	move.l	a4,d1
	swap	d1
	add.w	#1,d1
	cmp.w	#100,d1				; If we had enough timeouts, lets cancel serial output
	blt	.notenough

	move.w	#$fff,$dff180
	swap	d1
	bset	#7,d1
	bra	.enough
.notenough:
	swap	d1
.enough

	move.l	d1,a4				; We had a timeout. add 1 to higher word of A4 to show counter of timeouts

.notimeout:
	move.w	#$0100,d1
	swap	d7
	move.b	d7,d1
	move.w	d1,$dff030			; send it to serial
	move.w	#$0001,$dff09c			; turn off the TBE bit
.exit:
	jmp	(a1)				; AS we cannot use RTS (and bsr/jsr) jump here after we are done.





DumpBinSerial:				; Dumps value in D1 as binary to serialport

					; A3 is jumppointer for exit

	move.l	d1,d5

	move.l	#31,d6

.loop:
	btst	d6,d5
	beq	.notset
	move.l	#"1",d1
	lea	.charprinted,a1
	bra	DumpSerialCharacter
.notset:
	move.l	#"0",d1
	lea	.charprinted,a1
	bra	DumpSerialCharacter
.charprinted:

	dbf	d6,.loop
	jmp	(a3)







oldcrapanddelete:
	move.l	d2,a0
	move.l	d3,a1
	move.l	d4,a2
	move.l	d7,a3



	move.l	#31,d3
.tstloop1:
	clr.l	d7
	btst	d3,d1
	beq	.tstzero1
	move.b	#"1",d7
	bra	.tstout1
.tstzero1:
	move.b	#"0",d7
.tstout1:
	move.w	#$4000,$dff09a
	move.w	#373,$dff032			; Set the speed of the serialport (9600BPS)
	move.b	#$4f,$bfd000			; Set DTR high
	move.w	#$0801,$dff09a
	move.w	#$0801,$dff09c
	move.l	#40000,d2			; Load d2 with a timeoutvariable. only test this number of times.
						; IF CIA for serialport is dead we will not end up in a wait-forever-loop.
						; and as we cannot use timers. we have to do this dirty style of coding...
.tsttimeoutloop1:	
	move.b	$bfe001,d4			; just read crapdata, we do not care but reading from CIA is slow... for timeout stuff only
	sub.l	#1,d2				; count down timeout value
	cmp.l	#0,d2				; if 0, timeout.
	beq	.tstendloop1
	move.w	$dff018,d4
	btst	#13,d4				; Check TBE bit
	beq.s	.tsttimeoutloop1
.tstendloop1:
	move.w	#$0100,d4
	move.b	d7,d4
	move.w	d4,$dff030			; send it to serial
	move.w	#$0001,$dff09c			; turn off the TBE bit
	dbf	d3,.tstloop1


	move.l	a0,d2
	move.l	a1,d3
	move.l	a2,d4
	move.l	a3,d7
	jmp	(a7)


DumpHexLong:
					; Same as DumpHexByte but longword.
					; A3 is jumppointer for exit
	move.l	d1,d6
	swap	d1
	asr.l	#8,d1

	lea	bytehextxt,a0
	clr.l	d2
	move.b	d1,d2
	asl	#1,d2
	add.l	d2,a0
	lea	.byte1char,a1
	bra	DumpSerialChar
.byte1char:
	lea	.byte1,a1
	bra	DumpSerialChar

.byte1:

	move.l	d6,d1
	swap	d1
	lea	bytehextxt,a0
	clr.l	d2
	move.b	d1,d2
	asl	#1,d2
	add.l	d2,a0
	lea	.byte2char,a1
	bra	DumpSerialChar
.byte2char:
	lea	.byte2,a1
	bra	DumpSerialChar
.byte2:
	move.l	d6,d1
	asr	#8,d1
	lea	bytehextxt,a0
	clr.l	d2
	move.b	d1,d2
	asl	#1,d2
	add.l	d2,a0
	lea	.byte3char,a1
	bra	DumpSerialChar
.byte3char:
	lea	.byte3,a1
	bra	DumpSerialChar
.byte3:
	move.l	d6,d1
	lea	bytehextxt,a0
	clr.l	d2
	move.b	d1,d2
	asl	#1,d2
	add.l	d2,a0
	lea	.byte4char,a1
	bra	DumpSerialChar
.byte4char:
	lea	.byte4,a1
	bra	DumpSerialChar
.byte4:
	jmp	(a2)


DefaultVars:					; Set defualtvalues
	move.l	a6,d0
	add.l	#EndData-V,d0
	move.l	d0,CheckMemEditScreenAdr-V(a6)
	move.b	#0,skipnextkey-V(a6)
	rts



DumpHexByte:				; PRE MEM-CODE!  dumps content of BYTE in d1 to serialport-
					; INDATA:
					;	D1 = byte to print
					;	A2 = address to jump after done
	lea	bytehextxt,a0
	clr.l	d2
	move.b	d1,d2
	asl	#1,d2
	add.l	d2,a0
	lea	.char1,a1
	bra	DumpSerialChar
.char1:
	lea	.char2,a1
	bra	DumpSerialChar
.char2:
	jmp	(a2)




;----------------------------------------------------------------- "New" memorytester
;-------------------------------------------------------------------------------------------------------------------------------------------------------

ForceExtended16MBMem:

	bsr	ClearScreen

	lea	MemtestExtMBMemTxt,a0
	move.l	#2,d1
	bsr	Print

	move.b	#14,LogYpos-V(a6)		; Store first row of log
	lea	MemoryTest16MB,a0
		move.l	#MemTestEndcode-MemoryTest16MB,d0
	jsr	RunCode
	bsr	ClearBuffer
	bsr	WaitPressed
	bsr	WaitReleased
	bra	MemtestMenu




CheckExtended16MBMem:
	bsr	ClearScreen
	lea	MemtestExtMBMemTxt,a0
	move.l	#2,d1
	bsr	Print
	
	move.b	#14,LogYpos-V(a6)		; Store first row of log
	lea	MemoryTest16MBQuick,a0
	move.l	#MemTestEndcode-MemoryTest16MBQuick,d0
	jsr	RunCode
	bsr	ClearBuffer
	bsr	WaitPressed
	bsr	WaitReleased
	bra	MemtestMenu




CheckExtendedChip:
	bsr	ClearScreen
	lea	MemtestExtChipTxt,a0
	move.l	#2,d1
	bsr	Print


	move.b	#14,LogYpos-V(a6)		; Store first row of log
	lea	MemoryTestChipExt,a0
	move.l	#MemTestEndcode-MemoryTestChipExt,d0
	jsr	RunCode
	bsr	ClearBuffer
	bsr	WaitPressed
	bsr	WaitReleased
	bra	MemtestMenu


MemoryTest16MB:
	move.l	#$7000000,CheckMemFrom-V(a6)
	move.l	#$7ffffff,CheckMemTo-V(a6)

	move.l	#0,CheckMemStepSize-V(a6)	; Set how many bytes to step between every memorytest
	bsr	MemTesterInit
	bsr	MemTesterNewBlock
	bsr	MemoryTester
	cmp.w	#1,CheckMemCancel-V(a6)
	beq	.cancel

	jsr	LogLine
	jsr	LogLine
	lea	AnyKeyMouseTxt,a0
	move.l	#2,d1
	jsr	Print	
.cancel:

	rts	

MemoryTest16MBQuick:
	move.l	#$7000000,CheckMemFrom-V(a6)
	move.l	#$7ffffff,CheckMemTo-V(a6)

	move.l	#4096,CheckMemStepSize-V(a6)	; Set how many bytes to step between every memorytest
	bsr	MemTesterInit
	bsr	MemTesterNewBlock
	bsr	MemoryTester
	cmp.w	#1,CheckMemCancel-V(a6)
	beq	.cancel

	jsr	LogLine
	jsr	LogLine
	lea	AnyKeyMouseTxt,a0
	move.l	#2,d1
	jsr	Print	
.cancel:

	rts	


MemoryTestChipExt:

	ifne	rommode

		move.l	#$400,d0
		move.l	#$200000,d1

	else
		move.l	#$1a0000,d0
		move.l	#$200000,d1
	endc

	move.l	d0,CheckMemFrom-V(a6)
	move.l	d1,CheckMemTo-V(a6)

	move.l	#0,CheckMemStepSize-V(a6)	; Set how many bytes to step between every memorytest
	bsr	MemTesterInit
	move.l	#$400,CheckMemFrom-V(a6)
	move.l	#$1fffff,CheckMemTo-V(a6)
	bsr	MemTesterNewBlock
	bsr	MemoryTester
	cmp.w	#1,CheckMemCancel-V(a6)
	beq	.cancel

	jsr	LogLine
	jsr	LogLine
	lea	AnyKeyMouseTxt,a0
	move.l	#2,d1
	jsr	Print	
.cancel:

	rts	

MemoryTestManual:
.passloop:

	bsr	MemTesterInit
.loop:

	bsr	MemTesterNewBlock
	bsr	MemoryTester
	cmp.w	#1,CheckMemCancel-V(a6)
	beq	.cancel
	bsr	MemTesterNewPass
	bra	.loop

.cancel:
	rts	

	

MemoryTest:
;	move.w	#0,CheckMemRandom-V(a6)
;	move.w	#0,CheckMemQuick-V(a6)
	move.l	#0,CheckMemStepSize-V(a6)	; Set how many bytes to step between every memorytest
	bsr	MemTesterInit
.loop:

	move.l	#$4000,CheckMemFrom-V(a6)
	move.l	#$7fff,CheckMemTo-V(a6)
	bsr	MemTesterNewBlock
	bsr	MemoryTester
	cmp.w	#1,CheckMemCancel-V(a6)
	beq	.cancel

	move.l	#$7000000,CheckMemFrom-V(a6)
	move.l	#$7ffffff,CheckMemTo-V(a6)
	bsr	MemTesterNewBlock
	bsr	MemoryTester
	cmp.w	#1,CheckMemCancel-V(a6)
	beq	.cancel
	bsr	MemTesterNewPass
	bra	.loop

.cancel:
	rts	


MemoryTester:						; Does the actual real test
	cmp.l	#0,CheckMemPreFail-V(a6)		; Check if prefail is 0, if not cancel this block
	bne	.passquit
	cmp.w	#1,CheckMemCancel-V(a6)
	beq	.passquit

	bsr	MemTesterUpdate
.passloop:
	bsr	MemTesterTest
	bsr	MemTesterHandle				; How to handle the result
	move.l	CheckMemStepSize-V(a6),d6					; Set how much to step to next testlocation
	bsr	MemTesterStep

	cmp.w	#1,CheckMemPassQuit-V(a6)
	beq	.passquit
	cmp.w	#1,CheckMemCancel-V(a6)
	bne	.passloop
.passquit:
	clr.w	CheckMemPassQuit-V(a6)
	rts

MemTesterSkipTest:				; IN:	a2 = current address
						; out: D0 = 0 outside workarea    all other: inside SKIP THIS
	move.l	RunCodeStart-V(a6),d0
	cmp.l	d0,a2				; This routine check if we are testing workareas. if so tell testroutine to skip this.
	ble	.no				; we assume it as working.
	cmp.l	RunCodeEnd-V(a6),a2
	bge	.no
	move.l	#-1,d0
	rts
.no:
	move.l	BaseStart-V(a6),d0
	cmp.l	d0,a2
	ble	.no2
	cmp.l	BaseEnd-V(a6),a2
	bge	.no2
	move.l	#-1,d0
	rts
.no2:
	clr.l	d0
	rts



MemTesterHandle:					; Lets evaulate the result of the test.	


	cmp.l	#0,d7					; If d7 was 0, we had no errors
	beq	.wasok
									; we had an error..  lets check what type of error. we see this on CheckMemBitError

	cmp.l	#$ffffffff,CheckMemBitError-V(a6)	; if it was all 1. this is a dead area!
	beq	.wasdead
	move.b	#2,CheckMemType-V(a6)			; it was not all bits.  we are in a bad area
	bra	.typedone
.wasdead:
	move.b	#3,CheckMemType-V(a6)
	bra	.typedone
.wasok:
	move.b	#1,CheckMemType-V(a6)
.typedone:
.runagain:
	clr.l	d2
	move.b	CheckMemType-V(a6),d2
	move.b	CheckMemOldType-V(a6),d3
	cmp.b	d3,d2					; Check if we had a change of type
	beq	.notypechange


	move.b	d2,CheckMemOldType-V(a6)		; Store the new type as the old. we have a copy in d3 for future use
							; Memype is 1=good, 2=bad 3=dead  -1=Scan just started
							; We had a change of type here.. lets handle it
	clr.l	d6					; if null we wasn't at end of block
	
	cmp.b	#-1,d3					; if we had a -1. no block is ended. just a new is started.
	beq	.juststarted
	cmp.b	#-2,d3
	bne	.notend					; check if it was end of block.. if not go to notend
	cmp.b	#1,d2					; Check if we was in a good block.
	bne	.notend
	move.b	d2,d6					; set d6 to non-zero to tell we was at end of bock


.notend:
	cmp.b	#0,CheckMemTypeEnd-V(a6)
	bne	.end
	move.b	#1,CheckMemTypeEnd-V(a6)
	clr.l	d0
	clr.l	d1
	move.b	savexpos-V(a6),d0
	move.b	saveypos-V(a6),d1
	jsr	SetPos					; Set cursorpos to the stored position

	clr.l	d1
	move.b	savecol-V(a6),d1
	move.b	#-1,CheckMemOldType-V(a6)		; we was at end of a block, so mark this as "just started" and force a restart oftypetest
							; to handle next block

	lea	CheckMemEndAtTxt,a0
	jsr	Print

	move.l	CheckMemCurrent-V(a6),d0
	sub.l	#1,d0
	jsr	binhex
	jsr	Print

	lea	CheckMemSizeOfTxt,a0
	jsr	Print

	move.l	CheckMemTypeStart-V(a6),d1
	move.l	CheckMemCurrent-V(a6),d0
	sub.l	d1,d0

	asr.l	#8,d0
	asr.l	#2,d0				; Divide d0 with 1024 so we know how much memory in kb we got

	jsr	bindec
	clr.l	d1
	move.b	savecol-V(a6),d1
	jsr	Print				; Print out number of KB

	lea	KB,a0
	jsr	Print		
						; we have now a Block done...
	clr.l	d0

	cmp.b	#0,d6				;if d6 is 0 we wasn't at end of blockl
	beq	.adrcheck		 	;if not. say last 
	move.b	d6,d3
.adrcheck:
	cmp.b	#1,d3				; Check if it was a good block
	bne	.notgoodblock
	bsr	.checkgoodblock
	bra	.runagain
.notgoodblock:
	bra	.notypechange

.checkgoodblock:
	jsr	LogLine
	lea	CheckMemGoodBlockTxt,a0
	jsr	Print

	bsr	.addresscheck
.end:
	rts

.juststarted:
	move.l	CheckMemCurrent-V(a6),d0
	cmp.l	CheckMemTo-V(a6),d0
	bge	.notypechange			; if we was outside the testarea just exit


	cmp.b	#1,d2				; Check if type was Good
	bne	.notgood

	clr.b	CheckMemTypeEnd-V(a6)


	jsr	LogLine				; Start a new logline
	lea	CheckMemGoodTxt,a0
	move.l	#2,d1
	jsr	Print
	move.l	CheckMemCurrent-V(a6),d0
	move.l	d0,CheckMemTypeStart-V(a6)
	jsr	binhex
	jsr	Print
	bra	.startdone
.notgood:
	cmp.b	#2,d2				; Check if type was Good
	bne	.notbad

	jsr	LogLine				; Start a new logline
	lea	CheckMemBadTxt,a0
	move.l	#5,d1
	jsr	Print
	move.l	CheckMemCurrent-V(a6),d0
	jsr	binhex
	jsr	Print
	bra	.startdone
.notbad:
	cmp.b	#3,d2				; Check if type was Good
	bne	.notdead

	jsr	LogLine				; Start a new logline

	lea	CheckMemDeadTxt,a0
	move.l	#1,d1
	jsr	Print
	move.l	CheckMemCurrent-V(a6),d0
	jsr	binhex
	jsr	Print
	bra	.startdone
.notdead:
	
.startdone:
	move.b	d1,savecol-V(a6)
	jsr	GetPos
	move.b	d0,savexpos-V(a6)
	move.b	d1,saveypos-V(a6)

.notypechange:
	rts

.addresscheck:					; Check for addresserrors in block.
	jsr	LogLine
	lea	CheckMemAdrFillTxt,a0
	move.l	#3,d1
	jsr	Print
	move.l	CheckMemTypeStart-V(a6),a1
	move.l	CheckMemCurrent-V(a6),a2



	move.l	a1,d7
	move.l	a2,d6
	sub.l	d7,d6				;d6 now contains how many bytes to handle
	asr.l	#2,d6
	asr.l	#5,d6

	clr.l	d5				; Clear d5 as we will use it as a counter

	sub.l	#4,a2				; Subtract one longword at end. as we will write at the LAST longword
	move.l	CheckMemAdrRnd-V(a6),d2


							; Memory is now filled with addressdata


.filldata:					; Fill area with its memaddress.  do it backwards as that usually screws up when addressbits is bad
	add.l	#1,d5
	cmp.l	d5,d6				; if d5 is equal to d6, print a dot
	bne	.nodot
	clr.l	d5
	move.l	#".",d0
	move.l	#3,d1
	jsr	PrintChar
.nodot:
	jsr	MemTesterSkipTest
	beq	.doit
	sub.l	#4,a2				; skip this
	bra	.done
	move.l	a2,d7
.doit:



	sub.l	#4,a2				; subtract memadress to write to
	move.l	a2,d3				
	eor.l	d2,d3				; Eor with D2 that contains the random number. by doing this. old data will be "invalid"
	move.l	d3,(a2)				; Write address to ram
.done:
	cmp.l	a1,a2
	bge	.filldata


	jsr	LogLine
	lea	CheckMemAdrCheckTxt,a0
	move.l	#3,d1
	jsr	Print


						; Lets check if it is the same, if there is an addresserror it will not be.
	move.l	CheckMemTypeStart-V(a6),a2
	move.l	CheckMemCurrent-V(a6),a1
	sub.l	#4,a1

	lea	0,a4				; clear a4, is is used as a flag. if anything else than 0. we had an error
	
	clr.l	d5
	clr.l	d3				;d3 will contain a mask of all tested data
	clr.l	d2
.checkdata:
	add.l	#1,d5
	cmp.l	d5,d6				; if d5 is equal to d6, print a dot
	bne	.nodot2
	clr.l	d5
	cmp.l	#0,a4				; Check if there was an error in last block
	beq	.noerr
	move.l	#"E",d0
					;KUK
	move.l	#1,d1				; if so. print dot in red
	bra	.print
.noerr:
	move.l	#2,d1
	move.l	#".",d0
.print:	jsr	PrintChar
	clr.l	d7				; Clear d7
.nodot2:
	add.l	#4,a2
	jsr	MemTesterSkipTest
	cmp.w	#0,d0
	beq	.doit2
	move.l	a2,d4
	bra	.done2

.doit2:
	sub.l	#4,a2				; ok we cheated some.  fooled the checkroutine that we was 4 bytes longer than expected. lets fix later
	move.l	a2,d4
	move.l	(a2)+,d0
	move.l	CheckMemAdrRnd-V(a6),d1
	eor.l	d1,d0
	cmp.l	d0,d4
	beq	.done2
	add.l	#1,a4				; add 1 for each error

	or.l	d4,d2
	bra	.done3
.done2:
	or.l	d4,d3
.done3:
	move.l	a1,a3
	cmp.l	a2,a3
	bgt	.checkdata


	move.l	CheckMemTypeStart-V(a6),d6
	move.l	CheckMemCurrent-V(a6),d7
	sub.l	d6,d7				; D7 will contain size of block


	cmp.l	#0,d2
	beq	.noerror
	eor.l	d2,d3
	bra	.error
.noerror:
	add.l	d7,CheckMemUsable-V(a6)		; Add block as usable ram
	PUSH

	clr.l	CheckMemBitError-V(a6)
	bsr	MemTesterUpdate
	POP
	clr.l	d3

	bra	.runagain

.error:
						; Test is done
	jsr	LogLine
	lea	RamAdrErrTxt,a0
	move.l	#5,d1
	jsr	Print
	jsr	LogLine
	move.l	d3,d0
	or.l	d3,CheckMemAdrError-V(a6)
	move.l	#1,d1
	jsr	binstring
	jsr	Print
	lea	RamAdrErrSkipTxt,a0
	jsr	Print
	move.l	d7,d0
	add.l	d7,CheckMemNonUsable-V(a6)	; Mark block as nonusable
	PUSH
	bsr	MemTesterUpdate
	POP
	rts

MemTesterTest:					; Does the actual memorytesting of this address
	clr.l	d7
	movem.l a0-a6/d0-d6,-(a7)		;Store all registers in the stack	except d7 thats why we do not use PUSH
	move.l	CheckMemCurrent-V(a6),a0	; Load a0 with current address

	move.l	a0,a2				; as the skiptest routine requires address in a2....
	jsr	MemTesterSkipTest
	beq	.doit


	clr.l	d7				; We are in a workarea, skip this assumeall is ok!
	bra	.skiptest
.doit:

	move.l	(a0),d0				; make a backup of memorycontent

	lea	MEMCheckPattern,a1
.testloop:
	move.l	(a1)+,d2				; Load d2 with value to test


	move.l	d2,(a0)				; write it to RAM.
	move.l	#"CRAP",4(a0)			; Write "CRAP" to next longword. just to put crap in databus so stuck buffer will not give fale posetive
	nop
	nop					; Just 2 nops here.  040 etc might want this.

	move.l	(a0),d3				; load from ram to d3.  BUT do it several times, just to be sure we read correct value.
						; broken chips can report diferent values everytime, but first often the "wanted" one.
	move.l	(a0),d3
	move.l	(a0),d3				; ok this shold be enough.. lets trust d3 now contain what it thinks is in memory

	cmp.l	d3,d2				; Compare if they are equal.
	bne	.error
.back:
	cmp.l	#0,d2				; Check if we was at end of testlist
	bne	.testloop			; if not.  test next value

	move.l	d0,(a0)				; Restore memory
.skiptest:
	movem.l (a7)+,a0-a6/d0-d6		;Restore the registers from the stack
	rts

.error:

	move.l	d3,d4
	eor.l	d2,d4				; D4 bits that differs
	or.l	d4,CheckMemBitError-V(a6)	; or it into register to get a complete list of errors

	move.l	d3,d5
	and.l	d2,d5
	eor.l	d3,d5				; D5 all wrong HIGH bits
	or.l	d5,CheckMemHighError-V(a6)

	move.l	d5,d6
	eor.l	d4,d6				; D6 all wrong LOW bits
	or.l	d6,CheckMemLowError-V(a6)

	move.l	#1,d7				; Set d7 to 1 to mark we had an error

	bra	.back



MemTesterStep:
	move.l	CheckMemCurrent-V(a6),d0
	move.l	CheckMemTo-V(a6),d2
	cmp.l	d0,d2				; Check if we are done with the block
	blt	.passdone
	move.l	CheckMemBlockDone-V(a6),d1
	cmp.l	#$2000,d1			; Check if it is time to update
	blt	.noupdate
	clr.l	CheckMemBlockDone-V(a6)

	jsr	GetInput
	cmp.b	#1,BUTTON-V(a6)
	beq	.passquit
	PUSH
	TOGGLEPWRLED
	bsr	MemTesterUpdate
	POP
.noupdate:
	add.l	d6,CheckMemBlockDone-V(a6)	; Add to how much of block is done
	add.l	d6,CheckMemCurrent-V(a6)	; Add to next adress to test
	add.l	d6,CheckMemChecked-V(a6)
	cmp.l	#1,d7				; Check if d7 was 1 then we had a error on memtest, assume this whole block is bad
	bne	.noerr
	add.l	#1,CheckMemErrors-V(a6)
	add.l	d6,CheckMemNonUsable-V(a6)
.noerr:
	rts
.passdone:
	move.b	#-2,CheckMemOldType-V(a6)
	bsr	MemTesterHandle
	move.w	#1,CheckMemPassQuit-V(a6)
	rts
	
.passquit:
	move.l	d0,CheckMemCancelReason-V(a6)
	move.w	#1,CheckMemCancel-V(a6)
	clr.l	CheckMemStepSize-V(a6)		; clear the stepsize..

	bsr	LogLine
	lea	CheckMemCancelled,a0
	move.l	#6,d1
	jsr	Print
	move.l	CheckMemCancelReason-V(a6),d0
	btst.l	#3,d0
	bne	.serial
	btst	#2,d0
	bne	.key
	btst	#1,d0
	bne	.mouse

	lea	OtherPressTxt,a0
	bra	.reasondone
.serial:
	lea	SerialPressTxt,a0
	bra	.reasondone
.key:
	lea	KeyPressTxt,a0
	bra	.reasondone
.mouse:
	lea	MousePressTxt,a0
	bra	.reasondone

.reasondone:	
	move.l	#2,d1
	jsr	Print
	bsr	LogLine
	bsr	LogLine
	lea	AnyKeyMouseTxt,a0
	move.l	#2,d1
	jsr	Print
	clr.l	RunCodeStart-V(a6)		; make sure start of runcode is cleared for future use
	rts

MemTesterNewBlock:	
	clr.l	CheckMemPreFail-V(a6)		; Clear the prefail flag
	move.l	CheckMemFrom-V(a6),d0
	move.l	d0,d1
	and.l	#$ffffff,d1

	cmp.l	d0,d1				; are those the same.  then do not test if we have some 24bit adr. issue
	beq	.no24bit



	move.l	d1,a1
	move.l	d0,a0
	move.l	#"TEST",(a0)
	cmp.l	#"TEST",(a1)			; check if we get the same data at a1.  this means we are reading same data within 24bit adr.
	bne	.no24bit
	move.l	#-1,CheckMemPreFail-V(a6)	; Set the prefailflag to -1 telling we had an error

	jsr	LogLine
	lea	CheckMem24bitTxt,a0
	move.l	#5,d1
	jsr	Print

	move.l	CheckMemFrom-V(a6),d0
	jsr	binhex
	jsr	Print
	jsr	LogLine

	lea	CheckMem24bitTxt2,a0
	move.l	#1,d1
	jsr	Print

	bra	.nope
.no24bit:
	move.b	#-1,CheckMemOldType-V(a6)
	clr.l	CheckMemBitError-V(a6)
	clr.l	CheckMemHighError-V(a6)
	clr.l	CheckMemLowError-V(a6)
	move.l	#21,d0
	move.l	#3,d1
	jsr	SetPos
	move.l	CheckMemFrom-V(a6),d0
	jsr	binhex
	move.l	#2,d1
	jsr	Print
	move.l	#34,d0
	move.l	#3,d1
	jsr	SetPos
	move.l	CheckMemTo-V(a6),d0
	jsr	binhex
	move.l	#2,d1
	jsr	Print
	move.l	CheckMemFrom-V(a6),d0
	move.l	d0,CheckMemCurrent-V(a6)
.nope:
	rts
						; Update passes
MemTesterUpdate:				; Update from and to

	move.l	CheckMemPass-V(a6),d0
	cmp.l	CheckMemPassOLD-V(a6),d0
	beq	.passchange
	move.l	d0,CheckMemPassOLD-V(a6)
	jsr	bindec
	move.l	#12,d0
	move.l	#4,d1
	jsr	SetPos
	move.l	#2,d1
	jsr	Print
.passchange:
	move.l	CheckMemPassOK-V(a6),d0
	cmp.l	CheckMemPassOKOLD-V(a6),d0
	beq	.passchangeok
	move.l	d0,CheckMemPassOKOLD-V(a6)
	jsr	bindec
	move.l	#34,d0
	move.l	#4,d1
	jsr	SetPos
	move.l	#2,d1
	jsr	Print
.passchangeok:
	move.l	CheckMemPassFail-V(a6),d0
	move.l	d0,d7
	cmp.l	CheckMemPassFailOLD-V(a6),d0
	beq	.passchangeerror
	move.l	d0,CheckMemPassFailOLD-V(a6)
	jsr	bindec
	move.l	#57,d0
	move.l	#4,d1
	jsr	SetPos
	move.l	#2,d1
	cmp.l	#0,d7
	beq.s	.wasok
	move.l	#1,d1
.wasok:	
	jsr	Print
.passchangeerror:

	move.l	CheckMemCurrent-V(a6),d0
	cmp.l	CheckMemCurrentOLD-V(a6),d0
	beq	.current
	move.l	d0,CheckMemCurrentOLD-V(a6)
	jsr	binhex
	move.l	#18,d0
	move.l	#5,d1
	jsr	SetPos
	move.l	#3,d1
	jsr	Print
.current:

	move.l	CheckMemErrors-V(a6),d0
	move.l	CheckMemErrorsOLD-V(a6),d1
	cmp.l	d1,d0
	beq	.noerrors

	move.l	d0,d7
	move.l	d0,CheckMemErrorsOLD-V(a6)
	jsr	bindec
	move.l	#56,d0
	move.l	#7,d1
	jsr	SetPos
	move.l	#2,d1
	cmp.l	#0,d7
	beq	.noerr
	move.l	#1,d1
.noerr:
	jsr	Print

	
	move.l	#13,d0
	move.l	#8,d1
	jsr	SetPos
	lea	OK,a0
	move.l	#31,d6
	clr.l	d7
	move.l	CheckMemBitError-V(a6),d2	; Load what bits HAD errors
	move.l	CheckMemHighError-V(a6),d3	; Load what bits had stuck 1
	move.l	CheckMemLowError-V(a6),d4	; Load what bits had stuck 0
	move.l	d4,d5
	and.l	d3,d5				; D5 will now contain what bits had BOTH stuck 0 and 1 (varying bit)
.bitloop:
	cmp.w	#8,d7				; If this is the 8th char, do 2 spaces
	bne	.nospace
	lea	SpacesTxt,a0
	jsr	Print
	clr.l	d7				; Clear charcounter
.nospace:
	addq	#1,d7				; Add one to charcounter


	btst	d6,d2				; Check bit d6 of register to see error
	bne	.yeserr
	move.l	#"-",d0				; It was no error, so we print a green X
	move.l	#2,d1
	jsr	PrintChar
	bra	.errdone

.yeserr:					; OK we had an error
	btst	d6,d5				; Check if bit had both 0 or 1.
	bne.s	.yesboth

	btst	d6,d3				; Check for stuck 1
	bne.s	.yesone
						; as it wasn't 1.  and wasn't both. lets print as stuck 0
	move.l	#"0",d0
	move.l	#1,d1
	jsr	PrintChar
	bra	.errdone
						
.yesone:
	move.l	#"1",d0
	move.l	#1,d1
	jsr	PrintChar
	bra	.errdone
.yesboth:
	move.l	#"X",d0
	move.l	#1,d1
	jsr	PrintChar
.errdone:
	dbf	d6,.bitloop

.noerrors:

	move.l	CheckMemChecked-V(a6),d0
	cmp.l	CheckMemCheckedOLD-V(a6),d0
	beq	.nochecked
	move.l	d0,CheckMemCheckedOLD-V(a6)

	move.l	#16,d0
	move.l	#13,d1
	jsr	SetPos
	move.l	#2,d1
	move.l	CheckMemChecked-V(a6),d0
	jsr	ToKB
	jsr	bindec
	jsr	Print
.nochecked:


	move.l	CheckMemUsable-V(a6),d0
	cmp.l	CheckMemUsableOLD-V(a6),d0
	beq	.nousable
	move.l	d0,CheckMemUsableOLD-V(a6)

	move.l	#41,d0
	move.l	#13,d1
	jsr	SetPos
	move.l	#2,d1
	move.l	CheckMemUsable-V(a6),d0
	jsr	ToKB
	jsr	bindec
	jsr	Print
.nousable:

	move.l	CheckMemNonUsable-V(a6),d0
	cmp.l	CheckMemNonUsableOLD-V(a6),d0
	beq	.nonusable
	move.l	d0,CheckMemNonUsableOLD-V(a6)

	move.l	#70,d0
	move.l	#13,d1
	jsr	SetPos
	move.l	#2,d1
	move.l	CheckMemNonUsable-V(a6),d0
	move.l	d0,d7
	jsr	ToKB
	jsr	bindec
	move.l	#2,d1
	cmp.l	#0,d7
	beq	.noerr2
	move.l	#1,d1
.noerr2:
	jsr	Print

.nonusable:
	move.l	CheckMemAdrError-V(a6),d0
	cmp.l	CheckMemAdrErrorOLD-V(a6),d0
	beq	.noadr
	TOGGLEPWRLED
	move.l	d0,d7
	move.l	d0,CheckMemAdrErrorOLD-V(a6)
	move.l	#13,d0
	move.l	#11,d1
	jsr	SetPos
	move.l	d7,d3

	clr.l	d7
	move.l	#31,d6
.adrloop:
	cmp.b	#8,d7
	bne	.noadrspace

	lea	SpacesTxt,a0
	jsr	Print
	clr.l	d7				; Clear charcounter
.noadrspace:
	add.b	#1,d7
	btst	d6,d3
	bne	.adrerr
	move.l	#"-",d0
	move.l	#2,d1
	bra	.adrnoerr
.adrerr:
	move.l	#"E",d0
	move.l	#1,d1
.adrnoerr:
	jsr	PrintChar
	dbf	d6,.adrloop
.noadr:
	rts



MemTesterClear:
	clr.l	CheckMemBlockDone-V(a6)
	clr.w	CheckMemCancel-V(a6)
	clr.l	CheckMemNoErrors-V(a6)		; Clear number of errors
	clr.l	CheckMemAdrError2-V(a6)
	clr.l	CheckMemNonUsable-V(a6)
	clr.l	CheckMemErrors-V(a6)
	clr.l	CheckMemChecked-V(a6)
	clr.l	CheckMemUsable-V(a6)
	clr.l	CheckMemCancelReason-V(a6)
	rts

MemTesterInit:
	bsr	MemTesterClear
	jsr	Random				; Create a random number
	move.l	d0,CheckMemAdrRnd-V(a6)		; Store it as a token for addresserror test

	clr.l	CheckMemPassFail-V(a6)
	clr.l	CheckMemPassOK-V(a6)
	clr.l	CheckMemPass-V(a6)

	move.l	#31,d7
.clearloop:
	clr.b	(a0)+
	dbf	d7,.clearloop

	move.l	#-1,CheckMemPassOKOLD-V(a6)
	move.l	#-1,CheckMemPassOLD-V(a6)
	move.l	#-1,CheckMemPassFailOLD-V(a6)
	move.l	#-1,CheckMemCurrentOLD-V(a6)
	move.l	#-1,CheckMemCheckedOLD-V(a6)
	move.l	#-1,CheckMemErrorsOLD-V(a6)
	move.l	#-1,CheckMemUsableOLD-V(a6)
	move.l	#-1,CheckMemNonUsableOLD-V(a6)
	move.l	#-1,CheckMemAdrErrorOLD-V(a6)
	move.b	#-1,CheckMemOldType-V(a6)

	cmp.l	#4,CheckMemStepSize-V(a6)
	bge	.sizeok
	move.l	#4,CheckMemStepSize-V(a6)	; we had a too low size. so change it to 4
.sizeok:

	jsr	ClearScreen
	clr.l	MemTestPass-V(a6)
	
	lea	NewLineTxt,a0
	jsr	Print
	lea	NewLineTxt,a0
	jsr	Print
	lea	NewLineTxt,a0
	jsr	Print

	lea	CheckMemRangeTxt,a0
	move.l	#7,d1
	jsr	Print				; Print checking memory from...
	lea	NewLineTxt,a0
	jsr	Print

	lea	CheckMemNo,a0
	move.l	#7,d1
	jsr	Print				; Print checking memory from...

	lea	NewLineTxt,a0
	jsr	Print


	lea	CheckMemCheckAdrTxt,a0
	jsr	Print

	lea	NewLineTxt,a0
	jsr	Print

	lea	CheckMemBitErrsTxt,a0
	move.l	#7,d1
	jsr	Print				; Print Bit error shows max....


	lea	CheckMemDBitErrorsTxt,a0
	move.l	#3,d1				; Print Biterros and byte errors
	jsr	Print

	move.l	#45,d0
	move.l	#5,d1
	jsr	SetPos
	lea	CheckMemStepSizeTxt,a0
	move.l	#2,d1
	jsr	Print
	move.l	CheckMemStepSize-V(a6),d0
	jsr	bindec
	move.l	#2,d1
	jsr	Print



	move.l	#0,d0
	move.l	#9,d1
	jsr	SetPos

	lea	CheckMem16bitTxt,a0
	move.l	#5,d1
	jsr	Print


	lea	CheckMemABitErrorsTxt,a0
	move.l	#3,d1				; Print Biterros and byte errors
	jsr	Print

	move.l	#0,d0
	move.l	#12,d1
	jsr	SetPos

	lea	CheckMemAdrErrTxt,a0
	move.l	#5,d1
	jsr	Print


	move.l	#56,d0
	move.l	#6,d1
	jsr	SetPos
	lea	CheckMemNumErrTxt,a0
	move.l	#3,d1
	jsr	Print				; Print "Number of errors"
	bra	.nofast
.fastmode:
	lea	CheckMemFastModeTxt,a0
	move.l	#2,d1
	jsr	Print


.nofast:
	move.l	#0,d0
	move.l	#13,d1
	jsr	SetPos
	lea	CheckMemCheckedTxt,a0
	move.l	#6,d1
	jsr	Print

	move.l	#26,d0
	move.l	#13,d1
	jsr	SetPos
	lea	CheckMemUsableTxt,a0
	move.l	#6,d1
	jsr	Print

	move.l	#52,d0
	move.l	#13,d1
	jsr	SetPos
	lea	CheckMemNonUsableTxt,a0
	move.l	#6,d1
	jsr	Print



	clr.l	d0
	move.l	#14,d1
	jsr	SetPos
	lea	DividerTxt,a0
	move.l	#4,d1
	jsr	Print

	clr.l	CheckMemPassOK-V(a6)
	clr.l	CheckMemPassFail-V(a6)
	
	move.l	RunCodeStart-V(a6),d0
	cmp.l	#0,d0
	beq	.skipcode				; if it was 0.  we skipped even to try to run in ram
	jsr	LogLine
	lea	CheckMemCodeAreaTxt,a0
	move.l	#7,d1
	jsr	Print
	move.l	RunCodeStart-V(a6),d0
	jsr	binhex
	jsr	Print
	lea	MinusTxt,a0
	jsr	Print
	move.l	RunCodeEnd-V(a6),d0
	jsr	binhex
	jsr	Print
.skipcode:
	jsr	LogLine
	lea	CheckMemWorkAreaTxt,a0
	move.l	#7,d1
	jsr	Print


	move.l	BaseStart-V(a6),d0			; Get startaddress of chipmem
	jsr	binhex
	jsr	Print

	lea	MinusTxt,a0
	jsr	Print


	move.l	BaseEnd-V(a6),d0			; Get startaddress of chipmem
	jsr	binhex
	jsr	Print

							; Directly after the init.  we do a "new pass"
MemTesterNewPass:
	add.l	#1,CheckMemPass-V(a6)
	cmp.l	#1,CheckMemPass-V(a6)			; Check if we are in the first pass, then do not bother checking for result
	beq	.wehaderr				; by jumping to "wehaderr"  not correct label but correct location

	bsr	LogLine
	move.l	#"-",d0
	move.l	#6,d1
	jsr	PrintChar
	lea	CheckMemCheckedTxt,a0
	jsr	Print
	move.l	CheckMemChecked-V(a6),d0
	jsr	ToKB
	jsr	bindec
	jsr	Print
	lea	KB,a0
	jsr	Print
	lea	SpaceTxt,a0
	jsr	Print
	lea	CheckMemUsableTxt,a0
	move.l	#6,d1
	jsr	Print
	move.l	CheckMemUsable-V(a6),d0
	jsr	ToKB
	jsr	bindec
	jsr	Print
	lea	KB,a0
	jsr	Print
	lea	SpaceTxt,a0
	jsr	Print
	lea	CheckMemNonUsableTxt,a0
	move.l	#6,d1
	jsr	Print
	move.l	CheckMemNonUsable-V(a6),d0
	jsr	ToKB
	jsr	bindec
	jsr	Print
	lea	KB,a0
	jsr	Print


	move.l	#16,d0
	move.l	#13,d1
	jsr	SetPos
	lea	TenSpacesTxt,a0
	move.l	#1,d1
	jsr	Print
	move.l	#41,d0
	move.l	#13,d1
	jsr	SetPos
	lea	TenSpacesTxt,a0
	move.l	#1,d1
	jsr	Print
	move.l	#70,d0
	move.l	#13,d1
	jsr	SetPos
	lea	TenSpacesTxt,a0
	move.l	#1,d1
	jsr	Print					; Now we have cleaed the texts. so we can begin from scratch

	move.l	#56,d0
	move.l	#7,d1
	jsr	SetPos
	lea	TenSpacesTxt,a0
	move.l	#1,d1
	jsr	Print

	bsr	LogLine

	cmp.l	#0,CheckMemErrors-V(a6)
	beq	.noerr
	add.l	#1,CheckMemPassFail-V(a6)
	clr.l	CheckMemErrors-V(a6)
	bra	.wehaderr
.noerr:
	add.l	#1,CheckMemPassOK-V(a6)
.wehaderr:
	bsr	MemTesterClear
	rts



LogLine:					; Sets new line of log to print at
	PUSH
	clr.l	d1
	move.b	LogYpos-V(a6),d1
	add.b	#1,d1
	cmp.b	#31,d1
	beq	.endline
.setline:
	clr.l	d0
	jsr	SetPos
	move.b	d1,LogYpos-V(a6)
	POP
	rts
.endline:
	move.l	#15,d0
	jsr	DeleteLine
	sub.b	#1,d1
	bra	.setline
	



MemTestEndcode:

DetectMemo:
						; Detects memory
						; Indata:
						; a0 = Startadress.. or actually END of block as it scans backwards.
						; a1 = Endadress (or.. startadress)
						; Outdata:
						; d0 = Total amoumt of memory found (caluclated from 16Kb blocks)
						; d1 = if anything then 0, total memory was found in several blocks.
						; (like: you have  bad simm, placed wrong or so...)
						; a0 = first memoryaddress
						; a1 = last memoryaddress

			
						; (as the Amiga assigns memory that way)

	PUSH
	clr.l	d0				; Clear total amount of memory
	clr.l	d1				; Clear the "several block" flag
	clr.l	d3				; if 0, no memory found yet
	clr.l	d4				; Tempvariable holding the last working memaddress
	clr.l	d5				; Tempvariable holding the first working memaddress (last. scanning backwards)
	

	move.l	a0,a3				; Make a backup of the lowest memoryaddress

	cmp.l	#$ffffff,a1			; Check if testadress is above the 24bit limit
	ble	.check				; no, jump to check

	move.l	$700,d2				; Make a backup of $700
	clr.l	$700				; Clear $700 to be sure
	move.l	#"24BT",$4000700		; Write "24BT" to highmem
	cmp.l	#"24BT",$700			; IF memory is readable at $700 instead. we are using a cpu with 24 bit adress. no memory to detect this time
	beq	.24bitcpu
	move.l	d2,$700				; Restore $700 again

.check:
	sub.l	#$4000,a1			; Check next block of 16K of memory
	move.l	(a1),d2				; Backup data in position to test

	clr.l	d7				; should return 0 if there was no errors.
	lea	MEMCheckPattern,a4
.loop:
	move.l	(a4)+,d6
	move.l	d6,(a1)
	nop
	cmp.l	(a1),d6
	beq	.noerror
	move.b	#1,d7				; Mark that we had an error
.noerror:
	cmp.l	#0,d6				; Was last value a 0? if so, this longword is fully checked
	bne.s	.loop				; no, test some more
	move.l	d2,(a1)				; Restore backup of data to address

	cmp.b	#1,d7
	beq	.error				; If we had an error, handle it


	move.l	a1,d4				; OK, we had no error, meaning this is working memory
						; So store this address in d4
						
	cmp.b	#1,d3				; Check if we had working memory before
	beq	.yesmem				; yes we had
	move.b	#1,d3				; Mark that we now have memory
	move.l	a1,d5				; And store at what memory this segments ends. (yes we scan backwards)
	
.yesmem:

	add.l	#1,d0				; ok, no error, so we had memory. add one to block
.nomem:
	cmp.l	a0,a1				; Check if we scanned the whole block
	bge	.check				; no, scan more
.done:
	
	move.l	d0,temp-V(a6)			; Store size
	move.l	d4,temp+4-V(a6)			; Store firstmemaddress
	move.l	d5,temp+8-V(a6)			; Store last memaddress
	move.l	a3,temp+12-V(a6)		; Store the first WANTED memaddress to scan

						; lets change it to the lowest address we wanted to test

	POP					; Restore all registers
	move.l	temp-V(a6),d0
	asl.l	#6,d0
	asl.l	#8,d0
	move.l	temp+4-V(a6),a0
	move.l	temp+8-V(a6),a1

	cmp.l	temp+12-V(a6),a0		; Check is first memoryaddress is in a lower address than wanted
						; meaning that the 16K chunk was too big
	bgt	.notlower

	PUSH

	move.l	temp+12-V(a6),d1
	move.l	a0,d2
	sub.l	d2,d1				; D1 is now the difference between address we got and the real one
	move.l	d1,temp+8-V(a6)			; Lets store it as temp
	
	bchg	#1,$bfe001			; So lets correct it
	POP
	move.l	temp+12-V(a6),a0		; Lets put the lowest address to check as address of detected mem
	sub.l	temp+8-V(a6),d0			; Lets subtract sizedifference to size found

.notlower:

	rts

.error:						; OK we had an error in check
	cmp.b	#1,d3				; did we have memory detected before?
	bne	.nomem				; no, so scan for some
	beq	.done				; ok we had memory, this is the end (or beginning of it)
						; so stop.
						

.24bitcpu:					; OK we had a 24bit cpu and wanted to check memory above 24bit.
						; give null as answer
	POP
	clr.l	d0
	lea	$0,a0
	lea	$0,a1
	rts


WaitButton:					; Waits until a button is pressed AND released
	bsr	WaitPressed
	bsr	WaitReleased
	rts


WaitPressed:					; Waits until some "button" is pressed
	clr.l	d7				; Clear d7 that is used for a timeout counter
.loop:
		ifne	rommode			; if we are in rommode, do timeout code..
	add.l	#1,d7				; Add 1 to the timout counter
	cmp.l	#$ffff,d7			; did we count for a lot of times? well then there is a timeout
	beq	.timeout
		endc
	bsr	GetInput			; get inputdata
	cmp.b	#1,BUTTON-V(a6)			; check if any button was pressed.
	bne	.loop				; nope. lets loop
	rts
.timeout:
	rts
	move.b	P1LMB-V(a6),STUCKP1LMB-V(a6)	; ok we had a timeout. so we GUESS a port is stuck.
	move.b	P2LMB-V(a6),STUCKP2LMB-V(a6)	; if we just simply copy the status of all keys
	move.b	P1LMB-V(a6),STUCKP1LMB-V(a6)	; to the STUCK version. we will disable all stuck ports
	move.b	P2RMB-V(a6),STUCKP2RMB-V(a6)
	move.b	P1MMB-V(a6),STUCKP1MMB-V(a6)
	move.b	P2MMB-V(a6),STUCKP2MMB-V(a6)
	rts

WaitReleased:					; Waits until some "button" is unreleased

	clr.l	d7				; Clear d7 that is used for a timeout counter
.loop:
		ifne	rommode
	move.b	$dff006,$dff180
	add.l	#1,d7				; Add 1 to the timout counter
	cmp.l	#$ffff,d7			; did we count for a lot of times? well then there is a timeout
	beq	.timeout
		endc
	bsr	GetInput			; get inputdata
	cmp.b	#0,BUTTON-V(a6)			; check if any button was pressed.
	bne	.loop				; nope. lets loop
	rts
.timeout:
	move.b	P1LMB-V(a6),STUCKP1LMB-V(a6)	; ok we had a timeout. so we GUESS a port is stuck.
	move.b	P2LMB-V(a6),STUCKP2LMB-V(a6)	; if we just simply copy the status of all keys
	move.b	P1LMB-V(a6),STUCKP1LMB-V(a6)	; to the STUCK version. we will disable all stuck ports
	move.b	P2RMB-V(a6),STUCKP2RMB-V(a6)
	move.b	P1MMB-V(a6),STUCKP1MMB-V(a6)
	move.b	P2MMB-V(a6),STUCKP2MMB-V(a6)
	rts


;------------------------------------------------------------------------------------------


