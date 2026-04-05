*===========================================================
* treoir_uvlo_cmp_v4.sp
* Fixed gain stage (proper biasing)
*===========================================================

.option scale=1u

.model nch nmos level=1 vto=0.50 kp=200u lambda=0.05
.model pch pmos level=1 vto=-0.50 kp=100u lambda=0.05

VDD vdd 0 1.8
VSS vss 0 0

VIM vim 0 0.60
VIP vip 0 0.55

VBIAS vbias_tail 0 0.9

*-------------------------
* DIFF PAIR
*-------------------------
M1 n1 vip tail vss nch W=40u L=1u
M2 n2 vim tail vss nch W=40u L=1u

M3 n1 n1 vdd vdd pch W=80u L=1u
M4 n2 n1 vdd vdd pch W=80u L=1u

M5 tail vbias_tail vss vss nch W=20u L=1u

*-------------------------
* FIXED GAIN STAGE
*-------------------------
M6 vgain n2 vss vss nch W=100u L=1u
M7 vgain vgain vdd vdd pch W=100u L=1u

*-------------------------
* OUTPUT INVERTER
*-------------------------
M8 vout vgain vdd vdd pch W=150u L=1u
M9 vout vgain vss vss nch W=150u L=1u

.control
echo "==== FINE SWEEP ===="
dc VIP 0.55 0.65 0.002
print v(vip) v(vout) v(vgain) v(n2)
quit
.endc

.end
