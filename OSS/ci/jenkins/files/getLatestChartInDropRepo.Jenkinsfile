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
        string( name: 'INT_CHART_VERSION',
                defaultValue: '0.0.0',
                description: 'CHART Version sent in through a jenkins artifact.properties.')
        string( name: 'FUNCTIONAL_USER_SECRET',
                defaultValue: 'cloudman-user-creds',
                description: 'Functional user secret ID')
        string(name: 'SLAVE_LABEL',
                defaultValue: 'evo_docker_engine',
                description: 'Specify the slave label that you want the job to run on')
    }
    environment {
        HELM_REPO_CREDENTIALS = "${env.WORKSPACE}/repositories.yaml"
    }
    stages {
        stage('Prepare') {
            steps {
                sh 'git clean -xdff'
                sh 'git submodule sync'
                sh 'git submodule update --init --recursive'
            }
        }
        stage('Get Latest EO') {
            steps {
                withCredentials([usernamePassword(credentialsId: env.FUNCTIONAL_USER_SECRET, usernameVariable: 'FUNCTIONAL_USER_USERNAME', passwordVariable: 'FUNCTIONAL_USER_PASSWORD')]) {
                    sh '''
                        if [[ ${INT_CHART_VERSION} != "0.0.0" ]]; then
                            echo "INT_CHART_VERSION:${INT_CHART_VERSION}" > artifact.properties
                        else
                            bob/bob -r \${WORKSPACE}/OSS/ci/jenkins/rulesets/ruleset2.0.yaml get-latest-chart-version_from_drop_repo
                        fi
                    '''
                }
            }
        }
        stage('Archive Artifact Properties') {
            steps {
                script {
                    archiveArtifacts 'artifact.properties'
                }
            }
        }
    }
}
