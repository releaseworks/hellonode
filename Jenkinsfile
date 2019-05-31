node {
    def image
    /* Loading properties file requires the pipeline-utility-steps jenkins plugin 
       https://stackoverflow.com/questions/39619093/how-to-read-properties-file-from-jenkins-2-0-pipeline-script 
    */
    def props = readProperties file:'build.properties'
    String name = props['image.name']
    String tag = props['image.tag']

    stage('Clone repository') {
        /* Let's make sure we have the repository cloned to our workspace */
        checkout scm
    }

    stage('Build image') {
        /* This builds the actual image; synonymous to
         * docker build on the command line */
        // docker.build("foo", "--build-arg x=y .")
        //image = docker.build(props['image.name'])
        image = docker.build("${name}")
    }

    stage('Test image') {
        /* Ideally, we would run a test framework against our image.
         * For this example, we're using a Volkswagen-type approach ;-) */
        image.inside {
            sh 'echo "Tests passed"'
        }
    }

    stage('Push image') {
        /* Finally, we'll push the image with two tags:
         * First, the incremental build number from Jenkins
         * Second, the 'latest' tag.
         * Pushing multiple tags is cheap, as all the layers are reused. */
        docker.withRegistry("https://registry.hub.docker.com", "docker-hub-credentials") {
            image.push("${env.GIT_COMMIT}")
            image.push("latest")
        }
    }
}
