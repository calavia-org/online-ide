pipeline {

  agent {
    docker {
      image 'hashicorp/terraform:1.0.4'
      args  '--entrypoint="" -u root'
    }
  }

  stages {

    stage ('Terraform init') {
      steps {
        sh '''
          terraform --version
        '''
      }
    }

    stage ('Check if cluster is up') {
      steps {
        sh '''
          terraform --version
        '''
      }
    }

    stage ('Setup cluster') {
      steps {
        sh '''
          terraform --version
          echo "eclipse-che install"
        '''
      }
    }

    stage ('Tear down cluster') {
      steps {
        sh '''
          terraform --version
        '''
      }
    }

  } // close stages
}// close pipeline
