	include "globals.i"

	include "1_headers.s"
	include "2_startup.s"
	include "3_main.s"
	include "4_utility.s"
	include "5_menu.s"
	include "6_tests.s"
	include "7_ptreplay.s"
	include "8_data.s"

; Validate that globals.i structure matches 9_vars.s
	IF 0 ; ND SKIP_GLOBALS_VALIDATION
	include "9_vars.s"
	include "validate_globals.s"
	ENDC

; this is data for "non rom mode"..
	ifeq	rommode
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
	
	section	workspace,code_f
startwork:
	blk.b	64*1024,0
endwork:

	endc
