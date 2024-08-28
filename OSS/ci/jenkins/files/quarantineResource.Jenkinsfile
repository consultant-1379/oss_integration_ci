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
        string(name: 'ENV_NAME', description: 'Name of the Environment to be quarantined')
    }

    stages {
        stage('Quarantine Environment') {
            steps {
                script {
                    quarantineEnvDetails()
                }
            }
        }
    }
}

def quarantineEnvDetails() {
    //Get all registered environments
    def manager = org.jenkins.plugins.lockableresources.LockableResourcesManager.get()
    //Set input paramaters as groovy variables
    def envName = params.ENV_NAME
    // Check is the environment reserved
    if ( manager.fromName(envName)?.isReserved() ) {
        // Quarantine the environment
        def description = manager.fromName(envName).getReservedBy()
        def newDescription
        if ( description.contains("Quarantined") ) {
            newDescription = description
        }
        else {
            newDescription = "Quarantined :: ${description}"
        }
        manager.reset([ manager.fromName(envName) ])
        manager.reserve([ manager.fromName(envName) ], "${newDescription}" )
        // Add a description to the jenkins Build Description
        currentBuild.description = "Quarantined ${envName}"
    }
    else {
        currentBuild.description = "Unreserved or Not Found :: ${envName}"
    }
}
