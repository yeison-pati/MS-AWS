variable "engine" {
    type = string
}
variable "username" {
    type = string
    sensitive = true
}
variable "password" {
    type = string
    sensitive = true
}

variable "db_name" {
    type = string
    
}
variable "allocated_storage" {
    type = number
}
variable "vpc_id" {
    type = string
}
variable "subnet_ids" {
    type = list(string)
}
variable "environment" {
    type = string
}
