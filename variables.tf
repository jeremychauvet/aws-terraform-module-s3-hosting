variable "bucket_name" {
  description = "Bucket name where the site is hosted. Must be equal to DNS name. Eg: hello.mysite.com"
  type        = string
}

variable "dns_zone" {
  description = "FQDN DNS zone. Eg: mysite.com"
}

variable "tags" {
  description = "Tags used for billing and RBAC."
  type        = map(string)
}
