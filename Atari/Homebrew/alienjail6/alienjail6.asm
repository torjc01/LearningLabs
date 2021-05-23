;alien jail.

	PROCESSOR 6502

	include vcs.h
	include macro.h

ARENA_HEIGHT = 99

	SEG.U VARS
	ORG $80


Frame:		ds 1	        ; Frame counter.
ScanLine:	ds 1		; scanline counter

PlayerY0:	ds 1
PlayerY1:	ds 1
m0_Y:		ds 1		; ball y0
m1_Y:		ds 1
ball_Y:		ds 1

OverscanValue:	ds 1	
Score:      ds 2    ; stored in $80-81
DigitOnes:      ds 2    ; stored in $82-83, DigitOnes = Score, DigitOnes+1 = Score+1
DigitTens:      ds 2    ; stored in $84-85, DigitTens = Score, DigitTens+1 = Score+1
ScoreCounter:   ds 1
Temp:		ds 1
TempStackPtr:	ds 1		; Temporary Stack Pointer

PlayerX0:	ds 1
PlayerX1:	ds 1
m0_X:		ds 1
m1_X:		ds 1		; Ball y1
ball_X:		ds 1		; Ball y2


PlayerX1S: 	ds 1
PlayerY1S: 	ds 1
PlayerX0S: 	ds 1
PlayerY0S: 	ds 1

m0_X_Dir:	ds 1
m0_Y_Dir:	ds 1



P0Velocity:	ds 1
P1Dir		ds 1
Rand8:		ds 1
GameOn:		ds 1
SFXTimer:	ds 1

	SEG CODE
	ORG $F800

TheBeginning:
	CLEAN_START

    ; seed the random number generator
        lda INTIM       ; unknown value
        sta Rand8       ; use as seed


TheBeginning2:

	
	
	lda #$00
	sta GameOn
	sta SFXTimer
	sta AUDV0
	
	
	lda #$01
	sta P0Velocity







MainLoop:

VerticalSync:
        lda #$82        ; DGS - LoaD Accumulator with $82 so D7=1 and D1=1
        ldx #49			; LoaD X with 49
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
        lda #$20    ; 
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
      
	  
		jsr Random 

;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; ;; Yet another thwack at motion. No really, this
;;; ;; is getting really old. I feel like I'm Bill Murray
;;; ;; at this point. Actually, wait, maybe I'm schizophrenic
;;; ;; and I am both Bill Murray, and Stephen Tobolowsky?
;;; ;; Don't do drugs, kids...
;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	;;
	;;  Persist last known good coordinates if not colliding
	;;  with anything.
	;;

	;;
	;;  Persist last known good coordinates if not colliding
	;;  with anything.
	;;

	ldx #$00

PersistLNG:
	lda CXP0FB,x
	bpl MotionPlayer
	lda PlayerX0,x
	sta PlayerX0S,x
	lda PlayerY0,x
	sta PlayerY0S,x
PersistNext:
	inx
	cpx #$01
	bne PersistLNG

	;;
	;;  start with first player.
	;; 
MotionPlayer:
	ldx #$00
	stx VDELBL
	
	;;
	;; Apply the appropriate pre-motion delay in frames
	;; 
MotionPDelay:
	lda P0Velocity,x
	cmp #$00
	beq MotionNext
	and #$0F
	cmp #$00
	beq MotionPDirection
	sec
	sbc #$01
	sta Temp
	lda Frame
	and Temp
	bne MotionNext

	;;
	;; Next grab the requested direction(s),
	;; and flip them for easy carry set shifting.
	;; 
MotionPDirection:
	lda P0Velocity,x
	eor #$FF

	;;
	;; Finally, move on to the next player.
	;; 
MotionNext:
	cpx #$05
	bne MotionNext1
	lda PlayerY0,x
	clc
	adc #$01
	lsr
	bcs MotionNext1
	sta VDELBL
MotionNext1:
	inx
	cpx #$47
	bne MotionPDelay

	;;
	;; Check each player for collision, if it has occurred, reset player
	;; coordintes back to last known good coordinates.
	;;

	


	;;
	;; Apply X motion vectors.
	;; 
    ldx #3

ApplyMotion:
    lda PlayerX0,x
    jsr PosObject
    dex
    bpl ApplyMotion
	
	
	
	ldx #$02
	
ApplyMotionY:	
	lda PlayerY0,x
	jsr PosObject

        

	

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
	lda #$15
	sta CTRLPF


	ldx #0

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
	lda ball_Y		; Get ball's Y coord
	eor ScanLine		; eor with scanline to flip bits if needed
	and #$FE		; quantise to 4 lines.
	php			; transfer processor flags (we are interested in Z) to where SP is
	;;
	;; Then, missile 1, php caused SP to decrement over to ENAM1
	;; 
	lda m1_Y		; Same thing again, just against missile 1
	eor ScanLine		;
	and #$FE		;
	php			;
	;;
	;; Then, missile 0, php caused SP to decrement to ENAM0
	;; 
	lda m0_Y		; same thing again, just against missile 0
	eor ScanLine		;
	and #$FE		;
	php			;
	;;
	;; Ok, we're now done with p0, bl, m1, m0, now to precalculate playfield offset.
	;; 
	lda ScanLine		; Get current scanline
	bpl vvrefl		; if we're < 127, then don't reflect.
	eor #$00		; otherwise flip bits to reflect.
vvrefl:	cmp #$19		; figure out if we're at last playfield line, if so, done.
	bcc vfdone		;
	lsr			; divide the scanline counter by 8.
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
	eor #$C6		; are we done?
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



	
	lda #31
	sta OverscanValue
	


	lda GameOn
	cmp #1
	bcs PlayerColCheck
	
		lda #33
		sta OverscanValue
		

		
	
		lda INPT4           ; read the player's fire button value	
		bmi Overscan11
		
	
StartTheGame:

		lda #0
		sta AUDV0

	jsr InitialPosition

	jmp ThisSuckkkkks
	
TheBeginning22:

		lda #0
		sta AUDV0
		
		
		jmp TheBeginning2
	
Overscan11:
	jmp  Overscan1


PlayerColCheck:


	lda #%01000000
	bit CXM0P
	beq ThisSuckkkkks
	


	
	    lda #5
		sta AUDV0
        lda #10
		sta AUDC0
		lda SFXTimer
		sta AUDF0	

		inc SFXTimer
	
	
	
	
	
		lda #33
		sta OverscanValue

	 	lda SFXTimer
		cmp #31
		bcs TheBeginning22
	
	
	jmp Overscan11
	
	

ThisSuckkkkks:
	ldx #$00

	lda #0
	sta AUDV0

    lda CXP0FB,x      ; N=player0/playfield, V=player0/ball
    bpl notP0PF     ; if N is off then player0 did not collide with playfield
	lda PlayerX0S,x
	sta PlayerX0,x
	lda PlayerY0S,x
	sta PlayerY0,x

	lda #30
	sta OverscanValue	


	jmp ProcessJoystick
	
notP0PF:


	lda SWCHA
	cmp #127
	bcs ProcessJoystick


	lda #29
	sta OverscanValue	
	
	


ProcessJoystick:
        lda SWCHA       ; reads joystick positions
        
        ldx #0          ; x=0 for left joystick, x=1 for right
PJloop:    
        ldy PlayerX0,x   ; save original X location so the player can be
        sty PlayerX0S,x    ;   bounced back upon colliding with the playfield
        ldy PlayerY0,x   ; save original Y location so the player can be
        sty PlayerY0S,x    ;   bounced back upon colliding with the playfield
		

		
		
        asl             ; shift A bits left, R is now in the carry bit
        bcs CheckLeft   ; branch if joystick is not held right		




        ldy PlayerX0,x   ; get the object's X position
        iny             ; and move it right
        cpy #150        ; test for edge of screen
        bne SaveX       ; save Y if we're not at the edge
        ldy PlayerX0S           ; else wrap to left edge
		
	
		
		
		
SaveX:  sty PlayerX0,x   ; saveX
       ; ldy #0          ; turn off reflect of player, which
       ; sty REFP0,x     ; makes humanoid image face right

		


CheckLeft:
        asl             ; shift A bits left, L is now in the carry bit
        bcs CheckDown   ; branch if joystick not held left
		

		
        ldy PlayerX0,x   ; get the object's X position
        dey             ; and move it left
        cpy #255        ; test for edge of screen
        bne SaveX2      ; save X if we're not at the edge
        ldy PlayerX0S        ; else wrap to right edge
		

		
		
SaveX2: sty PlayerX0,x   ; save X
       ; ldy #8          ; turn on reflect of player, which
       ; sty REFP0,x     ; makes humanoid image face left 

		

CheckDown:
        asl                     ; shift A bits left, D is now in the carry bit
        bcs CheckUp             ; branch if joystick not held down
		
	
	
	
		
        ldy PlayerY0,x           ; get the object's Y position
        iny   
        cpy #ARENA_HEIGHT*2+2   ; test for top of screen
        bne SaveY2              ; save Y if we're not at the top
        ldy PlayerY0S                ; else wrap to bottom
		
				
		
		
SaveY2: sty PlayerY0,x           ; save Y

CheckUp:
        asl                     ; shift A bits left, U is now in the carry bit
        bcs AlienShip      ; branch if joystick not held up
	


		
        ldy PlayerY0,x           ; get the object's Y position
        dey                     ; move it down
        cpy #41              ; test for bottom of screen
        bne SaveY               ; save Y if we're not at the bottom
        ldy PlayerY0S		   ; else wrap to top
		
		
	
		
SaveY:  sty PlayerY0,x           ; save Y		
		


;-------------------------------
AlienShip:
	ldx #$00
	
	
    lda CXP0FB,x      ; N=player0/playfield, V=player0/ball
    bpl notP0PF2     ; if N is off then player0 did not collide with playfield	
	
	
	jmp PlayerColCheck1
	
notP0PF2:	
	lda #33
	sta OverscanValue


PlayerColCheck1:

	lda SWCHA
	cmp #63
	bcs ThisSucks
	
	lda #31
	sta OverscanValue	
	
	
	
	jmp ThisSucks2
	
ThisSucks:	
	lda #29
	sta OverscanValue	


ThisSucks2:

    lda CXP1FB,x      ; N=player0/playfield, V=player0/ball
    bpl notP1PF     ; if N is off then player0 did not collide with playfield
	lda PlayerX1S,x
	sta PlayerX1,x
	lda PlayerY1S,x
	sta PlayerY1,x

	lda #28
	sta OverscanValue	

	jsr CheckForP1Dir

	
notP1PF:




        lda P1Dir       ; reads joystick positions
        
        ldx #0          ; x=0 for left joystick, x=1 for right
PJloop1:    
        ldy PlayerX1,x   ; save original X location so the player can be
        sty PlayerX1S,x    ;   bounced back upon colliding with the playfield
        ldy PlayerY1,x   ; save original Y location so the player can be
        sty PlayerY1S,x    ;   bounced back upon colliding with the playfield
		
		
		
		
        lda P1Dir
		cmp #0
        bne CheckLeft1   ; branch if joystick is not held right
			
		
	

        ldy PlayerX1,x   ; get the object's X position
        iny             ; and move it right
        cpy #150        ; test for edge of screen
        bne SaveX1       ; save Y if we're not at the edge
		
			jsr P1DirIs0

	lda #29
	sta OverscanValue


        ldy PlayerX1S           ; else wrap to left edge
		
		
		
		
SaveX1:  sty PlayerX1,x   ; saveX
       ; ldy #0          ; turn off reflect of player, which
       ; sty REFP0,x     ; makes humanoid image face right

CheckLeft1:
        lda P1Dir
		cmp #1
        bne CheckDown1   ; branch if joystick not held left
		
        ldy PlayerX1,x   ; get the object's X position
        dey             ; and move it left
        cpy #255        ; test for edge of screen
        bne SaveX21      ; save X if we're not at the edge
        ldy PlayerX1S        ; else wrap to right edge
		
			
		
		
		jsr P1DirIs1		
	
	lda #29
	sta OverscanValue

	
SaveX21: sty PlayerX1,x   ; save X
       ; ldy #8          ; turn on reflect of player, which
       ; sty REFP0,x     ; makes humanoid image face left 

CheckDown1:
			lda P1Dir
			cmp #2

                     ; shift A bits left, D is now in the carry bit
        bne CheckUp1             ; branch if joystick not held down
		
				
		
        ldy PlayerY1,x           ; get the object's Y position
        iny   
        cpy #ARENA_HEIGHT*2+2   ; test for top of screen
        bne SaveY21              ; save Y if we're not at the top
        ldy PlayerY1S                ; else wrap to bottom
	

		
	
		jsr P1DirIs2		
	lda #29
	sta OverscanValue	

	
SaveY21: sty PlayerY1,x           ; save Y

CheckUp1:
        lda P1Dir
		cmp #3 ; shift A bits left, U is now in the carry bit
        bne MoveMissile0      ; branch if joystick not held up
	
		
		
        ldy PlayerY1,x           ; get the object's Y position
        dey                     ; move it down
        cpy #41              ; test for bottom of screen
        bne SaveY1               ; save Y if we're not at the bottom
	

	
		jsr P1DirIs3	
		
        ldy PlayerY1S		   ; else wrap to top
		lda #29
	sta OverscanValue
		
		
SaveY1:  sty PlayerY1,x           ; save Y		
	


;------------------------
MoveMissile0:

	
        ldx #0          


	
        
 
CheckRightMissile0:
		lda m0_X_Dir
		cmp #0
        bne CheckLeftMissile0             ; branch if joystick not held down
		
				
		
        ldy m0_X,x           ; get the object's Y position
        iny   
        cpy #150  ; test for top of screen
        bne SaveX011             ; save Y if we're not at the top
 
		
		jsr m0_X_DirIs0		
		
SaveX011: sty m0_X,x           ; save Y

CheckLeftMissile0:
        lda m0_X_Dir
		cmp #1 ; shift A bits left, U is now in the carry bit
        bne CheckDownMissile0       ; branch if joystick not held up
	
		
		
        ldy m0_X,x           ; get the object's Y position
        dey                     ; move it down
        cpy #15              ; test for bottom of screen
        bcs SaveX11               ; save Y if we're not at the bottom
		
		jsr m0_X_DirIs1	
		
  
	
		
		
SaveX11:  sty m0_X,x           ; save Y



;-------

CheckDownMissile0:

		ldx #0

		lda m0_Y_Dir
		cmp #0
        bne CheckUpMissile0             ; branch if joystick not held down
		
				
		
        ldy m0_Y,x           ; get the object's Y position
        iny   
        cpy #ARENA_HEIGHT*2-3  ; test for top of screen
        bne SaveY011             ; save Y if we're not at the top
    
		
		jsr m0_Y_DirIs0		
		
SaveY011: sty m0_Y,x           ; save Y



CheckUpMissile0:
        lda m0_Y_Dir
		cmp #1 ; shift A bits left, U is now in the carry bit
        bne Overscan1       ; branch if joystick not held up
	
		
		
        ldy m0_Y,x           ; get the object's Y position
        dey                     ; move it down
        cpy #41              ; test for bottom of screen
        bne SaveY01               ; save Y if we're not at the bottom
		
		jsr m0_Y_DirIs1	
		

	
		
		
SaveY01:  sty m0_Y,x           ; save Y		

	

Overscan1:
        sta WSYNC   ; Wait for SYNC (start of next scanline)
        lda #2      ; LoaD Accumulator with 2
        sta VBLANK  ; STore Accumulator to VBLANK, D1=1 turns image output off
        lda OverscanValue
        sta TIM64T  ; set timer for end of Overscan
    

			
OSwait:
        sta WSYNC
        bit TIMINT
        bpl OSwait  ; wait for the timer to denote end of Overscan	


                    LDA SWCHB           ; Check console switches
                    AND #$08            ; Black & white mode?
                    BEQ BlackWhite      ; Y: B/W colors

	
		lda #88
		sta COLUP1
	lda #$1A
	sta COLUPF	
	lda #$36
	sta COLUP0	
	
	
		jmp MainLoop

BlackWhite
	lda #$0A
	sta COLUP1
	lda #$0E
	sta COLUPF	
	lda #$06
	sta COLUP0	

	jmp MainLoop


P1DirIs3:
		lda #2
		sta P1Dir
		
		rts

P1DirIs2:
		lda #3
		sta P1Dir
		
		rts


P1DirIs1:
		lda #0
		sta P1Dir
		
		rts

P1DirIs0:
		lda #1
		sta P1Dir
		
		rts


m0_Y_DirIs1:
		lda #0
		sta m0_Y_Dir
		
		rts


m0_Y_DirIs0:
		lda #1
		sta m0_Y_Dir
		
		rts
		
	;;

m0_X_DirIs1:
		lda #0
		sta m0_X_Dir
		
		rts


m0_X_DirIs0:
		lda #1
		sta m0_X_Dir
		
		rts
		
  
PosObject:
        sec
        sta WSYNC
		
		
DivideLoop
        sbc #15        ; 2  2 - each time thru this loop takes 5 cycles, which is 
        bcs DivideLoop ; 2  4 - the same amount of time it takes to draw 15 pixels
        eor #7         ; 2  6 - The EOR & ASL statements convert the remainder
        asl            ; 2  8 - of position/15 to the value needed to fine tune
        asl            ; 2 10 - the X position
        asl            ; 2 12
        asl            ; 2 14
        sta.wx HMP0,X  ; 5 19 - store fine tuning of X
        sta RESP0,X    ; 4 23 - set coarse X position of object
        rts            ; 6 29
	

	
Sleep12:            ;       jsr here to sleep for 12 cycles        
        rts         ; ReTurn from Subroutine	


Random:
        lda Rand8
        lsr
        bcc noeor
        eor #$B4 
noeor: 
        sta Rand8
        rts  


CheckForP1Dir:




        ldy PlayerX1,x   ; save original X location so the player can be
        sty PlayerX1S,x    ;   bounced back upon colliding with the playfield
        ldy PlayerY1,x   ; save original Y location so the player can be
        sty PlayerY1S,x    ;   bounced back upon colliding with the playfield


	


		lda P1Dir
		cmp #0
        bcs GetRandomY

  		lda P1Dir
		cmp #1
        bcs GetRandomY 	

GetRandomX:



		jsr Random
		and #3
		sta P1Dir
		
		lda P1Dir
		inc P1Dir
		sta P1Dir
		rts
		
GetRandomY:




		jsr Random
		and #3	
		sta P1Dir
		
		lda P1Dir
		inc P1Dir


		sta P1Dir
		rts	



InitialPosition:
	lda #$4C
	sta PlayerX0
	lda #$88
	sta PlayerX1

	lda #$62
	sta PlayerY0
	sta PlayerY1
	
	lda #$10
	sta NUSIZ0
	sta NUSIZ1
	


	
	
	lda #1
	sta P1Dir
	sta GameOn
	
	lda #$00
	sta Score
	sta Score+1
	sta AUDV0	

		
		
	rts			; and return.
	
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

	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000010
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %01000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000010
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %01000000
	.byte %00000000
	.byte %00000000
	.byte %10000000	
	.byte %00000000
	.byte %00000100
	.byte %00000000
	.byte %00010000
	.byte %00000000
	.byte %00000000
	.byte %00100000
	.byte %00000000
	.byte %00000010
	.byte %00000000
	.byte %00000000
	.byte %01000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000100
	.byte %00000000	
	.byte %00000000

	
PF1_0
	.byte $00
	.byte $00
	.byte $00

	.byte %00000000
	.byte %01000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000010
	.byte %00000000
	.byte %01000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000010
	.byte %00000000
	.byte %01000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000010
	.byte %00000000
	.byte %00000000
	.byte %00001000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000100
	.byte %00000000	
	.byte %00000000
	.byte %00010000
	.byte %00000000
	.byte %00000000
	.byte %00100000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000010
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %01000000
	.byte %00000000
	.byte %00000000
	.byte %00000100
	.byte %00000000	
	.byte %00000000

PF2_0
	.byte $00
	.byte $00
	.byte $00

	.byte %00000000
	.byte %00000000
	.byte %00001000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00001000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00001000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %01000000
	.byte %00100000
	.byte %00100000
	.byte %11000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000	
	.byte %00001000
	.byte %00000000
	.byte %00000000
	.byte %00010000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00010000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000100
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000	


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
	
PLAYER:	
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000	
	.byte %11111110
	.byte %11111110	
	.byte %11111110
	.byte %10101010
	.byte %10101010	
	.byte %11111110
	.byte %11111110
	.byte %11111110
	.byte %11111110
	.byte %00000000
	.byte %00000000	
	.byte %00000000
	.byte %00000000
	
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
