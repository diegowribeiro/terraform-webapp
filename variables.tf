variable tenant_id {
  type    = "string"
}

variable application_id {
  type    = "string"
}


variable object_id {
  type    = "string"
}

variable "PlanName" {
  type    = "string"
}
variable "PlanRGName" {
  type    = "string"
}

variable "env" {
  type    = "string"
}

variable "Project" {
  type    = "string"
}

variable "AzureRegion" {
  type    = "string"
  default = "Brazil South"
}

variable "tags" {
  description = "Tags associadas aos recursos criados na Azure."
  type        = "map"

  default = {
    Maintenance = "<Mantainer>"
    Area        = "<Area>"
    Frente      = "DevOps"
    Provisioner = "Terraform"
  }
}