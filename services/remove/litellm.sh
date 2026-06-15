#!/bin/bash
set -e

kind export kubeconfig

helm uninstall --wait --timeout 15m --namespace litellm litellm