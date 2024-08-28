#!/usr/bin/env groovy

/* IMPORTANT:
 *
 * In order to make this pipeline work, the following configuration on Jenkins is required:
 * - slave with a specific label (see pipeline.agent.label below)
 * - Credentials Plugin should be installed and have the secrets with the following names:
 *   + c12a011-config-file (admin.config to access c12a011 cluster)
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
        string(name: 'NAMESPACE', defaultValue: 'oss', description: 'Namespace to purge environment')
        string(name: 'KUBECONFIG_FILE', defaultValue: 'c7a016-config-file', description: 'Kubernetes configuration file to specify which environment purge' )
        string(name: 'SLAVE_LABEL', defaultValue: 'evo_docker_engine', description: 'Specify the slave label that you want the job to run on')
    }

    stages {
        stage('Clean Workspace') {
            steps {
                sh 'git clean -xdff'
                sh 'git submodule sync'
                sh 'git submodule update --init --recursive'
            }
        }
        stage('Remove Helm Release') {
            steps {
                script {
                    withCredentials( [file(credentialsId: env.KUBECONFIG_FILE, variable: 'KUBECONFIG')]) {
                        sh "install -m 600 ${KUBECONFIG} ./admin.conf"
                        sh "${bob} remove-helm3-installed-release remove-helm2-installed-release"
                    }
                }
            }
        }
        stage('Remove Installed PVCs') {
            steps {
                script {
                    withCredentials( [file(credentialsId: env.KUBECONFIG_FILE, variable: 'KUBECONFIG')]) {
                        sh "install -m 600 ${KUBECONFIG} ./admin.conf"
                        sh "${bob} remove-installed-pvcs"
                    }
                }
            }
        }
        stage('Remove TLS Secrets') {
            steps {
                script {
                    withCredentials( [file(credentialsId: env.KUBECONFIG_FILE, variable: 'KUBECONFIG')]) {
                        sh "install -m 600 ${KUBECONFIG} ./admin.conf"
                        sh "${bob} remove-tls-secrets"
                    }
                }
            }
        }
    }
}
