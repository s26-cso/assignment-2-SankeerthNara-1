.section .data
fmt:    .string "%ld "
newline:.string "\n"

.section .bss
.lcomm arr, 800        # input array (max 100 elements)
.lcomm res, 800        # result array
.lcomm stack, 800      # stack (stores indices)

.section .text
.globl main

main:
    mv x20, a0      #a0=no of arguments ie n+1
    addi x20, x20, -1     #x20=n
    mv x21, a1            #x21 stores addresses of the values
    li x22, 0             #x22 is i 

parse_loop:
    bge x22, x20, parse_done     #if i==n go to parse_done

    addi x23, x22, 1           #x23 = x22+1 i.e i+1
    slli x23, x23, 3           #x23 = x23*8 i.e (i+1)*8
    add x23, x21, x23          
    ld x24, 0(x23)             

    mv a0, x24
    call atoi                  #strings to integers

    slli x25, x22, 3
    la x26, arr
    add x25, x26, x25
    sd a0, 0(x25)

    addi x22, x22, 1
    j parse_loop

parse_done:
    li x22, 0
init_res:
    bge x22, x20, init_done
    slli x23, x22, 3
    la x24, res
    add x23, x24, x23
    li x25, -1
    sd x25, 0(x23)
    addi x22, x22, 1
    j init_res

init_done:


    li x30, -1       
    addi x22, x20, -1  

outer_loop:
    blt x22, zero, done


while_loop:
    blt x30, zero, end_while

    la x23, stack
    slli x24, x30, 3
    add x24, x23, x24
    ld x25, 0(x24)      

    # arr[stack[top]]
    la x26, arr
    slli x27, x25, 3
    add x27, x26, x27
    ld x28, 0(x27)

    # arr[i]
    slli x29, x22, 3
    add x29, x26, x29
    ld x31, 0(x29)

    ble x28, x31, pop_stack
    j end_while

pop_stack:
    addi x30, x30, -1
    j while_loop

end_while:

    blt x30, zero, skip_assign

    la x23, stack
    slli x24, x30, 3
    add x24, x23, x24
    ld x25, 0(x24)

    la x26, res
    slli x27, x22, 3
    add x27, x26, x27
    sd x25, 0(x27)

skip_assign:

    addi x30, x30, 1
    la x23, stack
    slli x24, x30, 3
    add x24, x23, x24
    sd x22, 0(x24)

    addi x22, x22, -1
    j outer_loop

done:

    li x22, 0

print_loop:
    bge x22, x20, print_done
    la x23, res
    slli x24, x22, 3
    add x24, x23, x24
    ld x25, 0(x24)

    la a0, fmt
    mv a1, x25
    call printf

    addi x22, x22, 1
    j print_loop

print_done:
    la a0, newline
    call printf

    li a0, 0
    ret