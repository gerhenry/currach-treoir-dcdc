import csv
import math
import os

# ------------------------------------------------------------
# Currach Treoir DC-DC
# TX burst transient model
#
# Simple time-domain approximation:
# - TX current steps from idle to burst
# - shared rail sees immediate resistive droop
# - finite C causes dynamic droop during recovery interval
# - RX sees a fraction depending on architecture isolation
# ------------------------------------------------------------

# Time axis
t_start = 0.0
t_stop = 120e-6
dt = 0.5e-6

# Burst timing
t_step = 20e-6
t_release = 70e-6

# Rail / load assumptions
vrail_nom = 1.8
i_tx_idle = 0.020
i_tx_burst = 0.180
delta_i = i_tx_burst - i_tx_idle

# Effective source model
r_supply = 0.080      # ohm
c_bulk = 22e-6        # F
tau_recover = 18e-6   # s, simple loop recovery approximation

architectures = [
    {
        "name": "shared_buck",
        "coupling_factor": 1.00,
        "psrr_db": 0.0
    },
    {
        "name": "split_filtered",
        "coupling_factor": 0.35,
        "psrr_db": 0.0
    },
    {
        "name": "rx_ldo",
        "coupling_factor": 0.25,
        "psrr_db": 20.0
    },
    {
        "name": "rx_strong_ldo",
        "coupling_factor": 0.20,
        "psrr_db": 35.0
    },
]

def db_to_linear(db: float) -> float:
    return 10.0 ** (-db / 20.0)

def current_profile(t: float) -> float:
    if t < t_step:
        return i_tx_idle
    elif t < t_release:
        return i_tx_burst
    else:
        return i_tx_idle

def burst_droop(t: float) -> float:
    """
    Approximation:
    - immediate resistive step droop = delta_i * R
    - capacitor adds time-dependent sag during the burst
    - loop recovery partially counteracts sag with a simple exponential factor
    """
    if t < t_step:
        return 0.0

    if t < t_release:
        tb = t - t_step

        v_r = delta_i * r_supply
        v_c = (delta_i / c_bulk) * tb
        recovery = 1.0 - math.exp(-tb / tau_recover)

        # recovery term subtracts a fraction of the capacitor sag
        v_total = v_r + v_c * (1.0 - 0.75 * recovery)
        return v_total

    # after release: decays back to zero
    td = t - t_release

    burst_len = t_release - t_step
    v_r = delta_i * r_supply
    v_c = (delta_i / c_bulk) * burst_len
    recovery = 1.0 - math.exp(-burst_len / tau_recover)
    v_peak = v_r + v_c * (1.0 - 0.75 * recovery)

    return v_peak * math.exp(-td / tau_recover)

rows = []
summary = []

os.makedirs("data", exist_ok=True)

for arch in architectures:
    psrr_lin = db_to_linear(arch["psrr_db"])
    max_rx_disturb = 0.0
    min_rail = vrail_nom

    t = t_start
    while t <= t_stop + 0.5 * dt:
        itx = current_profile(t)
        v_droop = burst_droop(t)

        v_rail = vrail_nom - v_droop
        if v_rail < min_rail:
            min_rail = v_rail

        rx_rail_disturb = v_droop * arch["coupling_factor"]
        rx_effective_disturb = rx_rail_disturb * psrr_lin

        if rx_effective_disturb > max_rx_disturb:
            max_rx_disturb = rx_effective_disturb

        rows.append([
            arch["name"],
            t,
            itx,
            v_droop,
            v_rail,
            rx_rail_disturb,
            rx_effective_disturb
        ])

        t += dt

    summary.append([
        arch["name"],
        vrail_nom - min_rail,
        max_rx_disturb,
        min_rail
    ])

with open("data/tx_burst_transient.csv", "w", newline="") as f:
    w = csv.writer(f)
    w.writerow([
        "architecture",
        "time_s",
        "tx_current_A",
        "rail_droop_V",
        "rail_voltage_V",
        "rx_rail_disturb_V",
        "rx_effective_disturb_V"
    ])
    w.writerows(rows)

with open("data/tx_burst_transient_summary.csv", "w", newline="") as f:
    w = csv.writer(f)
    w.writerow([
        "architecture",
        "max_rail_droop_V",
        "max_rx_disturb_V",
        "min_rail_voltage_V"
    ])
    w.writerows(summary)

print("Generated data/tx_burst_transient.csv")
print("Generated data/tx_burst_transient_summary.csv")
print()
print("Transient summary:")
for row in summary:
    print(
        f"{row[0]:16s}  "
        f"rail_droop={row[1]*1e3:7.3f} mV   "
        f"rx_disturb={row[2]*1e3:7.3f} mV   "
        f"min_rail={row[3]:.4f} V"
    )
