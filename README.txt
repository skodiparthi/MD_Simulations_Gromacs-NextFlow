
# GROMACS Molecular Dynamics Pipeline with Nextflow

## Overview

This repository contains a molecular dynamics (MD) simulation pipeline using GROMACS and Nextflow. It automates the process of running energy minimization, equilibration (NVT, NPT), and production MD simulations.

## Requirements

- **GROMACS**: Install GROMACS (2020 or later) for molecular dynamics simulations.
- **Nextflow**: Install Nextflow for orchestrating the pipeline.

## Installation

1. Install [GROMACS](http://www.gromacs.org/Downloads).
2. Install [Nextflow](https://www.nextflow.io/docs/latest/getstarted.html).

## Inputs
Place your molecular structure (`structure.gro`), topology (`topology.top`), and simulation parameters (`md.mdp`) in the represented files before running the pipeline.


To clone this repository:

```bash
git clone https://github.com/skodiparthi/gromacs-nextflow-pipeline.git
cd gromacs-nextflow-pipeline
```

## Usage

To run the pipeline:

```bash
nextflow run main.nf --structure data/structure.gro --topology data/topology.top --mdp data/md.mdp
```

## Outputs

- **Energy Minimization**: `em.gro`, `em.log`
- **NVT Equilibration**: `nvt.gro`, `nvt.log`
- **NPT Equilibration**: `npt.gro`, `npt.log`
- **Production MD**: `md.xtc`, `md.gro`, `md.log`

## License

This project is licensed under the MIT License - see the LICENSE file for details.
