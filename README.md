# Washing Machine Controller – Verilog RTL

## 📌 Project Overview

This project implements a simple **Washing Machine Controller** using **Verilog HDL**.

The controller is designed using a **Finite State Machine (FSM)** to control different stages of a washing cycle.

The design includes:

* FSM-based control
* Timer counter
* Washing sequence control
* Rinse control
* Drain control
* Verilog RTL testbench
* Simulation and waveform analysis

---

## 🔄 FSM Architecture

The controller consists of five states:

```text
             coin = 1
                ↓
            ┌───────┐
            │ IDLE  │
            └───┬───┘
                ↓
          ┌───────────┐
          │  COUNTER  │
          └─────┬─────┘
                ↓
            ┌───────┐
            │ WASH  │
            └───┬───┘
                │
       timer_counter > 30
                ↓
            ┌───────┐
            │ RINSE │
            └───┬───┘
                │
             soap = 0
                ↓
            ┌───────┐
            │  DRY  │
            └───┬───┘
                │
              wet = 0
                ↓
             ┌──────┐
             │ IDLE │
             └──────┘
```

---

## 🧠 FSM States

| State     | Description                     |
| --------- | ------------------------------- |
| `IDLE`    | Waits for a coin                |
| `COUNTER` | Starts the washing timer        |
| `WASH`    | Washing/filling water operation |
| `RINSE`   | Rinsing operation               |
| `DRY`     | Draining/drying operation       |

---

## 📥 Inputs

| Signal | Width | Description              |
| ------ | ----- | ------------------------ |
| `clk`  | 1-bit | Clock                    |
| `rst`  | 1-bit | Reset                    |
| `coin` | 1-bit | Starts the washing cycle |
| `wet`  | 1-bit | Indicates wet condition  |
| `soap` | 1-bit | Indicates soap condition |

---

## 📤 Outputs

| Signal          | Width | Description             |
| --------------- | ----- | ----------------------- |
| `Timerbegin`    | 1-bit | Indicates counter state |
| `Fillwater`     | 1-bit | Indicates wash state    |
| `Refill`        | 1-bit | Indicates rinse state   |
| `Drain`         | 1-bit | Indicates dry state     |
| `timer_counter` | 5-bit | Washing timer counter   |

---

## 🛠️ Design Implementation

The RTL contains three main sections:

### 1. Timer Counter

The counter is implemented using sequential logic.

```verilog
always @(posedge clk)
begin
    if (rst)
        timer_counter <= 5'd0;
    else if (coin == 1'b1)
        timer_counter <= timer_counter + 1'b1;
    else
        timer_counter <= 5'd0;
end
```

### 2. State Transition Logic

The current state is updated on every positive clock edge.

```verilog
always @(posedge clk)
begin
    if (rst)
        cst <= IDLE;
    else
        cst <= nst;
end
```

### 3. Next-State Logic

The next state is determined based on the current state and inputs.

```verilog
always @(*)
begin
    case (cst)
        IDLE: ...
        COUNTER: ...
        WASH: ...
        RINSE: ...
        DRY: ...
        default: nst = IDLE;
    endcase
end
```

---

## 🧪 Testbench

A Verilog testbench is provided to verify the controller.

The testbench performs:

1. Clock generation
2. Input initialization
3. Reset operation
4. Coin insertion
5. Timer operation
6. Washing operation
7. Rinse operation
8. Dry operation
9. Waveform generation

The testbench generates a `wave.vcd` file for waveform analysis.

---

## 💻 Tools Used

* **Verilog HDL**
* **QuestaSim 10.7c**
* **Gvim**
* **EDA Playground**
* **VCD waveform**

---

## 📁 Project Structure

```text
washing-machine-controller/
│
├── washer.v
├── washer_tb.v
├── run.do
├── README.md
│
└── wave.vcd
```

---

## ▶️ How to Run

Open the project in QuestaSim and execute:

```tcl
do run.do
```

The RTL and testbench will be compiled and the simulation will run for `1000 ns`.

The important signals can be viewed in the QuestaSim waveform window.

---

## 🎯 Learning Outcomes

Through this project, I practiced:

* Verilog RTL coding
* FSM design
* Sequential logic
* Combinational logic
* Counter design
* Testbench development
* Simulation
* Waveform debugging

---

## 👨‍💻 Author

**THATCHAN G**

Electronics & Communication Engineering
Interested in RTL Design and Design Verification

```
```
