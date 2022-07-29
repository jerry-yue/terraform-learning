# Create AWS Environment by Terraform
## Stage 1: Building EC2 Web Server
- instance type: `t2.micro`
- resource region: `ap-southeast-1`
- resource availability zone: `apsoutheast-1a`
- mount an EBS volume: `size 1GB`
    - 1 partition
    - has file system
    - auto mount while instace startup
- install a web server application: `nginx` in this example
- default page showing: `Hello AWS World`
- the default page file should be saved in the EBS volume
- the page can be open from public (not using EIP in this example)
- attach a key-pair for ssh login


## Stage 2: Build Elastic Load Balancer
- create an ELB or an ALB
- resource region: `ap-southeast-1`
- accept HTTP on port 80
- the healthy threshold for the ELB/ALB to be set to 2
- deliver traffic to the EC2 instance crated in stage 1


## Stage 3: Configure a S3
- resource region: `ap-southeast-1`
- save some screenshots to the S3
- the screnshots also will be shown in the web page



# How to use it
0. Before the first time's applying, or before destorying, please comment all code lines in `s3_object_url.tf` file
1. Initial terraform folder by `terraform init`
2. Setup awscli AK and SK
3. Execute the tf script file by `terraform apply`. (Recommend `terraform plan` before apply.)
4. Un-comment `s3_object_url.tf`, and `terraform apply` again to get the object URL saved in S3 bucket
5. Update Nginx's index.html file
6. Allow CORS
7. After all test passed, please comment all code lines in `s3_object_url.tf` file, and execte `terraform destroy` to remove all resources.
> If the resources destroyed failed, please force detach EBS volume from AWS console. And try the destroy command again.


# Improvement Required
1. Resolve the bug of cannot detach EBS volume via terraform code
2. Resolve `s3_object_url.tf` file issue, it cause multiple apply and destroy concerns
3. Resolve object URL appending to Nginx index.html by terraform code
4. Resolve CORS configuration by terraform code (img src tag no CORS issue. fetch_response has.)
5. Grant S3 bucket objects permission by IAM role which assigned to the dedicated EC2 instance.


# More reference
[How to Deploy a Set of EC2 Instances behind an ALB Using Terraform | by Dasanirban | AWS in Plain English](https://aws.plainenglish.io/deploy-a-set-of-ec2-instances-behind-an-alb-using-terraform-403fe584f09e)

[How to manage Public and Private subnets in AWS with Terraform? | by Dhruvin Soni | Geek Culture | Medium](https://medium.com/geekculture/how-to-manage-public-and-private-subnets-in-aws-with-terraform-69c272003c81)

