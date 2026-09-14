# CIDR-Plan — az-hubspoke-weu

Region: `westeurope`. Ein Raum, dokumentiert nicht-überlappend.  
Kein VNet bekommt `10.0.0.0/8` oder ein anderes /8.

## Blöcke

| Block | Verwendung | Status |
|---|---|---|
| `10.20.0.0/16` | Azure-Lab West Europe (Supernet, nicht als ein VNet) | dokumentiert |
| `10.20.0.0/22` | `vnet-hub-weu-01` | MVP |
| `10.20.16.0/24` | `vnet-spoke-app-weu-01` | MVP |
| `10.20.32.0/22` | `vnet-spoke-aks-weu-01` | MVP, ohne Cluster |
| `10.20.48.0/24` | künftiger Spoke Data | reserviert |
| `10.20.64.0/22` | künftiger Spoke | reserviert |
| `10.21.0.0/16` | Region 2 (`northeurope`, Pair) | reserviert, ungebaut |
| `10.10.0.0/16` | On-Prem-Simulation | reserviert, ungebaut |
| `10.40.0.0/16` | AWS VPC (Second Door) | reserviert, ungebaut |

## Hub `10.20.0.0/22`

Pflichtnamen von Microsoft gelten unverändert.

| Subnet | CIDR | Name in Azure | Deploy im Default |
|---|---|---|---|
| Firewall | `10.20.0.0/26` | `AzureFirewallSubnet` | ja |
| Gateway | `10.20.0.64/27` | `GatewaySubnet` | Subnet ja, Gateway-Ressource nein |
| Bastion | `10.20.0.96/26` | `AzureBastionSubnet` | Subnet ja, Bastion-Ressource nein |
| Shared | `10.20.1.0/24` | `snet-shared` | ja (leer nutzbar) |
| frei | `10.20.2.0/24` | — | nein |
| frei | `10.20.3.0/24` | — | nein |

`AzureFirewallSubnet` mindestens `/26`.  
`GatewaySubnet` mindestens `/27`.  
Dediziertes Bastion mindestens `/26`.

## Spoke App `10.20.16.0/24`

| Subnet | CIDR | Zweck |
|---|---|---|
| `snet-workload` | `10.20.16.0/26` | Test-VM / App |
| `snet-privatelink` | `10.20.16.64/27` | Private Endpoint (Storage) |
| `snet-mgmt` | `10.20.16.96/27` | optional Jump, Default leer |
| Rest | `10.20.16.128/25` | reserviert im VNet |

## Spoke AKS-ready `10.20.32.0/22`

Kein Cluster, keine Delegation-Pflicht für AKS-Node-Subnets. Layout zeigt, dass der Spoke einen Cluster aufnehmen *kann*.

| Subnet | CIDR | Zweck |
|---|---|---|
| `snet-aks-system` | `10.20.32.0/23` | System-Nodepool |
| `snet-aks-user` | `10.20.34.0/24` | User-Nodepool |
| `snet-aks-ingress` | `10.20.35.0/26` | später AGIC / Gateway API |
| `snet-aks-privatelink` | `10.20.35.64/27` | ACR / API-nahe PEs |
| Rest | `10.20.35.96/27`+ | Puffer |

## Routing-Notizen

- Spoke-UDRs: `0.0.0.0/0` → Firewall Private IP.
- Hub-Peering: Spoke ↔ Hub, `allow_forwarded_traffic` am Hub-Peering = true, `allow_gateway_transit` am Hub = true (vorbereitet), Spokes `use_remote_gateways` = false bis ein Gateway existiert.
- Kein Spoke-to-Spoke-Peering.
- `GatewaySubnet` bekommt im MVP **keine** UDR. (Klassische Falle: UDR auf GatewaySubnet + Firewall bricht VPN-Lernpfade.)
