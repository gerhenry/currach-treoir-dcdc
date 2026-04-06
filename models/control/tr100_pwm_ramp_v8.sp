* TR100 PWM RAMP V8 - SWITCH RESET (CORRECT)

VDD vdd 0 1.8
VREF vref_ss 0 0.3

.param IRAMP=100u
.param CRAMP=100p
.param FSW=1Meg
.param TPER={1/FSW}

* clock
VCLK clk 0 PULSE(0 1.8 0 1n 1n {TPER/2} {TPER})

* inverted clock for reset
BCLKINV clk_inv 0 V = {1.8 - V(clk)}

* ramp capacitor
CR ramp 0 {CRAMP} IC=0
RLEAK ramp 0 1G

* charge current
BCHARGE 0 ramp I = { (V(clk)>0.6) ? IRAMP : 0 }

* switch model
.model SWMOD SW(Ron=1 Roff=10Meg Vt=0.6 Vh=0.05)

* HARD RESET SWITCH
SRESET ramp 0 clk_inv 0 SWMOD

* PWM comparator
BPWM pwm 0 V = { 0.9*(1+tanh((V(vref_ss)-V(ramp))/0.01)) }

.control
set noaskquit
tran 5n 10u
wrdata ~/tmp/tr100_pwm_ramp_v8.dat v(clk) v(ramp) v(vref_ss) v(pwm)
.endc

.end
