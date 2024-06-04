variable "github_org_name" {
  type = string
}

variable "github_repo_name" {
  type = string
}

variable "github_branch_name" {
  type = string
}

variable "entity_type" {
  type          = string
  default       = "environment"
  validation {
    condition = contains(["environment"], var.entity_type)
    error_message = "entity_type must 'environment' at the moment"
  }
}

variable "entity_name" {
  type = string
  default = "demo"
  description = "The name of the github action environment e.g. 'test' or 'prod'"
}