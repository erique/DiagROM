Print:						; Prints a string
	PUSH					; INDATA:
	clr.l	d7				; Clear d7
	cmp.b	#2,(a0)				; Check if first byte in string is a 2, then we will center it.
	beq	.center
.print:						; A0 = string to print, nullterminated
						; D1 = Color
	clr.l	d0
	move.b	(a0)+,d0
	cmp.b	#0,d0				; is the char 0?
	beq	.exit				; exit printing, we are done

	bsr	PrintChar

	add.l	#1,d7				; add one to d7
	cmp.l	#3000,d7			; to avoid "foreverprinting" bug, if string is too long, just stop
	beq	.exit
	
	bra.s	.print
.exit:
	POP
	rts


.center:
	move.l	d1,d5				; backup colordata
	add.l	#1,a0				; First skip this first char.
	move.l	a0,a1				; Store stringaddress for future use.
	clr.l	d7				; Clear d7
.loop:
	move.b	(a0)+,d6			; Read char into d6

	cmp.b	#0,d6				; End of string?
	beq	.end

	cmp.b	#31,d6
	ble	.loop				; is less then space? then it is not printable and should be ignored

	add.l	#1,d7				; Add 1 to length of string
	bra	.loop
.end:						; OK we are done, d7 now contains length of string
	cmp.b	#80,d7				; Check if string is larger then one row, then skip centerstuff
	bge	.zero

	move.l	#80,d1
	sub.b	d7,d1				; d7 now contains number of chars to fill row.
	asr	#1,d1				; Divide by 2, d7 now contains number of spaces to fill out to center

	cmp.b	#0,d1				; Check if zero, then no spaces to be printed
	beq	.zero
	move.l	d1,d7
	sub.b	#1,d7				; Subtract with 1 so loop gets correct number of spaces.

.spaceloop:
	move.b	#" ",d0				; make sure a space is printed
	move.l	d5,d1
	bsr	PrintChar			; Print it
	dbf	d7,.spaceloop			; loop it.

.zero:
	move.l	a1,a0				; We are done, restore string to print (minus first char) and print it
	move.l	d5,d1				; Restore d1 (color)
	bra	.print


DeleteLine:					; Delete line D0 on screen, scrolls everything under it up one line
	PUSH
	move.b	Xpos-V(a6),d6			; Make a backup of XPos.
	move.b	Ypos-V(a6),d7			; Make a backup of YPos

	clr.l	d1
	move.b	d0,d1				; set Y pos. (we used d0 to be lazy and logic)
	move.l	d1,d5
	move.l	#0,d0				; Set 0 to X pos. we already have Y pos in d0
	bsr	SetPos

	lea	DELLINE,a0			; Send ANSI command to delete line and scroll up
	move.l	#3,d1
	bsr	Print

	cmp.b	#0,NoDraw-V(a6)			; Check if we should draw
	bne	.exit
						; Lets Scroll up physical screen
						
	move.l	Bpl1Ptr-V(a6),a0		; load A0 with address of BPL1
	move.l	Bpl2Ptr-V(a6),a1		; load A1 with address of BPL2
	move.l	Bpl3Ptr-V(a6),a2		; load A2 with address of BPL3



	move.l	#31,d4				; Last line is 31
	sub.l	d5,d4				; subtract number of lines to where we was
	mulu	#640,d4				; calculate where in memory this is


	mulu	#640,d5				; calulate where to start scroll
	add.l	d5,a0
	add.l	d5,a1
	add.l	d5,a2
	move.l	#-1,(a0)
	move.l	#-1,(a1)
	move.l	#-1,(a2)


	divu	#4,d4
.loop:
	move.l	640(a0),(a0)+
	move.l	640(a1),(a1)+
	move.l	640(a2),(a2)+	
	dbf	d4,.loop



	move.w	#159,d4
.loop2:
	clr.l	(a0)+
	clr.l	(a1)+
	clr.l	(a2)+				; Clear last row
	dbf	d4,.loop2

.exit:
	clr.l	d0				; Restore old X and Y cordinates
	clr.l	d1
	move.b	d6,d0
	move.b	d7,d1
	bsr	SetPos
	
	POP
	rts


ScrollScreen:
	cmp.b	#0,NoDraw-V(a6)			; Check if we should draw
	bne	.exit

	PUSH
	move.l	Bpl1Ptr-V(a6),a0		; load A0 with address of BPL1
	move.l	Bpl2Ptr-V(a6),a1		; load A1 with address of BPL2
	move.l	Bpl3Ptr-V(a6),a2		; load A2 with address of BPL3
	move.l	#EndBpl1-Bpl1,d0		; How much data is one screen
	sub.l	#640,d0				; Subtract 8 pixels
	divu	#4,d0				; Divide by 4 to get longwords.
.loop:
	move.l	640(a0),(a0)+
	move.l	640(a1),(a1)+
	move.l	640(a2),(a2)+	
	dbf	d0,.loop

	move.w	#159,d0
.loop2:
	clr.l	(a0)+
	clr.l	(a1)+
	clr.l	(a2)+				; Clear last row
	dbf	d0,.loop2
	POP
.exit:
	rts

SendSerial:
						; Indata a0=string to send to serialport
						; nullterminated

	PUSH
	clr.l	d0				; Clear d0
.loop:
	move.b	(a0)+,d0
	cmp.b	#0,d0				; end of string?
	beq	.nomore				; yes
	bsr	rs232_out
	bra.s	.loop
.nomore:
	POP
	rts

SendSerialLW:
	PUSH
	clr.l	d0
	move.b	(a0)+,d0
	bsr	rs232_out
	move.b	(a0)+,d0
	bsr	rs232_out
	move.b	(a0)+,d0
	bsr	rs232_out
	move.b	(a0)+,d0
	bsr	rs232_out
	POP
	rts

SetPos:						; Set cursor at wanted position on screen
						; Indata:
						; d0 = xpos
						; d1 = ypos

	PUSH
	move.b	d0,Xpos-V(a6)
	move.b	d1,Ypos-V(a6)
	move.l	d0,d2
	move.l	d1,d0
	add.l	#1,d0
	lea	Ansi,a0
	bsr	SendSerial
	bsr	oldbindec			;convert d0 to decimal string (x pos)
	bsr	SendSerial			;and send result to serialport
	move.l	#";",d0				;load d0 with ;
	bsr	rs232_out
	move.l	d2,d0
	add.l	#1,d0
	bsr	oldbindec			;convert d0 (from d1. Ypos) to decimal
	bsr	SendSerial
	move.l	#"H",d0
	bsr	rs232_out
	POP
	rts

GetPos:
	clr.l	d0
	clr.l	d1
	move.b	Xpos-V(a6),d0
	move.b	Ypos-V(a6),d1
	rts


SetPosNoSerial:					; Set cursor at wanted position on screen but not on serialport
						; Indata:
						; d0 = xpos
						; d1 = ypos

	move.b	d0,Xpos-V(a6)
	move.b	d1,Ypos-V(a6)
	rts


ToKB:						; Convert D0 to KB (divide by 1024)
	asr.l	#8,d0
	asr.l	#2,d0
	rts



	; *********************************************
	;
	; $VER:	Binary2Decimal.s 0.2b (22.12.15)
	;
	; Author: 	Highpuff
	; Orginal code: Ludis Langens
	;
	; In:	D0.L = Hex / Binary
	;
	; Out:	A0.L = Ptr to null-terminated String
	;	D0.L = String Length (Zero if null on input)
	;
	; *********************************************


b2dNegative	equ	0			; 0 = Only Positive numbers
						; 1 = Both Positive / Negative numbers

	; *********************************************


bindec:		movem.l	d1-d5/a1,-(sp)

		moveq	#0,d1			; Clear D1/2/3/4/5
		moveq	#0,d2
		moveq	#0,d3
		moveq	#0,d4
		moveq	#0,d5

		lea.l	b2dString+12-V(a6),a0
		movem.l	d1-d3,-(a0)		; Clear String buffer

		neg.l	d0			; D0.L ! D0.L = 0?
		bne	.notZero		; If NOT True, Move on...
		move.b	#$30,(a0)		; Put a ASCII Zero in buffer
		moveq	#1,d0			; Set Length to 1
		bra	.b2dExit		; Exit	
		
.notZero:	neg.l	d0			; Restore D0.L

	IF b2dNegative				; Is b2dNegative True?

		move.l	d0,d1			; D1.L = D0.L
		swap	d1			; Swap Upper Word with Lower Word
		rol.w	#1,d1			; MSB  = First byte
		btst	#0,d1			; Negative?
		beq	.notNegative		; If not, jump to .notNegative
		move.b	#$2d,(a0)+		; Add a '-' to the String
		neg.l	d0			; Make D0.L positive
.notNegative:	moveq	#0,d1			; Clear D1 after use

	endc

.lftAlign:	addx.l	d0,d0			; D0.L = D0.L << 1
		bcc.s	.lftAlign		; Until CC is set (all trailing zeros are gone)

.b2dLoop:	abcd.b	d1,d1			; xy00000000
		abcd.b	d2,d2			; 00xy000000
		abcd.b	d3,d3			; 0000xy0000
		abcd.b	d4,d4			; 000000xy00
		abcd.b	d5,d5			; 00000000xy
		add.l	d0,d0			; D0.L = D0.L << 1
		bne.s	.b2dLoop		; Loop until D0.L = 0
	
		; Line up the 5x Bytes

		lea.l	b2dTemp-V(a6),a1	; A1.L = b2dTemp Ptr
		move.b	d5,(a1)			; b2dTemp = d5.xx.xx.xx.xx
		move.b	d4,1(a1)		; b2dTemp = d5.d4.xx.xx.xx
		move.b	d3,2(a1)		; b2dTemp = d5.d4.d3.xx.xx
		move.b	d2,3(a1)		; b2dTemp = d5.d4.d3.d2.xx
		move.b	d1,4(a1)		; b2dTemp = d5.d4.d3.d2.d1


		; Convert Nibble to Byte
		
		moveq	#5-1,d5			; 5 bytes (10 Bibbles) to check
.dec2ASCII:	move.b	(a1)+,d1		; D1.W = 00xy
		ror.w	#4,d1			; D1.W = y00x
		move.b	d1,(a0)+		; Save ASCII
		sub.b	d1,d1			; D1.B = 00
		rol.w	#4,d1			; D1.W = 000y
		move.b	d1,(a0)+		; Save ASCII
		dbf	d5,.dec2ASCII		; Loop until done...

		sub.l	#10,a0			; Point to first byte (keep "-" if it exists)
		move.l	a0,a1

		; Find where the numbers start and trim it...

		moveq	#10-1,d5		; 10 Bytes total to check
.trimZeros:	move.b	(a0),d0			; Move byte to D0.B
		bne.s	.trimSkip		; Not Zero? Exit loop
		add.l	#1,a0			; Next Character Byte
		dbf	d5,.trimZeros		; Loop
.trimSkip:	move.b	(a0)+,d0		; Move Number to D0.B
		add.b	#$30,d0			; Add ASCII Offset to D0.B
		move.b	d0,(a1)+		; Move to buffer
		dbf	d5,.trimSkip		; Loop

		; Get string length

		move.l	a1,d0			; D0.L = EOF b2dString
		lea.l	b2dString-V(a6),a0	; A0.L = SOF b2dString
		sub.l	a0,d0			; D0.L = b2dString.Length
		move.b	#0,(a0,d0)
.b2dExit:	movem.l	(sp)+,d1-d5/a1
		rts





oldbindec:					; Converts a binary number to decimal textstring
						; this is my old bin->dec code. it is still here as I need a bin-dec
						; convertion done for ANSI stuff in my print routine. and that can
						; overwrite other data when printing. so to separate the different things
						; why not have this left.  this only handles word and no longwords...
						;
						; INDATA:
						;	D0 = binary number (word)
						; OUTDATA:
						;	A0 = Pointer to "bindecoutput" contining the string

	PUSH
	lea	bindecoutput-V(a6),a0
	move.b	#$20,d1
	tst.w	d0
	bpl	.notneg
	move.b	#$2d,d1
	neg.w	d0
	clr.l	d3
.notneg:
	move.b	d1,(a0)
	add.l	#5,a0
	move.w	#4,d1
.loop:
	ext.l	d0
	divs	#10,d0
	swap	d0
	move.b	d0,-(a0)
	add.b	#$30,(a0)
	swap	d0
	dbra	d1,.loop
	clr.l	d0
.scroll:
	move.w	#6,d2
	lea	bindecoutput-V(a6),a0
	lea	bindecoutput+1-V(a6),a1
	move.b	(a0),d1
	cmp.b	#"0",d1
	bne.s	.stop
	add.b	#1,d0
	cmp.b	#5,d0
	beq.s	.stop
.scroll1:
	move.b	(a1)+,(a0)+
	dbf	d2,.scroll1
	bra.s	.scroll
.stop:
	POP
	lea	bindecoutput-V(a6),a0
	rts


decbin:						; Convert a decimal string to binary number
						; IN:
						;	A0 = String (NO SYNTAXCHECK!)
						; OUT:
						;	D0 = Number in binary (16 bit number max)
	PUSH
	jsr	StrLen
	move.l	#1,d7
	clr.l	d2
	clr.l	d1
.loop:
	sub.l	#1,d0				; Subtract 1 to the length
	move.b	(a0,d0),d1			; get char from the string
	sub.b	#"0",d1				; Subtract "0" to get the binary number
	mulu	d7,d1				; multiply with whats in d7 to d1 to get what to add in the result
	add.l	d1,d2				; add it to d2
	mulu	#10,d7				; multiply 10 do d7 to get next value to add for next char
	cmp.w	#0,d0				; are we done?
	bne.s	.loop				; no loop
	move.l	d2,DecBinBin-V(a6)		; write result
	POP
	move.l	DecBinBin-V(a6),d0		; D0 now contains the binary form of the number
	rts



hexbin:						; Converts a longword to binary.
						; NO ERRORCHECk WHATSOEVER!
						; Input:
						;	A0 = String to convert (8 bytes)
						; Output:
						;	D0 = binary number
						;
	PUSH
	clr.l	d0				; Clear D0 that will contain the binary number
	move.l	#3,d7				; Loop this 3 times.
.loop:

	bsr	hexbytetobin

	asl.l	#8,d0				; Rotate d0 8 bits to make room for the next byte
	add.l	d2,d0				; Add the content of d2 to d0
	dbf	d7,.loop			; Repeat 3 times to complete one longword
	move.l	d0,HexBinBin-V(a6)
	POP
	move.l	HexBinBin-V(a6),d0
	rts



hexbytetobin:
	clr.l	d2				; Clear D2 that holds the ASCII code
	move.b	(a0)+,d2			; Read one byte of the string
	bsr	.tobin				; Convert to binary
	move.l	d2,d1				; Store the value in D1
	move.b	(a0)+,d2			; Read next char to complete this byte
	bsr	.tobin				; Convert to binary
	asl.l	#4,d1				; Rotate the first char 4 bits
	add.l	d1,d2				; add d1 to d2, d2 will now contain this byte in binary
	rts
.tobin:
	cmp.b	#"A",d2				; Check if it is "A"
	blt	.nochar				; Lower then A, this is not a char
	sub.l	#7,d2				; ok we have a char, subtract 7
.nochar:
	sub.l	#$30,d2				; Subtract $30, converting it to binary.
	rts

binhexbyte:
						; Same as binhex but only for one byte.
	PUSH
	lea	hextab,a1			; location of hexstring source
	lea	binhexoutput-V(a6),a0
	clr.l	(a0)
	clr.l	4(a0)
	clr.w	8(a0)				; Clear the area first.
	add.l	#9,a0
	move.l	#1,d1
.loop:
	move.l	d0,d2
	and.l	#15,d2
	move.b	(a1,d2),-(a0)
	lsr.l	#4,d0
	dbra	d1,.loop
	POP
	lea	binhexoutput+7-V(a6),a0
	rts



binhexword:
						; Same as binhex but only for one word.
	PUSH
	lea	hextab,a1			; location of hexstring source
	lea	binhexoutput-V(a6),a0
	clr.l	(a0)
	clr.l	4(a0)
	clr.w	8(a0)				; Clear the area first.
	add.l	#9,a0
	move.l	#3,d1
.loop:
	move.l	d0,d2
	and.l	#15,d2
	move.b	(a1,d2),-(a0)
	lsr.l	#4,d0
	dbra	d1,.loop
	POP
	lea	binhexoutput+4-V(a6),a0
	move.b	#"$",(a0)
	rts
						; Same as binhex but only for one byte.


binstringbyte:
						; Converts a binary number (byte) to binary string
						; INDATA:
						;	D0 = binary number
						; OUTDATA:
						;	A0 = Poiner to outputstring
	PUSH
	move.l	#7,d7
	lea	binstringoutput-V(a6),a0
.loop:
	btst	d7,d0
	beq	.notset
	move.b	#"1",(a0)+
	bra	.done
.notset:
	move.b	#"0",(a0)+
.done:
	dbf	d7,.loop
	move.b	#0,(a0)
	
	POP
	lea	binstringoutput-V(a6),a0
	rts


binstring:
						; Converts a binary number (longword) to binary string
						; INDATA:
						;	D0 = binary number
						; OUTDATA:
						;	A0 = Poiner to outputstring
	PUSH
	move.l	#31,d7
	lea	binstringoutput-V(a6),a0
.loop:
	btst	d7,d0
	beq	.notset
	move.b	#"1",(a0)+
	bra	.done
.notset:
	move.b	#"0",(a0)+
.done:
	dbf	d7,.loop
	move.b	#0,(a0)
	
	POP
	lea	binstringoutput-V(a6),a0
	rts

		

binhex:						; Converts a binary number to hex
						; INDATA:
						;	D0 = binary nymber
						; OUTDATA:
						;	A0 = Pointer to "binhexoutput" contiaing the string
	PUSH
	lea	hextab,a1			; location of hexstring source
	lea	binhexoutput-V(a6),a0
	clr.l	(a0)
	clr.l	4(a0)
	clr.w	8(a0)				; Clear the area first.
	move.b	#"$",(a0)			; put a leading "$" char in the beginning
	add.l	#9,a0
	move.l	#7,d1
.loop:
	move.l	d0,d2
	and.l	#15,d2
	move.b	(a1,d2),-(a0)
	lsr.l	#4,d0
	dbra	d1,.loop
	POP
	lea	binhexoutput-V(a6),a0
	rts

HandleMenu:					; Routine that handles menus.
	cmp.b	#0,MenuChoose-V(a6)		; If this item chosen with keyboard etc?
	bne	.released			; if so.  go to "releaaed" (after LMB is released again..)
	cmp.b	#1,MBUTTON-V(a6)
	bne	.nobutton			; no mousebutton pressed

.CheckButton:
	bsr	GetInput
	bsr	WaitShort
	cmp.b	#0,MBUTTON-V(a6)
	bne	.CheckButton
.released:
	clr.b	MenuChoose-V(a6)		; Clear value of choosen item
	clr.l	d0
	move.w	MenuNumber-V(a6),d0
	lea	MenuCode,a0			; Get list of pointers to list for the menu
	mulu	#4,d0				; Multiply menunumber with 4
	add.l	d0,a0				; read pointer to the correct menu
	move.l	(a0),a0				; a0 now contains address of menu routines

	clr.l	d0
	move.b	MarkItem-V(a6),d0		; Get the marked item
	mulu	#4,d0
	
	add.l	d0,a0				; a0 now contains the address of the pointer to the routing
	move.l	(a0),a0				; a0 now contains the address of the routine.

	jmp	(a0)				; go there
.nobutton:

	clr.l	d0
	move.w	MenuNumber-V(a6),d0
	lea	MenuKeys,a0
	mulu	#4,d0
	add.l	d0,a0
	move.l	(a0),a0				; A0 now contains pointer to where list of interesting keys are.
	clr.l	d0				; Clear d0
.loop:
	cmp.b	#0,(a0)				; does A0 point to 0? in that case, out of list
	beq	.nokey

	move.b	GetCharData-V(a6),d7		; d7 is now what the last keycode was.
	cmp.b	(a0),d7				; check if value in list is the same as pressed keycode
	beq	.Pressed
.nokeyboard:
	add.l	#1,a0
	add.l	#1,d0
	bra	.loop
.nokey:	
	rts

.Pressed:					; ok we have a match of key or serial.
	move.b	d0,MarkItem-V(a6)		; store it to marked item
	bra	.released			; so jump to the part of the code that actually executes the routine

PrintMenu:
						; Prints out menu.
						; INDATA = D0 - MenuNumber
	PUSH
	clr.l	d1
	clr.l	d2
	clr.l	d3
	clr.l	d4
	clr.l	d5
	clr.l	d6
	clr.l	d7
	move.w	MenuNumber-V(a6),d0
	cmp.w	OldMenuNumber-V(a6),d0		; Check if menu is changed since last call
	beq	.nochange
	clr.b	MarkItem-V(a6)			; Clear variables for marked item etc
	clr.b	OldMarkItem-V(a6)	
	move.w	d0,OldMenuNumber-V(a6)
.nochange:
	cmp.b	#0,PrintMenuFlag-V(a6)
	beq	.noprint			; if flag is 0, menu is already printed.
	cmp.b	#2,PrintMenuFlag-V(a6)		; Check if we just want to update
	beq	.noupdatemenu
	move.b	#0,MenuPos-V(a6)		; Clear menuposition. always start at the top as we didnt want to update
.noupdatemenu:	
	clr.l	d0
	move.w	MenuNumber-V(a6),d0		; Load what menunumber to print
	move.l	MenuVariable-V(a6),a2		; A2 now contains pointer to pointerlist of variables. if 0 = no variables ignore

	move.l	Menu-V(a6),a0			; Load a0 with pointer to list of menus.
.nozero:
	mulu	#4,d0				; multiply d0 with 4 to point on the correct item on list.
	add.l	d0,a0				; A0 now points on the correct item in the menulist
	move.l	(a0),a1				; A1 now contains the menuinfo.

	clr.l	d0
	clr.l	d1
	bsr	SetPos
	move.l	(a1),a0				; Print first line (label) of the menu
	move.l	#7,d1
	
	cmp.b	#0,UpdateMenuNumber-V(a6)	; Check if we will only update one line.
	bne	.nolabel			; if so, skip printing label
	bsr	Print				; Print label of the menu
.nolabel:
	add.l	#4,a1				; Skip first row of itemlist as it was the label
	move.l	a1,a0				; Copy a1 to a0


	clr.l	d1				; Clear D1
	move.l	a0,a1


.loop:
	add.l	#1,d1				; Add 1 to D1 for number of entrys in list
	cmp.l	#0,(a1)+			; is A1 pointing to a 0?
	bne.s	.loop				; no, we are not at end of list if items in the menu.
	sub.l	#2,d1				; we ARE at end of itmes, and as we counted the last 0 aswell.. subtract with 2
						; d1 now contrains number of items in this menu.

	move.b	d1,MenuEntrys-V(a6)


	move.l	d1,d5				; Copy d1 to d5

	move.l	#20,d6				; Set d6 to X pos of text in menu
	move.l	#5,d7				; Set d7 to 5, where to start text on the meny on the Y pos

	move.l	a0,a1				; a1 is now list of items in menu
	clr.l	d4


.loop2:
	add.l	#1,d4
	move.l	(a1)+,a0

	cmp.b	#0,UpdateMenuNumber-V(a6)
	beq	.prnt
	cmp.b	UpdateMenuNumber-V(a6),d4	; Check if we just should update one line
	bne	.noprnt	
.prnt:
	move.l	d6,d0
	move.l	d7,d1
	bsr	SetPos				; Set position on screen for next item to be printed.
	move.l	#6,d1
	bsr	Print

.noprnt:
	cmp.l	#0,a2				; Check if A2 is 0.  if so, do not do anything with variables
	beq	.novar
						; OK, we have variables to be printed after the normal menuitem
						; A2 is a pointer to where a list of variables are located.
						; it is actually just a list if pointers to strings to be printed.
						; first word is color to print, next longword is pointer to string to be
						; printed.

	cmp.b	#0,UpdateMenuNumber-V(a6)
	beq	.prntvar
	cmp.b	UpdateMenuNumber-V(a6),d4	; Check if we just should update one line
	bne	.noprntvar
.prntvar:
	lea	SPACE,a0
	bsr	Print

	move.w	(a2),d1				; Set color
	move.l	2(a2),a0			; Set string
	cmp.l	#0,a0				; is A0 0? then skip printing
	beq	.novar
		
	bsr	Print				; Print it
.noprntvar:
	add.l	#6,a2				; add 6 to a2 for next varaibledata to print

.novar:
	add.l	#2,d7				; Add 2 to next row to print.
	dbf	d5,.loop2			; Print all items on the menu
	move.b	#1,UpdateMenuFlag-V(a6)
	move.b	#0,UpdateMenuNumber-V(a6)
.noprint:
						; ok we have printed the menu (or skipped it, depending on flag)
						; now lets see if it needs to be updated.
	clr.l	d7
	move.b	MenuEntrys-V(a6),d7
						; but to be sure, we add 1 to the result.
					
	clr.l	d0
	move.b	GetCharData-V(a6),d0

	cmp.b	#30,d0
	bne	.NoUp

	bsr	.Up
	bra	.NoKeyMove
	
.NoUp:
	cmp.b	#31,d0
	bne	.NoDown
	bsr	.Down
	bra	.NoKeyMove

.NoDown:
	cmp.b	#$a,d0
	bne	.NoEnter
	move.b	#1,MenuChoose-V(a6)
	bsr	ClearBuffer			; Make sure inputbuffer is cleared

.NoEnter:


.NoKeyMove:


	move.w	CurAddY-V(a6),d7		; Load d7 with any value of added (lower) mousemovement
	cmp.w	#0,d7
	beq	.noadd				; no movements down...


	clr.w	MenuMouseSub-V(a6)		; ok we add, then clear any sub variable
	add.w	d7,MenuMouseAdd-V(a6)		; add it to mouseadd variable
	cmp	#40,MenuMouseAdd-V(a6)		; Check if we moved enough to bump menu one step
	blt	.noadd	

	clr.w	MenuMouseAdd-V(a6)
	bsr	.Down
	
.noadd:
	move.w	CurSubY-V(a6),d7
	cmp.w	#0,d7
	beq	.nosub

	clr.w	MenuMouseAdd-V(a6)
	add.w	d7,MenuMouseSub-V(a6)
	cmp.w	#40,MenuMouseSub-V(a6)
	blt	.nosub

	clr.w	MenuMouseSub-V(a6)
	bsr	.Up

.nosub:

	clr.l	d7
	move.b	MenuPos-V(a6),d7		; Load d7 with menupostin to highlight

	move.b	d7,MarkItem-V(a6)

	cmp.b	#0,PrintMenuFlag-V(a6)		; check if menu is printed
	bne	.forceupdate			; if so, also force update of the marked line etc

	cmp.b	OldMarkItem-V(a6),d7		; Compare the value with the old marked item
	beq	.noupdate			; no changes done, no updates needed.
.forceupdate:

	clr.l	d7
	move.b	OldMarkItem-V(a6),d7		; d7 now contains the number of the FORMERLY marked item.
	move.b	#6,d6				; Set Color
	bsr	.PrintItem			; print it.
	

	clr.l	d7
	move.b	MarkItem-V(a6),d7
	move.b	d7,OldMarkItem-V(a6)

	move.l	#13,d6
	bsr	.PrintItem


.noupdate:				
	clr.b	PrintMenuFlag-V(a6)		; ok, clear the print menu flag..  we do not want this to be printed again;
	
	POP
	rts


.Up:
	cmp.b	#0,MenuPos-V(a6)		; check if we already are at the top
	beq	.No
	sub.b	#1,MenuPos-V(a6)		; Move up one step
.No:	rts

.Down:
	clr.l	d7
	move.b	MenuEntrys-V(a6),d7
	cmp.b	MenuPos-V(a6),d7
	beq	.No
	add.b	#1,MenuPos-V(a6)
	rts


.PrintItem:					; Prints item on menu.
						; d7 = item to print
						; d6 = color to use when printing

	PUSH					
	move.w	MenuNumber-V(a6),d0		; Load what menunumber to print

	move.l	Menu-V(a6),a0			; Load a0 with pointer to list of menus.
	mulu	#4,d0				; multiply d0 with 4 to point on the correct item on list.
	add.l	d0,a0				; A0 now points on the correct item in the menulist
	move.l	(a0),a1				; A1 now contains the menuinfo.
	add.l	#4,a1				; Skip first item as it is the label anyway.

	move.l	d7,d2				; copy d1 to d2 so d2 also contains the item to highlight.
	mulu	#2,d2				; Multiply d2 with 2 to get the row to print the text on.

	move.l	#20,d0				; Load d0 with X Postition of menu
	move.l	#5,d1				; Load d1 with beginning of Y position
	add.l	d2,d1				; add number of lines for the item to update
	bsr	SetPos				; Set screenposition
	move.l	d7,d2				; copy d7 to d2
	mulu	#4,d2				; Multiply with 4, so we know what item in list to point to
	add.l	d2,a1				; add it to a1, a1 now points to pointer of string to update
	move.l	(a1),a0				; load A0 with actual string
	move.l	d6,d1				; Set color
	bsr	Print				; Print it.
	POP
	rts


PrintStatus:
	move.l	#0,d0
	move.l	#31,d1
	bsr	SetPos
	lea	StatusLine,a0
	move.l	#3,d1
	bsr	Print
	rts

UpdateStatus:
	move.l	#8,d0				; Print Serialspeed
	move.l	#31,d1
	bsr	SetPos
	clr.l	d0
	move.w	SerialSpeed-V(a6),d0		; Get SerialSpeed value
	mulu	#4,d0				; Multiply with 4
	lea	SerText,a0			; Load table of pointers to different texts
	move.l	(a0,d0.l),a0			; load a0 with the value that a0+d0 points to (text of speed)
	move.l	#7,d1
	bsr	Print

	move.l	#25,d0				; Print CPU type
	move.l	#31,d1
	bsr	SetPos

	move.l	CPUPointer-V(a6),a0
	move.l	#7,d1
	bsr	Print

;	move.l	CPUPointer-V(a6),a0
;	move.l	#2,d1
;	bsr	Print

	move.l	#40,d0				; Print Chipmem
	move.l	#31,d1
	bsr	SetPos
	move.l	TotalChip-V(a6),d0
	bsr	bindec
	move.l	#7,d1
	bsr	Print
	lea	KB,a0
	bsr	Print
	move.l	#57,d0
	move.l	#31,d1
	bsr	SetPos
	move.l	#7,d1
	move.l	TotalFast-V(a6),d0
	bsr	bindec
	bsr	Print
	move.l	#70,d0
	move.l	#31,d1
	bsr	SetPos
	move.l	a6,d0
		ifne	rommode
	sub.l	#Endstack-Variables+4,d0
		endc
	bsr	binhex
	move.l	#7,d1
	bsr	Print

	rts

