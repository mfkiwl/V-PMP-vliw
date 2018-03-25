## What is V-PMP?
V-PMP stands for *Very Long Instrucion Word* - *Packet Manipulator Processor*. It's a soft core able to execute 8 MIPS-like instructions in parallel per clock cycle. It has been designed to specifically meet the need of packet manipulation tasks. We exploit the *Instruction Level Parallelization* by means of a wider instruction that is divided into 8 *syllables* that are executed in dedicated lanes. This CPU has also dedicated interfaces and memories to access data in a faster way. We will refer to the **core** as the CPU without interfaces, while we will refer to the **systtem** as the entire project. A top view of the core is depicted in the following figure.
![top_view_core](https://github.com/marcux95/V-PMP/blob/master/docs/figs/top.png)

