*===========================================================
* UVLO WITHOUT HYSTERESIS (DEBUG VERSION)
*===========================================================

.option scale=1u

.model nch nmos level=1 vto=0.50 kp=200u lambda=0.05
.model pch pmos level=1 vto=-0.50 kp=100u lambda=0.05

VDD vdd 0 1.8
VSS vss 0 0

VIN vin 0 DC 0
VREF vref 0 0.60
VBIAS vbias_tail 0 0.90

* Divider ONLY
RTOP vin vsense 450k
RBOT vsense 0 100k

* NO FEEDBACK YET

* Diff pair
M1 n1 vsense tail vss nch W=60u L=1u
M2 n2 vref   tail vss nch W=60u L=1u

M3 n1 n1 vdd vdd pch W=120u L=1u
M4 n2 n1 vdd vdd pch W=120u L=1u

M5 tail vbias_tail vss vss nch W=30u L=1u

* Gain stage
M6 vgain n2 vss vss nch W=200u L=1u
M7 vgain vgain vdd vdd pch W=200u L=1u

* Inverter
M8 vout vgain vdd vdd pch W=300u L=1u
M9 vout vgain vss vss nch W=300u L=1u

.control
echo "==== CLEAN UVLO SWEEP ===="
dc VIN 2.8 3.8 0.01
print v(vin) v(vsense) v(vout)
quit
.endc

.end
