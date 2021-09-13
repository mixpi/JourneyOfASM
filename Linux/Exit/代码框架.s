# 这种符号代表注释,注释通常包含代码目的、概述等内容

# 以.开始的指令都不会被直接翻译成机器指令，由汇编程序处理，被称为汇编指令或者伪指令
# .section指令将程序分成几个部分
# .section .data代表数据段的开始
.section .data
# 数据段中要列出程序所需要的所有内存存储空间 

# .section .text代表文本端的开始，文本段是存放程序指令的地方
.section .text
# .globl表示汇编程序不应在汇编之后废弃此符号，因为连接器需要它
# _start是一个特殊符号，总是用.globl标记，标记程序的开始位置
.globl _start

# _start：表示标签的开始位置，
_start:
    # 此处编写汇编代码



# 将functionname标记开始处当作函数使用
.type functionname, @function
funcitonname:
    # funciton code