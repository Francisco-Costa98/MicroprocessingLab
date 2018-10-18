	#include p18f87k22.inc
	
	code
	org 0x0
	goto	setup
		
setup	movlw   0x04
	movwf   0x20, ACCESS	;delay register
	movlw	0x00
	movwf	TRISD, ACCESS	;sets port d to input port
	movlw	0x00
	movwf	TRISC, ACCESS	;sets port c to input port
	movlw	0xC3		; turns all control lines to high
	movwf	PORTD, ACCESS	; moves high values to port D
	banksel PADCFG1 ; PADCFG1 is not in Access Bank!!
	bsf PADCFG1, REPU, BANKED ; PortE pull-ups on
	movlb 0x00 ; set BSR back to Bank 0
	setf TRISE ; Tri-state PortE
	goto start
	
	
start	movlw   0x04
	movwf   0x20, ACCESS	;delay register
	call write1
	call read
	call write2
	call read2
	movff	PORTE, PORTC
	goto start
	
	
	
write1	movlw	0x41		; only turns on oe 1 and clock1 for writting
	movwf	PORTD, ACCESS	;moves value for high oe1 to port D
	clrf	TRISE		;sets PORTE to outputs
	movlw	0x45		; chose random number to send to porte
	movwf	PORTE, ACCESS
	movlw	0x40		;makes clock tick
	movwf	PORTD, ACCESS	;makes clock tick
	call	delay		;calls 250ns delay
	movlw	0x41		;makes clock tick
	movwf	PORTD, ACCESS	;makes clock tick
	setf	TRISE		;sets porte top tristate again
	return
	
read	movlw	0x01		; only turns on clock1
	movwf	PORTD, ACCESS	;moves value for low oe1 to port D
	movlw	0x41		; only turns on oe1 
	movwf	PORTD, ACCESS	;moves value for high oe1 to port D
	return

delay	decfsz 0x20 ; decrement until zero
	bra delay	
	return	

	write2	movlw	0x82		; only turns on oe 2 and clock2 for writting
	movwf	PORTD, ACCESS	;moves value for high oe1 to port D
	clrf	TRISE		;sets PORTE to outputs
	movlw	0x11		; chose random number to send to porte
	movwf	PORTE, ACCESS
	movlw	0x80		;makes clock tick
	movwf	PORTD, ACCESS	;makes clock tick
	call	delay		;calls 250ns delay
	movlw	0x82		;makes clock tick
	movwf	PORTD, ACCESS	;makes clock tick
	movlw	0x00
	movwf	PORTE, ACCESS
	setf	TRISE		;sets porte top tristate again
	return
	
read2	movlw	0x02		; only turns on clock2 for writting
	movwf	PORTD, ACCESS	;moves value for low oe1 to port D
	movlw	0x82		; only turns on oe2 
	movwf	PORTD, ACCESS	;moves value for high oe1 to port D
	return
	
	goto 0x0
	end
