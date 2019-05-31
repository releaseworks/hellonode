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
        image.inside {
            sh 'echo "Tests passed"'
        }
    }

    stage('Push image') {
        /* Pushing the image with 3 tags:
         *  1. The git commit short identifier
         *  2. The tag defined in the build.properties
         *  3. The 'latest' tag
         * Note: Pushing multiple tags is cheap, as all the layers are reused.
         *
         * Require 2 environment variables from Jenkins
         *  -  REGISTRY_URL: To be configured in Jenkins / Configuration / Global properties / Environment variables
         *  -  REGISTRY_CRED: To be configured in Jenkins / Credentials (Username with password)
         */
        echo "Using the Registry: ${REGISTRY_URL}"
        
        docker.withRegistry("${REGISTRY_URL}", "REGISTRY_CRED") {
            image.push("${commit}")
            image.push("${tag}")
            image.push("latest")
        }
    }
}
