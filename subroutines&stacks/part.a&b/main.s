NUM			EQU				0x20000410
			
			AREA			main,CODE,READONLY
			THUMB
			EXTERN			convrt
			EXTERN			OutStr
			EXTERN			InChar
			EXPORT 			__main
;I included subroutines that i wil use

__main		
user		BL				InChar
			LDR				R5,=NUM
			LDR				R4,[R5]
			BL				convrt
			BL				OutStr
			B				user

;user is for infinite loop for user input.Branch goes to line started with user.
;I defined NUM as 0x20000410 .It is a memory address. 
;I loaded value from memory address pointed by R5 to R4
;Then i converted it to decimal value (in ascii characters for printing) using convrt subroutine 
;and printed it via OutStr
			
			END