    ; colorful
    ; Darrell Spice, Jr
    ; November 5, 2013
    ;
    ; Simple 2600 program that shows off moving bands of colors
    ;
    ; compile using DASM
    ; dasm colorful.asm -f3 -v0 -scolorful.sym -lcolorful.lst -ocolorful.bin

;========================================
; Initialize DASM
;========================================

    ; DASM supports a number of processors, this line tells DASM the code
    ; is for the 6502 CPU.  The Atari has a 6507, which is 6502 with an 8K
    ; address space and no interrupt lines.
    PROCESSOR 6502
    
    ; vcs.h contains the standard definitions for TIA and RIOT registers
    include vcs.h       
    
    ; macro.h contains commonly used routines which aid in coding
    include macro.h

    
;========================================
; Define RAM Usage
;========================================

    ; define a segment for variables
    ; .U means uninitialized, does not end up in ROM
    SEG.U VARS
    
    ; RAM starts at $80
    ORG $80             

    ; holds background color for first scanline of frame
BackgroundColor: ds 1    ; stored in $80

    ; holds playfield color for first scanline of frame
PlayfieldColor:  ds 1    ; stored in $81

    ; holds # of scanlines left for the kernel to draw
LineCount:       ds 1    ; stored in $82


;========================================
; Define Start of Cartridge
;========================================

    ; define a segment for code
    SEG CODE    
    
    ; ROM starts at $F000
    ORG $F000


;========================================
; Initialize Atari
;========================================    
    
InitSystem:
    ; CLEAN_START is a macro found in macro.h
    ; it sets all RAM, TIA registers
    ; and CPU registers to 0
    CLEAN_START
    
    ; set playfield to show vertical stripes                
    lda #$AA
    sta PF0
    sta PF2
    lda #$55
    sta PF1
             
    
;========================================
; Sync Signal
;========================================    

VerticalSync:
    lda #2      ; LoaD Accumulator with 2
    sta WSYNC   ; STore Accumulator to WSYNC, any value halts CPU until start of next scanline
    sta VSYNC   ; Accumulator D1=1, turns on Vertical Sync signal
    sta VBLANK  ; Accumulator D1=1, turns on Vertical Blank signal (image output off)
    lda #47
    sta TIM64T  ; set timer for end of Vertical Blank
    sta WSYNC   ; 1st scanline of VSYNC
    sta WSYNC   ; 2nd scanline of VSYNC
    lda #0      ; LoaD Accumulator with 0
    sta WSYNC   ; 3rd scanline of VSYNC
    sta VSYNC   ; Accumulator D1=0, turns off Vertical Sync signal
    
    
;========================================
; Vertical Blank
;========================================    
 
VerticalBlank:    
    ;==========================
    ;  game logic starts here
    ;==========================

    ; update background color for first scanline of this frame
    inc BackgroundColor
    
    ; update playfield color for first scanline this frame
    dec PlayfieldColor
    lda #199
    sta LineCount
    
    ;==========================
    ;   game logic ends here
    ;==========================
    
VBwait:
    sta WSYNC
    bit TIMINT
    bpl VBwait    ; loop until the timer ends
    
    
;========================================
; Kernel
;========================================        
    
    ; turn on video output    
    sta WSYNC
    lda #0 
    sta VBLANK
    sta COLUBK      ; color first scanline black
    sta COLUPF      ; color first scanline black
    ldx BackgroundColor
    ldy PlayfieldColor
    
    ; draw the screen
KernelLoop:   
    sta WSYNC       ; wait for start of next scanline
    stx COLUBK      ; change background color for current scanline
    sty COLUPF      ; change playfield color for current scanline
    inx             ; increase X so next scanline has a different background color
    iny             ; increase Y so next scanline has a different playfield color
    dec LineCount   ; decrease the line count
    bne KernelLoop  ; if we didn't hit 0, then draw another scanline

    
;========================================
; Overscan
;========================================  

    ; done drawing the screen
OverScan:
    sta WSYNC   ; Wait for SYNC (start of next scanline)
    lda #2      ; LoaD Accumulator with 2
    sta VBLANK  ; STore Accumulator to VBLANK, D1=1 turns image output off
    lda #23
    sta TIM64T
    
    ;===================================
    ;  additional game logic goes here
    ;===================================
    
OSwait:
    sta WSYNC
    bit TIMINT
    bpl OSwait  ; loop until the timer ends
    
    jmp VerticalSync    ; start the next frame
    
    
;========================================
; Define End of Cartridge
;========================================

    ORG $FFFA        ; set address to 6507 Interrupt Vectors 
    .WORD InitSystem ; NMI
    .WORD InitSystem ; RESET
    .WORD InitSystem ; IRQ
