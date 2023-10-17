#!/bin/bash

# 03-deploy-cluster-essentials.sh
#
 
source 00-set-environment-variables.sh  

REGISTRY_CA_PATH=${MY_REGISTRY_CA_PATH}
HARBOR_USERNAME=${MY_REGISTRY_USER}
HARBOR_PASSWORD=${MY_REGISTRY_PASSWORD}
HARBOR_URL=${MY_REGISTRY}
HARBOR_TAP_REPO=${MY_REGISTRY_INSTALL_REPO}

echo "start importing files...."
cp $REGISTRY_CA_PATH /etc/ssl/certs/tap-ca.crt
curl -u "${HARBOR_USERNAME}:${HARBOR_PASSWORD}" -X POST -H "content-type: application/json" "https://${HARBOR_URL}/api/v2.0/projects" -d "{\"project_name\": \"${HARBOR_TAP_REPO}\", \"public\": true, \"storage_limit\": -1 }" -k
curl -u "${HARBOR_USERNAME}:${HARBOR_PASSWORD}" -X POST -H "content-type: application/json" "https://${HARBOR_URL}/api/v2.0/projects" -d "{\"project_name\": \"tap-packages\", \"public\": true, \"storage_limit\": -1 }" -k
curl -u "${HARBOR_USERNAME}:${HARBOR_PASSWORD}" -X POST -H "content-type: application/json" "https://${HARBOR_URL}/api/v2.0/projects" -d "{\"project_name\": \"${MY_REGISTRY_BUNDLE_PROJECT}\", \"public\": true, \"storage_limit\": -1 }" -k

#curl -u "${HARBOR_USERNAME}:${HARBOR_PASSWORD}" -X POST -H "content-type: application/json" "https://${HARBOR_URL}/api/v2.0/projects" -d "{\"project_name\": \"bitnami\", \"public\": true, \"storage_limit\": -1 }" -k
#curl -u "${HARBOR_USERNAME}:${HARBOR_PASSWORD}" -X POST -H "content-type: application/json" "https://${HARBOR_URL}/api/v2.0/projects" -d "{\"project_name\": \"tools\", \"public\": true, \"storage_limit\": -1 }" -k
#curl -u "${HARBOR_USERNAME}:${HARBOR_PASSWORD}" -X POST -H "content-type: application/json" "https://${HARBOR_URL}/api/v2.0/projects" -d "{\"project_name\": \"tap-lsp\", \"public\": true, \"storage_limit\": -1 }" -k
#curl -u "${HARBOR_USERNAME}:${HARBOR_PASSWORD}" -X POST -H "content-type: application/json" "https://${HARBOR_URL}/api/v2.0/users" -d '{"comment": "push-user", "username": "push-user", "password": "VMware1!", "email": "push-user@vmware.com", "realname": "push-user"}' -k
#curl -u "${HARBOR_USERNAME}:${HARBOR_PASSWORD}" -X POST -H "content-type: application/json" "https://${HARBOR_URL}/api/v2.0/users" -d '{"comment": "pull-user", "username": "pull-user", "password": "VMware1!", "email": "pull-user@vmware.com", "realname": "pull-user"}' -k
#export push_user_id=$(curl -u "${HARBOR_USERNAME}:${HARBOR_PASSWORD}" -X GET -H "content-type: application/json" "https://${HARBOR_URL}/api/v2.0/users/search?page=1&page_size=10&username=push-user" -k |jq '.[].user_id')
#export pull_user_id=$(curl -u "${HARBOR_USERNAME}:${HARBOR_PASSWORD}" -X GET -H "content-type: application/json" "https://${HARBOR_URL}/api/v2.0/users/search?page=1&page_size=10&username=pull-user" -k |jq '.[].user_id')
#curl -u "${HARBOR_USERNAME}:${HARBOR_PASSWORD}" -X POST -H "content-type: application/json" "https://${HARBOR_URL}/api/v2.0/projects/tap-lsp/members" -d "{\"role_id\": 2, \"member_user\": { \"username\": \"push-user\", \"user_id\": ${push_user_id} }}" -k
#curl -u "${HARBOR_USERNAME}:${HARBOR_PASSWORD}" -X POST -H "content-type: application/json" "https://${HARBOR_URL}/api/v2.0/projects/tap-lsp/members" -d "{\"role_id\": 3, \"member_user\": { \"username\": \"pull-user\", \"user_id\": ${pull_user_id} }}" -k
