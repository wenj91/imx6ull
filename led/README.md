# 汇编LED原理分析

为什么要学习Cortex-A汇编
1. 需要用汇编初始化一些SOC外设
2. 使用汇编初始化DDR
3. 设置sp指针，一般指向DDR，设置好C语言运行环境

## LED1对应开发板管脚

led1->RUN_LED->GPIO4_IO16

## imx6ull

imx6ull汇编led的原理

1. 使能时钟， CCGR0~CCGR6 这7个寄存器控制着6ull所有外设时钟的使能。为了设置CCGR0~CCGR6这7个寄存器全部为0xFFFFFFFF，相当于使能所有外设时钟。  
11 Clock is on during all modes, except STOP mode.
2. IO复用，将寄存器IOMUXC_SW_MUX_CTL_PAD_NAND_DQS的bit3~0设置为0101=5，这样led GPIO4_IO16就复用为GPIO了
3. 寄存器IOMUXC_SW_PAD_CTL_PAD_NAND_DQS是设置GPIO4_16的电气属性。
包括压摆率，速度，驱动能力，开漏，上下拉等。
4. 配置GPIO功能，设置输入输出。设置GPIO4_DR寄存器bit16设置为输出模式。设置GPIO4_DR寄存器bit16，为1表示输出高电平，为0表示低电平。

## 编译与链接

### 编译

1. 使用交叉编译工具将.c, .s文件编译成.o
2. 将所有.o文件链接为elf格式的可执行文件
3. 将elf文件转换为bin文件
4. 将elf文件转换为汇编，反汇编

### 编译命令：  
`arm-linux-gnueabi-gcc -g -c start.S -o start.o`

### 链接

链接就是将所有.o文件链接在一起，并且链接到指定地方。 这里链接的时候要制定链接的起始地址。链接起始地址就是代码运行的起始地址。

对于6ull来说链接其实地址就是只想RAM地址。RAM分为内部RAM和外部RAM，也就是DDR。6ull内部RAM地址范围0x900000~0x91FFFF。也可以放到外部DDR中，开发板512M字节DDR范围就是0x80000000~0x9fffffff。

这里采用的起始地址0x87800000为裸机代码的链接起始地址（因为uboot默认起始地址为0x87800000，所以这里一致统一）。要使用DDR，那么必须要初始化DDR，对于bin文件不能直接运行，需要添加一个头部，这个头部信息包含了DDR的初始化参数，imx系列soc内部boot rom会从sdcard，emmc等外置存储中读取头部信息，然后初始化ddr，并且将bin文件拷贝到指定地方。

bin的运行地址一定要和链接起始地址一致。位置无关代码除外。

### 链接命令:   

`arm-linux-gnueabi-ld -Ttext 0x87800000 start.o -o start.elf`

### 转换为bin文件命令:

`arm-linux-gnueabi-objcopy -O binary -S -g start.elf start.bin`

### 反汇编：

`arm-linux-gnueabi-objdump -D start.elf > start.dis`
