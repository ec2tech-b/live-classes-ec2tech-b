
## Install CLoud Nginx Ingress Controller

kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.12.0-beta.0/deploy/static/provider/cloud/deploy.yaml

## Check the NGINX Ingress controller has been assigned a public IP address

kubectl get service ingress-nginx-controller --namespace=ingress-nginx

## If you get this error of Ingress Validation 
 # Error : Warning: path /(.*) cannot be used with pathType Prefix
    Error from server (BadRequest): error when creating "ingress-nginx-controller-ex.yaml": admission webhook "validate.nginx.ingress.kubernetes.io" denied the request: ingress contains invalid paths: path /hello-world-one(/|$)(.*) cannot be used with pathType Prefix
    path /hello-world-two(/|$)(.*) cannot be used with pathType Prefix
    path /(.*) cannot be used with pathType Prefix

 # Solution : kubectl delete -A ValidatingWebhookConfiguration ingress-nginx-admission    