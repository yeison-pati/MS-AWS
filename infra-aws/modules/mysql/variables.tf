variable "engine" { type = string }
variable "username" { type = string }
variable "password" { type = string }
variable "allocated_storage" { type = number }
variable "vpc_id" { type = string }
variable "subnet_ids" { type = list(string) }
variable "environment" { type = string }
