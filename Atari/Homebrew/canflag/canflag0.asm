; Canada Flag Program
;      for the
; Atari 2600 (Stella)
; MOS Technology 6507
;       NTSC
;
;     Don Dueck
;    July 8, 2016
;
; Assembler used: DASM
; http://dasm-dillon.sourceforge.net/
;
; Any references to page numbers are for the Stella Programming Guide ( http://atarihq.com/danb/files/stella.pdf ).
;
; I have tried to comment everything in as simple and as explanatory terms as possible, but it is assumed that the
; reader has some basic familiarity with assembler programming and with the Atari 2600 hardware (i.e. 6502/6507 
; processor, TIA, etc.).
;
;
; What this program does:
;
; This program uses the background color and the playfield to draw a Canada flag.  Two of the three registers that 
; control what to draw on the playfield are fixed throughout the program (these draw the red bars on the sides) 
; while the third playfield register is modified on the fly to draw the maple leaf in the center.
;


;------------------------------------------------------------------------------

                processor 6502          ; tells the compiler to compile this code for the 6502 processor (the processor that the Atari uses is a variant of this - the 6507)
                include "vcs.h"         ; include the "symbol table" vcs.h, which basically stores constants we can use to represent common values, such as system memory locations  
                ;include "macro.h"      ; include the "symbol table" macro.h, which contains some helper functions 
                include "clr_ntsc.h"    ; include NTSC palette color constants

;------------------------------------------------------------------------------

                SEG.U variables         ; Begin a section of uncompiled code (for symbols)

MapleLeafStart  = 50                    ; The scanline to start drawing the maple leaf
MapleLeafLines  = 95                    ; The number of scanlines tall that the maple leaf is

;------------------------------------------------------------------------------

                SEG                     ; Begin a section of compiled code
                ORG $F000               ; Set starting point of memory location for this code.  Address $F000 is the first byte in the VCS memory map that is meant 
                                        ; for addressing the ROM (i.e. our game).  That is, $F000 is the "insertion point" where our ROM will go in the Atari's complete
                                        ; memory structure.  
                                        ; For reference, our entire ROM (i.e. all the code here) *must* fit within the memory range $F000 to $FFFF.

Reset                                   ; Labels this point of code with the human-readable name (i.e. "symbol") "Reset".  We can jump code execution here to simulate 
                                        ; a reset of the Atari.  Labels can be treated as having the value of the address it is compiled at (in this case, $F000).

    ; Set the stack, the X and A registers, and the TIA registers all to zero, and also the stack pointer to $FF 

                ldx #0                  ; Load the value of zero into the X register.
                txa                     ; Transfer (copy) the value in the X register into the A register.  Both registers X and A now contain zero.
Clear           dex                     ; Decrement the value in the X register.  Remember that if the X register contains zero, subtracting one from it will cause
                                        ; it to 'wrap around' to the value $FF.  (Also, label this point in the ROM with the symbol "Clear")
                txs                     ; Transfer the value in the X register into the Stack Pointer register.  On the first iteration, the value will be $FF because
                                        ; we initialized the X register to zero, then decremented the X register by 1.  On subsequent iterations when the code branches
                                        ; to the Clear label, the X register value is decremented, then copied to the Stack Pointer.  This essentially makes the Stack
                                        ; Pointer count down from $FF.
                pha                     ; Push the value in register A (which we set to zero earlier) to the address in RAM that the Stack Pointer is pointing to.  
                                        ; NOTE: This opcode also decrements the value in the stack pointer.  This doesn't matter while we are branching, since the 
                                        ; preceeding txs operation sets the Stack Pointer value, but it is important on the last iteration of this loop because it 
                                        ; will change the Stack Pointer from $00 to $FF.
                bne Clear               ; Branch to the Clear label if the last operation that modified either the A, X, or Y register (dex, in this case) set that 
                                        ; register's value to anything other than zero.  If the value in the last modified A, X, or Y register ended up being zero, 
                                        ; then processing falls through.

    ; At this point, X and A registers are Zero, the Stack Pointer is $FF (the stack address range is $80 to $FF), and all TIA registers and RAM are zero.


    ; Set up two of the three playfield registers (page 39) to draw the red bars of the flag on the sides of the screen

                lda #%11110000          ; Load a value representing the playfield "pixels" to turn on/off in the first of three sections of the left half of the playfield
                sta PF0                 ; Store the value in the A register into the location in memory that the TIA looks at to determine when to draw and when not to draw.
                                        ; Note that this register is read in "reverse", and is only 4 bits wide (the rightmost bits typed out here are ignored). (page 5)

                lda #%11111000          ; Load a value representing the playfield "pixels" to turn on/off in the second of three sections of the left half of the playfield      
                sta PF1                 ; Store the value in the A register into the location in memory that the TIA looks at to determine when to draw and when not to draw.

    ; The right half of the playfield should be a mirror of the left half (instead of a repeat)

                lda #%00000001          ; Load a value that will set the "mirror playfield" bit into the A register.  
                sta CTRLPF              ; Stores the value in the A register into the location in memory that the TIA looks at to get flags that control how the
                                        ; playfield should be drawn (like mirroring or repeating the two halves of the playfield, drawing it with the player colors 
                                        ; instead, etc.).  (page 39)

        
    ; The TIA draws the playfield by looking at three registers -- P0, P1, and P2. Everytime a 1 bit is encountered, the TIA draws a playfield "pixel". 
    ; The three registers are read kind of oddly.  The four lowest order bits in P0 are ignored, and the bits in P0 and P2 are processed in reverse order.
    ; After half of the playfield is drawn, the TIA uses the same registers to draw the right half of the playfield.  The right half is either a repeat 
    ; or a mirror of the left half (this behavior is controlled by the CTRLPF register, which controls other playfield drawing behavior as well).
    ;
    ; So, in the above code, we are telling the TIA to draw the following:
    ;
    ; Values in memory (remember all registers were initalized to zero, so we didn't have to write anything to P2):
    ;
    ;     P0        P1        P2  
    ;  11110000  00011111  00000000
    ;
    ; Order in which bits are read by the TIA  (X means the bit is ignored):
    ;
    ;     P0       P1       P2        P2        P1       P0
    ;  XXXX1111  11111000  00000000  00000000  00011111  1111XXX
    ;                                |----------------------| 
    ;                                    Right half is a 
    ;                                   mirror of the left
    ;
    ; As you can see, this will tell the TIA to draw bars on the left and right side of the screen.

;------------------------------------------------

    ; Start of Main Program Loop

StartOfFrame
  
    ; Start of new frame of video (happens 60 times a second on an NTSC TV).  A single frame is made up of 262 scanlines, only 192 of which 
    ; are guaranteed to be visible (in other words, the Atari outputs a 192p image).
    ;
    ; So, always keep this in mind: the television beam is constantly drawing the TV image one scanline at a time, 262 scanlines per frame, 
    ; and 60 frames per second.  Our code is executing simultaneously as this beam moves.  The code controls what image appears on the screen 
    ; by writing numbers into places in memory that the TIA (Television Interface Adapter) looks at in order to determine how to behave (page 1). 
    ; This all means that, at every point in the code, we must be aware of where the television beam is!

    ; VERTICAL-BLANK
    ;
    ; The "vertical blank" is the top part of the TV image frame that should not be used becase it's not guaranteed to be visible on all TVs.
    ; The vertical blank consists of 40 scanlines.  The first three of these scanlines are the "vertical sync" scanlines.  The vertical sync
    ; is a "reset" signal for the TV that tells it to start a new video frame.  The 37 scanlines after that should just be blank.
    ;
    ; Because no image is being drawn at this point, we have some processing time to implement game logic if we so desired (we'll have some
    ; extra time at the end, too).  Later, when we're drawing the frame, there won't be much time to do any sort of game logic calculations --
    ; there is only 76 microprocessor cycles per scanline, and each instruction takes between 2 to 5 cycles (sometimes more) to execute!

    ; First, we need to tell the TIA to send three scanlines of vertical-sync signal to the TV.  
    ;
    ; NOTE: At this point, the TIA should already be set to not draw anything.  If you look at the end of the frame-drawing code, you'll see that we
    ;       store the appropriate value into the VBLANK register which the TIA looks at to determine whether or not to tell the TV to draw anything.

                lda #$02                ; Load the value that will tell the TIA to start the vertical-sync sequence into register A (we'll use this later).
                                        ; The binary value is 0010.  The second least significant bit (called D1) in the value is the one which the TIA will look at.
                sta WSYNC               ; Suspend code until the current scan-line finishes (i.e. wait for horizontal sync).  This is a "strobe" register, so we can just
                                        ; write any value to this register to trigger it, which is why we use the arbitrary value from register A.
                sta VSYNC               ; Tell the TIA to start the vertical-sync signal by copying the value from register A into the area in memory that the TIA looks
                                        ; at to determine whether or not to send a vertical-sync signal.  The TIA looks at the second least significant bit at this
                                        ; memory location (register) to determine whether or not it should perform vertical sync.  It should now have the value 0010.  
                                        ; The '1' bit in position D1 will turn on vertical sync once the TIA reads it (which happens almost immediately).
                sta WSYNC               ; Suspend code until the current scanline finishes.  1st scanline vertical sync
                sta WSYNC               ; Suspend code until the current scanline finishes.  2nd scanline vertical sync
                lsr                     ; Do a binary right shift on the value in register A.  This will change the value in that register to one which will tell the
                                        ; TIA to stop the vertical-sync sequence (we'll use this later).  Previous value was 0010, value after right-shift is 0001.
                                        ; Note that this operation changes the value of the bit D1 from 1 to 0.
                sta WSYNC               ; Suspend code until the current scan-line finishes.  3rd and last scanline vertical sync
                sta VSYNC               ; Tell the TIA to stop sending the vertical sync signal by copying the value from Register A into the area in memory that the TIA
                                        ; looks at to determine whether or not to send a vertical-sync signal.  Remember that we shifted the bits in the A register -- this
                                        ; moved a 0 bit into the spot where the TIA looks to determine whether or not it should send a vertical sync signal (i.e. D1 -- the
                                        ; second-least significant bit).

    ; Next we need to send 37 more blank scanlines (remember, the VBLANK register should, at this point, be set so the TIA doesn't draw anything)

                ldx #36                 ; Load the decimal value 36 into the X register.  We'll use this as a counter to limit how many blank scanlines we'll draw.
VBlankLoop 
                sta WSYNC               ; Wait until the current horizontal scanline ends.  We need to do this 37 times (counting down from 36 to 0).
                dex                     ; Decrement the value stored in the X register.
                bne VBlankLoop          ; If the value in the X register is non-zero, then branch code execution to VBlankLoop.  If the value in the X register is zero,
                                        ; then let code execution fall through.

                ldx #0                  ; Load a value into the X register which, when stored in VBLANK, will tell the TIA to start drawing again.
                stx VBLANK              ; Store the value in the X register (which we just set to 0) into the VBLANK register so that the TIA will read the proper bits to
                                        ; tell it to start sending a drawing signal again (i.e. to stop the vertical-blank).

    ; Note that, at this point the television beam has moved along the first scanline already.  Fortunately, the beam is still in the "horizontal blank" section.
    ; The first little bit of every scanline does not appear onscreen and is called the Horizontal Blank.  This gives us a few precious cycles of processing time before
    ; the scanline is actually drawn.

    ; Set the color of the background to be white.  

                ldx #WHITE              ; Load a value representing the desired color into the X register.  The values that the color labels represent are defined in cls_ntsc.h.
                stx COLUBK              ; Store the value in the X register into the register that the TIA looks at in order to determine what color to draw the background.

    ; Also set the playfield to be red.  
               
                lda #RED                ; Load a value representing the desired color into the X register.  The values that the color labels represent are defined in cls_ntsc.h.
                sta COLUPF              ; Store the value in the X register into the register that the TIA looks at in order to determine what color to draw the playfield.


    ; The beam is still going!  Thankfully we set the appropriate colors before the beam started drawing the visible portion of the first scanline.


    ; Do 192 scanlines of color-changing and whatnot in order to draw a picture.  We'll need a counter and a loop for this.  We'll use the X register to keep track
    ; of which scanline we're on.

                ldx #0                  ; Load the value 0 into the X register.  This register will act as a counter of how many scanlines we've drawn. 

                ldy #0                  ; Load the value 0 into the Y register.  This register will act as a counter for how many scanlines of the maple leaf graphic 
                                        ; we've drawn.  We won't start counting until we've hit the vertical position that we want to draw the maple leaf at.
                                        
VisibleScanlines                        ; Lable this point in the code with a nice, human-readable description.  The processing for a single frame will loop back to
                                        ; this point until the TIA draws all visible scanlines in the frame.
                                                
    ; In the main frame drawing loop we will be drawing a maple leaf.
                                        
                cpx #MapleLeafStart     ; Compare our current scanline counter with the value represented by the MapleLeafStart symbol.  We defined that value near the 
                                        ; beginning of the code.  That value is the vertical offset of the maple leaf.
                bmi StopDrawing         ; Code execution should skip to the StopDrawing label if the current scanline counter is less than the scanline we should start 
                                        ; drawing the maple leaf at.
                
                cpy #MapleLeafLines     ; Compare our current scanline counter with the value represented by the MapleLeafLines symbol.  We defined that value near the 
                                        ; beginning of the code.  That value is the number of scanlines tall the maple leaf graphic is.  We define the drawing data for
                                        ; all these lines later on in the code at the MapleLeaf label.
                bpl StopDrawing         ; Code execution should skip to the StopDrawing label if the current scanline counter is greater than than the scanline that we 
                                        ; should stop drawing the maple leaf at.

    ; If code execution falls through the two branch opcodes above, that means we are on a scanline which should be drawing some part of the maple leaf graphic.
                                        
                lda MapleLeaf,y         ; Load into the A register the byte stored at the MapleLeaf label and offset that value by whatever value is in the Y register 
                                        ; (which we are using to track the current line of the maple leaf we are drawing).  We'll increment the Y register every scanline
                                        ; so that this code will essentially be reading one byte of the maple leaf graphic data table every scanline.
                sta PF2                 ; Store the data from the A register into the PF2 register.  This will control what playfield 'pixels' the TIA will draw at a
                                        ; particular point on the screen.  From left to right, the TIA uses PF0, PF1, and PF2 registers to draw the left half of the 
                                        ; playfield. For the right half, the TIA repeats the sequence, or reverses it if a particular bit in the CTRLPF register is set 
                                        ; (which it is in this case).  So, in our case, the PF2 register controls what will be drawn in the middle of the screen.
    
    ; Keep track of which scanline of the maple leaf graphic we are drawing.
    
                iny                     ; Increment the value in the Y register

    ; Because the previous code is only supposed to execute while drawing, we need to skip over a bit of code that stops the drawing.
    
                jmp Continue

StopDrawing

    ; We'll end up here if the current scanline is before or after where the maple leaf is to be drawn.  If we end up here, we should not be drawing anything.
 
                lda #0
                sta PF2         
    
Continue 

    ; We'll always end up here every scanline.  So, now we need to synchronize the processor with the TIA, increment the scanline count, and figure out if we are
    ; processing another scanline or if the frame is finished.

                sta WSYNC               ; Halt code execution until the TIA resets to the beginning of the next scanline (we're effectively just "burning" microprocessor cycles)
                inx                     ; Increment the value in the X register, which is where we are storing our scanline count for the visible portion of the frame.
                cpx #192                ; Compare the value in the X register with the decimal value 192.
                bne VisibleScanlines    ; If the previous comparison resulted in a "not equal" answer, jump to the code that we labelled VisibleScanlines and start
                                        ; drawing the next scanline.  If the comparison resulted in an "equal" answer, then we've drawn all 192 scanlines and are done
                                        ; drawing this frame.

    ; At this point, the TIA has finished drawing all the scanlines that are guaranteed to be visible and is now drawing the first scanline in the Overscan
    ; part of the frame.  The Overscan is made up of 30 additional blank scanlines.  This is generally where you would put a lot of the game logic since we 
    ; don't have to worry about handling the drawing of the screen.

    ; OVERSCAN
    ;
    ; Next we need to send 30 blank scanlines.  This is known as the Overscan.  These lines are not guaranteed to be visible, so we should just not draw anything.

EndofVisibleScanlines                   ; Just a human-readable label.  We won't actually jump to this point ever.

                ldx #%01000010          ; Load a value into the X register which represents the appropriate bits to start VBLANK (page 38) -- i.e. stop drawing.
                stx VBLANK              ; Store the value in the X register into the VBLANK register.  This will case drawing to stop (but the electron gun
                                        ; is still scanning lines -- it doesn't stop moving until the TV is turned off!).

                ldx #30                 ; Load the decimal value 30 into the X register.  We'll use this as a counter to limit how many blank scanlines we'll draw.
OverscanLoop 
                sta WSYNC               ; Wait until the current horizontal scanline ends.  We need to do this 30 times.
                dex                     ; Decrement the value stored in the X register.
                bne OverscanLoop        ; If the value in the X register is non-zero, then branch code execution to OverscanLoop.  If the value in the X register is zero,
                                        ; then let code execution fall through.

                jmp StartOfFrame        ; Jump to the start of the frame drawing code so we can start drawing the next frame of video.

    ; End of Main Program Loop

;------------------------------------------------


    ; Code execution will never get to this point because of the jmp instruction up above, so we have a safe place here to store some additional information
    ; for our program to use.


    ; The data below is for drawing the maple leaf graphic.  Every scanline we will store one of these bytes into the PF2 register.  I've group the bytes into five
    ; per line of code for readbility -- the compiler will still put all these bytes one after the other regardless of how I am laying things out.  I used groups
    ; of five because I wanted the vertical resolution of the graphic to be about as blocky as the horizontal resolution.  Since each byte is drawn on one scanline,
    ; five identical bytes in a row will mean five scanlines drawn exactly the same.

MapleLeaf   

    ; Tell the compiler to write the exact bytes we want into the ROM 

                .byte $80,$80,$80,$80,$80
                .byte $80,$80,$80,$80,$80
                .byte $A0,$A0,$A0,$A0,$A0
                .byte $E0,$E0,$E0,$E0,$E0
                .byte $E0,$E0,$E0,$E0,$E0
                .byte $E4,$E4,$E4,$E4,$E4
                .byte $ED,$ED,$ED,$ED,$ED
                .byte $FF,$FF,$FF,$FF,$FF
                .byte $FE,$FE,$FE,$FE,$FE
                .byte $FE,$FE,$FE,$FE,$FE
                .byte $FF,$FF,$FF,$FF,$FF
                .byte $FE,$FE,$FE,$FE,$FE
                .byte $F8,$F8,$F8,$F8,$F8
                .byte $E0,$E0,$E0,$E0,$E0
                .byte $F0,$F0,$F0,$F0,$F0
                .byte $B8,$B8,$B8,$B8,$B8
                .byte $80,$80,$80,$80,$80
                .byte $80,$80,$80,$80,$80
                .byte $80,$80,$80,$80,$80

;------------------------------------------------------------------------------

    ; Compile some special final bytes at the very end of the ROM.  I haven't looked into what these are for, yet, but they appear to be standard.
    
                ORG $FFFA               ; Tell the compiler to start placing compiled code at address FFFA (right near the end of the ROM space) from this point forward.

InterruptVectors

    ; At addresses FFFA, FFFC, and FFFE in the ROM, write the two bytes that represent the game's "reset" point.  Our ROM must include these addresses at the
    ; end of the ROM because the Atari will be looking at addresses FFFA, FFFC, and FFFE for special operations.

                .word Reset             ; (NMI) - The 6502 processor looks at these two bytes when the hardware experiences a failure.  The 6507 (the 6502 variant processor
                                        ; used in the Atari) doesn't actually have an NMI pin, so we don't actually need to do this (and could use these two bytes if we
                                        ; *really* needed to).
                                        
                .word Reset             ; (RESET) - The 6502/6507 processor looks at these two bytes when it wants to know where to start code execution.  We're 
                                        ; telling it to start execution at the point in code that we labelled "Reset".
                                        
                .word Reset             ; (IRQ) - The 6502 processor looks at these two bytes when it encounters the BRK opcode or receives an interrupt request from the
                                        ; hardware.  The 6507 doesn't have an IRQ pin, but it does still look here if it executes the BRK opcode.  If we were *really*
                                        ; desperate for more bytes and we didn't use the BRK opcode anywhere, we could use these two bytes for our own purposes.

      END                               ; Tell the compiler that we're done.
      
 