variable "key_name" {
  description = "Name of key"
  type        = string
  default = null
  
}
variable "vpc_zone_identifier" {
  description = "vpc_zone_identifier"
  type        = list(string)
  default = []
}