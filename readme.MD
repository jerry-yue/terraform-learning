# Create AWS Environment by Terraform
## Stage 1: Building EC2 Web Server
- instance type: `t2.micro`
- resource region: `ap-southeast-1`
- resource availability zone: `apsoutheast-1a`
- mount an EBS volume: `size 1GB`
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
