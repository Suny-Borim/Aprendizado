.model small
.data
    valores db 37h,36h,35h,34h,33h,"$"
    tamanho dw 3
    contador dw 0
    
.code 

    printc macro car
        mov dl,car
        mov ah,02h
        int 21h
    endm 
    
   mov ax,@data
   mov ds,ax 

 loopingprinc:  
  inc contador
  cmp contador,si
  je exit 
   mov si,0
   looping: 
   mov dh,valores[si]
   mov dl,valores[si+1] 
  cmp dh,dl
  jg swap
  inc si
  cmp si,tamanho
  je exit
  jmp looping
       swap:
        printc valores[si]
        printc valores[si+1] 
        
        mov dh,valores[si+1]
        mov dl,valores[si]  
        
        mov valores[si+1],dl
        mov valores[si],dh   
        
        printc valores[si]
        printc valores[si+1] 
        
        cmp si,tamanho
        je loopingprinc
        inc si
        jmp looping    
   prints:         
   mov si,0
   looping2:
    printc valores[si]
    inc si
     cmp si,tamanho
        je exit
        jmp looping2  
      
          
   exit:
   mov ah,4ch
   int 21h
 end       