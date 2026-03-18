        [org 0x7c00]
        [bits 16]
        ;       tokens
        TOKEN_EOF    equ 0
        TOKEN_MUL    equ 1
        TOKEN_ADD    equ 2
        TOKEN_SUB    equ 3
        TOKEN_DIV    equ 4
        TOKEN_LPAREN equ 5
        TOKEN_RPAREN equ 6
        TOKEN_IDENT  equ 7
        TOKEN_NUMBER equ 8

        ;       notice the equality
        SYMTOTOK     equ 0x6000
        STACKTOP     equ SYMTOTOK

        ;       sizeof(identifier)
        IDENT_SIZE   equ 8
_start: cld
        mov     sp, STACKTOP
        mov     bx, sp
        mov     si, unget
        ;       cs must be zero for NORMAL BIOS's anyway
        ;       ss, es, ds is NOT our problem
        xor     ax, ax
        mov     dx, ax ; dx must always be zero
        ;       [0..255] := EOF
        mov     di, bx
        mov     cx, ax
        inc     ch
        repe    stosb
        ;       [..] := tokenfor(chr)
init:   mov     byte[bx + '*'], TOKEN_MUL
        mov     byte[bx + '+'], TOKEN_ADD
        mov     byte[bx + '-'], TOKEN_SUB
        mov     byte[bx + '/'], TOKEN_DIV
        mov     byte[bx + '('], TOKEN_LPAREN
        mov     byte[bx + ')'], TOKEN_RPAREN
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
next:   mov     di, identifier
        mov     cl, IDENT_SIZE
        clc
nextlp: cmp     byte[si], dl
        je      nextchr
nextun: mov     al, byte[si]
        mov     byte[si], dl
        jmp     classif
nextchr:xor     ax,ax   ; read(stdin,&al,1,1)
        int     0x16    ; echo(al)
        mov     ah,0xE
        int     0x10
tok:    mov     ah, al
        xlat
classif:cmp     al, TOKEN_IDENT
        jne     fall
        mov     al, ah
        stosb
        stc
        loop    nextlp
        dec     di
        mov     byte[di], dl
        mov     byte[si], ah
fall:   ;       otherwise, fall through unless we are the termination of an identifier
        ; mov     [token], al ; debug
        jc      override_ident
        ;       grab next token
        jmp     next
override_ident:
        mov     al, TOKEN_IDENT
        ;       grab next token
        jmp     next
        times   510-($-$$) nop
        dw      0xAA55
unget:  db 0
; token:  db 0
identifier:
        times IDENT_SIZE db 0
