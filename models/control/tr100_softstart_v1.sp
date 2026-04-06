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
