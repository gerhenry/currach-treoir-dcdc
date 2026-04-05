# Treoir DC-DC Architecture

## 1. Overview

Treoir is a low-voltage buck converter targeting 3.3 V input and 1.8 V output at up to 250 mA.

The architecture is partitioned into:
- always-on supervisory blocks
- control loop
- power stage

---

## 2. High-Level Block Diagram

VIN (3.3V)
  |
  +-- UVLO ----+
  |            |
  +-- EN ------+----> Control Shell ----> PWM ----> Gate Drivers ----> Power Stage ----> VOUT
               |
               +---- Soft Start
               |
               +---- Reference (Stub → Bandgap later)

---

## 3. Functional Partitioning

### 3.1 Always-On Domain (Quiet Analog Island)
- treoir_uvlo
- treoir_uvlo_cmp
- treoir_ref_stub
- treoir_softstart
- bias circuits

### 3.2 Control Domain
- treoir_ctrl_shell
- treoir_error_amp
- treoir_pwm_core
- treoir_compensation
- oscillator

### 3.3 Power Domain (Noisy)
- treoir_gate_drv_hs
- treoir_gate_drv_ls
- treoir_hs_switch
- treoir_ls_switch

---

## 4. Topology Choice (Initial)

- Buck converter
- First-pass: voltage-mode PWM
- Fixed-frequency operation

High-side implementation:
- PMOS high-side (first-pass simplicity)
- NMOS high-side (bootstrap) to be evaluated later

---

## 5. Power Strategy

- Main buck generates 1.8 V rail
- Sensitive domains (RX, PLL) may require:
  - post-filtering
  - optional LDO (future integration)

---

## 6. Isolation Strategy

- Separate quiet analog island from power switching domain
- Use deep n-well for sensitive circuits
- Guard rings around power devices
- Controlled routing of switching node

---

## 7. Development Approach

Phase 1:
- build and verify supervisory chain (UVLO, reference, soft-start)

Phase 2:
- implement control loop (error amp, PWM)

Phase 3:
- develop power stage and gate drivers

Phase 4:
- full system integration and transient validation

---

## 8. Open Questions

- Integrated vs external FET trade-off
- Switching frequency selection
- Output ripple vs efficiency trade-off
- RX/PLL supply filtering strategy
