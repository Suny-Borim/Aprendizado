.model small
.data   
 msg db 'Digite 1 para bom dia',0Dh, 0AH,'$'
 msg2 db 'Digite 2 para boa tarde',0Dh, 0AH,'$'
 msg3 db 'Digite 3 para boa noite',0Dh, 0AH,'$'
 
 dia db   0Dh,0Ah,'bom dia$'
 tarde db 0Dh,0Ah,'bom tarde$'
 noite db 0Dh,0Ah,'boa noite$'
 
.code

    mov ax,@data 
    mov ds,ax
    
    jmp pedir
       
  bom_dia: 
    lea dx,dia 
    mov ah,09h
     int 21h
     jmp cabo
     
  boa_tarde:    
    lea dx,tarde  
    mov ah,09h
    int 21h 
    jmp cabo
    
  boa_noite:  
    lea dx,noite
    mov ah,09h
    int 21h 
    jmp cabo    
    
  pedir: 
    lea dx,msg
    mov ah,09h
    int 21h
    lea dx,msg2
    mov ah,09h
    int 21h
    lea dx,msg3
    mov ah,09h
    int 21h
     
    mov ah,01h
    int 21h 
    
  cmp al,31h
  je bom_dia
  cmp al,32h
  je boa_tarde
  
  jmp boa_noite
    
  cabo:  
end  

