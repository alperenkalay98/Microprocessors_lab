			AREA    		routines,CODE,READONLY
			THUMB
			EXPORT			DELAY100

DELAY100
			LDR				R8,=0x61A80		;Internal clock is 16mhz.So, one cycle is about 6.25*10^-8 seconds.
loop		nop								;nop is 1 cycle,SUBS 1 cycle, BNE is ~2 cycle (change between 1-3)
			SUBS			R8,#1			;total 1.600.000 cycle is needed for 100miliseconds
			BNE				loop			;it makes 400.000 times of this loop
											;So r1 is counting down from decimal 400000.
			BX				LR	