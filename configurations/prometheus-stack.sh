#!/bin/sh
set -ex


helm repo add stable https://kubernetes-charts.storage.googleapis.com/
helm install prometheus-operator stable/prometheus-operator
#
helm repo add jenkinsci https://charts.jenkins.io
kubectl create namespace jenkins
helm install jenkins jenkinsci/jenkins --namespace jenkins
kubectl -n jenkins create -f quay-secret.yaml
#
kubectl get deployments,pods -n jenkins
#
kubectl get services -n jenkins

