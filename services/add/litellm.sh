#!/bin/bash
set -e

kind export kubeconfig

echo "Installing LiteLLM on the cluster"
helm upgrade --install --wait --timeout 15m --namespace litellm --atomic --create-namespace \
  litellm oci://ghcr.io/berriai/litellm-helm --set postgresql.auth.postgres-password=$(pwgen -s 10 1),postgresql.auth.password=$(pwgen -s 10 1) --values - <<EOF
replicaCount: 1

ingress:
  enabled: true
  className: "nginx"
  hosts:
    - host: litellm.localhost
      paths:
        - path: /
          pathType: ImplementationSpecific

proxy_config:
  model_list: []
  general_settings:
    store_model_in_db: true
  litellm_settings:
    ssl_verify: false
    cache: True
    cache_params:
      type: redis

db:
  deployStandalone: true

migrationJob:
  hooks:
    argocd:
      enabled: false
    helm:
      enabled: false

postgresql:
  architecture: standalone
  auth:
    username: litellm
    database: litellm

redis:
  enabled: true
  architecture: standalone
EOF

LITELLM_PASSWORD=$(kubectl -n litellm get secret litellm-masterkey -o jsonpath="{.data.masterkey}" | base64 -d)

echo "---------------------------------------------------------------------------------"
echo "LiteLLM is running and available at http://litellm.localhost/ui"
echo "- log in with admin / $LITELLM_PASSWORD"