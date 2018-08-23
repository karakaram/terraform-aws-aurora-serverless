variable "region" {
  description = "A region for the VPC"
}

variable "vpc_state_config" {
  description = "A config for accessing the vpc state file"
  type        = "map"
}

variable "name" {
  description = "Name to be used on all resources as prefix"
  default     = ""
}

variable "username" {
  description = "Username for the master DB user"
}

variable "password" {
  description = "Password for the master DB user. Note that this may show up in logs, and it will be stored in the state file"
}

variable "environment" {
  description = "The environment to use for the instance"
  default     = ""
}
