#!/bin/bash

declare -A node_process_count

parse_log_file() {
    local file=$1
    while read -r line; do
        if [[ $line == Hello\ world\ from\ processor* ]]; then
            node=$(echo $line | awk '{print $5}' | cut -d'.' -f1)
            if [[ -n $node ]]; then
                node_process_count[$node]=$((node_process_count[$node]+1))
            fi
        fi
    done < "$file"
}

for file in mpi_output.log-*; do
    if [[ -f $file ]]; then
        parse_log_file "$file"
    fi
done

echo "Node process statistics:"
for node in "${!node_process_count[@]}"; do
    echo "$node: ${node_process_count[$node]} processes"
done
