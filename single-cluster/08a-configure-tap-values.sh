#!/bin/bash

source ./00-set-environment-variables.sh  

# fct

process_yq(){
    KEY="${1}"
    ENV_VAR="${2}"
    echo "${KEY}"
    echo "${ENV_VAR}"
    DATA=$(yq eval ${KEY} ./tap-values.yaml)
    echo "current value : ${DATA}"
    if [ "${ENV_VAR}" == "" ];
    then
        read -p "Enter ${KEY} [${DATA}]: " yqvalue
    else
        read -p "Enter ${KEY} [${ENV_VAR}]: " yqvalue
    fi
    YQCMD="${KEY} |= strenv(yqvalue) | ..style=\"double\""
    #echo "${YQCMD}"
    yqvalue=${yqvalue:-${DATA}} yq  -i "${YQCMD}" ./tap-values.yaml
    DATA=$(yq eval ${KEY} ./tap-values.yaml)
    echo "ack : ${DATA}"
    echo
}

process_yq_cacerts(){
    KEY="${1}"
    CACRTFILE="./local-ca.crt"
    IFS= read -rd '' output < <(cat $CACRTFILE)
    output=$output yq e '.shared.ca_cert_data = strenv(output)' tap-values.yaml > tmpfile && mv tmpfile tap-values.yaml
}

# code

yq eval '.' ./tap-values.yaml
export yaml_check=$?

if [ $yaml_check -eq 0 ]; then
    echo "Valid yaml structure for: tap-values.yaml."
    echo "Reviewing values based on existing data"
else
    echo ""
    echo "Invalid yaml structure for: values.yaml . Check values.yaml"
    echo "creating a new one"
    cp ./tap-values-full-profile-doc.yaml ./tap-values.yaml
fi

echo

process_yq ".shared.ingress_domain"
process_yq ".shared.image_registry.project_path" "${MY_REGISTRY}/${MY_REGISTRY_INSTALL_REPO}"
process_yq ".shared.image_registry.secret.name"

process_yq ".buildservice.kp_default_repository" "${MY_REGISTRY}/${MY_REGISTRY_INSTALL_REPO}/tbs-full-deps"

process_yq ".ootb_supply_chain_basic.registry.server" "${MY_REGISTRY}"

yq e ./tap-values.yaml