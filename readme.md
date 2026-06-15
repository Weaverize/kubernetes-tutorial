# Kubernetes local testing
This project contains the scripts to create a local sandbox environment on your machine using Kind (Kubernetes In Docker).

# Installing tools

# kubectl
Check https://kubernetes.io/fr/docs/tasks/tools/install-kubectl/ for official websites.

Here is a quick way to download and setup kubectl:

On Linux:
```bash
curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
chmod +x kubectl
sudo mv kubectl /usr/local/bin/
```

On Windows:
Kubectl is already installed as part of the Google Cloud SDK.

# kind
Check https://github.com/kubernetes-sigs/kind/releases for newest release.

Here is a quick way to download and setup kind:

On Linux:
```bash
wget https://github.com/kubernetes-sigs/kind/releases/download/v0.30.0/kind-linux-amd64
chmod +x kind-linux-amd64
sudo mv kind-linux-amd64 /usr/local/bin/kind
kind completion bash |sudo tee /etc/bash_completion.d/kind
echo "restart terminal to have auto-completion on kind command"
```

On Windows:
```bash
curl.exe -LO "https://kind.sigs.k8s.io/dl/v0.30.0/kind-windows-amd64"
chmod +x kind-windows-amd64
mv kind-windows-amd64 ~/bin/kind
kind --version
```

# Start
To run a local kubernetes cluster run the `./create-cluster.sh`

This cluster comes ready with:
- 3 nodes (1 control plane, 2 worker)
- nginx-ingress exposed on port 80 and 443

Check with `kubectl get nodes` that the local kind cluster is used.
If not, you might have to specify which kubernetes config file to use: `export KUBECONFIG="$HOME/.kube/config"`

# Game example
To test the local cluster you just created, you can deploy a demo project:

The following command creates a "game" namespace and deploy a deployment, a service and an ingress in it
```bash
kubectl apply -f game/
```

The demo deployment is available in your web-browser http://game.localhost

To tear down the demo:
```bash
kubectl delete -f game/
```

# Delete Cluster
To delete your cluster (**ALL CLUSTER DATA WILL BE LOST !**): `./delete-cluster.sh`

# Data

## user-data
The data you put in this folder is available in each node and can be mounted in the various pod using hostPath.

This was implemented using the following tutorial: https://mauilion.dev/posts/kind-pvc-localdata

## shared-data
Contains the persisted data of your cluster from the Persistent Volumes.

Persisted data cannot be re-used as of now. Here are the steps to be able to restore previous data in a new cluster: https://mauilion.dev/posts/kind-pvc
