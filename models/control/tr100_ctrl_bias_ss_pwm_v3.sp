* TR100 CONTROL V3 (REAL SOFTSTART)

VDD vdd 0 1.8
VEN enable 0 1.8

.param IMASTER = 10u
.param ISSCALE_SS   = 0.1
.param ISSCALE_RAMP = 10

BSSBIAS ibias_ss     0 I = { IMASTER*ISSCALE_SS }
BRAMPBIAS ibias_ramp 0 I = { IMASTER*ISSCALE_RAMP }

RMON_SS     ibias_ss     0 1
RMON_RAMP   ibias_ramp   0 1

**************************************************
* SOFT-START (FIXED PROPERLY)
**************************************************
.param CSS=100p
.param VREF_FINAL=0.6

CSSNODE ss 0 {CSS} IC=0
RSSLEAK ss 0 10Meg

BSSCHG 0 ss I = { (V(ss) < VREF_FINAL) ? abs(V(ibias_ss)) : 0 }

BREF vref_ss 0 V = { V(ss) }

**************************************************
* PWM RAMP
**************************************************
.param CRAMP=100p
.param FSW=1Meg
.param TPER={1/FSW}

VCLK clk 0 PULSE(0 1.8 0 1n 1n {TPER/2} {TPER})

BCHG_EN chg_en 0 V = { V(clk)>0.9 ? 1 : 0 }
BRESET_EN rst_en 0 V = { V(clk)<0.9 ? 1 : 0 }

CRAMPNODE ramp 0 {CRAMP} IC=0

BCHARGE 0 ramp I = { V(chg_en)*abs(V(ibias_ramp)) }

.model SWMOD SW(Ron=1 Roff=10Meg Vt=0.5 Vh=0.1)
SRESET ramp 0 rst_en 0 SWMOD

**************************************************
* PWM
**************************************************
BPWM_RAW pwm_raw 0 V = { 0.9*(1+tanh((V(vref_ss)-V(ramp))/0.01)) }
BPWM pwm 0 V = { V(pwm_raw) }

.control
set noaskquit
tran 5n 20u
wrdata ~/tmp/tr100_ctrl_bias_ss_pwm_v3.dat v(ss) v(vref_ss) v(ramp) v(pwm)
.endc

.end
