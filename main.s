				AREA		main,CODE,READONLY
				THUMB
				EXTERN		ports_init
				EXTERN		InitSysTick
				EXTERN		is_there_any_change
				EXPORT		__main
					
__main												
				BL			ports_init
				BL			InitSysTick
				CPSIE		I
		
				BL			is_there_any_change
				END