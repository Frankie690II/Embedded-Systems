VARIABLE CURRENT_VALUE
VARIABLE SIZE 
8 CONSTANT SIZE_REQUESTED



: FALLING_EDGE_DETECT_SET_9				( -- )
	GPFEN0 
	9 1 MASK_REGISTER 
	200 OR GPFEN0 ! ;
	
: FALLING_EDGE_DETECT_SET_10				( -- )
	GPFEN0 
	10 1 MASK_REGISTER 
	400 OR GPFEN0 ! ;

: SETUP_9 						( -- )		
	SET_IN_9					\ We set the GPIOs as input and then we set the internal pull DOWN
	GPPUDCLK0 9 1 MASK_REGISTER			\ This is for GPIO 9 
	DOWN SET_PUD ;

: SETUP_10						( -- )
	SET_IN_10					\ We set the GPIOs as input and then we set the internal pull DOWN
	GPPUDCLK0 10 1 MASK_REGISTER			\ This is for GPIO 10
	DOWN SET_PUD ;

: SETUP_BSC						( -- )
	SET_ALT0_2					\ BSC1 is on GPIO pins 2(SDA) and 3(SCL) , so we set them to ALT0
	SET_ALT0_3
	SET_I2CEN ;					\ We enable the BSC controller
	
: FALLING_EDGE_DETECT_SET				( -- )
	FALLING_EDGE_DETECT_SET_9
	FALLING_EDGE_DETECT_SET_10 ;
	
: SETUP
	SETUP_9
	SETUP_10
	SETUP_BSC
	FALLING_EDGE_DETECT_SET 
	0 CURRENT_VALUE !				
	0 SIZE ! ;	

: CLEAR_PIN
	600 GPEDS0 ! ; 					\ We don't need to use a mask hence increase efficiency
	
: KEYS_MASK
	GPEDS0 10 1 MASK_REGISTER GPEDS0 9 1 MASK_REGISTER OR ;	
	
: PEEK_KEYPRESS							
	KEYS_MASK 
	GPEDS0 @ AND 
	DUP 0 <>
	IF
		1 MILLISECONDS DELAY		\ Makes sure the button has properly been
		GPLEV0 @ INVERT AND 		\ released, else a keypress could be read twice 
	THEN ;
	
	
: IS_PRESSED
	BEGIN						\ UPDATE : it should only check the approrpiate bits
		PEEK_KEYPRESS
	UNTIL ;

: READ_PIN						( -- 0/1 )	
	IS_PRESSED
	GPEDS0 @ 400 =					\ It leaves on the stack either 0 or 1
	IF
	0 
	ELSE
	GPEDS0 @ 200 =
	IF
	1
	THEN 
	THEN ; 
	
: LCD_HANDLE
	CURRENT_VALUE @ 10 =
	IF
	CLEAR_DISPLAY
	ELSE
	CURRENT_VALUE @ 11 =
	IF
	DISPLAY_LSHIFT
	ELSE
	CURRENT_VALUE @ 12 =
	IF
	DISPLAY_RSHIFT
	ELSE
	CURRENT_VALUE @ SEND_CHAR
	THEN
	THEN
	THEN ;
	
: WELCOME
	57 SEND_CHAR
	45 SEND_CHAR
	4C SEND_CHAR
	43 SEND_CHAR
	4F SEND_CHAR
	4D SEND_CHAR
	45 SEND_CHAR 
	21 SEND_CHAR
	3D0900 WAIT
	CLEAR_DISPLAY ;
	
	
	
: INPUT
	BEGIN 
		READ_PIN SIZE @ LSHIFT
		CURRENT_VALUE @ + CURRENT_VALUE !
		SIZE @ 1 + DUP SIZE !
		CLEAR_PIN
		SIZE_REQUESTED MOD 0 =
		IF
			LCD_HANDLE
			0 CURRENT_VALUE !
			0 SIZE ! 
		THEN
	AGAIN ;
	
: START
	SETUP
	LCD_INIT
	WELCOME
	INPUT ;

\ START










				

