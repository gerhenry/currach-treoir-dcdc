*===========================================================
* treoir_uvlo_hyst_v2.sp
* Improved UVLO with stronger gain + hysteresis
*===========================================================

.option scale=1u

.model nch nmos level=1 vto=0.50 kp=200u lambda=0.05
.model pch pmos level=1 vto=-0.50 kp=100u lambda=0.05

VDD vdd 0 1.8
VSS vss 0 0

VIN vin 0 3.3
VREF vref 0 0.60
VBIAS vbias_tail 0 0.90

* Divider
RTOP vin vsense 450k
RBOT vsense 0 100k

* Stronger hysteresis
RFB vout vsense 1meg

* Diff pair (stronger)
M1 n1 vsense tail vss nch W=60u L=1u
M2 n2 vref   tail vss nch W=60u L=1u

* Active load
M3 n1 n1 vdd vdd pch W=120u L=1u
M4 n2 n1 vdd vdd pch W=120u L=1u

* Tail
M5 tail vbias_tail vss vss nch W=30u L=1u

* Second stage (more gain)
M6 vgain n2 vss vss nch W=200u L=1u
M7 vgain vgain vdd vdd pch W=200u L=1u

* Output inverter (stronger)
M8 vout vgain vdd vdd pch W=300u L=1u
M9 vout vgain vss vss nch W=300u L=1u

.control
echo "==== UVLO DC SWEEP ===="
dc VIN 2.8 3.8 0.01
print v(vin) v(vsense) v(vout)

op
quit
.endc

.end
