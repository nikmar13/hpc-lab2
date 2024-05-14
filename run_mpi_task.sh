#!/bin/bash

# Початкова статистика
echo -n > statistics.log

# Створення файлу stagein_statistics для початкової задачі
cp statistics.log stagein_statistics

for i in {1..100}; do
    # Оновлення файлу stagein_statistics перед кожним завданням
    cp statistics.log stagein_statistics

    # Подання завдання у чергу PBS
    job_id=$(qsub mpi_task.pbs)

    # Очікування завершення завдання (перевірка кожні 5 секунд)
    while true; do
        if qstat | grep -q "$job_id"; then
            sleep 5
        else
            break
        fi
    done

    # Оновлення файлу statistics.log після завершення завдання
    cp stagein_statistics statistics.log
done

# Підсумковий вивід статистики
echo "Final node process statistics:"
cat statistics.log
