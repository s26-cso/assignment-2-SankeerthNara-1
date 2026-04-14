.text
.globl main
.extern printf
.extern atoi
.extern putchar

.data
fmt: .string "%d "

.bss
arr: .space 8000
res: .space 8000
stack: .space 8000

.text

main:
    addi sp, sp, -48
    sd ra, 40(sp)
    sd s0, 32(sp)
    sd s1, 24(sp)
    sd s2, 16(sp)
    sd s3, 8(sp)

    mv s0, a0
    mv s1, a1

    li s2, 1
    li s3, 0

reading:
    bge s2, s0, read_completed

    slli t0, s2, 3
    add t1, s1, t0
    ld a0, 0(t1)
    call atoi

    slli t2, s3, 3
    la t3, arr
    add t4, t3, t2
    sd a0, 0(t4)

    addi s3, s3, 1
    addi s2, s2, 1
    j reading

read_completed:
    addi t0, s3, -1
    li t1, -1

whynot:
    blt t0, zero, print

while:
    blt t1, zero, next

    la t2, stack
    slli t3, t1, 3
    add t4, t2, t3
    ld t5, 0(t4)

    la t2, arr
    slli t3, t5, 3
    add t4, t2, t3
    ld t5, 0(t4)

    la t2, arr
    slli t3, t0, 3
    add t4, t2, t3
    ld t6, 0(t4)

    blt t6, t5, next

    addi t1, t1, -1
    j while

negative:
    li t5, -1
    sd t5, 0(t4)
    j push_stack   

next:
    la t2, res
    slli t3, t0, 3
    add t4, t2, t3

    blt t1, zero, negative

    la t2, stack
    slli t3, t1, 3
    add t5, t2, t3
    ld t6, 0(t5)

    sd t6, 0(t4)
    j push_stack

push_stack:
    addi t1, t1, 1

    la t2, stack
    slli t3, t1, 3
    add t4, t2, t3
    sd t0, 0(t4)

    addi t0, t0, -1
    j whynot

print:
    li s2, 0

printing:
    bge s2, s3, end

    la t0, res
    slli t1, s2, 3
    add t2, t0, t1
    ld a1, 0(t2)

    la a0, fmt
    call printf

    addi s2, s2, 1
    j printing

end:
    li a0, 10
    call putchar

    li a0, 0

    ld ra, 40(sp)
    ld s0, 32(sp)
    ld s1, 24(sp)
    ld s2, 16(sp)
    ld s3, 8(sp)
    addi sp, sp, 48
    ret
