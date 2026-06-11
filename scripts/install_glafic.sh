#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
GLAFIC_DIR="${ROOT}/.deps/glafic2"

if [ ! -d "${GLAFIC_DIR}" ]; then
    git clone --depth 1 https://github.com/oguri/glafic2.git "${GLAFIC_DIR}"
fi

cd "${GLAFIC_DIR}"
make clean
make python LIBPATH="${CONDA_PREFIX}/lib" INCPATH="${CONDA_PREFIX}/include"

SITE_PACKAGES="$(python -c "import site; print(site.getsitepackages()[0])")"
rm -rf "${SITE_PACKAGES}/glafic"
cp -r python/glafic "${SITE_PACKAGES}/"
