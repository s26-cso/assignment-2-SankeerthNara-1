.text
.globl make_node
.globl insert
.globl get
.globl getAtMost

make_node:
    addi sp, sp, -16
    sd ra, 8(sp)
    sd s0, 0(sp)

    mv s0, a0
    li a0, 24
    call malloc

    sw s0, 0(a0)
    sd zero, 8(a0)
    sd zero, 16(a0)

    ld ra, 8(sp)
    ld s0, 0(sp)
    addi sp, sp, 16
    ret

insert:
    addi sp, sp, -32
    sd ra, 24(sp)
    sd s0, 16(sp)
    sd s1, 8(sp)

    mv s0, a0
    mv s1, a1

    bnez s0, insert_compare

    mv a0, s1
    call make_node
    j insert_end

insert_compare:
    lw t0, 0(s0)
    beq s1, t0, insert_dup
    blt s1, t0, insert_left

    ld a0, 16(s0)
    mv a1, s1
    call insert
    sd a0, 16(s0)
    j insert_dup

insert_left:
    ld a0, 8(s0)
    mv a1, s1
    call insert
    sd a0, 8(s0)

insert_dup:
    mv a0, s0

insert_end:
    ld ra, 24(sp)
    ld s0, 16(sp)
    ld s1, 8(sp)
    addi sp, sp, 32
    ret

get:
get_loop:
    beqz a0, get_end
    lw t0, 0(a0)

    beq a1, t0, get_end
    blt a1, t0, get_left

    ld a0, 16(a0)
    j get_loop

get_left:
    ld a0, 8(a0)
    j get_loop

get_end:
    ret

getAtMost:
    li a2, -1

gam_loop:
    beqz a1, getAtMost_end

    lw t0, 0(a1)

    beq t0, a0, getAtMost_equal
    bgt t0, a0, getAtMost_left

    mv a2, t0
    ld a1, 16(a1)
    j gam_loop

getAtMost_left:
    ld a1, 8(a1)
    j gam_loop

getAtMost_equal:
    mv a0, t0
    ret

getAtMost_end:
    mv a0, a2
    ret
