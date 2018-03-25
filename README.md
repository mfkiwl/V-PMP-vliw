## What is V-PMP?
V-PMP stands for *Very Long Instrucion Word* - *Packet Manipulator Processor*. It's a VHDL-described soft-core able to execute 8 MIPS-like instructions in parallel in a single clock cycle. It has been designed to specifically meet the need of packet manipulation tasks. We exploit the *Instruction Level Parallelization* by means of a wider instruction that is divided into 8 *syllables* that are executed in dedicated lanes. This CPU has also dedicated interfaces and memories to access data in a faster way. We will refer to the **core** as the CPU without interfaces, while we will refer to the **system** as the entire project. A top view of the core is depicted in the following figure:
![top_view_core](https://github.com/marcux95/V-PMP/blob/master/docs/figs/top.png)

## Getting started
### Requirements
V-PMP has been tested and synthesized on a [NetFPGA SUME](https://github.com/NetFPGA/NetFPGA-SUME-public/wiki) and the system his heavily tied to the IP Cores provided along with this device. Altough the core will work under any circumstances, the interfaces will be surely have to be adapted to meet the target FPGA architecture. In order to jumpstart with V-PMP, we will assume that you have:
* **NetFPGA SUME** (Not needed if you want only simulate)
* **Licensed Xilinx Vivado 201X.Y** (follow NetFPGA wiki)
* **This Repository**

