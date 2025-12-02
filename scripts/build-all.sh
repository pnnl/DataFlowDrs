#!/bin/bash
# Build all DataFlowDrs components
#
# Usage: ./scripts/build-all.sh [build_type] [install_prefix]

set -e

BUILD_TYPE=${1:-Release}
INSTALL_PREFIX=${2:-$(pwd)/install}
BUILD_DIR="build"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"

cd "$ROOT_DIR"

[ ! -f "CMakeLists.txt" ] && echo "Error: CMakeLists.txt not found" && exit 1

echo "Building DataFlowDrs"
echo "  Build type: $BUILD_TYPE"
echo "  Install to: $INSTALL_PREFIX"

mkdir -p "$BUILD_DIR"
cd "$BUILD_DIR"

cmake \
    -DCMAKE_BUILD_TYPE="$BUILD_TYPE" \
    -DCMAKE_INSTALL_PREFIX="$INSTALL_PREFIX" \
    -DBUILD_ALL=ON \
    ..

make -j$(nproc)
make install

echo "Done. Installed to: $INSTALL_PREFIX"
