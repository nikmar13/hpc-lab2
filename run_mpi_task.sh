#!/bin/bash                                                                                                                                                                                                      
                                                                                                                                                                                                                 
echo -n > statistics.log                                                                                                                                                                                         
                                                                                                                                                                                                                 
for i in {1..100}; do                                                                                                                                                                                              
    # Вибір випадкового вузла з доступних
    NODELIST=$(pbsnodes -l free | awk '{print $1}')
    NODES=($(echo $NODELIST | tr '\n' ' '))
    RANDOM_NODE1=${NODES[$RANDOM % ${#NODES[@]}]}
    RANDOM_NODE2=${NODES[$RANDOM % ${#NODES[@]}]}
    
    # Переконайтеся, що вузли різні
    while [ "$RANDOM_NODE1" == "$RANDOM_NODE2" ]; do
        RANDOM_NODE2=${NODES[$RANDOM % ${#NODES[@]}]}
    done

    # Подання завдання у чергу PBS з вказаними вузлами
    job_id=$(qsub -l nodes=${RANDOM_NODE1}:ppn=2+${RANDOM_NODE2}:ppn=2 mpi_task.pbs)
    echo "Submitted job $job_id on nodes $RANDOM_NODE1 and $RANDOM_NODE2"                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
                                                                                                                                               
    while true; do                                                                                                                                                                                               
        if qstat | grep -q "$job_id"; then                                                                                                                                                                       
            sleep 5                                                                                                                                                                                              
        else                                                                                                                                                                                                     
            break                                                                                                                                                                                                
        fi                                                                                                                                                                                                       
    done                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         
done                                                                                                                                                                                                             
                                                                                                                                                                                                                                                                                                                                                                                                
echo "Final node process statistics:"                                                                                                                                                                            
cat statistics.log
