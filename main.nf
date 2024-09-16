
#!/usr/bin/env nextflow

/*
 * Molecular Dynamics Simulation Pipeline with GROMACS and Nextflow
 * This pipeline performs:
 *   1. Energy Minimization
 *   2. NVT Equilibration
 *   3. NPT Equilibration
 *   4. Production MD
 */

params.structure = params.structure ?: error("Missing --structure parameter")
params.topology  = params.topology  ?: error("Missing --topology parameter")
params.mdp       = params.mdp       ?: error("Missing --mdp parameter")

/* 
 * Process: Energy Minimization 
 * - Prepares the system for simulation by minimizing energy
 */
process energyMinimization {
    
    input:
    path params.structure, path params.topology, path params.mdp

    output:
    path "em.gro", path "em.log"

    script:
    '''
    gmx grompp -f ${params.mdp} -c ${params.structure} -p ${params.topology} -o em.tpr
    gmx mdrun -deffnm em
    '''
}

/* 
 * Process: NVT Equilibration 
 * - Stabilizes the system's temperature with constant volume and temperature 
 */
process equilibrationNVT {
    
    input:
    path "em.gro", path params.topology, path params.mdp

    output:
    path "nvt.gro", path "nvt.log"

    script:
    '''
    gmx grompp -f ${params.mdp} -c em.gro -p ${params.topology} -o nvt.tpr
    gmx mdrun -deffnm nvt
    '''
}

/* 
 * Process: NPT Equilibration 
 * - Stabilizes the system's pressure and density with constant pressure and temperature 
 */
process equilibrationNPT {
    
    input:
    path "nvt.gro", path params.topology, path params.mdp

    output:
    path "npt.gro", path "npt.log"

    script:
    '''
    gmx grompp -f ${params.mdp} -c nvt.gro -p ${params.topology} -o npt.tpr
    gmx mdrun -deffnm npt
    '''
}

/* 
 * Process: Production MD 
 * - Main molecular dynamics simulation 
 */
process productionMD {
    
    input:
    path "npt.gro", path params.topology, path params.mdp

    output:
    path "md.xtc", path "md.log", path "md.gro"

    script:
    '''
    gmx grompp -f ${params.mdp} -c npt.gro -p ${params.topology} -o md.tpr
    gmx mdrun -deffnm md
    '''
}

/* 
 * Workflow Execution 
 * Defines the order in which processes will run 
 */
workflow {
    energyMinimization()
    equilibrationNVT()
    equilibrationNPT()
    productionMD()
}
