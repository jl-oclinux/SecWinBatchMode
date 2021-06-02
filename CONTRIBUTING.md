# Contributing to SWMB

## Contents
 - [Maintaining own forks](#maintaining-own-forks)
 - [Contribution guidelines](#contribution-guidelines)
 - [Windows builds overview](#windows-builds-overview)


## Maintaining own forks

### Récupérer le dépot du projet SWMB

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

### Synchronisation avec le projet amont

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

#git subtree pull --prefix Win10-Initial-Setup-Script/ Win10-Initial master --squash
git subtree pull --prefix Win10-Initial-Setup-Script/ https://github.com/Disassembler0/Win10-Initial-Setup-Script.git master --squash
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

#### Valider le developpement amont

```bash
git push
```

#### Annuler le developpement amont si celui-ci n'est pas au point pour le moment.

Il faudra cependant se mettre à jour pour conserver au maximum la synchronisation opérationnelle.

```bash
git reset HEAD~1
git checkout -- Win10-Initial-Setup-Script/
```

### Fonctionalités avancées

#### Inverser l'ordre d'un commit

Il n'est possible de pousser (`push`) ou d'annuler des commits que dans l'ordre
dans lequel ils ont été réalisés.
Si cet ordre ne convient pas,
il est possible de le modifier.

```bash
git rebase -i
```

#### Pousser tous les commits sauf le dernier

Si vous aviez un commit qui n'avait pas été poussé,
ou si vous faites un commit après coup (et un coup de rebase pour les réordonner),
il est possible de pousser tous les commits sauf le dernier.

```bash
git push origin HEAD~1:master
```

Évidement, en mettant 2 à la place de 1,
on pousse tous les commits sauf les deux derniers !


## Contribution guidelines

Following is a list of rules which I'm trying to apply in this project.
The rules are not binding and I accept pull requests even if they don't adhere to them, as long as their purpose and content are clear.
In cases when there are too many rule violations, I might simply redo the whole functionality and reject the PR while still crediting you.
If you'd like to make my work easier, please consider adhering to the following rules too.

### Function naming
Try to give a function a meaningful name up to 25 characters long, which gives away the purpose of the function.
Use verbs like `Enable`/`Disable`, `Show`/`Hide`, `Install`/`Uninstall`, `Add`/`Remove` in the beginning of the function name.
In case the function doesn't fit any of these verbs, come up with another name,
beginning with the verb `Set`, which indicates what the function does, e.g. `SetCurrentNetworkPrivate` and `SetCurrentNetworkPublic`.

### Revert functions
Always add a function with opposite name (or equivalent) which reverts the behavior to default.
The default is considered freshly installed Windows 10 or Windows Server 2016 / 2019 with no adjustments made during or after the installation.
If you don't have access to either of these, create the revert function to the best of your knowledge and I will fill in the rest if necessary.

### Function similarities
Check if there isn't already a function with similar purpose as the one you're trying to add.
As long as the name and objective of the existing function is unchanged, feel free to add your tweak to that function rather than creating a new one.

### Function grouping
Try to group functions thematically.
There are already several major groups (privacy, security, services etc.), but even within these, some tweaks may be related to each other.
In such case, add a new tweak below the existing one and not to the end of the whole group.

### Default preset
Always add a reference to the tweak and its revert function in the *Default.preset*.
Add references to both functions on the same line (mind the spaces) and always comment out the revert function.
Whether to comment out also the tweak in the default preset is a matter of personal preference.
The rule of thumb is that if the tweak makes the system faster, smoother, more secure and less obtrusive, it should be enabled by default.
Usability has preference over performance (that's why e.g. indexing is kept enabled).

### Repeatability
Unless applied on unsupported system, all functions have to be applicable repeatedly without any errors.
When you're creating a registry key, always check first if the key doesn't happen to already exist.
When you're deleting registry value, always append `-ErrorAction SilentlyContinue` to prevent errors while deleting already deleted values.

### Input / output hiding
Suppress all output generated by commands and cmdlets using `| Out-Null` or `-ErrorAction SilentlyContinue` where applicable.
Whenever an input is needed, use appropriate arguments to suppress the prompt and programmatically provide values for the command to run
(e.g. using `-Confirm:$false`).
The only acceptable output is from the `Write-Output` cmdlets in the beginning of each function and from non-suppressible cmdlets like `Remove-AppxPackage`.

### Registry
Create the registry keys only if they don't exist on fresh installation if Windows 10 or Windows Server 2016 / 2019.
When deleting registry, delete only registry values, not the whole keys.
When you're setting registry values, always use `Set-ItemProperty` instead of `New-ItemProperty`.
When you're removing registry values, choose either `Set-ItemProperty` or `Remove-ItemProperty` to reinstate the same situation
as it was on the clean installation.
Again, if you don't know what the original state was, let me know in PR description and I will fill in the gaps.
When you need to use `HKEY_USERS` registry hive, always add following snippet before the registry modification to ensure portability.

```powershell
If (!(Test-Path "HKU:")) {
    New-PSDrive -Name HKU -PSProvider Registry -Root HKEY_USERS | Out-Null
}
```

### Force usage
Star Wars jokes aside, don't use `-Force` option unless absolutely necessary.
The only permitted case is when you're creating a new registry key (not a value) and you need to ensure that all parent keys will be created as well.
In such case always check first if the key doesn't already exist, otherwise you will delete all its existing values.

### Comments
Always add a simple comment above the function briefly describing what the function does,
especially if it has an ambiguous name or if there is some logic hidden under the hood.
If you know that the tweak doesn't work on some editions of Windows 10 or on Windows Server, state it in the comment too.
Add a `Write-Output` cmdlet with the short description of action also to the first line of the function body,
so the user can see what is being executed and which function is the problematic one whenever an error occurs.
The comment is written in present simple tense, the `Write-Output` in present continuous with ellipsis (resp. three dots) at the end.

### Coding style
Indent using tabs, enclose all string values in double quotes (`"`) and strictly use `PascalCase` wherever possible.
Put opening curly bracket on the same line as the function name or condition, but leave the closing bracket on a separate line for readability.

### Examples

**Naming example**: Consider function `EnableFastMenu`.
What does it do? Which menu? How fast is *fast*?
A better name might be `EnableFastMenuFlyout`, so it's a bit clearer that we're talking about the menu flyouts delays.
But the counterpart function would be `DisableFastMenuFlyouts` which is not entirely true.
We're not *disabling* anything, we're just making it slow again. So even better might be to name them `SetFastMenuFlyouts` and `SetSlowMenuFlyouts`.
Or better yet, just add the functionality to already existing `SetVisualFXPerformance`/`SetVisualFXAppearance`.
Even though the names are not 100% match, they aim to tweak similar aspects and operate within the same registry keys.

**Coding example:** The following code applies most of the rules mentioned above (naming, output hiding, repeatability, force usage, comments and coding style).

```powershell
# Enable some feature
Function EnableSomeFeature {
	Write-Output "Enabling some feature..."
	If (!(Test-Path "HKLM:\Some\Registry\Key")) {
		New-Item -Path "HKLM:\Some\Registry\Key" -Force | Out-Null
	}
	Set-ItemProperty -Path "HKLM:\Some\Registry\Key" -Name "SomeValueName" -Type String -Value "SomeValue"
}

# Disable some feature
Function DisableSomeFeature {
	Write-Output "Disabling some feature..."
	Remove-ItemProperty -Path "HKLM:\Some\Registry\Key" -Name "SomeValueName" -ErrorAction SilentlyContinue
}
```


## Windows builds overview

See [Windows 10 version history](https://en.wikipedia.org/wiki/Windows_10_version_history)

| Version |        Code name        |     Marketing name     | Build |
| :-----: | ----------------------- | ---------------------- | :---: |
|  1507   | Threshold 1 (TH1 / RTM) | N/A                    | 10240 |
|  1511   | Threshold 2 (TH2)       | November Update        | 10586 |
|  1607   | Redstone 1 (RS1)        | Anniversary Update     | 14393 |
|  1703   | Redstone 2 (RS2)        | Creators Update        | 15063 |
|  1709   | Redstone 3 (RS3)        | Fall Creators Update   | 16299 |
|  1803   | Redstone 4 (RS4)        | April 2018 Update      | 17134 |
|  1809   | Redstone 5 (RS5)        | October 2018 Update    | 17763 |
|  1903   | 19H1                    | May 2019 Update        | 18362 |
|  1909   | 19H2                    | November 2019 Update   | 18363 |
|  2004   | 20H1                    | May 2020 Update        | 19041 |
|  20H2   | 20H2                    | October 2020 Update    | 19042 |
|  21H1   | 21H1                    | May 2021 Update        | 19043 |
