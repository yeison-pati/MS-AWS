variable "environment" { type = string }
variable "package_file" { type = string }
variable "handler" { type = string }
variable "runtime" { type = string }
variable "timeout" { 
    type = number
    default = 30 
}
variable "memory_size" { 
    type = number
    default = 512 
}