# 目的：    本程序将输入文件的所有字母转换为大写字母,输出到存储文件
# 
# 处理过程：    1、打开输入文件
#               2、打开输出文件
#               3、如果未达到输入文件尾部：
#                   a、将部分文件读入内存缓冲区
#                   b、读取内存缓冲区的每个字节，如果该字节为小写字母，则转换为大写字母
#                   c、将内存缓冲区写入输出文件

.section .data

### 常数 ###

# 系统调用号
.equ SYS_OPEN, 5
.equ SYS_WRITE, 4
.equ SYS_READ, 3
.equ SYS_CLOSE, 6
.equ SYS_EXIT, 1

# 文件打开选项
.equ O_RDONLY, 0
.equ O_CREAT_WRONLY_TRUNC, 03101

# 标准文件描述符
.equ STDIN, 0
.equ STDOUT, 1
.equ STDERR, 2

# 系统调用中断
.equ LINUX_SYSCALL, 0x80
.equ END_OF_FILE, 0     # 读操作的返回值,表明到达文件结束处
.equ NUMBER_ARGUMENTS, 2

.section .bss
# 缓冲区 - 从文件中将数据加载到这里，也从这里将数据写入输出文件，缓冲区大小不超过16000字节
.equ BUFFER_SIZE, 500
.lcomm BUFFER_DATA, BUFFER_SIZE

.section .text

# 栈位置
.equ ST_SIZE_RESERVE, 8
.equ ST_FD_IN, -4
.equ ST_FD_OUT, -8
.equ ST_ARGC, 0 # 参数数目
.equ ST_ARGV_0, 4 # 程序名
.equ ST_ARGV_1, 8 # 输入文件名
.equ ST_ARGV_2, 12 # 输出文件名

.globl _start
_start:
    ### 程序初始化 ###
    # 保存栈指针
    movl %esp, %ebp

    # 在栈上为文件描述符分配空间
    subl $ST_SIZE_RESERVE, %esp

    open_files:
    open_id_in:
        ### 打开输入文件 ###
        # 打开系统调用
        movl $SYS_OPEN, %eax
        # 将输入文件名放入%ebx
        movl ST_ARGV_1(%ebp), %ebx  
        # 只读标志
        movl $O_RDONLY, %ecx
        movl $0666, %edx
        int $LINUX_SYSCALL
    
    store_fd_in:
        ### 保存给定的文件描述符,描述符保存在%eax中
        movl %eax, ST_FD_IN(%ebp)
    
    open_fd_out:
        ### 打开输出文件 ###
        # 打开文件
        movl $SYS_OPEN, %eax
        # 将输出文件名放入%ebx
        movl ST_ARGV_2(%ebp), %ebx
        # 写入文件标志
        movl $O_CREAT_WRONLY_TRUNC, %ecx
        # 新文件模式
        movl $0666, %edx
        int $LINUX_SYSCALL
    
    store_fd_out:
        movl %eax, ST_FD_OUT(%ebp)

    read_loop_begin:
        ### 主循环开始 ###
        ### 从输入文件中读取一个数据块 ###
        movl $SYS_READ, %eax
        # 获取输入文件描述符
        movl ST_FD_IN(%ebp), %ebx
        # 放置读取数据的存储位置
        movl $BUFFER_DATA, %ecx
        # 缓冲区大小
        movl $BUFFER_SIZE, %edx
        # 读取缓冲区大小返回到%eax中
        int $LINUX_SYSCALL

        ### 如达到文件结束处就退出 ###
        # 检查文件结束标记
        cmpl $END_OF_FILE, %eax
        # 如果发现文件结束符或出现错误，就跳转到程序结束处
        jle end_loop
    
    continue_read_loop:
        ### 将字符块内容转换成大写形式 ###
        pushl $BUFFER_DATA # 缓冲区位置
        pushl %eax          # 缓冲区大小
        call convert_to_upper
        popl %eax   # 重新获取大小
        addl $4, %esp       # 恢复%esp
        

