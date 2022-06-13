pipeline {
    agent { label 'molecule' }
    environment {
        ROLE = "vector-role"
    }
    parameters {
        choice(name: 'TEST', choices: ['only default', 'all'], description: 'Test cases')
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
                if ('only default' != ${params.TEST}) {
                    sh 'molecule test --all'
                }
                else {
                    sh 'molecule test'
                }
            }
        }
    }
}
