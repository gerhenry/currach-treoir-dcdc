* TR100 MASTER BIAS V1 (FIXED)
* Behavioral master bias with scaled outputs

VDD vdd 0 1.8

* Enable for bias startup (fast for transient sim)
VEN enable 0 PULSE(0 1.8 100n 10n 10n 10u 20u)

**************************************************
* MASTER BIAS PARAMETERS
**************************************************
.param IMASTER = 10u
.param ISSCALE_SS   = 0.1
.param ISSCALE_RAMP = 10
.param ISSCALE_UVLO = 0.5

**************************************************
* MASTER BIAS GENERATION
**************************************************
BMASTER ibias_master 0 I = { (V(enable)>0.9) ? IMASTER : 0 }

**************************************************
* SCALED BIAS OUTPUTS
**************************************************
BSS   ibias_ss   0 I = { (V(enable)>0.9) ? IMASTER*ISSCALE_SS   : 0 }
BRAMP ibias_ramp 0 I = { (V(enable)>0.9) ? IMASTER*ISSCALE_RAMP : 0 }
BUVLO ibias_uvlo 0 I = { (V(enable)>0.9) ? IMASTER*ISSCALE_UVLO : 0 }

**************************************************
* MONITORS (1Ω → V = I)
**************************************************
RMON_MASTER ibias_master 0 1
RMON_SS     ibias_ss     0 1
RMON_RAMP   ibias_ramp   0 1
RMON_UVLO   ibias_uvlo   0 1

.control
set noaskquit
tran 10n 10u
wrdata ~/tmp/tr100_master_bias_v1.dat v(enable) v(ibias_master) v(ibias_ss) v(ibias_ramp) v(ibias_uvlo)
.endc

.end
