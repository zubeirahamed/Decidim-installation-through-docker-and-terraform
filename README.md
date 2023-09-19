# Decidim-installation-through-docker-and-terraform

Decidim-Docker
Launching Decidim App through Terraform and Docker Image.

Write Terraform Configuration (ec2.tf).
Create a Terraform configuration file (e.g., ec2.tf) to define your EC2 instance.

Prepare the docker.sh Script.
Ensure that your docker.sh script is ready and contains the necessary commands you want to run on the EC2 instance.

SSH into the EC2 Instance and Copy the Script.
After the EC2 instance is created, you can SSH into it using the private key associated with your key pair. Use the public DNS or IP address of the EC2 instance.

ssh -i /path/to/your-key-pair.pem ec2-user@ec2-instance-public-dns-or-ip
Copy the Script to the EC2 Instance:
Once you're connected to the EC2 instance via SSH, you can use the scp command to copy the docker.sh script to the instance.

scp -i /path/to/your-key-pair.pem /path/to/docker.sh ec2-user@ec2-instance-public-dns-or-ip:/path/on/remote/host
Replace /path/to/docker.sh with the local path to your docker.sh script and /path/on/remote/host with the desired path on the EC2 instance where you want to copy the script.
Run the Script on the EC2 Instance.
After copying the script, you can execute it on the EC2 instance.

ssh -i /path/to/your-key-pair.pem ec2-user@ec2-instance-public-dns-or-ip "bash /path/on/remote/host/docker.sh"
This sequence of steps will create an EC2 instance using Terraform, copy your docker.sh script onto the instance, and execute it.
You can now start your server!

Visit http://<server_public_ip>:3000 to see your app running. 🎉 🎉
