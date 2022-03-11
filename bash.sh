#!/bin/bash
gcloud components install kubectl
myNamespace="$BRANCH_NAME"
kubectl get namespace | grep -q "^$myNamespace " || kubectl create namespace $myNamespace