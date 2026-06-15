#!/bin/bash
set -e
unset KUBECONFIG #to ensure the current file are not overwritten by kind
kind create cluster --config - <<EOF
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: worker
  extraMounts:
  - hostPath: ./volumes/user-data/
    containerPath: /data
  - hostPath: ./volumes/shared-data/
    containerPath: /var/local-path-provisioner
- role: worker
  extraMounts:
  - hostPath: ./volumes/user-data/
    containerPath: /data
  - hostPath: ./volumes/shared-data/
    containerPath: /var/local-path-provisioner
- role: control-plane
  extraMounts:
  - hostPath: ./volumes/user-data/
    containerPath: /data
  - hostPath: ./volumes/shared-data/
    containerPath: /var/local-path-provisioner
  kubeadmConfigPatches:
  - |
    kind: InitConfiguration
    nodeRegistration:
      kubeletExtraArgs:
        node-labels: "ingress-ready=true"
  extraPortMappings:
  - containerPort: 80 #30080 # For Gateway Fabric
    hostPort: 80
    listenAddress: "0.0.0.0"
  - containerPort: 443 #30443 # For Gateway Fabric
    hostPort: 43
    listenAddress: "0.0.0.0"
EOF

echo "cluster is ready, use './delete-cluster.sh' to delete it (all data will be lost)"
