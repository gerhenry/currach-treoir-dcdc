*===========================================================
* treoir_uvlo_hyst_v1.sp
* Simplified UVLO with hysteresis
*===========================================================

.option scale=1u

.model nch nmos level=1 vto=0.50 kp=200u lambda=0.05
.model pch pmos level=1 vto=-0.50 kp=100u lambda=0.05

*-----------------------------------------------------------
* SUPPLIES
*-----------------------------------------------------------
VDD vdd 0 1.8
VSS vss 0 0

*-----------------------------------------------------------
* UVLO INPUT
*-----------------------------------------------------------
* VIN is the supply being monitored
VIN vin 0 3.3

* Fixed reference for first-pass UVLO proof
VREF vref 0 0.60

* Tail bias
VBIAS vbias_tail 0 0.90

*-----------------------------------------------------------
* VIN DIVIDER + HYSTERESIS NETWORK
*-----------------------------------------------------------
* Divider target:
* VIN = 3.3 V -> VSENSE approx 0.60 V nominal
*
* VSENSE = VIN * Rbot / (Rtop + Rbot)
* choose: Rtop=450k, Rbot=100k
* gives 3.3 * 100 / 550 = 0.60 V approx

RTOP vin vsense 450k
RBOT vsense 0 100k

* Positive feedback for hysteresis
* Output high nudges VSENSE upward
* Output low removes that assist
RFB vout vsense 4meg

*-----------------------------------------------------------
* COMPARATOR CORE
*-----------------------------------------------------------
* Compare VSENSE against VREF
* If VSENSE > VREF => output should switch

* NMOS differential pair
M1 n1    vsense tail vss nch W=40u  L=1u
M2 n2    vref   tail vss nch W=40u  L=1u

* PMOS active mirror load
M3 n1    n1     vdd  vdd pch W=80u  L=1u
M4 n2    n1     vdd  vdd pch W=80u  L=1u

* Tail current sink
M5 tail  vbias_tail vss vss nch W=20u L=1u

*-----------------------------------------------------------
* SECOND GAIN STAGE
*-----------------------------------------------------------
M6 vgain n2    vss vss nch W=100u L=1u
M7 vgain vgain vdd vdd pch W=100u L=1u

*-----------------------------------------------------------
* OUTPUT INVERTER
*-----------------------------------------------------------
M8 vout  vgain vdd vdd pch W=150u L=1u
M9 vout  vgain vss vss nch W=150u L=1u

*-----------------------------------------------------------
* ANALYSIS
*-----------------------------------------------------------
.control
echo "==== UVLO DC SWEEP ===="
dc VIN 2.0 4.0 0.02
print v(vin) v(vsense) v(vout) v(vgain) v(n2)

echo "==== OPERATING POINT AT 3.3V ===="
op
print v(vin) v(vsense) v(vref) v(vout) v(vgain) v(n1) v(n2) v(tail)
print i(VDD)

quit
.endc

.end
