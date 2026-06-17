# Condor computation

Each **task** = one **chunk** of sky × **all lens redshifts** (`z = 0.1 … zlmax`, step 0.001). One task ≈ **one CPU × ~20 min** (depends on `zlmax`).

**Chunk split** (`gen_mock_halo.py`):

```
jobs_per_cpu = floor(area / nworker)
n_chunks     = jobs_per_cpu × nworker
chunk_area   = area / n_chunks          # must be ≥ 1 deg²
```

Usually `chunk_area ≈ 1 deg²`. Example: `area=14,000`, `nworker=200` → 70 × 200 chunks → **1.0 deg²** each.

```
jobs_per_cpu = floor(area / nworker)
total time   = jobs_per_cpu × (time per task) + ~30 min setup
```

**Time per task vs `zlmax`:**

| zlmax | z bins | ~time / task |
|------:|-------:|-------------:|
| 3.0 | 2,901 | ~15 min |
| 4.0 | 3,901 | ~20 min |

(`z bins = (zlmax − 0.1) / 0.001 + 1`; scale roughly linear with bin count.)

**Example:** `area = 14,000 deg²`, `zlmax = 4`, `nworker = 200` → 70 jobs/CPU × 20 min ≈ **23 h**.

| nworker | area (deg²) | jobs/CPU | est. time (@ zlmax=4) |
|--------:|------------:|---------:|----------------------:|
| 10 | 14,000 | 1,400 | ~19 days |
| 99 | 14,000 | 141 | ~47 h |
| 200 | 14,000 | 70 | ~23 h |
| 256 | 14,000 | 54 | ~18 h |

**Condor:** `request_cpus` = `NWORKER`. Monitor: `tail -f logs/*_s4.err` (`Done N tasks`, total ≈ area).
