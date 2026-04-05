* treoir_uvlo_cmp core comparator
* First-pass analog implementation

* Replace include with the exact GF180 model path once confirmed
*.include $PDK_ROOT/gf180mcu/models/ngspice/gf180mcu.lib.spice

VDD vdd 0 1.8
VSS vss 0 0

* Inputs
VIP vip 0 0.60
VIM vim 0 0.60

* Tail bias placeholder
VBIAS vbias_tail 0 0.75

* Differential pair
M1 n1   vip tail vss nfet_03v3 W=8u  L=0.5u
M2 vout vim tail vss nfet_03v3 W=8u  L=0.5u

* PMOS mirror load
M3 n1   n1   vdd vdd pfet_03v3 W=16u L=0.5u
M4 vout n1   vdd vdd pfet_03v3 W=16u L=0.5u

* Tail current sink
M5 tail vbias_tail vss vss nfet_03v3 W=4u L=1u

.op
*.dc VIP 0.50 0.70 0.001
*.print dc v(vout) v(n1)

.end
