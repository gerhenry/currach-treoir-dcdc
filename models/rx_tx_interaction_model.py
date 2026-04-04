import csv
import math
import os

# ------------------------------------------------------------
# Currach Treoir DC-DC
# RX/TX interaction model
#
# Purpose:
# Estimate how TX burst current causes shared-rail droop
# and how much of that disturbance reaches RX under
# different supply partition strategies.
# ------------------------------------------------------------

# Frequency sweep for disturbance content
freqs_hz = [
    1e3, 3e3, 1e4, 3e4, 1e5, 3e5, 1e6, 3e6, 1e7
]

# System assumptions
vrail = 1.8
i_rx_dc = 0.040      # 40 mA RX nominal
i_tx_idle = 0.020    # 20 mA TX idle
i_tx_burst = 0.180   # 180 mA TX burst
delta_i_tx = i_tx_burst - i_tx_idle   # burst step current

# Shared output impedance of buck + routing + package + decap reality
# This is not transistor-accurate; it is a system exploration model.
r_supply = 0.080     # ohm
l_supply = 8e-9      # H
c_bulk = 22e-6       # F

# RX sensitivity to supply ripple (dimensionless conversion factor)
# Interpreted here as "how much rail ripple becomes RX-equivalent disturbance"
rx_sensitivity = 0.08

# Architecture-specific attenuation from TX disturbance to RX rail
architectures = [
    {
        "name": "shared_buck",
        "coupling_factor": 1.00,   # full shared rail exposure
        "ldo_psrr_db": 0.0
    },
    {
        "name": "split_filtered",
        "coupling_factor": 0.35,   # branch filtering / partial isolation
        "ldo_psrr_db": 0.0
    },
    {
        "name": "rx_ldo",
        "coupling_factor": 0.25,   # pre-LDO coupling reduced at rail split
        "ldo_psrr_db": 20.0        # simple fixed PSRR assumption
    },
    {
        "name": "rx_strong_ldo",
        "coupling_factor": 0.20,
        "ldo_psrr_db": 35.0
    },
]

def z_supply_mag(f_hz: float) -> float:
    """Magnitude of simplified supply impedance."""
    w = 2.0 * math.pi * f_hz

    x_l = w * l_supply
    x_c = 1.0 / (w * c_bulk)

    # Simple series R-L with capacitive shunt represented approximately
    # as net reactive difference for early architecture exploration.
    x_net = x_l - x_c
    return math.sqrt(r_supply ** 2 + x_net ** 2)

def db_to_linear(db: float) -> float:
    return 10.0 ** (-db / 20.0)

rows = []

for arch in architectures:
    psrr_lin = db_to_linear(arch["ldo_psrr_db"])

    for f in freqs_hz:
        zmag = z_supply_mag(f)

        # TX-induced rail droop at shared source node
        tx_droop_v = delta_i_tx * zmag

        # Disturbance that reaches RX rail before any LDO rejection
        rx_rail_disturb_v = tx_droop_v * arch["coupling_factor"]

        # After post-regulation / PSRR if present
        rx_effective_disturb_v = rx_rail_disturb_v * psrr_lin

        # Convert rail disturbance into RX-equivalent output disturbance
        rx_equiv_noise_v = rx_effective_disturb_v * rx_sensitivity

        rows.append([
            arch["name"],
            f,
            vrail,
            i_rx_dc,
            delta_i_tx,
            zmag,
            tx_droop_v,
            rx_rail_disturb_v,
            rx_effective_disturb_v,
            rx_equiv_noise_v
        ])

os.makedirs("data", exist_ok=True)

outfile = "data/rx_tx_interaction.csv"
with open(outfile, "w", newline="") as f:
    w = csv.writer(f)
    w.writerow([
        "architecture",
        "freq_Hz",
        "vrail_V",
        "i_rx_dc_A",
        "delta_i_tx_A",
        "supply_impedance_ohm",
        "tx_droop_V",
        "rx_rail_disturb_V",
        "rx_effective_disturb_V",
        "rx_equiv_noise_V"
    ])
    w.writerows(rows)

print(f"Generated {outfile}")
print()
print("Sample rows:")
for r in rows[:8]:
    print(r)
