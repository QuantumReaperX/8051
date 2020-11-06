;**************************************************;
;   -----------D' Number Guessing Game-------------; 
;   CPE108L/OL100                                  ;
;   Submitted by:                                  ;
;   GROUP 1                                        ;
;   Martinez, Roland P.                            ;
;   Sangani, Mansi A,                              ;
;   Ibasco, Hiede Geene D.                         ;
;   Nagayo, Paolo  A,                              ;
;                                                  ;
;   Submitted to:                                  ;
;   Engr. Cyrel O. Manlises                        ; 
;**************************************************;

ORG 000H ;starting address location

CALL setString1 ;directly calls setString1 subroutine to display data to LCD

GameStart: ;LCD setString1 data 
    MOV A, #0 ;starting value in accumulator

    MOV 30H, #'G' ;starting address and data to display to lcd
    MOV 31H, #'U'
    MOV 32H, #'E'
    MOV 33H, #'S'
    MOV 34H, #'S'
    MOV 35H, #' '
    MOV 36H, #'T'
    MOV 37H, #'H'
    MOV 38H, #'E'
    MOV 39H, #' '
    MOV 3AH, #'N'
    MOV 3BH, #'U'
    MOV 3CH, #'M'
    MOV 3DH, #'B'
    MOV 3EH, #'E'
    MOV 3FH, #'R'
    MOV 40H, #0    ; end of data marker

    ;initializing the display
    CLR P1.3;clear pin RS to select register (0-instruction register for write and busy flag: address counter for read)
    ;indicate that instructions are being sent to the module
    ;function set
    CLR P1.7 
    CLR P1.6 
    SETB P1.5 
    CLR P1.4 ; | high nibble set
    SETB P1.2 
    CLR P1.2 ; | negative edge on E
    CALL delay ; wait for BF to clear
    ; function set sent for first time - tells module to
    ; go into 4-bit mode
    SETB P1.2 ; |
    CLR P1.2 ; | negative edge on E
    ; same function set high nibble sent a second time
    SETB P1.7 ; low nibble set (only P1.7 needed to be changed)
    SETB P1.2 ; |
    CLR P1.2 ; | negative edge on E
    ; function set low nibble sent
    CALL delay ; wait for BF to clear
    ; entry mode set
    ; set to increment with no shift
    CLR P1.7 ; |
    CLR P1.6 ; |
    CLR P1.5 ; |
    CLR P1.4 ; | high nibble set
    SETB P1.2 ; |

    CLR P1.2 ; | negative edge on E
    SETB P1.6 ; |
    SETB P1.5 ; |low nibble set
    SETB P1.2 ; |
    CLR P1.2 ; | negative edge on E
    CALL delay ; wait for BF to clear
    ; display on/off control
    ; the display is turned on, the cursor is turned on and blinking is turned on
    CLR P1.7 ; |
    CLR P1.6 ; |
    CLR P1.5 ; |
    CLR P1.4 ; | high nibble set
    SETB P1.2 ; |
    CLR P1.2 ; | negative edge on E
    SETB P1.7 ; |
    SETB P1.6 ; |
    SETB P1.5 ; |
    SETB P1.4 ; | low nibble set
    SETB P1.2 ; |
    CLR P1.2 ; | negative edge on E
    CALL delay ; wait for BF to clear
    ; send data
    SETB P1.3 ; clear RS - indicates that data is being sent to
    ; module

loop0:
    MOV A, @R1 ; move data pointed to by R1 to A
    JZ LCD_Clear ; if A is 0, then end of data has been reached ? jump
            ; out of loop
    CALL LCD_SetCharacter ; send data in A to LCD module
    INC R1 ; point to next piece of data
    JMP loop0 ; repeat

LCD_Clear:
    CLR P1.3
    CLR P1.7 ; |
    CLR P1.6 ; |
    CLR P1.5 ; |
    CLR P1.4 ; | high nibble set
    SETB P1.2 ; |
    CLR P1.2 ; | negative edge on E
    SETB P1.4 ;set to clear the display
    SETB P1.2 ; |
    CLR P1.2 ; | negative edge on E
    CALL delay2 ; wait for BF to clear
    SETB P1.3
    CALL delay2
    CALL setString2
    JMP LCD_Display

LCD_SetCharacter:
    MOV C, ACC.7 ; |
    MOV P1.7, C ; |
    MOV C, ACC.6 ; |
    MOV P1.6, C ; |
    MOV C, ACC.5 ; |
    MOV P1.5, C ; |
    MOV C, ACC.4 ; |
    MOV P1.4, C ; | high nibble set
    SETB P1.2 ; |
    CLR P1.2 ; | negative edge on E

    MOV C, ACC.3 ; |
    MOV P1.7, C ; |
    MOV C, ACC.2 ; |
    MOV P1.6, C ; |
    MOV C, ACC.1 ; |
    MOV P1.5, C ; |
    MOV C, ACC.0 ; |
    MOV P1.4, C ; | low nibble set
    SETB P1.2 ; |
    CLR P1.2 ; | negative edge on E
    CALL delay ; wait for BF to clear

delay: ; time delay
    MOV R0, #50H
    DJNZ R0, $
    RET

delay2: ;time delay
    MOV R0, #0FFH
    DJNZ R0, $
    RET

LCD_Display: ;start guessing data selected after setString2
    MOV A, #0 ;starting value in accumulator
    
    MOV 41H, #'S' ;starting address and data to display to lcd
    MOV 42H, #'T'
    MOV 43H, #'A'
    MOV 44H, #'R'
    MOV 45H, #'T'
    MOV 46H, #' '
    MOV 47H, #'G'
    MOV 48H, #'U'
    MOV 49H, #'E'
    MOV 4AH, #'S'
    MOV 4BH, #'S'
    MOV 4CH, #'I'
    MOV 4DH, #'N'
    MOV 4EH, #'G'
    MOV 4FH, #'!'
    MOV 50H, #0  ;end of data marker end
    JMP LCD_Command ; Jumps to LCD_Command

LCD_Command:
;initializing the display
    CLR P1.3;clear pin RS to select register (0-instruction register for write and busy flag: address counter for read)
    ;indicate that instructions are being sent to the module
    ;function set
    CLR P1.7 
    CLR P1.6 
    SETB P1.5 
    CLR P1.4 ; | high nibble set
    SETB P1.2 
    CLR P1.2 ; | negative edge on E
    CALL delay3 ; wait for BF to clear
    ; function set sent for first time - tells module to
    ; go into 4-bit mode
    SETB P1.2 ; |
    CLR P1.2 ; | negative edge on E
    ; same function set high nibble sent a second time
    SETB P1.7 ; low nibble set (only P1.7 needed to be changed)
    SETB P1.2 ; |
    CLR P1.2 ; | negative edge on E
    ; function set low nibble sent
    CALL delay3 ; wait for BF to clear
    ; entry mode set
    ; set to increment with no shift
    CLR P1.7 ; |
    CLR P1.6 ; |
    CLR P1.5 ; |
    CLR P1.4 ; | high nibble set
    SETB P1.2 ; |

    CLR P1.2 ; | negative edge on E
    SETB P1.6 ; |
    SETB P1.5 ; |low nibble set
    SETB P1.2 ; |
    CLR P1.2 ; | negative edge on E
    CALL delay3 ; wait for BF to clear
    ; display on/off control
    ; the display is turned on, the cursor is turned on and blinking is turned on
    CLR P1.7 ; |
    CLR P1.6 ; |
    CLR P1.5 ; |
    CLR P1.4 ; | high nibble set
    SETB P1.2 ; |
    CLR P1.2 ; | negative edge on E
    SETB P1.7 ; |
    SETB P1.6 ; |
    SETB P1.5 ; |
    SETB P1.4 ; | low nibble set
    SETB P1.2 ; |
    CLR P1.2 ; | negative edge on E
    CALL delay3 ; wait for BF to clear
    ; send data
    SETB P1.3 ; clear RS - indicates that data is being sent to
    ; module

loop1:
    MOV A, @R1 ; move data pointed to by R1 to A
    JZ LCD_Clear1 ; if A is 0, then end of data has been reached ? jump
            ; out of loop
    CALL LCD_SetCharacter1 ; send data in A to LCD module
    INC R1 ; point to next piece of data
    JMP loop1 ; repeat

LCD_Clear1: ;clearing lcd content to prep for new batch of data
    CLR P1.3
    CLR P1.7 ; |
    CLR P1.6 ; |
    CLR P1.5 ; |
    CLR P1.4 ; | high nibble set
    SETB P1.2 ; |
    CLR P1.2 ; | negative edge on E
    SETB P1.4 ;set to clear the display
    SETB P1.2 ; |
    CLR P1.2 ; | negative edge on E
    CALL delay4 ; wait for BF to clear
    SETB P1.3
    CALL countloop ;started count at 5 on SSD
    CALL keycheck ;Jumps to keycheck

LCD_SetCharacter1: ;setting characters to lcd
    MOV C, ACC.7 ; |
    MOV P1.7, C ; |
    MOV C, ACC.6 ; |
    MOV P1.6, C ; |
    MOV C, ACC.5 ; |
    MOV P1.5, C ; |
    MOV C, ACC.4 ; |
    MOV P1.4, C ; | high nibble set
    SETB P1.2 ; |
    CLR P1.2 ; | negative edge on E

    MOV C, ACC.3 ; |
    MOV P1.7, C ; |
    MOV C, ACC.2 ; |
    MOV P1.6, C ; |
    MOV C, ACC.1 ; |
    MOV P1.5, C ; |
    MOV C, ACC.0 ; |
    MOV P1.4, C ; | low nibble set
    SETB P1.2 ; |
    CLR P1.2 ; | negative edge on E
    CALL delay3 ; wait for BF to clear

delay3: ;time delay
    MOV R0, #50H
    DJNZ R0, $
    RET

delay4: ;time delay
    MOV R0, #0FFH
    DJNZ R0, $
    RET



LCD_Display3: ;character set selected when correct number is pressed displayed to lcd
    MOV A, #0 ; starting content in accumulator

    MOV 51H, #'C' ;starting address and content of the string
    MOV 52H, #'O'
    MOV 53H, #'N'
    MOV 54H, #'G'
    MOV 55H, #'R'
    MOV 56H, #'A'
    MOV 57H, #'T'
    MOV 58H, #'U'
    MOV 59H, #'L'
    MOV 5AH, #'A'
    MOV 5BH, #'T'
    MOV 5CH, #'I'
    MOV 5DH, #'O'
    MOV 5EH, #'N'
    MOV 5FH, #'S'
    MOV 60H, #'!'
    MOV 61H, #0  ;end of data marker end
    JMP LCD_Command2

LCD_Display4: ;character set for incorrect string when incorrect number is pressed ;displayed in lcd
    MOV A, #0 ;starting content in the accumulator 

    MOV 62H, #'I' ;starting address ad content of the string
    MOV 63H, #'N'
    MOV 64H, #'C'
    MOV 65H, #'O'
    MOV 66H, #'R'
    MOV 67H, #'R'
    MOV 68H, #'E'
    MOV 69H, #'C'
    MOV 6AH, #'T'
    MOV 6BH, #'!'
    MOV 6CH, #0  ;end of data marker end
    JMP LCD_Command2

LCD_Display5: ;character set for gameover ;displayed in lcd 
    MOV A, #0 ;starting content of the accumulator

    MOV 6DH, #'G' ;starting address ad content of the string
    MOV 6EH, #'A'
    MOV 6FH, #'M'
    MOV 70H, #'E'
    MOV 71H, #' '
    MOV 72H, #'O'
    MOV 73H, #'V'
    MOV 74H, #'E'
    MOV 75H, #'R'
    MOV 76H, #'!'
    MOV 77H, #0  ;end of data marker end
    JMP LCD_Command2

LCD_Command2:
;initializing the display
    CLR P1.3;clear pin RS to select register (0-instruction register for write and busy flag: address counter for read)
    ;indicate that instructions are being sent to the module
    ;function set
    CLR P1.7 
    CLR P1.6 
    SETB P1.5 
    CLR P1.4 ; | high nibble set
    SETB P1.2 
    CLR P1.2 ; | negative edge on E
    CALL delay5 ; wait for BF to clear
    ; function set sent for first time - tells module to
    ; go into 4-bit mode
    SETB P1.2 ; |
    CLR P1.2 ; | negative edge on E
    ; same function set high nibble sent a second time
    SETB P1.7 ; low nibble set (only P1.7 needed to be changed)
    SETB P1.2 ; |
    CLR P1.2 ; | negative edge on E
    ; function set low nibble sent
    CALL delay5 ; wait for BF to clear
    ; entry mode set
    ; set to increment with no shift
    CLR P1.7 ; |
    CLR P1.6 ; |
    CLR P1.5 ; |
    CLR P1.4 ; | high nibble set
    SETB P1.2 ; |

    CLR P1.2 ; | negative edge on E
    SETB P1.6 ; |
    SETB P1.5 ; |low nibble set
    SETB P1.2 ; |
    CLR P1.2 ; | negative edge on E
    CALL delay5 ; wait for BF to clear
    ; display on/off control
    ; the display is turned on, the cursor is turned on and blinking is turned on
    CLR P1.7 ; |
    CLR P1.6 ; |
    CLR P1.5 ; |
    CLR P1.4 ; | high nibble set
    SETB P1.2 ; |
    CLR P1.2 ; | negative edge on E
    SETB P1.7 ; |
    SETB P1.6 ; |
    SETB P1.5 ; |
    SETB P1.4 ; | low nibble set
    SETB P1.2 ; |
    CLR P1.2 ; | negative edge on E
    CALL delay5 ; wait for BF to clear
    ; send data
    SETB P1.3 ; clear RS - indicates that data is being sent to
    ; module

loop2:
    MOV A, @R1 ; move data pointed to by R1 to A
    JZ LCD_Clear2 ; if A is 0, then end of data has been reached ? jump
            ; out of loop
    CALL LCD_SetCharacter2 ; send data in A to LCD module
    INC R1 ; point to next piece of data
    JMP loop2 ; repeat

LCD_Clear2: ;clearing lcd content to prep for new data
    CLR P1.3
    CLR P1.7 ; |
    CLR P1.6 ; |
    CLR P1.5 ; |
    CLR P1.4 ; | high nibble set
    SETB P1.2 ; |
    CLR P1.2 ; | negative edge on E
    SETB P1.4 ;set to clear the display
    SETB P1.2 ; |
    CLR P1.2 ; | negative edge on E
    CALL delay10 ; wait for BF to clear
    SETB P1.3
    CALL delay6
    CALL looper ;calls looper for counting
    CALL delay6
    JMP keycheck ;jumps directly to keycheck subroutine

LCD_SetCharacter2: ;setting characters to lcd
    MOV C, ACC.7 ; |
    MOV P1.7, C ; |
    MOV C, ACC.6 ; |
    MOV P1.6, C ; |
    MOV C, ACC.5 ; |
    MOV P1.5, C ; |
    MOV C, ACC.4 ; |
    MOV P1.4, C ; | high nibble set
    SETB P1.2 ; |
    CLR P1.2 ; | negative edge on E

    MOV C, ACC.3 ; |
    MOV P1.7, C ; |
    MOV C, ACC.2 ; |
    MOV P1.6, C ; |
    MOV C, ACC.1 ; |
    MOV P1.5, C ; |
    MOV C, ACC.0 ; |
    MOV P1.4, C ; | low nibble set
    SETB P1.2 ; |
    CLR P1.2 ; | negative edge on E
    CALL delay5 ; wait for BF to clear

delay5: ;time delay
    MOV R0, #50H
    DJNZ R0, $
    RET

delay6: ;time delay
    MOV R0, #0FFH
    DJNZ R0, $
    RET

LCD_Display6:
    MOV A, #0

    MOV 6DH, #'G'
    MOV 6EH, #'A'
    MOV 6FH, #'M'
    MOV 70H, #'E'
    MOV 71H, #' '
    MOV 72H, #'O'
    MOV 73H, #'V'
    MOV 74H, #'E'
    MOV 75H, #'R'
    MOV 76H, #'!'
    MOV 77H, #0  ;end of data marker end
    JMP LCD_Command3

LCD_Command3:
;initializing the display
    CLR P1.3;clear pin RS to select register (0-instruction register for write and busy flag: address counter for read)
    ;indicate that instructions are being sent to the module
    ;function set
    CLR P1.7 
    CLR P1.6 
    SETB P1.5 
    CLR P1.4 ; | high nibble set
    SETB P1.2 
    CLR P1.2 ; | negative edge on E
    CALL delay7 ; wait for BF to clear
    ; function set sent for first time - tells module to
    ; go into 4-bit mode
    SETB P1.2 ; |
    CLR P1.2 ; | negative edge on E
    ; same function set high nibble sent a second time
    SETB P1.7 ; low nibble set (only P1.7 needed to be changed)
    SETB P1.2 ; |
    CLR P1.2 ; | negative edge on E
    ; function set low nibble sent
    CALL delay7 ; wait for BF to clear
    ; entry mode set
    ; set to increment with no shift
    CLR P1.7 ; |
    CLR P1.6 ; |
    CLR P1.5 ; |
    CLR P1.4 ; | high nibble set
    SETB P1.2 ; |

    CLR P1.2 ; | negative edge on E
    SETB P1.6 ; |
    SETB P1.5 ; |low nibble set
    SETB P1.2 ; |
    CLR P1.2 ; | negative edge on E
    CALL delay7 ; wait for BF to clear
    ; display on/off control
    ; the display is turned on, the cursor is turned on and blinking is turned on
    CLR P1.7 ; |
    CLR P1.6 ; |
    CLR P1.5 ; |
    CLR P1.4 ; | high nibble set
    SETB P1.2 ; |
    CLR P1.2 ; | negative edge on E
    SETB P1.7 ; |
    SETB P1.6 ; |
    SETB P1.5 ; |
    SETB P1.4 ; | low nibble set
    SETB P1.2 ; |
    CLR P1.2 ; | negative edge on E
    CALL delay5 ; wait for BF to clear
    ; send data
    SETB P1.3 ; clear RS - indicates that data is being sent to
    ; module

loop3:
    MOV A, @R1 ; move data pointed to by R1 to A
    JZ LCD_Clear3 ; if A is 0, then end of data has been reached ? jump
            ; out of loop
    CALL LCD_SetCharacter3 ; send data in A to LCD module
    INC R1 ; point to next piece of data
    JMP loop3 ; repeat

LCD_Clear3:
    CLR P1.3
    CLR P1.7 ; |
    CLR P1.6 ; |
    CLR P1.5 ; |
    CLR P1.4 ; | high nibble set
    SETB P1.2 ; |
    CLR P1.2 ; | negative edge on E
    SETB P1.4 ;set to clear the display
    SETB P1.2 ; |
    CLR P1.2 ; | negative edge on E
    CALL delay10 ; wait for BF to clear
    SETB P1.3
    CALL delay10
    CALL GameStart ;call GameStart subroutine
    CALL delay10
    
LCD_SetCharacter3:
    MOV C, ACC.7 ; |
    MOV P1.7, C ; |
    MOV C, ACC.6 ; |
    MOV P1.6, C ; |
    MOV C, ACC.5 ; |
    MOV P1.5, C ; |
    MOV C, ACC.4 ; |
    MOV P1.4, C ; | high nibble set
    SETB P1.2 ; |
    CLR P1.2 ; | negative edge on E

    MOV C, ACC.3 ; |
    MOV P1.7, C ; |
    MOV C, ACC.2 ; |
    MOV P1.6, C ; |
    MOV C, ACC.1 ; |
    MOV P1.5, C ; |
    MOV C, ACC.0 ; |
    MOV P1.4, C ; | low nibble set
    SETB P1.2 ; |
    CLR P1.2 ; | negative edge on E
    CALL delay7 ; wait for BF to clear

delay7: ;time delay
    MOV R0, #50H
    DJNZ R0, $
    RET

delay8: ;time delay
    MOV R0, #0FFH
    DJNZ R0, $
    RET

keycheck: ; keypad press checking loop
    CLR P0.0       
    JB P0.4, NEXT1 ;R1C1 ;# ;exit ;jumpbyte if no press
    CALL exit ;call exit subroutine
    CALL delay10

NEXT1:
    JB P0.5, NEXT2 ;R1C2 ;0 ;jumpbyte if no press
    CALL success ;call success subroutine ;correct number
    CALL delay10

NEXT2:
    JB P0.6, NEXT3 ;R1C3 ;* ;reset
    CALL RESET ;call reset subroutine
    CALL delay10

NEXT3:
    SETB P0.0      ;R2C1 ;9 
    CLR P0.1
    JB P0.4, NEXT4 ;jumpbyte if no keypress
    CALL retry
    CALL delay10

NEXT4:
    JB P0.5, NEXT5 ;R2C2 ;8 ;jumpbyte if no keypress
    CALL retry
    CALL delay10

NEXT5:
    JB P0.6, NEXT6 ;R2C3 ;7 ;jumpbyte if no keypress
    CALL retry
    CALL delay10

NEXT6:
    SETB P0.1      ;R3C1 ;6 ;jumpbyte if no keypress
    CLR P0.2
    JB P0.4, NEXT7
    CALL retry
    CALL delay10

NEXT7:
    JB P0.5, NEXT8 ;R3C2 ;5 ;jumpbyte if no keypress
    CALL retry
    CALL delay10

NEXT8:
    JB P0.6, NEXT9 ;R3C3 ;4
    CALL retry
    CALL delay10

NEXT9:
    SETB P0.2      ;R4C1 ;3
    CLR P0.3
    JB P0.4, NEXT10 ;jumpbyte if no keypress
    CALL retry
    CALL delay10

NEXT10:
    JB P0.5, NEXT11 ;R4C2 ;2
    CALL retry
    CALL delay10

NEXT11:
    JB P0.6, keycheck ;R4C3 ;1 ;jumpbyte if no keypress
    CALL retry
    CALL delay10
    LJMP keycheck

success: ; success subroutine ;when correct number is guessed
    CLR P1.3
    CLR P1.7 ; |
    CLR P1.6 ; |
    CLR P1.5 ; |
    CLR P1.4 ; | high nibble set
    SETB P1.2 ; |
    CLR P1.2 ; | negative edge on E
    SETB P1.4 ;set to clear the display
    SETB P1.2 ; |
    CLR P1.2 ; | negative edge on E
    CALL delay10 ; wait for BF to clear
    SETB P1.3
    CALL delay10
    CALL setString3
    CALL LCD_Display3
    CALL delay10
    RET
  
reset: ; reset subroutine to start game again
    CALL GameStart 
    CALL LCD_Display
    CALL delay10
    RET

exit: ;exit subroutine to decline game
    CLR P1.3
    CLR P1.7 ; |
    CLR P1.6 ; |
    CLR P1.5 ; |
    CLR P1.4 ; | high nibble set
    SETB P1.2 ; |
    CLR P1.2 ; | negative edge on E
    SETB P1.4 ;set to clear the display
    SETB P1.2 ; |
    CLR P1.2 ; | negative edge on E
    CALL delay10 ; wait for BF to clear
    SETB P1.3
    CALL delay10
    CALL setString5
    CALL LCD_Display6
    CALL delay10
    RET

retry: ;retry subroutine for incorrect guessed
    CLR P1.3
    CLR P1.7 ; |
    CLR P1.6 ; |
    CLR P1.5 ; |
    CLR P1.4 ; | high nibble set
    SETB P1.2 ; |
    CLR P1.2 ; | negative edge on E
    SETB P1.4 ;set to clear the display
    SETB P1.2 ; |
    CLR P1.2 ; | negative edge on E
    CALL delay10 ; wait for BF to clear
    SETB P1.3
    CALL delay10
    CALL setString4
    CALL LCD_Display4
    CALL delay10
    CALL looper
    RET

gameover: ; gameover subroutine when trials reach zero
    CLR P1.3
    CLR P1.7 ; |
    CLR P1.6 ; |
    CLR P1.5 ; |
    CLR P1.4 ; | high nibble set
    SETB P1.2 ; |
    CLR P1.2 ; | negative edge on E
    SETB P1.4 ;set to clear the display
    SETB P1.2 ; |
    CLR P1.2 ; | negative edge on E
    CALL delay10 ; wait for BF to clear
    SETB P1.3
    CALL delay10
    CALL setString5
    CALL LCD_Display6
    CALL delay10
    
delay10: ;time delay for lcd display 
    MOV R0, #0FFH
    DJNZ R0, $
    RET

setString1:
    MOV R1, #30H ; data to be sent to LCD is stored in 8051 RAM,
            ; starting at location 30H
    RET

setString2:
    MOV R1, #41H ; data to be sent to LCD is stored in 8051 RAM,
            ; starting at location 41H
    RET

setString3:
    MOV R1, #51H; data to be sent to LCD is stored in 8051 RAM,
            ; starting at location 51H
    RET

setString4:
    MOV R1, #62H; data to be sent to LCD is stored in 8051 RAM,
            ; starting at location 62H
    RET

setString5:
    MOV R1, #6DH; data to be sent to LCD is stored in 8051 RAM,
            ; starting at location 6DH
    RET

countloop: ; counting keypress loop
    MOV DPTR, #SSDcodes ; data is stored in dptr for ssd counter 

looper: ; keypress is counted in ssd
    MOVC A, @A+DPTR
    INC DPTR
    SETB P3.3 ;ssd prep
    SETB P3.4
    CLR P3.3 
    CLR P3.4
    MOV P1, A ; counting down digit is displayed on ssd
    CALL delay10
    LJMP keycheck ; longjump back to keycheck subroutine

SSDcodes: ;ssd data from 5 to 0
    DB 92H, 99H, B0H, A4H, F9H, C0H

END   ;end of the program