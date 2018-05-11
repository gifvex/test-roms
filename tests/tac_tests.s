.define ROM_NAME "TAC TESTS"
.include "shell.inc"

.macro tac_test
  wreg TAC, \1
  xor a
  sta TIMA
  sta DIV
  delay 1024 + ((\3 - 20) >> 2)
  wreg TAC, 4 | \2
  lda TIMA
  call print_a
.endm

.macro tac_test_set
  print_str "0\1|"
  tac_test \1, 0, \2
  tac_test \1, 1, \2
  tac_test \1, 2, \2
  tac_test \1, 3, \2
  print_str newline
.endm

main:
  print_str "   00 01 02 03",newline
  print_str "   -----------",newline
  tac_test_set 0, 512
  tac_test_set 1, 8
  tac_test_set 2, 32
  tac_test_set 3, 128
  
  jp tests_passed
