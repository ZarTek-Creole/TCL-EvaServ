 tcl-eva
Services IRC "Eva" en TCL/Eggdrop
- [1. Installation / Configuration](#1-installation--configuration)
			- [1.1 Récuperer le code Eva](#11-récuperer-le-code-eva)
			- [1.2 Configuration de l'eggdrop](#12-configuration-de-leggdrop)
			- [1.3 Configuration de Eva Service](#13-configuration-de-eva-service)
			- [1.4 Configuration de votre IRCD (UnrealIRCd 5 et +)](#14-configuration-de-votre-ircd-unrealircd-5-et-)
			- [1.5 Rehashez votre eggdrop](#15-rehashez-votre-eggdrop)
- [2. Un peu plus loin](#2-un-peu-plus-loin)
			- [2.1 Debug general](#21-debug-general)
			- [2.2 Debug Socket/Link](#22-debug-socketlink)
- [3. Support](#3-support)
			- [3.1 Tickets](#31-tickets)
			- [3.2 IRC](#32-irc)
- [4. Greets](#4-greets)
##Vous pouvez trouver les sources de Eva Service sur :
```
https://github.com/MalaGaM/tcl-eva
```
# 1. Installation / Configuration
#### 1.1 Récuperer le code Eva
Première étape, télécharger le code, le mettre dans votre répertoire scripts/
Exemple pour ```/home/votre-dossier/eggdrop/scripts/Eva```
```
git clone https://github.com/MalaGaM/tcl-eva /home/votre-dossier/eggdrop/scripts/Eva
```
ou 
```
wget https://github.com/MalaGaM/tcl-eva/archive/refs/heads/main.zip -O Eva.zip
unzip Eva.zip -d /home/votre-dossier/eggdrop/scripts/Eva
```

#### 1.2 Configuration de l'eggdrop
Deuxieme étape, ouvrez le fichier de configuration de votre eggdrop ```eggdrop.conf``` et ajoutez la ligne ci-dessous :
```
source /home/votre-dossier/eggdrop/scripts/Eva/Eva.tcl
```

#### 1.3 Configuration de Eva Service
Troisième étape, renommez le fichier ```Eva.example.conf``` en ```Eva.conf``` et configurez celui-ci en fonction de votre serveur IRC

####  1.4 Configuration de votre IRCD (UnrealIRCd 5 et +)
Quatrième étape, il vous suffit de configurer le link dans votre fichier "unrealircd.conf" en fonction de la configuration que vous aurez réalisée dans "Eva.conf". 

[Comment créer un link Service sur UnrealIRCd](http://www.exolia.fr/guide-lire-11.html)

####  1.5 Rehashez votre eggdrop
Cinquième étape, connectez vous en party-line avec votre eggdrop puis tapez les deux commandes suivantes :
```
.rehash
.evaconnect
```

# 2. Un peu plus loin
#### 2.1 Debug general
Si Eva Service ne se connecte pas, activez le mode debug depuis la party-line  pour voir les erreurs directement dans le fichier "logs/Eva.debug".
```
.evadebug on 
```
#### 2.2 Debug Socket/Link
Pour activer le mode *socket debug* changer la valeur ```eva(sdebug)``` dans ```eva.conf``` en mettant 1 a la place de 0.


# 3. Support
#### 3.1 Tickets
Signalez tout bugs, toutes idées :
* [Creez un ticket]([#4-configuration-de-unrealircd](https://github.com/MalaGaM/tcl-eva/issues))

#### 3.2 IRC
Vous pouvez me contacter sur IRC :

* [irc.epiknet.org 6667 #eggdrop](irc://irc.epiknet.org:6667/#eggdrop)
* [irc.epiknet.org +6697 #eggdrop](irc://irc.epiknet.org:+6697/#eggdrop)
# 4. Greets
* TiSMA de Exolia.net pour le code d'origine
* Amandine de eggdrop.Fr pour son aide/idées/testes/..
* MenzAgitat car dans mes developpements il y a toujours des astuces/maniere de faire fournis par MenzAgitat ou bout code de MenzAgitat

