#!/bin/bash


source 00-set-environment-variables.sh  

HARBOR_USERNAME=${MY_REGISTRY_USER}
HARBOR_PASSWORD=${MY_REGISTRY_PASSWORD}
HARBOR_URL=${MY_REGISTRY}

cd $HOME/download
cd $(ls -d */ |grep post)

kubectx ${K8S_CONTEXT}

kubectl create ns postgresql-operator

kubectl create secret docker-registry regsecret \
    --docker-server=${HARBOR_URL} \
    --docker-username=${HARBOR_USERNAME} \
    --docker-password="${HARBOR_PASSWORD}" \
    --namespace postgresql-operator

yq e  operator/postgre-values.yaml

helm install my-postgres-operator operator/  --wait --debug

