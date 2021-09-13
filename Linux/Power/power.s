# 目的： 展示函数如何工作的程序
#   本程序将计算2^3 + 5^2
#

# 主程序中的所有内容都存储在寄存器中,因此数据段不含任何内容
.section .data
.section .text
.globl _start
_start:
    pushl $3            # 压入第二个参数
    pushl $2            # 压入第一个参数
    call power          # 调用函数
    addl $8, %esp       # 将栈指针向后移动,覆盖$2,$3
    pushl %eax          # 上一个函数的返回值，即2^3的值，调用第二个函数前压入栈
    pushl $2            # 压入第二个参数
    pushl $5            # 压入第一个参数
    call power          # 调用函数
    addl $8, %esp       # 将栈恢复到调用前，即覆盖$5,$2
    popl %ebx           # 第一个函数的返回值被压入栈中，此时弹出到ebx中，第二个函数的返回值在eax中
    addl %eax, %ebx     # 计算8+25结果保留在ebx中
    movl $1, %eax       # 系统调用参数，代表退出
    int $0x80           # 系统调用

    #   目的： 本函数用于计算一个数的幂
    #
    #   输入：  第一个参数-底数
    #           第二个参数-底数的指数
    #
    #   输出：  以返回值的形式给出结果
    #
    #   注意：  指数必须大于等于1
    #
    #   变量：  %ebx------保存底数
    #           %ecx------保存指数
    #
    #           -4(%ebp)---保存当前结果
    #           %eax用于暂时存储
    #
    .type power, @function
    power:
        pushl %ebp                  # 保存旧基址指针
        movl %esp, %ebp             # 将基址指针设为栈空间
        sub $4, %esp                # 为本地存储保留空间

        movl 8(%ebp), %ebx          # 将第一个参数放入%ebx
        movl 12(%ebp), %ecx         # 将第二个参数放入%ecx
        movl %ebx, -4(%ebp)         # 存储当前结果

        power_loop_start:
            cmpl $1, %ecx           # 如果是1次方，那么我们已经获得结果
            je end_power
            movl -4(%ebp), %eax     # 将当前结果移入%eax
            imull %ebx, %eax        # 将当前结果与底数相乘
            movl %eax, -4(%ebp)     # 保存当前结果

            decl %ecx               # 指数递减
            jmp power_loop_start    # 为递减后的指数进行幂计算

        end_power:
            movl -4(%ebp), %eax     # 返回值移入%eax
            movl %ebp, %esp         # 恢复栈指针
            popl %ebp               # 恢复基址指针
            ret      
      