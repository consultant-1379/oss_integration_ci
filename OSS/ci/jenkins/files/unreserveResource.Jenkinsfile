#!/usr/bin/env groovy

import org.jenkins.plugins.lockableresources.LockableResourcesManager;

pipeline {
    agent {
        label 'master'
    }
	
    options {
        timestamps()
    }

    parameters {
        string(name: 'ENV_NAME', description: 'Name of the Environment to be unreserved')
    }

    stages {
        stage('Unreserve Environment') {
            steps {
                script {
                    UnReserveEnvDetails()
                }
            }
        }
    }
}

def UnReserveEnvDetails() {
    //Get all registered environments
    def manager = org.jenkins.plugins.lockableresources.LockableResourcesManager.get()
    //Set input paramaters as groovy variables
    def envName = params.ENV_NAME
    // Check is the environment reserved
    if ( manager.fromName(envName)?.isReserved() ) {
        // Reset the reserved environment
        manager.reset([ manager.fromName(envName) ])
        // Add a description to the jenkins Build Description
        currentBuild.description = "Unreserved ${envName}"
    }
    else {
        currentBuild.description = "Already Unreserved ${envName}"
    }
}
