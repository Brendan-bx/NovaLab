# Audit après reconstruction

Second passage de `make all`, le 06/11/2026, après l'ajout de la cible `base`. Durée : 84,37 s. Code de retour : 0.

| Nœud | Socle | k3s |
| --- | --- | --- |
| preprod | 28 contrôles, Failed 0 | 12 contrôles, Failed 0 |
| prod | 28 contrôles, Failed 0 | 14 contrôles, Failed 0 |

Les deux pages répondent : Application v1.0.0.

Le premier `make all` (281,70 s), sans le rôle `common`, laissait chrony arrêté. Le socle affichait alors 28 contrôles et Failed 2 sur les deux nœuds. La couche k3s était déjà conforme.
