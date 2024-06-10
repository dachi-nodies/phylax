**Github Actions**
This will not work out of the box due to the need to input your own secrets. Use github secrets or other alternatives . 
You will need DOCKER_USERNAME, DOCKER_PASSWORD, OAUTH2_CLIENT_ID, OAUTH2_CLIENT_SECRET, OAUTH2_COOKIE_SECRET, and GCP_KEY_JSON.
Apart from OAuth2, these weren't implemented with base64 encoding in mind but can be implemented.

**K8S Manifests**

nginx-ingress-clusterrole.yaml:

    Purpose: Defines a ClusterRole, which is a set of permissions for resources in the entire cluster.
    Usage: Grants necessary permissions to the NGINX Ingress Controller to perform actions across namespaces.

nginx-ingress-clusterrolebinding.yaml:

    Purpose: Binds the ClusterRole defined in nginx-ingress-clusterrole.yaml to a ServiceAccount.
    Usage: Associates the NGINX Ingress Controller ServiceAccount with the permissions defined in the ClusterRole.

ingress-class.yaml:

    Purpose: Defines an IngressClass, which is used to specify which controller should be used to implement Ingress resources.
    Usage: Specifies that the NGINX Ingress Controller should handle Ingress resources that reference this class.

nginx-ingress-controller.yaml:

    Purpose: Deploys the NGINX Ingress Controller as a pod in the cluster.
    Usage: Ensures that the NGINX Ingress Controller is running and configured according to the provided specifications.

nginx-configmap.yaml:

    Purpose: Creates a ConfigMap containing NGINX configuration settings.
    Usage: Provides custom NGINX configuration for the Ingress Controller, such as custom error pages or SSL certificates.

nginx-deployment.yaml:

    Purpose: Defines a Deployment for NGINX.
    Usage: Manages the lifecycle of NGINX pods, ensuring the desired number of replicas are running and handling updates or scaling.

nginx-service.yaml:

    Purpose: Creates a Service for NGINX.
    Usage: Exposes the NGINX pods internally or externally, allowing other components to access NGINX.

nginx-ingress.yaml:

    Purpose: Defines an Ingress resource.
    Usage: Specifies rules for routing external HTTP traffic to specific services within the cluster, leveraging the NGINX Ingress Controller to manage this routing.

oauth2-proxy.yaml:

    Purpose: Deploys an OAuth2 proxy as a pod in the cluster.
    Usage: Handles authentication and authorization for incoming requests, typically used in conjunction with the NGINX Ingress Controller to protect web applications.
