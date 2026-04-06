# TR100 — Packaging and Power Considerations

## Date
$(date +"%Y-%m-%d")

## Context
During review of the TR100 DC-DC architecture (target ~250mA output), a key question was raised regarding the feasibility of delivering this power level in a small SOT23 package.

This document captures initial analysis and design options.

---

## 1. Target Operating Point

Assumptions:
- Vout ≈ 3.3V
- Iout ≈ 250mA

Output power:
Pout ≈ 0.825W

---

## 2. Efficiency and Loss Estimate

Assuming:
- Efficiency η ≈ 80–85%

Estimated input power:
Pin ≈ 0.97W – 1.03W

Estimated internal dissipation:
Ploss ≈ 150–250mW

---

## 3. Thermal Constraints (SOT23)

Typical SOT23 thermal resistance:
θJA ≈ 150–250 °C/W (layout dependent)

Estimated temperature rise:
ΔT ≈ 30–60 °C

Observations:
- This is borderline for reliable operation
- Strong dependence on PCB copper area
- No exposed thermal pad in SOT23

---

## 4. Loss Mechanisms

### 4.1 Conduction Loss
- Internal FET Rds(on) critical
- Estimated:
  - Rds(on): 150–500 mΩ
  - IL_peak > Iout

Pcond ≈ I² × R  
→ ~50–150 mW (combined high-side + low-side)

---

### 4.2 Switching Loss
- Depends on frequency, gate drive, overlap current
- Estimated:
→ ~50–100 mW

---

### 4.3 Additional Losses
- Gate drive losses
- Dead-time losses
- Control circuitry consumption

---

## 5. Why Commercial Parts Use SOT23

Observed in similar devices:

### 5.1 Optimized Silicon
- Aggressive FET sizing
- Low Rds(on) relative to die area

### 5.2 Operating Modes
- PFM / burst mode at light load
- Reduced switching losses at low current

### 5.3 Conditional Ratings
- Maximum current only under specific conditions
- Not continuous worst-case operation

### 5.4 PCB Thermal Contribution
- Large copper areas reduce effective θJA
- Layout heavily influences performance

---

## 6. Design Options for TR100

### Option A — Keep SOT23, Reduce Current
- Target: 100–150 mA
- Safer thermal margin
- Simpler first silicon

---

### Option B — Keep 250mA, Improve Package
- Move to DFN/QFN with exposed pad
- Better thermal performance
- More robust across conditions

---

### Option C — Match Commercial Optimization
- Aggressive FET sizing
- Efficiency-first design
- PFM/PWM hybrid control
- Tight thermal assumptions

(Higher complexity, higher risk)

---

## 7. Current Position

- Architecture development continues assuming 250mA target
- Packaging decision not yet fixed
- Power and thermal modelling required before tapeout decision

---

## 8. Next Steps

- Build detailed loss model (conduction + switching)
- Estimate realistic Rds(on) for target process
- Simulate worst-case thermal scenario
- Evaluate package trade-offs before finalizing product definition

---

## Key Takeaway

SOT23 operation at ~250mA is feasible only under optimized conditions and is close to thermal limits.  

Design must either:
- operate within a constrained envelope, or  
- adopt a package with improved thermal capability.

