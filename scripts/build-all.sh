#!/bin/bash
# Build All DataFlowDrs Components
#
# Usage: ./scripts/build-all.sh [build_type] [install_prefix]

BUILD_TYPE=${1:-Release}
INSTALL_PREFIX=${2:-$(pwd)/install}
BUILD_DIR="build"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"

cd "$ROOT_DIR"

if [ ! -f "CMakeLists.txt" ]; then
    echo "Error: CMakeLists.txt Not Found"
    exit 1
fi

echo "Building Dataflowdrs"
echo "  Build Type: $BUILD_TYPE"
echo "  Install To: $INSTALL_PREFIX"

mkdir -p "$BUILD_DIR"
cd "$BUILD_DIR"

# Run CMake configuration
echo ""
echo "Configuring With CMake..."
if ! cmake \
    -DCMAKE_BUILD_TYPE="$BUILD_TYPE" \
    -DCMAKE_INSTALL_PREFIX="$INSTALL_PREFIX" \
    -DBUILD_ALL=ON \
    ..; then
    echo "Error: CMake Configuration Failed"
    exit 1
fi

# Build with make, continuing even if some targets fail
echo ""
echo "Building Components..."
BUILD_FAILED=0
if ! make -k -j$(nproc); then
    BUILD_FAILED=1
    echo ""
    echo "Warning: Some Components Failed To Build"
fi

# Attempt installation, continuing on errors
echo ""
echo "Installing Components..."
INSTALL_FAILED=0
if ! make -k install; then
    INSTALL_FAILED=1
    echo ""
    echo "Warning: Some Components Failed To Install"
fi

# Print summary
echo ""
echo "=========================================="
if [ $BUILD_FAILED -eq 0 ] && [ $INSTALL_FAILED -eq 0 ]; then
    echo "✓ All Components Built And Installed Successfully"
    echo "Installed To: $INSTALL_PREFIX"
    exit 0
else
    echo "⚠ Build Completed With Errors"
    if [ $BUILD_FAILED -eq 1 ]; then
        echo "  - Some Components Failed To Build"
    fi
    if [ $INSTALL_FAILED -eq 1 ]; then
        echo "  - Some Components Failed To Install"
    fi
    echo ""
    echo "Check The Output Above For Details On Which Components Failed."
    echo "Successfully Built Components Are Installed To: $INSTALL_PREFIX"
    exit 1
fi