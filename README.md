 tcl-eva
Services IRC en TCL Eva
- [1. Installation](#1-installation)
	- [1. Upload du dossier Eva](#1-upload-du-dossier-eva)
	- [2. Configuration de l'eggdrop](#2-configuration-de-leggdrop)
	- [3. Configuration de Eva Service](#3-configuration-de-eva-service)
	- [4. Configuration de UnrealIRCd](#4-configuration-de-unrealircd)
- [2. support](#2-support)
- [3. Greets](#3-greets)
##Vous pouvez trouver les sources de Eva Service sur :
```
https://github.com/MalaGaM/tcl-eva
```
# 1. Installation
## 1. Upload du dossier Eva
Première étape, uploadez le dossier Eva en entier dans votre eggdrop ( scripts/Eva - src/Eva ).
```
git clone https://github.com/MalaGaM/tcl-eva /home/votre-dossier/eggdrop/scripts/Eva
```

## 2. Configuration de l'eggdrop
Deuxieme étape, ouvrez le fichier de configuration de votre eggdrop "eggdrop.conf" et ajoutez la ligne ci-dessous :
```
source votre-dossier/scripts/Eva/Eva.tcl
```

## 3. Configuration de Eva Service
Troisième étape, ouvrez le fichier "Eva.conf" et configurez celui-ci en fonction de votre Link, IP, Port etc.. . Une fois fini sauvegardez le (et uploadez le).

## 4. Configuration de UnrealIRCd
Quatrième étape, il vous suffit de configurer le link dans votre fichier "unrealircd.conf" en fonction de la configuration que vous aurez réalisée dans "Eva.conf". Une fois celui-ci configuré, (uploadez le sur votre shell et) rechargez la configuration de votre serveur IRC ( /rehash ).

Cinquième étape, connectez vous en party-line avec votre eggdrop puis tapez les deux commandes suivantes :
```
.rehash
.evaconnect
```

Si Eva Service ne se connecte pas, activez le mode debug depuis la party-line ( .evadebug on ) pour voir les erreurs directement dans le fichier "/logs/Eva.debug".

Mode super debug changer dans eva.conf "set eva(sdebug) 0" en mettant 1 a la place de 0

# 2. support
Signalez tout bugs, toutes idées
[tickets/support]([#4-configuration-de-unrealircd](https://github.com/MalaGaM/tcl-eva/issues))

# 3. Greets
TiSMA de Exolia.net pour le code d'origine
Amandine de eggdrop.Fr pour son aide/idées

