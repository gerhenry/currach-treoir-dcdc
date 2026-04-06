# TR100 Master Bias V1 — Golden Baseline

## Status
TR100_MASTER_BIAS_V1_GOLDEN

## Summary
Behavioral master bias block implemented and verified.

## Function
Generates a centralized master bias current and scaled bias outputs for:
- soft-start
- PWM ramp
- UVLO

## Parameters
- IMASTER = 10uA
- I_SS = 1uA
- I_RAMP = 100uA
- I_UVLO = 5uA

## Notes
Monitor resistor convention causes negative sign in reported values, but current magnitudes are correct.

## Verification
Observed steady-state values:
- ibias_master ≈ 10uA
- ibias_ss ≈ 1uA
- ibias_ramp ≈ 100uA
- ibias_uvlo ≈ 5uA

## Conclusion
Master bias architecture is valid and ready to be connected into the TR100 control blocks.
