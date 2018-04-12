.define ROM_NAME "HALT PRIORITY"
.include "shell.inc"

main:
  print_str "ADDRESSES:",newline
  ld hl, main_addresses
  call print_hl
  print_str "NOP",newline
  inc hl
  call print_hl
  print_str "HALT",newline
  inc hl
  call print_hl
  print_str "NOP",newline
  
wait_ly:
  lda LY
  sub $91
  jr nz, wait_ly
  
  ld hl, LCDC
  res 7, [hl]
  sta IF
  ei
  inc a
  sta IE
  set 7, [hl]
  
  call wait_a_bit
  
main_addresses:
  nop
  halt
  nop
  
  di
  
  print_str newline,"RETS:",newline
  ld hl, sp-1
  ld c, a
  add hl, bc
  add hl, bc
print_rets:
  ld d, [hl]
  dec hl
  ld e, [hl]
  dec hl
  call print_de
  print_str newline
  dec c
  jr nz, print_rets
  
  cp 2
  jp nz, test_failed
  
  jp tests_passed

wait_a_bit:
  ld bc, $0927
wait_a_bit_more:
  dec bc
  ld a, b
  or c
  jr nz, wait_a_bit_more
  ret

vblank:
  pop hl
  push hl
  push hl
  inc a
  reti

.bank 0 slot 0
.org $40
  jp vblank
