# TR100 Control V4 — Master Bias into Soft-Start

## Status
Working startup sequence verified

## Verified Behaviour
- soft-start starts at 0V
- enable delay holds startup off initially
- after enable rises, soft-start begins charging correctly
- master bias drives the soft-start charging current

## Observation
Early samples show ss = 0 before enable assertion.
After enable assertion (~100ns), ss begins rising from 0V.

## Conclusion
Master-bias-driven soft-start startup behaviour is now physically correct and ready for further PWM/ramp verification.
