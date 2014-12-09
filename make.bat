@ECHO OFF

del mmx_msu1.sfc
del *.pcm

copy mmx_original.sfc mmx_msu1.sfc
asar mmx_msu1_music.asm mmx_msu1.sfc

rem mmx_msu1-16.wav selectionStart=126976 selectionEnd=813056

rem OCRemix ones
wav2msu mmx_msu1_sting_chameleon.wav mmx_msu1-2.pcm
wav2msu mmx_msu1_chill_penguin.wav mmx_msu1-7.pcm
wav2msu mmx_msu1_spark_mandrill.wav mmx_msu1-8.pcm
wav2msu mmx_msu1_storm_eagle.wav mmx_msu1-9.pcm
wav2msu mmx_msu1_sigma_stage_2.wav mmx_msu1-11.pcm
wav2msu mmx_msu1_sigma_stage_4.wav mmx_msu1-13.pcm
wav2msu mmx_msu1_boss_battle_1.wav mmx_msu1-14.pcm
wav2msu mmx_msu1_title_screen.wav mmx_msu1-15.pcm
wav2msu mmx_msu1-16.wav -l 126976
wav2msu mmx_msu1_boss_victory_jingle.wav mmx_msu1-17.pcm
wav2msu mmx_msu1_stage_selected_jingle.wav mmx_msu1-18.pcm
wav2msu mmx_msu1_got_a_weapon.wav mmx_msu1-23.pcm
wav2msu mmx_msu1_password.wav mmx_msu1-24.pcm
wav2msu mmx_msu1_ending_theme.wav mmx_msu1-28.pcm
wav2msu mmx_msu1_cast_roll.wav mmx_msu1-29.pcm
wav2msu mmx_msu1_boss_tension_1.wav mmx_msu1-30.pcm

rem Maverick Hunter ones
wav2msu mmx_msu1-1.wav -l 76400
wav2msu mmx_msu1_launch_octopus.wav mmx_msu1-3.pcm
wav2msu mmx_msu1_armored_armadillo.wav mmx_msu1-4.pcm
wav2msu mmx_msu1_flame_mammoth.wav mmx_msu1-5.pcm
wav2msu mmx_msu1-6.wav -l 279049
wav2msu mmx_msu1_sigma_stage_1.wav mmx_msu1-10.pcm
wav2msu mmx_msu1-12.wav -l 336895
wav2msu mmx_msu1_boss_tension_2.wav mmx_msu1-19.pcm
wav2msu mmx_msu1_boss_battle_2.wav mmx_msu1-20.pcm
wav2msu mmx_msu1_zero_appears.wav mmx_msu1-21.pcm
wav2msu mmx_msu1_zero_talks.wav mmx_msu1-22.pcm
wav2msu mmx_msu1-25.wav -l 80937
wav2msu mmx_msu1_sigma_battle_1.wav mmx_msu1-26.pcm
wav2msu mmx_msu1_sigma_battle_2.wav mmx_msu1-27.pcm