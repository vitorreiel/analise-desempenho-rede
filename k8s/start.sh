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
id=1
execution_count=1
start_time=$(date +%s)
polinux=$(minikube kubectl -- get pods | grep polinux-pod | awk 'NR==1 {print $2}')
app=$(minikube kubectl -- get pods | grep app-pod | awk 'NR==1 {print $2}')
echo "id,execucao,tempo_execucao,uso_cpu,uso_mem,livre_mem,orquestrador,pods_stress,pods_aplicacao,tipo_vm">> cpu_mem_usage_report.txt
while [ $execution_count -le 20 ]; do
  current_time=$(date +%s)
  elapsed_time=$((current_time - start_time))
  cpu_usage=$(top -b -n 1 | grep "Cpu(s)" | awk '{print int($2)}')
  mem_usage=$(free -m | awk '/Mem/{print $3}')
  mem_free=$(free -m | awk '/Mem/{print $4}')
  echo "$id,$execution_count,$elapsed_time,$cpu_usage,$mem_usage,$mem_free,Kubernetes,$polinux,$app,t2.large" >> cpu_mem_usage_report.txt
  execution_count=$((execution_count + 1))
  id=$((id + 1))
  sleep 5
done

# Deletando o cenário
minikube kubectl -- delete pod polinux-pod
minikube kubectl -- delete pod app-pod
