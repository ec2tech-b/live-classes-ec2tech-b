# AWS Load Balancer Controller on EKS

This guide explains how to install and configure the AWS Load Balancer Controller on your EKS cluster, and then create an Ingress for your frontend service.

---

## Step 1: Install AWS Load Balancer Controller via Helm

### Prerequisites
- EKS cluster is up and running.
- IAM OIDC provider associated with your cluster.
- `eksctl` and `kubectl` are configured.
- Helm CLI installed locally.

---

### Install eksctl
```bash
# for ARM systems, set ARCH to: arm64, armv6 or armv7
ARCH=amd64
PLATFORM=$(uname -s)_$ARCH

curl -sLO "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_$PLATFORM.tar.gz"

# (Optional) Verify checksum
curl -sL "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_checksums.txt" | grep $PLATFORM | sha256sum --check

tar -xzf eksctl_$PLATFORM.tar.gz -C /tmp && rm eksctl_$PLATFORM.tar.gz
sudo install -m 0755 /tmp/eksctl /usr/local/bin && rm /tmp/eksctl

---

###  Enable IAM OIDC provider
eksctl utils associate-iam-oidc-provider \
  --cluster eks \
  --region us-east-1 \
  --approve
  
aws eks describe-cluster \
  --name eks \
  --region us-east-1 \
  --query "cluster.identity.oidc.issuer" \
  --output text  



Verify in IAM console → Identity Providers. You should see one with that issuer URL.

###  Configure AWS Load Balancer Controller
1. Create IAM policy
curl -o iam_policy.json \
  https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.13.3/docs/install/iam_policy.json

aws iam create-policy \
  --policy-name AWSLoadBalancerControllerIAMPolicy \
  --policy-document file://iam_policy.json

2. Create IAM role for ServiceAccount
eksctl create iamserviceaccount \
  --cluster <CLUSTER_NAME> \
  --namespace kube-system \
  --name aws-load-balancer-controller \
  --attach-policy-arn arn:aws:iam::<AWS_ACCOUNT_ID>:policy/AWSLoadBalancerControllerIAMPolicy \
  --approve


This creates the aws-load-balancer-controller ServiceAccount with IAM permissions.

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

4. Verify installation
kubectl get deployment aws-load-balancer-controller -n kube-system

Step 2: Create Ingress Resource

Once the controller is installed, you can create an Ingress that directs traffic from an ALB to the frontend service.

Example Ingress
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