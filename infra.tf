provider "aws" {
  region     = "ap-south-1"     # Desired region
  access_key = "*************"
  secret_key = "****************"
}

resource "tls_private_key" "rsa_4096" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}

resource "aws_key_pair" "my_key" {
  key_name   = "my_key"
  public_key = tls_private_key.rsa_4096.public_key_openssh
}

resource "local_file" "private_key" {
  content  = tls_private_key.rsa_4096.private_key_pem
  filename = "private_key"
}

resource "aws_security_group" "aws_sg" {
  name_prefix = "aws-sg-"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "Deci-Instance" {
  ami                    = "ami-08e5424edfe926b43"
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.my_key.key_name
  vpc_security_group_ids = [aws_security_group.aws_sg.id]
  tags = {
    Name    = "Deci-Instance"
    Project = "Deci-Project"
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = tls_private_key.rsa_4096.private_key_pem
    host        = self.public_ip
    timeout     = "5m"
  }

  provisioner "file" {
    source      = "docker.sh"
    destination = "/home/ubuntu/decidim/docker.sh"
  }


  provisioner "remote-exec" {
    inline = [
      "sudo chmod +x /home/ubuntu/decidim/docker.sh",
      "/home/ubuntu/decidim/docker.sh",
    ]
  }

  provisioner "remote-exec" {
    inline = [
      "mkdir /home/ubuntu/decidim_app",
    ]
  }

  provisioner "remote-exec" {
    inline = [
      "cd /home/ubuntu/decidim_app",
      "git clone https://github.com/decidim/docker.git",
      "cd docker",
      "docker compose up -d",
    ]
  }
}
