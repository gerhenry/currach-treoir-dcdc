# TR100 Soft-Start — Golden Baseline

## Block
TR100 Soft-Start (V1)

## Status
TR100_SOFTSTART_V1_GOLDEN

---

## Summary

The soft-start block provides a controlled ramp of the reference voltage for the TR100 DC-DC converter.

Key features:

- Linear ramp using current source (I/C)
- Enable-controlled activation
- Clamp at final reference (0.6V)
- Smooth completion detection
- Fully stable in ngspice

---

## Parameters

| Parameter     | Value |
|--------------|------|
| ISS          | 1 µA |
| CSS          | 100 pF |
| VREF_FINAL   | 0.6 V |

---

## Behaviour

- When enable = HIGH:
  - Capacitor charges linearly
  - Output ramps toward 0.6V
- When enable = LOW:
  - Capacitor discharges
  - Output resets to 0V

---

## Verified Results

- Ramp slope ≈ 10 mV/µs
- Clamp at 0.6V confirmed
- No overshoot
- Stable simulation

---

## System Role

Soft-start is part of the TR100 control chain:

UVLO → SOFT-START → PWM → DRIVER → POWER

---

## Source Code Snapshot

Below is the current golden implementation:

* TR100 SOFT-START V1
* simple robust behavioural version

VDD vdd 0 1.8
VEN enable 0 PULSE(0 1.8 0 1u 1u 5m 10m)

.param VREF_FINAL=0.6
.param ISS=1u
.param CSS=100p

CSS ss 0 {CSS} IC=0
RLEAK ss 0 1G

* charge when enabled
BCHG 0 ss I = { (V(enable)>0.9) ? ISS : 0 }

* discharge when disabled
GDIS ss 0 value = { (V(enable)<0.2) ? V(ss)/1 : 0 }

* clamp output reference
EOUT vref_ss 0 value = { min(V(ss), VREF_FINAL) }

* soft done flag, smooth transition
BDONE ss_done 0 V = { 0.9*(1+tanh((V(vref_ss)-0.59)/0.005)) }

.control
set noaskquit
tran 1u 10m
wrdata ~/tmp/tr100_softstart_v1.dat v(enable) v(ss) v(vref_ss) v(ss_done)
.endc

.end
