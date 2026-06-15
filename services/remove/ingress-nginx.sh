#!/bin/bash

kind export kubeconfig

echo "Deleting nginx-ingress"
kubectl delete -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.12.5/deploy/static/provider/kind/deploy.yaml

echo "The nginx-ingress was removed from your cluster"