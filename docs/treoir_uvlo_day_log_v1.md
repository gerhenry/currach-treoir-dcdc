# Treoir UVLO Development Log – Day 1

## Objective
Develop and validate a transistor-level UVLO comparator for Treoir DC-DC system.

---

## Work Completed

### 1. Comparator Architecture Built
- Differential pair implemented
- Active load implemented
- Second gain stage added
- Output inverter added for full swing restoration

### 2. Reference & Divider Network
- Reference voltage: 0.6 V
- Divider ratio: 45k / 10k
- Target VIN threshold ≈ 3.3 V

### 3. Simulation Setup
- DC sweep implemented:
  - Up sweep: 2.5 V → 4.2 V
  - Down sweep: 4.2 V → 2.5 V
- Clean output extraction using ngspice control block
- Automated threshold extraction using awk

### 4. Results (Validated)
- Output swing: ~0 V → 1.8 V
- Clean switching behavior observed
- Threshold extracted:

  VON ≈ 3.28 – 3.32 V  
  VOFF ≈ 3.28 – 3.32 V  

- Hysteresis ≈ 0 V (baseline comparator)

### 5. Hysteresis Investigation
- Resistive feedback (VOUT → VSENSE) tested
- Observations:
  - Strong feedback → latch behavior
  - Weak feedback → negligible hysteresis
- Conclusion:
  - Simple resistive feedback not robust for final design

---

## Key Engineering Conclusions

- Comparator architecture is **valid and stable**
- Divider + reference scaling is **correct**
- System produces **clean digital output**
- Baseline comparator is suitable for integration

---

## Limitations Identified

- No hysteresis → susceptible to noise near threshold
- Current feedback approach not production-grade

---

## Next Steps

- Implement controlled hysteresis (V6):
  - Reference-side injection or current injection method
- Validate hysteresis window (target ~50–150 mV)
- Ensure no latch behavior
- Prepare for layout-aware design considerations

---

## Status

✔ Comparator core validated  
✔ Threshold verified  
✔ Ready for hysteresis refinement  

