pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build and Archive Web') {
            steps {
                sh 'flutter pub get'
                sh 'flutter build web'
                archiveArtifacts artifacts: '**/build/web/**/*', fingerprint: true
            }
        }

//         stage('Build and Archive iOS') {
//             steps {
//                 sh 'flutter build ios'
//                 archiveArtifacts artifacts: '**/build/ios/**/*', fingerprint: true
//             }
//         }
    }
}