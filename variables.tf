variable "key_name" {
  description = "keypair for ec2 instance"
}

variable "instance_profile" {
  description = "instance profile with correct privileges to be able to join domain"
}

variable "name_tag" {
  default = "adclient"
  description = "Name tag of instance to use as computer name and domain join"
}

variable "private_ip" {
  description = "private ip address"
}

variable "ami" {
  description = "base amazon windows 2012 ami"
}

variable "instance_type" {
  default = "t2.micro"
  description = "instance type"
}

variable "associate_public_ip_address" {
  default = "false"
  description = "associate_public_ip_address"
}

variable "ssm_document_name" {
  description = "ssm_document_name to do domain join"
}

variable "vpc_security_group_ids" {
  description = "vpc_security_group_ids"
}

variable "subnet_id" {
  description = "subnet_id to run adclient"
}

variable "tags" {
  description = "A map of additional tags for the adclient ec2 instance"
  default     = {}
}
