resource "aws_instance" "bustercloud_jupiter_web" {
  ami                         = "ami-04985531f48a27ae7" #this AMI value is unique per region
  instance_type               = "t2.micro"
  key_name                    = "patty-moore-key1"
  subnet_id                   = aws_subnet.bustercloud_project_public_subnet-az1a.id
  vpc_security_group_ids      = [aws_security_group.bustercloud_jupiter_web_sg.id]
  associate_public_ip_address = true
  user_data                   = <<-EOF
    #!/bin/bash
    sudo su
    yum update -y
    yum install -y httpd
    cd /var/www/html
    wget https://github.com/Ahmednas211/jupiter-zip-file/raw/main/jupiter-main.zip
    unzip jupiter-main.zip
    cp -r jupiter-main/* /var/www/html
    rm -rf jupiter-main jupiter-main.zip
    systemctl start httpd
    systemctl enable httpd
  EOF

  tags = {
    Name = "Jupiter Web Server"
  }
}