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
	    string(name: 'APP_NAME',
                defaultValue: 'eric-oss',
                description: 'Application chart name which will be downloaded from helm repository for deployment' )
        string(name: 'INT_CHART_VERSION',
                description: 'The version of base platform to install' )
        string(name: 'DEPLOYMENT_TYPE',
                defaultValue: 'install',
                description: 'Deployment Type, set \"install\" or \"upgrade\"' )
        string(name: 'ARMDOCKER_USER_SECRET',
                description: 'ARM Docker secret')
        string(name: 'HELM_TIMEOUT',
                defaultValue: '1800',
                description: 'Time in seconds for the Deployment Manager to wait for the deployment to execute, default 1800' )
        string(name: 'IAM_HOSTNAME',
                defaultValue: 'default',
                description: 'Hostname for IAM')
        string(name: 'SO_DEPLOY',
                defaultValue: 'true',
                description: 'SO Deploy, set \"true\" or \"false\"' )
        string(name: 'SO_HOSTNAME',
                defaultValue: 'default',
                description: 'Hostname for SO')
        string(name: 'UDS_DEPLOY',
                defaultValue: 'true',
                description: 'UDS Deploy, set \"true\" or \"false\"' )
        string(name: 'UDS_HOSTNAME',
                defaultValue: 'default',
                description: 'Hostname for WANO')
        string(name: 'PF_DEPLOY',
                defaultValue: 'true',
                description: 'PF Deploy, set \"true\" or \"false\"' )
        string(name: 'PF_HOSTNAME',
                defaultValue: 'default',
                description: 'Hostname for PF')
        string(name: 'GAS_HOSTNAME',
                defaultValue: 'default',
                description: 'Hostname for GAS')
        string(name: 'PLATFORM_DEPLOY',
                defaultValue: 'true',
                description: 'PLATFORM Deploy, set \"true\" or \"false\"' )
        string(name: 'ADC_DEPLOY',
                defaultValue: 'false',
                description: 'ADC Deploy, set \"true\" or \"false\"' )
		string(name: 'ADC_HOSTNAME',
                defaultValue: 'default',
                description: 'Hostname for ADC')
        string(name: 'DMM_DEPLOY',
                defaultValue: 'false',
                description: 'DMM Deploy, set \"true\" or \"false\"' )
        string(name: 'TH_DEPLOY',
                defaultValue: 'false',
                description: 'Topology Handling Deploy, set \"true\" or \"false\"' )
        string(name: 'PATH_TO_CERTIFICATES_FILES',
                description: 'Path within the Repo to the location of the certificates directory')
        string(name: 'FULL_PATH_TO_SITE_VALUES_FILE',
                description: 'Full path within the Repo to the site_values.yaml file')
        string(name: 'HELM_REPOSITORY_NAME',
                defaultValue: 'proj-eo-drop-helm',
                description: 'Helm Chart Repository name' )
        string(name: 'NAMESPACE',
                description: 'Namespace to install the Chart' )
        string(name: 'KUBECONFIG_FILE',
                description: 'Kubernetes configuration file to specify which environment to install on' )
        string(name: 'FUNCTIONAL_USER_SECRET',
                defaultValue: 'cloudman-user-creds',
                description: 'Jenkins secret ID for ARM Registry Credentials')
        string(name: 'SLAVE_LABEL',
                defaultValue: 'evo_docker_engine',
                description: 'Specify the slave label that you want the job to run on')
    }
    stages {
        stage('Prepare') {
            steps {
                sh 'git clean -xdff'
                sh 'git submodule sync'
                sh 'git submodule update --init --recursive'
            }
        }
        stage('Get Helm Chart') {
            steps {
                withCredentials([usernamePassword(credentialsId: env.FUNCTIONAL_USER_SECRET, usernameVariable: 'FUNCTIONAL_USER_USERNAME', passwordVariable: 'FUNCTIONAL_USER_PASSWORD')]) {
                    sh "${bob} set-helm-repository fetch-chart"
                }
            }
        }
        stage('Prepare Working Directory'){
            steps {
                withCredentials([file(credentialsId: params.ARMDOCKER_USER_SECRET, variable: 'DOCKERCONFIG'), file(credentialsId: env.KUBECONFIG_FILE, variable: 'KUBECONFIG')]) {
                    sh "install -m 600 ${DOCKERCONFIG} ${HOME}/.docker/config.json"
                    sh "${bob} prepare-workdir"
                    sh "install -m 600 ${KUBECONFIG} ./kube_config/config"
                    sh "${bob} prepare-site-values"

                }
            }
        }
        stage('Update Site Values') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: env.FUNCTIONAL_USER_SECRET, usernameVariable: 'FUNCTIONAL_USER_USERNAME', passwordVariable: 'FUNCTIONAL_USER_PASSWORD')]) {
                        sh "${bob} update-site-values"
                    }
                }
            }
        }
        stage('Helm Chart Deploy') {
            steps {
                script {
                    withCredentials( [file(credentialsId: env.KUBECONFIG_FILE, variable: 'KUBECONFIG')]) {
                        sh "install -m 600 ${KUBECONFIG} ./kube_config/config"
                        sh "${bob} execute-deployment-manager"
                     }
                }
             }
             post {
                failure {
                    script {
                        withCredentials([file(credentialsId: env.KUBECONFIG_FILE, variable: 'KUBECONFIG')]) {
                            sh "install -m 600 ${KUBECONFIG} ./admin.conf"
                            sh "${bob} gather-deployment-logs || true"
                            archiveArtifacts artifacts: 'logs_*.tgz', allowEmptyArchive: true
                        }
                    }
                }
            }
        }
    }
}
