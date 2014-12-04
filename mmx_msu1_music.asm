lorom

; MSU memory map I/O
MSU_STATUS = $2000
MSU_ID = $2002
MSU_AUDIO_TRACK_LO = $2004
!MSU_AUDIO_TRACK_HI = $2005
!MSU_AUDIO_VOLUME = $2006
!MSU_AUDIO_CONTROL = $2007

; SPC communication ports
SPC_PORT_0 = $2140

; MSU_STATUS possible values
MSU_STATUS_TRACK_MISSING = $8
MSU_STATUS_AUDIO_PLAYING = %00010000
MSU_STATUS_AUDIO_REPEAT  = %00100000
MSU_STATUS_AUDIO_BUSY    = $40
MSU_STATUS_DATA_BUSY     = %10000000

; Constants
FULL_VOLUME = $FF
DUCKED_VOLUME = $60

FADE_DELTA = ($FF/45)

; Variables
fadeState = $7E7C00
fadeVolume = $7E7C02

; FADE_STATE possibles values
FADE_STATE_IDLE = $00
FADE_STATE_FADEOUT = $01
FADE_STATE_FADEIN = $02

; TODO: Remove that
org $8692B8
	db "MSU1 Hack DarkShock "

; Fade-in/Fade-out hijack in NMI routine
org $80817A
	jsr MSU_FadeUpdate
	
; Add a hook to where the sound effects/special commands are played
org $80885B
	jsr MSU_SoundEffectsAndCommand

; At Capcom logo, init the required variables
org $808613
	jsr MSU_Init

; Play music from Options Screen, All music after level music, Password Screen, Stage Select
org $8087AA
	jsr MSU_Main

; Play Title Screen
org $808D8F
	jsr MSU_Main
	
; Play music at level load
org $809A2D
	jmp MSU_Main

; Play stage selected jingle
org $809709
	jsr MSU_Main
	
; Ending ??
org $809CFA
	jsr MSU_Main

; Got a weapon
org $80ABD6
	jsr MSU_Main

; A = Music to play + $10
org $80FBCE
MSU_Main:
	php
; Backup A and Y in 16bit mode
	rep #$30
	pha
	phy
	
	sep #$30 ; Set all registers to 8 bit mode
	tay
	
	; Check if MSU-1 is present
	lda MSU_ID
	cmp #'S'
	bne .MSUNotFound
	
.MSUFound:
	; Set track
	tya
	clc
	sbc #$F
	tay
	sta MSU_AUDIO_TRACK_LO
	stz !MSU_AUDIO_TRACK_HI

.CheckAudioStatus
	lda MSU_STATUS
	
	and.b #MSU_STATUS_AUDIO_BUSY
	bne .CheckAudioStatus
	
	; Check if track is missing
	lda MSU_STATUS
	and.b #MSU_STATUS_TRACK_MISSING
	bne .MSUNotFound
	
	; Play the song and add repeat if needed
	jsr TrackNeedLooping
	sta !MSU_AUDIO_CONTROL
	
	; Set volume
	lda.b #FULL_VOLUME
	sta.w !MSU_AUDIO_VOLUME
	
	; Reset the fade state machine
	lda #$00
	sta fadeState
	
	rep #$30
	ply
	pla
	plp
	rts
	
; Call original routine if MSU-1 is not found
.MSUNotFound:
	rep #$30
	ply
	pla
	plp
	
	jsr $87B0
	rts

MSU_Init:
	php
	sep #$30
	pha
	
	; Check if MSU-1 is present
	lda MSU_ID
	cmp #'S'
	bne .MSUNotFound
	
	; Set volume
	lda.b #FULL_VOLUME
	sta.w !MSU_AUDIO_VOLUME
	
	; Reset the fade state machine
	lda.b #$00
	sta.l fadeState

.MSUNotFound
	pla
	plp
	
	jsr $87B0
	
	rts

TrackNeedLooping:
; Capcom Jingle
	cpy #$00
	beq .noLooping
; Title Screen
	cpy #$0F
	beq .noLooping
; Victory Jingle 
	cpy #$11
	beq .noLooping
; Stage Selected Jingle
	cpy #$12
	beq .noLooping
; Got a Weapon 
	cpy #$17
	beq .noLooping
; Boss Tension 1
	cpy #$1E
	beq .noLooping
	lda #$03
	rts
.noLooping:
	lda #$01
	rts
	
MSU_SoundEffectsAndCommand:
	php
	
	sep #$30
	pha
	
	lda MSU_ID
	cmp #'S'
	bne .MSUNotFound_SE
	
	pla
	; $F5 is a command to resume music
	cmp #$F5
	beq .ResumeMusic
	; $F6 is a command to fade-out music
	cmp #$F6
	beq .StopMusic
	; $FE is a command to raise volume back to full volume coming from pause menu
	cmp #$FE
	beq .RaiseVolume
	; $FF is a command to drop volume when going to pause menu
	cmp #$FF
	beq .DropVolume
	; If not, play the sound as the game excepts to
	bra .PlaySound
	
.ResumeMusic:
	; Stop the SPC music if any
	lda #$F6
	sta SPC_PORT_0
	
	; Resume music then fade-in to full volume
	lda #$03
	sta !MSU_AUDIO_CONTROL
	lda.b #FADE_STATE_FADEIN
	sta fadeState
	lda #$00
	sta fadeVolume
	bra .CleanupAndReturn

.StopMusic:
	sta SPC_PORT_0

	lda MSU_STATUS
	and.b #MSU_STATUS_AUDIO_PLAYING
	beq .CleanupAndReturn

	; Fade-out current music then stop it
	lda.b #FADE_STATE_FADEOUT
	sta fadeState
	lda.b #FULL_VOLUME
	sta fadeVolume
	bra .CleanupAndReturn

.RaiseVolume:
	sta.w SPC_PORT_0
	lda.b #FULL_VOLUME
	sta.w !MSU_AUDIO_VOLUME
	bra .CleanupAndReturn
	
.DropVolume:
	sta.w SPC_PORT_0
	lda.b #DUCKED_VOLUME
	sta.w !MSU_AUDIO_VOLUME
	bra .CleanupAndReturn
	
.MSUNotFound_SE:
	pla
.PlaySound:
	sta SPC_PORT_0
.CleanupAndReturn:
	plp
	rts
	
MSU_FadeUpdate:
	; Original code I hijacked that increase the real frame counter
	inc.w $0B9E
	
	php
	sep #$30
	pha
	
	lda MSU_ID
	cmp #'S'
	bne .MSUNotFound
	
	; Switch on fade state
	lda fadeState
	cmp.b #FADE_STATE_IDLE
	beq .MSUNotFound
	cmp.b #FADE_STATE_FADEOUT
	beq .FadeOutUpdate
	cmp.b #FADE_STATE_FADEIN
	beq .FadeInUpdate
	bra .MSUNotFound
	
.FadeOutUpdate:
	lda fadeVolume
	sec
	sbc.b #FADE_DELTA
	bcs +
	lda #$0
+
	sta fadeVolume
	sta.w !MSU_AUDIO_VOLUME
	beq .SetToIdle
	bra .MSUNotFound
	
.FadeInUpdate:
	lda fadeVolume
	clc
	adc.b #FADE_DELTA
	bcc +
	lda.b #FULL_VOLUME
+
	sta fadeVolume
	sta.w !MSU_AUDIO_VOLUME
	cmp.b #FULL_VOLUME
	beq .SetToIdle
	bra .MSUNotFound

.SetToIdle:
	lda.b #FADE_STATE_IDLE
	sta fadeState

.MSUNotFound
	pla
	plp
	rts
