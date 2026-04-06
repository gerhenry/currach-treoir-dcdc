* TR100 PWM RAMP V2 - PHYSICALLY CORRECT RESET

VDD vdd 0 1.8
VREF vref_ss 0 0.3

.param IRAMP=10u
.param CRAMP=100p
.param FSW=1Meg
.param TPER={1/FSW}

* clock
VCLK clk 0 PULSE(0 1.8 0 1n 1n {TPER/2} {TPER})

* ramp cap (real node)
CR ramp 0 {CRAMP} IC=0
RLEAK ramp 0 1G

* current source (charges ramp)
BRAMP 0 ramp I = { (V(clk)<0.9) ? IRAMP : 0 }

* reset switch (THIS IS THE FIX)
SRESET ramp 0 clk 0 SWMOD

.model SWMOD SW(Ron=1 Roff=1Meg Vt=0.9 Vh=0.1)

* PWM comparator
BPWM pwm 0 V = { 0.9*(1+tanh((V(vref_ss)-V(ramp))/0.01)) }

.control
set noaskquit
tran 10n 10u
wrdata ~/tmp/tr100_pwm_ramp_v2.dat v(clk) v(ramp) v(vref_ss) v(pwm)
.endc

.end
