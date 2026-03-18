        [org 0x7c00]
        [bits 16]
        ;       tokens
        TOKEN_EOF    equ 0
        TOKEN_IDENT  equ 1
        TOKEN_NUMBER equ 2
        ;       All other tokens are the same as the ascii value

        ;       notice the equality
        ;       Must align to 256 bytes
        SYMTOTOK     equ 0x6000

        ;       sizeof(identifier)
        IDENT_SIZE   equ 8
        ;       stack is not our problem
        ;       if sp == 0, and 8086 stack is pre decrement
        ;       then first push will make it ss:fffe, which is fine, and safe
_start: cld
        mov     bx, SYMTOTOK
        mov     si, unget
        ;       cs must be zero for NORMAL BIOS's anyway
        ;       ss, es, ds is NOT our problem
        xor     ax, ax
        ;       mov dx,0
        ;       dl must be zero, dh must be prev
        cwd
        ;       [0..255] := EOF
        mov     di, bx
        mov     cx, ax
        inc     ch
        repe    stosb
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
        %include "tok.S"
        times   510-($-$$) nop
        dw      0xAA55
unget:  db 0
identifier:
        times IDENT_SIZE db 0
