# Vicharak\_task

**Vicharak FPGA Intern Task - By Pranav Kavitkar (19-Bit Architecture)**

---

## 📁 Modules

This project consists of several Verilog modules that form the processor core and its simulation environment.

```
├── rtl/
│   ├── TOP.v
│   ├── ALU.v
│   ├── core_control.v
│   ├── data_mem.v
│   ├── gp_regs.v
│   ├── hazard_unit.v
│   ├── IFU.v
│   ├── instruction_deframer.v
│   ├── instruction_mem.v
│   └── mem_acc.v
│
└── sim/
    └── top_tb.v
```

---

## 🤩 Pipeline Stages

The processor implements a classic **5-stage RISC pipeline** to maximize instruction throughput. Each stage is handled by dedicated Verilog modules.

* **Instruction Fetch (IF)**:
  The Instruction Fetch Unit (`IFU`) retrieves the next instruction from the instruction memory (`instruction_mem`) using the Program Counter (`PC`).

* **Instruction Decode (ID)**:
  The `instruction_deframer` and `core_control` modules decode the fetched instruction. This stage also reads the necessary source operands from `gp_regs`.

* **Execute (EX)**:
  The Arithmetic Logic Unit (`ALU`) performs arithmetic or logical operations as defined by the decoded instruction.

* **Memory Access (MEM)**:
  For load/store instructions, `mem_acc` accesses the `data_mem` to read/write data.

* **Write-Back (WB)**:
  The final result (from ALU or memory) is written back to the register file.

📅 The `hazard_unit` is used to manage data and control hazards, ensuring the pipeline flows smoothly.

---

## 🧠 Processor Architecture

Refer to the “Custom Instruction Manual” for complete instruction structures.

```
                                     +-----------------+
                                     |   Hazard Unit   |
                                     +-----------------+
                                       ^      |      ^
                                       |      v      |
+-----------------+   +-----------+    | +----v-----+----+      +-----------------+
| PC / Stack Ptr  |-->|    IFU    |--->| | Instruction   |      | General Purpose |
| (Program Counter)|   +-----------+    | | Deframer &    |----->|   Registers     |
+-----------------+                      | | Core Control  |      |  (incl. SP)     |
                                       | +-------------+      +-----------------+
                                       |       |       ^             |      ^
                                       |       v       |             v      |
                                       |    +--+-------+--+          |      |
                                       +--> |      ALU     | <--------+      |
                                            +-------------+                 |
                                                  |                       |
                                                  v                       |
                                            +-----+--------+              |
                                       +--> | Memory Access|              |
                                            +--------------+              |
                                                  |                       |
                                                  v                       |
                                            (to Write Back)---------------+
```
