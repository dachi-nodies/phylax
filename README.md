
WIP 

Quickstart
1. Download gcloud cli
2. Download terraform
3. Create a project on GCP
4. Enable Kubernetes Engine Api
5. Authenticate with cloud, i.e. gcloud auth login
6. Set project id you just created gcloud config set project
7. Run terraform init followed by terraform apply
8. Input gcp, your project id, and region like us-central1
9. Confirm and wait for it to create the kubernetes cluster
12. Navigate to manifests folder and apply all manifest with kubectl apply -f file.yaml .. order doesn’t matter.
13. Run kubectl apply -f . 
14. Run kubectl get services and get the nginx ingress controllers external ip to access the nginx server!
