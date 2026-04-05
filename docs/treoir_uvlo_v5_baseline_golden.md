# Treoir UVLO Comparator Baseline (Golden)

## Status
Frozen as the current golden comparator baseline before reworking hysteresis.

## Proven behavior
- Differential pair functional
- Active load functional
- Gain stage functional
- Output inverter functional
- Rail-to-rail output observed
- Divider/reference scaling gives switching around ~3.3 V

## Extracted threshold
- VON ≈ 3.28 V to 3.32 V
- VOFF ≈ VON in current configuration
- Effective hysteresis ≈ 0 V

## Interpretation
The comparator architecture is validated.
The present resistive feedback implementation does not produce a robust hysteresis window and should not be used as the final UVLO hysteresis method.

## Next step
Create V6 with controlled hysteresis injection using a cleaner method.
