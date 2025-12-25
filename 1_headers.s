;APS0000002E0000002E000393A300039D5400039D5400039D5400039D5400039D5400039D5400039D54
;
; DiagROM by John "Chucky" Hertell
;

; A6 is ONLY to be used as a memorypointer to variables etc. so never SET a6 in the code.
; First some definitions.

; obscene words like "kuk" marks really bad code or temporary crap.. just look away.

VER:	MACRO
	dc.b "1"			; Versionnumber
	ENDM
REV:	MACRO
	dc.b "3"			; Revisionmumber
	ENDM

VERSION:	MACRO
	dc.b	"V"			; Generates versionstring.
	VER
	dc.b	"."
	REV
	ENDM

EDITION:	MACRO
;	dc.b	" - Revision Edition"
	ENDM

PUSH:	MACRO
	movem.l a0-a6/d0-d7,-(a7)	;Store all registers in the stack
	ENDM

POP:	MACRO
	movem.l (a7)+,a0-a6/d0-d7	;Restore the registers from the stack
	ENDM

TOGGLEPWRLED: MACRO
	bchg	#1,$bfe001
	ENDM
	
PAROUT: MACRO
	move.b	\1,$bfe101
	ENDM
	
VBLT:		MACRO
.vblt\@		btst	#14,$dff002
		bne.s	.vblt\@
		ENDM

STOPP:		MACRO
.halt\@
		move.b	$dff006,$dff181
		btst	#6,$bfe001
		bne.s	.halt\@
.endhalt\@
		btst	#6,$bfe001
		beq.s	.endhalt\@
		ENDM



rom_base:	equ $f80000		; Originate as if data is in ROM

; Then some different modes for the assembler

rommode =	1				; Set to 1 if to assemble as being in ROM
	ifnd a1k
a1k =		0				; Set to 1 if to assemble as for being used on A1000 (64k memrestriction)
	endc
debug = 	0				; Set to 1 to enable some debugshit in code
amiga = 	0 				; Set to 1 to create an amiga header to write the ROM to disk

	ifne rommode
	ifeq amiga
	;;  if we are spitting out a rom directly then we need to make sure
	;; vasm doesnt try to write out a section at the origin.
	;; this is a bit of a hack to make the 
	org rom_base
	endc
 	endc

	
	PRINTT
	PRINTT "Diagrom Assembling... Statistics: "
	PRINTT
	PRINTT Romsize:
	PRINTV EndRom-TheStart	
	PRINTT
	PRINTT Codesize:
	PRINTV EndCode-TheStart
	PRINTT Datasize:
	PRINTV EndRom-DataStart
	PRINTT
	PRINTT Variablespace:
	PRINTV C-V
	PRINTT
	PRINTT Workspace:
	PRINTV EndData-V	
	PRINTT
	PRINTT "Total Chipmem usage:"
	PRINTV EndData-Variables
	PRINTT
	PRINTT
	PRINTT "End of Code (aligned):"
	PRINTV ((EndRom-$f80000)+3)&(~$3)
	PRINTT
	PRINTT "Checksum area:"
	PRINTV Checksums-$f80000
	PRINTV EndChecksums-$f80000
	PRINTT
	PRINTT
	

LOWRESSize:	equ	40*256
HIRESSize:	equ	80*512
	ifne	rommode
						; If we are in ROM Mode and start.
						; just save the file to disk.
	ifne	amiga

	move.l	#IRQDATA-EndRom,a+(EndRom-TheStart)

	lea	2+a+(EndRom-TheStart),a2		; Get the first "unused" adress of rom
	move.l	#EndRom,d7
.AdrLoop:
	move.l	d7,(a2)+
	add.l	#4,d7
	cmp.l	#a+(IRQDATA-TheStart),a2
	blt.s	.AdrLoop			; Simply fill the rom with adressdata, so we have constants to test addresserors.
						; this way we can atleast handle some data we know shold be real.


					; First lets fix some checksums
	move.l	#Checksums-rom_base,d0
	lea	a,a0
	move.l	a0,a1
	add.l	d0,a1				; a1 should now point to where checksums starts in memory
	move.l	a1,d1				; Store startaddress of checksums in d1
	move.l	d1,d2
	add.l	#EndChecksums-Checksums,d2	; Store endaddress of checksums in d2
	
	clr.l	d3
	
	move.l	#7,d6

romcheckloop2:
	move.l	#0,d0				; Clear D0 that calculates the checksum
	move.l	#$3fff,d7
.romcheckloop:
	cmp.l	d1,a0
	bhi	.higher
	bra	.not
.higher:					; ok we are above checksums.
	cmp.l	d2,a0				; are we lower then end of checksums
	bhi	.not				; no. so we will do checksumcalculations
	add.l	#1,d3
	add.l	#4,a0
	bra	.nocalc
.not:

	add.l	(a0)+,d0
.nocalc:
	dbf	d7,.romcheckloop
.endromcheck:
	move.l	d0,(a1)+
	dbf	d6,romcheckloop2
.slut:						; Checksums is calculated and put into code.
SaveFile:
	lea	.filnamn,a5
	move.l	$4,a6
	lea	Dos,a1
	jsr	-408(a6)
	move.l	d0,a6
	move.l	a5,d1
	jsr	-72(a6)				; Delete file
	move.l	a5,d1
	move.l	#1006,d2
	jsr	-30(a6)
	beq	.Error
	move.l	d0,.Peekare
	move.l	d0,d1
	move.l	#a,d2
	move.l	#b-a,d3
	jsr	-48(a6)

	move.l	.Peekare,d1
	jsr	-36(a6)
	clr.l	d0
	rts

.Error:
	move.l	#-1,d0
	rts

.Peekare:
	dc.l	0
.filnamn:
	ifeq	a1k
		dc.b	"DiagROM",0
	else
		dc.b	"DiagROMA1k",0
	endc
Dos:
	dc.b	"dos.library",0

a: 	equ $45000000		; YES! this is as dirty as yesterdays underwear, but needed..  do not do this if you care about other running stuff.. OK?

		ifeq	a1k
b:	equ a+512*1024
		else
b:	equ a+64*1024
		endc

	endc			; end the amiga writer header.

	org rom_base		; Originate as if data is in ROM

	ifne	amiga           ; 
	load a			; PUT Data in where A points to, change this to a safe location for your machine.
	endc


START:

	PRINTT
	PRINTT "--------------------------------- ROMMMODE ENABLED ---------------------------------"
	PRINTT

	dc.w $1114		; this just have to be here for ROM. code starts at $2



	endc

; Lets start the code..  with a jump
TheStart:
	jmp	Begin
	dc.l	POSTBusError				; Hardcoded pointers
	dc.l	POSTAddressError			; if something is wrong rom starts at $0
	dc.l	POSTIllegalError			; so this will actually be pointers to
	dc.l	POSTDivByZero				; traps.
	dc.l	POSTChkInst
	dc.l	POSTTrapV
	dc.l	POSTPrivViol
	dc.l	POSTTrace
	dc.l	POSTUnimplInst

strstart:
	DC.B	"IHOL : :6U6U,A,B1U1U5767U,U,8181 1 0    "	; This string will make a readable text on each 32 bit
	DC.B	"HILO: : U6U6A,B,U1U17576,U,U18181 0     "	; rom what socket to use. (SOME programmingsoftware does byteshift so both orders)

	dc.b	"$VER: DiagROM Amiga Diagnostic by John Hertell. "
	dc.b	"www.diagrom.com "
	incbin	"BootDate.txt"
	dc.b	"- "
	VERSION
strstop:

	blk.b	166-(strstop-strstart),0		; Crapdata that needs to be here

	EVEN


