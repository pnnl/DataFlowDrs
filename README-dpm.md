
- Repos
  - Widget: https://github.com/candiceT233/widget-v1
  - Orchestrator (Hasan fork): https://github.com/candiceT233/agentic-workflow-orchestrator
  - DPM: https://github.com/candiceT233/dpm

- DPM status
  - DPM repo (old)
    - Corresponds to the version in paper
    - Training (Storage resource profiler): exhaustive
    - Build Workflow DAG: unnecessary repretition
      
  - Widget repo (new DPM)
    - DPM Training: adaptive/data-efficient (80% fewer benchmarks)
    - DPM Build Workflow DAG: eliminates duplication (performance optimization). _Much faster_
    - DPM regression algorithms: interpolation and random forest. Currently prefer interpolation
    - DPM API/interaction (widget)
      - MCP API, agent friendly
      - Automates plots (data lifecycle, storage resource analysis plots)
      - Output is more organized, dictionary output
    - [ ] DaYu is integrated but no end-to-end test yet
      - HDF5 datalifecycles plots

- Plans
  - [ ] READMEs/HOWTos. A list of topics + dictation is better than crafted text
  - [ ] Experiment validation data to =/qfs/projects/oddite/dpm=
    - Compress for achiving
    - label Training data so we can deprecate
  - [ ] SRA Search
  - [ ] DaYu integration
  - [ ] Integrate with Hasan agentic-reasoning
  - [ ] Add Jesun, Nathan to agentic-reasoning repo
  - [ ] Where to look for DPM in context of background traffic


- NEW (forgot to ask)
  - [ ] What is the status of DPM for direct data flow vs. data flow with intermediate copy? Example: the last stage of 1KG where intermediate file + copy is much faster than direct data flow to parallel storage.
