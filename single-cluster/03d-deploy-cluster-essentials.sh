#!/bin/bash

# 03-deploy-cluster-essentials.sh
#
# This script is only required for non-TKGm clusters (AKS, EKS, GKE, etc.). For vSphere /w Tanzu v7 it's also required to 
# install Cluster Essentials. vSphere /w Tanzu v8 TKG clusters have cluster essentials available out-of-the-box, so you can skip this step.
#
# Run this script in the context of the Kubernetes cluster you're planning to install TAP on.
# Use 'kubectl config set-context <kubernetes context>' to switch to correct cluster prior to running this script.
#
# Download Cluster Essentials from Tanzu Network at https://network.tanzu.vmware.com/
#
# For Linux:
# - Change download file to tanzu-cluster-essentials-linux-amd64-1.3.0.tgz
# 
source 00-set-environment-variables.sh  

ClusterEssentialsVersion=$(jq -r '."tap-versions"[] | select (."tap-version" == "'${TAP_VERSION}'") | ."cluster-essentials-bundle"' tanzu_versions.json)
echo " ClusterEssentialsVersion : ${ClusterEssentialsVersion}"

ClusterEssentialsSHA=$(jq -r '."tap-versions"[] | select (."tap-version" == "'${TAP_VERSION}'") | ."cluster-essentials-sha"' tanzu_versions.json)
echo "ClusterEssentialsSHA : ${ClusterEssentialsSHA}"

kubectx ${K8S_CONTEXT}

kubectl get pods
export k8s_check=$?

cd $HOME/tanzu-cluster-essentials
if [ ! -e install.sh ]; then
    echo "tanzu clusteressntials cli not present. download and uncompress tanzu-cluster-essentials-linux-amd64-<version>.tgz"
    exit 1
fi

if [ $k8s_check -eq 0 ]; then
    echo "Installing Cluster Essentials on ${K8S_CONTEXT}."
    export INSTALL_BUNDLE=${MY_REGISTRY}/${MY_REGISTRY_BUNDLE_PROJECT}/${ClusterEssentialsSHA}
    export INSTALL_REGISTRY_HOSTNAME=${MY_REGISTRY}
    export INSTALL_REGISTRY_USERNAME=${MY_REGISTRY_USER}
    export INSTALL_REGISTRY_PASSWORD=${MY_REGISTRY_PASSWORD}

    ./install.sh --yes
else
    echo ""
    echo "problem getting response from ${K8S_CONTEXT}"
    echo "check your k8s context and cluster"
fi

openssl s_client -showcerts -connect ${MY_REGISTRY}:443 </dev/null |  sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' > ${MY_REGISTRY}.pem

cat ${MY_REGISTRY_CA_PATH} > harbor.certs
cat ${MY_REGISTRY}.pem >> harbor.certs

kubectl create secret generic kapp-controller-config \
    --namespace kapp-controller \
    --from-file caCerts=harbor.certs

kubectl delete -n kapp-controller pod $(kubectl get po -n kapp-controller | grep kapp- | awk '{print $1}' ) 
