# treoir_uvlo_cmp Specification

## Role
Low-power continuous comparator-amplifier for UVLO decision path.

## Inputs
- vip
- vim
- vdd
- vss
- vbias or ibias

## Output
- vout

## First-Pass Architecture
- NMOS differential pair
- PMOS current-mirror active load
- single-ended output
- external inverter/buffer for logic shaping

## First-Pass Priorities
- low power
- monotonic switching
- operation around 0.6 V input common-mode
- portable between GF180 and 22nm FDX

## Notes
This is not a clocked comparator.
This is an always-on analog decision block.
