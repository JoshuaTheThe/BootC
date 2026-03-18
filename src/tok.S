        ;       TOK.S
        ;       FETCH THE NEXT TOKEN IN $AL, STORE PREV IN $DH
next:   mov     di, identifier
        mov     cl, IDENT_SIZE
nextlp: mov     al, byte[si]
        test    al, al
        je      nextchr
nextun: mov     byte[si], dl
        jmp     tok
nextchr:xor     ax,ax   ; read(stdin,&al,1,1)
        int     0x16    ; echo(al)
        mov     ah,0xE
        int     0x10
tok:    mov     ah, al
        xlat
classif:cmp     al, TOKEN_IDENT
        je      ident
        cmp     dh, TOKEN_IDENT
        jne     fall
        jmp     ungetx
ident:  mov     al, ah
        stosb
        mov     dh, TOKEN_IDENT
        loop    nextlp
        dec     di
        mov     byte[di], dl
ungetx: ;       UnGet
        mov     byte[si], ah
fall:   ;       otherwise, fall through unless we are the termination of an identifier
        mov     dh, al
        jc      override_ident
        ;       grab next token
        jmp     next
override_ident:
        mov     al, TOKEN_IDENT
        ;       grab next token
        jmp     next