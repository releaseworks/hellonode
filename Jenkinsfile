node {
    def image
    /* Loading properties file requires the pipeline-utility-steps jenkins plugin 
       https://stackoverflow.com/questions/39619093/how-to-read-properties-file-from-jenkins-2-0-pipeline-script 
    */
    def props = readProperties file:'build.properties'
    String name = props['image.name']
    String tag = props['image.tag']
    // Getting the short commit identifier
    String commit = sh(returnStdout: true, script: "git describe --always")

    stage('Clone repository') {
        /* Simple checkout of the SCM */
        checkout scm
    }

    stage('Build image') {
        /* Building the image
         * $ docker build -t "${name}" .*/
        // docker.build("foo", "--build-arg x=y .")
        image = docker.build("${name}")
    }

    stage('Test image') {
        /* Testing the image 
           To be defined according to the image
        */
        /* image.inside {
            sh 'echo "Tests passed"'
        }*/
    }

    stage('Push image') {
        /* Pushing the image with 3 tags:
         *  1. The git commit short identifier
         *  2. The tag defined in the build.properties
         *  3. The 'latest' tag
         * Note: Pushing multiple tags is cheap, as all the layers are reused.
         * TODO: Check if it's better with Docker plugin to manage credentials and registry
         * Require 2 environment variables from Jenkins
         *  -  REGISTRY_HOST: To be configured in Jenkins / Configuration / Global properties / Environment variables
         *  -  REGISTRY_CREDS: To be configured in Jenkins / Credentials (Username with password)
         */
        docker.withRegistry("https://${REGISTRY_HOST}", "REGISTRY_CREDS") {
            image.push("${commit}")
            image.push("latest")
            // Trying to pull the tag to check if it already exists, before pushing it.
            pushTag = sh (returnStatus: true, script: "docker pull ${REGISTRY_HOST}/${name}:${tag} > /dev/null") != 0
            if (pushTag) {
                echo "Tag ${name}:${tag} does not exist -> pushing it ..."
                image.push("${tag}")
            }
            else {
                echo "Tag ${name}:${tag} already exists -> no action (avoid overwriting)"
            }
        }
    }

    stage('Cleanup image') {
        /* Removing images on the local host
        There is no implemntation for that in the plugin so doing it whith sh
        */
        sh "docker rmi ${name}:latest"
        sh "docker rmi ${REGISTRY_HOST}/${name}:${commit}"
        sh "docker rmi ${REGISTRY_HOST}/${name}:${tag}"
        sh "docker rmi ${REGISTRY_HOST}/${name}:latest"

    }
}
