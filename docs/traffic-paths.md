# Traffic-Pfade — az-hubspoke-weu

Was das Repo beweisen muss. Jeder Pfad mit Failure-Mode.

## 1. Spoke → Internet

Soll: Packet verlässt Spoke, trifft UDR `0.0.0.0/0`, geht zur Firewall, SNAT auf Firewall-PIP, raus.

Wenn UDR fehlt: Spoke nutzt Azure-Default-Internet. Firewall sieht nichts. Portfolio-Aussage tot.

Wenn Peering fehlt: Route next-hop unerreichbar.

Test: `az vm run-command` auf Spoke-VM, `curl -sI https://example.com`. Firewall-Log zeigt Allow + SNAT.

## 2. Spoke App → Spoke AKS

Soll: nicht-transitives Peering. Traffic Hub → Firewall → Ziel-Spoke.

Wenn jemand Spoke-to-Spoke-Peering setzt: Pfad umgeht Inspection. Genau das darf das Diagramm nicht hergeben.

Test: zweite Test-NIC oder zweite Mini-VM im AKS-Subnet (optional, nicht Default). Ohne VM: effektive Routen an `snet-aks-system` zeigen Next-Hop Firewall.

## 3. Spoke → Azure PaaS (Storage)

Soll: Private Endpoint in `snet-privatelink`. Name `*.blob.core.windows.net` löst privat auf (Private DNS Zone im Hub, Link an alle VNets). Traffic bleibt im Microsoft-Backbone, nicht über öffentliches Blob.

Entscheidung: PE im Spoke, Zone zentral. Siehe `DECISIONS.md` ADR-0004.

Wenn Zone-Link am Spoke fehlt: öffentliche IP, oft Timeout oder Policy-Konflikt.

Test: `nslookup <sa>.blob.core.windows.net` von der Spoke-VM → 10.20.16.x. Danach `curl` auf ein Test-Blob.

## 4. On-Prem → Spoke (nur dokumentiert)

Soll-Pfad später: Gateway im Hub → (bewusst) Firewall oder direkt, je nach UDR auf GatewaySubnet.

MVP: Subnet existiert, keine Gateway-SKU. README beschreibt die Falle, Code setzt keine UDR auf `GatewaySubnet`.

## 5. Management

Keine Public IPs auf Workload-VMs.  
Kein Bastion im Default (Subnet reserviert).  
Demo-Zugriff: Azure Serial Console oder `run-command`.

## Effektive Routen — Checkliste nach Apply

| Quelle | Präfix | Next Hop | Erwartung |
|---|---|---|---|
| `snet-workload` | `0.0.0.0/0` | VirtualAppliance = FW-IP | ja |
| `snet-workload` | `10.20.0.0/22` | VNet-Peering | ja |
| `snet-workload` | `10.20.32.0/22` | VirtualAppliance = FW-IP | ja (nicht Peering) |
| `AzureFirewallSubnet` | Internet | Internet / PIP | SNAT |
| `GatewaySubnet` | (keine Custom 0/0) | Azure-Default | ja |
