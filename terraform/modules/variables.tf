variable "instance_type" {
  type        = string
  description = "Type of EC2 instance to provision"
  default     = "t3.nano"
}

variable "subnet_id" {
  type        = string
  description = "ID of the subnet to deploy the instance"
  default     = "subnet-08c58a2f9ba7f1ba0"
}

variable "instance_name" {
  type        = string
  description = "Name of the instance"
  default     = "DDAI02"
}
