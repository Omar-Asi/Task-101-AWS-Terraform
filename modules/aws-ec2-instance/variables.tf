variable "ami" {
  description = "ami"
  type        = string
  default     = null
}

variable "instance_type" {
  description = "instance_type"
  type        = string
  default     = null
}

variable "key_name" {
  description = "ID of the VPC where to create security group"
  type        = string
  default     = null
}

variable "subnet_id" {
  description = "subnet_id"
  type        = string
  default     = null
}

variable "vpc_security_group_ids" {
  description = "vpc_security_group_ids"
  type        = list(string)
  default     = []
}


variable "associate_public_ip_address" {
  description = "associate_public_ip_address"
  type        = bool
  default     = false
}

variable "tags" {
  description = "tag"
  type        = map(string)
  default     = {}
}

