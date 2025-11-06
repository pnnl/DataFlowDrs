<!-- -*-Mode: markdown;-*- -->
<!-- $Id$ -->


DataFlowDrs
=============================================================================

**About**: 

Scientific workflows  are critical in many areas of scientific exploration. Because these workflows tend to be data intensive, severe bottlenecks emerge in storage systems and I/O networks. We introduce DataFlowDrs, a new comprehensive suite of tools for performance optimization of HPC workflows that especially focuses on data flow and storage. DataFlowDrs introduces (a) lightweight high-resolution measurement and visualization tools for workflow profiling and tracing; (b) rapid modeling and analysis that reduces analysis data by compressing common repeated coordination patterns; (c) novel methods for predicting data flow scaling using automatically generated interpretable models of data flow; (d) effective performance analysis and bottleneck detection that can automatically quantify and rank bottlenecks for different combinations of task parallelism and storage resources; (e) actionable performance optimization in the form of new schedules and resource assignments. DataFlowDrs automates several previously difficult manual analyses and substantially reduces the impact of data flow bottlenecks by recommending the right tradeoffs between task parallelism and storage performance.


**DataFlowDrs Tools**: 

![DataFlowDrs overview](/dataflowdr-overview.png)

DataFlowDrs provides tools for measuring, visualizing, analyzing, modeling, ranking, and resolving dataflow bottlenecks. Its capabilities include lightweight high-resolution measurement; intuitive and interactive visualization; automated modeling methods for reasoning about workflow DAGs and data flows; bottleneck analysis and performance prediction to identify and rank bottlenecks; and rescheduling to select the better of better of flow parallelism and flow locality.

The *measurement* (1), which operates on unmodified workflows, is scalable, with lightweight but high-resolution profiles and traces of dataflow between tasks. The resulting data flow lifecycles (DFL) guide bottleneck analysis and coordination of task and data flows on distributed resources. DFLs even expose the relationship between data semantics and dataflow when using descriptive data formats such as HDF5.

The *visualization and analysis* (2) enable an analyst to quickly and interactively reason about dataflow and potential bottlenecks. To focus attention, flow analysis isolates critical flows and their interactions; and associates flow metrics with producer-consumer patterns.

The performance *modeling* (3) predicts data flow bottlenecks using automatically generated models of data flow, inferred from only 3--5 workflow executions. The models are interpretable in that they typically are composed entirely of analytical expressions. Companion *ranking* models (4) quantify the bottleneck severity of producer-consumer relations for different combinations of task parallelism and storage resources.

Finally, *bottleneck ranking and resolution* (5) presents actionable performance optimization in the form of new schedules and resource assignments. The resulting schedules find the right tradeoffs between task parallelism and storage performance and that can substantially reduce the impact of data flow bottlenecks.



TODO
-----------------------------------------------------------------------------

## [DataFlowDrs](https://gitlab.com/perflab-exact/bigflow-suite): Performance analysis and scheduling for distributed scientific workflows

<!-- https://github.com/perflab-exact -->


* Storage resource explorer: 
    https://github.com/candiceT233/linux_resource_detect
    
* [DataLife](https://github.com/pnnl/datalife):
  https://github.com/candiceT233/datalife
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

* FastFlow: https://github.com/PerfLab-EXaCT/FastFlow <!-- [FastFlow]() https://github.com/pnnl/FastFlow -->
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

