.section .data
fmt: .string "%ld "
nl:  .string "\n"

.section .bss
arr:    .space 800
res:    .space 800
stack:  .space 800

.section .text
.globl main

main:
    # x5 = n
    addi x5, a0, -1        # n = argc - 1
    mv x6, a1              # argv

    li x7, 0               # i = 0

# -------- Read input --------
read_loop:
    bge x7, x5, read_done

    addi x8, x7, 1
    slli x8, x8, 3
    add x8, x6, x8
    ld a0, 0(x8)
    call atoi

    la x9, arr
    slli x10, x7, 3
    add x10, x9, x10
    sd a0, 0(x10)

    addi x7, x7, 1
    j read_loop

read_done:

# -------- res[i] = -1 --------
    li x7, 0
init:
    bge x7, x5, init_done
    la x8, res
    slli x9, x7, 3
    add x9, x8, x9
    li x10, -1
    sd x10, 0(x9)
    addi x7, x7, 1
    j init

init_done:

# -------- Stack logic --------
    li x11, -1         # top = -1
    addi x7, x5, -1    # i = n-1

outer:
    blt x7, zero, finish

while:
    blt x11, zero, end_while

    # stack[top]
    la x8, stack
    slli x9, x11, 3
    add x9, x8, x9
    ld x10, 0(x9)

    # arr[stack[top]]
    la x12, arr
    slli x13, x10, 3
    add x13, x12, x13
    ld x14, 0(x13)

    # arr[i]
    slli x15, x7, 3
    add x15, x12, x15
    ld x16, 0(x15)

    ble x14, x16, pop
    j end_while

pop:
    addi x11, x11, -1
    j while

end_while:

    # if stack not empty → res[i] = stack[top]
    blt x11, zero, skip

    la x8, stack
    slli x9, x11, 3
    add x9, x8, x9
    ld x10, 0(x9)

    la x12, res
    slli x13, x7, 3
    add x13, x12, x13
    sd x10, 0(x13)

skip:

    # push i
    addi x11, x11, 1
    la x8, stack
    slli x9, x11, 3
    add x9, x8, x9
    sd x7, 0(x9)

    addi x7, x7, -1
    j outer

finish:

# -------- Print --------
    li x7, 0

print:
    bge x7, x5, done

    la x8, res
    slli x9, x7, 3
    add x9, x8, x9
    ld x10, 0(x9)

    la a0, fmt
    mv a1, x10
    call printf

    addi x7, x7, 1
    j print

done:
    la a0, nl
    call printf

    li a0, 0
    ret