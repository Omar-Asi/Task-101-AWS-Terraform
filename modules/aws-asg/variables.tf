variable "desired_capacity" {
  description = "desired_capacity"
  type        = number
  default     = 2
}

variable "max_size" {
  description = "max_size"
  type        = number
  default     = 3
}

variable "min_size" {
  description = "min_size"
  type        = number
  default     = 1
}

variable "vpc_zone_identifier" {
  description = "vpc_zone_identifier"
  type        = list(string)
  default     = []
}

variable "load_balancers" {
  description = "load_balancers"
  type        = list(string)
  default     = []
}

variable "lt_id" {
  description = "lt_id"
  type        = string
  default     = null
}

variable "lt_name" {
  description = "lt_id"
  type        = string
  default     = ""
}

variable "lt_v" {
  description = "lt_id"
  type        = string
  default     = null
}