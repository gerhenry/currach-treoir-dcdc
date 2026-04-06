* TR100 GATE DRIVER V3
* Cleaner damped gate driver

VDD vdd 0 1.8
VPWM pwm_in 0 PULSE(0 1.8 100n 2n 2n 500n 1u)

.model nch nmos level=1 vto=0.45 kp=150u lambda=0.05
.model pch pmos level=1 vto=-0.45 kp=75u lambda=0.05

* stage 1
M1 n1 pwm_in 0   0   nch W=2u  L=0.5u
M2 n1 pwm_in vdd vdd pch W=4u  L=0.5u

* stage 2
M3 n2 n1     0   0   nch W=4u  L=0.5u
M4 n2 n1     vdd vdd pch W=8u  L=0.5u

* stage 3
M5 gate_int n2   0   0   nch W=10u L=0.5u
M6 gate_int n2   vdd vdd pch W=20u L=0.5u

* stronger damping
RDRV gate_int gate_drv 50
CLOAD gate_drv 0 1p
RLEAK gate_drv 0 1Meg

.control
set noaskquit
tran 1n 5u
wrdata ~/tmp/tr100_gate_driver_v3.dat v(pwm_in) v(n1) v(n2) v(gate_int) v(gate_drv)
.endc

.end
