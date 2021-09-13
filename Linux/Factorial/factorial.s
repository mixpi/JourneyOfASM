# 目的 - 给定一个数字，本程序将计算其阶乘
#   如，3的阶乘是3*2*1=6
#
# 本程序展示了如何递归调用一个函数

.section .data
# 本程序无全局数据

.section .text

.globl _start
.globl factorial        # 如果不与其他程序共享该函数，则无需此项

_start:
    pushl $4            # 阶乘有一个参数
    call factorial      # 运行阶乘函数
    addl $4, %esp       # 恢复栈，弹出入栈的参数
    movl %eax, %ebx     # 阶乘将答案返回到%eax，我们将答案保存到%ebx,作为退出状态
    movl $1, %eax       # 调用内核退出函数
    int $0x80

    # 这是实际函数的定义
    .type factorial, @function
    factorial:
        pushl %ebp      
        movl %esp, %ebp
        movl 8(%ebp), %eax  # 将第一个参数移入%eax

        cmpl $1, %eax       # 如果参数是1，则返回即可
        je end_factorial
        decl %eax           # 参数不是1，值递减
        pushl %eax          # 当作参数入栈
        call factorial      # 递归调用函数
        movl 8(%ebp), %ebx  # %eax中为返回值，因此将参数重新加载至%ebx
        imull %ebx, %eax    # 将与上一次调用的结果相乘
    
    end_factorial:
        movl %ebp, %esp
        popl %ebp
        ret
