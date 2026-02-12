<!-- -*-Mode: markdown;-*- -->
<!-- $Id$ -->


DataFlowDrs
=============================================================================

**Home**:
  - https://github.com/pnnl/DataFlowDrs
  
  - [Performance Lab for EXtreme Computing and daTa](https://github.com/perflab-exact)


Getting Started
-----------------------------------------------------------------------------

### Prerequisites

- CMake
- C++ Compiler (GCC or Clang)
- Python 3 with pip
- Git
- Bash

The build system will verify compatibility and report any issues.

### Quick Build Instructions

```bash
# 1. Clone the repository
git clone https://github.com/pnnl/DataFlowDrs.git
cd DataFlowDrs

# 2. Make scripts executable (if needed)
chmod +x init-repository.sh scripts/*.sh

# 3. Initialize submodules
./init-repository.sh

# 4. Build entire suite (includes Python dependencies)
./scripts/build-all.sh

# 5. Add to PATH
export PATH="$(pwd)/install/bin:$PATH"
```

### Repository Structure

```
DataFlowDrs/
├── CMakeLists.txt                  # Top-level build configuration
├── init-repository.sh              # Submodule initialization script
├── components/
│   ├── linux_resource_detect/      # Storage Resource Explorer
│   ├── datalife/                   # DataLife - Measurement & DFL analysis
│   ├── dayu/                       # DaYu - Semantic dataflow analysis
│   ├── flowforecaster/             # FlowForecaster - Workflow scaling models
│   └── spm/                        # SPM - Storage Performance Matcher
├── scripts/                        # Build automation scripts
└── docs/                           # Documentation
```

### Managing Component Submodules

DataFlowDrs uses git submodules to organize components as separate repositories. The `init-repository.sh` script manages these submodules.

**Usage:**
```bash
./init-repository.sh [OPTIONS] [COMPONENTS...]

# Options:
#   -h, --help      Show help message
#   -u, --update    Update existing submodules to latest versions
#
# Available components:
#   linux_resource_detect, datalife, dayu, flowforecaster, spm
```

### Build Options

**Usage:**
```bash
# Build all components
./scripts/build-all.sh [BUILD_TYPE] [INSTALL_PREFIX]

# Build specific component
./scripts/build-component.sh <COMPONENT> [BUILD_TYPE] [INSTALL_PREFIX]

# Or manually with CMake
cd components/<COMPONENT>
mkdir build && cd build
cmake ..
make

# Defaults:
#   BUILD_TYPE: Release
#   INSTALL_PREFIX: ./install
#
# Available BUILD_TYPE options:
#   Release, Debug, RelWithDebInfo, MinSizeRel
#
# Available components:
#   linux_resource_detect, datalife, dayu, flowforecaster, spm
```




Components
-----------------------------------------------------------------------------

### Storage Resource Explorer

**Repository**: https://github.com/candiceT233/linux_resource_detect

The Storage Resource Explorer is a set of shell scripts designed to find resources in Linux.

#### Usage Examples

```bash
# Navigate to the component directory
cd components/linux_resource_detect

# Detect local storage resources
./remote_data_transfer.sh

# Detect resources on a remote system
./remote_data_transfer.sh -s <server_address> -i <ssh_identity_file>

# Transfer data to optimal storage location
./remote_data_transfer.sh -f <file_list> -s <server_address>
```

See `components/linux_resource_detect/README.md` for detailed usage instructions.




### DataLife - Measurement & DFL Analysis

**Repository**: https://github.com/pnnl/datalife

The combination of ever-growing scientific datasets and distributed workflow complexity creates I/O performance bottlenecks due to data volume, velocity, and variety. DataLife is a measurement and analysis toolset for distributed scientific workflows comprised of tasks that interact using files and storage. DataLife performs data flow lifecycle (DFL) analysis to guide decisions regarding coordinating task and data flows on distributed resources. DataLife provides tools for measuring, analyzing, visualizing, and estimating the severity of flow bottlenecks based on I/O and storage.

#### Subcomponents

**FlowMonitor**: Description

**FlowAnalysis**: Description

#### Usage Examples

```bash
# Step 1: Set up monitoring environment
# Set output directory for monitoring data
# NOTE: This directory must already exist - DataLife does not create it automatically
mkdir -p ./my_workflow_stats
export DATALIFE_OUTPUT_PATH="./my_workflow_stats"
# Specify file patterns to monitor (optional)
export DATALIFE_FILE_PATTERNS="*.h5, *.nc"

# Step 2: Run your workflow with monitoring
LD_PRELOAD=/path/to/install/lib/libmonitor.so python my_workflow.py [args]
# Or
export PATH="/path/to/install/bin:$PATH"
datalife-run python my_workflow.py [args]

# Step 3: Analyze the collected data
# NOTE: The output directory must already exist - DataLife does not create it automatically
mkdir -p ./my_workflow_stats
datalife-analyze -i ./my_workflow_stats -o my_workflow_dfl.png
```

**Build a single component**:
To build just datalife instead of the entire suite:
```bash
# Using the build script
./scripts/build-component.sh datalife

# Or manually with CMake
cd components/datalife
mkdir build && cd build
cmake ..
make
```

See `components/datalife/README.md` for detailed usage instructions.




### DaYu - Semantic Dataflow Analysis

**Repository**: https://github.com/pnnl/DaYu

The increasing use of descriptive data formats (e.g., HDF5, netCDF) helps organize scientific datasets, but it also creates obscure bottlenecks due to the need to translate high level operations into file addresses and then into low-level I/O operations. DaYu is a method and toolset for analyzing (a) semantic relationships between logical datasets and file addresses, (b) how dataset operations translate into I/O, and (c) the combination across entire workflows. DaYu's analysis and visualization enables identification of critical bottlenecks and reasoning about remediation. With DaYu, one can extract workflow data patterns, develop insights into the behavior of data flows, and identify opportunities for both users and I/O libraries to optimize the applications.

#### Usage Examples

```bash
# Step 1: Set up environment variables
export CURR_TASK="my_workflow_task"

TRACKER_SRC_DIR="../build/src" # dayu_tracker installation path
schema_file_path="`pwd`" #your_path_to_store_log_files
export HDF5_VOL_CONNECTOR="tracker under_vol=0;under_info={};path=$schema_file_path;level=2;format=" # VOL connector info string
export HDF5_PLUGIN_PATH=$TRACKER_SRC_DIR/vfd:$TRACKER_SRC_DIR/vol
export HDF5_DRIVER=hdf5_tracker_vfd # VFD driver name
export HDF5_DRIVER_CONFIG="${schema_file_path};${TRACKER_VFD_PAGE_SIZE}" # VFD info string

# Step 2: Run your HDF5-based workflow
python my_hdf5_workflow.py
```

**Build DaYu component**:
To build just DaYu instead of the entire suite:
```bash
# Using the build script
./scripts/build-component.sh dayu

# Or manually with CMake
cd components/dayu
mkdir build && cd build
cmake ..
make
```

See `components/dayu/README.md` for detailed usage instructions.




### FlowForecaster - Workflow Scaling Model Inference

**Repository**: https://github.com/pnnl/FlowForecaster

FlowForecaster is a tool for automatically inferring detailed and interpretable workflow scaling models from only a few (3--5) empirical task property graphs. A model represents workflow control and data flow as an abstract DAG with analytical expressions to describe how the DAG scales and how data flows along edges. Thus, with a model and proposed workflow input, FlowForecaster predicts the workflow's tasks, control, and data flow properties. 

#### Usage Examples

FlowForecaster processes workflow execution data to generate scaling models:

```bash
# Navigate to FlowForecaster directory
cd components/flowforecaster

# Run the main model inference script
python create_canonical_model_auto_scaling.py \
  --data-instances <data_scaling_files> \
  --task-instances <task_scaling_files> \
  --output-data <data_model_output> \
  --output-task <task_model_output>
```

**Build FlowForecaster component**:
To build just FlowForecaster instead of the entire suite:
```bash
# Using the build script
./scripts/build-component.sh flowforecaster

# Or manual dependency installation
pip install -r components/flowforecaster/requirements.txt
```

See `components/flowforecaster/README.md` for detailed usage instructions.




### SPM - Storage Performance Matcher

**Repository**: https://github.com/candiceT233/spm

SPM (Storage Performance Matcher) is a comprehensive system for analyzing scientific workflow performance and optimizing storage configurations.

#### Prerequisites

SPM is a Python-based tool with the following dependencies:
- Python 3.7+
- numpy
- pandas
- matplotlib
- scipy

#### Usage Examples

SPM processes workflow data in two phases:

```bash
# Navigate to SPM workflow analysis directory
cd components/spm/workflow_analysis

# Phase 1: Convert workflow JSON data to CSV
python3 workflow_data_loader.py --workflow ddmd_4n_l

# Phase 2: Run SPM analysis
python3 workflow_analyzer.py analysis_data/ddmd_4n_l_workflow_data.csv
```

**Build SPM component**:
To build just SPM instead of the entire suite:
```bash
# Using the build script
./scripts/build-component.sh spm

# Or manual dependency installation
pip install numpy pandas matplotlib scipy
```

See `components/spm/workflow_analysis/README.md` for detailed usage instructions.


