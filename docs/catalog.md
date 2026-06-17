# SL-Hammocks Output Catalog

This document describes the files produced by `gen_mock_halo.py`, using examples from the completed `qso_100` run (`area=100 deg²`, `prefix=qso_100`).

File names follow the pattern `{prefix}_*`. Replace `qso_100` with your own `--prefix` value.

---

## Quick reference

| File | Type | Purpose |
|------|------|---------|
| `{prefix}_result.dat` | Main catalog | Lensing events + lens model components |
| `{prefix}_log.dat` | Image catalog | Per-event summary and image-level data |
| `{prefix}_setup.dat` | Config | All simulation parameters |
| `{prefix}_interp_*.npz` | Binary tables | Precomputed interpolation grids (setup) |
| `{prefix}_*_tup.txt` | Raw tuples | Python-native dumps for reloading |

**Primary science products:** `result.dat` and `log.dat`.

---

## `{prefix}_result.dat`

Main mock catalog. Each **lensing event** is one header line followed by up to **5 lens component lines**.

### File header (comment lines)

```
# observable multi events: 22 (subhalo 3), high-mag events: 23
# total area, nworkers, and exec time : 100.0 [deg^2], 99 process, 893.04 [sec]
```

| Field | `qso_100` value | Meaning |
|-------|-----------------|---------|
| Observable multi events | 22 | Events with multiple resolved images above the magnitude limit |
| Subhalo multi events | 3 | Subset lensed by subhalos |
| High-mag events | 23 | Events with peak magnification above threshold |
| Area | 100.0 deg² | Survey area simulated |
| Workers | 99 | Parallel processes used |
| Exec time | 893.04 s | Wall time for parallel stage |

### Event header line (12 columns)

**Example (event 1, line 10):**

```
3  2.193000e+01  2.265973e+01  1.552268e+00  8.786398e-01  0  2.765281e-01  2.028148e+01  3  2.6500  8.606622e-01  -5.682473e-01
```

| Col | Name | Example | Units | Description |
|-----|------|---------|-------|-------------|
| 0 | `nim` | 3 | — | Number of lensed images |
| 1 | `mori` | 21.93 | mag | Intrinsic (unlensed) source magnitude |
| 2 | `mobs` | 22.66 | mag | Observed (lensed) brightest image magnitude |
| 3 | `sep` | 1.55 | arcsec | Separation between brightest and faintest image |
| 4 | `ein` | 0.879 | arcsec | Einstein radius |
| 5 | `fs` | 0 | — | Flux-ratio flag |
| 6 | `frac_sh_trunc` | 0.277 | — | Fraction of subhalo mass truncated |
| 7 | `mmin` | 20.28 | mag | Faintest image magnitude |
| 8 | `flag_out` | 3 | — | Event classification (see below) |
| 9 | `zs` | 2.65 | — | Source (QSO) redshift |
| 10 | `xs` | 0.861 | arcsec | Source position x |
| 11 | `ys` | -0.568 | arcsec | Source position y |

**`flag_out` values:**

| Value | Meaning |
|-------|---------|
| 1 | Observable multiply-imaged event |
| 2 | High-magnification event (not necessarily multi-image) |
| 3 | Both (1 + 2) |

### Lens component lines (8 columns each, up to 5 per event)

Follow the event header. Index `i = 0..4` maps to:

| `m_type` | Component | Model |
|----------|-----------|-------|
| 0 | Subhalo | NFW (`anfw`) |
| 1 | Satellite galaxy | Hernquist (`ahern`) |
| 2 | Host halo | NFW (`anfw`) |
| 3 | Central galaxy | Hernquist (`ahern`) |
| 4 | External perturbation | (`pert`) |

Missing components are stored as **-1**.

**Example lens lines for event 1:**

```
 0  1.1010  4.936501e+12  0.0  0.0  2.107e-01  -35.30  12.25    ← subhalo (i=0)
 1  1.1010  5.603645e+10  0.0  0.0  3.234e-01  -60.29   0.107   ← satellite (i=1)
 2  1.1010  1.770136e+13  11.79  -11.99  0.353  62.32  2.78    ← host halo (i=2)
 3  1.1010  1.271675e+11  11.79  -11.99  0.560  77.88  0.057    ← central gal (i=3)
 4  1.1010  2.650000e+00  0.0  0.0  0.098  -29.53  0.0          ← perturbation (i=4)
```

| Col | Name | Example (host halo) | Units | Description |
|-----|------|---------------------|-------|-------------|
| 0 | `m_type` | 2 | — | Component index (0–4) |
| 1 | `zl` | 1.101 | — | Lens redshift |
| 2 | `mass` | 1.77×10¹³ | M☉/h | Mass |
| 3 | `xl` | 11.79 | arcsec | Lens position x |
| 4 | `yl` | -11.99 | arcsec | Lens position y |
| 5 | `e` | 0.353 | — | Ellipticity |
| 6 | `p` | 62.32 | deg | Position angle |
| 7 | `param1` | 2.78 | arcsec | Concentration (NFW) or scale radius (Hernquist) |

---

## `{prefix}_log.dat`

Human-readable per-event log with image positions and lensing diagnostics.

### File header (comment lines)

```
# zmin, zmax, log10Mhmin, log10Mhmax, log10mshmin, log10mshmax, n_bins: 0.10, 3.00, 10.00, 16.00, 9.00, 16.00, 100
```

### Event summary line (10 columns)

**Example (event 1, line 4):**

```
3  8.606622e-01  -5.682473e-01  1.552268e+00  8.786398e-01  1.118669e-01  2.650000e+00  0  3  2.765281e-01
```

| Col | Name | Example | Units | Description |
|-----|------|---------|-------|-------------|
| 0 | `num_image` | 3 | — | Number of images |
| 1 | `x_src` | 0.861 | arcsec | Source x |
| 2 | `y_src` | -0.568 | arcsec | Source y |
| 3 | `sep` | 1.55 | arcsec | Image separation |
| 4 | `ein` | 0.879 | arcsec | Einstein radius |
| 5 | `fr` | 0.112 | — | Flux ratio |
| 6 | `zs` | 2.65 | — | Source redshift |
| 7 | `fs` | 0 | — | Flux-ratio flag |
| 8 | `flag_out` | 3 | — | Event type (1/2/3) |
| 9 | `frac_sh_trunc` | 0.277 | — | Subhalo truncation fraction |

### Image lines (8 columns, `nim` lines per event)

**Example (3 images for event 1, lines 5–7):**

```
-2.474216e-01   1.308223e+00   4.564655e+00   0.000000e+00   0.435172   0.312517   0.047843   0.002909
-7.354702e-02  -2.342762e-01  -5.106337e-01  1.753314e+02   1.593626   1.285567  -0.811209   0.339743
-6.966056e-03  -2.003698e-02   5.703964e-03  1.800359e+02  15.806307   4.485686  -4.877364  13.252631
```

| Col | Name | Example (image 1) | Units | Description |
|-----|------|-------------------|-------|-------------|
| 0 | `x_img` | -0.247 | arcsec | Image position x |
| 1 | `y_img` | 1.308 | arcsec | Image position y |
| 2 | `mag` | 4.56 | — | Magnification μ |
| 3 | `delay` | 0.0 | days | Time delay |
| 4 | `kappa` | 0.435 | — | Convergence κ |
| 5 | `gamma1` | 0.313 | — | Shear component γ₁ |
| 6 | `gamma2` | 0.048 | — | Shear component γ₂ |
| 7 | `kappa*` | 0.0029 | — | External convergence from galaxy |

---

## `{prefix}_setup.dat`

Key-value list of all global parameters used in the run.

**Example entries from `qso_100_setup.dat`:**

```
area: 100.0
ilim: 23.3
zlmax: 3.0
zlmin: 0.1
source: qso
prefix: qso_100
solver: glafic
nworker: 99
COSMO_MODEL: planck18
cosmo_omega: 0.3111
cosmo_lambda: 0.6889
cosmo_hubble: 0.6766
log10Mh_min: 10.0
log10Mh_max: 16.0
log10Msh_min: 9.0
maglim: 3.0
```

Use this file to reproduce or cite the exact run configuration.

---

## `{prefix}_interp_*.npz`

Binary NumPy archives created during setup. These speed up the simulation and are not primary science outputs.

### `{prefix}_interp_bsrc_h.npz`

Host-halo background-source probability interpolator.

```python
import numpy as np
d = np.load("result/qso_100_interp_bsrc_h.npz")
# d["arr_0"] → log10(host halo mass), shape (50,)
# d["arr_1"] → redshift grid, shape (50,)
# d["arr_2"] → source probability table, shape (50, 50)
```

### `{prefix}_interp_bsrc_sh.npz`

Subhalo background-source probability interpolator (same layout as above).

### `{prefix}_interp_dnsh_msh_acc_Mh.npz`

Subhalo mass function lookup table (dn/dm vs. host mass and redshift).

---

## `{prefix}_*_tup.txt`

Raw Python tuple dumps — one line per lensing event. Useful for reloading in Python; not meant for manual reading.

All five files share the same line order (event 1 = line 1 in each file).

### `{prefix}_pars_tup.txt`

**Example (event 1):**

```
[3, 21.93, 22.66, 0.112, 1.55, 0, 0.277, 0.879, 20.28, 3]
```

| Index | Name | Example | Description |
|-------|------|---------|-------------|
| 0 | `nim` | 3 | Number of images |
| 1 | `mori` | 21.93 | Intrinsic magnitude |
| 2 | `mobs` | 22.66 | Observed magnitude |
| 3 | `fr` | 0.112 | Flux ratio |
| 4 | `sep` | 1.55 | Image separation [arcsec] |
| 5 | `fs` | 0 | Flux-ratio flag |
| 6 | `frac_sh_trunc` | 0.277 | Subhalo truncation fraction |
| 7 | `ein` | 0.879 | Einstein radius [arcsec] |
| 8 | `mmin` | 20.28 | Faintest image magnitude |
| 9 | `flag_out` | 3 | Event type |

### `{prefix}_srcs_tup.txt`

**Example (event 1):**

```
[2.65, 0.861, -0.568]
```

| Index | Name | Example | Description |
|-------|------|---------|-------------|
| 0 | `zs` | 2.65 | Source redshift |
| 1 | `xs` | 0.861 | Source x [arcsec] |
| 2 | `ys` | -0.568 | Source y [arcsec] |

### `{prefix}_lens_tup.txt`

**Example (event 1, truncated):**

```python
[
  ['anfw',  1.101, 4.94e12,  0.0, 0.0, 0.211, -35.3, 12.25, 0.0],   # subhalo
  ['ahern', 1.101, 5.60e10,  0.0, 0.0, 0.323, -60.3,  0.107, 0.0], # satellite
  ['anfw',  1.101, 1.77e13, 11.8, -12.0, 0.353,  62.3,  2.78, 0.0],# host halo
  ['ahern', 1.101, 1.27e11, 11.8, -12.0, 0.560,  77.9,  0.057, 0.0],# central gal
  ['pert',  1.101, 2.65,     0.0,  0.0, 0.098, -29.5,  0.0,  0.0] # perturbation
]
```

Each lens entry: `[model, zl, mass, x, y, e, p, param1, extra]`.

### `{prefix}_imgs_tup.txt`

**Example (event 1, 3 images):**

```python
[(-0.247, 1.308, 4.565, 0.0), (-0.074, -0.234, -0.511, 175.3), (-0.007, -0.020, 0.006, 180.0)]
```

Each image tuple: `(x_img, y_img, magnification, time_delay_days)`.

### `{prefix}_kapg_tup.txt`

**Example (event 1, image 1):**

```python
[0.435, 0.313, 0.048, 0.0029]
```

| Index | Name | Example | Description |
|-------|------|---------|-------------|
| 0 | `kappa` | 0.435 | Convergence |
| 1 | `gamma1` | 0.313 | Shear γ₁ |
| 2 | `gamma2` | 0.048 | Shear γ₂ |
| 3 | `kappa*` | 0.0029 | External convergence |

---

## Reloading in Python

```python
# Read raw event tuples
def load_events(prefix="qso_100"):
    base = f"result/{prefix}"
    with open(f"{base}_pars_tup.txt") as f:
        pars = [eval(line) for line in f]
    with open(f"{base}_srcs_tup.txt") as f:
        srcs = [eval(line) for line in f]
    with open(f"{base}_lens_tup.txt") as f:
        lenses = [eval(line) for line in f]
    return pars, srcs, lenses

pars, srcs, lenses = load_events("qso_100")
print(f"Event 1: {pars[0][0]} images, zs={srcs[0][0]:.2f}")
```

---

## Further reading

- SL-Hammocks paper: [Abe et al. 2025, OJAp 8, 8](https://ui.adsabs.harvard.edu/abs/2025OJAp....8E...8A/abstract)
- Example catalogs: [LSST data_public / SL_hammocks_catalogs](https://github.com/LSST-strong-lensing/data_public/tree/main/SL_hammocks_catalogs)
