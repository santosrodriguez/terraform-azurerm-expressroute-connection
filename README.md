# ExpressRoute Connection

## Overview

This Terraform module creates an Azure ExpressRoute connection using the `azurerm_express_route_connection` resource. It is intended to connect an existing Virtual WAN ExpressRoute gateway to an ExpressRoute circuit private peering.

The module also creates a random lowercase string that is used as part of the ExpressRoute connection name.

## What This Module Deploys

- One `random_string` resource used for name uniqueness.
- One `azurerm_express_route_connection` resource.
- A generated ExpressRoute connection name using:
  - `solution_name`
  - `location`
  - `environment`
  - random 4-character suffix

## Requirements

| Requirement | Details |
|---|---|
| Required Terraform version | Not explicitly defined. |
| Required providers | `azurerm`, `random` |
| Required provider versions | Not explicitly defined. |
| Azure prerequisites | An existing Virtual WAN ExpressRoute gateway is required. An ExpressRoute circuit private peering is also required. |
| Required permissions or role assumptions | Not explicitly defined. Permissions must allow creating and managing ExpressRoute connections. |

## Required Parameters

| Name | Type | Description |
|---|---|---|
| `environment` | `string` | Environment name. Valid values are `prd` and `nonprd`. |
| `express_route_gateway_id` | `string` | The ID of the Virtual WAN ExpressRoute gateway. |
| `express_route_circuit_peering_id` | `string` | The ID of the ExpressRoute circuit private peering. |
| `location` | `string` | Azure region for resource deployment. Only supported US regions are allowed. |
| `solution_name` | `string` | Short name for the solution. |

## Optional Parameters

| Name | Type | Default | Description |
|---|---|---|---|

This module does not currently define any optional parameters.

## Default Parameter Values

| Parameter | Default Value | Purpose |
|---|---|---|
| `random_string.this.length` | `4` | Creates a 4-character random suffix for the ExpressRoute connection name. |
| `random_string.this.upper` | `false` | Prevents uppercase characters in the random suffix. |
| `random_string.this.special` | `false` | Prevents special characters in the random suffix. |
| `random_string.this.numeric` | `false` | Prevents numeric characters in the random suffix. |
| `local.name_suffix` | `"${var.solution_name}-${var.location}-${var.environment}-${random_string.this.result}"` | Builds the reusable suffix used in the ExpressRoute connection name. |
| `azurerm_express_route_connection.this.name` | `"erconnection-${local.name_suffix}"` | Sets the generated ExpressRoute connection name. |

## Minimum Required Example

```hcl
module "express_route_connection" {
  source = "./modules/express-route-connection"

  environment                      = "nonprd"
  express_route_gateway_id         = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-network-nonprd-eastus-001/providers/Microsoft.Network/expressRouteGateways/ergw-network-nonprd-eastus-001"
  express_route_circuit_peering_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-network-nonprd-eastus-001/providers/Microsoft.Network/expressRouteCircuits/er-circuit-nonprd-eastus-001/peerings/AzurePrivatePeering"
  location                         = "eastus"
  solution_name                    = "network"
}
```

## Full Example

```hcl
module "express_route_connection" {
  source = "./modules/express-route-connection"

  environment                      = "prd"
  express_route_gateway_id         = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-network-prd-eastus-001/providers/Microsoft.Network/expressRouteGateways/ergw-network-prd-eastus-001"
  express_route_circuit_peering_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-network-prd-eastus-001/providers/Microsoft.Network/expressRouteCircuits/er-circuit-prd-eastus-001/peerings/AzurePrivatePeering"
  location                         = "eastus"
  solution_name                    = "network"
}
```

## Outputs

| Name | Description |
|---|---|

This module does not currently define any outputs.

## Best Practices

- Use a short, consistent `solution_name` value because it is included in the generated ExpressRoute connection name.
- Use only the supported `environment` values: `prd` or `nonprd`.
- Use lowercase Azure region names such as `eastus`, `westus2`, or `centralus`.
- Keep production and non-production deployments in separate Terraform states.
- Store Terraform state remotely, such as in an Azure Storage Account, to support collaboration and state locking.
- Validate the `express_route_gateway_id` and ExpressRoute private peering ID before applying the module.
- Limit access to this module through Azure RBAC because ExpressRoute connectivity changes can affect production network routing.
- Use Azure governance controls such as naming standards, resource organization, and policy assignments around the Virtual WAN and ExpressRoute resources.

## Notes

- The module creates a `random_string.this` resource with:
  - `length = 4`
  - `upper = false`
  - `special = false`
  - `numeric = false`
- Because `upper`, `special`, and `numeric` are all disabled, the generated suffix uses lowercase alphabetic characters only.
- The local value `local.name_suffix` is built using the following pattern:

```hcl
"${var.solution_name}-${var.location}-${var.environment}-${random_string.this.result}"
```

- The ExpressRoute connection name is built using the following pattern:

```hcl
"erconnection-${local.name_suffix}"
```

- The `environment` variable includes validation and only allows:
  - `prd`
  - `nonprd`
- The `location` variable includes validation and only allows the following Azure US regions:
  - `eastus`
  - `eastus2`
  - `centralus`
  - `northcentralus`
  - `southcentralus`
  - `westcentralus`
  - `westus`
  - `westus2`
  - `westus3`
- The module defines `express_route_circuit_peering_id`, but the current `azurerm_express_route_connection.this` resource does not reference `var.express_route_circuit_peering_id`.
- The current resource configuration references `azurerm_express_route_circuit_peering.private.id`, but that resource is not defined in the provided module code.
- As provided, the module may fail during Terraform validation or planning unless `azurerm_express_route_circuit_peering.private` is defined elsewhere in the module.
- The module does not define `count`, `for_each`, conditional logic, or dynamic blocks.
- The module does not define tags.
- The module does not define provider version constraints or Terraform version constraints.
- The module does not define outputs.
