# Buck Functional Blocks

## Reference Functional Blocks

The reference buck converter architecture includes the following internal functions:

- Control logic
- Current sense
- Soft start
- Thermal detect
- Internal reference (0.6 V)
- Input UVLO
- Enable path
- Feedback path

## Why these matter

### Soft Start
Limits startup inrush current and reduces sudden rail stress during enable.

### UVLO
Prevents operation when input voltage is too low for valid regulation.

### Current Sense
Supports control action and protection during load steps and overload.

### Thermal Detect
Protects the converter during excessive power dissipation or fault conditions.

### Feedback / Reference
Sets and regulates output voltage using the resistor divider.

## Relevance to RX/TX supply architecture

For an RX/TX shared or partitioned rail design, these functions affect:

- startup behaviour
- fault handling
- transient recovery
- safe operating region
- supply sequencing
