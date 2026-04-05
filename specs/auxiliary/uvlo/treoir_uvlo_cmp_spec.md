# treoir_uvlo_cmp Specification

## Role
Analog decision core for Treoir UVLO.

## Inputs
- vip
- vim
- vbias_tail
- vdd
- vss

## Output
- vout

## Topology
- NMOS differential pair
- PMOS current mirror load
- NMOS tail current source
- single-ended analog output

## First-Pass Operating Point
- vdd = 1.8 V
- vip/vim common-mode ≈ 0.6 V
- tail current target ≈ 2 µA

## Priorities
- low quiescent current
- monotonic threshold response
- sufficient gain near crossing
- portability to 22nm FDX# treoir_uvlo_cmp Specification

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
