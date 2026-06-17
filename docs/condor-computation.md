# Condor computation — `gen_mock_halo.py`

```
n_split       = floor(area / nworker)     # jobs per CPU
total_tasks   = n_split × nworker
chunk_area    = area / total_tasks        # must be ≥ 1 deg²
jobs_per_cpu  = n_split
```

**Example:** `area=14000`, `nworker=200` → **70 jobs/CPU** × **14,000 tasks** × **1.0 deg²**.

**Condor:** `request_cpus` must equal `NWORKER`. Submit: `condor_submit /users/souvik.jana/SL-Hammocks/scripts/condor/qso_14k.sub`

**Monitor:** `tail -f logs/qso_14k_s4.err` — progress `Done N tasks` (total = `n_split × nworker`). `.dat` files fill only at end.

---

## Est. wall time

One task (~1 deg²) ≈ **20 min on one CPU** (measured: `qso_100` ~15 min @ `zlmax=3`; `qso_14k` ~23 min @ `zlmax=4`).

```
T = jobs_per_cpu × 20 min + setup
  = n_split × 20 min + ~30 min
```

| nworker | Tasks | jobs/CPU | Est. time |
|--------:|------:|---------:|-----------|
| 10 | 14,000 | 1,400 | ~19 days |
| 99 | 13,959 | 141 | ~47 h |
| 200 | 14,000 | 70 | ~23 h |
| 256 | 13,824 | 54 | ~18 h |

**Check:** `area=100`, `nworker=99` → 1 job/CPU × 20 min ≈ **20 min** (observed **14.9 min** @ `zlmax=3`).
