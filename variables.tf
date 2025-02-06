variable "cidr_block" {
  
}

variable "instance_tenancy" {
  
}

variable "enable_dns_hostnames" {
    
  }

variable "env" {


}

variable "tags" {
  
}

variable "gw_tags" {
    default = {}
  
}

variable "public_cidr_block" {
   type= list 
   validation {
    condition     = length(var.public_cidr_block) == 2
    error_message = "max select only two"
  }
}

variable "public_subnet_tags" {
    default = {}
  
}

variable "private_cidr_block" {
   type= list 
   validation {
    condition     = length(var.private_cidr_block) == 2
    error_message = "max select only two"
  }
}

variable "private_subnet_tags" {
    default = {}
  
}

variable "database_cidr_block" {
   type= list 
   validation {
    condition     = length(var.database_cidr_block) == 2
    error_message = "max select only two"
  }
}

variable "database_subnet_tags" {
    default = {}
  
}

variable "nat_tags" {
    default = {}
  
}

variable "public_rt_tags" {
    default = {}
  
}

variable "private_rt_tags" {
    default = {}
  
}

variable "database_rt_tags" {
    default = {}
  
}

variable "is_peering" {
    default = false
  
}

variable "peering_tags" {
    default = {}
  
}

variable "sg_tags" {
    default = {}
  
}


