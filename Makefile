# TR100 DC-DC Project Makefile

TOP = models/top/tr100_closed_loop_top_v1.sp
OUT = $(HOME)/tmp/tr100_closed_loop_top_v1

all: run

run:
@mkdir -p $(HOME)/tmp
ngspice -b $(TOP) > $(OUT).log 2>&1

results:
awk 'END{print "Vout =", $$14, "Iload =", $$14/7.2, "fb =", $$2, "verr =", $$4}' $(OUT).dat

log:
tail -40 $(OUT).log

clean:
rm -f $(OUT).log $(OUT).dat

help:
@echo "Targets:"
@echo "  make run      - run simulation"
@echo "  make results  - print final output"
@echo "  make log      - show last log lines"
@echo "  make clean    - remove outputs"
