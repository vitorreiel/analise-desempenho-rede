#!/bin/bash

# Inicia a execução dos Containers
chmod 777 polinux/main.sh
./polinux/main.sh
chmod 777 app/main.sh
./app/main.sh

# Pega o status de execução dos PODs
status_polinux=""
status_app=""
while [ "$status_polinux" != "Running" ] && [ "$status_app" != "Running" ]; do
  sleep 5
  status_polinux=$(docker service ps polinux | grep polinux | awk 'NR==1 {print $5}')
  status_app=$(docker service ps app | grep app | awk 'NR==1 {print $5}')
done

# Captura e armazena os dados relevantes para a analise de desempenho da máquina
id=21
execution_count=1
start_time=$(date +%s)
polinux=$(docker service ls | grep polinux | awk 'NR==1 {print $4}')
app=$(docker service ls | grep app | awk 'NR==1 {print $4}')
while [ $execution_count -le 20 ]; do
  current_time=$(date +%s)
  elapsed_time=$((current_time - start_time))
  cpu_usage=$(top -b -n 1 | grep "Cpu(s)" | awk '{print int($2)}')
  mem_usage=$(free -m | awk '/Mem/{print $3}')
  mem_free=$(free -m | awk '/Mem/{print $4}')
  echo "$id,$execution_count,$elapsed_time,$cpu_usage,$mem_usage,$mem_free,DockerSwarm,$polinux,$app,t2.large" >> cpu_usage_report.txt
  execution_count=$((execution_count + 1))
  id=$((id + 1))
  sleep 5
done

# Deletando o cenário
docker service rm app
docker service rm polinux
