.ORG 0x0					;location for reset
  JMP MAIN
.ORG OC2Aaddr  JMP timer2_compareMatch_A_Routine
.ORG OC2Baddr  JMP timer2_compareMatch_B_Routine
.ORG OC0Aaddr  JMP timer0_compareMatch_A_Routine
.ORG OC0Baddr  JMP timer0_compareMatch_B_Routine
 
MAIN:
 
	  LDI R20,HIGH(RAMEND)
	  OUT SPH,R20
	  LDI R20,LOW(RAMEND)
	  OUT SPL,R20
 
	  //Setting input ports for sensor input
	  CBI DDRB,2
	  CBI DDRB,3
	  //Set 
 
	  //Right Motor Configuration with Timer2
	  SBI DDRB,1
	  SBI DDRD,5
          SBI DDRD,4
 
	  SBI PORTD,5
	  CBI PORTD,4
 
	  LDI R20,239
	  STS OCR2A,R20
 
	  LDI R20,(1<<WGM21)
	  STS TCCR2A,R20							
 
	  LDI R20,0x01
	  STS TCCR2B,R20							
 
	  LDI R20,(1<<OCIE2A)	| (1<<OCIE2B)
	  STS TIMSK2,R20
	  //Right motor configured
 
	  //Left Motor Configuration with Timer0
	  SBI DDRB,0
	  SBI DDRD,7
	  SBI DDRD,6
 
	  SBI PORTD,7
	  CBI PORTD,6
 
	  LDI R20,239
	  OUT OCR0A,R20
 
	  LDI R20,(1<<WGM01)
	  OUT TCCR0A,R20							
 
	  LDI R20,0x01
	  OUT TCCR0B,R20							
 
	  LDI R20,(1<<OCIE0A)	| (1<<OCIE0B)
	  STS TIMSK0,R20
	  //Left Motor Configured
 
	  SEI						
 
 HERE:
		SBIS PINB,2	//Right sensor
		LDI R20,100
		OUT OCR0B,R20
		SBIC PINB,2
		LDI R20,30
		OUT OCR0B,R20
 
		SBIS PINB,3	//Left sensor
		LDI R21,100
		STS OCR2B,R21
		SBIC PINB,3
		LDI R21,30
		STS OCR2B,R21
 
		JMP HERE
 
timer2_compareMatch_A_Routine:							;Controls right motor
 
  CBI PORTB,1
  RETI 
 
timer2_compareMatch_B_Routine:							;Controls right motor
 
  SBI PORTB,1
  RETI 
 
timer0_compareMatch_A_Routine:							;Controls left motor
 
  CBI PORTB,0
  RETI 
 
timer0_compareMatch_B_Routine:							;Controls left motor
 
  SBI PORTB,0
  RETI
