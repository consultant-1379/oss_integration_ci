#!/usr/bin/env groovy
/* IMPORTANT:
 *
 * In order to make this pipeline work, the following configuration on Jenkins is required:
 * - slave with a specific label (see pipeline.agent.label below)
 */

def bob = "bob/bob -r \${WORKSPACE}/OSS/ci/jenkins/rulesets/ruleset2.0.yaml"

pipeline {
    agent {
        label env.SLAVE_LABEL
    }
    options {
        timestamps()
    }
    parameters {
        string(name: 'NAMESPACE', defaultValue: 'eo', description: 'Namespace to Check' )
        string(name: 'INT_CHART_VERSION', description: 'Base Chart Version that is going to be installed from the Drop Repo' )
        string(name: 'SNAP_INT_CHART_VERSION', defaultValue: '0.0.0', description: 'Snapshot Base Chart Version that is going to be installed during the upgrade phase' )
        string(name: 'KUBECONFIG_FILE', defaultValue: 'C13A017-config-file', description: 'Kubernetes configuration file to specify which environment to check' )
        string(name: 'SLAVE_LABEL', defaultValue: 'evo_docker_engine', description: 'Specify the slave label that you want the job to run on')
    }
    stages {
        stage('Cleaning Git Repo') {
            steps {
                sh 'git clean -xdff'
                sh 'git submodule sync'
                sh 'git submodule update --init --recursive'
            }
        }
        stage('Check Status of the Deployment') {
            steps {
                script {
                    withCredentials( [file(credentialsId: env.KUBECONFIG_FILE, variable: 'KUBECONFIG')]) {
                        sh "install -m 600 ${KUBECONFIG} ./admin.conf"
                        sh "${bob} check-deployment-status"
                    }
                }
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
