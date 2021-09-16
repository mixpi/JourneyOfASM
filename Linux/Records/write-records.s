.include "linux.s"
.include "record-def.s"

.section .data
# 想要写入的常量数据
# 每个数据项以空字节（0）填充到适当的长度

# .rept用于填充每一项。
# .rept和.endr之间的段重复指定次数
# 在这个程序中，此指令用于将多余的空白字符增加到每个字段末尾以将之填满
record1:
    .ascii "Fredrick\0"
    .rept 31 # 填充到40字节
    .byte 0
    .endr

    .ascii "Bartlett\0"
    .rept 31 # 填充到40字节
    .byte 0
    .endr

    .ascii "4242 S Prairie\nTulsa, OK 55555\0"
    .rept 209 # 填充到240字节
    .byte 0
    .endr

    .long 45

record2:
    .ascii "Marilyn\0"
    .rept 32 # 填充到40字节
    .byte 0
    .endr

    .ascii "Taylor\0"
    .rept 33
    .byte 0
    .endr

    .ascii "2224 S Johannan St\nChicago, IL 12345\0"
    .rept 203
    .byte 0
    .endr

    .long 29

record3:
    .ascii "Derrick\0"
    .rept 32
    .byte 0
    .endr

    .ascii "McIntire\0"
    .rept 31
    .byte 0
    .endr

    .ascii "500 W Oakland\nSan Diego, CA 54321\0"
    .rept 206
    .byte 0
    .endr

    .long 36

file_name:
    # 要写入文件的文件名：
    .ascii "test.dat\0"

    .equ ST_FILE_DESCRIPTOR, -4
    .globl _start

_start:
    movl %esp,%ebp
    subl $4, %esp

    # 打开输入文件
    movl $SYS_OPEN, %eax
    movl $file_name, %ebx
    movl $0101, %ecx    # 本指令表明如文件不存在则创建，并打开文件用于写入
    movl $0666, %edx
    int $LINUX_SYSCALL

    # 存储文件描述符
    movl %eax, ST_FILE_DESCRIPTOR(%ebp)

    # 写第一条记录
    pushl ST_FILE_DESCRIPTOR(%ebp)
    pushl $record1
    call write_record
    addl $8, %esp
    
    # 写第二条记录
    pushl ST_FILE_DESCRIPTOR(%ebp)
    pushl $record2
    call write_record
    addl $8, %esp

    # 写第三条记录
    pushl ST_FILE_DESCRIPTOR(%ebp)
    pushl $record3
    call write_record
    addl $8, %esp

    # 关闭文件描述符
    movl $SYS_CLOSE, %eax
    movl ST_FILE_DESCRIPTOR(%ebp), %ebx
    int $LINUX_SYSCALL

    # 退出程序
    movl $SYS_EXIT, %eax
    movl $0, %ebx
    int $LINUX_SYSCALL

