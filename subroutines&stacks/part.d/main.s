			AREA			sdata,DATA,READONLY
			THUMB				
inp_info	DCB				"Please insert input with '.' at the end --> ex. insert 72. instead of 72"
			DCB				0x0D
			DCB				0x04
;I used '.' character as ending character. I red input values up to this character.

alt			DCB				" "
			DCB				0x0D
			DCB				0x04
;This line is just for good looking terminal, i wanted to go another line for another input
			

			
			AREA			main,CODE,READONLY
			THUMB
			EXTERN			convrt
			EXTERN			OutStr
			EXTERN			InChar
			EXTERN			century_bay
			EXTERN			seventh_town
			EXTERN			quartier_digit
			EXTERN			humble_ville
;I wrote subroutines for each area. I explained them in their section more detailed.
			EXPORT			__main
				
__main

alw			LDR				R0,=0x2E						;alw is for infinite loop. 
			LDR				R10,=0x20000410
			PUSH			{R0}
			LDR				R5,=inp_info
			BL 				OutStr
get_input	BL				InChar
			CMP				R5,R0
			BEQ				to_hex
			SUB				R5,#'0'
			STRB			R5,[R10],#1
			PUSH			{R5}
			B				get_input
;In the upper part, I red the input value from user up to '.' character and stored the digits of decimal input.
;I used stack for this because later i will multiply these digits with 10's power and i wanted to start from least 
;significant number of decimal digits.Simply i reversed the order.
			
			
to_hex		POP				{R2}
			LDR				R1,=0x0A
			MOV				R6,R1
hex_done	POP				{R3}
			CMP				R3,R0
			BEQ				logistic
			MUL				R3,R1
			ADD				R2,R3
			MUL				R1,R6
			B				hex_done
;In the upper part, I simply convert decimal to hex. I seperated digits and summed them. For example 254 --> 200+50+4
;and i stored it in R2 as hexadecimal.
			
logistic	LDR				R0,=0x20000430
			LDR				R1,=0x20000434
			STR				R2,[R0]
;I will store every subroutine result starting from R1. R0 is food parcel that i have at the beginning.
			
possble_min	BL				century_bay
			BL				seventh_town
			BL				quartier_digit
			BL				humble_ville
			ADD				R0,#4
			CMP				R0,R1
			BEQ				find_min
			B				possble_min
;This is the most critical part of my code.I go into these subroutines with food parcels i have.
;If i can reduce the number of food parcel i have, i reduce it and store this value.
;I am modifying my memory until i can not go more.
;Later i will search for minumum value from memory from 0x20000430 up to modified R1 value.
;It is like a tree. I have a value first and go from 4 different paths. And each path goes for another 4 different paths
;and it goes like this until they can not go more
			
find_min	LDR				R11,=0x20000430
			LDR				R8,[R11]
			ADD				R11,#4			
find		CMP				R11,R0
			BEQ				finish
			LDR				R9,[R11],#4
			CMP				R8,R9
			BMI				find
			MOV				R8,R9
			B				find
;I am searching for minumum value among all possible food parcel number left.
;I red datas from these locations and compared them. I stored the smaller value at R8.
;I continued it up to last value. So, i basically find the smallest value.-->linear search method.
			
finish		MOV				R4,R8
			BL				convrt
			BL				OutStr
			LDR				R5,=alt
			BL				OutStr
			B				alw
;I converted hex value of smallest value to decimal with subroutine that i wrote before.
;Then printed it. The second OutStr subroutine is just for going next line.
;Then i used branch to make this code work in an infinite loop.

			END