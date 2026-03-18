        ;       INIT.S
        ;       Initialise the tokeniser data
        ;       [..] := tokenfor(chr)
init:   ;       we know the buffer aligns to 256, therefore
        mov     ax, di
        stosb
        inc     al
        ;       all ascii value are 0..127
        jno     init
        ; unget (normally zero anyway)
        ; mov     byte[si - (symtotok - unget)], dl
        mov     di, SYMTOTOK + 'A'
        mov     cl, 26
        push    cx
        mov     al, TOKEN_IDENT
        repe    stosb
        add     di, 6
        pop     cx
        repe    stosb