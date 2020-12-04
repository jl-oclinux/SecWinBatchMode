# Création d'un paquet SWMB pour OCS Inventory

Nous créons une archive zip contenant un fichier `install.bat`
ainsi que tous les fichiers de l'application SWMB.
Afin de simplifier cette tache, les différentes commandes sont regroupés dans un `Makefile`.
Celles-ci sont plus faciles à utiliser sous GNU/Linux.
```bash
make help
```

Dans le fichier `Makefile`, mettre les variables `VERSION` et `PATCH` aux bonnes valeurs.
Lors de la création de l'archive zip, le script `install.bat` sera automatiquement mis à jour avec ces bonnes valeurs.

Il est possible de faire un `make update` afin de se mettre à jour avec la dernière version proposée par le groupe de travail de RESINFO.
Cette commande est strictement équivalente à un `git pull` à la racine de votre clone SWMB.

Une fois fixées les versions, faites
```
make
```
puis téléverser le zip fournit dans votre serveur OCS Inventory en suivant les réponses que vous indique le `Makefile`.
