import os

steps = [
    "python models/buck_startup_protection_model.py",
    "python models/rx_tx_interaction_model.py",
    "python models/rank_architectures.py",
"python models/system_operating_states.py",
    "python models/tx_burst_transient_model.py",
]

for cmd in steps:
    print(f"Running: {cmd}")
    rc = os.system(cmd)
    if rc != 0:
        print(f"Stopped on failure: {cmd}")
        break

print("Analysis flow complete.")
