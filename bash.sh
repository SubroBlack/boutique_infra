#!/bin/bash
gcloud components install kubectl
apt-get update
apt-get install -y jq

if [ -d "env/$BRANCH_NAME/" ]; then
    gcloud container clusters get-credentials gke-boutique-cluster --region europe-north1 --project team-2-a
    namespaceStatus=$(kubectl get ns $BRANCH_NAME -o json | jq .status.phase -r)
    if ["$namespaceStatus" = "Active"]
        then
             echo "namespace is present"
        else
             kubectl create namespace $BRANCH_NAME
    fi;
else
    echo "***************************** SKIPPING APPLYING *******************************"
    echo "Branch '$BRANCH_NAME' does not represent an oficial environment."
    echo "*******************************************************************************"
fi;