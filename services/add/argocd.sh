#!/bin/bash
set -

kind export kubeconfig

helm upgrade --install --wait --timeout 15m --atomic --namespace argocd --create-namespace \
  --repo https://argoproj.github.io/argo-helm argocd argo-cd --values - <<EOF
crds:
  install: true
  keep: true

configs:
  cm:
    exec.enabled: "true"
    accounts.gitlab: apiKey, login
  params:
    server.insecure: "true"

server:
  global:
    domain: argocd.localhost
  ingress:
    enabled: true
    ingressClassName: nginx
    hostname: argocd.localhost
  rbacConfig:
    policy.csv: |
      p, gitlab, applications, *, *, allow
      p, gitlab, applications, delete, *, deny
EOF

ARGOCD_PASSWORD=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)

echo "---------------------------------------------------------------------------------"
echo "ArgoCD is running and available at http://argocd.localhost/"
echo "- log in with admin / $ARGOCD_PASSWORD"