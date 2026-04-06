* TR100 IDEAL BUCK POWER STAGE V2
* Cleaned asynchronous buck stage for 250mA target

VIN vin 0 3.3
VDRV gate_drv 0 PULSE(0 1.8 100n 2n 2n 565n 1u)

**************************************************
* IDEAL HIGH-SIDE SWITCH
**************************************************
.model SWBUCK SW(Ron=0.05 Roff=10Meg Vt=0.9 Vh=0.1)
SMAIN vin sw gate_drv 0 SWBUCK

**************************************************
* FREEWHEEL DIODE
* anode at ground, cathode at switch node
**************************************************
.model DFW D(IS=1e-15 RS=0.05 N=1)
DFREE 0 sw DFW

**************************************************
* LC FILTER
**************************************************
L1 sw vout 4.7u
COUT vout 0 22u
RESR vout vout_load 0.05

**************************************************
* 250mA LOAD TARGET @ 1.8V
**************************************************
RLOAD vout_load 0 7.2

**************************************************
* NUMERICAL AIDS
**************************************************
RBLEED sw 0 1Meg
RVBLEED vout 0 1Meg

.control
set noaskquit
tran 10n 100u
wrdata ~/tmp/tr100_buck_power_stage_v2.dat v(gate_drv) v(sw) v(vout) v(vout_load)
.endc

.ic V(vout)=0 V(vout_load)=0

.end
