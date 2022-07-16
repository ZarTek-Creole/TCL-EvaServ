<span class="badge-opencollective"><a href="https://github.com/ZarTek-Creole/DONATE" title="Donate to this project"><img src="https://img.shields.io/badge/open%20collective-donate-yellow.svg" alt="Open Collective donate button" /></a></span>
[![CC BY 4.0][cc-by-shield]][cc-by]

[cc-by]: http://creativecommons.org/licenses/by/4.0/
[cc-by-shield]: https://img.shields.io/badge/License-CC%20BY%204.0-lightgrey.svg
<!-- PROJECT LOGO -->
<br />
<p align="center">
  <a href="github.com/ZarTek-Creole/TCL-Eva-Service">
    <img src="https://upload.wikimedia.org/wikipedia/commons/6/6c/IRC_Logo_Small-01_%281%29.png" alt="Logo" width="80" height="80">
  </a>

  <h3 align="center">Eva - IRC Services</h3>

  <p align="center">
    Services IRC "EvaServ" en TCL/Eggdrop
     <br />
    !!! VERSION ALPHA !!!
    <br />
    <a href="github.com/ZarTek-Creole/TCL-Eva-Service"><strong>Explorez les documents </strong></a>
    <br />
    <br />
    <a href="github.com/ZarTek-Creole/TCL-Eva-Service/issues">Reportez un Bug</a>
    ·
    <a href="github.com/ZarTek-Creole/TCL-Eva-Service/issues">Proposez une amélioration</a>
    ·
    <a href="github.com/ZarTek-Creole/TCL-Eva-Service/wiki">Wiki / Documentation</a>
  </p>
</p>

<!-- TABLE OF CONTENTS -->
<details open="open">
  <summary>Table des matières</summary>
  <ol>
    <li>
      <a href="#about-the-project">À propos du projet</a>
    </li>
    <li>
      <a href="#getting-started"> Commencez</a>
      <ul>
        <li><a href="#prerequisites"> Conditions préalables</a></li>
        <li><a href="#installation">Installation / Configuration</a></li>
      </ul>
    </li>
    <li><a href="#usage"> Utilisation</a></li>
    <li><a href="#roadmap"> Feuille de route</a></li>
    <li><a href="#contributing">Contributions</a></li>
    <li><a href="#license">License</a></li>
    <li><a href="#contact">Contact</a></li>
    <li><a href="#acknowledgements">Remerciements</a></li>
  </ol>
</details>

<!-- ABOUT THE PROJECT -->
## A propos EvaServ

EvaServ est un ensemble de Services IRC écris en TCL et fonctionnant avec un [eggdrop (v1.9+)](http://www.eggheads.org/) pour la gestion de votre réseau IRC.
Il a été testé sur un [Unrealircd (v5.0+)](https://www.unrealircd.org/) qui utilise les nouveaux protocoles IRC, il est compatible avec la nouvelle génération de serveurs d'IRCD.

Par défaut Evaserv à 4 niveaux de rôles  : Utilisateur (niveau 0 : aucun), Helpeur (1), Géofront (2), Ircop (3), Admin (4).
Chaque niveau supérieur hérite des privilèges des niveaux inférieurs. chaque niveau donne droit à de nouvelles fonctionnalités (commandes) :
* Gestion des utilisateurs (vhost, interdire des accès,...)
* Gestion des salons (interdire la création, enregistrer...)
* Gestion des clients (interdire certaines ips; version de client, hostname, ident..)
* Gestion des serveurs connectés.

### Prérequis
* [eggdrop (v1.9+)](http://www.eggheads.org/)
* [Unrealircd (v5.0+)](https://www.unrealircd.org/)
  * Serveur IRC nouveau protocol
* [Package TCL: IRCServices (v0.0.1+)](https://github.com/ZarTek-Creole/TCL-PKG-IRCServices)
* [Package TCL: ZCT (v0.0.1+)](https://github.com/ZarTek-Creole/TCL-ZCT)
* [Client Git](https://git-scm.com/downloads) ** Fortement recommandé **
* [tcllib](https://github.com/tcltk/tcllib)
* [tcl-tls](https://core.tcl-lang.org/tcltls/home)

### Installation
1.1.  Récupérez le code EvaServ
1.1.1 Première étape, vérifiez que les dépendances sont installées et présentes : https://github.com/ZarTek-Creole/TCL-EvaServ#pr%C3%A9requis

1.1.2 Téléchargez EvaServ
Téléchargez le code d'EvaServ dans votre répertoire scripts/ de votre eggdrop

Exemple ```/home/votre-dossier/eggdrop/scripts/EvaServ```
```
git clone --recurse-submodules  https://github.com/ZarTek-Creole/TCL-Eva-Service /home/votre-dossier/eggdrop/scripts/EvaServ
```
ou 
```
wget github.com/ZarTek-Creole/TCL-Eva-Service/archive/refs/heads/main.zip -O EvaServ.zip
unzip EvaServ.zip -d /home/votre-dossier/eggdrop/scripts/EvaServ
```

1.2. Configuration de l'eggdrop
Deuxième étape, ouvrez le fichier de configuration de votre eggdrop ```eggdrop.conf``` et ajoutez la ligne ci-dessous :
```
source /home/votre-dossier/eggdrop/scripts/Eva/EvaServ.tcl
```
Si vous devez charger des dépendances pensez à le mettre au dessus de EvaServ.tcl dans votre fichier eggdrop.conf

1.3.  Configuration de Eva Service
Troisième étape, renommez le fichier ```Eva.example.conf``` en ```EvaServ.conf``` et configurez celui-ci en fonction de votre serveur IRCD

1.4.  Configuration de votre IRCD (UnrealIRCd 5 et +)
Quatrième étape, il vous suffit de configurer le link dans votre fichier "unrealircd.conf" en fonction de la configuration que vous aurez réalisé dans "EvaServ.conf". 

## Comment créer un link EvaServ sur UnrealIRCd

Afin de réaliser votre link EvaServ, veuillez vérifier si vous disposez d'un port dédié pour vos links ( plusieurs listen ) ou bien d'un mono port ( un seul listen ) :  

### Port dédié 
```
listen IP-serveur:port-dedie {  
    options {  
		serversonly;  
	};  
};  
```  
###  Ou Mono Port 
```
listen IP-serveur:mono-port;
```
  
### Ajoutez la uline
```
ulines {  
EvaServ.nom-de-domaine.fr;  
...  
...  
};
```
### Ajoutez le link
```
link EvaServ.nom-de-domaine.fr {  
	username *;  
	hostname IP-link;  
	bind-ip *;  
	port Port-link;  
	hub *;  
	password-connect "mot-de-passe-link";  
	password-receive "mot-de-passe-link";  
	class servers;  
};
```
Enregistrez le fichier de configuration. N'oubliez pas de _Rehash_ votre serveur.  
```/rehash```

## Comment créer un link EvaServ sur InspIRCd

Afin de réaliser votre link Serveur ou Service, veuillez vérifier que vous disposez bien du _bind servers_ ci-dessous :  
```
 <bind address="IP-serveur" port="port-dedie" type="servers"> 
```
### _Link Serveur_  
  
* Serveur 1  
```
  <link name="irc2.domaine.tld" ipaddr="10.0.0.2" port="7000" autoconnect="60" hidden="no" sendpass="mot-de-passe" recvpass="mot-de-passe">
``` 
* Serveur 2  
```
  <link name="irc1.domaine.tld" ipaddr="10.0.0.1" port="7000" hidden="no" sendpass="mot-de-passe" recvpass="mot-de-passe">
  ```

* Link Service  
```
<link name="EvaServ.domaine.tld" ipaddr="10.0.0.1" port="7000" allowmask="10.0.0.1" sendpass="mot-de-passe" recvpass="mot-de-passe">  

<uline server="Service.domaine.tld" silent="no">
```
 
Attention afin de réaliser votre link veuillez vérifier que votre configuration comporte bien le module ci dessous :  
```
<module name="m_spanningtree.so">
```
# Premier lancement
Lors du premier lancement, aucun compte utilisateur n'existe, pour créer votre compte vous devez vous identifier
```msg EvaServ auth [Votre pseudo voulu] <votre mot de passe voulu>```
Cela aura comme effet de vous créer un compte de niveau 4 (Admin) par défaut
2. Un peu plus loin
2.1. Débug général
Si Eva Service ne se connecte pas, activez le mode debug depuis la party-line.
2.2. Debug Socket/Link
Pour activer le mode *socket debug* changez la valeur ```SERVICE(mode_debug)``` dans votre fichier ```EvaServ.conf``` en mettant 1 a la place de 0.
<!-- USAGE EXAMPLES -->
## Usage

Avant de l'utiliser prenez conscience que EvaServ se compose de deux éléments distincts : 
* Votre eggdrop
* Le service EvaServ
Votre eggdrop permet de charger les services Eva et annoncer sur votre salon services ```SERVICE_BOT(channel)``` des informations de l'utilisation.
Tandis que le service Eva (bot séparer sur irc) est le service en lui-même ou les commandes seront envoyées

Pour obtenir de l'aide
```/msg <nom d'eva> help```

Pour vous identifier
```/msg <nom d'eva> auth <mot de passe>```

<!-- ROADMAP -->
## Roadmap

Voir les [problèmes en suspens](https://github.com/ZarTek-Creole/TCL-EvaServ/issues) pour une liste des fonctionnalités proposées (et des problèmes connus).

<!-- CONTRIBUTING -->
## Contributions

Les contributions sont ce qui font de la communauté open source un endroit incroyable pour apprendre, inspirer et créer. Toute contribution que vous apportez est ** grandement appréciée **.
1. Forkez le projet
2. Créez votre branche de fonctionnalités (`git checkout -b feature/AmazingFeature`)
3. Validez vos modifications (`git commit -m 'Add some AmazingFeature'`)
4. Poussez vers la branche (`git push origin feature/AmazingFeature`)
5. Ouvrez une [Pull Request](https://github.com/ZarTek-Creole/TCL-Eva-Service/pulls)

<!-- LICENSE -->
## License

Distributed under the SoonDecision License. See `LICENSE` for more information.

<!-- CONTACT -->
## Contact

ZarTek - [@ZarTek](github.com/ZarTek-Creole) 

Lien du projet : [https://github.com/ZarTek-Creole/TCL-Eva-Service](https://github.com/ZarTek-Creole/TCL-Eva-Service)

1. Tickets
Signalez tout bug, proposez toute idée :
* [Créez un ticket]([#4-configuration-de-unrealircd](https://github.com/ZarTek-Creole/TCL-Eva-Service/issues))

2. IRC
Vous pouvez me contacter sur IRC :

   * [irc.extra-cool.fr:+6697 #Extra-Cool](irc://irc.extra-cool.fr:+6697/#Extra-Cool) 
   * [irc.libera.chat:+6697 #Zartek](irc://irc.libera.chat:+6697/#Zartek)

<!-- ACKNOWLEDGEMENTS -->
## Remerciements
* TiSMA de Exolia.net pour le code d'origine
* Amandine de eggdrop.Fr pour son aide/idées/tests/..
* MenzAgitat car dans mes développements il y a toujours des astuces/manière de faire, fournis par MenzAgitat ou bout code de MenzAgitat

<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[contributors-shield]: https://img.shields.io/github/contributors/ZarTek/TCL-Eva-Service.svg?style=for-the-badge
[contributors-url]: https://github.com/ZarTek-Creole/TCL-Eva-Service/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/ZarTek/TCL-Eva-Service.svg?style=for-the-badge
[forks-url]: https://github.com/ZarTek-Creole/TCL-Eva-Service/network/members
[stars-shield]: https://img.shields.io/github/stars/ZarTek/TCL-Eva-Service.svg?style=for-the-badge
[stars-url]: https://github.com/ZarTek-Creole/TCL-Eva-Service/stargazers
[issues-shield]: https://img.shields.io/github/issues/ZarTek/TCL-Eva-Service.svg?style=for-the-badge
[issues-url]: https://github.com/ZarTek-Creole/TCL-Eva-Service/issues
[license-shield]: https://img.shields.io/github/license/ZarTek/TCL-Eva-Service.svg?style=for-the-badge
[license-url]: https://github.com/ZarTek-Creole/TCL-Eva-Service/blob/master/LICENSE.txt
[product-screenshot]: images/screenshot.png

[product-screenshot]: images/screenshot.png
