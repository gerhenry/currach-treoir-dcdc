* TR100 PWM RAMP V6 - CLAMPED RESET (FINAL)

VDD vdd 0 1.8
VREF vref_ss 0 0.3

.param IRAMP=10u
.param IRESET=1m
.param CRAMP=100p
.param FSW=1Meg
.param TPER={1/FSW}

* clock
VCLK clk 0 PULSE(0 1.8 0 1n 1n {TPER/2} {TPER})

* ramp capacitor
CR ramp 0 {CRAMP} IC=0
RLEAK ramp 0 1G

* charge current
BCHARGE 0 ramp I = { (V(clk)>1.2) ? IRAMP : 0 }

* reset current WITH CLAMP
BRESET ramp 0 I = { (V(clk)<0.6 && V(ramp)>0) ? IRESET : 0 }

* hard clamp at 0V (diode)
DCLAMP ramp 0 DCL

.model DCL D(IS=1e-15)

* PWM comparator
BPWM pwm 0 V = { 0.9*(1+tanh((V(vref_ss)-V(ramp))/0.01)) }

.control
set noaskquit
tran 5n 10u
wrdata ~/tmp/tr100_pwm_ramp_v6.dat v(clk) v(ramp) v(vref_ss) v(pwm)
.endc

.end
