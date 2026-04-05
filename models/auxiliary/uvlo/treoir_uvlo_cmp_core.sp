*===========================================================
* treoir_uvlo_cmp_core.sp
* GF180 UVLO comparator core
* FIXED model include + correct device usage
*===========================================================

.option scale=1u

* 🔴 Use ONLY this model file (this is the key fix)
.include "/data/data/com.termux/files/home/pdks/gf180mcu-pdk/libraries/gf180mcu_fd_pr/latest/models/ngspice/sm141064.ngspice"

*===========================================================
* SUPPLIES
*===========================================================

VDD vdd 0 1.8
VSS vss 0 0

VIP vip 0 0.60
VIM vim 0 0.60

VBIAS vbias_tail 0 0.75

*===========================================================
* CORE COMPARATOR
*===========================================================

* NMOS differential pair
XMN1 n1   vip        tail vss nmos_3p3 W=8u  L=0.5u
XMN2 vout vim        tail vss nmos_3p3 W=8u  L=0.5u

* PMOS current mirror load
XMP1 n1   n1         vdd  vdd pmos_3p3 W=16u L=0.5u
XMP2 vout n1         vdd  vdd pmos_3p3 W=16u L=0.5u

* Tail current source
XMNTAIL tail vbias_tail vss vss nmos_3p3 W=4u L=1u

.control
op
display
print v(vout) v(n1) v(tail) v(vip) v(vim)
print i(VDD)
quit
.endc

.end
