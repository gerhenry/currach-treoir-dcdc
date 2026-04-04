import csv
from collections import defaultdict

infile = "data/rx_tx_interaction.csv"

# accumulate worst-case RX noise per architecture
worst_noise = defaultdict(float)

with open(infile, "r") as f:
    reader = csv.DictReader(f)
    for row in reader:
        arch = row["architecture"]
        noise = float(row["rx_equiv_noise_V"])

        if noise > worst_noise[arch]:
            worst_noise[arch] = noise

print("=== Architecture Ranking (Worst-Case RX Disturbance) ===")

sorted_arch = sorted(worst_noise.items(), key=lambda x: x[1])

for i, (arch, noise) in enumerate(sorted_arch, 1):
    print(f"{i}. {arch:20s}  worst_noise = {noise*1e3:.3f} mV")
