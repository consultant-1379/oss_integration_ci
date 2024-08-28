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
        string(name: 'CHART_NAME', description: 'Chart Name sent in through a jenkins artifact.properties.\n This take precedence over the parmaeter sent to the spinnaker pipeline')
        string(name: 'CHART_VERSION', description: 'Chart Version sent in through a jenkins artifact.properties.\n This take precedence over the parmaeter sent to the spinnaker pipeline')
        string(name: 'CHART_REPO', description: 'Chart REPO sent in through a jenkins artifact.properties.\n This take precedence over the parmaeter sent to the spinnaker pipeline')
        string(name: 'INT_CHART_VERSION', description: 'Integration Chart Version, sent in through a jenkins artifact.properties.\n This take precedence over the parmaeter sent to the spinnaker pipeline')
        string(name: 'PARA_CHART_NAME', description: 'Chart Name, sent into the pipeline as a parameter by executing the spinnaker pipeline directly')
        string(name: 'PARA_CHART_VERSION', description: 'Chart Version, sent into the pipeline as a parameter by executing the spinnaker pipeline directly')
        string(name: 'PARA_CHART_REPO', description: 'Chart Repo, sent into the pipeline as a parameter by executing the spinnaker pipeline directly')
        string(name: 'PARA_INT_CHART_VERSION', description: 'Integration Chart Version, sent into the pipeline as a parameter by executing the spinnaker pipeline directly')
        string(name: 'SLAVE_LABEL', defaultValue: 'evo_docker_engine', description: 'Specify the slave label that you want the job to run on')
    }
    stages {
        stage('Generate Deployment Properties') {
            steps {
                sh '''
                    if [[ ${CHART_NAME} != "" && ${CHART_NAME} != *"CHART_NAME"* ]]; then
                        echo "CHART_NAME=${CHART_NAME}" > artifact.properties
                        echo "CHART_VERSION=${CHART_VERSION}" >> artifact.properties
                        echo "CHART_REPO=${CHART_REPO}" >> artifact.properties
                        echo "INT_CHART_VERSION=${INT_CHART_VERSION}" >> artifact.properties
                    elif [[ ${PARA_CHART_NAME} != "" && ${PARA_CHART_NAME} != *"CHART_NAME"* ]]; then
                        echo "CHART_NAME=${PARA_CHART_NAME}" > artifact.properties
                        echo "CHART_VERSION=${PARA_CHART_VERSION}" >> artifact.properties
                        echo "CHART_REPO=${PARA_CHART_REPO}" >> artifact.properties
                        echo "INT_CHART_VERSION=" >> artifact.properties
                    else
                        echo "Issue with the parameters. Please investigate."
                        exit 1
                    fi
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
