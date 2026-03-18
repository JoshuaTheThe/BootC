        ;       TOK.S
        ;       FETCH THE NEXT TOKEN IN $AL, STORE PREV IN $DH
        ;       len = 0
next:   mov     di, identifier
        ;       remaining = 32
        mov     cl, IDENT_SIZE
nextlp: mov     al, byte[si]
        ;       if unget { tmp = unget } else { goto nextchr; }
        test    al, al
        je      nextchr
        ;       unget = 0;
nextun: mov     byte[si], dl
        jmp     tok
        ;       read(stdin,&chr,1)
        ;       putc(chr)
nextchr:xor     ax,ax
        int     0x16
        mov     ah,0xE
        int     0x10
        ;       chr = tmp
tok:    mov     ah, al
        ;       current = sym_to_token[tmp]
        xlat
        ;       if tok  == identifier { goto ident; }
        ;       else if prev == identifier { goto fall; }
        ;       else { goto fall_id; }
classif:cmp     al, TOKEN_IDENT
        je      ident
        cmp     dh, TOKEN_IDENT
        je      fall_id
        jmp     fall
        ;       *ide[len ++] = chr
ident:  mov     al, ah
        stosb
        ;       prev = identifier
        mov     dh, TOKEN_IDENT
        loop    nextlp
        ;       *ide[len - 1] = 0
fall_id:mov     byte[di], dl
        ;       unget
        mov     byte[si], ah
        ;       current = identifier
        mov     al, TOKEN_IGNORE
        ;       prev = current
fall:   mov     dh, al
        ;       yield
        ret
