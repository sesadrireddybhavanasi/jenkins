resource "aws_security_group" "jenkins" {
  name        = "webjenkins"
  description = "this is using for securitygroup"
  vpc_id      = "vpc-0ff0fc318b12bf0ae"

  ingress {
    description = "this is inbound rule"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["45.249.77.103/32"]
  }
  ingress {
    description = "this is inbound rule"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "jenkins"
  }
}
#apacheuserdata
data "template_file" "jenkinsuser" {
  template = file("jenkins.sh")

}
# apache instance
resource "aws_instance" "jenkins" {
  ami                    = "ami-074dc0a6f6c764218"
  instance_type          = "t2.micro"
  subnet_id              = "subnet-0f60f8b79257a51fa"
  vpc_security_group_ids = [aws_security_group.jenkins.id]
  key_name               = "seshu"
  user_data              = data.template_file.jenkinsuser.rendered
  tags = {
    Name = "stage-jenkins"
  }
}