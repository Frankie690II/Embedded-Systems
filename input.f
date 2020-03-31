: FALLING_EDGE_DETECT_SET_9				( -- )
	GPFEN0 9 1 MASK_REGISTER OR GPFEN0 ! ;
	
: FALLING_EDGE_DETECT_SET_10				( -- )
	GPFEN0 10 1 MASK_REGISTER OR GPFEN0 ! ;

\ We set the GPIOs as input and then we set the internal pull DOWN

\ This is for GPIO 9 
SET_IN_9
GPPUDCLK0 9 1 MASK_REGISTER
DOWN SET_PUD

\ This is for GPIO 10
SET_IN_10
GPPUDCLK0 10 1 MASK_REGISTER
DOWN SET_PUD

\ BSC1 is on GPIO pins 2(SDA) and 3(SCL) , so we set them to ALT0
SET_ALT0_2
SET_ALT0_3

\ We enable the BSC controller
SET_I2CEN

FALLING_EDGE_DETECT_SET_9
FALLING_EDGE_DETECT_SET_10



