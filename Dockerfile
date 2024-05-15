# Use a base image with necessary dependencies
FROM python:3.9-slim

# Install AWS CLI using pip
RUN pip install awscli

# Install Terraform
RUN apt update && apt install -y wget unzip \
    && wget https://releases.hashicorp.com/terraform/1.0.11/terraform_1.0.11_linux_amd64.zip \
    && unzip terraform_1.0.11_linux_amd64.zip \
    && mv terraform /usr/local/bin \
    && rm terraform_1.0.11_linux_amd64.zip

# Verify Terraform installation
RUN terraform --version

# Define entry point command
CMD ["terraform"]
