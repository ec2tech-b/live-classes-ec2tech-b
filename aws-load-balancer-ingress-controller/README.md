AWS Load Balancer Controller Setup on EKS

This guide walks you through installing and configuring the AWS Load Balancer Controller on your EKS cluster, and deploying an Ingress resource for your frontend service.

🚀 Prerequisites

An EKS cluster is up and running.

IAM OIDC provider associated with your cluster.

eksctl and kubectl installed and configured.

Helm CLI installed locally.

AWS CLI configured with credentials.

Step 1: Install eksctl

Download and install the latest eksctl:

# For ARM systems, set ARCH to: arm64, armv6, or armv7
ARCH=amd64
PLATFORM=$(uname -s)_$ARCH

curl -sLO "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_$PLATFORM.tar.gz"

# (Optional) Verify checksum
curl -sL "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_checksums.txt" | grep $PLATFORM | sha256sum --check

tar -xzf eksctl_$PLATFORM.tar.gz -C /tmp && rm eksctl_$PLATFORM.tar.gz
sudo install -m 0755 /tmp/eksctl /usr/local/bin && rm /tmp/eksctl

Step 2: Enable IAM OIDC Provider

Associate your cluster with an IAM OIDC provider:

eksctl utils associate-iam-oidc-provider \
  --cluster eks \
  --region us-east-1 \
  --approve


Verify:

aws eks describe-cluster \
  --name eks \
  --region us-east-1 \
  --query "cluster.identity.oidc.issuer" \
  --output text


👉 In the IAM console → Identity Providers, you should now see an entry with that OIDC issuer.

Step 3: Configure AWS Load Balancer Controller
1. Create IAM Policy
curl -o iam_policy.json \
  https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.13.3/docs/install/iam_policy.json

aws iam create-policy \
  --policy-name AWSLoadBalancerControllerIAMPolicy \
  --policy-document file://iam_policy.json

2. Create IAM Role for ServiceAccount
eksctl create iamserviceaccount \
  --cluster eks \
  --namespace kube-system \
  --name aws-load-balancer-controller \
  --attach-policy-arn arn:aws:iam::<AWS_ACCOUNT_ID>:policy/AWSLoadBalancerControllerIAMPolicy \
  --approve


This creates the aws-load-balancer-controller ServiceAccount annotated with the correct IAM role.

3. Install via Helm
helm repo add eks https://aws.github.io/eks-charts
helm repo update

helm upgrade --install aws-load-balancer-controller eks/aws-load-balancer-controller \
  -n kube-system \
  --set clusterName=eks \
  --set serviceAccount.create=false \
  --set serviceAccount.name=aws-load-balancer-controller \
  --set region=<your-region> \
  --set vpcId=<your-vpc-id>

4. Verify Installation
kubectl get deployment aws-load-balancer-controller -n kube-system

Step 4: Deploy Ingress Resource

Once the controller is installed, create an Ingress to expose your frontend service.

ingress.yaml

apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: frontend-ingress
  namespace: app-2
  annotations:
    alb.ingress.kubernetes.io/scheme: internet-facing
    alb.ingress.kubernetes.io/target-type: ip
    alb.ingress.kubernetes.io/listen-ports: '[{"HTTP":80}]'
spec:
  ingressClassName: alb
  rules:
    - http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: frontend
                port:
                  number: 80


Apply it:

kubectl apply -f ingress.yaml

🔎 How It Works

AWS Load Balancer Controller provisions an ALB (internet-facing).

The ALB routes HTTP traffic on / to the frontend service.

The frontend service forwards requests to its pod endpoints.

✅ Your EKS cluster now has a fully functional AWS Load Balancer Controller with an Ingress exposing your frontend application.