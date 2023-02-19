variable "name" {
  description = "ELB name"
  type        = string
  default     = null
}

variable "internal" {
  description = "internal or not"
  type        = bool
  default     = null
}


variable "security_groups" {
  description = "security_groups"
  type        = list(string)
  default     = []
}

variable "subnets" {
  description = "subnets"
  type        = list(string)
  #default     = []
}



