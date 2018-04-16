.define ROM_NAME "HALT TESTS"
.include "shell.inc"

; 56 cycles
div_start:
  xor a
  sta DIV
  ret

; 16732 cycles
div_stop:
  ld c, 0
  lda DIV
  ld b, a
  push de
  ld d, a
  ld a, 9
  call div_stall
  ld e, 63
div_stop_loop:
  lda DIV
  sub d
  cp 2
  jr nz, div_stop_loop_skip
  ld c, e
div_stop_loop_skip:
  add d
  ld d, a
  ld a, 8
  call div_stall
  dec e
  jr nz, div_stop_loop
div_stop_done:
  ld a, c
  rlca
  rlca
  sub 60
  jr nc, div_stop_done_skip
  dec b
div_stop_done_skip:
  ld c, a
  pop de
  ret

; 64 + a * 16 cycles
div_stall:
  add 1
div_stall_loop:
  dec a
  jr nz, div_stall_loop
  ret z

; 65512 cycles
wait_a_bit:
  ld bc, $0922
wait_a_bit_more:
  dec bc
  ld a, b
  or c
  jr nz, wait_a_bit_more
  ret

.macro halt_test
  ld a, \2
  call print_a
  call halt_test_begin
  \1
  .rept 5 - (\2 >> 2)
    nop
  .endr
  call halt_test_end
  print_str newline
.endm

main:
  print_str "ei",newline
  halt_test ei, -4
  halt_test ei, 0
  halt_test ei, 4
  halt_test ei, 8
  halt_test ei, 12
  halt_test ei, 16
  
  print_str newline
  
  print_str "di",newline
  halt_test di, -4
  halt_test di, 0
  halt_test di, 4
  halt_test di, 8
  halt_test di, 12
  halt_test di, 16
  
  ld a, 0
  jp exit

halt_test_begin:
wait_ly:
  lda LY
  sub $91
  jr nz, wait_ly
  ld hl, LCDC
  res 7, [hl]
  sta IF
  inc a
  sta IE
  set 7, [hl]
  call wait_a_bit
  ld de, $0000
  ld hl, $d800
  ret

halt_test_end:
  call div_start
  halt
  inc d
  call div_stop
  di
  push bc
  ld hl, $d800
  ld a, e
  or a
halt_test_end_loop:
  jr z, halt_test_end_done
  ld b, [hl]
  inc hl
  ld c, [hl]
  inc hl
  call print_bc
  dec a
  jr halt_test_end_loop
halt_test_end_done:
  pop bc
  call print_bc
  call print_d
  ret

vblank:
  call div_stop
  ld [hl], b
  inc hl
  ld [hl], c
  inc hl
  inc e
  call div_start
  reti

.bank 0 slot 0
.org $40
  jp vblank
