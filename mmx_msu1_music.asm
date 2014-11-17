lorom

MSU_STATUS = $2000
MSU_ID = $2002
MSU_AUDIO_TRACK_LO = $2004
!MSU_AUDIO_TRACK_HI = $2005
!MSU_AUDIO_VOLUME = $2006
!MSU_AUDIO_CONTROL = $2007
SPC_PORT_0 = $2140

; MSU_STATUS possible values
MSU_STATUS_TRACK_MISSING = $8
MSU_STATUS_AUDIO_PLAYING = %00010000
MSU_STATUS_AUDIO_REPEAT  = %00100000
MSU_STATUS_AUDIO_BUSY    = $40
MSU_STATUS_DATA_BUSY     = %10000000

org $8692B8
	db "MSU1 Hack by DarkSho"

; Add a hook to where the sound effects/special commands are played
org $80885B
	jsr MSU_SoundEffectsAndCommand

; Play Capcom Logo
org $808613
	jsr MSU_Main

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
	
	; Check if MSU is present
	lda MSU_ID
	cmp #'S'
	bne .MSUNotFound
	
.MSUFound:
	; Set volume
	lda #$60
	sta !MSU_AUDIO_VOLUME
	
	; Set track
	tya
	clc
	sbc #$F
	tay
	sta MSU_AUDIO_TRACK_LO
	stz !MSU_AUDIO_TRACK_HI

	lda MSU_STATUS
	and.b #MSU_STATUS_TRACK_MISSING
	bne .MSUNotFound
	
.CheckAudioStatus
	lda MSU_STATUS
	
	and.b #MSU_STATUS_AUDIO_BUSY
	bne .CheckAudioStatus
	
	; Play the song and add repeat if needed
	jsr TrackNeedLooping
	sta !MSU_AUDIO_CONTROL

	rep #$30
	ply
	pla
	plp
	rts
	
.MSUNotFound:
	rep #$30
	ply
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
	; $F6 is a command to fade-out music (currently stopping it)
	cmp #$F6
	beq .StopMusic
	; If not, play the sound as the game excepts to
	bra .PlaySound
	
.ResumeMusic:
	lda #$F6
	sta SPC_PORT_0
	
	; TODO: Fade-in ?
	lda #$03
	sta !MSU_AUDIO_CONTROL
	bra .CleanupAndReturn

.StopMusic:
	sta SPC_PORT_0

	lda MSU_STATUS
	and.b #MSU_STATUS_AUDIO_PLAYING
	beq .CleanupAndReturn

	; Stop current music (TODO: Fade-out)
	lda #$00
	sta !MSU_AUDIO_CONTROL
	bra .CleanupAndReturn

.MSUNotFound_SE:
	pla
.PlaySound:
	sta SPC_PORT_0
.CleanupAndReturn:
	plp
	rts
