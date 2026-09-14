# Architecture Decision Records

Kurz, eine Entscheidung pro Eintrag. Datum = Freeze 2026-09-13.

## ADR-0001 — Hub-Spoke statt Virtual WAN

Status: accepted

Klassisches VNet-Hub-Spoke. vWAN wäre die moderne Folie, macht Routing und Preis undurchsichtiger und ist teurer im Lab. DACH-Ausschreibungen verlangen den klassischen Pfad noch immer 1:1: Peering, UDR, Firewall als Default-Route. vWAN bleibt dokumentierte Alternative, nicht Code.

## ADR-0002 — Azure Firewall Standard, nicht NSG-only / Premium / NVA

Status: accepted

NSG allein inspectiert Spoke-to-Spoke und Egress nicht zentral. Premium (TLS-Inspection, IDPS) und DDoS Network Protection sprengen ein ephemeral Portfolio. NVA (OPNsense/Forti) ist näher an klassischer Infra, aber schlecht destroy-bar und kein Microsoft-Landing-Zone-Signal.

SKU: **Standard**. DNS-Proxy an der Firewall ist vorgesehen (Phase B), damit Spoke-Clients den PE-Namen über die Firewall auflösen können.

## ADR-0003 — Terraform statt Bicep

Status: accepted

Ein Tool für Azure jetzt und AWS später. Markt in Freelance-Ausschreibungen. State und Module sind portabler. Bicep-What-if bleibt die Azure-native Alternative, nicht dieses Repo.

## ADR-0004 — Private Endpoint im Spoke, DNS-Zonen im Hub

Status: accepted

Workload-Spoke besitzt den PE (kein PE-Wildwuchs im Hub, klarer Testpfad). Private DNS Zones liegen zentral im Connectivity-RG und werden an Hub + alle Spokes gelinkt. Hairpin über den Hub entfällt für PaaS, solange der PE lokal im Spoke sitzt.

Alternative (zentraler PE-Subnet im Hub) wäre platform-team-typischer, erzeugt aber extra Hop und kompliziertere effektive Routen. Nicht MVP.

## ADR-0005 — GatewaySubnet als Platzhalter, kein VPN-Gateway

Status: accepted

VPN-Gateway braucht 30–45 Minuten Provisioning und läuft stündlich weiter, wenn Destroy vergessen wird. On-Prem ist hier kein echtes DC. CIDR `10.10.0.0/16` bleibt reserviert. Keine UDR auf `GatewaySubnet` im MVP.

## ADR-0006 — AKS-ready ohne Cluster

Status: accepted

Ziel-Titel enthält Kubernetes, der erste Wurf muss Netz beweisen. Ein Live-AKS überdeckt CIDR, UDR und DNS. Spoke `10.20.32.0/22` ist so geschnitten, dass System-/User-Pool und Ingress später passen. Kein privater API-Server, kein AGIC, kein ACR im Default.

## ADR-0007 — West Europe, strikt ephemeral

Status: accepted

Region `westeurope` (Pair: `northeurope`, Block `10.21.0.0/16` reserviert). Apply → Demo/Screenshot → Destroy. Firewall Standard liegt bei ca. 1,25 USD/h plus Traffic — Monat ohne Destroy ≈ 900 USD vor Traffic. Kein DDoS-Plan, kein Firewall Premium, kein Bastion-Default.

## ADR-0008 — Eine Region, zwei Resource Groups-Welten

Status: accepted

Connectivity (Hub, Firewall, DNS-Zonen) in `rg-conn-hub-weu-01`.  
Workload-Spokes in eigenen RGs (`rg-spoke-app-weu-01`, `rg-spoke-aks-weu-01`).  
Kein Management-Group-Baum, keine ALZ-Policies. Das ist bewusst kein Enterprise-Scale.
