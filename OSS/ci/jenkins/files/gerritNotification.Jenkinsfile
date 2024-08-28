#!/usr/bin/env groovy

def gerritReviewCommand = "ssh -p 29418 gerrit.ericsson.se gerrit review --message '\"${Message}\"' \${GERRIT_CHANGE_NUMBER},\${GERRIT_PATCHSET_NUMBER}"

pipeline {
    agent {
        label env.SLAVE_LABEL
    }
    options {
        timestamps()
    }
    parameters {
        string(name: 'Message', description: 'A message to be added as feedback on the triggering Gerrit event.')
        string(name: 'GERRIT_CHANGE_NUMBER')
        string(name: 'GERRIT_PATCHSET_NUMBER')
        string(name: 'SLAVE_LABEL', defaultValue: 'evo_docker_engine', description: 'Specify the slave label that you want the job to run on')
    }
    stages {
        stage('Comment on Gerrit') {
            steps {
                sh "${gerritReviewCommand}"
            }
        }
    }
}