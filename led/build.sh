rm start.bin start.o start.elf start.dis load.imx 
arm-linux-gnueabi-gcc -g -c start.S -o start.o
arm-linux-gnueabi-ld -Ttext 0x87800000 start.o -o start.elf
arm-linux-gnueabi-objcopy -O binary -S -g start.elf start.bin
arm-linux-gnueabi-objdump -D start.elf > start.dis

# 生成imx6ull可执行文件
./imx start.bin