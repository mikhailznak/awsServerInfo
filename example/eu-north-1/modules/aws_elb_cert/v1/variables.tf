variable "domain_name" {
  type = string
}
variable "validation_method" {
  type    = string
  default = "DNS"
}
variable "tags" {
  type    = map(string)
  default = {}
}
variable "zone_id" {
  type = string
}
variable "ttl" {
  type = number
}