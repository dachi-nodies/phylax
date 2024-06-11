![diagram](https://i.imgur.com/ty4jfkC.png)


# Prerequisites

- **Google Cloud SDK**: Ensure you have the Google Cloud SDK installed and authenticated.
- **Terraform**: Install Terraform on your local machine.
- **kubectl**: Install kubectl to manage your Kubernetes cluster.
- **Helm**: Install Helm for deploying the Nginx Ingress Controller.


# Quickstart
3. Create a project on GCP
4. Enable Kubernetes Engine Api
5. Authenticate with cloud, `gcloud auth login` : Note this is for testing, in prod you would use a service account with least access privlege. 
6. Set project id you just created `gcloud config set project`
7. Run `terraform init` followed by `terraform apply`
8. Input gcp, your project id, and region like us-central1
9. Confirm and wait for it to create the kubernetes cluster
12. Navigate to manifests folder 
13. Run `kubectl apply -f . `
14. Run` kubectl get services` and get the nginx ingress controllers external ip to access the nginx server!


# Main Components
**GKE Module**: This module is responsible for creating and configuring the Google Kubernetes Engine (GKE) cluster. It includes resources for the cluster itself and optionally a node pool if Autopilot is not enabled.
**Nginx Ingress Module**: This module deploys the Nginx Ingress Controller using Helm. It configures the controller to use a LoadBalancer service type, which provides an external IP for accessing the services in the cluster.
**Kubernetes Resources**: These include the Nginx deployment, service, and ingress resource which define how the Nginx server is deployed and exposed to external traffic.

## Rationale

# CI/CD
I would choose GitHub actions in this case since the code is being hosted on Github. Due to time constraints, I wasn't able to write the workflows. Github Actions does make it easy to get up and running with their Github-hosted runners and simple YAML syntax for defining flows. It comes with several pre-built actions from the GitHub Marketplace that make interacting with docker repositories and cloud providers a breeze.

# IAC
I chose Terraform for IaC as it uses a simplistic declarative approach that allows us to provision infrastructure with state management. Terraform can map active resources to the configuration, detect changes, and plan updates.
The modules in terraform allow me to encapsulate configurations into reusable components allowing for cloud agnostic status. No vendor lock in with services like Cloudformation. Although the repo currently only truly supports GCP due to time constraints, the configurations were written with modularity in mind. It can easily be extended to other cloud providers and I've commented out some rough implementations in the main.tf file in the terraform folder.
Terraform is currently being used to provision the K8S Cluster and Ingress Controller. The manifests will automatically be applied through Github Actions as this allows for seperation of concerns where Terraform is the IaC and application configuration is managed by seperate scripts. (Also manifests in terraform is quite heinous to manage).

# K8S + resources
Despite Nomad being more geared towards simple and small use cases like this, most DevOps engineers, cloud architects, and developers are familiar with Kubernetes. By choosing Kubernetes, I can leverage the existing knowledge and skills of the common engineer which will reduce  learning curve and increase productivity. Apart from that, theres strong community support, a rich ecosystem that has cloud native integrations, and is generally future proofed.

**Deployment**: The deployment creates and manages a set of Nginx pods. It ensures the desired number of pods are running, handles updates, and scales the number of pods as needed.

**Service**: The service exposes the Nginx pods created by the deployment. It provides a stable network endpoint to access the Nginx pods, regardless of their lifecycle.Other pods within the cluster can access the Nginx service using its name.

**Ingress Controller**: The ingress controller manages external HTTP/HTTPS access to the services within the cluster. The ingress resource defines routing rules, directing external traffic to the appropriate services.When traffic hits the ingress controller, it checks the rules defined in the ingress resources and routes the traffic to the specified service

# Auth
Although I was not able to implement auth due to time constraints, I would've chosen Oauth2. It is a industry standard protocol with a huge community and great documentation. It has some great security based features such as limited scope access and short term stateless token based auth.
The general approach for implementation would be registering the application with GCP,Okta,etc. Next we would need a OAuth proxy,  this will intercept incoming requests to the application, redirect unauthenticated users to the OAuth 2.0 provider, and validate tokens for authenticated requests. 
We would need the Oauth secret credentials which would be base64 encoded and then used in the OAuth Proxy Deployment. This would then be exposed via a OAuth Proxy Service and then the Ingress Controller would be configured to route traffic through it. This would all be accomplishable through manifests and performed by GitHub actions.


# Addressing Requirements
** Containerization: Get the container, as described in the Phylax docs. **


This wasn't available so I just used a nginx image. It is defined in the K8S Deployment.


** Resource Isolation: Each container should have resource limits (CPU, memory, etc.) enforced to prevent overconsumption and ensure fair resource sharing. **


This is accomplished in the Deployment specification. To break it down the 'requests' section are the minimum resources required by the container. Kubernetes uses these values to schedule the pod onto a node that has at least this amount of resources available.
The 'limits' section defines  the maximum resources that the container is allowed to use. If the container tries to use more than these amounts, it will be throttled (for CPU) or terminated (for memory).


** Network Isolation: Containers should be isolated from each other and the host network. Each container should be accessible only via its API endpoint. **


This is accomplished through K8S Namespaces and network policies. Namespaces provide a mechanism for isolating resources within a cluster. It can be used to seperate cluster resources between multiple users or teams.
Network policies are used to control the traffic flow between pods within a Kubernetes cluster. They can be configured to allow or deny traffic to and from certain pods based on labels, namespaces, and other criteria.


** API Access: Implement a mechanism to securely expose each container's API endpoint to the respective user. Users should be able to access their container's API using a pre-provisioned unique API token (bearer) that you can expect them to get trough some auth2 service that we use for autorisation/authentication. **
The ingress controller can be used to only allow requests coming from specific hosts and can be defined granularly as to which path(s). In terms of token based auth, i touched on this in the AUTH section above.


** Internet Access: Containers should have internet access to allow for external communication if required by the application. **


While ingress controller controls access to the service, network policies are used for egress traffic from the pods.


** Cloud Agnostic: The deployment should be cloud-agnostic and leverage Infrastructure as Code (IaC) principles to ensure consistent and repeatable deployments across different cloud providers or on-premises environments. **


The terraformation files I made were built with cloud-agnostic in mind. I wrote it very extensibly and  commented out large chunks of code that with a little bit more work can be used to implement other cloud providers. The variables file and modularity of Terraform allow for this.


** Documentation: Provide comprehensive documentation explaining the design decisions, deployment process, and any relevant configuration or usage instructions. **


I've definitely written before documentation but I believe this is sufficient for a takehome interview project. Please let me know if I can explain more and I'm sure we will have a call to discuss.


** Env Variables: The system should allow for per-container environment variables that should be available inside the container. **


Terraform and Helm can be utilized for templating manifests allowiong for configuration specific provisioning and configuration. Many ways to skin this cat.
