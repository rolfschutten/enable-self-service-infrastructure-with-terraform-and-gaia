variable "ServiceName" {
  type     = string
  description = "The name of all resources referring to the service name."
  default = "gaia"
}
variable "ServiceNameAlphanumeric" {
  type     = string
  description = "The name of all resources referring to the service name."
  default = "gaia"
}
variable "Location" {
  type    = string
  description = "Resource location"
  default = "westeurope"
}
variable "EnvironmentPrefix" {
  type     = string
  description = "The prefix of all resources referring to environment type. Choose p for production, t for testing and a for acceptance. Only 1 character."
  default = "p"
}
variable "VNetPrefixSecondOctet" {
  type     = number
  description = "The second octet IP address space. For example: if you need a address space of 172.20.8.0/22, choose 20."
  default = 17
}
variable "VNetPrefixThirdOctet" {
  type     = number
  description = "The third octet IP address space. For example: if you need a address space of 172.20.8.0/22, choose 8."
  default = 20
}
