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
    INSTALL_BUNDLE=${MY-REGISTRY}/${MY_REGISTRY_BUNDLE_PROJECT}/${ClusterEssentialsSHA} \
    IMGPKG_REGISTRY_HOSTNAME=${MY-REGISTRY} \
    IMGPKG_REGISTRY_USERNAME=${MY-REGISTRY-USER} \
    IMGPKG_REGISTRY_PASSWORD=${MY-REGISTRY-PASSWORD} \
    ./install.sh --yes
else
    echo ""
    echo "problem getting response from ${K8S_CONTEXT}"
    echo "check your k8s context and cluster"
fi
