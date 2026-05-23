<!-- -*-Mode: markdown;-*- -->
<!-- $Id$ -->

<!-- 
  New: &#x1F195; 
  ★ ✅ ⚠️ ℹ️
-->

DataFlowDrs
=============================================================================

**Home**:
  - [DataFlowDrs](https://github.com/pnnl/DataFlowDrs): https://github.com/pnnl/DataFlowDrs

  - [Performance Lab for EXtreme Computing and daTa](https://github.com/PerfLab-EXaCT)


**About**: 

Scientific workflows  are critical in many areas of scientific exploration. Because these workflows tend to be data intensive, severe bottlenecks emerge in storage systems and I/O networks. We introduce DataFlowDrs, a new comprehensive suite of tools for performance optimization of HPC workflows that especially focuses on data flow and storage. DataFlowDrs introduces (a) lightweight high-resolution measurement and visualization tools for workflow profiling and tracing; (b) rapid modeling and analysis that reduces analysis data by compressing common repeated coordination patterns; (c) novel methods for predicting data flow scaling using automatically generated interpretable models of data flow; (d) effective performance analysis and bottleneck detection that can automatically quantify and rank bottlenecks for different combinations of task parallelism and storage resources; (e) actionable performance optimization in the form of new schedules and resource assignments. DataFlowDrs automates several previously difficult manual analyses and substantially reduces the impact of data flow bottlenecks by recommending the right tradeoffs between task parallelism and storage performance.


**DataFlowDrs Tools**: 

![DataFlowDrs overview](/dataflowdr-overview.png)

DataFlowDrs provides tools for measuring, visualizing, analyzing, modeling, ranking, and resolving dataflow bottlenecks. Its capabilities include lightweight high-resolution measurement; intuitive and interactive visualization; automated modeling methods for reasoning about workflow DAGs and data flows; bottleneck analysis and performance prediction to identify and rank bottlenecks; and rescheduling to select the better of better of flow parallelism and flow locality.

The *measurement* (1), which operates on unmodified workflows, is scalable, with lightweight but high-resolution profiles and traces of dataflow between tasks. The resulting data flow lifecycles (DFL) guide bottleneck analysis and coordination of task and data flows on distributed resources. DFLs even expose the relationship between data semantics and dataflow when using descriptive data formats such as HDF5.

The *visualization and analysis* (2) enable an analyst to quickly and interactively reason about dataflow and potential bottlenecks. To focus attention, flow analysis isolates critical flows and their interactions; and associates flow metrics with producer-consumer patterns.

The performance *modeling* (3) predicts data flow bottlenecks using automatically generated models of data flow, inferred from only 3--5 workflow executions. The models are interpretable in that they typically are composed entirely of analytical expressions. Companion *ranking* models (4) quantify the bottleneck severity of producer-consumer relations for different combinations of task parallelism and storage resources.

Finally, *bottleneck ranking and resolution* (5) presents actionable performance optimization in the form of new schedules and resource assignments. The resulting schedules find the right tradeoffs between task parallelism and storage performance and that can substantially reduce the impact of data flow bottlenecks.


Components
-----------------------------------------------------------------------------

* [DataLife](https://github.com/pnnl/DataLife):
  The combination of ever-growing scientific datasets and distributed workflow complexity creates I/O performance bottlenecks due to data volume, velocity, and variety. DataLife is a measurement and analysis toolset for distributed scientific workflows comprised of tasks that interact using files and storage. DataLife performs data flow lifecycle (DFL) analysis to guide decisions regarding coordinating task and data flows on distributed resources. DataLife provides tools for measuring, analyzing, visualizing, and estimating the severity of flow bottlenecks based on I/O and storage.

  <!-- https://github.com/candiceT233/datalife -->


* [DaYu](https://github.com/pnnl/DaYu):
  The increasing use of descriptive data formats (e.g., HDF5, netCDF) helps organize scientific datasets, but it also creates obscure bottlenecks due to the need to translate high level operations into file addresses and then into low-level I/O operations. DaYu is a method and toolset for analyzing (a) semantic relationships between logical datasets and file addresses, (b) how dataset operations translate into I/O, and (c) the combination across entire workflows. DaYu's analysis and visualization enables identification of critical bottlenecks and reasoning about remediation. With DaYu, one can extract workflow data patterns, develop insights into the behavior of data flows, and identify opportunities for both users and I/O libraries to optimize the applications.

  <!-- https://github.com/candiceT233/dayu-tracker -->


* Dataflow Performance Matcher (DPM) and Storage Resource Explorer: [DPM](https://github.com/candiceT233/dpm):

  <!-- https://github.com/candiceT233/dpm -->
  <!-- https://github.com/candiceT233/linux_resource_detect -->
  <!-- 
    https://github.com/candiceT233/linux_resource_detect/tree/dev/perf_analysis
    https://github.com/candiceT233/linux_resource_detect/blob/dev/perf_analysis/wf_analysis.ipynb
    https://github.com/candiceT233/linux_resource_detect/tree/dev/perf_analysis/fastflow_plots
  -->


* [FlowForecaster](https://github.com/pnnl/FlowForecaster):
  FlowForecaster is a tool for automatically inferring detailed and interpretable workflow scaling models from only a few (3--5) empirical task property graphs. A model represents workflow control and data flow as an abstract DAG with analytical expressions to describe how the DAG scales and how data flows along edges. Thus, with a model and proposed workflow input, FlowForecaster predicts the workflow's tasks, control, and data flow properties. 


* [FastFlow](https://github.com/pnnl/FastFlow)
   When distributed scientific workflows are not intelligently executed, they can fail time constraints. To improve workflow response time, FastFlow is a new method of scheduling that prioritizes critical flow paths and their interactions. The key insight is to use the global perspective of interacting critical flows to guide a fast (locally greedy) scheduler that uses data flow projections to select between the better of flow parallelism and flow locality. The result is a rapid, linear-time scheduling method that achieves high quality results and excels on data-intensive workflows.


* [QoSFlow](https://github.com/pnnl/QoSFlow) 🆕 **New**!
  To enable Quality of Service scheduling constraints (e.g., minimize time, limit execution to resource subsets) for scientific workflows, QoSFlow uses rapid reasoning over the large configuration space that is driven by predictive models rather than costly executions. QoSFlow partitions a workflow's execution configuration space into regions with similar behavior. Each region groups configurations with comparable execution times according to a given statistical sensitivity, enabling efficient QoS-driven scheduling through analytical reasoning rather than exhaustive testing.
  
  <!-- https://github.com/PerfLab-EXaCT/QoSFlow -->


* Sample [Workflows](https://gitlab.com/PerfLab-EXaCT/workflows)

  With prototype [agentic interface](https://github.com/candiceT233/hpc_workflows).



## In Progress:
  
* [AutoFlowFlexer](https://github.com/PerfLab-EXaCT/AutoFlowFlexer)


Getting Started
-----------------------------------------------------------------------------

See [README-Install.md](./README-Install.md) 


Contacts
-----------------------------------------------------------------------------

**Contacts**: (_firstname_._lastname_@pnnl.gov)
  - Nathan R. Tallent ([www](https://nathantallent.github.io))
  - Lenny Guo ([www](https://www.pnnl.gov/people/luanzheng-guo))
  - Jesun Firoz ([www](https://www.pnnl.gov/people/jesun-firoz))


**Contributors**:
  - Zhen Peng ([www](https://johnpzh.github.io))
  - Jesun Firoz ([www](https://www.pnnl.gov/people/jesun-firoz))
  - Lenny Guo ([www](https://www.pnnl.gov/people/luanzheng-guo))
  - Meng Tang (Illinois Institute of Technology) ([www](https://scholar.google.com/citations?user=KXC9NesAAAAJ&hl=en))
  - Nathan R. Tallent ([www](https://nathantallent.github.io))


References
-----------------------------------------------------------------------------

* Hyungro Lee, Luanzheng Guo, Meng Tang, Jesun Firoz, Nathan Tallent, Anthony Kougkas, and Xian-He Sun. "Data Flow Lifecycles for Optimizing Workflow Coordination." Proc. of the Intl. Conf. for High Performance Computing, Networking, Storage and Analysis (SuperComputing), SC '23, Association for Computing Machinery, November 2023. ([doi: 10.1145/3581784.3607104](https://doi.org/10.1145/3581784.3607104))

* Meng Tang, Jaime Cernuda, Jie Ye, Luanzheng Guo, Nathan R. Tallent, Anthony Kougkas, and Xian-He Sun. "DaYu: Optimizing Distributed Scientific Workflows by Decoding Dataflow Semantics and Dynamics." Proc. of the 2024 IEEE Conf. on Cluster Computing, CLUSTER '24, pp. 357-369, IEEE, September 2024. ([doi: 10.1109/CLUSTER59578.2024.00038](https://doi.org/10.1109/CLUSTER59578.2024.00038))

* Luanzheng Guo, Meng Tang, Hyungro Lee, Jesun Firoz, and Nathan R. Tallent. "Improving I/O-aware Workflow Scheduling via Data Flow Characterization and Trade-off Analysis" Seventh IEEE Intl. Workshop on Benchmarking, Performance Tuning and Optimization for Big Data Applications (Proc. of the IEEE Intl. Conf. on Big Data), Big Data Workshops '24, pp. 3674-3681, IEEE Computer Society, December 2024. ([doi: 10.1109/BigData62323.2024.10825855](https://doi.org/10.1109/BigData62323.2024.10825855))

* Hyungro Lee, Jesun Firoz, Nathan R. Tallent, Luanzheng Guo, and Mahantesh Halappanavar. "FlowForecaster: Automatically Inferring Detailed & Interpretable Workflow Scaling Models for Forecasts." Proc. of the 39th IEEE Intl. Parallel and Distributed Processing Symp., IPDPS '25, pp. 420-432, IEEE Computer Society, June 2025. ([doi: 10.1109/IPDPS64566.2025.00045](https://doi.org/10.1109/IPDPS64566.2025.00045))

* Jesun Firoz, Hyungro Lee, Luanzheng Guo, Meng Tang, Nathan R. Tallent, and Zhen Peng. "FastFlow: Rapid Workflow Response by Prioritizing Critical Data Flows and their Interactions." Proc. of the 37th Intl. Conf. on Scalable Scientific Data Management, SSDBM '25, pp. 1-12, ACM, June 2025. ([doi: 10.1145/3733723.3733735](https://doi.org/10.1145/3733723.3733735))

* Meng Tang, Zhaobin Zhu, Luanzheng Guo, James G. Bandy, Tim Carlson, Sarah Neuwirth, Anthony Kougkas, Xian-He Sun, and Nathan R. Tallent. "Quantifying AWS S3 I/O Performance Boundaries Using the Roofline Model." Proc. of the SC '25 Workshops of the Intl. Conf. for High Performance Computing, Networking, Storage and Analysis (10th Intl Parallel Data Systems Workshop), SC Workshops '25, pp. 1415-1423, Association for Computing Machinery, November 202. ([doi: 10.1145/3731599.3767513](https://doi.org/10.1145/3731599.3767513))

* Meng Tang, Luanzheng Guo, Anthony Kougkas, Xian-He Sun, and Nathan R. Tallent. "Characterizing Dataflow for I/O-Aware Scheduling in HPC Workflows." Proc. of the 40th IEEE Intl. Parallel and Distributed Processing Symp., IPDPS '26, pp. 868-884, IEEE Computer Society, May 2026. ([doi: 10.1109/IPDPS65963.2026.00076](https://doi.org/10.1109/IPDPS65963.2026.00076))

* Md Hasanur Rashid, Jesun Firoz, Nathan R. Tallent, Luanzheng Guo, Meng Tang, and Dong Dai. "QoSFlow: Ensuring Service Quality of Distributed Workflows Using Interpretable Sensitivity Models." Proc. of the 40th IEEE Intl. Parallel and Distributed Processing Symp., IPDPS '26, pp. 1372-1387, IEEE Computer Society, May 2026. ([doi: 10.1109/IPDPS65963.2026.00112](https://doi.org/10.1109/IPDPS65963.2026.00112))


## Related
  
* C. Egersdoerfer, M. H. Rashid, D. Dai, B. Fang, and N. R. Tallent, “Understanding and predicting cross-application I/O interference in HPC storage systems,” in Proc. of the Workshops of the Intl. Conf. for High Performance Computing, Networking, Storage and Analysis (9th Intl. Parallel Data Systems Workshop), Nov. 2024. ([doi: 10.1109/SCW63240.2024.00174](https://doi.org/10.1109/SCW63240.2024.00174))

* Md Hasanur Rashid, Nathan R. Tallent, Forrest Sheng Bao, and Dong Dai. "CARAT: Client-Side Adaptive RPC and Cache Co-Tuning for Parallel File Systems." Proc. of the 40th IEEE Intl. Parallel and Distributed Processing Symp., IPDPS '26, pp. 1343-1357, IEEE Computer Society, May 2026. ([doi: 10.1109/IPDPS65963.2026.00110](https://doi.org/10.1109/IPDPS65963.2026.00110))
