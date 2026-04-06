* TR100 PWM Comparator V2
* Standalone comparator using a soft-start-like reference and the golden ramp

VDD vdd 0 1.8

**************************************************
* REFERENCE INPUT
**************************************************
* simple rising reference for standalone validation
VREF vref_ss 0 PWL(
+ 0        0
+ 100n     0
+ 2u       0.15
+ 4u       0.30
+ 6u       0.45
+ 8u       0.60
+ 10u      0.60
)

**************************************************
* GOLDEN RAMP
**************************************************
.param FSW=1Meg
.param TPER={1/FSW}
.param CRAMP=100p
.param IRAMP=100u

VCLK clk 0 PULSE(0 1.8 0 1n 1n {TPER/2} {TPER})

BCHG_EN chg_en 0 V = { V(clk)>0.9 ? 1.8 : 0 }
BRESET_EN rst_en 0 V = { V(clk)<0.9 ? 1.8 : 0 }

CRAMPNODE ramp 0 {CRAMP} IC=0
RRAMPLEAK ramp 0 10Meg

BCHARGE 0 ramp I = { V(chg_en)>0.9 ? IRAMP : 0 }

.model SWMOD SW(Ron=1 Roff=10Meg Vt=0.9 Vh=0.1)
SRESET ramp 0 rst_en 0 SWMOD

**************************************************
* PWM COMPARATOR
**************************************************
* smooth behavioral comparator
BPWM_RAW pwm_raw 0 V = { 0.9*(1+tanh((V(vref_ss)-V(ramp))/0.01)) }

* rail-like output buffer
BPWM pwm 0 V = { V(pwm_raw) > 0.9 ? 1.8 : 0 }

.control
set noaskquit
tran 5n 10u
wrdata ~/tmp/tr100_pwm_comp_v2.dat v(clk) v(vref_ss) v(ramp) v(pwm_raw) v(pwm)
.endc

.ic V(ramp)=0

.end
