PB_IN			EQU		0x4000503C
PB_OUT			EQU		0x400053C0	
				
				AREA		routines,CODE,READONLY
				THUMB
				EXTERN		speed_change	
				EXPORT		is_there_any_change
is_there_any_change

				B			loop
				
change_speed	
				BL			speed_change
				CPSIE		I
				B			cont				

				

loop			LDR			R8,=PB_IN
				LDR			R9,[R8]
											
				CMP			R9,#8
				BEQ			release_detect
				CMP			R9,#4
				BEQ			release_detect
				B			cont
				
release_detect	LDR			R10,[R8]
				CMP			R10,#0
				BNE			release_detect			
				B			change_speed

cont			CMP			R9,#1
				BEQ			change
				CMP			R9,#2
				BEQ			change
				B			done
								
change			nop
				nop
				nop
				nop
release_detect2	LDR			R10,[R8]
				CMP			R10,#0
				BNE			release_detect2
				MOV			R6,R9
				B			done
												
done			B			loop
				ENDP