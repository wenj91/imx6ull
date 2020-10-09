.global _start

_start:

    /* 
     * 1. 使能时钟， CCGR0~CCGR6 这7个寄存器控制着6ull所有外设时钟的使能。
     * 为了设置CCGR0~CCGR6这7个寄存器全部为0xFFFFFFFF，相当于使能所有外设时钟。 
     */
    ldr r0, =0x020C4068  @ CCGR0
    ldr r1, =0xffffffff @ 要向CCGR0写入的数据
    str r1, [r0]        @ 将oxffffffff写入CCGR0中

    ldr r0, =0x020C406c  @ CCGR1
    str r1, [r0]       @ 将oxffffffff写入CCGR1中

    ldr r0, =0x020C4070  @ CCGR2
    str r1, [r0]       @ 将oxffffffff写入CCGR2中

    ldr r0, =0x020C4074  @ CCGR3
    str r1, [r0]       @ 将oxffffffff写入CCGR3中

    ldr r0, =0x020C4078  @ CCGR4
    str r1, [r0]       @ 将oxffffffff写入CCGR4中

    ldr r0, =0x020C407c  @ CCGR5
    str r1, [r0]       @ 将oxffffffff写入CCGR5中

    ldr r0, =0x020C4080  @ CCGR6
    str r1, [r0]       @ 将oxffffffff写入CCGR6中

    @ IO复用
    @ beep 将寄存器 IOMUXC_SW_MUX_CTL_PAD_GPIO1_IO09 0x020E0080
    @ 的bit3~0设置为0101=5，这样led GPIO4_IO16就复用为GPIO了
    ldr r0, =0x020E0080 @ 
    ldr r1, =0x5
    str r1, [r0]


    /*
     * 寄存器IOMUXC_SW_PAD_CTL_PAD_GPIO1_IO09是设置GPIO1_IO09的电气属性。
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
    @  IOMUXC_SW_PAD_CTL_PAD_GPIO1_IO09 0x020E030C
    ldr r0, =0x020E030C
    ldr r1, =0x000010b0
    str r1, [r0]

    /*
     * 配置GPIO功能，设置输入输出。
     * 设置GPIO1_GDIR寄存器bit9设置为输出模式
     * 设置GPIO1_GDIR寄存器bit9，为1表示输出高电平，为0表示低电平。
     */
    @ GPIO1_GDIR 0x0209C004 bit9 GPIO_9
    ldr r0, =0x0209C004
    ldr r1, =0x200
    str r1, [r0]

    /*
     * 打开beep，也就是设置GPIO1_IO09为0
     * GPIO1_DR寄存器地址为0xffffffff 
     */
    ldr r0, =0x0209C000
    ldr r1, =0xffffffff
    str r1, [r0]

loop:
    b loop