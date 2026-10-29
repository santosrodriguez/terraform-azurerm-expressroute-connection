resource "random_string" "this" {
  length = 4
  upper = false
  lower = false
  special = false
  numeric = true
}

locals {
  name_suffix = "${var.solution_name}-${var.location}-${var.environment}-${random_string.this.result}"
}

resource "azurerm_express_route_connection" "this" {
  name                             = "erconnection-${local.name_suffix}"
  express_route_gateway_id         = var.express_route_gateway_id
  express_route_circuit_peering_id = azurerm_express_route_circuit_peering.private.id

}
