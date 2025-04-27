# search for terraform aws create an asg launch template
# terraform aws launch template
resource "aws_launch_template" "webserver_launch-template" {
  name = "webserver_launch-template"

  vpc_security_group_ids = [aws_security_group.bustercloud_jupiter_web_sg.id]

  image_id = var.ec2_ami_id

  instance_type = "t2.micro"

  key_name = "patty_moore_key1"

  monitoring {
    enabled = true
  }
  user_data = <<-EOF
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

}

# create auto scaling group
# terraform aws create autoscaling group
