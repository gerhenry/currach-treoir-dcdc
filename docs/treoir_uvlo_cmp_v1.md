# Treoir UVLO Comparator – Version 1 (V1)

## Status
First-pass transistor-level validation of UVLO comparator architecture using simplified MOS models (Level 1 SPICE).

## Objective
Demonstrate feasibility of:
- Undervoltage detection using differential comparator
- Multi-stage gain structure
- Rail-to-rail digital output generation

## Architecture

### Stage 1: Differential Pair
- NMOS input pair
- PMOS active mirror load
- Tail current bias
- Function: converts input voltage difference into current difference

### Stage 2: Gain Stage
- Common-source NMOS amplifier
- PMOS diode-connected load
- Function: amplify differential signal to near-digital levels

### Stage 3: Output Stage
- CMOS inverter
- Function: restore full logic swing (0–VDD)

## Simulation Setup

- VDD = 1.8 V
- VREF (VIM) = 0.60 V
- VIP swept from 0.55 V to 0.65 V
- DC sweep analysis performed in ngspice

## Results

- Comparator switching observed around ~0.60 V input
- Output transitions from low to high as VIP crosses VREF
- Internal node (n2) shows expected exponential rise near threshold
- Output stage restores near full-scale voltage (~0 to ~1.8 V)

## Key Observations

- Differential pair is correctly biased and responsive
- Active load provides functional gain
- Second stage significantly increases gain
- Output inverter successfully digitizes signal
- No hysteresis present (expected behavior)

## Limitations (V1)

- No hysteresis → potential chatter near threshold
- Ideal voltage sources used (no bandgap or divider yet)
- Simplified MOS models (not process-accurate)
- No offset, mismatch, or PVT analysis

## Significance

This validates the **core UVLO detection architecture** required for:
- DC-DC converters (target: 250 mA output)
- IoT / energy harvesting systems
- Low-voltage startup control circuits

## Next Steps

1. Add hysteresis (UVLO behavior)
2. Replace VREF with bandgap/reference block
3. Replace VIP with VIN divider network
4. Tune thresholds for system-level requirements
5. Port design to GF180 / 22FDX PDK
6. Perform corner and mismatch simulations

## Application Context

- Target system: 3.3 V input DC-DC converter
- Output current target: 250 mA
- Use case: IoT, remote sensing, solar/energy harvesting nodes

## Conclusion

Version 1 successfully demonstrates that a transistor-level UVLO comparator
can be implemented and simulated, forming the basis for a complete power
management IC block.

