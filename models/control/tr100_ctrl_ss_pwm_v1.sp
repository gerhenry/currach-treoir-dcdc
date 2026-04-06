* TR100 CONTROL V1
* Soft-start integrated into PWM reference path

VDD vdd 0 1.8

* enable goes high after startup
VEN enable 0 PULSE(0 1.8 0 1u 1u 5m 10m)

* ----------------------------
* SOFT-START BLOCK
* ----------------------------
.param ISS=1u
.param CSS=100p
.param VREF_FINAL=0.6

CSSNODE ss 0 {CSS} IC=0
RSSLEAK ss 0 1G

* charge soft-start cap only when enabled
BSSCHG 0 ss I = { (V(enable)>0.9 && V(ss)<VREF_FINAL) ? ISS : 0 }

* discharge when disabled
BSSDIS ss 0 I = { (V(enable)<0.9 && V(ss)>0) ? 100u : 0 }

* clamp/reference shaping
BREF vref_ss 0 V = { min(V(ss), VREF_FINAL) }

* ----------------------------
* PWM RAMP BLOCK
* ----------------------------
.param IRAMP=100u
.param CRAMP=100p
.param FSW=1Meg
.param TPER={1/FSW}

VCLK clk 0 PULSE(0 1.8 0 1n 1n {TPER/2} {TPER})

* digital control phases
BCHG_EN chg_en 0 V = { V(clk) > 0.9 ? 1 : 0 }
BRESET_EN rst_en 0 V = { V(clk) < 0.9 ? 1 : 0 }

CRAMPNODE ramp 0 {CRAMP} IC=0
RRAMPLEAK ramp 0 1G

* charge current into ramp cap
BCHARGE 0 ramp I = { V(chg_en) * IRAMP }

* reset switch
.model SWMOD SW(Ron=1 Roff=10Meg Vt=0.5 Vh=0.1)
SRESET ramp 0 rst_en 0 SWMOD

* ----------------------------
* PWM COMPARATOR
* ----------------------------
* PWM only active when enable is high
BPWM_RAW pwm_raw 0 V = { 0.9*(1+tanh((V(vref_ss)-V(ramp))/0.01)) }
BPWM pwm 0 V = { (V(enable)>0.9) ? V(pwm_raw) : 0 }

.control
set noaskquit
tran 5n 20u
wrdata ~/tmp/tr100_ctrl_ss_pwm_v1.dat v(enable) v(ss) v(vref_ss) v(clk) v(ramp) v(pwm)
.endc

.end
