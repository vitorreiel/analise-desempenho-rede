#!/bin/bash

docker service create --name polinux --replicas 6 polinux/stress:latest stress --cpu 1 --vm 1 --vm-bytes 256M --vm-hang 1
