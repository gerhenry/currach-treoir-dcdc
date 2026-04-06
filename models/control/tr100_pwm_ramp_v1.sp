* TR100 PWM RAMP + COMPARATOR V1
* fixed hard-reset sawtooth

VDD vdd 0 1.8
VREF vref_ss 0 0.3

.param IRAMP=10u
.param CRAMP=100p
.param FSW=1Meg
.param TPER={1/FSW}

* ramp capacitor
CR ramp_raw 0 {CRAMP} IC=0
RLEAK ramp_raw 0 1G

* reset clock
VCLK clk 0 PULSE(0 1.8 0 1n 1n {TPER/2} {TPER})

* charge only when clk is low
BRAMP 0 ramp_raw I = { (V(clk)<0.9) ? IRAMP : 0 }

* hard reset view of ramp
BRS ramp 0 V = { (V(clk)>0.9) ? 0 : V(ramp_raw) }

* smooth PWM comparator
BPWM pwm 0 V = { 0.9*(1+tanh((V(vref_ss)-V(ramp))/0.01)) }

.control
set noaskquit
tran 10n 10u
wrdata ~/tmp/tr100_pwm_ramp_v1.dat v(clk) v(ramp_raw) v(ramp) v(vref_ss) v(pwm)
.endc

.end
