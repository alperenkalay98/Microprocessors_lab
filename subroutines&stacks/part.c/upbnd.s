;BOTTOM		EQU				r9
;TOP		EQU				r10
;MIDDLE		EQU				r11	
			
			AREA			routines,CODE,READONLY
			THUMB
			EXPORT 			upbnd
				
upbnd		
			CMP				R5,#0x55
			BEQ				up
			CMP				R5,#0x44
			BEQ				down
;It goes to two path according to input from user.
;If it is 'D' ,it goes to down branch,
;If it is 'U' ,it goes to up branch
			
up			MOV				R9,R11
			ADD				R9,#1
			ADD				R11,R9,R10
			LSR				R11,#1
			B				done
;I made my new bottom as old middle and added 1.
;Then i defined new middle as average of bottom and top.

down		MOV				R10,R11
			SUB				R10,#1
			ADD				R11,R9,R10
			LSR				R11,#1
			B				done
;I made my new top as old middle and subtracted 1.
;Then i defined new middle as average of bottom and top.

done		BX				LR
			END
			
			