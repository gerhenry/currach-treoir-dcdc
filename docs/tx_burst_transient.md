# TX Burst Transient Model

## Purpose

Estimate time-domain rail droop caused by TX burst current steps and compare how much of that disturbance reaches RX under different supply architectures.

## Architectures

- Shared buck
- Split filtered rail
- Buck with RX LDO
- Buck with stronger RX LDO

## Model intent

This is a simplified system-level model for architecture comparison.

It is not a switching-accurate or transistor-level regulator simulation.

## Key outputs

- Rail droop during burst
- Minimum rail voltage
- Maximum RX effective disturbance
- Recovery behaviour after burst release
