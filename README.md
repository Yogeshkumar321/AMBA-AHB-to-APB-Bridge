# AMBA-AHB-to-APB-Bridge

## Overview

This project implements a synthesizable AHB to APB Bridge using Verilog, designed to interface the high-performance Advanced High-performance Bus (AHB) with the low-power Advanced Peripheral Bus (APB) as per the AMBA specification. The bridge facilitates seamless data transfers between AHB masters and APB slaves, supporting single read/write operations, burst write transfers, and timeout handling. The design is verified through a comprehensive testbench that includes four test cases: single write, single read, burst write, and timeout handling. 

## About the AMBA Buses

The Advanced Microcontroller Bus Architecture (AMBA) is an on-chip communication standard for high-performance embedded systems. It defines three primary buses:

- **Advanced High-performance Bus (AHB)**: A high-performance backbone bus for connecting processors, on-chip memories, and external memory interfaces with high clock frequencies.
- **Advanced System Bus (ASB)**: An alternative high-performance bus for systems not requiring AHB's advanced features.
- **Advanced Peripheral Bus (APB)**: A low-power bus optimized for minimal power consumption and reduced interface complexity, ideal for peripheral devices.

The AHB to APB Bridge serves as an interface between the AHB (system bus) and APB (peripheral bus), as shown below:

![AMBA System](https://user-images.githubusercontent.com/91010702/194475317-68a7f60d-65ea-48de-a13a-fd85e25c364b.png)

## Basic Terminology

- **Bus Cycle**: A single clock period, defined from rising edge to rising edge for AHB and APB protocols.
- **Bus Transfer**: A read or write operation of a data object. AHB transfers may span multiple cycles, while APB transfers require exactly two cycles (setup and access).
- **Burst Operation**: Multiple data transactions initiated by an AHB master to an incremental address region. APB does not support bursts.
