variable "resource_group_name" {
  type        = string
  description = "The name of the resource group where the load balancer will be deployed."
}

variable "location" {
  type        = string
  description = "The Azure region where the load balancer will be created."
}

variable "load_balancer_name" {
  type        = string
  default     = "ftalk01-p-noe-01-nort-lbi"
  description = "The name of the load balancer to be created."
}

variable "frontend_ip_name" {
  type        = string
  default     = "ftalk01-lbfrontend"
  description = "The name of the frontend IP address for the load balancer."
}

variable "frontend_ip_address" {
  type        = string
  description = "The private IP address of the load balancer."
}

variable "backend_pool_name" {
  type        = string
  default     = "ftalk01-lbbackendAddressPool"
  description = "The name of the backend pool for the load balancer."
}

variable "nic_names" {
  type = list(string)

}

variable "lb_details" {
  type = map(any)
  default = {
    rule_6220 = {
      fe_port           = "6220"
      be_port           = "6220"
      proto             = "Tcp"
      name              = "ftalk01-lb-systemservice-rule"
      probename         = "probe-6220"
      load_distribution = "SourceIP"
    },
    rule_6222 = {
      fe_port           = "6222"
      be_port           = "6222"
      proto             = "Tcp"
      name              = "ftalk01-lb-deviceservice-rule"
      probename         = "probe-6222"
      load_distribution = "SourceIP"
    },
  }
}

