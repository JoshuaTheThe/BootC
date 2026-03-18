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
        %include "init.S"
forever:call    next
        jmp     forever
        %include "tok.S"
        times   510-($-$$) nop
        dw      0xAA55
unget:  db 0
identifier:
        times IDENT_SIZE db 0
