# System Use Case

## Target Application

Mixed-signal / RF SoC supply architecture.

## Load Domains

### RX
- Noise-sensitive
- Moderate current
- Requires low ripple supply

### TX
- Dynamic current (burst behaviour)
- Higher instantaneous current
- Less sensitive to low-frequency ripple

## Total Load Range

- 50 mA to 250 mA typical modelling range

## Supply Options Evaluated

- Shared DC-DC rail
- Partitioned filtering
- Post-regulated RX rail (LDO)
- Fully partitioned rails

## Objective

Understand trade-offs between:
- Noise
- Efficiency
- Transient response
- Implementation complexity
