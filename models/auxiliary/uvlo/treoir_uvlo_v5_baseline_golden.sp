* TREOIR UVLO COMPARATOR V5 CLEAN + HYSTERESIS
* TREOIR UVLO COMPARATOR V4 CLEAN
* Clean transistor-level comparator with:
*  - resistor divider
*  - NMOS differential pair
*  - PMOS mirror load
*  - common-source gain stage
*  - CMOS inverter output buffer
* No hysteresis yet
*========================================================

.option scale=1u

*--------------------------------------------------------
* Simple generic MOS models for architecture validation
*--------------------------------------------------------
.model nch nmos level=1 vto=0.50 kp=200u lambda=0.05
.model pch pmos level=1 vto=-0.50 kp=100u lambda=0.05

*--------------------------------------------------------
* Supplies and biases
*--------------------------------------------------------
VDD   vdd         0    1.8
VSS   vss         0    0

* VIN is swept in control block
VIN   vin         0    DC 2.8
VREF  vref        0    0.60
VTAIL vbias_tail  0    0.90

*--------------------------------------------------------
* Input divider
* Target nominal trip near 3.3 V when no hysteresis
* Vsense = Vin * 10k / (45k + 10k) = 0.1818*Vin
* At Vin = 3.3 V, Vsense ~ 0.60 V
*--------------------------------------------------------
RTOP  vin         vsense   45k
RBOT  vsense      0        10k
RFB   vout   vsense   1Meg

*--------------------------------------------------------
* Differential pair
* M1 senses divided VIN
* M2 senses VREF
*--------------------------------------------------------
M1    n1          vsense   tail   vss   nch   W=40u   L=1u
M2    n2          vref     tail   vss   nch   W=40u   L=1u

* PMOS mirror active load
M3    n1          n1       vdd    vdd   pch   W=80u   L=1u
M4    n2          n1       vdd    vdd   pch   W=80u   L=1u

* Tail source
M5    tail        vbias_tail vss   vss   nch   W=20u   L=2u

*--------------------------------------------------------
* Second gain stage
* Input = n2
* Output = vgain
*--------------------------------------------------------
M6    vgain       n2       vss    vss   nch   W=120u  L=1u
M7    vgain       vgain    vdd    vdd   pch   W=60u   L=1u

*--------------------------------------------------------
* Output inverter
*--------------------------------------------------------
M8    vout        vgain    vdd    vdd   pch   W=120u  L=1u
M9    vout        vgain    vss    vss   nch   W=80u   L=1u

* Small capacitive load for realism/stability
CLOAD vout        0        10f

.control

echo "==== UVLO V5 UP SWEEP ===="

dc VIN 2.5 4.2 0.001

print v(vin) v(vsense) v(vout)

echo "==== UVLO V5 DOWN SWEEP ===="

dc VIN 4.2 2.5 -0.001

print v(vin) v(vsense) v(vout)

echo "==== UVLO V5 OP @ 3.3V ===="

alter VIN 3.3

op

print v(vin) v(vsense) v(vref) v(vgain) v(vout) v(tail)

.endc

.end
