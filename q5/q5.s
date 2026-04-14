.section .data
filename: .string "input.txt"
mode: .string "r"
yes: .string "Yes\n"
no:  .string "No\n"

.section .text
.globl main

.extern fopen
.extern fseek
.extern ftell
.extern fgetc
.extern printf

main:
    la a0, filename
    la a1, mode
    call fopen
    mv s0, a0

    mv a0, s0
    li a1, 0
    li a2, 2
    call fseek

    mv a0, s0
    call ftell
    mv s1, a0

    addi s1, s1, -1
    li s2, 0

loop:
    bge s2, s1, palindrome

    mv a0, s0
    mv a1, s2
    li a2, 0
    call fseek

    mv a0, s0
    call fgetc
    mv t0, a0

    mv a0, s0
    mv a1, s1
    li a2, 0
    call fseek

    mv a0, s0
    call fgetc
    mv t1, a0

    bne t0, t1, not_pal

    addi s2, s2, 1
    addi s1, s1, -1
    j loop

palindrome:
    la a0, yes
    call printf
    j exit

not_pal:
    la a0, no
    call printf

exit:
    li a0, 0
    ret