# TR100 PWM Ramp — Issues Found and Resolved

## Block
TR100 PWM Ramp

## Final Status
Resolved — frozen as TR100_PWM_RAMP_V9_GOLDEN

---

## Issue 1 — Behavioural voltage forcing on ramp node

### Symptom
Ramp node stuck or became numerically unstable.

### Root Cause
A behavioural voltage source was used to force the ramp node directly.

### Fix
Removed behavioural voltage forcing and returned to capacitor-based dynamics.

---

## Issue 2 — Reset current caused runaway negative voltage

### Symptom
Ramp node went to extreme negative values.

### Root Cause
Constant reset current discharged the capacitor without a lower bound.

### Fix
Abandoned pure current reset approach and moved to switch-based reset.

---

## Issue 3 — Idealized reset topology prevented integration

### Symptom
Ramp remained at 0 V.

### Root Cause
Reset path dominated charge path or produced hidden algebraic loop behaviour.

### Fix
Separated charge and reset using explicit digital phase-control signals.

---

## Issue 4 — Wrong shell path when running ngspice

### Symptom
No output data file produced.

### Root Cause
Used `...` shorthand in a shell pathname.

### Fix
Used full absolute shell path to the netlist.

---

## Issue 5 — Wrong wrdata column interpretation

### Symptom
Incorrect conclusions drawn from waveform output.

### Root Cause
wrdata stores x-y pairs for each signal.

### Fix
Verified correct signal-column mapping before judging waveform behaviour.

---

## Final Behaviour
- Stable startup
- Ramp integrates correctly
- Reset operates correctly
- PWM architecture now valid for integration

## Lessons Learned
- Do not drive dynamic analog nodes with behavioural voltage sources unless strictly necessary
- Prefer explicit phase control for switched control circuits
- Always validate data-file column mapping
- Always inspect the log before trusting output data
