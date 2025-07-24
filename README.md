# Vicharak_task
Vicharak FPGA Intern Task - By Pranav Kavitkar
19 Bit Architecture

//////////////////////////////////////////////////////////////////////////////////////////////////////

Modules - 
├── TOP.v
│   ├── ALU.v
│   ├── core_control.v
│   ├── data_mem.v
│   ├── gp_regs.v
│   ├── hazard_unit.v
│   ├── IFU.v
│   ├── instruction_deframer.v
│   ├── instruction_mem.v
│   ├── mem_acc.v
│   
└── sim
    └── top_tb.v

//////////////////////////////////////////////////////////////////////////////////////////////////////

**Pipeline Stages**
The processor implements a classic 5-stage RISC pipeline to maximize instruction throughput. Each stage is handled by dedicated Verilog modules.


**Instruction Fetch (IF)**: The Instruction Fetch Unit (IFU) retrieves the next instruction from the instruction memory (instruction_mem) using the address in the Program Counter (PC).



**Instruction Decode (ID):** The instruction_deframer and core_control modules decode the fetched instruction. This stage also reads the necessary source operands from the general-purpose registers 



**Execute (EX):** The Arithmetic Logic Unit (ALU) performs the primary computation, such as an arithmetic or logical operation, as defined by the decoded instruction.


**Memory Access (MEM)**: If the instruction is a load or store, the memory access unit (mem_acc) interacts with the data memory (data_mem) to read from or write to it.


**Write-Back (WB):** The final stage writes the result, either from the ALU or from a memory read, back into the register file.


**hazard_unit** is included in the design to manage data and control hazards, ensuring the pipeline operates correctly.


/////////////////////////////////////////////////////////////////////////////////////////////////////

**Please Refer to Custom Instruction Manual for instructions and their structures**




                                     |   Hazard Unit   |
                                     +-----------------+
                                       ^      |      ^
                                       |      v      |
+-----------------+   +-----------+    | +----+-----+----+      +-----------------+
| PC & Stack Ptr  |-->|    IFU    |--->| | Instruction   |      | General Purpose |
|  (Program Counter)|   +-----------+    | | Deframer &    |----->|   Registers     |
+-----------------+                      | | Core Control  |      |  (incl. SP)     |
                                       | +-------------+      +-----------------+
                                       |       |       ^             |      ^
                                       |       v       |             v      |
                                       |    +--+-------+--+          |      |
                                       |    |      ALU     |          |      |
                                       |    +-------------+          |      |
                                       |            |                |      |
                                       |            v                |      |
                                       |    +-------+------+          |      |
                                       +--> |  Memory Access |        |     |
                                            +--------------+          |      |
                                                    |                /       |
                                                    v               /        |
                                                  (to Write Back)---/----------
