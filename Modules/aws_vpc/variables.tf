#######################################################################################################################################
##  VPC VARIABLES
#######################################################################################################################################

# Names

variable "vpc_name" {
  description = "Virtual Private Cloud Name"
  type        = string
  default     = "MyLabVPC"
}

variable "igw_name" {
  description = "Internet Gateway Name"
  type        = string
  default     = "LabVPC IGW"
}

variable "igw_rt_name" {
  description = "Internet Gateway Route Table Name"
  type        = string
  default     = "LabVPC RouteTable"
}

# Networking

variable "vpc_cidr_block" {
  description = "VPC CIDR Block to be used in the infrastructure"
  type        = string
  default     = "10.0.0.0/16"
}

variable "enable_dns_hostnames" {
  description = "Enable the automatic creation of dns hostnames"
  type        = bool
  default     = true
}


