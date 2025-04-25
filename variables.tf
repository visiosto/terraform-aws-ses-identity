variable "domain" {
  description = "The domain name to create the Amazon SES configuration for."
  type        = string

  validation {
    condition     = endswith(var.domain, var.zone_name)
    error_message = "The SES domain must belong to the given DNS zone."
  }
}

variable "enable_dmarc_record" {
  description = "Whether or not to create a DSN record for the DMARC configuration."
  type        = bool
  default     = true
}

variable "mail_from_subdomain" {
  description = "The subdomain to use for the MAIL FROM domain."
  type        = string
  default     = "mail"
}

variable "zone_name" {
  description = "The name of the zone to create the DNS record in."
  type        = string

  validation {
    condition     = length(var.zone_name) > 0
    error_message = "The name of the DNS zone cannot be empty."
  }
}
