*===========================================================
* treoir_uvlo_v3.sp
* Clean UVLO V3 with controlled hysteresis
*===========================================================

.option scale=1u

.model nch nmos level=1 vto=0.50 kp=200u lambda=0.05
.model pch pmos level=1 vto=-0.50 kp=100u lambda=0.05

VDD vdd 0 1.8
VSS vss 0 0

* Sweepable VIN
VIN vin 0 DC 0

* Fixed reference
VREF vref 0 0.60

* Tail bias
VBIAS vbias_tail 0 0.90

*-----------------------------------------------------------
* VIN SENSE DIVIDER
* Lower impedance than before to reduce loading sensitivity
* 3.3V -> ~0.60V
*-----------------------------------------------------------
RTOP vin vsense 47k
RBOT vsense 0   10k

*-----------------------------------------------------------
* CONTROLLED HYSTERESIS
* Weak positive feedback from output to sense node
* Kept much larger than divider resistors
*-----------------------------------------------------------

*-----------------------------------------------------------
* COMPARATOR CORE
* Reduced input device size to avoid divider corruption
*-----------------------------------------------------------
M1 n1 vsense tail vss nch W=10u L=1u
M2 n2 vref   tail vss nch W=10u L=1u

M3 n1 n1 vdd vdd pch W=80u L=1u
M4 n2 n1 vdd vdd pch W=80u L=1u

M5 tail vbias_tail vss vss nch W=20u L=1u

*-----------------------------------------------------------
* SECOND GAIN STAGE
*-----------------------------------------------------------
M6 vgain n2    vss vss nch W=150u L=1u
M7 vgain vgain vdd vdd pch W=150u L=1u

*-----------------------------------------------------------
* OUTPUT INVERTER
*-----------------------------------------------------------
M8 vout vgain vdd vdd pch W=250u L=1u
M9 vout vgain vss vss nch W=250u L=1u


.end

.control

echo "==== UP SWEEP ===="

dc VIN 2.8 4.2 0.001

print v(vin) v(vsense) v(vout)

echo "==== DOWN SWEEP ===="

dc VIN 4.2 2.8 -0.001

print v(vin) v(vsense) v(vout)

echo "==== OP @ 3.3V ===="

alter VIN 3.3

op

print v(vin) v(vsense) v(vref) v(vout) v(vgain) v(n1) v(n2) v(tail)

.endc

RFB vout vsense 1Meg
