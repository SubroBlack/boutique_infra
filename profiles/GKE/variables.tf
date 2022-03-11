variable "cluster_name" {
  type = string
  description = "Name of the gke cluster"
}
variable "region" {
  type = string
  description = "Name of the cluster region"
}
variable "project_1" {
  type = string
  description = "id of the project for deployment"
}

variable "project_2" {
  type = string
  description = "id of the project for deployment"
}

variable "peer_name_1" {
  description = "Name of the first peer"
  type = string
}

variable "peer_name_2" {
  description = "Name of the second peer"
  type = string
}


variable "zone" {
  description = "network zone"
  type = string
}



/* if [ -d "env/$BRANCH_NAME/" ]; then
    gcloud container clusters get-credentials gke-boutique-cluster --region europe-north1 --project team-2-a
    namespaceStatus=$(kubectl get ns $BRANCH_NAME )
    if [ $namespaceStatus == "Active" ]
        then
             echo "namespace is present"
        else
             kubectl create namespace $BRANCH_NAME
    fi;
else
    echo "***************************** SKIPPING APPLYING *******************************"
    echo "Branch '$BRANCH_NAME' does not represent an oficial environment."
    echo "*******************************************************************************"
fi; */