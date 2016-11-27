-- Qifei 4-bit LED Digital Tube Module: function for NodeMCU ESP 8266. 
-- Adapted from https://goo.gl/nRNc4v to display the "dot". More characters added. 

-- WIRING:
-- DIO -> D7
-- SCLK -> D5
-- RCLK -> D4

latch_pin = 4
chars = { 
  0xC0, -- 0
  0xF9, -- 1
  0xA4, -- 2
  0xB0, -- 3
  0x99, -- 4
  0x92, -- 5
  0x82, -- 6
  0xF8, -- 7
  0x80, -- 8
  0x90, -- 9
  0x40, -- 0.
  0x79, -- 1.
  0x24, -- 2.
  0x30, -- 3.
  0x19, -- 4.
  0x12, -- 5.
  0x02, -- 6.
  0x78, -- 7.
  0x00, -- 8.
  0x10,  --9.
  0x88, -- A - write chars[21] to display this character on digit X
  0x83, -- b - write chars[22] to display this character on digit X 
  0xC6, -- C - write chars[23] to display this character on digit X
  0xA1, -- d - write chars[24] to display this character on digit X
  0x86, -- E - write chars[25] to display this character on digit X
  0x8E, -- F - write chars[26] to display this character on digit X
  0x89, -- H - write chars[27] to display this character on digit X
  0xE1, -- J - write chars[28] to display this character on digit X
  0xC7, -- L - write chars[29] to display this character on digit X
  0xC0, -- O - write chars[30] to display this character on digit X
  0x8C, -- P - write chars[31] to display this character on digit X
  0xC1, -- U - write chars[32] to display this character on digit X
  0x7F, -- . - write chars[33] to display this character on digit X
};
function displaywrite(n) -- It will display numbers in format: 12.34 (See examples)

    digit1 = chars[1+math.floor(n/1000)]
    digit2 = chars[1+10+math.floor((n/100)%10)] -- +10 to display the "dot" 
    digit3 = chars[1+math.floor((n/10)%10)]
    digit4 = chars[1+math.floor((n%10))]

    gpio.mode(latch_pin, gpio.OUTPUT)
    gpio.write(latch_pin, gpio.LOW)
    result = spi.setup(1, spi.MASTER, spi.CPOL_HIGH, spi.CPHA_LOW, spi.DATABITS_8, 0)
    tmr.alarm(1,8,1,function() 

    gpio.write(latch_pin, gpio.LOW)
-- sending to digit 1:
    spi.send(1, digit1)
    spi.send(1, tonumber("000001000",2)) -- spi.send(1, tonumber("000000000",2)) to disable this digit.
    gpio.write(latch_pin, gpio.HIGH)
 
    gpio.write(latch_pin, gpio.LOW)
-- sending to digit 2:
    spi.send(1, digit2)
    spi.send(1, tonumber("000000100", 2) )-- spi.send(1, tonumber("000000000",2)) to disable this digit.
    gpio.write(latch_pin, gpio.HIGH)

    gpio.write(latch_pin, gpio.LOW)
-- sending to digit 3:
    spi.send(1, digit3)
    spi.send(1, tonumber("00000010", 2) )-- spi.send(1, tonumber("000000000",2)) to disable this digit.
    gpio.write(latch_pin, gpio.HIGH)

    gpio.write(latch_pin, gpio.LOW)
-- sending to digit 4:
    spi.send(1, digit4)
    spi.send(1, tonumber("00000001", 2) ) -- spi.send(1, tonumber("000000000",2)) to disable this digit.
    gpio.write(latch_pin, gpio.HIGH)
    
        --clear
    gpio.write(latch_pin, gpio.LOW)
    spi.send(1, 0x00 )
    gpio.write(latch_pin, gpio.HIGH)
    
end)
end

--EXAMPLES:
--digit1 = chars[1+10+math.floor(n/1000)]
--digit2 = chars[1+math.floor((n/100)%10)]  
--digit3 = chars[1+math.floor((n/10)%10)]
--digit4 = chars[1+math.floor((n%10))]

-- It will display numbers in format: 1.234

--digit1 = chars[1+math.floor(n/1000)]
--digit2 = chars[1+math.floor((n/100)%10)]  
--digit3 = chars[1+10+math.floor((n/10)%10)]
--digit4 = chars[1+math.floor((n%10))]

-- It will display numbers in format: 123.4

--digit1 = chars[29]
--digit2 = chars[25]  
--digit3 = chars[30]
--digit4 = chars[33]

-- It will display LEO . (Yeah, it's me!)
