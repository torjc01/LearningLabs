; ==============================================================================
; Program Collect.asm - tutorial from Atari Age - by SpiceWare
; Step 1 - bases do jogo
; ==============================================================================

; Initialize dasm

    PROCESSOR 6502

; include vcs.h que contem definicoes standard para registros TIA e RIOT
    include vcs.h

; macro.h contem rotinas comumente utilizadas que auxiliam na codificacao
    include macro.h

; ========================
; Definicao de uso da RAM
; ========================

; define segmento para as variaveis

    SEG.U VARS

; RAM comeca em $80
    ORG $80

; ============================
; Define o comeco do cartucho
; ============================

; define segmento para o codigo.
    SEG CODE

; 2K ROM comeca em $f800; 4k ROM comeca em $F000
    ORG $F800


; ============================
; Inicializa o ATARI
; ============================

InitSystem:
; CLEAN_START : macro
    CLEAN_START

; ============================
;  Main loop
; ============================

Main:
    jsr VerticalSync        ; Jump para a subroutine VerticalSync
    jsr VerticalBlank       ; Jump para a subroutine VerticalBlank
    jsr Kernel              ; Jump para a subrotina Kernel
    jsr OverScan            ; Jump para a subrotine OverScan
    jmp Main                ; Jump para Main


; ============================
; VerticalSync
;  aqui geramos o sinal que diz a tv para mover o raio ao topo da tela de modo
; que possamos comecar o proximo frame de video.
; O sync signal deve estar ligado por 3 scanlines
; ============================

VerticalSync:
    lda #2            ; Load acumulador com 2 tal que D1=1
    sta WSYNC         ; Espera por SYNC (para a CPU ate o fim do scanline)
    sta VSYNC         ; Acumulador D1=1, liga o sinal VerticalSync
    sta WSYNC         ; Espera por sync - para a CPU ate fim da 1 scanline de VSYNC
    sta WSYNC         ; Espera ate fim do 2 scanline VSYNC
    lda #0            ; Load acumulador com 0, tal que D1=0
    sta WSYNC         ; Espera ate fim do 3 scanline de VSYNC
    sta VSYNC         ; Acumulador D1=0 desliga sinal VerticalSync
    rts               ; Retorna subrotina

; ============================
; Vertical Blank
; ============================
VerticalBlank:
    ldx #37

vbLoop:
    sta WSYNC
    dex
    bne vbLoop
    rts

; ============================
; Kernel
; aqui se atualiza o registro na TIA (o chip de video), para gerar o que o
; jogador ve. Pelo momento vamos somente gerar 192 linhas coloridas de scanline
; para que tenhamos o que ver
; ============================

Kernel:
  ; liga o display
    sta WSYNC
    lda #0
    sta VBLANK

  ; Desenha a tela
    ldx #192

KernelLoop:
    sta WSYNC
    stx COLUBK
    dex
    bne KernelLoop
    rts

; ============================
; Overscan
; ============================

OverScan:
    sta WSYNC
    lda #2
    sta VBLANK

    ldx #27

osLoop:
    sta WSYNC
    dex
    bne osLoop
    rts

; ============================
; Define fim de cartucho
; ============================

    ORG $FFFA
    .WORD InitSystem
    .WORD InitSystem
    .WORD InitSystem
