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
