variable "name" {}
variable "role_tag" {}
variable "environment_tag" {}
variable "costcenter_tag" {}
variable "iam_profile" {}
variable "region" {}
variable "instance_type" {}
variable "ami" {}
variable "subnet" {}
variable "security_groups" {}
variable "key_name" {}
variable "key_path" {}
variable "num_nodes" {}
variable "environment" {}
variable "cluster" {}
variable "stream_tag" {}

resource "aws_instance" "elastic" {

  instance_type = "${var.instance_type}"

  # Lookup the correct AMI based on the region we specified
  ami = "${var.ami}"
  subnet_id = "${var.subnet}"

  iam_instance_profile = "elasticSearchNode"
  associate_public_ip_address = "false"

  # Our Security groups
  security_groups = ["${split(",", replace(var.security_groups, "/,\s?$/", ""))}"]
  key_name = "${var.key_name}"

  # Elasticsearch nodes
  count = "${var.num_nodes}"

  connection {
    # The default username for our AMI
    user = "ubuntu"
    type = "ssh"
    host = "${self.private_ip}"
    # The path to your keyfile
    key_file = "${var.key_path}"
  }

  tags {
    Name = "${var.name}-${count.index+1}"
    Stream = "${var.stream_tag}"
    # change to use cluster
    es_env = "${var.environment}"
    cluster = "${var.cluster}"
    consul = "agent"
    # required for ops reporting
    ServerRole = "${var.role_tag}"
    "Cost Center" = "${var.costcenter_tag}"
    Environment = "${var.environment_tag}"
  }

}