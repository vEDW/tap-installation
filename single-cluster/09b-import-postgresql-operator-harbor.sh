#!/bin/bash


source 00-set-environment-variables.sh  

REGISTRY_CA_PATH=${MY_REGISTRY_CA_PATH}
HARBOR_USERNAME=${MY_REGISTRY_USER}
HARBOR_PASSWORD=${MY_REGISTRY_PASSWORD}
HARBOR_URL=${MY_REGISTRY}
HARBOR_TAP_REPO=${MY_REGISTRY_INSTALL_REPO}

curl -u "${HARBOR_USERNAME}:${HARBOR_PASSWORD}" -X POST -H "content-type: application/json" "https://${HARBOR_URL}/api/v2.0/projects" -d "{\"project_name\": \"postgresql\", \"public\": true, \"storage_limit\": -1 }" -k

cd $HOME/download
tar -zxf postgres-for-kubernetes*.gz
cd $(ls -d */ |grep post)

docker load -i ./images/postgres-instance
docker load -i ./images/postgres-operator
docker images "postgres-*"

echo "Login in to registry '$MY_REGISTRY'"
docker login $MY_REGISTRY --username $MY_REGISTRY_USER --password $MY_REGISTRY_PASSWORD


INSTANCE_IMAGE_NAME="${MY_REGISTRY}/postgresql/postgres-instance:$(cat ./images/postgres-instance-tag)"
docker tag $(cat ./images/postgres-instance-id) ${INSTANCE_IMAGE_NAME}
docker push ${INSTANCE_IMAGE_NAME}

OPERATOR_IMAGE_NAME="${MY_REGISTRY}/postgresql/postgres-operator:$(cat ./images/postgres-operator-tag)"
docker tag $(cat ./images/postgres-operator-id) ${OPERATOR_IMAGE_NAME}
docker push ${OPERATOR_IMAGE_NAME}

params=$OPERATOR_IMAGE_NAME yq e '.operatorImage = strenv(params)' operator/values.yaml > tmpfile && mv tmpfile operator/postgre-values.yaml
params=$INSTANCE_IMAGE_NAME yq e '.postgresImage = strenv(params)' operator/postgre-values.yaml > tmpfile && mv tmpfile operator/postgre-values.yaml
yq e  operator/postgre-values.yaml
