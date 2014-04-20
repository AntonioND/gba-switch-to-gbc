
; -----------------------------------------------------------------------------------------------------------------

0000018C E3A0C301 mov     r12,#0x4000000   ; FUNCTION something | r12 = 0x04000000
00000190 E3A02004 mov     r2,#0x4          ; r2 = 0x4
00000194 E5CC2001 strb    r2,[r12,#0x1]    ; DISPCNT(15:8) = 0x4
00000198 E3A02008 mov     r2,#0x8          ; r2 = 0x8
0000019C E5CC2000 strb    r2,[r12]         ; DISPCNT(7:0) = 0x8 -> Video mode 0, GBC mode enabled, BG2 enabled
; Code now falls to WAIT VBL. It seems that GBC mode begins when HALTCNT is written.
000001A0 E3A02000 mov     r2,#0x0          ; FUNCTION WAIT VBL/WAIT IRQ | r2 = 0
000001A4 EA000000 b       #0x1AC           ; Skip next instruction
000001A8 E3A02080 mov     r2,#0x80
000001AC E3A0C301 mov     r12,#0x4000000   ; r12 = 0x04000000
000001B0 E5CC2301 strb    r2,[r12,#0x301]  ; HALTCNT = 0
000001B4 E12FFF1E bx      r14              ; Return to 0x2D0 in THUMB mode

; -----------------------------------------------------------------------------------------------------------------

00000284 2404     mov     r4,#0x4         ; FUNCTION @ 0x00000284
00000286 0624     lsl     r4,r4,#0x18     ; r4 = 0x04000000
00000288 2505     mov     r5,#0x5
0000028A 062D     lsl     r5,r5,#0x18     ; r5 = 0x05000000
0000028C 2606     mov     r6,#0x6
0000028E 0636     lsl     r6,r6,#0x18     ; r6 = 0x06000000
00000290 2100     mov     r1,#0x0         ; r1 = 0x00000000
00000292 20C2     mov     r0,#0xC2        ; r0 = 0x000000C2
00000294 1C22     mov     r2,r4
00000296 3280     add     r2,#0x80        ; r2 = 0x04000080
00000298 7090     strb    r0,[r2,#0x2]    ; SOUNDCNT_H(7:0) = 0xC2 --- SOUNDCNT_H = 0x88C2
0000029A 7250     strb    r0,[r2,#0x9]    ; SOUNDBIAS(15:8) = 0xC2 --- SOUNDBIAS = 0xC200 (6 bit, 262.144kHz)
0000029C 20FF     mov     r0,#0xFF
0000029E 1C80     add     r0,r0,2         ; r0 = 0x00000101
000002A0 22A0     mov     r2,#0xA0        ; r2 = 0x000000A0
000002A2 2390     mov     r3,#0x90        ; r3 = 0x00000090
000002A4 9600     str     r6,[sp]         ; [sp] = 0x06000000 (sp = 0x3007EB8)
000002A6 27F0     mov     r7,#0xF0        ; r7 = 0x000000F0
000002A8 9701     str     r7,[sp,#0x4]    ; [sp+4] = 0x000000F0
000002AA F000FA78 bl      #0x79E          ; CALL Weird VRAM fill
000002AE 2083     mov     r0,#0x83
000002B0 01C0     lsl     r0,r0,#0x7      ; r0 = 0x4180
000002B2 81A0     strh    r0,[r4,#0xC]    ; BG2CNT = 0x4180 (r4 = 0x04000000)
000002B4 480F     ldr     r0,=#0xFFFFD800 ; r0 = 0xFFFFD800
000002B6 62A0     str     r0,[r4,#0x28]   ; BG2X = 0xFFFFD800 (-40.0)
000002B8 1400     asr     r0,r0,#0x10
000002BA 02C0     lsl     r0,r0,#0xB      ; r0 = 0xFFFFF800
000002BC 62E0     str     r0,[r4,#0x2C]   ; BG2Y = 0xFFFFF800 (-8.0)
000002BE 4B0E     ldr     r3,=#0x7FFF7BDE ; r3 = 0x7FFF7BDE
000002C0 602B     str     r3,[r5]         ; [0x05000000] = 0x7FFF7BDE (palette RAM) - Color 1 = white, Color 0 = white fade to black
000002C2 882B     ldrh    r3,[r5]         ; r3 = 0x7BDE
000002C4 4F0D     ldr     r7,=#0xC63      ; r7 = 0xC63
000002C6 0C62     lsr     r2,r4,#0x11
000002C8 1912     add     r2,r2,r4        ; r2 = 0x04000200
000002CA 8057     strh    r7,[r2,#0x2]    ; IF = 0xC63
000002CC F003FA20 bl      #0x3710         ; CALL - WAIT VBL
000002D0 2004     mov     r0,#0x4         ; r0 = 4
000002D2 7060     strb    r0,[r4,#0x1]    ; DISPCNT(15:8) = 4 (r4 = 0x04000000)
000002D4 7020     strb    r0,[r4]         ; DISPCNT(7:0)  = 4 (Video mode 4 = 8 bit, BG2 enabled)
000002D6 1BDB     sub     r3,r3,r7        ; r3 -= 0xC63
000002D8 802B     strh    r3,[r5]         ; [0x05000000] = r3 (6F7B 6318 56B5 4A52 3DEF 318C 2529 18C6 0C63 0000)
000002DA DCF4     bgt     #0x2C6          ; Loop -> Fade screen
000002DC 43C8     mvn     r0,r1           ; r0 = 0xFFFFFFFF
000002DE 9002     str     r0,[sp,#0x8]    ; [sp+8] = 0xFFFFFFFF (sp = 0x03007EB8)
000002E0 34D4     add     r4,#0xD4        ; r4 = 0x040000D4
000002E2 A902     add     r1,sp,#0x8      ; r1 = sp+8 = 0x03007EC0
000002E4 6021     str     r1,[r4]         ; DMA3SAD = 0x03007EC0 ( [0x03007EC0] = 0xFFFFFFFF )
000002E6 6066     str     r6,[r4,#0x4]    ; DMA3DAD = r6 = 0x06000000 = VRAM
000002E8 4901     ldr     r1,=#0x85006000 ; Fixed source, Increment destination, 32 bit, 98304 bytes
000002EA 60A1     str     r1,[r4,#0x8]    ; DMA3CNT = 0x85006000 -> Start now - Fill 0x18000 bytes with 0xFF - All VRAM
000002EC F003FA14 bl      #0x3718         ; CALL 0x3718 - Should never return - Should switch to GBC mode
000002F0          dcd     0x85006000,0xFFFFD800,0x7FFF7BDE,0x00000C63

; -----------------------------------------------------------------------------------------------------------------

; This function sets a 160x144 rectangle in the upper left corner of the BG that uses palette color 1.
; This is the GBC screen, and the BG is scrolled to be in the middle of the GBA screen.
; The rest uses palette color 0.

0000079E B5F0     push    {r4-r7,r14}   ; FUNCTION @ 0x0000079E - Weird VRAM fill
000007A0 9C05     ldr     r4,[sp,#0x14] ; r4 = 0x06000000
000007A2 9D06     ldr     r5,[sp,#0x18] ; r5 = 0x000000F0
000007A4 2700     mov     r7,#0x0       ; r7 = 0
000007A6 2600     mov     r6,#0x0       ; r6 = 0
000007A8 53A0     strh    r0,[r4,r6]    ; [0x06000000 + r6] = 0x101 ; change 2 pixels each time
000007AA 1840     add     r0,r0,r1      ; r0 += 0 (r1 = 0)
000007AC 1CB6     add     r6,r6,2       ; r6 += 2 ; change 2 pixels each time
000007AE 4296     cmp     r6,r2         ; cmp r6,0xA0 (= 160)
000007B0 DBFA     blt     #0x7A8        ; if (r6 < 0xA0) inner loop
000007B2 1964     add     r4,r4,r5      ; r4 += 0xF0
000007B4 1C7F     add     r7,r7,1       ; r7 += 1
000007B6 429F     cmp     r7,r3         ; cmp r7,0x90 (= 144)
000007B8 DBF5     blt     #0x7A6        ; if (r7 < 0x90) outer loop
000007BA BDF0     pop     {r4-r7,r15}   ; return to 0x2AE

; -----------------------------------------------------------------------------------------------------------------

; DMAxxxx = 0
; BGnCNT, BGnH/VOFS = 0, BG2X/Y = 0, BG3X/Y = 0, BG2A..D = 0 or 0x100; BG3A..D = 0 o 0x100
; WIN0H/V = 0, WIN1H/V = 0, WININ = 0, WINOUT = 0
; MOSAIC = 0, BLDCNT = 0, BLDALPHA = 0, BLDY = 0
; GREENSWP = 0
; SOUNDnCNT_L,H,X = 0, SOUNDCNT_L = 0, SOUNDCNT_X = 0


; *************************************** START HERE ***************************************

........ ........ ...     ...
 
0000194E 4EF8     ldr     r6,=#0x4000200
00001950 2008     mov     r0,#0x8
00001952 05C1     lsl     r1,r0,#0x17
00001954 8035     strh    r5,[r6] ; IE = 1 (Enable VBL IRQ) (IME = 0) 
00001956 8088     strh    r0,[r1,#0x4] ; DISPSTAT = 8 (VBL IRQ enable)
00001958 88B0     ldrh    r0,[r6,#0x4] ; Read WAITCNT
0000195A 0BC0     lsr     r0,r0,#0xF   ; Check WAITCNT(15)
0000195C D001     beq     #0x1962 ; Skip next instruction if WAITCNT(15) = 0 (GBA game)
0000195E F7FEFC91 bl      #0x284 ; CALL SWITCH TO GBC MODE - Should never return
00001962 F7FEFF87 bl      #0x874

........ ........ ...     ...

; -----------------------------------------------------------------------------------------------------------------

00003710 4778     bx      r15 ; FUNCTION @ 0x00003710 - WAIT VBL? WAIT IRQ?
00003712 0000     lsl     r0,r0,#0x0 ; Switch to ARM at 0x00003714
00003714 EAFFF2A1 b       #0x1A0 ; Jump to 0x1A0

; -----------------------------------------------------------------------------------------------------------------

00003718 4778     bx      r15  ; FUNCTION @ 0x00003718
0000371A 0000     lsl     r0,r0,#0x0 ; Switch to ARM at 0x0000371C
0000371C EAFFF29A b       #0x18C ; Jump to 0x18C

; -----------------------------------------------------------------------------------------------------------------
