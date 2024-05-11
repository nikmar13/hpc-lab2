#!/bin/bash

#PBS -l nodes=2:ppn=2
#PBS -N mpi_statistic
#PBS -o mpi_output.log
#PBS -e mpi_error.log
#PBS -W stagein=hello@$PBS_O_WORKDIR:./hello
#PBS -W stageout=/tmp/statistics.txt@$PBS_O_HOST:$PBS_O_WORKDIR/statistics.txt
cd $PBS_O_WORKDIR

mpirun -np 4 ./hello

node1_processes=$(ps -ef | grep "your_mpi_program" | grep "node1" | wc -l)
node2_processes=$(ps -ef | grep "your_mpi_program" | grep "node2" | wc -l)

echo "Node1: $node1_processes processes, Node2: $node2_processes processes" > statistics.txt


exit 0
