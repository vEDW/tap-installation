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

cd $HOME/tanzu-cluster-essentials
IMGPKG_REGISTRY_HOSTNAME=${MY-REGISTRY} \
IMGPKG_REGISTRY_USERNAME=${MY-REGISTRY-USER} \
IMGPKG_REGISTRY_PASSWORD=${MY-REGISTRY-PASSWORD} \
imgpkg copy \
--tar ${TANZU_CLUSTER_ESSENTIALS_FILE}  \
--to-repo MY-REGISTRY/cluster-essentials-bundle \
--include-non-distributable-layers \
--registry-ca-cert-path CA_PATH

INSTALL_BUNDLE=MY-REGISTRY/cluster-essentials-bundle@sha256:0378d8592f368b28495153871c497143035747b22f398642220eb0cae596b09d \
INSTALL_REGISTRY_HOSTNAME=MY-REGISTRY \
INSTALL_REGISTRY_USERNAME=MY-REGISTRY-USER \
INSTALL_REGISTRY_PASSWORD=MY-REGISTRY-PASSWORD \
./install.sh --yes
