variable "lab_access_key" {
  description = "aws acess key"
  type        = string
}
variable "lab_secret_key" {
  description = "aws secret_key"
  type        = string
}
variable "lab_token" {
  description = "aws temporal session token"
  type        = string
}

variable "lab_region" {
  description = "Region to deploy"
  type        = string
}
variable "my_ip" {
  description = "My IPv4"
  type        = string
}

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

variable "enable_dns_hostnames" {
  description = "Enable the automatic creation of dns hostnames"
  type        = bool
  default     = true
}
