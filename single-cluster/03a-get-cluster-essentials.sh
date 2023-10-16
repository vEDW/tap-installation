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

if [[ ! -e $HOME/tanzu-cluster-essentials ]]; then
  mkdir $HOME/tanzu-cluster-essentials
fi

ClusterEssentialsVersion=$(jq -r '."tap-versions"[] | select (."tap-version" == "'${TAP_VERSION}'") | ."cluster-essentials-bundle"' tanzu_versions.json)
echo " ClusterEssentialsVersion : ${ClusterEssentialsVersion}"

ClusterEssentialsSHA=$(jq -r '."tap-versions"[] | select (."tap-version" == "'${TAP_VERSION}'") | ."cluster-essentials-sha"' tanzu_versions.json)
echo "ClusterEssentialsSHA : ${ClusterEssentialsSHA}"

if [[ "${ClusterEssentialsSHA}" != "" ]] || [[ "${ClusterEssentialsSHA}" != "" ]];
then
  cd $HOME/tanzu-cluster-essentials
  echo "start imgpkg copy"
  IMGPKG_REGISTRY_HOSTNAME=registry.tanzu.vmware.com \
  IMGPKG_REGISTRY_USERNAME=${TANZU_NET_USER} \
  IMGPKG_REGISTRY_PASSWORD=${TANZU_NET_PASSWORD} \
  imgpkg copy \
    -b registry.tanzu.vmware.com/tanzu-cluster-essentials/${ClusterEssentialsSHA} \
    --to-tar cluster-essentials-bundle-${ClusterEssentialsVersion}.tar \
    --include-non-distributable-layers
else 
  echo "one or more versions variable is empty"
fi
