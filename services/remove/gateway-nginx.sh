#!/bin/bash
kind export kubeconfig

echo "Deleteting the http gateway on port 80"
kubectl delete gateway -n nginx-gateway nginx-gateway
echo ""

echo "Uninstalling nginx Gateway Fabric"
helm uninstall --namespace nginx-gateway nginx-gateway 
echo ""

echo "Uninstalling nginx Gateway Fabric CRDs"
kubectl delete -f https://raw.githubusercontent.com/nginx/nginx-gateway-fabric/refs/heads/main/deploy/crds.yaml
echo ""

echo "Uninstalling Gateway API CRDs"
kubectl delete -f https://github.com/kubernetes-sigs/gateway-api/releases/download/v1.4.0/standard-install.yaml
echo ""