# TR100 Soft-Start — Issues & Debug Log

## Block
TR100 Soft-Start (V1)

## Status
Resolved — TR100_SOFTSTART_V1_GOLDEN

---

## Issue 1 — Missing MOS Model

### Error
can't find model 'nmos'

### Root Cause
Model not defined in SPICE deck

### Fix
Added Level=1 MOS model or removed dependency

---

## Issue 2 — Invalid IF Function

### Error
no such function 'if'

### Root Cause
ngspice does not support if()

### Fix
Replaced with ternary operator:
(condition) ? value1 : value2

---

## Issue 3 — Incorrect Current Direction (CRITICAL)

### Symptom
Soft-start node went negative

### Root Cause
Current source polarity reversed

### Incorrect
BCHG ss 0 I = ...

### Fixed
BCHG 0 ss I = ...

---

## Issue 4 — Batch Simulation Failure

### Error
no .print / .plot

### Root Cause
Missing control output

### Fix
Added wrdata in control block

---

## Issue 5 — No Ramp Observed

### Root Cause
Combined effect of:
- wrong current direction
- enable condition

### Fix
Corrected polarity + threshold logic

---

## Issue 6 — Clamp Behaviour

### Requirement
Limit to 0.6V

### Fix
Used:
min(V(ss), VREF_FINAL)

---

## Issue 7 — Numerical Stability

### Risk
Discontinuities

### Fix
Used smooth tanh() transition

---

## Lessons Learned

- Always verify current direction
- Avoid unsupported syntax
- Use behavioural models for control first
- Validate against physics (I/C)

---

## Final Status

TR100_SOFTSTART_V1_GOLDEN

Ready for integration into control system
