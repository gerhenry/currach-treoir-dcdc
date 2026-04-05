# treoir_uvlo_cmp

## 1. Overview

`treoir_uvlo_cmp` is the comparator-amplifier used within the `treoir_uvlo` block of the Treoir DC-DC system.

It performs the core decision function that determines whether the input supply voltage (VIN) is above a valid operating threshold.

This block is implemented as a low-power continuous-time comparator suitable for always-on operation.

---

## 2. What is UVLO?

Undervoltage Lockout (UVLO) is a supervisory function used in power management ICs to ensure that a system does not operate when the supply voltage is below a safe or valid level.

UVLO monitors the input supply (VIN) and generates a control signal:

- UVLO inactive → system disabled
- UVLO active → system allowed to operate

UVLO typically includes:

- threshold detection
- hysteresis
- logic output for system enable/disable

---

## 3. Why UVLO is Required in Power ICs

UVLO is a critical function in DC-DC converters and power management systems for the following reasons:

### 3.1 Prevents Unreliable Operation
At low supply voltages:
- MOSFETs may not fully turn on
- gate drive is insufficient
- switching becomes inefficient or unstable

This can lead to:
- incorrect regulation
- increased losses
- unpredictable behaviour

---

### 3.2 Protects Internal Circuits
Operating below valid supply levels can cause:

- analog bias circuits to collapse
- reference voltages to become inaccurate
- control loops to malfunction

UVLO ensures:
- circuits only operate within valid conditions

---

### 3.3 Ensures Controlled Startup
Without UVLO:

- the converter may attempt to start too early
- repeated start/stop oscillations can occur

With UVLO:
- startup is delayed until VIN is sufficient
- system behaviour is deterministic

---

### 3.4 Prevents Output Instability and Noise
Near threshold conditions can cause:

- rapid on/off switching (chatter)
- output ripple or collapse
- interaction with load transients (e.g. TX bursts)

UVLO with hysteresis prevents this.

---

### 3.5 System-Level Reliability
UVLO contributes to:

- predictable power sequencing
- stable enable logic
- safe interaction with digital and RF subsystems

---

## 4. UVLO Behaviour (Treoir Targets)

The Treoir UVLO is aligned to a standard synchronous buck converter class.

### Target Parameters

- Rising threshold: ~2.5 V
- Falling threshold: ~2.35 V
- Hysteresis: ~150 mV

### Behaviour

- VIN rising past threshold → `uvlo_ok = 1`
- VIN falling below threshold → `uvlo_ok = 0`

---

## 5. Role of treoir_uvlo_cmp

`treoir_uvlo_cmp` performs the analog comparison:

### Inputs
- `vip` → scaled VIN (via resistor divider)
- `vim` → reference voltage (≈ 0.6 V)

### Output
- `vout` → analog comparator output

This output is later processed by:

- hysteresis network
- output buffer
- control logic

---

## 6. Design Requirements

The comparator must meet the following requirements:

### 6.1 Low Power
- always-on block
- minimal quiescent current

### 6.2 Operation at Low Input Levels
- inputs around ~0.6 V common-mode
- stable over PVT

### 6.3 Sufficient Gain
- clear decision at threshold
- minimal ambiguity for downstream logic

### 6.4 Monotonic Behaviour
- no oscillation near threshold
- stable transition

---

## 7. Chosen Architecture

The comparator is implemented as:

- NMOS differential pair (input stage)
- PMOS current mirror load
- tail current source
- single-ended output

Followed by:

- inverter / buffer (in separate block)

This architecture provides:

- simplicity
- robustness
- portability across processes (GF180, 22nm FDX)

---

## 8. Design Philosophy

This implementation is:

- based on fundamental analog design principles
- not a transistor-level reproduction of any specific commercial IC

The goal is to:

- capture the functional behaviour of UVLO
- create a reusable and scalable internal IP block

---

## 9. Next Steps

- implement transistor-level schematic (`treoir_uvlo_cmp`)
- validate DC transfer characteristics
- integrate with divider and hysteresis
- verify full UVLO behaviour across VIN sweep# treoir_uvlo_cmp

## Purpose
Comparator-amplifier used inside treoir_uvlo.

## Design Choice
A continuous-time low-power comparator is used instead of a dynamic latch because UVLO is an always-on supervisory function.

## Topology
- NMOS input differential pair
- PMOS active load
- tail current source
- single-ended analog output

## Integration
The output is followed by:
- hysteresis path
- output buffer / inverter
- uvlo_ok generation
