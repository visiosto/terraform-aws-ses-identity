# Amazon SES identity Terraform module

Terraform module to create a domain identity in Amazon SES and set up its DNS
records on Cloudflare.

## Requirements

| Name                  | Version  |
| --------------------- | -------- |
| terraform             | >= 1.9.0 |
| hashicorp/aws         | >= 5.0.0 |
| cloudflare/cloudflare | >= 5.0.0 |

## Providers

| Name                  | Version  |
| --------------------- | -------- |
| hashicorp/aws         | >= 5.0.0 |
| cloudflare/cloudflare | >= 5.0.0 |

## Modules

| Name                                     | Version |
| ---------------------------------------- | ------- |
| visiosto/terraform-cloudflare-record-set | 0.3.5   |

## Resources

| Name                          | Type        |
| ----------------------------- | ----------- |
| aws_region.current            | data source |
| aws_ses_domain_dkim.this      | resource    |
| aws_ses_domain_identity.this  | resource    |
| aws_ses_domain_mail_from.this | resource    |

## Inputs

| Name                | Description                                                        | Type     | Default  | Required |
| ------------------- | ------------------------------------------------------------------ | -------- | -------- | :------: |
| domain              | The domain name to create the Amazon SES configuration for         | `string` | `""`     |   yes    |
| enable_dmarc_record | Whether or not to create a DSN record for the DMARC configuration. | `bool`   | `true`   |    no    |
| mail_from_subdomain | The subdomain to use for the MAIL FROM domain                      | `string` | `"mail"` |    no    |
| zone_name           | The name of the zone to create the DNS records in                  | `string` | `""`     |   yes    |

## Outputs

No outputs.
