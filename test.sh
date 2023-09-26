#!/bin/bash

execution_count=0
start_time=$(date +%s)
polinux=$(k get pods | grep polinux-pod | awk 'NR==1 {print $2}')
while [ $execution_count -le 10 ]; do
  current_time=$(date +%s)
  elapsed_time=$((current_time - start_time))
  cpu_usage=$(top -b -n 1 | grep "Cpu(s)" | awk '{print $2}')
  echo "$execution_count, Tempo: $elapsed_time segundos, Uso de CPU: $cpu_usage%, Pod polinux: $polinux" >> cpu_usage_report.txt
  execution_count=$((execution_count + 1))
  sleep 5
done