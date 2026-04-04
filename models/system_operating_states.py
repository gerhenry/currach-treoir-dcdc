# ------------------------------------------------------------
# Currach Treoir DC-DC
# System Operating States Model
#
# Defines high-level operating modes of the power system
# combining buck + RX/TX behaviour
# ------------------------------------------------------------

states = [
    "OFF",
    "UVLO_BLOCKED",
    "SOFT_START",
    "REGULATION",
    "TX_BURST",
    "OVERLOAD",
    "SHORT_CIRCUIT",
    "THERMAL_SHUTDOWN"
]

# simple rule-based state transitions

def determine_state(vin, en, load_current, temperature, tx_active):
    if en == 0:
        return "OFF"

    if vin < 2.5:
        return "UVLO_BLOCKED"

    if temperature > 150:
        return "THERMAL_SHUTDOWN"

    if load_current > 0.35:
        return "OVERLOAD"

    if load_current < 0.01:
        return "SOFT_START"

    if tx_active:
        return "TX_BURST"

    return "REGULATION"


# Example sweep
vin_values = [2.4, 3.3]
en_values = [0, 1]
load_values = [0.0, 0.1, 0.25, 0.4]
temp_values = [25, 160]
tx_active_values = [0, 1]

results = []

for vin in vin_values:
    for en in en_values:
        for load in load_values:
            for temp in temp_values:
                for tx in tx_active_values:
                    state = determine_state(vin, en, load, temp, tx)
                    results.append([vin, en, load, temp, tx, state])

# Save
import csv, os
os.makedirs("data", exist_ok=True)

with open("data/system_states.csv", "w", newline="") as f:
    w = csv.writer(f)
    w.writerow(["vin", "en", "load_A", "temp_C", "tx_active", "state"])
    w.writerows(results)

print("Generated data/system_states.csv")

for r in results[:10]:
    print(r)
