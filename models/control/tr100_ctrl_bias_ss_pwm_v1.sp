* TR100 CONTROL V1
* Master bias wired into soft-start and PWM ramp

VDD vdd 0 1.8
VEN enable 0 1.8

**************************************************
* MASTER BIAS
**************************************************
.param IMASTER = 10u
.param ISSCALE_SS   = 0.1
.param ISSCALE_RAMP = 10
.param ISSCALE_UVLO = 0.5

BMASTER ibias_master 0 I = { IMASTER }
BSSBIAS ibias_ss     0 I = { IMASTER*ISSCALE_SS }
BRAMPBIAS ibias_ramp 0 I = { IMASTER*ISSCALE_RAMP }
BUVLOBIAS ibias_uvlo 0 I = { IMASTER*ISSCALE_UVLO }

* 1 ohm monitors so V = I numerically
RMON_MASTER ibias_master 0 1
RMON_SS     ibias_ss     0 1
RMON_RAMP   ibias_ramp   0 1
RMON_UVLO   ibias_uvlo   0 1

**************************************************
* SOFT-START BLOCK
**************************************************
.param CSS=100p
.param VREF_FINAL=0.6

CSSNODE ss 0 {CSS} IC=0
RSSLEAK ss 0 1G

* Use magnitude of ibias_ss monitor node voltage as current source value
BSSCHG 0 ss I = { abs(V(ibias_ss)) }

* discharge when disabled
BSSDIS ss 0 I = { (V(enable)<0.9 && V(ss)>0) ? 100u : 0 }

* reference clamp/shape
BREF vref_ss 0 V = { (V(ss) < VREF_FINAL) ? V(ss) : VREF_FINAL }

**************************************************
* PWM RAMP BLOCK
**************************************************
.param CRAMP=100p
.param FSW=1Meg
.param TPER={1/FSW}

VCLK clk 0 PULSE(0 1.8 0 1n 1n {TPER/2} {TPER})

* digital phase control
BCHG_EN chg_en 0 V = { V(clk) > 0.9 ? 1 : 0 }
BRESET_EN rst_en 0 V = { V(clk) < 0.9 ? 1 : 0 }

CRAMPNODE ramp 0 {CRAMP} IC=0
RRAMPLEAK ramp 0 1G

* ramp current from master bias branch
BCHARGE 0 ramp I = { V(chg_en) * abs(V(ibias_ramp)) }

.model SWMOD SW(Ron=1 Roff=10Meg Vt=0.5 Vh=0.1)
SRESET ramp 0 rst_en 0 SWMOD

**************************************************
* PWM COMPARATOR
**************************************************
BPWM_RAW pwm_raw 0 V = { 0.9*(1+tanh((V(vref_ss)-V(ramp))/0.01)) }
BPWM pwm 0 V = { (V(enable)>0.9) ? V(pwm_raw) : 0 }

.control
set noaskquit
tran 5n 20u
wrdata ~/tmp/tr100_ctrl_bias_ss_pwm_v1.dat \
  v(enable) v(ibias_master) v(ibias_ss) v(ibias_ramp) \
  v(ss) v(vref_ss) v(clk) v(ramp) v(pwm)
.endc

.end
