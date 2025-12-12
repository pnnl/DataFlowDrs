#!/bin/bash
# Build All DataFlowDrs Components
#
# Usage: ./scripts/build-all.sh [build_type] [install_prefix]
#
# This script builds each component individually, so failures in one
# component don't prevent others from building.

BUILD_TYPE=${1:-Release}
INSTALL_PREFIX=${2:-$(pwd)/install}
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"

cd "$ROOT_DIR"

if [ ! -f "CMakeLists.txt" ]; then
    echo "Error: CMakeLists.txt Not Found"
    exit 1
fi

echo "Building DataFlowDrs (All Components)"
echo "  Build Type: $BUILD_TYPE"
echo "  Install To: $INSTALL_PREFIX"
echo ""

# Define all components and their CMake options
# To add a new component, add it to both arrays:
declare -a COMPONENTS=(
    "linux_resource_detect"
    "datalife"
    "dayu"
    "flowforecaster"
    "spm"
)

declare -A CMAKE_OPT
CMAKE_OPT[linux_resource_detect]="BUILD_LINUX_RESOURCE_DETECT"
CMAKE_OPT[datalife]="BUILD_DATALIFE"
CMAKE_OPT[dayu]="BUILD_DAYU"
CMAKE_OPT[flowforecaster]="BUILD_FLOWFORECASTER"
CMAKE_OPT[spm]="BUILD_SPM"

# Track build results
declare -a SUCCESS_COMPONENTS=()
declare -a FAILED_COMPONENTS=()
declare -a SKIPPED_COMPONENTS=()

# Build each component individually
for COMPONENT in "${COMPONENTS[@]}"; do
    echo "=========================================="
    echo "Building Component: $COMPONENT"
    echo "=========================================="

    # Check if component directory exists
    if [ ! -d "components/$COMPONENT" ]; then
        echo "⚠ Component Directory Not Found: components/$COMPONENT"
        echo "  Run: ./init-repository.sh $COMPONENT"
        echo ""
        SKIPPED_COMPONENTS+=("$COMPONENT")
        continue
    fi

    BUILD_DIR="build-$COMPONENT"
    mkdir -p "$BUILD_DIR"
    cd "$BUILD_DIR"

    # Configure CMake for this component only
    echo "Configuring $COMPONENT..."
    if cmake \
        -DCMAKE_BUILD_TYPE="$BUILD_TYPE" \
        -DCMAKE_INSTALL_PREFIX="$INSTALL_PREFIX" \
        -DBUILD_LINUX_RESOURCE_DETECT=OFF \
        -DBUILD_DATALIFE=OFF \
        -DBUILD_DAYU=OFF \
        -DBUILD_FLOWFORECASTER=OFF \
        -DBUILD_SPM=OFF \
        -D${CMAKE_OPT[$COMPONENT]}=ON \
        .. > /dev/null 2>&1; then

        # Build the component
        echo "Building $COMPONENT..."
        if make -j$(nproc) > /dev/null 2>&1; then
            # Install the component
            echo "Installing $COMPONENT..."
            if make install > /dev/null 2>&1; then
                echo "✓ $COMPONENT Built and Installed Successfully"
                SUCCESS_COMPONENTS+=("$COMPONENT")
            else
                echo "✗ $COMPONENT Installation Failed"
                FAILED_COMPONENTS+=("$COMPONENT (Install Failed)")
            fi
        else
            echo "✗ $COMPONENT Build Failed"
            FAILED_COMPONENTS+=("$COMPONENT (Build Failed)")
        fi
    else
        echo "✗ $COMPONENT CMake Configuration Failed"
        FAILED_COMPONENTS+=("$COMPONENT (Configure Failed)")
    fi

    cd "$ROOT_DIR"
    echo ""
done

# Print summary
echo "=========================================="
echo "Build Summary"
echo "=========================================="

if [ ${#SUCCESS_COMPONENTS[@]} -gt 0 ]; then
    echo "✓ Successfully Built (${#SUCCESS_COMPONENTS[@]}):"
    for comp in "${SUCCESS_COMPONENTS[@]}"; do
        echo "  - $comp"
    done
    echo ""
fi

if [ ${#FAILED_COMPONENTS[@]} -gt 0 ]; then
    echo "✗ Failed (${#FAILED_COMPONENTS[@]}):"
    for comp in "${FAILED_COMPONENTS[@]}"; do
        echo "  - $comp"
    done
    echo ""
fi

if [ ${#SKIPPED_COMPONENTS[@]} -gt 0 ]; then
    echo "⚠ Skipped (${#SKIPPED_COMPONENTS[@]}):"
    for comp in "${SKIPPED_COMPONENTS[@]}"; do
        echo "  - $comp (Not Initialized)"
    done
    echo ""
fi

echo "Installation Directory: $INSTALL_PREFIX"
echo "=========================================="

# Exit with appropriate code
if [ ${#FAILED_COMPONENTS[@]} -eq 0 ]; then
    echo "✓ All Available Components Built Successfully"
    exit 0
else
    echo "⚠ Some Components Failed to Build"
    exit 1
fi