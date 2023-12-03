.equ SREG, 0x3f
.equ PORTB, 0x05 
.equ DDRB, 0x04
.equ PORTD, 0x0B
.equ DDRD, 0x0A
.org 0


main: 
; Display K-number K21134158 from left to right
display_knumber:
         ldi r16, 0
         out SREG, r16
         ldi r16, 0x0F
         out DDRB, r16
         ldi r16, 0xF0
         out DDRD, r16         
         ldi r17,0x02    
         out PORTB, r17          
         call second 
         ldi r17, 0x01   
         out PORTB, r17
         call second
         ldi r17, 0x01    
         out PORTB, r17 
         call second
         ldi r17, 0x03
         out PORTB, r17 
         call second
         ldi r17, 0x04
         out PORTB, r17 
         call second
         ldi r17, 0x01
         out PORTB, r17 
         call second
         ldi r17, 0x05
         out PORTB, r17 
         call second
         ldi r17, 0x08
         out PORTB, r17
         call second
         ldi r17, 0x00
         out PORTB, r17
         call second

; Display my initials "J.X" 
;"J" 0x0A 00001010
;"." 0x1B 00011011
;"X" 0x18 00011000
display_initials:
        ldi r17, 0x0A
        out PORTB, r17
        call second
        ldi r17, 0x1B
        out PORTB, r17
        out PORTD, r17
        call second
        ldi r17, 0x18
        out PORTB, r17
        out PORTD, r17
        call second
        ldi r17, 0x00
        out PORTB, r17
        out PORTD, r17
        call second
; Display Morse Code "JIA"
; make r29 as odd/even flag
; use neg(two's complement) to toggle r29, when r29 is 1, neg r29 is 0, and when r29 is 1, neg r29 is 0.  
        ldi r16,0x0F        
        out DDRB, r16
        ldi r16,0xf0 
        out DDRD, r16 
        ldi r28, 50
        ldi r29, 1 ;odd/even flag, 1 for odd, 0 for even

morse_code_loop: 
        ldi r24, 0x00
        ldi r25, 0xFF
        out PORTB, r24
        out PORTD, r24

        cpi r29, 1
        breq display_JIA
        call display_AIJ
        ;check if the iteration number is divisible by 5
        
       
check1: mov r17, r28         
        call divide_by_5
        cpi r18, 0 
        brne update_iteration ; if not, then go on 
        call display_5  ; if equal, display 5

update_iteration:        
        cpi r28, 0
        brne morse_code_loop         
        rjmp ping_pong_loop

ping_pong_loop:      
        ldi r16, 0x08
        out PORTB, r16
        call delay
        lsr r16
        out PORTB, r16
        call delay
        lsr r16
        out PORTB, r16
        call delay
        lsr r16
        out PORTB, r16
        call delay
        lsl r16
        out PORTB, r16
        call delay
        lsl r16
        out PORTB, r16
        call delay
        rjmp ping_pong_loop

mainloop: rjmp mainloop

display_JIA:
        out PORTB, r25
        out PORTD, r25
        call delay
        out PORTB, r24
        out PORTD, r24
        call delay
        out PORTB, r25
        out PORTD, r25
        call delay_dash
        out PORTB, r24
        out PORTD, r24
        call delay        
        out PORTB, r25
        out PORTD, r25
        call delay_dash
        out PORTB, r24
        out PORTD, r24
        call delay
        out PORTB, r25
        out PORTD, r25
        call delay_dash
        out PORTB, r24
        out PORTD, r24
        call delay_dash
        out PORTB, r25
        out PORTD, r25
        call delay
        out PORTB, r24
        out PORTD, r24
        call delay
        out PORTB, r25
        out PORTD, r25
        call delay
        out PORTB, r24
        out PORTD, r24
        call delay_dash
        out PORTB, r25
        out PORTD, r25
        call delay
        out PORTB, r24
        out PORTD, r24
        call delay
        out PORTB, r25
        out PORTD, r25
        call delay_dash
        out PORTB, r24
        out PORTD, r24
        call delay_dash ;600ms
        call delay_dash ;600ms
        call delay      ;200ms
    
        dec r28
        neg r29
        call check1

display_5:
         ldi r26, 5

loop4:   out PORTB, r25
         out PORTD, r25
         call delay
         out PORTB, r24
         out PORTD, r24
         call delay
         
         dec r26
         cpi r26, 0
         brne loop4
         call delay_dash
         call delay_dash
         rjmp update_iteration

divide_by_5:
         clr r18           ; clear r18
         
go_on:
         cpi r17, 5
         brge loop5
         ldi r18, 1
         ret
         
loop5:   subi r17, 5       ; subtract 5 from r17, r17=r28=50
         cpi r17,0
         brne go_on        ; if result is 0, it can be divide
         ldi r18, 0
         ret

; delay for 600ms
delay_dash:ldi r23, 3
loop3:     call delay
           dec r23
           cpi r23,0
           brne loop3
           ret

; delay for 1s
second:    ldi r22, 5
loop2:     call delay
           dec r22
           cpi r22, 0
           brne loop2
           ret
            
; delay for 200ms
delay:    ldi r19, 255
          ldi r20, 255
          ldi r21, 10
loop1:    nop
          dec r19
          cpi r19, 0
          brne loop1
          ldi r19, 255
          dec r20
          cpi r20, 0
          brne loop1
          ldi r20, 255
          dec r21
          cpi r21, 0
          brne loop1
          ret

display_AIJ:
        out PORTB, r25
        out PORTD, r25
        call delay
        out PORTB, r24
        out PORTD, r24
        call delay
        out PORTB, r25
        out PORTD, r25
        call delay_dash
        out PORTB, r24
        out PORTD, r24
        call delay_dash ;600ms
        out PORTB, r25
        out PORTD, r25
        call delay
        out PORTB, r24
        out PORTD, r24
        call delay
        out PORTB, r25
        out PORTD, r25
        call delay
        out PORTB, r24
        out PORTD, r24
        call delay_dash
        out PORTB, r25
        out PORTD, r25
        call delay
        out PORTB, r24
        out PORTD, r24
        call delay
        out PORTB, r25
        out PORTD, r25
        call delay_dash
        out PORTB, r24
        out PORTD, r24
        call delay
        out PORTB, r25
        out PORTD, r25
        call delay_dash
        out PORTB, r24
        out PORTD, r24
        call delay
        out PORTB, r25
        out PORTD, r25
        call delay_dash
        out PORTB, r24
        out PORTD, r24
        call delay_dash ;600ms
        call delay_dash ;600ms
        call delay      ;200ms
        
        dec r28
        neg r29       
        call check1



