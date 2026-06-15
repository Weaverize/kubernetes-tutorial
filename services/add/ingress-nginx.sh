#!/bin/bash
set -e

kind export kubeconfig

echo "Deploying nginx-ingress"
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.12.5/deploy/static/provider/kind/deploy.yaml

echo "Waiting for ingress to be ready (this can be long)"
kubectl wait --namespace ingress-nginx --for=condition=ready pod --selector=app.kubernetes.io/component=controller --timeout=300s

echo "Your cluster is available at http://localhost, it should display a 404 error"