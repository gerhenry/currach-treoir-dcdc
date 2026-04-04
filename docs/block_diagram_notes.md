# Block Diagram Notes

## Reference Architecture Elements

The buck converter class used as reference includes:

- EN-controlled start/stop behaviour
- UVLO gating from input supply
- current-sense based control/protection
- internal soft-start
- thermal shutdown
- feedback-regulated output using 0.6 V reference

## Architecture Use in This Repo

These functions are represented here at behavioural level only.

The purpose is to capture:
- startup sequencing
- fault gating
- transient implications
- suitability for RX/TX rail supply

Not included:
- transistor-level comparator implementation
- exact compensation internals
- exact silicon timing details
