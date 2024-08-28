#!/bin/bash
HELM="/usr/share/helm/3.x/helm"

NAMESPACE=$1
INT_CHART_VERSION=$2
SNAPSHOT_INT_CHART_VERSION=$3
KUBE_CONFIG=$4

echo "INT_CHART_VERSION:" ${INT_CHART_VERSION}
echo "SNAPSHOT_INT_CHART_VERSION:" ${SNAPSHOT_INT_CHART_VERSION}
echo "NAMESPACE:" ${NAMESPACE}
echo "KUBE_CONFIG:" ${KUBE_CONFIG}

if (${HELM} list --namespace ${NAMESPACE} --kubeconfig ${KUBE_CONFIG} --output yaml | grep -i deployed); then
    # Get the main part of the version eric-eo-1.10.0-2-ha3015ca --> 1.10.0
    SHORT_SNAPSHOT_INT_CHART_VERSION=$( echo ${SNAPSHOT_INT_CHART_VERSION} | sed -e 's/eric-eo-//' -e 's/-.*//' )
    DEPLOYED_VERSION=$(${HELM} list --namespace ${NAMESPACE} --kubeconfig ${KUBE_CONFIG} --output yaml | grep -i chart | sed 's/[^0-9.-]//g' | sed -r 's/-+//')
    echo "DEPLOYED_VERSION=${DEPLOYED_VERSION}"
    # Check if the same version is already deployed
    if [[ "${INT_CHART_VERSION}" == "${DEPLOYED_VERSION}" || "${DEPLOYED_VERSION}" == *"${SHORT_SNAPSHOT_INT_CHART_VERSION}"* ]]; then
      echo "*** Versions are consistent - No deployment required"
      echo "SKIP_DELETION=true" >> artifact.properties;
    else
      echo "*** Versions are different - New Deployment is required"
      echo "SKIP_DELETION=false" >> artifact.properties;
    fi
else
    echo "SKIP_DELETION=false" >> artifact.properties;
fi
