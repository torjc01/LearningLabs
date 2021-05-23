;ursa major

	PROCESSOR 6502

	include vcs.h
	include macro.h

	SEG.U VARS
	ORG $80
	
Frame:		ds 1	        ; Frame counter.
ScanLine:	ds 1		; scanline counter
PlayerY1:	ds 1
PlayerY0:	ds 1
Score:      ds 2    ; stored in $80-81
DigitOnes:      ds 2    ; stored in $82-83, DigitOnes = Score, DigitOnes+1 = Score+1
DigitTens:      ds 2    ; stored in $84-85, DigitTens = Score, DigitTens+1 = Score+1
ScoreCounter:   ds 1
Temp:		ds 1
TempStackPtr:	ds 1		; Temporary Stack Pointer
PlayerX0:	ds 1
PlayerX1:	ds 1
BallY0:		ds 1		; ball y0
BallY1:		ds 1		; Ball y1
BallY2:		ds 1		; Ball y2

	SEG CODE
	ORG $F800

TheBeginning:
	CLEAN_START

	
	lda #$00
	sta Score

	lda #$1A
	sta COLUPF	




MainLoop:

VerticalSync:
        lda #$82        ; DGS - LoaD Accumulator with $82 so D7=1 and D1=1
        ldx #45         ; LoaD X with 49
        sta WSYNC       ; Wait for SYNC (halts CPU until end of scanline)
        sta VSYNC       ; Accumulator D1=1, turns on Vertical Sync signal
        sta VBLANK      ; DGS - turn off video, dump paddles to ground
        stx TIM64T      ; set timer to go off in 41 scanlines (49 * 64) / 76
        ;sta CTRLPF      ; D1=1, playfield now in SCORE mode
        lda Frame
        and #$3f
        bne VSskip
VSskip: inc Frame       ; increment Frame count

        sta WSYNC   ; Wait for Sync - halts CPU until end of 1st scanline of VSYNC
        lda #$30    ; 
        sta NUSIZ0  ; set missile0 to be 8x
        sta NUSIZ1  ; set missile1 to be 8x
        sta WSYNC   ; wait until end of 2nd scanline of VSYNC
        lda #0      ; LoaD Accumulator with 0 so D1=0
        sta PF0     ; blank the playfield
        sta PF1     ; blank the playfield
        sta PF2     ; blank the playfield
        sta GRP0    ; blanks player0 if VDELP0 was off
        sta GRP1    ; blanks player0 if VDELP0 was on, player1 if VDELP1 was off 
        sta GRP0    ; blanks                           player1 if VDELP1 was on		
        sta VDELP0  ; turn off Vertical Delay
        sta VDELP1  ; turn off Vertical Delay
        sta CXCLR   ; clear collision detection latches
        sta WSYNC   ; wait until end of 3rd scanline of VSYNC
        sta VSYNC   ; Accumulator D1=0, turns off Vertical Sync signal




	

PrepScoreForDisplay:
        ; initialize the loop counter for the score        
        ldx #5
        stx ScoreCounter
        
        ldx #1          ; use X as the loop counter for PSFDloop
PSFDloop:
        lda Score,x     ; LoaD A with Score+1(first pass) or Score(second pass)
        and #$0F        ; remove the tens digit
        sta Temp        ; Store A into Temp
        asl             ; Accumulator Shift Left (# * 2)
        asl             ; Accumulator Shift Left (# * 4)
        adc Temp        ; ADd with Carry value in Temp (# * 5)
        sta DigitOnes,x  ; STore A in DigitOnes+1(first pass) or DigitOnes(second pass)
        lda Score,x     ; LoaD A with Score+1(first pass) or Score(second pass)
        and #$F0        ; remove the ones digit
        lsr             ; Logical Shift Right (# / 2)
        lsr             ; Logical Shift Right (# / 4)
        sta Temp        ; Store A into Temp
        lsr             ; Logical Shift Right (# / 8)
        lsr             ; Logical Shift Right (# / 16)
        adc Temp        ; ADd with Carry value in Temp ((# / 16) * 5)
        sta DigitTens,x ; STore A in DigitTens+1(first pass) or DigitTens(second pass)
        dex             ; DEcrement X by 1
        bpl PSFDloop    ; Branch PLus (positive) to PSFDloop
        ;rts             ; ReTurn from Subroutine     

	lda #$00
	sta CXCLR

ThePlayfield:	


	;; wait for timer to run out
	lda INTIM
	bne ThePlayfield

	;; a is now 0, so turn off vblank, so we can see stuff.
	sta VBLANK
	
	;; Assume scanline 35 once HMOVE happens.
	lda #$19
	sta ScanLine

	;; go to next scanline and thwack HMOVE, to commit the X motion changes.
	sta WSYNC
	sta HMOVE

	;; grab the stack pointer and temporarily store it, for later.
	tsx
	stx TempStackPtr



		; these 4 lines are duplicated after the inc DigitOnes/Tens 		
        ldy DigitTens           ; 3 54 - get the tens digit offset for the Score
        lda DigitFlippedGfx,y   ; 5 59 -   use it to load the digit graphics
        and #$0F                ; 2 61 -   remove the graphics for the ones digit
        sta Temp                ; 3 64 -   and save it
		
		
		
		
		
ScoreLoop2:                     ;   51 from bne ScoreLoop2
        ; calculate PF2 for left side of screen
        ldy DigitOnes           ; 3 54 - get the ones digit offset for the Score
        lda DigitFlippedGfx,y   ; 4 58 -   use it to load the digit graphics
        and #$F0                ; 2 60 -   remove the graphics for the tens digit
        ora Temp                ; 3 63 -   merge with the tens digit graphics
		tax                     ; 2 65 - save in X for later		
        sta WSYNC               ; 3 68 - wait for end of scanline
;---------------------------------------     
        stx PF2                 ; 3  3 - update PF2 for left side of screen
        ldy DigitOnes+1         ; 3  6 - get the left digit offset for the Score+1
        lda DigitGfx,y          ; 4 10 -   use it to load the digit graphics
        and #$0F                ; 2 12 -   remove the graphics for the ones digit
        sta Temp                ; 3 15 -   and save it
        ldy DigitTens+1         ; 3 18 - get the ones digit offset for the Score+1
        lda DigitGfx,y          ; 4 22 -   use it to load the digit graphics
        and #$F0                ; 2 24 -   remove the graphics for the tens digit
        ora Temp                ; 3 27 -   merge with the tens digit graphics
        jsr Sleep12             ;12 39
        SLEEP 6                 ; 6 45
        sta PF2                 ; 3 48 - @48 - update PF2 for right side of screen
        sta WSYNC               ; 3 53 - wait for end of scanline		
;---------------------------------------
        stx PF2                 ; 3  3 - update PF2 for left side of screen
        tax                     ; 2  5 - save in X for right side
        inc DigitOnes           ; 5 10 - advance for the next line of graphic data
        inc DigitOnes+1         ; 5 15 - advance for the next line of graphic data
        inc DigitTens           ; 5 20 - advance for the next line of graphic data
        inc DigitTens+1         ; 5 25 - advance for the next line of graphic data
        ldy DigitTens           ; 3 28 - get the tens digit offset for the Score
        lda DigitFlippedGfx,y   ; 4 32 -   use it to load the digit graphics
        and #$0F                ; 2 34 -   remove the graphics for the ones digit
        sta Temp                ; 3 37 -   and save it
        dec ScoreCounter        ; 5 42 - decrement score loop counter
        SLEEP 3                 ; 3 45
        stx PF2                 ; 3 48
        bne ScoreLoop2          ; 2 50 - (3 51) if ScoreCounter != 0 then branch to ScoreLoop






	;;
	;; Clear the playfield
	;;
ScoreDone:
	sta WSYNC
	lda #$00
	sta PF1
	sta PF2
	

	
	lda ScanLine
	adc #$05
	sta ScanLine
	sta WSYNC
	sta WSYNC

	;;
	;; Set CTRLPF to do a 2 clock ball, and reflective playfield.
	;;
PFReady:	
	lda #$11
	sta CTRLPF

	;;
	;; the inner playfield loop
	;; 
vfield:	ldx #$1F		; Place SP over ENABL
	txs			; for the stack trick to be used in a moment.
	;;
	;; handle Player 0
	;; 
	sec			;
	lda PlayerY0		; Where is player0's Y?
	sbc ScanLine		; subtract current scanline
	and #$FE		; quantise to two scanlines
	tax			; move into x register for graphic lookup
	and #$F0		; mask upper 4 bits
	beq vdoplayer		; if we're 0, we need to do the player.
	lda #$00		; else don't draw a player, and....
	beq vnoplayer		; continue onward.
vdoplayer:
	lda PLAYER,X		; load the next player graphic line
vnoplayer:
	sta WSYNC		; go to next scanline
	STA GRP0		; slam player0's graphic into place.
	;;
	;; the combat stack trick. Utilize the fact that the missile and ball enables
	;; are in bit D1, and thus can be strobed in O(1) time if we're on the right
	;; scanline, because A = 0 = Z
	;;
	;; First, do the ball., ENABL
	;; 
	lda BallY2		; Get ball's Y coord
	eor ScanLine		; eor with scanline to flip bits if needed
	and #$FE		; quantise to 4 lines.
	php			; transfer processor flags (we are interested in Z) to where SP is
	;;
	;; Then, missile 1, php caused SP to decrement over to ENAM1
	;; 
	lda BallY1		; Same thing again, just against missile 1
	eor ScanLine		;
	and #$FE		;
	php			;
	;;
	;; Then, missile 0, php caused SP to decrement to ENAM0
	;; 
	lda BallY0		; same thing again, just against missile 0
	eor ScanLine		;
	and #$FE		;
	php			;
	;;
	;; Ok, we're now done with p0, bl, m1, m0, now to precalculate playfield offset.
	;; 
	lda ScanLine		; Get current scanline
	bpl vvrefl		; if we're < 127, then don't reflect.
	eor #$F8		; otherwise flip bits to reflect.
vvrefl:	cmp #$19		; figure out if we're at last playfield line, if so, done.
	bcc vfdone		;
	lsr			; divide the scanline counter by 8.
	lsr			;
	lsr			;
	tay			; transfer to Y for table lookup.
	;;
	;; now deal with Player 1
	;; 
vfdone:	lda PlayerY1		; get player 1's Y coord
	sec			; 
	sbc ScanLine		; subtract it against current scanline
	inc ScanLine		; go ahead and increment scanline in memory (to correct bias)
	nop			; wait a tick...
	ora #$01		; get the next odd bit in player (p0 and p1 graphics are interleaved!)
	tax			; convert to table lookup
	;;
	and #$F0		; mask off top bits (we have 16 possible entries)
	beq vdot1		; do player 1 graphics if we need to, else...
	lda #$00		; write 0's
	beq vnot1		; and slam it to GRP0
vdot1:	lda PLAYER,X		; load next graphic line
vnot1:	sta GRP1		; slam it into GRP1	
	lda PF0_0,Y
	sta PF0
	lda PF1_0,Y		; now we have some time to slam PF1 into place
	sta PF1			;
	lda PF2_0,Y		; and PF2.
	sta PF2			;
	
	inc ScanLine		; increment to next scanline
	lda ScanLine		; get current scanline
	eor #$E6		; are we done?
	bne vfield		; if not, loop around.

	;;
	;; go to next line, to keep things clean.
	;;
	sta WSYNC

	;;
	;; Bottom of the visible kernel
	;; clean up the visible regsters to prevent messes.
	;;
KernelCleanup:

	;;
	;; put the stack back the way it was.
	;;
	ldx TempStackPtr
	txs
	ldx #$08
wloop	sta WSYNC
	dex
	bpl wloop
	lda #$00
		

	

	
		jmp MainLoop
	
Sleep12:            ;       jsr here to sleep for 12 cycles        
        rts         ; ReTurn from Subroutine	


	
;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; ;; Player data, p0 and p1 are interleaved.
;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


	
	
;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; ;; Playfield data
;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PF0_0
	.byte $00
	.byte $00
	.byte $00
	.byte $00

	.byte $F0
	.byte $10
	.byte $10
	.byte $10
	.byte $10
	.byte $10
	.byte $10
	.byte $10
	.byte $10
	.byte $10
	.byte $10
	.byte $10
	
PF1_0
	.byte $00
	.byte $00
	.byte $00
	.byte $00

	.byte $FF
	.byte $00
	.byte $00
	.byte $00
	.byte $38
	.byte $00
	.byte $00
	.byte $00
	.byte $60
	.byte $20
	.byte $20
	.byte $23
	
PF2_0
	.byte $00
	.byte $00
	.byte $00
	.byte $00

	.byte $FF
	.byte $80
	.byte $80
	.byte $00
	.byte $00
	.byte $00
	.byte $1C
	.byte $04
	.byte $00
	.byte $00
	.byte $00
	.byte $00
	

DigitGfx:
        .byte %01110111
        .byte %01010101
        .byte %01010101
        .byte %01010101
        .byte %01110111
        
        .byte %00100010
        .byte %01100110
        .byte %00100010
        .byte %00100010       
        .byte %01110111
        
        .byte %01110111
        .byte %00010001
        .byte %01110111
        .byte %01000100
        .byte %01110111
        
        .byte %01110111
        .byte %00010001
        .byte %00110011
        .byte %00010001
        .byte %01110111
        
        .byte %01010101
        .byte %01010101
        .byte %01110111
        .byte %00010001
        .byte %00010001
        
        .byte %01110111
        .byte %01000100
        .byte %01110111
        .byte %00010001
        .byte %01110111
           
        .byte %01110111
        .byte %01000100
        .byte %01110111
        .byte %01010101
        .byte %01110111
        
        .byte %01110111
        .byte %00010001
        .byte %00010001
        .byte %00010001
        .byte %00010001
        
        .byte %01110111
        .byte %01010101
        .byte %01110111
        .byte %01010101
        .byte %01110111
        
        .byte %01110111
        .byte %01010101
        .byte %01110111
        .byte %00010001
        .byte %01110111

DigitFlippedGfx:
        .byte %11101110
        .byte %10101010
        .byte %10101010
        .byte %10101010
        .byte %11101110
        
        .byte %01000100
        .byte %01100110
        .byte %01000100
        .byte %01000100       
        .byte %11101110
        
        .byte %11101110
        .byte %10001000
        .byte %11101110
        .byte %00100010
        .byte %11101110
        
        .byte %11101110
        .byte %10001000
        .byte %11001100
        .byte %10001000
        .byte %11101110
        
        .byte %10101010
        .byte %10101010
        .byte %11101110
        .byte %10001000
        .byte %10001000
        
        .byte %11101110
        .byte %00100010
        .byte %11101110
        .byte %10001000
        .byte %11101110
           
        .byte %11101110
        .byte %00100010
        .byte %11101110
        .byte %10101010
        .byte %11101110
        
        .byte %11101110
        .byte %10001000
        .byte %10001000
        .byte %10001000
        .byte %10001000
        
        .byte %11101110
        .byte %10101010
        .byte %11101110
        .byte %10101010
        .byte %11101110
        
        .byte %11101110
        .byte %10101010
        .byte %11101110
        .byte %10001000
        .byte %11101110
	
PLAYER:	.byte $00
	.byte $00
	.byte $00
	.byte $00
	.byte $3C
	.byte $3C
	.byte $3C
	.byte $3C
	.byte $3C
	.byte $3C
	.byte $3C
	.byte $3C
	.byte $00
	.byte $00
	.byte $00
	.byte $00
;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; ;; Function to check for free space at end of cart.
;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	echo "------", [$FFFA - *]d, "bytes free before End of Cartridge"

            ORG $FFFA

InterruptVectors
            .word TheBeginning         ; NMI
            .word TheBeginning          ; RESET
            .word TheBeginning           ; IRQ

      END
