# treoir_uvlo_cmp

## Purpose
Comparator-amplifier used inside treoir_uvlo.

## Design Choice
A continuous-time low-power comparator is used instead of a dynamic latch because UVLO is an always-on supervisory function.

## Topology
- NMOS input differential pair
- PMOS active load
- tail current source
- single-ended analog output

## Integration
The output is followed by:
- hysteresis path
- output buffer / inverter
- uvlo_ok generation
