.section .text
.globl make_node
.globl insert
.globl get
.globl getAtMost
.extern malloc

# make_node(int val)
make_node:
    mv x20, ra          # save return address
    mv x21, a0          # val

    li a0, 24
    call malloc

    mv x22, a0          # node pointer

    sd x21, 0(x22)      # val
    li x23, 0
    sd x23, 8(x22)      # left
    sd x23, 16(x22)     # right

    mv a0, x22

    mv ra, x20          # restore ra
    ret


# insert(root=a0, val=a1)
insert:
    mv x20, ra

    beq a0, x0, insert_null

    ld x21, 0(a0)
    blt a1, x21, go_left

# go right
    ld x22, 16(a0)
    mv x23, a0

    mv a0, x22
    call insert

    sd a0, 16(x23)
    mv a0, x23
    j insert_end

go_left:
    ld x22, 8(a0)
    mv x23, a0

    mv a0, x22
    call insert

    sd a0, 8(x23)
    mv a0, x23
    j insert_end

insert_null:
    mv a0, a1
    call make_node

insert_end:
    mv ra, x20
    ret


# get(root=a0, val=a1)
get:
    beq a0, x0, get_null

    ld x21, 0(a0)
    beq x21, a1, found
    blt a1, x21, go_left_g

# go right
    ld a0, 16(a0)
    j get

go_left_g:
    ld a0, 8(a0)
    j get

found:
    ret

get_null:
    li a0, 0
    ret


# getAtMost(val=a0, root=a1)
getAtMost:
    li x20, -1      # answer

loop:
    beq a1, x0, done

    ld x21, 0(a1)
    bgt x21, a0, go_left2

    mv x20, x21
    ld a1, 16(a1)
    j loop

go_left2:
    ld a1, 8(a1)
    j loop

done:
    mv a0, x20
    ret