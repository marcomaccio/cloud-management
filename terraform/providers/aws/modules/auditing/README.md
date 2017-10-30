AWS CLOUD TRAIL & CLOUD WATCH AUDITING
======================================

Terraform module to configure CloudTrail with CloudWatch Logs to monitor your trail logs and be notified when specific activity occurs, as described here [](http://docs.aws.amazon.com/awscloudtrail/latest/userguide/monitor-cloudtrail-log-files-with-cloudwatch-logs.html)

These types of resources are supported:

* [S3](https://www.terraform.io/docs/providers/aws/r/)
* [CloudTrail](https://www.terraform.io/docs/providers/aws/r/)
* [CloudWathLogs](https://www.terraform.io/docs/providers/aws/r/)

Goals
-----

Description
-----------


Usage
-----

```hcl
module "auditing" {

}
```

Launch
------
In order to launch this module launch the following commands, at the shell:
```bash
host:auditing user$ terraform init -backend-config="region=us-east-1" \
                                   -backend-config="bucket=<your_s3_bucket_name>" \
                                   -backend-config="key=<your_dir>/terraform.tfstate" \

host:auditing user$ terraform plan -out auditing.tfplan -var "profile=<your_aws_credentials_profile>"   \
                                    -var "aws_account_id=<your_aws_account_id>"     \
                                    -var "project_name=auditing"                    \
                                    -var "contact_email_list=info@example.com"      \
                                    -var "aws_region=us-east-1"                     \
                                    -var "aws_cloudtrail_name=mm-global-security" .
                                    
host:auditing user$ terraform apply
```

Examples
--------


Authors
-------
Module managed by [Marco Maccio](https://github.com/marcomaccio)


License
-------
Apache 2 Licensed. See LICENSE for full details.
