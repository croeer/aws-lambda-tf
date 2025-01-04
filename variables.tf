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
