#!/usr/bin/env groovy
import org.jenkins.plugins.lockableresources.LockableResourcesManager;
import java.text.SimpleDateFormat
def resourceName

pipeline {
    agent {
        label 'master'
    }
	
    options {
        timestamps()
    }

    parameters {
        string(name: 'ENV_LABEL', defaultValue: 'honeypots_deploy', description: 'Name of the Environment Label to search against')
        string(name: 'FLOW_URL_TAG', defaultValue: 'Spinnaker', description: 'Name for the Flow to be used for the URL to append to the Jenkins Job' )
        string(name: 'FLOW_URL', defaultValue: 'https://spinnaker.rnd.gic.ericsson.se/#/applications/eoapp/executions', description: 'Pipeline URL' )
        string(name: 'WAIT_TIME', defaultValue: '60', description: 'Time in minutes to wait for resource to become free')

    }

    stages {
        stage('Reserve Environment') {
            steps {
                script {
                    resourceName = ReserveEnvDetails()
                    sh "echo 'RESOURCE_NAME=${resourceName}' > artifact.properties"
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

def ReserveEnvDetails() {
    //Get all registered environments
    def manager = org.jenkins.plugins.lockableresources.LockableResourcesManager.get()
    //Defined variables
    def reserveIteration = 1
    def lockedResource = null
    //Set input parameters as groovy variables
    def envLabel = params.ENV_LABEL
    def flowUrlTag = params.FLOW_URL_TAG
    def flowUrl = params.FLOW_URL
    def waitTime = params.WAIT_TIME
    //Set up the number of iterations to wait according to the input time.
    waitTime  = waitTime.toInteger()
    def reserveIterationTotal = waitTime * 2

    while (reserveIteration <= reserveIterationTotal) {
        // Get all free resources that are not reserved and contains the given envLabel parameter as a label
        def freeResources = manager.getResources().findAll {
            ( !it.reserved ) && it.labels.contains(envLabel)
        }
        // Append Number of Free Resources to Jenkins Build Description
        currentBuild.description = "${freeResources.size()} free"
        //If free resources are 0 wait for 30 seconds and loop
        if ( freeResources.size() == 0 ) {
            echo "Unable to find resource, all are currently reserved... Waiting 30 seconds.. Try ${reserveIteration} of ${reserveIterationTotal}"
            reserveIteration++
            if ( reserveIteration > reserveIterationTotal ){
                error("Build failed, unable to reserve environment in allotted time, all environments already reserved")
            }
            // Wait 30 seconds
            Thread.sleep(30000)
            continue
        }
        else {
            freeResources.any { resource ->
                def date = new Date()
                def simpleDateFormat = new SimpleDateFormat("dd/MM/yyyy HH:mm")
                def currentDate = simpleDateFormat.format(date)
                println "Reserving ${resource.name} ~~> ${resource.labels}"
                //Reserve resource according to the name, add a tag to the description of the flow name and flow URL reserving the resource
                manager.reserve([ manager.fromName(resource.name) ], "${flowUrlTag} :: ${flowUrl} :: ${currentDate}")
                // Add a description to the jenkins Build Description
                currentBuild.description = "Reserved ${resource.name} for <a href='${flowUrl}'>${flowUrlTag}</a>"
                lockedResource = resource.name
                return true
            }
            break
        }
    }
    return lockedResource
}
