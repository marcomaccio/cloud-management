
pipeline {

    agent any

    parameters {
        string(defaultValue: 'mm-auditing',                     description: 'Project Name',                                        name: 'PROJECT_NAME')
        string(defaultValue: 'marcus.maccio@gmail.com',         description: 'Contact Emails',                                      name: 'CONTACT_EMAILS')
        string(defaultValue: 'us-east-1',                       description: 'AWS Region in which store the S3 bucket',             name: 'AWS_S3_REGION')
        string(defaultValue: 'mm-global-sec',                   description: 'AWS S3 bucket to store Tf State Files',               name: 'AWS_S3_BUCKET_NAME_TFSTATE')
        string(defaultValue: 'mm-global-sec',                   description: 'AWS S3 dir in which store Tf state files',            name: 'AWS_S3_BUCKET_NAME_TFSTATE')
        string(defaultValue: 'marmac-marcomaccio-eu-west-1',    description: 'AWS Credential Profile',                              name: 'AWS_PROFILE')
        string(defaultValue: '328917479208',                    description: 'AWS Account Id used to reference all AWS Resources',  name: 'AWS_ACCOUNT_ID')
        string(defaultValue: 'mm-globalsec-trail',              description: 'AWS CLoud Trail name',                                name: 'AWS_CLOUDTRAIL_NAME')
        string(defaultValue: 'CloudTrail/SecurityLogs',         description: 'AWS CloudWatch Logs log group name',                  name: 'AWS_CLOUDWATCH_LOGS_GROUP_NAME')
        string(defaultValue: 'mm-security-logstream',           description: 'AWS CloudWatch Logs log stream name',                 name: 'AWS_CLOUDWATCH_LOGS_LOG_STREAM_NAME')
    }

    environment {
        PACKER_HOME    = tool(name: 'packer-1.1.1', type: 'biz.neustar.jenkins.plugins.packer.PackerInstallation')
        TERRAFORM_HOME = tool(name: 'terraform-0.10.8', type: 'org.jenkinsci.plugins.terraform.TerraformInstallation')
    }

    stages {
        stage('Checkout-EnvPreparation') {
            agent any
            steps {
                echo 'Checkout-EnvPreparation stage: this will checkout the source code from github'

                git branch: 'integr',
                        credentialsId: 'github-marcomaccio',
                        url: 'https://github.com/marcomaccio/cloud-management.git'

                // Script to retrieve the Public IP of the Internet Connection in use
                script {
                    awsICPublicIP = sh(returnStdout: true, script: 'dig @ns1.google.com -t txt o-o.myaddr.1.google.com +short').trim()
                    echo "Public Ip:  ${awsICPublicIP}"
                }
            }
        }
        stage('Auditing-Creation') {
            agent any
            steps {
                echo 'CloudTrail-CloudWatch-Creation stage: this will create resources to audit AWS resources'

                wrap([$class: 'AnsiColorBuildWrapper', colorMapName: 'xterm']) {

                    dir('terraform/providers/aws/modules/auditing') {

                        withCredentials([
                                [
                                        $class: 'AmazonWebServicesCredentialsBinding',
                                        credentialsId: 'marmac-marcomaccio-eu-west-1',
                                        accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                                        secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
                                ]
                        ]) {

                            echo "Launch terraform init ... "

                            sh "${TERRAFORM_HOME}/terraform init"

                            echo "Launch terraform plan"

                            sh "${TERRAFORM_HOME}/terraform plan --out auditing.tfplan      " +
                                    "-var 'project_name=$PROJECT_NAME'                      " +
                                    "-var 'contact_email_list=$CONTACT_EMAILS'              " +
                                    "-var 'profile=$AWS_PROFILE'                            " +
                                    "-var 'aws_account_id=$AWS_ACCOUNT_ID'                  " +
                                    "-var 'aws_region=$AWS_S3_REGION'                       " +
                                    "-var 'aws_cloudtrail_name=$AWS_CLOUDTRAIL_NAME'        " +
                                    "-var 'aws_cloudwatch_log_group_name=$AWS_CLOUDWATCH_LOGS_GROUP_NAME'   " +
                                    "-var 'aws_cloudwatch_logs_log_stream_name=$AWS_CLOUDWATCH_LOGS_LOG_STREAM_NAME' "

                            sh "${TERRAFORM_HOME}/terraform apply auditing.tfplan"

                            //script {
                            //    awsYveFEPubIp = sh(returnStdout: true, script: '${TERRAFORM_HOME}/terraform output aws_yve_sv_eip_fe_ip').trim()
                            //    echo "FE Public Ip:  ${awsYveFEPubIp}"
                            //}
                        }
                    }
                }
            }
        }
    }
}