#!/bin/bash
#

helm delete my-postgres-operator
kubectl delete ns postgresql-operator
kubectl delete crd $(k get crd | grep postgres | awk '{print $1}')
