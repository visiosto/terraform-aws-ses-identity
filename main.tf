resource "aws_ses_domain_identity" "this" {
  domain = var.domain
}

resource "aws_ses_domain_dkim" "this" {
  domain = aws_ses_domain_identity.this.domain
}

resource "aws_ses_domain_mail_from" "this" {
  domain           = aws_ses_domain_identity.this.domain
  mail_from_domain = "${var.mail_from_subdomain}.${aws_ses_domain_identity.this.domain}"
}

data "aws_region" "current" {}

locals {
  subdomain           = var.domain == var.zone_name ? "" : trimsuffix(var.domain, ".${var.zone_name}")
  mail_from_subdomain = trimsuffix(aws_ses_domain_mail_from.this.mail_from_domain, ".${var.zone_name}")
  records = {
    (var.zone_name) = merge(
      {
        "mx" = {
          name     = local.mail_from_subdomain
          type     = "MX"
          content  = "feedback-smtp.${data.aws_region.current.name}.amazonses.com"
          priority = 10
          # ttl = 600
        }
        "spf" = {
          name    = local.mail_from_subdomain
          type    = "TXT"
          content = "\"v=spf1 include:amazonses.com ~all\""
          # ttl = 600
        }
      },
      {
        for i in range(3) : "dkim_${i}" => {
          name    = local.subdomain == "" ? "${aws_ses_domain_dkim.this.dkim_tokens[i]}._domainkey" : "${aws_ses_domain_dkim.this.dkim_tokens[i]}._domainkey.${local.subdomain}"
          type    = "CNAME"
          content = "${aws_ses_domain_dkim.this.dkim_tokens[i]}.dkim.amazonses.com"
          # ttl = 600
        }
      },
      var.enable_dmarc_record ? {
        "TXT:_dmarc" = {
          content = "\"v=DMARC1; p=none;\""
          # ttl = 600
        }
      } : {},
    )
  }
}

module "records" {
  source = "github.com/visiosto/terraform-cloudflare-record-set?ref=v0.3.5"

  records = local.records
}
