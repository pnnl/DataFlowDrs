#!/bin/bash
# Initialize DataFlowDrs Git Submodules
#
# Usage:
#   ./init-repository.sh                        # Initialize All Submodules
#   ./init-repository.sh <component_name>       # Initialize Only Specified Component
#   ./init-repository.sh --help                 # Show Help

set -e

# Component list with URLs
# To add a new component, add it here:
#   COMPONENTS[component_name]="https://github.com/org/repo.git"
declare -A COMPONENTS
COMPONENTS[linux_resource_detect]="https://github.com/candiceT233/linux_resource_detect.git"
COMPONENTS[datalife]="https://github.com/pnnl/datalife.git"
COMPONENTS[dayu]="https://github.com/pnnl/DaYu.git"
COMPONENTS[flowforecaster]="https://github.com/pnnl/FlowForecaster.git"
COMPONENTS[spm]="https://github.com/candiceT233/spm.git"

show_help() {
    cat << EOF
DataFlowDrs Submodule Initialization

Usage:
    ./init-repository.sh [OPTIONS] [COMPONENTS...]

Options:
    -h, --help          Show this help message
    -u, --update        Update existing submodules

Components:
    linux_resource_detect
    datalife
    dayu
    flowforecaster
    spm

Examples:
    ./init-repository.sh                            # Initialize All Components
    ./init-repository.sh linux_resource_detect      # Initialize Storage Resource Explorer
    ./init-repository.sh datalife                   # Initialize DataLife
    ./init-repository.sh dayu                       # Initialize DaYu
    ./init-repository.sh flowforecaster             # Initialize FlowForecaster
    ./init-repository.sh spm                        # Initialize SPM

EOF
}

submodule_exists() {
    [ -d "components/$1/.git" ] || [ -f "components/$1/.git" ]
}

init_submodule() {
    local component=$1
    local url=${COMPONENTS[$component]}

    [ -z "$url" ] && echo "Error: Unknown Component: $component" && return 1

    if submodule_exists "$component"; then
        echo "Already Initialized: $component (Use --update To Update)"
        return 0
    fi

    echo "Initializing: $component"

    if git config --file .gitmodules --get "submodule.components/$component.url" > /dev/null 2>&1; then
        git submodule update --init --recursive components/$component
    else
        git submodule add "$url" "components/$component"
        git submodule update --init --recursive components/$component
    fi

    echo "Done: $component"
}

update_submodule() {
    local component=$1

    if ! submodule_exists "$component"; then
        echo "Not Initialized: $component (Skipping)"
        return 0
    fi

    echo "Updating: $component"
    git submodule update --remote components/$component
}

main() {
    local update_mode=false
    local components_to_init=()

    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help) show_help; exit 0 ;;
            -u|--update) update_mode=true; shift ;;
            *)
                if [[ -n "${COMPONENTS[$1]}" ]]; then
                    components_to_init+=("$1")
                else
                    echo "Error: Unknown Component Or Option: $1"
                    exit 1
                fi
                shift
                ;;
        esac
    done

    # Initialize all if no components specified
    if [ ${#components_to_init[@]} -eq 0 ]; then
        components_to_init=("${!COMPONENTS[@]}")
    fi

    [ ! -f "CMakeLists.txt" ] && echo "Error: Run From DataFlowDrs Root Directory" && exit 1

    for component in "${components_to_init[@]}"; do
        if [ "$update_mode" = true ]; then
            update_submodule "$component"
        else
            init_submodule "$component"
        fi
    done

    echo ""
    echo "Next Steps:"
    echo "  ./scripts/build-all.sh"
    echo "  ./scripts/build-component.sh <component_name>"
}

main "$@"