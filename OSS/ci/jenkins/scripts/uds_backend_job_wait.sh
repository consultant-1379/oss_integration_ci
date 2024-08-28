#!/bin/bash
KUBECONFIG=$2
NAMESPACE=$1
TIME=$3
JOB=$4

echo Waiting 30 minutes for the UDS backend job to finish.
kubectl wait --for=condition=complete --timeout=$TIME job/$JOB --namespace $NAMESPACE --kubeconfig $KUBECONFIG
