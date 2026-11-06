# Décisions d'architecture

Les cinq décisions du fil rouge, avec ce qu'elles nous ont coûté dans le labo.

| Réf. | Décision | Commentaire |
| --- | --- | --- |
| ADR-01 | Ansible s'exécute dans la VM ctrl, pas sur le poste hôte | Le poste est sous Linux, mais le labo reste identique pour tout le monde : même Ansible 2.17, mêmes chemins `/vagrant`. On se connecte à ctrl, on ne mélange pas l'outillage de l'hôte. |
| ADR-02 | Un k3s mono-nœud par environnement | Préprod et prod tiennent chacune dans 2 Go. Traefik est fourni. On n'a pas de haute disponibilité du plan de contrôle : un redémarrage de nœud coupe l'API le temps que k3s revienne. |
| ADR-03 | Les variables `nova_*` sont le contrat partagé | L'inventaire alimente le rôle `nova_release`, les valeurs Helm et les attendus Goss. Changer `nova_replicas` change le déploiement et l'audit ensemble. `jinja2_native` est nécessaire pour que les entiers restent des entiers dans le schéma Helm. |
| ADR-04 | Helm tourne sur le nœud, avec le kubeconfig local de k3s | On ne copie pas de kubeconfig vers ctrl. La limite vue au TP13 : Helm compare sa révision, pas le cluster vivant. Un `kubectl scale` manuel n'est pas corrigé par un simple rejeu. |
| ADR-05 | Goss pour l'audit | Un binaire, un YAML, un verdict. Goss 0.4.9 ne voit pas l'écoute IPv6 de l'API ni le port 80, qui est un DNAT : ces deux contrôles sont des commandes (`ss` et `curl`), pas des ressources `port`. |

La dérogation DER-01 est dans [derogations.md](derogations.md) : `net.ipv4.ip_forward` reste à 1 parce que k3s route les pods.
