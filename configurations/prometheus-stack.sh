#!/bin/sh
set -ex

# These steps follow the readme here: https://github.com/coreos/prometheus-operator/tree/master/helm
# With RBAC disabled
#helm repo add coreos https://s3-eu-west-1.amazonaws.com/coreos-charts/stable/

#https://github.com/hitokiri-mata/helm-charts/tree/main/charts
#helm repo add coreos https://charts.bitnami.com/bitnami
#helm repo add coreos https://kubernetes-charts.storage.googleapis.com/
#helm repo add coreos http://kubernetes-charts.banzaicloud.com/branch/master

#helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add stable https://kubernetes-charts.storage.googleapis.com/
#helm repo update
#helm install stable/prometheus --set name=prom -f k8s-values.yml
helm install prometheus-operator stable/prometheus-operator
helm install kube-prometheus stable/kube-prometheus --wait

#helm  install prometheus-community/kube-prometheus
#helm upgrade --install --namespace monitoring --set rbacEnable=false prometheus-operator helm/prometheus-operator  
#helm upgrade --install --namespace monitoring --set rbacEnable=false kube-prometheus coreos/kube-prometheus --wait

kubectl patch service kube-prometheus               --type='json' -p='[{"op": "replace",  "path": "/spec/type", "value":"NodePort"}]'
kubectl patch service kube-prometheus-alertmanager  --type='json' -p='[{"op": "replace",  "path": "/spec/type", "value":"NodePort"}]'
kubectl patch service kube-prometheus-grafana       --type='json' -p='[{"op": "replace",  "path": "/spec/type", "value":"NodePort"}]'

minikube service list -n monitoring
