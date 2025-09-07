show databases;
show tables;


helm install myapp ./3-tier-app --create-namespace --namespace app-2

helm upgrade myapp ./3-tier-app -n app-2

helm uninstall myapp -n app-2
kubectl delete ns app-2
