# 目的：退出并向Linux内核返回一个状态码的简单程序
#
# 输入： 无
# 
# 输出： 返回一个状态码。在运行程序后可通过输入echo $？来读取状态码
#
# 变量：
#   $eax保存系统调用号
#   $ebx保存返回状态
.section .data
.section .text
.globl _start
_start:
    movl $1, %eax # 这是用于退出程序的Linux内核命令号(系统调用)
    movl $0, %ebx # 返回给操作系统的状态码
                  # 改变这个数字，则返回到echo $?的值会不同
    int $0x80     # 唤醒内核，以运行退出命令