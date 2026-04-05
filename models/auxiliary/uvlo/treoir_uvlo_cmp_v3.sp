*===========================================================
* treoir_uvlo_cmp_v3.sp
* Focused differential sweep around threshold
*===========================================================

.option scale=1u

.model nch nmos level=1 vto=0.50 kp=200u lambda=0.05
.model pch pmos level=1 vto=-0.50 kp=100u lambda=0.05

VDD vdd 0 1.8
VSS vss 0 0

* Reference
VIM vim 0 0.60

* Sweep input (tight window)
VIP vip 0 0.55

VBIAS vbias_tail 0 0.9

* Diff pair
M1 n1 vip tail vss nch W=40u L=1u
M2 n2 vim tail vss nch W=40u L=1u

M3 n1 n1 vdd vdd pch W=80u L=1u
M4 n2 n1 vdd vdd pch W=80u L=1u

M5 tail vbias_tail vss vss nch W=20u L=1u

* Gain stage
M6 vgain n2 vss vss nch W=80u L=1u
M7 vgain vdd vdd vdd pch W=80u L=1u

* Output inverter
M8 vout vgain vdd vdd pch W=100u L=1u
M9 vout vgain vss vss nch W=100u L=1u

.control
echo "==== FINE SWEEP ===="
dc VIP 0.55 0.65 0.002
print v(vip) v(vout) v(vgain) v(n1) v(n2)
quit
.endc

.end
