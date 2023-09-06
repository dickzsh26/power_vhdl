# power_vhdl
在电力电子中常用的verilog模块

## 目录结构

- software内是运行本项目必须安装的软件，包括iverilog（用于综合verilog代码并仿真查看波形）和make软件（用于写命令行脚本）
- user
    - sim 仿真测试目录，这里有模块的tesebench，以及makefile代码，用来跑代码的仿真并查看波形
    - src 模块的verilog代码
## 使用方法
首先进入`/user/src`文件夹下的开发需要的verilog模块，然后进入`/user/sim/`复制任意一个文件夹并改名为你对应要测试的模块。

然后修改`testbench.v`代码为你需要的testbench代码，注意修改第一行的include路径。

然后进入对应的sim文件夹
```bash
cd /user/sim/test_xxx
```

在命令行执行make即可编译代码并打开波形查看器查看波形。

如果更新了代码，可以新建一个terminal饼进入刚刚的sim文件夹，输入
```bash
make vcd
```
即可重新仿真波形，此时打开gtkwave点击刷新波形即可。
