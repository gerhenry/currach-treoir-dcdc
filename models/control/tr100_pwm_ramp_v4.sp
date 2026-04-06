* TR100 PWM RAMP V4 - NON-OVERLAP FIX

VDD vdd 0 1.8
VREF vref_ss 0 0.3

.param IRAMP=10u
.param CRAMP=100p
.param FSW=1Meg
.param TPER={1/FSW}

* clock
VCLK clk 0 PULSE(0 1.8 0 1n 1n {TPER/2} {TPER})

* ramp node
CR ramp 0 {CRAMP} IC=0
RLEAK ramp 0 1G

* CHARGE only when clk HIGH (strong condition)
BRAMP 0 ramp I = { (V(clk)>1.2) ? IRAMP : 0 }

* RESET only when clk LOW (strong condition)
SRESET ramp 0 clk 0 SWMOD

.model SWMOD SW(Ron=0.5 Roff=10Meg Vt=0.6 Vh=0.05)

* PWM comparator
BPWM pwm 0 V = { 0.9*(1+tanh((V(vref_ss)-V(ramp))/0.01)) }

.control
set noaskquit
tran 5n 10u
wrdata ~/tmp/tr100_pwm_ramp_v4.dat v(clk) v(ramp) v(vref_ss) v(pwm)
.endc

.end
