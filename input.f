\ We set the GPIOs as input and then we set the internal pull DOWN


\ This is for GPIO 9 
SET_IN_9
GPPUDCLK0 9 1 MASK_REGISTER
DOWN SET_PUD
\ This is for GPIO 10
SET_IN_10
GPPUDCLK0 10 1 MASK_REGISTER
DOWN SET_PUD


