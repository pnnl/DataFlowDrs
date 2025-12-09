<!-- -*-Mode: markdown;-*- -->
<!-- $Id$ -->


DataFlowDrs
=============================================================================

**Home**:
  - https://github.com/pnnl/DataFlowDrs
  
  - [Performance Lab for EXtreme Computing and daTa](https://github.com/perflab-exact)


**About**: 

Scientific workflows  are critical in many areas of scientific exploration. Because these workflows tend to be data intensive, severe bottlenecks emerge in storage systems and I/O networks. We introduce DataFlowDrs, a new comprehensive suite of tools for performance optimization of HPC workflows that especially focuses on data flow and storage. DataFlowDrs introduces (a) lightweight high-resolution measurement and visualization tools for workflow profiling and tracing; (b) rapid modeling and analysis that reduces analysis data by compressing common repeated coordination patterns; (c) novel methods for predicting data flow scaling using automatically generated interpretable models of data flow; (d) effective performance analysis and bottleneck detection that can automatically quantify and rank bottlenecks for different combinations of task parallelism and storage resources; (e) actionable performance optimization in the form of new schedules and resource assignments. DataFlowDrs automates several previously difficult manual analyses and substantially reduces the impact of data flow bottlenecks by recommending the right tradeoffs between task parallelism and storage performance.


**DataFlowDrs Tools**: 

![DataFlowDrs overview](/dataflowdr-overview.png)

DataFlowDrs provides tools for measuring, visualizing, analyzing, modeling, ranking, and resolving dataflow bottlenecks. Its capabilities include lightweight high-resolution measurement; intuitive and interactive visualization; automated modeling methods for reasoning about workflow DAGs and data flows; bottleneck analysis and performance prediction to identify and rank bottlenecks; and rescheduling to select the better of better of flow parallelism and flow locality.

The *measurement* (1), which operates on unmodified workflows, is scalable, with lightweight but high-resolution profiles and traces of dataflow between tasks. The resulting data flow lifecycles (DFL) guide bottleneck analysis and coordination of task and data flows on distributed resources. DFLs even expose the relationship between data semantics and dataflow when using descriptive data formats such as HDF5.

The *visualization and analysis* (2) enable an analyst to quickly and interactively reason about dataflow and potential bottlenecks. To focus attention, flow analysis isolates critical flows and their interactions; and associates flow metrics with producer-consumer patterns.

The performance *modeling* (3) predicts data flow bottlenecks using automatically generated models of data flow, inferred from only 3--5 workflow executions. The models are interpretable in that they typically are composed entirely of analytical expressions. Companion *ranking* models (4) quantify the bottleneck severity of producer-consumer relations for different combinations of task parallelism and storage resources.

Finally, *bottleneck ranking and resolution* (5) presents actionable performance optimization in the form of new schedules and resource assignments. The resulting schedules find the right tradeoffs between task parallelism and storage performance and that can substantially reduce the impact of data flow bottlenecks.



Getting Started
-----------------------------------------------------------------------------

### Prerequisites

- **CMake** >= 3.15
- **C++14** compliant compiler (GCC 7+, Clang 5+)
- **Python** 3.7+
- **Git** 2.13+ (for submodules)

### Quick Build Instructions

```bash
# 1. Clone the repository
git clone https://github.com/pnnl/DataFlowDrs.git
cd DataFlowDrs

# 2. Initialize submodules
./init-repository.sh

# 3. Build entire suite (includes Python dependencies)
./scripts/build-all.sh

# 4. Add to PATH
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

**Initialize all components:**
```bash
./init-repository.sh
```

**Initialize specific component:**
```bash
./init-repository.sh <component_name>
```

**Update components to latest versions:**
```bash
./init-repository.sh --update
```

### Build Options

**Standard build:**
```bash
./scripts/build-all.sh
```

**Debug build:**
```bash
./scripts/build-all.sh Debug
```

**Build a single component:**
You can also build just a single component instead of the entire suite:
```bash
# Using the build script
./scripts/build-component.sh <component_name>

# Or manually with CMake
cd components/<component_name>
mkdir build && cd build
cmake ..
make
```




Components
-----------------------------------------------------------------------------

### Storage Resource Explorer

**Repository**: https://github.com/candiceT233/linux_resource_detect

The Storage Resource Explorer is a set of shell scripts designed to find resources in Linux using shell scripts.

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
export DATALIFE_OUTPUT_PATH="./my_workflow_stats"
# Specify file patterns to monitor (optional)
export DATALIFE_FILE_PATTERNS="*.h5, *.nc"

# Step 2: Run your workflow with monitoring
LD_PRELOAD=/path/to/install/lib/libmonitor.so python my_workflow.py [args]
# Or
export PATH="/path/to/install/bin:$PATH"
datalife-run python my_workflow.py [args]

# Step 3: Analyze the collected data
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

#### Prerequisites

FlowForecaster is a Python-based tool with the following dependencies:
- Python 3.7+
- numpy
- networkx
- matplotlib
- pandas
- sortedcontainers

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
pip install numpy networkx matplotlib pandas sortedcontainers
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




TODO
-----------------------------------------------------------------------------

<del>

* Storage resource explorer: 
    https://github.com/candiceT233/linux_resource_detect
    
* [DataLife](https://github.com/pnnl/datalife): <!-- https://github.com/candiceT233/datalife -->
  The combination of ever-growing scientific datasets and distributed workflow complexity creates I/O performance bottlenecks due to data volume, velocity, and variety. DataLife is a measurement and analysis toolset for distributed scientific workflows comprised of tasks that interact using files and storage. DataLife performs data flow lifecycle (DFL) analysis to guide decisions regarding coordinating task and data flows on distributed resources. DataLife provides tools for measuring, analyzing, visualizing, and estimating the severity of flow bottlenecks based on I/O and storage.

* [DaYu](https://github.com/pnnl/DaYu):
  The increasing use of descriptive data formats (e.g., HDF5, netCDF) helps organize scientific datasets, but it also creates obscure bottlenecks due to the need to translate high level operations into file addresses and then into low-level I/O operations. DaYu is a method and toolset for analyzing (a) semantic relationships between logical datasets and file addresses, (b) how dataset operations translate into I/O, and (c) the combination across entire workflows. DaYu's analysis and visualization enables identification of critical bottlenecks and reasoning about remediation. With DaYu, one can extract workflow data patterns, develop insights into the behavior of data flows, and identify opportunities for both users and I/O libraries to optimize the applications.

    <!-- https://github.com/candiceT233/dayu-tracker -->

* [FlowForecaster](https://github.com/pnnl/FlowForecaster): 
  FlowForecaster is a tool for automatically inferring detailed and interpretable workflow scaling models from only a few (3--5) empirical task property graphs. A model represents workflow control and data flow as an abstract DAG with analytical expressions to describe how the DAG scales and how data flows along edges. Thus, with a model and proposed workflow input, FlowForecaster predicts the workflow's tasks, control, and data flow properties. 

* Dataflow Performance Matcher (DPM):
  https://github.com/candiceT233/spm
    <!-- 
    https://github.com/candiceT233/linux_resource_detect/tree/dev/perf_analysis
        https://github.com/candiceT233/linux_resource_detect/blob/dev/perf_analysis/wf_analysis.ipynb
    https://github.com/candiceT233/linux_resource_detect/tree/dev/perf_analysis/fastflow_plots
    -->

</del>

* FastFlow: https://github.com/pnnl/FastFlow  https://github.com/PerfLab-EXaCT/FastFlow <!-- [FastFlow]() -->
   When distributed scientific workflows are not intelligently executed, they can fail time constraints. To improve workflow response time, FastFlow is a new method of scheduling that prioritizes critical flow paths and their interactions. The key insight is to use the global perspective of interacting critical flows to guide a fast (locally greedy) scheduler that uses data flow projections to select between the better of flow parallelism and flow locality. The result is a rapid, linear-time scheduling method that achieves high quality results and excels on data-intensive workflows.

  
## In Progress:
  
* AutoFlowFlexer: https://github.com/PerfLab-EXaCT/AutoFlowFlexer
  
* QoSFlow: https://github.com/PerfLab-EXaCT/QoSFlow



References
-----------------------------------------------------------------------------

* H. Lee, L. Guo, M. Tang, J. Firoz, N. Tallent, A. Kougkas, and X.-H. Sun, “Data flow lifecycles for optimizing workflow coordination,” in Proc. of the Intl. Conf. for High Performance Computing, Networking, Storage and Analysis (SuperComputing), SC ’23, (New York, NY, USA), Association for Computing Machinery, November 2023. ([doi](https://doi.org/10.1145/3581784.3607104))

* M. Tang, J. Cernuda, J. Ye, L. Guo, N. R. Tallent, A. Kougkas, and X.-H. Sun, “DaYu: Optimizing distributed scientific workflows by decoding dataflow semantics and dynamics,” in Proc. of the 2024 IEEE Conf. on Cluster Computing, pp. 357–369, IEEE, September 2024. ([doi](https://doi.org/10.1109/CLUSTER59578.2024.00038))

* L. Guo, H. Lee, J. Firoz, M. Tang, and N. R. Tallent, “Improving I/O-aware workflow scheduling via data flow characterization and trade-off analysis,” in Seventh IEEE Intl. Workshop on Benchmarking, Performance Tuning and Optimization for Big Data Applications (Proc. of the IEEE Intl. Conf. on Big Data), IEEE Computer Society, December 2024.  ([doi](https://doi.org/10.1109/BigData62323.2024.10825855))

* H. Lee, J. Firoz, N. R. Tallent, L. Guo, and M. Halappanavar, “FlowForecaster: Automatically inferring detailed & interpretable workflow scaling models for forecasts,” in Proc. of the 39th IEEE Intl. Parallel and Distributed Processing Symp., IEEE Computer Society, June 2025. ([doi](https://doi.org/10.1109/IPDPS64566.2025.00045))

* J. Firoz, H. Lee, L. Guo, M. Tang, N. R. Tallent, and Z. Peng, “FastFlow: Rapid workflow response by prioritizing critical data flows and their interactions,” in Proc. of the 37th Intl. Conf. on Scalable Scientific Data Management, ACM, June 2025. ([doi](https://doi.org/10.1145/3733723.3733735))
