#!/bin/bash
gcloud components install kubectl
if [ $BRANCH_NAME = wahid ]; then
    gcloud container clusters get-credentials infra-test --region us-west1 --project test-project-ws-342013
    namespaceStatus=$(kubectl get ns $BRANCH_NAME -o json | jq .status.phase -r)
    if [ "$namespaceStatus"=="Active" ]
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