# block 15.3
resource "yandex_cm_certificate" "cert" {
  name    = "certificate"
  domains = [var.cert_domain_name]

  managed {
    challenge_type  = "DNS_TXT"
  }
}