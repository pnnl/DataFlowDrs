#!/bin/bash
# Build a specific DataFlowDrs component
#
# Usage: ./scripts/build-component.sh <component> [build_type] [install_prefix]

set -e

if [ $# -lt 1 ]; then
    echo "Usage: $0 <component> [build_type] [install_prefix]"
    echo ""
    echo "Available: linux_resource_detect, datalife, dayu, flowforecaster, spm"
    exit 1
fi

COMPONENT=$1
BUILD_TYPE=${2:-Release}
INSTALL_PREFIX=${3:-$(pwd)/install}
BUILD_DIR="build-$COMPONENT"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"

cd "$ROOT_DIR"

# Component name mapping
# To add a new component, add it here:
#   CMAKE_OPT[newcomponent]="BUILD_NEWCOMPONENT"
declare -A CMAKE_OPT
CMAKE_OPT[linux_resource_detect]="BUILD_LINUX_RESOURCE_DETECT"
CMAKE_OPT[datalife]="BUILD_DATALIFE"
CMAKE_OPT[dayu]="BUILD_DAYU"
CMAKE_OPT[flowforecaster]="BUILD_FLOWFORECASTER"
CMAKE_OPT[spm]="BUILD_SPM"

[ -z "${CMAKE_OPT[$COMPONENT]}" ] && echo "Error: Unknown component: $COMPONENT" && exit 1
[ ! -d "components/$COMPONENT" ] && echo "Error: Component not found. Run: ./init-repository.sh $COMPONENT" && exit 1

echo "Building $COMPONENT"
echo "  Build type: $BUILD_TYPE"
echo "  Install to: $INSTALL_PREFIX"

mkdir -p "$BUILD_DIR"
cd "$BUILD_DIR"

cmake \
    -DCMAKE_BUILD_TYPE="$BUILD_TYPE" \
    -DCMAKE_INSTALL_PREFIX="$INSTALL_PREFIX" \
    -DBUILD_LINUX_RESOURCE_DETECT=OFF \
    -DBUILD_DATALIFE=OFF \
    -DBUILD_DAYU=OFF \
    -DBUILD_FLOWFORECASTER=OFF \
    -DBUILD_SPM=OFF \
    -D${CMAKE_OPT[$COMPONENT]}=ON \
    ..

make -j$(nproc)
make install

echo "Done. Installed to: $INSTALL_PREFIX"
