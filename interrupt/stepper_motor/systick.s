NVIC_ST_CTRL		EQU		0xE000E010
NVIC_ST_RELOAD		EQU		0xE000E014
NVIC_ST_CURRENT		EQU		0xE000E018
SHP_SYSPRI3			EQU		0xE000ED20
RELOAD_VALUE		EQU		0x0000FFFF
PB_OUT				EQU		0x400053C0
MAX_SPEED			EQU		0x00001BB0
MIN_SPEED			EQU		0x00FFFFFF
	
	
					AREA	init_isr,CODE,READONLY,ALIGN=2
					THUMB
	
						
					EXPORT	InitSysTick
InitSysTick			PROC
					
					LDR		R1,=NVIC_ST_CTRL
					MOV		R0,#0
					STR		R0,[R1]
					
					LDR		R1,=NVIC_ST_RELOAD
					LDR		R0,=RELOAD_VALUE
					STR		R0,[R1]
					
					LDR		R1,=NVIC_ST_CURRENT
					STR		R0,[R1]
					
					LDR		R1,=SHP_SYSPRI3
					MOV		R0,#0x40000000
					STR		R0,[R1]
					
					LDR		R1,=NVIC_ST_CTRL
					MOV		R0,#0x03
					STR		R0,[R1]
					
					BX		LR
					ENDP
						
					
					EXPORT	speed_change
speed_change		PROC
					
					LDR		R1,=NVIC_ST_CTRL
					MOV		R0,#0
					STR		R0,[R1]
					
					LDR		R1,=NVIC_ST_RELOAD
					LDR		R0,[R1]
					LDR		R2,=0X0A
					UDIV	R3,R0,R2
					CMP		R9,#2
					BEQ		faster
					CMP		R9,#4
					BEQ		slower
					
faster				SUB		R0,R0,R3
					LDR		R4,=MAX_SPEED
					CMP		R0,R4
					BLO		go
					STR		R0,[R1]
					B		go
slower				ADD		R0,R0,R3
					LDR		R4,=MIN_SPEED
					CMP		R0,R4
					BHI		go
					STR		R0,[R1]
					B		go
				
go					LDR		R1,=NVIC_ST_CURRENT
					STR		R0,[R1]
					
					LDR		R1,=SHP_SYSPRI3
					MOV		R0,#0x40000000
					STR		R0,[R1]
					
					LDR		R1,=NVIC_ST_CTRL
					MOV		R0,#0x03
					STR		R0,[R1]
					
					BX		LR
					ENDP
					
						
					EXPORT	My_ST_ISR
My_ST_ISR			PROC
					
	
					LDR		R0,=PB_OUT										
					LDR		R3,[R0]	
					
					CMP		R6,#1
					BEQ		cw
					CMP		R6,#2
					BEQ		ccw
					B		done					
					
cw					CMP		R3,#0x10
					BEQ		o
					CMP		R3,#0x30
					BEQ		oh
					CMP		R3,#0x20
					BEQ		t
					CMP		R3,#0x60
					BEQ		th
					CMP		R3,#0x40
					BEQ		tr1
					CMP		R3,#0xC0
					BEQ		trh
					CMP		R3,#0x80
					BEQ		f
					CMP		R3,#0x90
					BEQ		fh
					B		done
					
o					LDR		R3,=0x30					
					B		done
oh					LDR		R3,=0x20					
					B		done
t					LDR		R3,=0x60					
					B		done
th					LDR		R3,=0x40					
					B		done
tr1					LDR		R3,=0xC0					
					B		done
trh					LDR		R3,=0x80					
					B		done
f					LDR		R3,=0x90					
					B		done
fh					LDR		R3,=0x10					
					B		done					
			
					
ccw					CMP		R3,#0x10
					BEQ		or
					CMP		R3,#0x30
					BEQ		ohr
					CMP		R3,#0x20
					BEQ		tr
					CMP		R3,#0x60
					BEQ		thr
					CMP		R3,#0x40
					BEQ		trr
					CMP		R3,#0xC0
					BEQ		trhr
					CMP		R3,#0x80
					BEQ		fr
					CMP		R3,#0x90
					BEQ		fhr
					B		done
					
or					LDR		R3,=0x90					
					B		done
ohr					LDR		R3,=0x10					
					B		done
tr					LDR		R3,=0x30					
					B		done
thr					LDR		R3,=0x20					
					B		done
trr					LDR		R3,=0x60					
					B		done
trhr				LDR		R3,=0x40					
					B		done
fr					LDR		R3,=0xC0					
					B		done
fhr					LDR		R3,=0x80					
					B		done					
					
done			    STR		R3,[R0]
					BX		LR
					ENDP