variable "function_name" {
  description = "The name of the lambda function"
  type        = string
}

variable "zipfile_name" {
  description = "The name of the zip file containing the lambda function code"
  type        = string
}

variable "handler_name" {
  description = "The name of lambda handler"
  type        = string
}

variable "runtime" {
  description = "The lambda runtime"
  type        = string
}

variable "environment_variables" {
  description = "A map of environment variables for the lambda function"
  type        = map(string)
  default     = { "TZ" = "Europe/Berlin" }
}

variable "memory_size" {
  description = "The amount of memory in MB allocated to the lambda function"
  type        = number
  default     = 128
}

variable "layers" {
  description = "A list of ARNs of lambda layers to attach to the function"
  type        = list(string)
  default     = []
}

variable "create_function_url" {
  description = "Whether to create a URL for the lambda function"
  type        = bool
  default     = false
}

variable "timeout" {
  description = "The timeout for the lambda function"
  type        = number
  default     = 3
}

variable "tags" {
  description = "A map of tags to assign to the lambda function"
  type        = map(string)
  default     = {}
}
