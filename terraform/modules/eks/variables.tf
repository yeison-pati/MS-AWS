# Variables para el módulo EKS
variable "cluster_name" { 
  type = string 
}

variable "vpc_id" { 
  type = string 
}

variable "public_subnets" { 
  type = list(string) 
}

variable "private_subnets" { 
  type = list(string) 
}

variable "node_count" { 
  type = number 
}

variable "node_instance_type" { 
  type = string 
}