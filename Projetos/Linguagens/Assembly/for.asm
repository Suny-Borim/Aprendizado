.model small
.data
    valores db 55,54, 51 ,48 , 49, 50,54, 0Ah,0Dh, "$"
    tamanho dw 7   
    
.code  
    printc macro car
        mov ah,02h
        int 21h
    endm
    
    mov ax, @data
    mov ds,ax
    mov si, 0
    looping:
    printc valores[si] 
   
        inc si 
        cmp si,tamanho
        je exit
        jmp looping 
        
    exit:    
    mov ah, 4ch
    int 21h
  end 