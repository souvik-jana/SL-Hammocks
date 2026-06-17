# Condor computation — `gen_mock_halo.py`

```
n_split     = floor(area / nworker)
total_tasks = n_split × nworker
chunk_area  = area / total_tasks    # must be ≥ 1 deg²
z_bins      = (zlmax − 0.1) / 0.001 + 1    # zlmax=5 → 4901
```

**Example:** `area=14000`, `nworker=200` → `n_split=70` → **14,000 tasks** × **1.0 deg²** → ~70 tasks/worker.

**Condor:** `request_cpus` must equal `NWORKER`. Submit from anywhere: `condor_submit /users/souvik.jana/SL-Hammocks/scripts/condor/qso_14k.sub`

**Monitor:** `tail -f logs/qso_14k_s4.out` — done when `Done 14000 tasks`. `.dat` files fill only at end.

---

## Est. wall time (`area=14000`, `zlmax=5`)

**Raw estimate** — each 1 deg² task (4901 z bins) ≈ **7–8 min**:

```
T ≈ n_split × (7–8 min) + 30 min setup
```

Example @ 200 workers: `70 tasks/worker × 7–8 min` → **~8–9 h**.

| nworker | Tasks | Chunk (deg²) | Est. time |
|--------:|------:|-------------:|-----------|
| 10 | 14,000 | 1.000 | ~7–8 days |
| 16 | 14,000 | 1.000 | ~4–5 days |
| 99 | 13,959 | 1.003 | ~17–19 h |
| 180 | 13,860 | 1.010 | ~9–10 h |
| 200 | 14,000 | 1.000 | ~8–9 h |
| 256 | 13,824 | 1.013 | ~6–7 h |
