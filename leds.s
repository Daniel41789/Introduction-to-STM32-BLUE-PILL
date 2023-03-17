.include "gpio.inc" @ Includes definitions from gpio.inc file

.thumb              @ Assembles using thumb mode
.cpu cortex-m3      @ Generates Cortex-M3 instructions
.syntax unified

.include "nvic.inc"

delay:
        # Prologue
        push    {r7} @ backs r7 up
        sub     sp, sp, #28 @ reserves a 32-byte function frame
        add     r7, sp, #0 @ updates r7
        str     r0, [r7] @ backs ms up
        # Body function
        mov     r0, #255 @ ticks = 255, adjust to achieve 1 ms delay
        str     r0, [r7, #16]
# for (i = 0; i < ms; i++)
        mov     r0, #0 @ i = 0;
        str     r0, [r7, #8]
        b       F3
# for (j = 0; j < tick; j++)
F4:     mov     r0, #0 @ j = 0;
        str     r0, [r7, #12]
        b       F5
F6:     ldr     r0, [r7, #12] @ j++;
        add     r0, #1
        str     r0, [r7, #12]
F5:     ldr     r0, [r7, #12] @ j < ticks;
        ldr     r1, [r7, #16]
        cmp     r0, r1
        blt     F6
        ldr     r0, [r7, #8] @ i++;
        add     r0, #1
        str     r0, [r7, #8]
F3:     ldr     r0, [r7, #8] @ i < ms
        ldr     r1, [r7]
        cmp     r0, r1
        blt     F4
        # Epilogue
        adds    r7, r7, #28
        mov	    sp, r7
        pop	    {r7}
        bx	    lr

reset:
    @ prologue
    push {r7, lr}
    sub sp, sp, #8
    add r7, sp, #0
    str r0, [r7, #4]
    @ body function
    ldr r1, = GPIOB_ODR
    mov r2, 0x0
    str r2, [r1]
    str r2, [r7, #4]
    mov r0, #500
    bl delay
    ldr r0, [r7, #4]

    @ epilogue
    adds r7, r7, #8
    mov sp, r7
    pop {r7}
    pop {lr}
    bx lr

incremento:
    @ prologue
    push {r7, lr}
    sub sp, sp, #8
    add r7, sp, #0
    str r0, [r7, #4]        @ store argument of function
    @ end of prologue

    @ body function
    ldr r0, [r7, #4]        @ load c into r0
    adds r0, r0, #1         @ c++
    str r0, [r7,#4]         @ store c++
    ldr r0, [r7, #4]
    ldr r1, =0x100          @ load 256 in r1 -> 2 ^ 8 Leds = 256
    cmp r0, r1              @ compare r0 with r1
    bgt reset               @ branch to reset
    str r0, [r7, #4]

    @ pin writing
    ldr r2, =GPIOB_ODR
    ldr r0, [r7, #4]
    mov r1, r0
    lsl r1, r1, #8
    str r1, [r2]
    mov r0, #500
    bl delay
    ldr r0, [r7, #4]
    @ epilogue
    adds r7, r7, #8
    mov sp, r7
    pop {r7}
    pop {lr}
    bx lr

decremento:
    @ prologue
    push {r7, lr}
    sub sp, sp, #8
    add r7, sp, #0
    str r0, [r7, #4]
    
    @ body function
    ldr r0, [r7, #4]
    sub r0, r0, #1          @ r0 <- r0 - 1 
    str r0, [r7, #4]        @ store r0 in d
    ldr r0, [r7, #4]
    cmp r0, #0
    blt reset
    str r0, [r7, #4]

    @ pin writing
    ldr r2, =GPIOB_ODR
    ldr r0, [r7, #4]        @ load d into r0
    mov r1, r0
    lsl r1, r1, #8
    str r1, [r2]
    mov r0, #500
    bl delay
    ldr r0, [r7, #4]

    @ epilogue
    adds r7, r7, #8
    mov sp, r7
    pop {r7}
    pop {lr}
    bx lr

setup: 
    @ prologue 
    push {r7, lr}
    sub sp, sp, #8
    add r7, sp, #0

    @ enabling clock in port A, B and C
    ldr r0, =RCC_APB2ENR
    mov r1, 0x1C
    str r1, [r0]

    @ set pins PA0 & PA4 as digital input
    ldr r0, =GPIOA_CRL
    ldr r1, =0x44484448
    ldr r1, [r0]

    @ set pins PB8 - PB15 as digital output
    ldr r0, =GPIO_CRH
    ldr r1, =0x33333333
    str r1, [r0]

    @ set led status initial value 
    ldr r1, =GPIOB_ODR
    mov r2, 0x0
    str r2, [r1]

    mov r1, 0x0
    str r1, [r7, #4]

loop:
    ldr r0, =GPIOA_IDR
    ldr r0, [r0]
    and r0, r0, #17
    cmp r0, #17
    bne .L1
    bl reset
    str r0, [r7, #4]
    mov r0, #500
    bl delay

.L1:
    @ verificación del 'push button' (PA0)
    ldr r0, =GPIOA_IDR
    ldr r0, [r0]
    and r0, r0, #1
    cmp r0, #1
    bne .L2
    ldr r0, [r7,#4]
    bl incremento
    str r0, [r7, #4]

.L2:
    @ verificación del 'push button' (PA4)
    ldr r0, =GPIOA_IDR
    ldr r0, [r0]
    and r0, r0, #16
    cmp r0, #16
    bne .L3
    ldr r0, [r7, #4]
    bl decremento
    str r0, [r7, #4]

.L3:
    b loop
