.global _start

_start:

    /* 
     * 1. 使能时钟， CCGR0~CCGR6 这7个寄存器控制着6ull所有外设时钟的使能。
     * 为了设置CCGR0~CCGR6这7个寄存器全部为0xFFFFFFFF，相当于使能所有外设时钟。 
     */
    ldr r0, =0x020C4068     @ CCGR0
    ldr r1, =0xffffffff     @ 要向CCGR0写入的数据
    str r1, [r0]            @ 将oxffffffff写入CCGR0中

    ldr r0, =0x020C406c     @ CCGR1
    str r1, [r0]            @ 将oxffffffff写入CCGR1中

    ldr r0, =0x020C4070     @ CCGR2
    str r1, [r0]            @ 将oxffffffff写入CCGR2中

    ldr r0, =0x020C4074     @ CCGR3
    str r1, [r0]            @ 将oxffffffff写入CCGR3中

    ldr r0, =0x020C4078     @ CCGR4
    str r1, [r0]            @ 将oxffffffff写入CCGR4中

    ldr r0, =0x020C407c     @ CCGR5
    str r1, [r0]            @ 将oxffffffff写入CCGR5中

    ldr r0, =0x020C4080     @ CCGR6
    str r1, [r0]            @ 将oxffffffff写入CCGR6中

    /*
     * IO复用，将寄存器IOMUXC_SW_MUX_CTL_PAD_NAND_DQS 0x020E01B8  
     * 的bit3~0设置为0101=5，这样led GPIO4_IO16就复用为GPIO了
     */
    ldr r0, =0x020E01B8 @ 
    ldr r1, =0x5
    str r1, [r0]


    /*
     * 寄存器IOMUXC_SW_PAD_CTL_PAD_NAND_DQS是设置GPIO4_16的电气属性。
     * 包括压摆率，速度，驱动能力，开漏，上下拉等。
     * bit0: 0 低速率
     * bit5:3:  110 R0/6驱动能力
     * bit7:6: 10 100MHz速度
     * bit11: 0 关闭开路输出
     * bit12: 1 使能pull/kepper
     * bit13: 0 kepper
     * bit15:14: 00 100k下拉
     * bit16: 0 关闭hys
     * final=0x10b0 
     */
    ldr r0, =0x020E0444
    ldr r1, =0x000010b0
    str r1, [r0]

    /*
     * 配置GPIO功能，设置输入输出。
     * 设置GPIO4_GDIR寄存器bit16设置为输出模式。 0x020A8004
     * 设置GPIO4_GDIR寄存器bit16，为1表示输出高电平，为0表示低电平。
     */
    ldr r0, =0x020A8004
    ldr r1, =0x10000
    str r1, [r0]

    /*
     * 打开LED，也就是设置GPIO4_IO16为1
     * GPIO4_DR寄存器地址为0x020A8000 
     */
    ldr r0, =0x020A8000
    ldr r1, =0xffffffff
    str r1, [r0]
/*
 * 死循环
 */
loop:
    bl delay            @延迟1s

    ldr r1, =0x0        @熄灭led
    str r1, [r0]

    bl delay            @延迟1s
    ldr r1, =0xffffffff @点亮led
    str r1, [r0]

    b loop

/*
 * 延迟1s（大概值）
 */
delay:
	mov r5,#0x200000
temp:
	sub r5,r5,#1
	cmp r5,#0
	bne temp
	bx lr 