#!/bin/bash
set -e

kind export kubeconfig

echo "Installing Gateway API CRDs"
kubectl apply -f https://github.com/kubernetes-sigs/gateway-api/releases/download/v1.4.0/standard-install.yaml
echo ""

echo "Installing nginx Gateway Fabric CRDs"
kubectl apply --server-side -f https://raw.githubusercontent.com/nginx/nginx-gateway-fabric/refs/heads/main/deploy/crds.yaml
echo ""

echo "Installing nginx Gateway Fabric"
helm upgrade --install nginx-gateway oci://ghcr.io/nginx/charts/nginx-gateway-fabric --namespace nginx-gateway --create-namespace --wait --values - <<EOF
nginx:
  service:
    type: NodePort
  pod:
    nodeSelector:
      kubernetes.io/hostname: kind-control-plane
    tolerations:
      - key: "node-role.kubernetes.io/control-plane"
        operator: "Exists"
        effect: "NoSchedule"
nginxGateway:
  nodeSelector:
    kubernetes.io/hostname: kind-control-plane
  tolerations:
    - key: "node-role.kubernetes.io/control-plane"
      operator: "Exists"
      effect: "NoSchedule"
gateways:
  - name: nginx-gateway
    namespace: nginx-gateway
    spec:
      gatewayClassName: nginx
      listeners:
      - name: http
        protocol: HTTP
        port: 80
        allowedRoutes:
          namespaces:
            from: All
      - name: https
        protocol: TLS
        port: 443
        allowedRoutes:
          namespaces:
            from: All
        tls:
          mode: Terminate
          certificateRefs:
          - kind: Secret
            name: gateway-tls
            namespace: certificate
EOF
echo ""

echo "Forcing internal ports to 30080 and 30443"
kubectl patch svc nginx-gateway-nginx -n nginx-gateway --type=json -p='[
  {"op": "replace", "path": "/spec/ports/0/nodePort", "value": 30080}
]'
kubectl patch svc nginx-gateway-nginx -n nginx-gateway --type=json -p='[
  {"op": "replace", "path": "/spec/ports/1/nodePort", "value": 30443}
]'
echo ""

echo "NGINX Gateway Fabric should now be answering on port 80 and 443 of your machine"