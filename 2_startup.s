Begin:	


	ifne	rommode

; Code in ROM mode

	clr.l	d0
	clr.l	d1
	clr.l	d2
	clr.l	d3
	clr.l	d4
	clr.l	d6
	clr.l	d7
;	lea	$0,a0	replace instructions here to make the rest of the ROM (mostly) line up
		move.l	d0,a0
		nop

	lea	$0,a1
	lea	$0,a2
	lea	$0,a3
	lea	$0,a4
	lea	$0,a5
	lea	$0,a6
	

	lea	$400,SP			; Set the stack. BUT!!! do not use it yet. we need to check chipmem first!

	move.b	#$ff,$bfe200
	move.b	#$ff,$bfe300



	move.b	#0,$bfe001			; Clear register.
	move.b	#$ff,$bfe301
	move.b	#$0,$bfe101
	move.b	#3,$bfe201	
	move.b	#0,$bfe001		; Powerled will go ON! so user can see that CPU works
	move.b	#$40,$bfed01
	move.w	#$f0f,$dff180
	move.w	#$ff00,$dff034
	move.w	#$0ff,$dff180
	move.b	#$ff,$bfd300
	or.b	#$f8,$bfd100
	nop
	and.b	#$87,$bfd100
	nop
	or.b	#$78,$bfd100

					; Lets check status of mousebuttons at start.  AAAND we have ONE register not used in
	move.l	#POSTBusError,$8
	move.l	#POSTAddressError,$c
	move.l	#POSTIllegalError,$10
	move.l	#POSTDivByZero,$14
	move.l	#POSTChkInst,$18
	move.l	#POSTTrapV,$1c
	move.l	#POSTPrivViol,$20
	move.l	#POSTTrace,$24
	move.l	#POSTUnimplInst,$28
	move.l	#POSTUnimplInst,$2c

					; all code.  A4.. so lets store the result therea
			
	move.b	#$88,$bfed01
	or.b	#$40,$bfee01		; For keyboard



	cmp.l	#"PPC!",d5		; Check if D5 is "PPC!" if so. we had been reset and should not reset again
	beq	wehadreset

	cmp.l	#" PPC",$f00092		; if the string " PPC" is located here, we have a CSPPC
	bne	nocsppc

	lea	2.w,a0
					; OK we got a CSPPC in the machine

	move.l	#5,d6
csloop:
	move.l	#$ffff,d7
	bchg	#1,$bfe001		; Some LED flashity!
	
csloop2:
	move.b	$bfe001,d0		; nonsense read from something slow.
	dbf	d7,csloop2
	dbf	d6,csloop

	move.l	#"PPC!",d5
	move.w	#$2700,SR
	nop				; Make sure next instruction is on a even longword
rst:	reset
	jmp	(a0)
wehadreset:

	move.b	#0,$bfe001		; Powerled will go ON! so user can see that CPU works




nocsppc:




					; Lets check status of mousebuttons at start.  AAAND we have ONE register not used in


	; some writes to check some logicanalyzer shit at start.  just ignore :)  so addresslines and datalines steps up one bit at a time at startup
	move.l	#%00000000000000000000000000000001,%00000000000000000000000000000000
	move.b	#1,$1	; bytewrite as it is at an odd address
	move.l	#%00000000000000000000000000000010,%00000000000000000000000000000010
	move.l	#%00000000000000000000000000000100,%00000000000000000000000000000100
	move.l	#%00000000000000000000000000001000,%00000000000000000000000000001000
	move.l	#%00000000000000000000000000010000,%00000000000000000000000000010000
	move.l	#%00000000000000000000000000100000,%00000000000000000000000000100000
	move.l	#%00000000000000000000000001000000,%00000000000000000000000001000000
	move.l	#%00000000000000000000000010000000,%00000000000000000000000010000000
	move.l	#%00000000000000000000000100000000,%00000000000000000000000100000000
	move.l	#%00000000000000000000001000000000,%00000000000000000000001000000000
	move.l	#%00000000000000000000010000000000,%00000000000000000000010000000000
	move.l	#%00000000000000000000100000000000,%00000000000000000000100000000000
	move.l	#%00000000000000000001000000000000,%00000000000000000001000000000000
	move.l	#%00000000000000000010000000000000,%00000000000000000010000000000000
	move.l	#%00000000000000000100000000000000,%00000000000000000100000000000000
	move.l	#%00000000000000001000000000000000,%00000000000000001000000000000000
	move.l	#%00000000000000010000000000000000,%00000000000000010000000000000000
	move.l	#%00000000000000100000000000000000,%00000000000000100000000000000000
	move.l	#%00000000000001000000000000000000,%00000000000001000000000000000000
	move.l	#%00000000000010000000000000000000,%00000000000010000000000000000000
	move.l	#%00000000000100000000000000000000,%00000000000100000000000000000000
	move.l	#%00000000001000000000000000000000,%00000000001000000000000000000000
	move.l	#%00000000010000000000000000000000,%00000000010000000000000000000000
	move.l	#%00000000100000000000000000000000,%00000000100000000000000000000000
	move.l	#%00000001000000000000000000000000,%00000001000000000000000000000000
	move.l	#%00000010000000000000000000000000,%00000010000000000000000000000000
	move.l	#%00000100000000000000000000000000,%00000100000000000000000000000000
	move.l	#%00001000000000000000000000000000,%00001000000000000000000000000000
	move.l	#%00010000000000000000000000000000,%00010000000000000000000000000000
	move.l	#%00100000000000000000000000000000,%00100000000000000000000000000000
	move.l	#%01000000000000000000000000000000,%01000000000000000000000000000000
	move.l	#%10000000000000000000000000000000,%10000000000000000000000000000000


	clr.l	d0					; all code.  A4.. so lets store the result therea
			

					; We will print the result on the serialport later.
					
	btst	#6,$bfe001		; Check LMB port 1
	bne	.NOP1LMB		; NOT pressed.. Skip to next
	bset	#0,d0
.NOP1LMB:
	btst	#7,$bfe001		; Check LMB port 2
	bne	.NOP2LMB
	bset	#1,d0
.NOP2LMB:
	btst	#10,$dff016		; Check RMB port 1
	bne	.NOP1RMB
	bset	#2,d0
.NOP1RMB:
	btst	#14,$dff016		; Check RMB port 2
	bne	.NOP2RMB
	bset	#3,d0
.NOP2RMB:
	btst	#8,$dff016		; Check MMB Port 1
	bne	.NOP1MMB
	bset	#4,d0			; MMB Port 1
.NOP1MMB:
	btst	#12,$dff016		; Check MMB Port 2
	bne.s	.NOP2MMB
	bset	#5,d0			; MMB Port 2
.NOP2MMB:



	move.l	d0,a4			; OK Store the result in a4 (YEAH I know it is not used for data.. but  no mem.. and only register not used)




	move.l	#0,d0			; Make sure D0 is cleared.
	
	lea	AnsiNull,a0		; Clear screen, clear ansi attributes, set default color
	lea	.jmp0,a1
	bra	DumpSerial		; Dump to serial, after it jump to where a1 points at.
.jmp0:




	lea	InitSerial,a0
	lea	.jmp1,a1
	bra	DumpSerial		; Dump to serial, after it jump to where a1 points at.
.jmp1:

	PAROUT #$ff			; Send #$ff to Paralellport.
	lea	parfftxt,a0		; And explaining simliar text to serialport.
	lea	.jmp2,a1
	bra	DumpSerial
.jmp2:



	lea	RomAdrtest,a0
	lea	.romadr,a1
	bra	DumpSerial
	
.romadr:

	lea	EndRom,a5		; Lets scan trough the "unused" part of the ROM. every longword have its address written to it
	move.l	EndRom2,d4		; so let the machine look through those addresses to see if it is correct.

.AdrTest:
	move.l	a5,a6

	
	move.l	(a5),d0			; load d0 with what was in the address
	move.l	a6,a5

	cmp.l	a5,d0			; was is it the correct data?
	beq	.ok


	move.l	a4,d1
	bset	#10,d1			; Set bit 10.. we had an addresserror
	swap	d1
	add.w	#1,d1
	cmp.w	#50,d1
	bgt	.adrtoomany
	swap	d1
	move.l	d1,a4

	lea	RomAdrErr,a0
	lea	.romadr2,a1
	bra	DumpSerial

.romadr2:
	move.b	$dff006,$dff180
	TOGGLEPWRLED

	move.l	a5,d1
	lea	.aab,a2
	bra	DumpHexLong
.aab:

	lea	.afterspace,a1
	move.l	#" ",d1
	bra	DumpSerialCharacter
.afterspace:

	move.l	a5,d1
	lea	.afterbin,a3
	bra	DumpBinSerial
.afterbin:
	lea	SpacesTxt,a0
	lea	.afterspace2,a1
	bra	DumpSerial
.afterspace2:
	move.l	(a5),d1
	lea	.aab2,a2
	bra	DumpHexLong
.aab2:

.ok:
	add.l	#8,a5
	move.l	#EndRom2,d4
	cmp.l	a5,d4
	bge	.AdrTest
	bra	.adrdoneok
	
.adrtoomany:
	swap	d1
	move.l	d1,a4
.adrtoomany2:
	lea	RomAdrErrors,a0
	lea	.adrdone,a1
	bra	DumpSerial

.adrdoneok:
	move.l	a4,d1
	btst	#10,d1			; did we have an addresserror
	bne	.adrtoomany2

	lea	SPACEOK,a0
	lea	.adrdone,a1
	bra	DumpSerial

.adrdone:

	move.w	#$afa,$dff180


	move.l	#-1,d0			; ok we have went through that .. lets set all unused registers to -1 again to keep track of em
	move.l	#-1,d1
	move.l	#-1,d2
	move.l	#-1,d3
	move.l	#-1,d4
	move.l	#-1,d5
	move.l	#-1,d6
	move.l	#-1,d7
	lea	$ffffffff,a0
	lea	$ffffffff,a1
	lea	$ffffffff,a2
	lea	$ffffffff,a3
	lea	$ffffffff,a5
	lea	$ffffffff,a6
	lea	$ffffffff,a7		; As we have no memory.. we can actually use the A7 register to save data! WIN!!







	lea	.cleardone,a0
	bra	DumpClearSerial
.cleardone:


	lea	LoopSerTest,a0
	lea	.loopdone,a1
	bra	DumpSerial
.loopdone:
	move.w	#$4000,$dff09a
	move.w	#373,$dff032			; Set the speed of the serialport (9600BPS)
	move.b	#$4f,$bfd000			; Set DTR high
	move.w	#$0801,$dff09a
	move.w	#$0801,$dff09c

	TOGGLEPWRLED


	clr.l	d6			; Clear D6, if this is anything else than 0 efter loopbacktest, we had an echo (adapter)
	
	move.l	#"<",d2

	lea	.looptst1,a0
	jmp	Loopbacktest
.looptst1:


	move.w	#$777,$dff180		; Set screen to medium grey
	TOGGLEPWRLED
	move.l	#">",d2
	lea	.looptst2,a0
	jmp	Loopbacktest
.looptst2:
	move.w	#$555,$dff180		; Set screen to dark grey
	TOGGLEPWRLED
	cmp.b	#0,d6
	beq	.noadapter


	lea	DDETECTED,a0
	lea	.loopdetect,a1
	bra	DumpSerial
.loopdetect:


					; ok we had detected a loopback, lets mark it in our "secret" register (in A4 now) by setting bit 4
	move.l	a4,d0
	bset	#9,d0			; Set that loopbackadapter was detected
	bset	#7,d0			; Also set that no serial output wanted
	move.l	d0,a4			; ok we have restored it in A4 now.

	bra	.goon

.noadapter:
	lea	NoLoopback,a0
	lea	.nodetect,a1
	bra	DumpSerial
.nodetect:


.goon:

	move.l	a4,$4


	lea	Initmousetxt,a0
	lea	.jmp3,a1
	bra	DumpSerial
.jmp3:
	move.l	a4,d0
	btst	#0,d0
	beq	.noP1LMB
	lea	InitP1LMBtxt,a0
	lea	.noP1LMB,a1
	bra	DumpSerial
.noP1LMB:
	btst	#1,d0
	beq	.noP2LMB
	lea	InitP2LMBtxt,a0
	lea	.noP2LMB,a1
	bra	DumpSerial
.noP2LMB:
	btst	#2,d0
	beq	.noP1RMB
	lea	InitP1RMBtxt,a0
	lea	.noP1RMB,a1
	bra	DumpSerial
.noP1RMB:
	btst	#3,d0
	beq	.noP2RMB
	lea	InitP2RMBtxt,a0
	lea	.noP2RMB,a1
	bra	DumpSerial
.noP2RMB:
	btst	#4,d0
	beq	.noP1MMB
	lea	InitP1MMBtxt,a0
	lea	.noP1MMB,a1
	bra	DumpSerial
.noP1MMB:
	btst	#5,d0
	beq	.noP2MMB
	lea	InitP2MMBtxt,a0
	lea	.noP2MMB,a1
	bra	DumpSerial
.noP2MMB:

	lea	NewLineTxt,a0
	lea	.mousedone,a1
	bra	DumpSerial
		
.mousedone:
	lea	InitINTENAtxt,a0
	lea	.jmp4,a1
	bra	DumpSerial
.jmp4:	
	move.w	#$7fff,$dff09a		; Disable all INTENA

	lea	InitDONEtxt,a0
	lea	.jmp5,a1
	bra	DumpSerial
.jmp5:
	lea	InitINTREQtxt,a0
	lea	.jmp6,a1
	bra	DumpSerial
.jmp6:
	move.w	#$7fff,$dff09c		; Disable all INTREQ

	lea	InitDONEtxt,a0
	lea	.jmp7,a1
	bra	DumpSerial
.jmp7:

	lea	InitDMACONtxt,a0
	lea	.jmp8,a1
	bra	DumpSerial
.jmp8:
	move.w	#$7fff,$dff096		; Disable all DMACON

	lea	InitDONEtxt,a0
	lea	.jmp9,a1
	bra	DumpSerial
.jmp9:


	move.w	#$200,$dff100
	move.w	#0,$dff110

						; next part will hopefully go so fast so the user will not release the button
						; so we can force data to fastmem if any.

;	Now lets check for some memory, the only thing we KNOW exists on all machines is Chipmem.
;	so this will only really rely on Chipmem.  but does it work?  anyway. NO stack is allowed at this
;	point, meaning NO Stack, no subroutines only registers A0-A7 and D0-D7 and no memory.


	lea	OvlTestTxt,a0
	lea	.ovlprt,a1
	bra	DumpSerial
.ovlprt:
	btst	#0,$bfe001
	bne	.noovl
	lea	SOK,a0
	lea	.ovldone,a1
	bra	DumpSerial


.noovl:						; OK OVL test failed. that means by misstake "stuck" LMB1 and LMB2 is false.
	move.l	a4,d0
	bclr	#0,d0				; Clear LMB1
	bclr	#1,d0				; Clear LMB2
	bset	#8,d0				; Set bit 8 as OVL ERROR
	move.l	d0,a4				; store it back to a4
	lea	SFAILED,a0
	lea	.ovldone,a1
	bra	DumpSerial

.ovldone:
	lea	NewLineTxt,a0
	lea	.ovlover,a1
	bra	DumpSerial
.ovlover:







	PAROUT	#$fe			; Send #$fe to Paralellport.
	lea	parfetxt,a0			; And explaining simliar text to serialport.
	lea	.ldsuds1,a1
	bra	DumpSerial

.ldsuds1:
						; Time to detect some chipmem



	lea	writeffff,a0			; labels have ff.. that was a bad value. actual value will be aa
	lea	.ldsuds2,a1
	bra	DumpSerial
.ldsuds2:
	move.w	#$aaaa,d1
	move.w	d1,$400
	move.l	#$ffffffff,$3fc
	nop
	move.w	$400,d0
	move.w	$400,d0
	move.w	$400,d0
	move.w	$400,d0
	move.w	$400,d0
	cmp.w	d0,d1
	bne.s	.ldsuds2fail
	lea	SOK,a0
	lea	.ldsuds3,a1
	bra	DumpSerial
.ldsuds2fail:
	lea	SFAILED,a0
	lea	.ldsuds3,a1
	bra	DumpSerial
.ldsuds3:
	lea	NewLineTxt,a0
	lea	.ldsuds3nl,a1
	bra	DumpSerial
.ldsuds3nl:
	
	lea	write00ff,a0
	lea	.ldsuds4,a1
	bra	DumpSerial
.ldsuds4:
	move.w	#$00aa,d1
	move.w	d1,$400
	move.l	#$ffffffff,$3fc
	nop
	move.w	$400,d0
	move.w	$400,d0
	move.w	$400,d0
	move.w	$400,d0
	move.w	$400,d0
	cmp.w	d0,d1
	bne.s	.ldsuds4fail
	lea	SOK,a0
	lea	.ldsuds5,a1
	bra	DumpSerial
.ldsuds4fail:
	lea	SFAILED,a0
	lea	.ldsuds5,a1
	bra	DumpSerial
.ldsuds5:
	lea	NewLineTxt,a0
	lea	.ldsuds5nl,a1
	bra	DumpSerial
.ldsuds5nl:
	

	lea	writeff00,a0
	lea	.ldsuds6,a1
	bra	DumpSerial
.ldsuds6:
	move.w	#$aa00,d1
	move.w	d1,$400
	move.l	#$ffffffff,$3fc
	nop
	move.w	$400,d0
	move.w	$400,d0
	move.w	$400,d0
	move.w	$400,d0
	move.w	$400,d0
	cmp.w	d0,d1
	bne.s	.ldsuds6fail
	lea	SOK,a0
	lea	.ldsuds7,a1
	bra	DumpSerial
.ldsuds6fail:
	lea	SFAILED,a0
	lea	.ldsuds7,a1
	bra	DumpSerial
.ldsuds7:
	lea	NewLineTxt,a0
	lea	.ldsuds7nl,a1
	bra	DumpSerial
.ldsuds7nl:

	lea	write0000,a0
	lea	.ldsuds8,a1
	bra	DumpSerial
.ldsuds8:
	move.w	#$0000,d1
	move.w	d1,$400
	move.l	#$ffffffff,$3fc

	nop
	move.w	$400,d0
	move.w	$400,d0
	move.w	$400,d0
	move.w	$400,d0
	move.w	$400,d0
	cmp.w	d0,d1
	bne.s	.ldsuds8fail
	lea	SOK,a0
	lea	.ldsuds9,a1
	bra	DumpSerial
.ldsuds8fail:
	lea	SFAILED,a0
	lea	.ldsuds9,a1
	bra	DumpSerial
.ldsuds9:
	lea	NewLineTxt,a0
	lea	.ldsuds9nl,a1
	bra	DumpSerial
.ldsuds9nl:
	lea	writebeven,a0
	lea	.ldsuds10,a1
	bra	DumpSerial
.ldsuds10:
	move.w	#$0,d0
	move.w	d0,$400
	move.b	#$aa,d1
	move.b	d1,$400
	move.l	#$ffffffff,$3fc
	move.w	#$aa00,d1
	nop
	move.w	$400,d0
	move.w	$400,d0
	move.w	$400,d0
	move.w	$400,d0
	move.w	$400,d0
	cmp.b	d0,d1
	bne	.ldsuds10fail
	lea	SOK,a0
	lea	.ldsuds11,a1
	bra	DumpSerial
.ldsuds10fail:
	lea	SFAILED,a0
	lea	.ldsuds11,a1
	bra	DumpSerial
.ldsuds11:
	lea	NewLineTxt,a0
	lea	.ldsuds11nl,a1
	bra	DumpSerial
.ldsuds11nl:
	lea	writebodd,a0
	lea	.ldsuds12,a1
	bra	DumpSerial
.ldsuds12:
	move.w	#$0,d0
	move.w	d0,$400
	move.b	#$aa,d1
	move.b	d1,$401
	move.l	#$ffffffff,$3fc
	move.w	#$00aa,d1
	nop
	move.w	$400,d0
	move.w	$400,d0
	move.w	$400,d0
	move.w	$400,d0
	move.w	$400,d0
	cmp.b	d0,d1
	bne	.ldsuds12fail
	lea	SOK,a0
	lea	.ldsuds13,a1
	bra	DumpSerial
.ldsuds12fail:
	lea	SFAILED,a0
	lea	.ldsuds13,a1
	bra	DumpSerial
.ldsuds13:

	lea	NewLineTxt,a0
	lea	.ldsuds13nl,a1
	bra	DumpSerial
.ldsuds13nl:


	PAROUT	#$fd				; Send #$fe to Paralellport.
	lea	parfdtxt,a0			; And explaining simliar text to serialport.
	lea	.jmp10,a1
	bra	DumpSerial


.jmp10:





;---------------------------------------------------------------------------------------------------------------------------------
;---------------------------------------------------------------------------------------------------------------------------------
;---------------------------------------------------------------------------------------------------------------------------------
;---------------------------------------------------------------------------------------------------------------------------------
;---------------------------------------------------------------------------------------------------------------------------------
;---------------------------------------------------------------------------------------------------------------------------------
;---------------------------------------------------------------------------------------------------------------------------------
; Chipmemtest starts here

	move.l	#-1,d0			; ok we have went through that .. lets set all unused registers to -1 again to keep track of em
	move.l	#-1,d1			; so this IS actually kinda pointless and more for debugging..  ignore this..
	move.l	#-1,d2
	move.l	#-1,d3
	move.l	#-1,d4
	move.l	#-1,d5
	move.l	#-1,d6
	move.l	#-1,d7
	lea	$ffffffff,a0
	lea	$ffffffff,a1
	lea	$ffffffff,a2
	lea	$ffffffff,a3
	lea	$ffffffff,a5
	lea	$ffffffff,a6
	lea	$ffffffff,a7		; As we have no memory.. we can actually use the A7 register to save data! WIN!!



POSTDetectChipmem:





.tstnomore:


	lea	$400,a6				; Lets scan memory, start at $400


	move.l	#$33333333,(a6)			; Write a number that is NOT in the memcheck table. for shadowcheck
	clr.l	d0			
	clr.l	d3				; if d3 is not null, it contains first memaddr found
	
	lea	NewLineTxt,a0
	lea	.nldone,a1
	bra	DumpSerial
		
.nldone:


.detectloop:
	move.l	(a6),d5				; Do a backup of content
	lea	MEMCheckPattern,a5		; Load list of data to test
	bclr	#31,d0

	move.l	a6,d1
	asr.l	#8,d1
	move.w	#$0f0,$dff180

	TOGGLEPWRLED
	lea	AddrTxt,a0			; Prints text "Addr $"
	lea	.addrdone,a1
	bra	DumpSerial
.addrdone:

	move.l	a6,d1
	lea	.addrout,a2
	bra	DumpHexLong
.addrout:


.memloop:



	move.l	(a5),(a6)			; Write data to memory
	move.l	#$ffffffff,$3fc			; INTERESTING FIX!  if an A4000 with no chipmem.  if I write to chipmem and read from chipmem.
						; INDEPENDENT of what address, I will read the last thing that was written on the bus.
						; so by writing this here. if no chipmem is present. read will get all 1, as it would on ANY other Amiga!
	move.l	(a5),d1

	move.b	$bfe001,d4
	move.l	(a6),d4				; Read data from memory
	move.l	(a6),d4				; Read data from memory
	move.l	(a6),d4				; Read data from memory
	move.l	(a6),d4				; Read data from memory
	move.l	(a6),d4				; Read data from memory
	move.l	(a6),d4				; Read data from memory
	move.l	(a6),d4				; Read data from memory (read several times.. this will make sure it is real data)
	cmp.l	(a5),d4				; Check if written data is the same as the read data.
	beq	.ok				; YES it is OK

	cmp.l	#0,d3				; Check if d3 is 0, in that case we havent found any memory
						; and user might want to see whats wrong. if we had. we are simply out of mem
	bne	.faildone

	cmp.l	#$80400,a6
	beq	.divider
	cmp.l	#$100400,a6
	beq	.divider
	cmp.l	#$180400,a6
	beq	.divider
	bra	.nodivider
.divider:
	swap	d0
	cmp.b	#1,d0
	beq	.norow					; if d0 (higher word) is 1 we already printed a divider this time

	move.b	#1,d0
	lea	Divider2Txt,a0				; Prints text "Write:"
	lea	.norow,a1
	bra	DumpSerial

.norow
	swap	d0
	bra	.nocleard0
.nodivider:
	swap	d0
	clr.w	d0
	swap	d0					; just make sure upper word of d0 is clear
.nocleard0:


	lea	WTxt,a0				; Prints text "Write:"
	lea	.wtxtdone,a1
	bra	DumpSerial
.wtxtdone:
	move.l	a6,d1				; Print address to check

	move.l	(a5),d1
	lea	.wbindone,a2
	bra	DumpHexLong
.wbindone:


	;-------------  binary to serial

	lea	SpacesTxt,a0				; Prints text "Write:"
	lea	.tststart,a1
	bra	DumpSerial
.tststart:
	lea	.tstlmb,a3




	move.l	(a5),d1
	move.l	d2,a0
	move.l	d3,a1
	move.l	d4,a2
	move.l	d7,a3
	move.l	#31,d3
.tstloop:
	clr.l	d7
	btst	d3,d1
	beq	.tstzero
	move.b	#"1",d7
	bra	.tstout
.tstzero:
	move.b	#"0",d7
.tstout:

	move.w	#$4000,$dff09a
	move.w	#373,$dff032			; Set the speed of the serialport (9600BPS)
	move.b	#$4f,$bfd000			; Set DTR high
	move.w	#$0801,$dff09a
	move.w	#$0801,$dff09c
	move.l	#40000,d2			; Load d2 with a timeoutvariable. only test this number of times.
						; IF CIA for serialport is dead we will not end up in a wait-forever-loop.
						; and as we cannot use timers. we have to do this dirty style of coding...
.tsttimeoutloop:	
	move.b	$bfe001,d4			; just read crapdata, we do not care but reading from CIA is slow... for timeout stuff only
	sub.l	#1,d2				; count down timeout value
	cmp.l	#0,d2				; if 0, timeout.
	beq	.tstendloop
	move.w	$dff018,d4
	btst	#13,d4				; Check TBE bit
	beq.s	.tsttimeoutloop
.tstendloop:
	move.w	#$0100,d4
	move.b	d7,d4
	move.w	d4,$dff030			; send it to serial
	move.w	#$0001,$dff09c			; turn off the TBE bit
	dbf	d3,.tstloop
	move.l	a0,d2
	move.l	a1,d3
	move.l	a2,d4
	move.l	a3,d7
.tstlmb:
	;-------------  end of binary to serial


	lea	RTxt,a0				; Prints text "Read:"
	lea	.rtxtdone,a1
	bra	DumpSerial
.rtxtdone:

	move.l	d4,d1
	lea	.rbindone,a2
	bra	DumpHexLong
.rbindone:

	;-------------  binary to serial
	lea	SpacesTxt,a0				; Prints text "Write:"
	lea	.tststart1,a1
	bra	DumpSerial
.tststart1:
;	btst	#6,$bfe001
;	beq	.tstlmb1

	move.l	d4,d1

	move.l	d2,a0
	move.l	d3,a1
	move.l	d4,a2
	move.l	d7,a3
	move.l	(a5),d2				; D2 now also contain the longword we want to compare against



	move.l	#31,d3

.tstloop1:
	move.b	#27,d7
	lea	.aa1,a7
	bra	DumpSerialChar2
.aa1:
	move.b	#"[",d7
	lea	.aa2,a7
	bra	DumpSerialChar2
.aa2:
	move.b	#"3",d7
	lea	.aa3,a7
	bra	DumpSerialChar2
.aa3:


	clr.l	d7

	btst	d3,d2				; check what value it was for the written data
	beq	.waszero
	move.b	#1,d7				; set d7 to 1 as it was 1
	bra	.wasone
.waszero:

	move.b	#0,d7				; set d7 to 0 as it was 0
.wasone:
	btst	d3,d1
	beq	.tstzero1

	cmp.b	#1,d7				; check if it was 1 written if not.. make sure it written in red, other green
	bne	.not1



	move.b	#"2",d7					; 1 red    2 green
	lea	.aa4,a7
	bra	DumpSerialChar2
.aa4:
	move.b	#"m",d7
	lea	.wasnt1,a7
	bra	DumpSerialChar2

.not1:

	move.b	#"1",d7					; 1 red    2 green
	lea	.aa6,a7
	bra	DumpSerialChar2
.aa6:
	move.b	#"m",d7
	lea	.wasnt1,a7
	bra	DumpSerialChar2

.wasnt1:

	move.l	#"1",d7
	bra	.tstout1
.tstzero1:
	cmp.b	#0,d7
	bne	.not00

	move.b	#"2",d7					; 1 red    2 green
	lea	.aa8,a7
	bra	DumpSerialChar2
.aa8:
	move.b	#"m",d7
	lea	.aa9,a7
	bra	DumpSerialChar2
.aa9:
	bra	.not0


.not00:

	move.b	#"1",d7					; 1 red    2 green
	lea	.aa10,a7
	bra	DumpSerialChar2
.aa10:
	move.b	#"m",d7
	lea	.aa11,a7
	bra	DumpSerialChar2
.aa11:


.not0:
	move.l	#"0",d7





.tstout1:

	lea	.Numberprinted,a7
	bra	DumpSerialChar2
.Numberprinted:

	dbf	d3,.tstloop1


	move.l	a0,d2
	move.l	a1,d3
	move.l	a2,d4
	move.l	a3,d7


.tstlmb1:
	;-------------  end of binary to serial



	lea	SPACEFAIL,a0			; Prints "FAILED"
	lea	.faildone,a1
	bra	DumpSerial
.faildone:
	bset	#31,d0				; set bit 31 in d0 to tell we had an error
	move.w	#$f00,$dff180
.ok:
	cmp.l	#$400,a6
	beq	.yes400				; if we are checking address 400, skip this
	move.l	$400,d4
	bra	.shadow				; ok, we are not checking address 400, BUT we had same data there. meaning
						; we have a shadow. so exit

.yes400:
	cmp.l	#0,(a5)+			; Was last longword tested null? if not, repeat
	bne	.memloop



	btst	#31,d0
	bne	.fail				; did we have failed memory


	cmp.l	#0,d3				; check if this is the first block of good memory
	bne	.notfirst
	move.l	a6,d3				; Store that this was the first sucessful memory

.notfirst:
	move.w	#$0,$dff180
	add.w	#1,d0				; Add 1 to mark a sucessful block
	lea	SPACEOK,a0			; Print "OK"
	lea	.okdone,a1
	bra	DumpSerial
.okdone:
	lea	Txt64KBlock,a0			; Print string of number of blocks
	lea	.blkdone,a1
	bra	DumpSerial
.blkdone:
	move.l	d0,d1
	lea	.longdone,a2
	bra	DumpHexByte			; Print out number of OK blocks.

.fail:						; We had a failure


	cmp.l	#0,d3				; Check if d3 is 0, in that case we havent found any memory yet
	beq	.longdone
						; ok we had memory, so this is the endblock.
	bra	.finished			; lets stop all check. we have found it all.

.longdone:
	move.l	d5,(a6)				; Restore backupped data

	add.l	#65536,a6			; Add 64k to a6
	cmp.l	#$200000,a6			; have we scanned more then 2MB of data, exit
	bhi	.finished
	bra	.detectloop			; Do one more turn.

.shadow:
	move.l	#"SHDW",(a6)			; to test that we REALLY have a shadowram. write a string
	move.l	#$ffffffff,$3fc
	nop
	nop
	move.l	$400,d7	
	move.l	$400,d7	
	move.l	$400,d7	
	move.l	$400,d7				; Read several times.. just to make sure random reads is true random
	cmp.l	#"SHDW",d7			; and check it at $400,  if it is there aswell SHADOW
	bne	.yes400				; go on checking ram. we did not have shadow
	lea	ShadowChiptxt,a0
	lea	.finished,a1
	bra	DumpSerial

.finished:
	bclr	#31,d0				; Clear "the errorbit"
	cmp.l	#0,d0				; check if we had no chipmem
	beq	.nochipatall



	move.w	#$0,$dff180			; Set backgroundcolor to black

	lea	StartAddrTxt,a0
	lea	.startaddrdone,a1
	bra	DumpSerial
.startaddrdone:
	move.l	d3,a7				; Store start of chipmem to a7
	move.l	d3,d1
	lea	.startdone,a2
	bra	DumpHexLong
.startdone:

	lea	EndAddrTxt,a0
	lea	.endaddrdone,a1
	bra	DumpSerial
.endaddrdone:
	sub.l	#$400,a6
	move.l	a6,d1
	sub.l	#1,d1
	lea	.enddone,a2
	bra	DumpHexLong
.enddone:
	lea	NewLineTxt,a0
	lea	.nl,a1
	bra	DumpSerial


.nochipatall:
	lea	NoChiptxt,a0
	lea	.nl,a1
	bra	DumpSerial

.nl:

					; At EXIT registers that are interesting:
					; D0 = Number of usable 64Kb blocks
					; D3 = First usable address
					; A6 = Last usable address


					; A3 not used yet
					

	swap 	d0
	clr.w	d0			; make sure upper word is 0
	swap	d0

Chipmemadrcheck:
	cmp.w	#0,d0			; check if d0 is 0. we had no chipmem, skip test
	beq	.adrdone


	lea	RamAdrTest,a0
	lea	.ramadr,a1
	bra	DumpSerial
.ramadr
	lea	RamAdrFill,a0
	lea	.ramfill,a1
	bra	DumpSerial
.ramfill:

	move.l	a6,a3
	move.l	d3,a0
	clr.l	d1
.fillloop:
	add.l	#1,d1
	cmp.l	#4096,d1
	bne	.nodot
	move.l	a0,d5
	TOGGLEPWRLED
	lea	DotTxt,a0
	lea	.DotDone,a1
	bra	DumpSerial
.DotDone:
	move.l	d5,a0
	clr.l	d1
.nodot:
	move.l	a3,(a3)
	sub.l	#4,a3
	move.l	a3,(a3)
	sub.l	#4,a3
	move.l	a3,(a3)
	sub.l	#4,a3
	move.l	a3,(a3)
	sub.l	#4,a3
	move.w	$dff006,$dff180
	cmp.l	a0,a3
	bge	.fillloop		; Memory is filled with every longword containing its address.


	move.w	#$fff,$dff180

	lea	RamAdrComp,a0
	lea	.ramcomp,a1
	bra	DumpSerial
.ramcomp:


	move.l	#-2,d1
	move.l	#-2,d2
	move.l	#-2,d4
	move.l	#-2,d5
;	move.l	#-2,d6
	move.l	#-2,d7
	lea	-2,a0
	lea	-2,a1
	lea	-2,a2
;	lea	-2,a3
	lea	-2,a5
	lea	-2,a7			; ok clear "unused" registers that can be scrapped now.  only for debugging..



	move.l	d3,a5
	move.l	a6,d4
	clr.l	d2

.AdrTest:
	cmp.l	#16384,d2
	bne	.nodot2
	TOGGLEPWRLED
	lea	DotTxt,a0
	lea	.DotDone2,a1
	bra	DumpSerial
.DotDone2:
	clr.l	d2
.nodot2:
	add.l	#1,d2
	move.l	a5,a6

	move.l	(a5),d5			; load d5 with what was in the address
	move.l	a6,a5


	cmp.l	a5,d5			; was is it the correct data?
	beq	.ok2

	swap	d0			; Swap words on d0
	cmp.w	#1,d0			; does high contain 1, then we had an error before
	beq	.newerror
	swap	d0

	swap	d0
	move.w	#1,d0			; Set that we had an error
	move.l	a5,a7			; Save address into a7 where first error occured

.newerror:
	swap	d0


	move.l	a4,d1
	bset	#11,d1			; Set bit 11.. we had an addresserror
	swap	d1
	add.w	#1,d1
	cmp.w	#40,d1
	bgt	.adrtoomany
	swap	d1
	move.l	d1,a4


	lea	RomAdrErr,a0
	lea	.romadr2,a1
	bra	DumpSerial

.romadr2:


	move.b	$dff006,$dff180
	TOGGLEPWRLED

	move.l	a5,d1
	lea	.aab,a2
	bra	DumpHexLong
.aab:

	lea	.afterspace,a1
	move.l	#" ",d1
	bra	DumpSerialCharacter
.afterspace:

	move.l	a5,d1
	lea	.ok,a3
	bra	DumpBinSerial
.ok:


	lea	SpacesTxt,a0
	lea	.afterspace2,a1
	bra	DumpSerial
.afterspace2:
	move.l	(a5),d1
	lea	.aab2,a2
	bra	DumpHexLong
.aab2:
.ok2:

	move.b	(a5),$dff180
	move.b	$dff007,$dff181
	add.l	#4,a5
	cmp.l	a5,d4
	bgt	.AdrTest
	bra	.adrdoneok
	
.adrtoomany:
	swap	d1
	move.l	d1,a4
.adrtoomany2:

	swap	d0
	cmp.w	#1,d0
	beq	.adrerr
	swap	d0
	bra	.noadrerr
.adrerr:
	clr.w	d0
	swap	d0
	sub.l	#$400,a7
	move.l	a7,d1
	divu	#1024,d1	; get number of kilobytes
	divu	#63,d1		; and as chipmem detectroutine returns number of 64Kb blocks.. lets do that
	move.l	a7,a6

	move.w	d1,d0

	cmp.w	#3,d0
	blt	.noadrerr

	lea	ChipReducedErrors,a0
	lea	.chipreduced,a1
	bra	DumpSerial
.chipreduced:

	move.l	d0,d1
	lea	.chipreduced2,a2
	bra	DumpHexByte			; Print out number of OK blocks.
.chipreduced2:

	lea	ChipReducedErrors2,a0
	lea	.adrdone,a1
	bra	DumpSerial


.noadrerr:
	clr.l	d0
	lea	RamAdrErrors,a0
	lea	.adrdone,a1
	bra	DumpSerial

.adrdoneok:

	move.l	a4,d1
	bset	#11,d1			; Set bit 11.. we had an addresserror
	bne	.chipfail

	lea	CHIPOK,a0
	lea	.adrdone,a1
	bra	DumpSerial
.chipfail:
	lea	SPACEFAIL,a0
	lea	.adrdone,a1
	bra	DumpSerial
.adrdone:
	move.w	#$afa,$dff180


;---------------------------------------------------------------------------------------------------------------------------------------------
;---------------------------------------------------------------------------------------------------------------------------------------------
;---------------------------------------------------------------------------------------------------------------------------------------------
;---------------------------------------------------------------------------------------------------------------------------------------------
;---------------------------------------------------------------------------------------------------------------------------------------------
;---------------------------------------------------------------------------------------------------------------------------------------------
;---------------------------------------------------------------------------------------------------------------------------------------------
;---------------------------------------------------------------------------------------------------------------------------------------------


	move.l	d3,a3			; Store start of chipmem in A3 temporary

	move.l	d4,a2



	move.l	a4,d6			; Copy A4 Startupregister to D6 so we can compare
	lea	Initmousetxt2,a0
	lea	.mousedone,a1
	bra	DumpSerial
.mousedone:

	btst	#6,$bfe001		; Check LMB port 1
	bne	.NOP1LMB		; NOT pressed.. Skip to next
	bset	#0,d4
.NOP1LMB:
	btst	#7,$bfe001		; Check LMB port 2
	bne	.NOP2LMB
	bset	#1,d4
.NOP2LMB:
	btst	#10,$dff016		; Check RMB port 1
	bne	.NOP1RMB
	bset	#2,d4
.NOP1RMB:
	btst	#14,$dff016		; Check RMB port 2
	bne	.NOP2RMB
	bset	#3,d4
.NOP2RMB:
	btst	#8,$dff016		; Check MMB Port 1
	bne	.NOP1MMB
	bset	#4,d4			; MMB Port 1
.NOP1MMB:
	btst	#12,$dff016		; Check MMB Port 2
	bne.s	.NOP2MMB
	bset	#5,d4			; MMB Port 2
.NOP2MMB:


	move.l	a4,d6			; Copy startupregister to D6 so we can process it

	btst	#0,d4
	beq	.noP1LMB
	btst	#0,d6
	beq	.GoGreen
.GoRed:
	bclr	#0,d4
	lea	RedTxt,a0
	lea	.Pressed,a1
	bra	DumpSerial
.GoGreen
	lea	GreenTxt,a0
	lea	.Pressed,a1
	bra	DumpSerial
.GoYellow:
	bclr	#0,d6			; Lets clear bit from startup, it is not stuck
	bset	#0,d4
	lea	YellowTxt,a0
	lea	.Pressed,a1
	bra	DumpSerial
.Pressed:
	lea	InitP1LMBtxt,a0
	lea	ChkP2LMB,a1
	bra	DumpSerial
.noP1LMB:
	btst	#0,d6
	bne	.GoYellow
	



ChkP2LMB:
	btst	#1,d4
	beq	.noP2LMB
	btst	#1,d6
	beq	.GoGreen
.GoRed:
	bclr	#1,d4
	lea	RedTxt,a0
	lea	.Pressed,a1
	bra	DumpSerial
.GoGreen
	lea	GreenTxt,a0
	lea	.Pressed,a1
	bra	DumpSerial
.GoYellow:
	bclr	#1,d6			; Lets clear bit from startup, it is not stuck
	bset	#1,d4
	lea	YellowTxt,a0
	lea	.Pressed,a1
	bra	DumpSerial
.Pressed:
	lea	InitP2LMBtxt,a0
	lea	ChkP1RMB,a1
	bra	DumpSerial
.noP2LMB:
	btst	#1,d6
	bne	.GoYellow




ChkP1RMB:
	btst	#2,d4
	beq	.noP1RMB
	btst	#2,d6
	beq	.GoGreen
.GoRed:
	bclr	#2,d4
	lea	RedTxt,a0
	lea	.Pressed,a1
	bra	DumpSerial
.GoGreen
	lea	GreenTxt,a0
	lea	.Pressed,a1
	bra	DumpSerial
.GoYellow:
	bclr	#2,d6			; Lets clear bit from startup, it is not stuck
	bset	#2,d4
	lea	YellowTxt,a0
	lea	.Pressed,a1
	bra	DumpSerial
.Pressed:
	lea	InitP1RMBtxt,a0
	lea	ChkP2RMB,a1
	bra	DumpSerial
.noP1RMB:
	btst	#2,d6
	bne	.GoYellow



ChkP2RMB:
	btst	#3,d4
	beq	.noP2RMB
	btst	#3,d6
	beq	.GoGreen
.GoRed:
	bclr	#3,d4
	lea	RedTxt,a0
	lea	.Pressed,a1
	bra	DumpSerial
.GoGreen
	lea	GreenTxt,a0
	lea	.Pressed,a1
	bra	DumpSerial
.GoYellow:
	bclr	#3,d6			; Lets clear bit from startup, it is not stuck
	bset	#3,d4
	lea	YellowTxt,a0
	lea	.Pressed,a1
	bra	DumpSerial
.Pressed:
	lea	InitP2RMBtxt,a0
	lea	ChkP1MMB,a1
	bra	DumpSerial
.noP2RMB:
	btst	#3,d6
	bne	.GoYellow


ChkP1MMB:
	btst	#4,d4
	beq	.noP1MMB
	btst	#4,d6
	beq	.GoGreen
.GoRed:
	bclr	#4,d4
	lea	RedTxt,a0
	lea	.Pressed,a1
	bra	DumpSerial
.GoGreen
	lea	GreenTxt,a0
	lea	.Pressed,a1
	bra	DumpSerial
.GoYellow:
	bclr	#4,d6			; Lets clear bit from startup, it is not stuck
	bset	#4,d4
	lea	YellowTxt,a0
	lea	.Pressed,a1
	bra	DumpSerial
.Pressed:
	lea	InitP1MMBtxt,a0
	lea	.noP1MMB,a1
	bra	DumpSerial
.noP1MMB:
	btst	#4,d6
	bne	.GoYellow

ChkP2MMB:

	btst	#5,d4
	beq	.noP2MMB
	btst	#5,d6
	beq	.GoGreen
.GoRed:
	bclr	#5,d4
	lea	RedTxt,a0
	lea	.Pressed,a1
	bra	DumpSerial
.GoGreen
	lea	GreenTxt,a0
	lea	.Pressed,a1
	bra	DumpSerial
.GoYellow:
	bclr	#5,d6			; Lets clear bit from startup, it is not stuck
	bset	#5,d4
	lea	YellowTxt,a0
	lea	.Pressed,a1
	bra	DumpSerial
.Pressed:

	lea	InitP2MMBtxt,a0
	lea	ChkDone,a1
	bra	DumpSerial
.noP2MMB:
	btst	#5,d6
	bne	.GoYellow
ChkDone:



	move.l	d6,a4			; Store register to A4 again. now with correct "stuck" keys

	lea	StartupTxt,a0
	lea	.mouse1,a1
	bra	DumpSerial
.mouse1:

	cmp.w	#0,d4
	beq	.none


	btst	#0,d4
	beq	.nop1lmb
	move.l	a4,d6
	bset	#12,d6
	move.l	d6,a4
	lea	P1LMBActTxt,a0
	lea	.nop1lmb,a1
	bra	DumpSerial
.nop1lmb:
	btst	#2,d4
	beq	.nop1rmb
	move.l	a4,d6
	bset	#13,d6
	move.l	d6,a4
	lea	P1RMBActTxt,a0
	lea	.nop1rmb,a1
	bra	DumpSerial
.nop1rmb:
	bra	.done

.none:
	lea	NONE,a0
	lea	.done,a1
	bra	DumpSerial
.done:

	lea	NewLineTxt,a0
	lea	.done2,a1
	bra	DumpSerial
.done2

	move.l	a2,d4



;----------- Chipmemtest done

	move.w	#$bfb,$dff180


					;----------------------------------------------
					;	Here machine have just printed out start and endaddress of detected chipemem
	move.l	a3,a7

	move.l	a4,d1
	btst	#12,d1				; Check if LMB was pressed, this means users asked for fastmem to be used, if found.
	bne	.dofast2
	move.l	d1,a4				; store it back to a4


	move.l	#-1,d1			; Set d1 to -1 telling machine we actually did skip fastmem test



	cmp.l	#(EndData-Variables)/65536+1,d0
	bgt	.skipfasttest		; ok we had enough chipmem
					; so we are not happy with the amount of found chipmem
.dofast:


	PAROUT	#$fc			; Send $fd to parallelport
	lea	parfctxt,a0		; And explaining simliar text to serialport.
	lea	.jmp12,a1
	bra	DumpSerial
					; Lets detect fastmem, do NOT touch D0, A6 or A4
.dofast2:
	PAROUT	#$fc			; Send $fd to parallelport
	lea	parfctxt2,a0		; And explaining simliar text to serialport.
	lea	.jmp12,a1
	bra	DumpSerial
.jmp12:
					; As we have several blocks to search. we do it in a subroutine instead of in-code as we did with chipmem
					

	move.w	#$cfc,$dff180



	move.l	d3,a7			; Store start of chipmem
	clr.l	d1
	lea	$0,a0
	lea	$0,a3
	lea	$0,a6


					; as d0 is used as a "random" number in memcheck.  but d0 is also detected chipmem.
					; lets eor this to make it more... "random"
					; this detection is quite.. "poor" as it will stop when finding one block of ram. so fragmented memory only first block
					; will be found

	clr.l	d2			; We set d2 to 0.  if it is anything else than 0 after 24bit tests, we have32bit cpu



	move.w	#$006,$dff180


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
	beq	.a1200done





	lea	$8000000,a1		; Detect cpuboard on A3000/4000
	lea	$10000000,a2


	eor.l	#$01010000,d0

	lea	.a3k4kcpudone,a3
	jmp	DetectMemory
.a3k4kcpudone:


	cmp.l	#0,a0			; if a0 is 0, we did not find memory
	bne	.det20			; it wasnt, we did have memory
					; ok we did not have memory, copy data from last detect
	move.l	a3,a0
	move.l	a6,a1
	bra	.det26
.det20:
	move.l	a0,d5			; Backup startaddress of memory found
	move.l	a1,d4			; Backup endaddress of memory found
	move.l	d1,d3			; Backup data of addresses found to registers not used

	lea	FastFoundtxt,a0
	lea	.det21,a1
	bra	DumpSerial
.det21:
	move.l	d5,d1
	lea	.det22,a2
	bra	DumpHexLong
.det22:
	lea	MinusDTxt,a0
	lea	.det23,a1
	bra	DumpSerial
.det23:
	move.l	d4,d1
	lea	.det24,a2
	bra	DumpHexLong
.det24:
	lea	NewLineTxt,a0
	lea	.det25,a1
	bra	DumpSerial
.det25:
	eor.l	#$01010000,d0
	bra	.fast
.det26:


	eor.l	#$01010000,d0

.bppc:	move.w	#$009,$dff180


	lea	$40000000,a1
	lea	$e0000000,a2
	lea	.detmbcpu,a3

	eor.l	#$11010000,d0


	jmp	DetectMemory


.detmbcpu:
	cmp.l	#" PPC",$f00090		; Check if the string "PPC" is located in rom at this address. if so we have a BPPC
					; that will disable the 68k cpu onboard if memory  below $40000000 is tested.
	beq	.bppc



	eor.l	#$01110000,d0

	move.w	#$003,$dff180

	lea	$1000000,a1		; Detect motherboardmem on A3000/4000
	lea	$8000000,a2

	lea	.a3k4kdone,a3
	jmp	DetectMemory
.a3k4kdone:				; Again, the wonders without stack.  pasta-code.. :)



	move.l	a0,d5			; Backup startaddress of memory found
	move.l	a1,d4			; Backup endaddress of memory found
	move.l	d1,d3			; Backup data of addresses found to registers not used



	cmp.l	#0,a0			; was a0 0?  if so. no memory was found
	beq	.det16


	lea	FastFoundtxt,a0
	lea	.det11,a1
	bra	DumpSerial
.det11:


	move.l	d5,d1
	lea	.det12,a2
	bra	DumpHexLong
.det12:
	lea	MinusDTxt,a0
	lea	.det13,a1
	bra	DumpSerial
.det13:
	move.l	d4,d1
	lea	.det14,a2
	bra	DumpHexLong
.det14:

	lea	NewLineTxt,a0
	lea	.det15,a1
	bra	DumpSerial
.det15:
	eor.l	#$01110000,d0


	bra	.fast


.det16:

	eor.l	#$01110000,d0


.det1200cpu:
	cmp.l	#0,a0			; if a0 is 0, we did not find memory
	bne	.det30			; it wasnt, we did have memory
					; ok we did not have memory, copy data from last detect
	move.l	a3,a0
	move.l	a6,a1
	bra	.det36
.det30:
	move.l	a0,d5			; Backup startaddress of memory found
	move.l	a1,d4			; Backup endaddress of memory found
	move.l	d1,d3			; Backup data of addresses found to registers not used

	lea	FastFoundtxt,a0
	lea	.det31,a1
	bra	DumpSerial
.det31:
	move.l	d5,d1
	lea	.det32,a2
	bra	DumpHexLong
.det32:
	lea	MinusDTxt,a0
	lea	.det33,a1
	bra	DumpSerial
.det33:
	move.l	d4,d1
	lea	.det34,a2
	bra	DumpHexLong
.det34:
	lea	NewLineTxt,a0
	lea	.det35,a1
	bra	DumpSerial
.det35:
	eor.l	#$11010000,d0
	bra	.fast

.det36:



	eor.l	#$11010000,d0

.a1200done:

	move.w	#$00c,$dff180


	lea	$200000,a1		; Detect memory on 24 bit range
	lea	$9fffff,a2
	lea	.24bitdone,a3
	eor.l	#$10010000,d0

	jmp	DetectMemory
.24bitdone:
	cmp.l	#0,a0			; if a0 is 0, we did not find memory
	bne	.det40			; it wasnt, we did have memory
					; ok we did not have memory, copy data from last detect
	move.l	a3,a0
	move.l	a6,a1
	bra	.det46
.det40:
	move.l	a0,d5			; Backup startaddress of memory found
	move.l	a1,d4			; Backup endaddress of memory found
	move.l	d1,d3			; Backup data of addresses found to registers not used
	lea	FastFoundtxt,a0
	lea	.det41,a1
	bra	DumpSerial
.det41:
	move.l	d5,d1
	lea	.det42,a2
	bra	DumpHexLong
.det42:
	lea	MinusDTxt,a0
	lea	.det43,a1
	bra	DumpSerial
.det43:
	move.l	d4,d1
	lea	.det44,a2
	bra	DumpHexLong
.det44:
	lea	NewLineTxt,a0
	lea	.det45,a1
	bra	DumpSerial
.det45:
	eor.l	#$10010000,d0
	bra	.fast
.det46:


	eor.l	#$10010000,d0

	move.w	#$00f,$dff180

	lea	$c00000,a1		; Detect memory on 24 bit range
	lea	$c80000,a2


	eor.l	#$10110000,d0

	lea	.fakefastdone,a3
	jmp	DetectMemory
.fakefastdone:

	move.w	#$aaa,$dff180		; make screen light grey

	cmp.l	#0,a0			; if a0 is 0, we did not find memory
	bne	.det50			; it wasnt, we did have memory
					; ok we did not have memory, copy data from last detect
	move.l	a3,a0
	move.l	a6,a1
	move.l	d1,d3
	bra	.det55
.det50:
	move.l	a0,d5			; Backup startaddress of memory found
	move.l	a1,d4			; Backup endaddress of memory found
	move.l	d1,d3			; Backup data of addresses found to registers not used
	lea	FastFoundtxt,a0
	lea	.det51,a1
	bra	DumpSerial
.det51:
	move.l	d5,d1
	lea	.det52,a2
	bra	DumpHexLong
.det52:
	lea	MinusDTxt,a0
	lea	.det53,a1
	bra	DumpSerial
.det53:
	move.l	d4,d1
	lea	.det54,a2
	bra	DumpHexLong
.det54:
	lea	NewLineTxt,a0
	lea	.det55,a1
	bra	DumpSerial
.det55:
	move.l	d3,d1
	eor.l	#$10110000,d0
	bra	.fast
.det56:

	eor.l	#$10110000,d0

	move.l	d1,d3

.skipfasttest:


	move.w	#$dfd,$dff180


	move.l	d1,d3
	cmp.l	#-1,d1
	beq	.skippedfm		; if it was -1 we skipped fastmemtest
	cmp.l	#0,d1			; check if we had any fastmem
	bne	.fast			; if it wasnt 0 , we had fastmem
	bra	.nofastmemfound	
.skippedfm:

	lea	NoFastFoundSkippedtxt,a0
	lea	.fast,a1
	bra	DumpSerial

.nofastmemfound:

	lea	NoFastFoundtxt,a0
	lea	.fast,a1
	bra	DumpSerial


.fast:
	move.l	a7,a5			; Put start of chipstart at A2
	swap	d0
	clr.w	d0			; make sure higher bits of d0 is cleared
	swap	d0			; kuk

	move.l	d3,d1




	move.l	d1,d3			; Store size in d3 as Dumpserial uses d1

	move.w	#$efe,$dff180

	PAROUT	#$fb			; Send $fd to parallelport
	lea	parfbtxt,a0		; And explaining simliar text to serialport.
	lea	.jmp16,a1
	bra	DumpSerial
.jmp16:
	move.l	d3,d1
	move.l	d4,a1			; Restore important data from fastmemdetection
	move.l	d5,a0

	;	memdetection done
	move.l	a5,a7			; move the backup of chipstart to a7

;	d0				; total chipmem *32
;	d1				; total fastmem *64
;	a0				; Start of Fastmemblock
;	a1				; end of fastmemblock
;	a4				; Startupbits (pressed mousebuttons etc)
;	a7				; Start of chipmem



	clr.l	d7			; Be sure d7 is clear

	cmp.l	#(EndData-Variables)/65535+1,d0
	bgt	.enoughchip		; ok we had enough chipmem
					; so we are not happy with the amount of found chipmem

	cmp.l	#-1,d1
	beq	.fastskipped
	cmp.l	#(EndData-Variables)/65535+1,d1		; but was there enough FASTMEM??
	bgt	.enoughfast				; if so, jump there  (should be enoughfast..)
.fastskipped:
					; OK we are is trouble.. not enough memory
	cmp.l	#2,d0			; do we have extremly little chipmem
	ble	.nochip
	
					; ok we did not have enough chipmem, or fastmem, but SOME chipmem
 	PAROUT	#$81			; Set code to $81 to paralellport, NOT ENOUGH chipmem avaible
	lea	par81txt,a0		; And explaining simliar text to serialport.
	lea	.jmp14,a1
	bra	DumpSerial
.jmp14:
	move.l	#$0080,d6		; set D6 to darker green
	bra	ERRORHALT	
.nochip:				; we had NO chipmem
 	PAROUT	#$80			; Set code to $80 to paralellport, NO chipmem avaible
	lea	par80txt,a0		; And explaining simliar text to serialport.
	lea	.jmp15,a1
	bra	DumpSerial
.jmp15:
	move.l	#$00f0,d6		; set D0 to darker green
	bra	ERRORHALT	

.enoughfast:




	move.l	a0,a6			; set d6 to contain the pointer to fastmem
	move.l	d1,d4			; copy size in blocks to d4
	asl.l	#8,d4			; Multiply  d2 with 64 to get correct number of kilobytes of fastmem.;
	asl.l	#8,d4
	move.l	a4,d7
	bset.l	#6,d7			; Set "nodraw" on
	move.l	d7,a4

	bra	startcode

	
.enoughchip:				; OK we had enough chipmem avaible.

	move.l	a7,a6			; Copy pointer to first chipmem found to a6
	move.l	d0,d4			; Copy size in blocks to d2
	asl.l	#8,d4			; Multiply d0 with 64 as it contains number of blocks of 64K
	asl.l	#8,d4
	sub.l	#$400,d4

	move.l	a4,d7
	btst	#12,d7			; Check if LMB was pressed during boot
	bne	.chipLMB

.wearechip:


	bra	startcode		; Start ROM for real, now with memory.
	

.chipLMB:				; LMB Pressed so we force fastmem if avaible, and if not just turn off screenstuff etc.


	move.l	a4,d7
	bset.l	#6,d7			; Set "nodraw" on
	move.l	d7,a4
	
	cmp.l	#0,d1			; Was there any useful fastmem
	beq	.nofast
	bra	.enoughfast
	move.l	a5,a6			; OK we had fastmem, set it as baseadress
.nofast:				; we didnt have any fastmem, lets use chipmem but skip screenstuff.



startcode:
	move.l	a4,d7
	btst	#13,d7
	bne	.rmb

	add.l	d4,a6			; add total size of memory to a6, so a6 now points to END of memory


	sub.l	#(EndData-Variables)+2048,a6	; Now subtract the needed space for workspace, plus extra 2k "safespace"
.rmb:
						; Basememory is now set!



	move.l	d1,d3
	lea	Base1Txt,a0
	lea	.base1,a1
	bra	DumpSerial
.base1:
	move.l	a6,d1
	lea	.base2,a2
	bra	DumpHexLong
.base2:
	lea	Base2Txt,a0
	lea	.base3,a1
	bra	DumpSerial
.base3:
	move.l	d3,d1			; Printed workmem




					; a6  now contains workspace
	move.l	d1,d6			; Store size in d6 as Dumpserial uses d1
	move.l	a0,a5			; Store detected mem to a1




	move.w	#$fff,$dff180


	lea	WorkAdrtest,a0
	lea	.jmp1,a1
	bra	DumpSerial
.jmp1:





	move.l	a6,a3			; Start to fill the workarea with its address
	move.l	a6,d3
	add.l	#EndData-V,d3
	clr.l	d5

.adrloop:
	move.l	a3,(a3)+
	cmp.l	d3,a3
	blo	.adrloop			; Now we have filles the workarea..




	move.l	a6,a5			; Start to fill the workarea with its address
	move.l	a6,d3
	add.l	#EndData-V,d3
.adrtstloop:

	move.l	a5,d1
	cmp.l	(a5),d1
	bne	.adrerr
	add.l	#4,a5
	cmp.l	d3,a5
	blo	.adrtstloop			; Now we have filled the workarea..
	bra	.adrok
.adrerr:
	move.l	a4,d5
	swap	d5
	add.w	#1,d5
	cmp.w	#50,d5
	bgt	.adrtoomany
	swap	d5
	move.l	d5,a4
	lea	RomAdrErr,a0
	lea	.romadr2,a1
	bra	DumpSerial
.romadr2:
	move.b	$dff006,$dff180
	TOGGLEPWRLED
	
	move.l	a5,d1
	lea	.aab,a2
	bra	DumpHexLong
.aab:
	lea	.afterspace,a1
	move.l	#" ",d1
	bra	DumpSerialCharacter
.afterspace:
	move.l	a5,d1
	lea	.afterbin,a3
	bra	DumpBinSerial
.afterbin:
	lea	SpacesTxt,a0
	lea	.afterspace2,a1
	bra	DumpSerial
.afterspace2:
	move.l	(a5),d1
	lea	.aab2,a2
	bra	DumpHexLong
.aab2:


.ok:
	move.w	#$000,$dff180
	add.l	#4,a5
	bra	.adrtstloop

.adrtoomany:
	swap	d1
	move.l	d1,a4
.adrtoomany2:
	lea	WorkAdrErrors,a0
	lea	.adrdone,a1
	bra	DumpSerial


.adrok:	
	lea	WORKOK,a0
	lea	.adrdone,a1
	bra	DumpSerial

.adrdone:

	move.w	#$eee,$dff180




	move.l	a6,a3			; Start to clear the workarea.. So everything is initliized correctly at start/reset
	move.l	a6,d3
	add.l	#EndData-V,d3
.loopa:
	clr.l	(a3)+
	cmp.l	d3,a3
	blo	.loopa			; Now we have cleared the workarea..



	move.w	#$ddd,$dff180


 	PAROUT	#$fa			; Set code to $fa to paralellport
	lea	parfatxt,a0		; Telling the user that memory is started to be used.
	lea	.jmp,a1	
	bra	DumpSerial
.jmp:
	move.l	d6,d1
	move.l	a5,a0			; Restore important data from fastmemdetection






	move.l	a6,a3			; Start to clear the workarea.. So everything is initliized correctly at start/reset
	move.l	a6,d3
	add.l	#EndData-V,d3
.loop:
	clr.l	(a3)+
	cmp.l	d3,a3
	blo	.loop			; Now we have cleared the workarea..




	bra	code

	
ERRORHALT:				; This is a critical Error. stop everything. we are fucked.
	move.l	d6,d4			; as d4 isnt used in motherboardcheck, store color

ERRORHALT2:

	lea	HALTTXT,a0		; Tell user on serialport that we are totally halted.
	lea	.endless,a1
	bra	DumpSerial


.endless:
	move.w	#$0f0,d5			; color to flash with
	clr.l	d3
						; speed of "flash"
	lea	$400,a1				; Start to test at $400
.endlessloop:	
	move.l	#$ffffffff,d0
	move.l	d0,(a1)
	move.l	(a1),d1
	move.l	(a1),d1
	move.l	(a1),d1
	move.l	(a1),d1
	clr.l	d2				; result. 0 = ok, 1 = error
						; check only SETS error.
	lea	.check1,a0
	jmp	bitcheck			; So lets check what we got from it
.check1:

	move.l	#$0,d0
	move.l	d0,(a1)
	move.l	(a1),d1
	move.l	(a1),d1
	move.l	(a1),d1
	move.l	(a1),d1
	lea	.check2,a0
	jmp	bitcheck
.check2:

	move.l	#$aaaaaaaa,d0
	move.l	d0,(a1)
	move.l	(a1),d1
	move.l	(a1),d1
	move.l	(a1),d1
	move.l	(a1),d1
	lea	.check3,a0
	jmp	bitcheck
.check3:
	move.l	#$55555555,d0
	move.l	d0,(a1)
	move.l	(a1),d1
	move.l	(a1),d1
	move.l	(a1),d1
	move.l	(a1),d1
	lea	.check4,a0
	jmp	bitcheck
.check4:
	move.l	#$f0f00f0f,d0
	move.l	d0,(a1)
	move.l	(a1),d1
	move.l	(a1),d1
	move.l	(a1),d1
	move.l	(a1),d1
	lea	.check5,a0
	jmp	bitcheck
.check5:



	move.l	d2,d1				; Transfer biterorlongword to d1
.bottomloopa:
	move.l	#32,d7				; number of "bits"
	move.l	#31,d6
	move.l	#$34,d0				; Startrow

.bottomloop2:
	cmp.b	#$35,$dff006			; wait for rasterline below that even more
	bne	.bottomloop2				; to make sure, we will be waiting for the top later
						; OK this is the real deal. so now we can start the business
								
.redloop:
	cmp.b	$dff006,d0
	bne	.redloop
	move.w	#$f00,$dff180
	add.l	#2,d0
.endredloop:
	cmp.b	$dff006,d0
	bne	.endredloop
	btst	d6,d1
	beq	.on
	move.w	#$070,$dff180
	bra	.off
.on:
	move.w	#$0f0,$dff180
.off:
	sub.l	#1,d6
	add.l	#2,d0
	dbf	d7,.redloop
	move.w	#$333,$dff180			; Make it DAAAARKGREY

	move.b	#$e0,d0				; Set to wait to row $e0 here we will do the 512K block chip test

	move.l	d3,a4				; make a backup of d3 to a4


	lea	$400,a3				; Where to start testing
	clr.l	$400
	move.l	#3,d7				; do this 4 times

.chiploop:
	add.l	#1,d0
	clr.l	d6
.blueloop:
	cmp.b	$dff006,d0
	bne	.blueloop
	move.w	#$00f,$dff180
	add.l	#2,d0


	cmp.l	#$400,a3			; Check if we is testing $400
	beq	.a400				; we are
	move.l	#"SHDW",$400			; write a string into $400 if this string is read. we have a shadow

	cmp.l	#"SHDW",(a3)			; Check if string "SHDW" is here. then. we have a shadow. no real mem.
	bne	.noshdw
	move.b	#1,d6				; set d6 to anything but 0 to mark we had a shadow
.noshdw:


.a400:
	move.l	#"MEM?",(a3)
	nop
	move.l	(a3),d3
	nop
	move.l	(a3),d3
	nop
	move.l	(a3),d3
	nop
	move.l	(a3),d3
	cmp.l	#"MEM?",d3			; did we read the same thing?
	bne	.nomem

	move.l	a3,a5
	sub.l	#1024*1024,a5			; Subtract 1MB of where we was.
	move.l	#"COPY",(a3)			; Write COPY to mem..
	cmp.l	#"COPY",(a5)			; Can COPY still be read 1MB lower? then we have a shadow
	beq	.nomem

.endblueloop:
	cmp.b	$dff006,d0
	bne	.endblueloop

	cmp.b	#0,d6
	bne	.shadow

	clr.l	(a3)				; Clear mem
	move.w	#$ff0,$dff180
	bra	.done
.nomem:

.endblueloop2:
	cmp.b	$dff006,d0
	bne	.endblueloop2

	clr.l	(a3)
	move.w	#$77,$dff180
	bra	.done
.shadow:
	clr.l	(a3)
	move.w	#$600,$dff180			; Set backgroundcolor to dark red

.done:

	add.l	#3,d0
	add.l	#512*1024,a3			; add 512K to next block to test

	dbf	d7,.chiploop
.blueloop2:
	cmp.b	$dff006,d0
	bne	.blueloop2
	move.w	#$00f,$dff180
	add.l	#2,d0
.endblueloop3:
	cmp.b	$dff006,d0
	bne	.endblueloop3


	move.w	d5,$dff180
	move.l	a4,d3


	add.b	#1,d3
	cmp.b	#15,d3
	bne	.notnow
	eor.w	#$0c0,d5
	TOGGLEPWRLED				; Change value of Powerled.
	add.l	#4,a1				; so at every flash, lets text next longword
						; no "endtest" is done, if you want to wait for
						; 2 MB of data YOU ARE FUCKING WELCOME!
	clr.b	d3	
.notnow:
	bra	.endlessloop


						; "real" code starts here.  we got detected memory etc.
						; FINALLY som stack etc etc..

code:
	move.w	#$ccc,$dff180



	move.l	a7,d3			; Copy start of chipmem (temporary stored in a7) do d3


	move.l	a6,a7
	move.l	#Endstack-Variables,d6	; set d6 to the stacksize	
	add.l	d6,a7			; and add stacksize so we have a stack
	move.l	a7,a6			
	add.l	#4,a6			; make a6 first usable address AFTER stack. for variables.






	clr.l	d2

	move.l	#RTEcode,$64
	move.l	#RTEcode,$68
	move.l	#RTEcode,$6c
	move.l	#RTEcode,$70
	move.l	#RTEcode,$74
	move.l	#RTEcode,$78
	move.l	#RTEcode,$7c

	move.l	#SSPError,0		; Set different traps of faults that can happen
	move.l	#BusError,$8		; This time to a routine that can present more data.
	move.l	#AddressError,$c
	move.l	#IllegalError,$10
	move.l	#DivByZero,$14
	move.l	#ChkInst,$18
	move.l	#TrapV,$1c
	move.l	#PrivViol,$20
	move.l	#Trace,$24
	move.l	#UnimplInst,$28
	move.l	#UnimplInst,$2c
	move.l	#Trap,$80
	move.l	#Trap,$84
	move.l	#Trap,$88
	move.l	#Trap,$8c
	move.l	#Trap,$90
	move.l	#Trap,$94
	move.l	#Trap,$98
	move.l	#Trap,$9c
	move.l	#Trap,$a0
	move.l	#Trap,$a4
	move.l	#Trap,$a8
	move.l	#Trap,$ac
	move.l	#Trap,$b0
	move.l	#Trap,$b4
	move.l	#Trap,$b8
	move.l	#Trap,$bc
	move.b	#0,DISPAULA-V(a6)

	TOGGLEPWRLED


		else

; Code in NON-ROM mode
code:



	move.l	$8,SaveBusError		; This time to a routine that can present more data.
	move.l	$c,SaveAddressError
	move.l	$10,SaveIllegalError
	move.l	$14,SaveDivByZero
	move.l	$18,SaveChkInst
	move.l	$1c,SaveTrapV
	move.l	$20,SavePrivViol
	move.l	$24,SaveTrace
	move.l	$28,SaveUnimplInst
	move.l	$2c,SaveUnimplInst2
	move.l	$80,SaveTrap
	move.l	$84,SaveTrap2
	move.l	$88,SaveTrap3
	move.l	$8c,SaveTrap4
	move.l	$90,SaveTrap5
	move.l	$94,SaveTrap6
	move.l	$98,SaveTrap7
	move.l	$9c,SaveTrap8
	move.l	$a0,SaveTrap9
	move.l	$a4,SaveTrap10
	move.l	$a8,SaveTrap11
	move.l	$ac,SaveTrap12
	move.l	$b0,SaveTrap13
	move.l	$b4,SaveTrap14
	move.l	$b8,SaveTrap15
	move.l	$bc,SaveTrap16



	clr.b	$bfe001
	clr.b	$bfe201
	clr.b	$bfe001
	move.b	#$ff,$bfe301
	move.b	#3,$bfe201	
	bclr	#1,$bfe001

	lea	$0,a4			; if this is not set. bugs can happen as it can think we are in nondrawmode
	lea	V,a6			; Set V as startaddress in non-rom mode.. the stackblock is more "nonsense"
					; do not set any stack in this mode. it is already set.
	move.l	#BeforeUsed,d3
	move.l	#$20,d0			; Assume 2MB of chipem when running in non ROM mode
	move.b	#1,RASTER-V(a6)		; Set that we DO have raster


	move.l	$64,irq1
	move.l	$68,irq2
	move.l	$6c,irq3
	move.l	$70,irq4
	move.l	$74,irq5
	move.l	$78,irq6
	move.l	$7c,irq7


	endc
		
; Normal code

	ifeq	rommode			; if we are in rommode, disable serial output

;	move.b	#1,NoSerial-V(a6)

	move.l	a4,d0
	bset	#7,d0
	move.l	d0,a4

	endc

;	Put initstuff here that consumes time, so user have time to read text on console


					; Before we actually do start, lets clear all used memory


