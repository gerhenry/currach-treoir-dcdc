# Treoir DC-DC Top Specification

## 1. Overview

Treoir DC-DC is a low-voltage buck converter architecture intended for IoT, RF, and mixed-signal systems.

The initial target is a converter operating from a 3.3 V input rail and generating a regulated 1.8 V output rail for on-chip and subsystem use.

This specification defines the first-pass top-level targets for architectural design, circuit implementation, and simulation.

---

## 2. Target Application Space

### Intended Use Cases
- IoT edge nodes
- remote and distributed sensing systems
- battery-powered embedded systems
- USB-powered low-voltage systems
- solar-powered systems with battery or supercapacitor storage

### System Role
- generate a 1.8 V rail from a 3.3 V input
- support mixed-signal / RF subsystem power
- support burst-current events typical of transmit activity

---

## 3. Electrical Targets

### Input Supply
- VIN nominal: 3.3 V
- VIN minimum operating target: 2.5 V
- VIN maximum operating target: 5.0 V first-pass system consideration
- Process direction: standard 3.3 V / 5 V CMOS implementation path

### Output Supply
- VOUT nominal: 1.8 V
- Output current target: 250 mA
- Output power target: 0.45 W

### Environment
- Maximum ambient operating target: 85°C

---

## 4. Functional Targets

### UVLO
- Rising threshold target: 2.5 V
- Falling threshold target: 2.35 V
- Hysteresis target: 150 mV

### Enable
- EN high threshold target: 1.2 V
- EN low threshold target: 0.4 V

### Startup
- Turn-on delay target: 300 µs
- Soft-start target: 700 µs

### Protection
- Current limit concept included
- Thermal shutdown concept included
- Short-circuit protection concept included

---

## 5. Converter Architecture Direction

### Topology
- Buck converter
- Low-voltage DC-DC architecture
- First-pass implementation targeted for integrated CMOS development

### Output Domain Strategy
Architectures to be evaluated:
1. Shared buck rail
2. Buck with filtered RX/TX branches
3. Buck with RX post-LDO
4. Buck with stronger post-regulation on sensitive domain

---

## 6. Power Stage Intent

### Initial Direction
- Integrated low-voltage CMOS implementation path
- Gate driver and power FET feasibility to be evaluated
- External FET option remains open if integrated switch area or efficiency becomes limiting

### Key Design Questions
- integrated switch Rds_on vs area
- gate driver capability
- thermal handling
- switching loss vs frequency
- feasibility of delivering 250 mA on-chip

---

## 7. Performance Goals

### Efficiency
- Efficiency target: to be defined during power-stage sizing
- Focus on practical efficiency at moderate load and burst conditions

### Ripple
- Output ripple target: to be defined
- RX-sensitive domains may require post-regulation or filtering

### Transient Response
- Must tolerate TX-like burst current events
- Rail droop and RX disturbance must be managed through architecture and isolation

---

## 8. Physical Design Intent

### Layout Philosophy
- analog/control circuits in quiet island
- power FETs and switching nodes in isolated noisy domain
- deep n-well / isolation strategy for sensitive circuits
- package and thermal design must support approximately 1 W class dissipation margin

---

## 9. Development Sequence

### First Circuit Blocks
1. treoir_uvlo
2. treoir_uvlo_cmp
3. treoir_ref_stub
4. treoir_softstart
5. treoir_ctrl_shell

### Later Blocks
6. treoir_error_amp
7. treoir_pwm_core
8. treoir_gate drivers
9. treoir_power FET stage
10. treoir_top integration

---

## 10. Scope Statement

This specification defines the first-pass architectural and circuit-design targets for the Treoir DC-DC program.

It is intended for:
- open-access implementation in GF180
- parallel private implementation path in advanced CMOS
- simulation, feasibility, and early design validation

This document does not represent a final production specification.
