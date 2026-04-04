# System Operating States

This model defines the high-level operating modes of the DC-DC powered RX/TX system.

## States

- OFF
- UVLO_BLOCKED
- SOFT_START
- REGULATION
- TX_BURST
- OVERLOAD
- SHORT_CIRCUIT
- THERMAL_SHUTDOWN

## Purpose

To connect:

- converter behaviour
- load conditions (TX/RX)
- fault handling
- system-level performance

## Relevance

This allows mapping of:

- when RX is vulnerable
- when TX causes disturbance
- when system protection dominates behaviour
