;
; BattyBovine UMA1 expansion sound
;

UMA1_CH1 = 4
UMA1_CH2 = 5

ft_update_uma1:
	lda var_PlayerFlags
	bne @Play
	rts
@Play:
	; UMA1 Pulse 1
	lda var_ch_Note + UMA1_CH1		; Kill channel if note = off
	beq @KillPulse1
	; Calculate volume
	lda var_ch_VolColumn + UMA1_CH1		; Kill channel if volume column = 0
	asl a
	and #$F0
	beq @KillPulse1
	sta var_Temp
	lda var_ch_Volume + UMA1_CH1		; Kill channel if volume = 0
	beq @KillPulse1
	ora var_Temp
	tay
	; Write to registers
	lda var_ch_DutyCycle + UMA1_CH1
	and #$03
	tax
	lda ft_volume_table, y
    sec
    sbc var_ch_TremoloResult + UMA1_CH1
    bpl :+
    lda #$00
:
	ora ft_duty_table, x		; Add volume
	ora #$30					; and disable length counter and envelope
	sta $5000
	; Period table isn't limited to $7FF anymore
	lda var_ch_PeriodCalcHi + UMA1_CH1
	and #$F8
	beq :+
	lda #$03
	sta var_ch_PeriodCalcHi + UMA1_CH1
	lda #$FF
	sta var_ch_PeriodCalcLo + UMA1_CH1
:	lda var_ch_PeriodCalcLo + UMA1_CH1
	sta $5002
	lda var_ch_PeriodCalcHi + UMA1_CH1
	cmp var_ch_PrevFreqHighUMA1
	beq :+
	sta $5003
	sta var_ch_PrevFreqHighUMA1
:	jmp @Pulse2
@KillPulse1:
	lda #$30
	sta $5000
@Pulse2: 	; UMA1 Pulse 2
	lda var_ch_Note + UMA1_CH2		; Kill channel if note = off
	beq @KillPulse2
	; Calculate volume	
	lda var_ch_VolColumn + UMA1_CH2		; Kill channel if volume column = 0
	asl a
	and #$F0
	beq @KillPulse2
	sta var_Temp
	lda var_ch_Volume + UMA1_CH2		; Kill channel if volume = 0
	beq @KillPulse2
	ora var_Temp
	tay
	; Write to registers
	lda var_ch_DutyCycle + UMA1_CH2
	and #$03
	tax
	lda ft_volume_table, y
    sec
    sbc var_ch_TremoloResult + UMA1_CH2
    bpl :+
    lda #$00
:
	ora ft_duty_table, x		; Add volume
	ora #$30					; and disable length counter and envelope
	sta $5004
	; Period table isn't limited to $7FF anymore
	lda var_ch_PeriodCalcHi + UMA1_CH2
	and #$F8
	beq :+
	lda #$03
	sta var_ch_PeriodCalcHi + UMA1_CH2
	lda #$FF
	sta var_ch_PeriodCalcLo + UMA1_CH2
:	lda var_ch_PeriodCalcLo + UMA1_CH2
	sta $5006
	lda var_ch_PeriodCalcHi + UMA1_CH2
	cmp var_ch_PrevFreqHighUMA1 + 1
	beq @Return
	sta $5007
	sta var_ch_PrevFreqHighUMA1 + 1
@Return:
	rts
@KillPulse2:
	lda #$30
	sta $5004
	rts
	