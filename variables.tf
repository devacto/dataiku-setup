variable "project_id" {
  type        = string
  default     = "dataiku-candidate-vwibisono"
  description = "Project ID to use for cloud resources."
}

variable "ssh_ip" {
  type        = string
  default     = "114.129.19.115"
  description = "IP allowed to SSH."
}
