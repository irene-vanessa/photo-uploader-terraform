#  Photo Uploader Terraform Project

This project uses **Terraform** to provision a fully serverless photo uploader application on AWS. It automates the setup of **storage**, **event-driven processing**, and **metadata management** using services like **S3**, **Lambda**, and **DynamoDB**.

##  Overview

Photos uploaded to an S3 bucket trigger a Lambda function, which processes the event and stores photo metadata in a DynamoDB table. This project is a practical example of an event-driven serverless application using Infrastructure as Code (IaC) principles.

##  Resources Created

- **Amazon S3 Bucket** – Stores uploaded photos.
- **AWS Lambda Function** – Triggered by new uploads to process and store metadata.
- **Amazon DynamoDB Table** – Stores metadata (e.g., filename, timestamp, file size).
- **IAM Role & Policies** – Allow Lambda to interact with DynamoDB and CloudWatch Logs.
- **S3 Event Notification** – Automatically invokes Lambda on object uploads (`PUT`).

##  Usage

### Prerequisites

- Terraform v1.0+
- AWS CLI configured with credentials and region
- SSH key linked to your GitHub account
- AWS account with permission to create required services

### Steps

1. **Clone the repository using SSH**  
   Run: git clone https://github.com/irene-vanessa/photo-uploader-terraform.git


2. **Initialize Terraform**  
   Run: `terraform init`

3. **Deploy infrastructure**  
   Run: `terraform apply`  
   Then confirm with `yes` when prompted.

4. **Test the workflow**  
   Upload a photo to the S3 bucket and check DynamoDB for metadata and CloudWatch for logs.


## Key Benefits

- Fully **serverless** deployment using AWS Free Tier eligible services.
- Event-driven design: no need for polling or manual triggers.
- Portable and version-controlled infrastructure using **Terraform**.
- Secure access policies using **IAM best practices**.

## Cleanup
To destroy all provisioned resources and avoid ongoing charges:
terraform destroy

Confirm with yes when prompted

##  License

This project is licensed under the [MIT License](LICENSE).


