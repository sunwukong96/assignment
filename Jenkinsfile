pipeline {
    agent any

    environment {
        IMAGE_TAG = 'v0.2.0'
    }

    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'main', 
                    url: 'https://github.com/sunwukong96/assignment.git',
                    credentialsId: 'public-git'
            }
        }

        stage('Update Image Tag') {
            steps {
                script {
                    def patchFile = 'kustomize/overlays/dev/patch-deployment.yaml'
                    
                    def patchContent = readFile(patchFile)
                    
                    def updatedContent = patchContent.replaceAll(/scarifcitadel\\/helloapi:.*/, "scarifcitadel/helloapi:${env.IMAGE_TAG}")
                    
                    writeFile(file: patchFile, text: updatedContent)
                }
            }
        }

        stage('Commit and Push Changes') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'public-git', usernameVariable: 'GIT_USER', passwordVariable: 'GIT_PASS')]) {
                    sh '''
                    git config user.name "Jenkins CI"
                    git config user.email "jenkins@example.com"
                    git add kustomize/overlays/dev/patch-deployment.yaml
                    git commit -m "Update image tag to ${IMAGE_TAG}"
                    git push https://${GIT_USER}:${GIT_PASS}@github.com/sunwukong96/assignment.git main
                    '''
                }
            }
        }
    }
}
