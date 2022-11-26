resource "azurerm_dns_zone" "public_dns" {
  name                = var.domain_name
  resource_group_name = var.resource_group_name
}

resource "azurerm_dns_a_record" "a_record" {
  name                = var.a_record_name
  zone_name           = azurerm_dns_zone.public_dns.name
  resource_group_name = azurerm_dns_zone.public_dns.resource_group_name
  ttl                 = 300
  records             = [var.a_record_ip]
}