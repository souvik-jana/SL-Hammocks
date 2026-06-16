#!/bin/bash
set -euo pipefail

cd /users/souvik.jana/SL-Hammocks
export HOME="${HOME:-/users/souvik.jana}"
export PATH="${HOME}/.pixi/bin:${PATH:-/usr/bin:/bin}"
export PYTHONUNBUFFERED=1

NWORKER="${NWORKER:-16}"

exec pixi run python gen_mock_halo.py "$@" --nworker="${NWORKER}"
