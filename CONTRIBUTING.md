# Contribuer à SWMB

## Récupérer le dépot du projet SWMB

Il est préférable de fonctionner avec des clefs SSH plutôt qu'en HTTPS.
Cependant, il ne faut pas oublier de mettre une phrase de passe pour protéger sa clef privé.
Puis, on utlise l'agent SSH pour ne pas avoir à remettre la phrase de passe à chaque fois
(attention à ne pas transmettre vos clefs privés à un agent SSH distant
si vous n'êtes pas sur de ce serveur distant !).

```bash
# Création de la clef
ssh-keygen  -t rsa -b 409 # phrase de passe

# Ajout de la clef dans l'agent
ssh-add ~/.ssh/id_rsa
```

On récupère alors le dépôt SWMB

```bash
git clone git@gitlab.in2p3.fr:resinfo-gt/swmb.git
cd swmb
```

## Synchronisation avec le projet amont

Il faut ajouter le lien avec le subtree amont `Win10-Initial-Setup-Script`
afin de pouvoir gérer les mises à jour.
L'option `--squash` permet de récupérer tous les patchs du projet amont
sous la forme d'un seul commit.
Ainsi on n'importe pas l'ensemble de l'historique dans notre projet.

La commande `subtree pull` permet de faire en une seule étape un `fetch` et un `merge`.

Avant de faire cela, il est préférable de bien penser à pousser (`push`)
tous ses patchs dans l'arbre principal.

```bash
git remote add -f Win10-Initial https://github.com/Disassembler0/Win10-Initial-Setup-Script.git
git subtree add --prefix Win10-Initial-Setup-Script/ Win10-Initial master --squash

git subtree pull --prefix Win10-Initial-Setup-Script/ Win10-Initial master --squash
```

Faire une différence dans un terminal ou en graphique
afin de voir ce qu'il y a de nouveau dans le projet amont.
Dans les commandes suivantes,
à gauche est l'état du projet actuel,
à droite est l'état du projet amont.

```bash
git diff origin/master...HEAD
git difftool origin/master...HEAD
git status
```
Deux cas se présentent alors :
valider ou annuler le développement amont pour cette fois-ci,
car un jour il faudra bien le faire...

### Valider le developpement amont

```bash
git push
```

### Annuler le developpement amont si celui-ci n'est pas au point pour le moment.

Il faudra cependant se mettre à jour pour conserver au maximum la synchronisation opérationnelle.

```bash
git reset HEAD~1
git checkout -- Win10-Initial-Setup-Script/
```

## Fonctionalités avancées

### Inverser l'ordre d'un commit

Il n'est possible de pousser (`push`) ou d'annuler des commits que dans l'ordre
dans lequel ils ont été réalisés.
Si cet ordre ne convient pas,
il est possible de le modifier.

```bash
git rebase -i
```

### Pousser tous les commits sauf le dernier

Si vous aviez un commit qui n'avait pas été poussé,
ou si vous faites un commit après coup (et un coup de rebase pour les réordonner),
il est possible de pousser tous les commits sauf le dernier.

```bash
git push origin HEAD~1:master
```

Évidement, en mettant 2 à la place de 1,
on pousse tous les commits sauf les deux derniers !
