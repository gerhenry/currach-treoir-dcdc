import csv
import os

# ------------------------------------------------------------
# Currach Treoir DC-DC
# Startup / protection behaviour model
#
# Simple functional model:
# - UVLO gate
# - EN gate
# - soft-start ramp
# - thermal shutdown flag
# - short-circuit hiccup flag
# ------------------------------------------------------------

vin_values = [2.0, 2.4, 2.6, 3.3, 4.2, 5.0]
en_values = [0, 1]

# simplified assumptions for architecture-level modelling
uvlo_threshold = 2.5
soft_start_time_ms = 1.2
thermal_shutdown_c = 150.0
short_detect_v_fraction = 0.5
hiccup_freq_hz = 300.0
hiccup_duty = 0.45

rows = []

for vin in vin_values:
    for en in en_values:
        uvlo_ok = vin >= uvlo_threshold
        enabled = bool(en) and uvlo_ok

        startup_mode = "disabled"
        if bool(en) and not uvlo_ok:
            startup_mode = "uvlo_blocked"
        elif enabled:
            startup_mode = "soft_start_ramp"

        rows.append([
            vin,
            en,
            uvlo_ok,
            enabled,
            soft_start_time_ms,
            thermal_shutdown_c,
            short_detect_v_fraction,
            hiccup_freq_hz,
            hiccup_duty,
            startup_mode
        ])

os.makedirs("data", exist_ok=True)

with open("data/buck_startup_protection.csv", "w", newline="") as f:
    w = csv.writer(f)
    w.writerow([
        "vin_V",
        "en",
        "uvlo_ok",
        "enabled",
        "soft_start_time_ms",
        "thermal_shutdown_C",
        "short_detect_v_fraction",
        "hiccup_freq_Hz",
        "hiccup_duty",
        "startup_mode"
    ])
    w.writerows(rows)

print("Generated data/buck_startup_protection.csv")
for r in rows:
    print(r)
