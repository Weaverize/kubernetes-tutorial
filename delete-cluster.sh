#!/bin/bash

set -e

cluster=$(kind get clusters)
if [ "$cluster" == 'kind' ]
then
    kind delete cluster
	echo "Kind cluster removed, run ./clear-shared-data.sh if you want to delete the cluster's internal data"
else
    echo "kind cluster not found. Run 'kind export kubeconfig' if kind is running."
fi