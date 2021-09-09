# 目的：本程序寻找一组数据项中的最大值
#
# 变量：寄存器有以下用途：
#       %edi - 保存正在检测的数据项索引
#       %ebx - 当前已经找到的最大数据项
#       %eax - 当前数据项
#
# 使用以下内存位置：
#       data_items - 包含数据项，0表示数据结束
#

.section .data
data_items:    # 以下是数据项
    .long 3,67,34,222,45,75,54,34,44,33,22,11,66,0

.section .text
.globl _start
_start:
    movl  $0, %edi                  # 将0移入索引寄存器
    movl data_items(,%edi,4),%eax   # 加载数据的第一个字节
    movl %eax, %ebx                 # 当前的最大值放入%ebx

start_loop:                         # 标记，用来进行循环
    cmpl $0, %eax                   # 检测是否已经是数据末尾
    je loop_exit
    incl %edi                       # 加载下一个值
    movl data_items(, %edi,4), %eax
    cmpl %ebx, %eax                 # 将当前值与最大值比较
    jle start_loop                  # 当前值不大于最大值，继续循环
    movl %eax, %ebx                 # 大于最大值，则将该值移入最大值
    jmp start_loop                  # 再次进入循环代码

loop_exit:                          #标记，用于退出循环
                                    # %ebx中保存的是最大值，也是系统调用exit的状态码
    movl $1, %eax                   # 1是exit()系统调用
    int $0x80
