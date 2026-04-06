# TR100 PWM Comparator V2 — Golden Baseline

## Status
TR100_PWM_COMP_V2_GOLDEN

## Summary
Standalone PWM comparator verified using:
- soft-start-like reference ramp
- golden 0.5V carrier ramp
- rail-like PWM output

## Verified Behaviour
- PWM remains low initially while reference is small
- PWM transitions high when reference exceeds ramp
- Observed high pulse from approximately 0.502us to 1.081us
- Approximate duty in captured window: ~58%

## Conclusion
PWM comparator is working correctly and is ready for integration with standalone soft-start and control top level.
