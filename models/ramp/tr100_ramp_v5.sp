* TR100 RAMP V5
* FIX: correct current direction

VDD vdd 0 1.8
VEN enable 0 1.8

.param FSW=1Meg
.param TPER={1/FSW}
.param CRAMP=100p
.param IRAMP=100u

VCLK clk 0 PULSE(0 1.8 0 1n 1n {TPER/2} {TPER})

BCHG_EN chg_en 0 V = { V(clk)>0.9 ? 1.8 : 0 }
BRESET_EN rst_en 0 V = { V(clk)<0.9 ? 1.8 : 0 }

CRAMPNODE ramp 0 {CRAMP} IC=0
RRAMPLEAK ramp 0 10Meg

* ✅ Correct direction: ground → ramp
BCHARGE 0 ramp I = { V(chg_en)>0.9 ? IRAMP : 0 }

.model SWMOD SW(Ron=1 Roff=10Meg Vt=0.9 Vh=0.1)
SRESET ramp 0 rst_en 0 SWMOD

.control
set noaskquit
tran 5n 10u
wrdata ~/tmp/tr100_ramp_v5.dat v(clk) v(chg_en) v(rst_en) v(ramp)
.endc

.ic V(ramp)=0

.end
