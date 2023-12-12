ORG 100h        ;Comeca a funcionar a partir do h, para nao afetar o que nao deve

; Imprime mensagem    
mov dx, offset msg1
mov ah, 9
int 21h

; Scan numero
call scan_num
mov num, cx

; Pula Linha:
PUTC 0Dh
PUTC 0Ah

MOV     AX, num
MOV     n1, AX
MOV     AX, n1      ;Copia n1 em AL
DIV     div3        ; AL/div1 -> Resto salvo em AH
CMP     AH, 0       ;Verifica se AH - 0 = 0
 

JE     divisivel_por_3      ;Se for divisivel por 3
JMP    n_divisivel_por_3    ;Se NAO for divisivel por 3


divisivel_por_3:

    MOV     AX, n1
    MOV     BL, div5         ;Mesmo procedimento 
    DIV     BL
    CMP     AH, 0
    
    JE     divisivel_por_5              ;Se for divisivel por 5
    JMP     divisivel_apenas_por_3      ;Se for divisivel apenas por 3 

n_divisivel_por_3:

    MOV     AX, n1
    MOV     BL, div5         ;Mesmo procedimento
    DIV     BL
    CMP     AH, 0
    
JE     divisivel_apenas_por_5       ;Se for divisivel apenas por 5
JMP    n_divisivel_por_nenhum       ;Se nao for divisivel por nenhum dos dois 

divisivel_por_5:

    LEA DX, fizzbuzz_msg
    
    JMP     stop

divisivel_apenas_por_5:

    LEA DX, buzz_msg
    
    JMP     stop

divisivel_apenas_por_3:

    LEA DX, fizz_msg
    
    JMP     stop

n_divisivel_por_nenhum:

    LEA DX, fudeu_msg

stop:

MOV AH, 9
INT 21h

RET ;Parar programa  
  
  
; Variaveis
n1   DW 7  
div3 DB 3
div5 DB 5 
num dw ?
  
  
; Prints:
fizzbuzz_msg DB "FIZZBUZZ $"
fizz_msg DB "FIZZ $"
buzz_msg DB "BUZZ $"
fudeu_msg DB "FUDEU :b $"

msg1 db "Digite um numero: $"
msg2 db "Numero digitado: $"


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; these functions are copied from emu8086.inc ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; this macro prints a char in AL and advances
; the current cursor position:
PUTC    MACRO   char
        PUSH    AX
        MOV     AL, char
        MOV     AH, 0Eh
        INT     10h     
        POP     AX
ENDM

; gets the multi-digit SIGNED number from the keyboard,
; and stores the result in CX register:
SCAN_NUM        PROC    NEAR
        PUSH    DX
        PUSH    AX
        PUSH    SI
        
        MOV     CX, 0

        ; reset flag:
        MOV     CS:make_minus, 0

next_digit:

        ; get char from keyboard
        ; into AL:
        MOV     AH, 00h
        INT     16h
        ; and print it:
        MOV     AH, 0Eh
        INT     10h

        ; check for MINUS:
        CMP     AL, '-'
        JE      set_minus

        ; check for ENTER key:
        CMP     AL, 0Dh  ; carriage return?
        JNE     not_cr
        JMP     stop_input
not_cr:


        CMP     AL, 8                   ; 'BACKSPACE' pressed?
        JNE     backspace_checked
        MOV     DX, 0                   ; remove last digit by
        MOV     AX, CX                  ; division:
        DIV     CS:ten                  ; AX = DX:AX / 10 (DX-rem).
        MOV     CX, AX
        PUTC    ' '                     ; clear position.
        PUTC    8                       ; backspace again.
        JMP     next_digit
backspace_checked:


        ; allow only digits:
        CMP     AL, '0'
        JAE     ok_AE_0
        JMP     remove_not_digit
ok_AE_0:        
        CMP     AL, '9'
        JBE     ok_digit
remove_not_digit:       
        PUTC    8       ; backspace.
        PUTC    ' '     ; clear last entered not digit.
        PUTC    8       ; backspace again.        
        JMP     next_digit ; wait for next input.       
ok_digit:


        ; multiply CX by 10 (first time the result is zero)
        PUSH    AX
        MOV     AX, CX
        MUL     CS:ten                  ; DX:AX = AX*10
        MOV     CX, AX
        POP     AX

        ; check if the number is too big
        ; (result should be 16 bits)
        CMP     DX, 0
        JNE     too_big

        ; convert from ASCII code:
        SUB     AL, 30h

        ; add AL to CX:
        MOV     AH, 0
        MOV     DX, CX      ; backup, in case the result will be too big.
        ADD     CX, AX
        JC      too_big2    ; jump if the number is too big.

        JMP     next_digit

set_minus:
        MOV     CS:make_minus, 1
        JMP     next_digit

too_big2:
        MOV     CX, DX      ; restore the backuped value before add.
        MOV     DX, 0       ; DX was zero before backup!
too_big:
        MOV     AX, CX
        DIV     CS:ten  ; reverse last DX:AX = AX*10, make AX = DX:AX / 10
        MOV     CX, AX
        PUTC    8       ; backspace.
        PUTC    ' '     ; clear last entered digit.
        PUTC    8       ; backspace again.        
        JMP     next_digit ; wait for Enter/Backspace.
        
        
stop_input:
        ; check flag:
        CMP     CS:make_minus, 0
        JE      not_minus
        NEG     CX
not_minus:

        POP     SI
        POP     AX
        POP     DX
        RET
make_minus      DB      ?       ; used as a flag.
SCAN_NUM        ENDP                             

ten             DW      10      ; used as multiplier/divider by SCAN_NUM & PRINT_NUM_UNS.          