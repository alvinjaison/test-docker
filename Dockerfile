# Use a base image with necessary dependencies
FROM ubuntu:latest

# Set the working directory
WORKDIR /app

RUN apt clean

RUN apt update -y --fix-missing && apt install -y \
        gnupg \
        software-properties-common \
        wget \
        gpg \
        curl \
        unzip



RUN wget -O- https://apt.releases.hashicorp.com/gpg | \
        gpg --dearmor | \
        tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null

RUN gpg --no-default-keyring \
    --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg \
    --fingerprint

RUN echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
    https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
    tee /etc/apt/sources.list.d/hashicorp.list

RUN apt update && apt install terraform -y

RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip" -o "awscliv2.zip" \
    unzip awscliv2.zip \
    ./aws/install



# Copy your Terraform files and scripts into the container
COPY ./app-infra /app

# Make the script executable
RUN chmod +x /app/run_terraform.sh

# # Create a non-root user and switch to it
# RUN useradd -m myuser
# USER myuser

# Define entry point command
CMD ["/app/run_terraform.sh"]

# End of Dockerfile
