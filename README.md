## What is V-PMP?
V-PMP stands for *Very Long Instrucion Word* - *Packet Manipulator Processor*. It's a VHDL-described soft-core able to execute 8 MIPS-like instructions in parallel in a single clock cycle. It has been designed to specifically meet the needs of packet manipulation tasks. We exploit the *Instruction Level Parallelization* by means of a wider instruction that is divided into 8 *syllables* that are executed in dedicated lanes. This CPU has also dedicated interfaces and memories to access data with minimum overhead.The top view of the core is depicted in the following figure:

<p align="center"> 
<img src="https://raw.githubusercontent.com/marcux95/V-PMP/master/docs/figs/top.png" width="800"/>
 </p>



