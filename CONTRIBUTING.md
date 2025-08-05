# Contributing to AHB to APB Bridge

Thank you for showing interest in contributing! This project implements a Verilog-based bridge between AHB and APB buses following the AMBA specification. Contributions to improve functionality, test coverage, documentation, or simulation workflows are welcome.

---

## 🛠️ Project Setup

1. Clone the repository:
   ```bash
   git clone https://github.com/Yogeshkumar321/AMBA-AHB-to-APB-Bridge
   cd ahb_to_apb_bridge
   ```

2. Open the project in VS Code (optional):
   ```bash
   code ahb_to_apb_bridge.code-workspace
   ```

3. Verilog source files are in `src/`  
   Testbenches are in `tb/`  
   Supporting materials are in `docs/`

4. Simulate using tools like **Vivado**, **ModelSim**, or any preferred simulator.  

---

## 🚀 How You Can Contribute

- 🔧 Fix bugs or improve module behavior
- 🧪 Add new test cases to increase coverage
- 📄 Enhance documentation (README, FSM table, block diagrams)
- 🎯 Optimize FSM transitions or timing
- 🧹 Refactor code for readability or modularity
- 🧰 Add support for other simulation tools or CI setup

---

## 🧬 Code Guidelines

- Use consistent formatting and indentation
- Comment important logic (especially FSM)
- Use descriptive module and signal names
- Keep testbenches clean and modular
- Maintain 100% synthesizability (no `$display`, etc. in RTL)

---

## 📦 Project Structure

```
src/        → RTL modules (AHB slave, APB controller, etc.)
tb/         → Testbenches (AHB master, APB slave, stimulus)
docs/       → Diagrams, PDF references, architecture notes
sim/        → Simulation outputs (dump.vcd, logs)
.github/    → GitHub CI workflows (if used)
```

---

## 📤 How to Contribute

1. Fork the repository
2. Create a new branch:
   ```bash
   git checkout -b feature/<add-burst-read>
   ```
3. Commit your changes with a meaningful message:
   ```bash
   git commit -m "Add burst read support in FSM"
   ```
4. Push and open a Pull Request

---

## 🙋 Need Help?

Feel free to open an [issue](https://github.com/Yogeshkumar321/AMBA-AHB-to-APB-Bridge) for questions, discussions, or feature suggestions.

Happy coding! 🚀
