# Architecture du laboratoire

Trois machines VirtualBox, réseau hôte 192.168.56.0/24.

| Machine | IP | Rôle |
| --- | --- | --- |
| ctrl | 192.168.56.10 | Ansible, Vault, clés SSH. Ne fait pas tourner l'application. |
| preprod | 192.168.56.21 | k3s, 1 réplica, sans NetworkPolicy. Comptes alice et bob. |
| prod | 192.168.56.22 | k3s, 2 réplicas, NetworkPolicy. Compte bob seul. |

```mermaid
flowchart LR
  hote["Hôte 192.168.56.1"]
  ctrl["ctrl 192.168.56.10"]
  pre["preprod .21"]
  prod["prod .22"]
  hote -->|HTTP 80| pre
  hote -->|HTTP 80| prod
  ctrl -->|SSH 22, HTTP 80, API 6443| pre
  ctrl -->|SSH 22, HTTP 80, API 6443| prod
  pre -.->|SSH 22 refusé| prod
```

Flux voulus par ufw : entrant refusé, puis une liste blanche. SSH n'est ouvert que depuis ctrl et le NAT Vagrant. L'API Kubernetes n'est ouverte que depuis ctrl. Le HTTP du smoke test vient de ctrl et de l'hôte.

Limite mesurée au TP14 : depuis la préprod, le port 22 de la prod est fermé, mais le port 80 répond. kube-proxy accepte le service dans `INPUT` avant la chaîne ufw.

Outils : Vagrant décrit les VM, Ansible décrit le socle et pilote Helm, Helm décrit l'application, Goss relit l'état réel.
