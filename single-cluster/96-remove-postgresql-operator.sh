#!/bin/bash
#

helm delete my-postgres-operator
kubectl delete ns postgresql-operator
kubectl delete crd $(kubectl get crd | grep postgres | awk '{print $1}')
