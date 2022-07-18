## vars

variable "region" {

  description = "AWS Region"
  type        = string
  default     = "eu-west-3"
}

variable "cidr_ab" {
  type = map(any)
  default = {
    development = "10.10"
    qa          = "10.20"
    staging     = "10.30"
    production  = "10.40"
  }
}

variable "env" {
  description = "Environment"
  default     = "qa"
}

### ALB
variable "healthy_threshold" {
  description = "Healthy threshold count for alb"
  default     = 2
  type        = number
}

variable "unhealthy_threshold" {
  description = "Un-Healthy threshold count for alb"
  default     = 5
  type        = number
}

variable "health_check_interval" {
  description = "Health check interval"
  default     = 10
  type        = number
}


### ASG
variable "asg_desired_capacity" {
  description = "Desired Capacity of instances"
  default     = 2
  type        = number
}

variable "asg_min_size" {
  description = "Minimum number of instances"
  default     = 2
  type        = number
}

variable "asg_max_size" {
  description = "Max number of instances"
  default     = 5
  type        = number
}
