#!/bin/sh
# Customize --time and --partition as appropriate.
# --exclusive --mem=0 allocates all CPUs and memory on the node.
#SBATCH --partition=holy-cow,holy-smokes,holy-info,shared
#SBATCH --nodes=1
#SBATCH --mem=0
#SBATCH --exclusive
#SBATCH --time=6-23:00:00

#MAKER_IMAGE=/n/singularity_images/informatics/maker/maker:2.31.11-repbase.sif
MAKER_IMAGE=/n/singularity_images/informatics/maker/maker:3.01.03-repbase.sif

# Submit this job script from the directory with the MAKER control files

# RepeatMasker setup (if not using RepeatMasker, optionally comment-out these three lines)
export SINGULARITYENV_LIBDIR=${PWD}/LIBDIR
mkdir -p LIBDIR
singularity exec ${MAKER_IMAGE} sh -c 'ln -sf /usr/local/share/RepeatMasker/Libraries/* LIBDIR'

# singularity options:
# * --cleanenv : don't pass environment variables to container (except those specified in --env option-arguments)
# * --no-home : don't mount home directory (if not current working directory) to avoid any application/language startup files
# Add any MAKER options after the "maker" command
# * -nodatastore is suggested for Lustre, as it reduces the number of directories created
# * -fix_nucleotides needed for hsap_contig.fasta example data
singularity exec --home /root --no-home --cleanenv ${MAKER_IMAGE} mpiexec -n $((SLURM_CPUS_ON_NODE*3/4)) maker -fix_nucleotides -nodatastore
