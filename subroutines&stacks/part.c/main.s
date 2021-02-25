			AREA			sdata,	DATA,	READONLY
			THUMB
MSG			DCB				"Please insert n up to 31 in two digits --> ex.insert 02 for 2"
			DCB				0x0D
			DCB				0x04
;I could end the reading from user by determining an ending charcter but i modified it in that way
;So that user does not need to press any other key than numbers
nextline	DCB				0x0D
			DCB				0x04
			
			AREA			main,CODE,READONLY
			THUMB
			
			EXTERN			OutStr
			EXTERN			convrt
			EXTERN			InChar
			EXTERN 			upbnd
			EXPORT 			__main
				
__main
			LDR				R5,=MSG
			BL				OutStr
			BL				InChar
			MOV				R3,R5
			SUB				R3,#'0'
			BL				InChar
			MOV				R2,R5
			SUB				R2,#'0'
;I printed the message above and get the values from user.
;First digit of input is loaded to R3 and second digit is loaded to R2

			LDR				R6,=0x0A
			MUL				R3,R6
			ADD				R3,R2
			LDR				R9,=0x01		;r9 bottom
			LSL				R10,R9,R3		;r10 top
			ADD				R11,R9,R10		
			LSR				R11,R11,#1		;R11 middle
;I modified multiplied R3 with 0x0A and added the R2 value so it is hex now.
;Then i shifted left the 0x00000001 value for R3 times. Simply i get the value for maximum number.
;For binary search, i defined r9 as bottom register,r10 as top register and r11 as middle register
			
loop		MOV				R4,R11
			LDR				R5,=nextline
			BL				OutStr
			BL				convrt
			BL				OutStr
			BL				InChar
			CMP				R5,#0x43
			BEQ				done
			BL				upbnd
			B				loop
done		B				done
;I guessed before entering to loop.According to given input from user i updated the boundaries with upbnd subroutine.
;If the input from user is 'C' then i ended the loop.
;I explained subroutine upbnd in its section more detailed.

			END