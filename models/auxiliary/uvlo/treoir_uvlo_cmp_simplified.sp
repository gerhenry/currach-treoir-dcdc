*===========================================================
* treoir_uvlo_cmp_simplified.sp
* Simplified standalone UVLO comparator core
* No GF180 wrapper/model dependency
*===========================================================

.option scale=1u

*-----------------------------------------------------------
* SIMPLE MOS MODELS
*-----------------------------------------------------------
.model nch nmos level=1 vto=0.50 kp=200u lambda=0.04 gamma=0.4 phi=0.7
.model pch pmos level=1 vto=-0.50 kp=100u lambda=0.04 gamma=0.4 phi=0.7

*-----------------------------------------------------------
* SUPPLIES
*-----------------------------------------------------------
VDD vdd 0 1.8
VSS vss 0 0

*-----------------------------------------------------------
* INPUTS
*-----------------------------------------------------------
* For first OP check both are equal
VIP vip 0 0.60
VIM vim 0 0.60

* Tail bias
VBIAS vbias_tail 0 0.85

*-----------------------------------------------------------
* COMPARATOR CORE
*-----------------------------------------------------------

* NMOS differential pair
M1 n1   vip  tail vss nch W=20u L=1u
M2 vout vim  tail vss nch W=20u L=1u

* PMOS active mirror load
M3 n1   n1   vdd vdd pch W=40u L=1u
M4 vout n1   vdd vdd pch W=40u L=1u

* Tail current sink
M5 tail vbias_tail vss vss nch W=10u L=2u

*-----------------------------------------------------------
* ANALYSES
*-----------------------------------------------------------

.control
echo "==== OPERATING POINT ===="
op
print v(vout) v(n1) v(tail) v(vip) v(vim)
print i(VDD)

echo "==== DC SWEEP ===="
dc VIP 0.40 0.80 0.01
print v(vout) v(n1) v(tail)

quit
.endc

.end
