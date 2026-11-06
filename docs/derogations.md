# Registre des dérogations

| Réf. | Écart au référentiel | Raison | Mesure compensatoire | Test | Revue |
| --- | --- | --- | --- | --- | --- |
| DER-01 | `net.ipv4.ip_forward = 1` (CIS demande 0) | Routage des pods par k3s | Pare-feu en liste blanche ; NetworkPolicy en Prod | TP12 : kernel-param attendu à 1 | À chaque montée de version de k3s |
