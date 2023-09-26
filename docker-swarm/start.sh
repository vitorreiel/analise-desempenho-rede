#!/bin/bash

# Inicia a execução dos PODs
minikube kubectl -- apply -f polinux/main.yaml
minikube kubectl -- apply -f app/main.yaml

# Pega o status de execução dos PODs
status_polinux=""
status_app=""
while [ "$status_polinux" != "Running" ] && [ "$status_app" != "Running" ]; do
  sleep 5
  status_polinux=$(minikube kubectl -- get pods | grep polinux-pod | awk 'NR==1 {print $3}')
  status_app=$(minikube kubectl -- get pods | grep app-pod | awk 'NR==1 {print $3}')
done

# Captura e armazena os dados relevantes para a analise de desempenho da máquina
execution_count=1
start_time=$(date +%s)
polinux=$(minikube kubectl -- get pods | grep polinux-pod | awk 'NR==1 {print $2}')
app=$(minikube kubectl -- get pods | grep app-pod | awk 'NR==1 {print $2}')
while [ $execution_count -le 10 ]; do
  current_time=$(date +%s)
  elapsed_time=$((current_time - start_time))
  cpu_usage=$(top -b -n 1 | grep "Cpu(s)" | awk '{print $2}')
  echo "$execution_count Tempo: $elapsed_time CPU: $cpu_usage $polinux $app Kubernetes t2.large" >> cpu_usage_report.txt
  execution_count=$((execution_count + 1))
  sleep 5
done

# Deletando o cenário
minikube kubectl -- delete pod polinux-pod
minikube kubectl -- delete pod app-pod
