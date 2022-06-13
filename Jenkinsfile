pipeline {
    agent { label 'molecule' }
    environment {
        ROLE = "vector-role"
    } 
    stages {
        stage('Git checkout') {
            steps {
                echo "Testing role ${env.ROLE}"
                checkout([
                    $class: 'GitSCM', 
                    branches: [[name: "*/${env.ROLE}"]], 
                    extensions: [], 
                    userRemoteConfigs: [[url: 'https://github.com/Kraktorist/devops-netology.git']]
                ])
            }
        }
        stage('Run molecule') {
            steps {
                sh 'molecule test --all'
            }
        }
    }
}
