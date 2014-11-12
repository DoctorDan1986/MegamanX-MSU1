lorom

MSU_STATUS = $2000
MSU_ID = $2002
MSU_AUDIO_TRACK_LO = $2004
!MSU_AUDIO_TRACK_HI = $2005
!MSU_AUDIO_VOLUME = $2006
!MSU_AUDIO_CONTROL = $2007

; MSU_STATUS possible values
MSU_STATUS_TRACK_MISSING = %00001000
MSU_STATUS_AUDIO_PLAYING = %00010000
MSU_STATUS_AUDIO_REPEAT  = %00100000
MSU_STATUS_AUDIO_BUSY    = %01000000
MSU_STATUS_DATA_BUSY     = %10000000

org $8692B8
	db "MSU1 Hack by DarkSho"

; This is the play music routine
; A = Music to play + $10
org $8087B0
	jsl CheckMSU
	nop
	nop

org $8C8B4D
CheckMSU:
	rep #$30
	pha
	phy
	sep #$30 ; Set all registers to 8 bit mode
	tay
	
	; Check if MSU is present
	lda MSU_ID
	cmp #'S'
	bne MSUNotFound
	
MSUFound:
	; Set volume
	lda #$FF
	sta !MSU_AUDIO_VOLUME
	
	; Set track
	tya
	clc
	sbc #$F
	sta MSU_AUDIO_TRACK_LO
	stz !MSU_AUDIO_TRACK_HI
	
	lda MSU_STATUS
	and.b #MSU_STATUS_TRACK_MISSING
	bne MSUNotFound
	
.CheckAudioStatus
	lda MSU_STATUS
	
	and.b #MSU_STATUS_AUDIO_BUSY
	bne .CheckAudioStatus
	
	; Play the song and repeat it
	lda #$01
	sta !MSU_AUDIO_CONTROL
	
MSUNotFound:
	rep #$30
	ply
	pla
	
	sep #$30
	tay
	lda $806B,y
	rtl