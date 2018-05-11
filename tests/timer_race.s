.define ROM_NAME "TIMER RACE"
.include "shell.inc"

.macro race_test
  xor a
  sta DIV
  delay (\1 - 20) >> 2
  ld a, %110
  sta TAC
  lda TIMA
  call print_a
  xor a
  sta TAC
  sta TIMA
.endm

main:
  ; bits 9,5
  
  ; no change
  race_test 20  ; 0,0 -> 0,0
  race_test 36  ; 0,1 -> 0,1
  race_test 516 ; 1,0 -> 1,0
  race_test 548 ; 1,1 -> 1,1
  print_str newline
  
  ; lower change
  race_test 32  ; 0,0 -> 0,1
  race_test 64  ; 0,1 -> 0,0
  race_test 544 ; 1,0 -> 1,1
  race_test 576 ; 1,1 -> 1,0
  print_str newline
  
  ; upper change
  race_test 512  ; 0,1 -> 1,0
  race_test 1024 ; 1,1 -> 0,0
  print_str newline
  
  jp tests_passed
