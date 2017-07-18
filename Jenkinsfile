node {
    def app

    stage('Clone repository') {
        /* Let's make sure we have the repository cloned to our workspace */

        checkout scm
    }

    stage('Build image') {
        /* This builds the actual image; synonymous to
         * docker build on the command line */

        app = docker.build("getintodevops/hellonode")
    }

    stage('Test image') {
        /* Ideally, we would run a test framework against our image.
         * For this example, we're using a Volkswagen-type approach ;-) */

        app.inside {
            sh 'echo "Tests passed"'
        }
    }


    stage("deploy infrastructure") {
        stage("build infra") { 
            withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: 'devops-aws-credentials', passwordVariable: 'password', usernameVariable: 'username']]) {
                docker.image("hashicorp/terraform:light").inside {
                 sh 'AWS_ACCESS_KEY=${username} AWS_SECRET_ACCESS_KEY=${password} terraform init'
                    sh 'AWS_ACCESS_KEY=${username} AWS_SECRET_ACCESS_KEY=${password} terraform taint -allow-missing aws_instance.app.0'
                    sh 'AWS_ACCESS_KEY=${username} AWS_SECRET_ACCESS_KEY=${password} terraform taint -allow-missing aws_instance.app.1'
                    sh 'AWS_ACCESS_KEY=${username} AWS_SECRET_ACCESS_KEY=${password} terraform apply'
                    IP_ADDRESSES = sh (
                                        script: 'AWS_ACCESS_KEY=${username} AWS_SECRET_ACCESS_KEY=${password} terraform output ips',
                                        returnStdout: true
                                    ).trim()
                } 
            }
        }
    }

    stage('Push image') {
        /* Finally, we'll push the image with two tags:
         * First, the incremental build number from Jenkins
         * Second, the 'latest' tag.
         * Pushing multiple tags is cheap, as all the layers are reused. */
        docker.withRegistry('https://registry.hub.docker.com', 'docker-hub-credentials') {
            app.push("${env.BUILD_NUMBER}")
            app.push("latest")
        }
    }

    stage('Wait for infrastructure to get ready') {
        sh 'sleep 15'
    }

    stage('Deploy with Ansible') {
        def ansible_image = docker.image("williamyeh/ansible:alpine3")
        withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: 'docker-hub-credentials', passwordVariable: 'password', usernameVariable: 'username']]) {
            ansible_image.inside("-u root") {
                ansiblePlaybook(
                    colorized: true,
                    playbook: 'deploy.yml',
                    credentialsId: 'devops-aws-pem',
                    extras: "-i ${IP_ADDRESSES}, -e registry_username=${username} -e registry_password=${password} -e deploy_version=${env.BUILD_NUMBER}"
                )
            }
        }
    }
}