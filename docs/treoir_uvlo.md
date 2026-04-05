# treoir_uvlo

## Role

`treoir_uvlo` is the undervoltage lockout block for the Treoir DC-DC system.

It prevents startup or continued operation when VIN is below the valid operating threshold.

## Functional Structure

The block is composed of:

- input resistor ladder
- comparator-amplifier
- hysteresis path
- output buffer / logic shaping

## Implementation Intent

The first behavioural implementation is used to validate threshold and hysteresis.

The next implementation stage is a transistor-level UVLO using:

- a low-power continuous comparator
- resistor ladder threshold generation
- positive feedback for hysteresis
- buffered logic-compatible `uvlo_ok` output

## Protection Note

The VIN sensing interface must be compatible with top-level protection strategy.

Pad-level ESD is treated as a system integration topic, not as a direct copy of any reference implementation.
