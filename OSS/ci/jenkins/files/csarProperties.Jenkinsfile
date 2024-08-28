#!/usr/bin/env groovy
/* IMPORTANT:
 *
 * In order to make this pipeline work, the following configuration on Jenkins is required:
 * - slave with a specific label (see pipeline.agent.label below)
 */

pipeline {
    agent {
        label env.SLAVE_LABEL
    }
    options {
        timestamps()
    }
    parameters {
        string(name: 'INT_CHART_VERSION',
               description: 'Version of Base Chart Version that will be used for the CSARS Version')
        string(name: 'CSAR_STORAGE_INSTANCE',
               defaultValue: 'arm.seli.gic.ericsson.se',
               description: 'Instance that the CSARs are deployed to.')
        string(name: 'CSAR_STORAGE_REPO',
               defaultValue: 'proj-eric-oss-drop-generic-local',
               description: 'Repo that the CSARs are stored in.')
        string(name: 'SLAVE_LABEL',
                defaultValue: 'evo_docker_engine',
                description: 'Specify the slave label that you want the job to run on')
    }
    stages {
        stage('Generate CSAR Properties') {
            steps {
                sh '''
                    NEXUS_PATH="https://${CSAR_STORAGE_INSTANCE}/artifactory/${CSAR_STORAGE_REPO}/eric-oss"
                    echo "BASE_CHART_VERSION=${INT_CHART_VERSION}" > artifact.properties
                    echo "SO_CSAR=${NEXUS_PATH}/eric-oss-so/${INT_CHART_VERSION}/eric-eo-so-${INT_CHART_VERSION}.csar" >> artifact.properties
                    echo "PF_CSAR=${NEXUS_PATH}/eric-oss-pf/${INT_CHART_VERSION}/eric-oss-pf-${INT_CHART_VERSION}.csar" >> artifact.properties
                    echo "UDS_CSAR=${NEXUS_PATH}/eric-oss-uds/${INT_CHART_VERSION}/eric-oss-uds-${INT_CHART_VERSION}.csar" >> artifact.properties
                '''
            }
        }
        stage('Archiving artifact.properties') {
            steps {
                script {
                    archiveArtifacts 'artifact.properties'
                 }
            }
        }
    }
}
