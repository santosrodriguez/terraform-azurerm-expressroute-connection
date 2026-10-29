variable "environment" {
  type = string
  validation {
    condition = contains(
      ["prd", "nonprd"], var.environment
    )
    error_message = "Error: Valid environments are prd and nonprd"
  }
}

variable "express_route_gateway_id" {
  description = "The ID of the Virtual WAN ExpressRoute gateway."
  type        = string
}

variable "express_route_circuit_peering_id" {
  description = "The ID of the ExpressRoute circuit private peering."
  type        = string
}


variable "location" {
  type        = string
  description = "Azure region for resource deployment. Only US regions are allowed."

  validation {
    condition = contains([
      "eastus",
      "eastus2",
      "centralus",
      "northcentralus",
      "southcentralus",
      "westcentralus",
      "westus",
      "westus2",
      "westus3"
    ], lower(var.location))

    error_message = "Location must be a valid Azure US region: eastus, eastus2, centralus, northcentralus, southcentralus, westcentralus, westus, westus2, or westus3."
  }
}


variable "solution_name" {
  description = "Short name for solution"
  type        = string
}
