# module dns

Zentrale Private DNS Zones im Hub-RG, Links zu Hub + Spokes.

MVP-Zone: `privatelink.blob.core.windows.net`  
A-Record kommt vom Private Endpoint (env oder kleines PE-Stück), nicht zwingend aus diesem Modul.

Kein Private DNS Resolver im MVP (Conditional Forwarding braucht On-Prem-DNS).
