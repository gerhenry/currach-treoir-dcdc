# Design Targets

## Baseline Operating Point
- VIN nominal: 3.3 V
- VOUT nominal: 1.8 V
- Output current target: 250 mA
- Switching frequency: 1.5 MHz

## Control / Protection Targets
- Feedback reference: 0.6 V
- UVLO threshold: 2.5 V
- UVLO hysteresis: 150 mV
- EN high threshold: 1.2 V
- EN low threshold: 0.4 V
- Turn-on delay: 300 µs
- Soft-start time: 700 µs
- Top FET current limit: 2.5 A typ
- Thermal shutdown: 160 °C
- Thermal shutdown hysteresis: 20 °C

## Power Stage Baseline
- Inductor: 2.2 µH
- Input capacitor: 10 µF / 6.3 V
- Output capacitor: 10 µF / 6.3 V
- Feed-forward capacitor: 22 pF
- RH: 100 kΩ
- RL: 49.9 kΩ

## Device-Level Baseline Assumptions
- Top FET RDS(on): 260 mΩ typ
- Bottom FET RDS(on): 160 mΩ typ

## Architecture Intent
- Buck converter generates 1.8 V rail from 3.3 V input
- RX and TX load interaction evaluated at system level
- Shared, filtered, and post-LDO partition options compared
