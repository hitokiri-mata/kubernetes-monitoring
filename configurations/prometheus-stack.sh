#!/bin/sh
set -ex

# These steps follow the readme here: https://github.com/coreos/prometheus-operator/tree/master/helm
# With RBAC disabled
#helm repo add coreos https://s3-eu-west-1.amazonaws.com/coreos-charts/stable/

#https://github.com/hitokiri-mata/helm-charts/tree/main/charts
#helm repo add coreos https://charts.bitnami.com/bitnami

helm repo add coreos http://kubernetes-charts.banzaicloud.com/branch/master
helm install --devel --namespace=monitoring kube-prometheus coreos/kube-prometheus
#helm upgrade --install --namespace monitoring --set rbacEnable=false prometheus-operator helm/prometheus-operator  
#helm upgrade --install --namespace monitoring --set rbacEnable=false kube-prometheus coreos/kube-prometheus --wait

kubectl patch service kube-prometheus              --namespace=monitoring --type='json' -p='[{"op": "replace",  "path": "/spec/type", "value":"NodePort"}]'
kubectl patch service kube-prometheus-alertmanager --namespace=monitoring --type='json' -p='[{"op": "replace",  "path": "/spec/type", "value":"NodePort"}]'
kubectl patch service kube-prometheus-grafana      --namespace=monitoring --type='json' -p='[{"op": "replace",  "path": "/spec/type", "value":"NodePort"}]'

minikube service list -n monitoring
