#!/bin/bash

docker service create --name app --replicas 1 -p 3000:3000 vitorreiel/vuejs-node
