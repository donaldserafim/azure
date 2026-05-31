variable "prefix" {
  type        = string
  description = "Base name used to create Azure resources."
  default     = "azure"
}

variable "location" {
  type        = string
  description = "Azure region."
  default     = "eastus"
}
