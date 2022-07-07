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
    <a href="github.com/ZarTek-Creole/TCL-Eva-Service"><strong>Explore the docs / Explorez les documents »</strong></a>
    <br />
    <br />
    <a href="github.com/ZarTek-Creole/TCL-Eva-Service/issues">Report Bug</a>
    ·
    <a href="github.com/ZarTek-Creole/TCL-Eva-Service/issues">Request Feature</a>
    ·
    <a href="github.com/ZarTek-Creole/TCL-Eva-Service/wiki">Wiki / Documenation</a>
  </p>
</p>

<!-- TABLE OF CONTENTS -->
<details open="open">
  <summary>Table of Contents / Table des matières</summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project / À propos du projet</a>
    </li>
    <li>
      <a href="#getting-started">Getting Started / Commencez</a>
      <ul>
        <li><a href="#prerequisites">Prerequisites / Conditions préalables</a></li>
        <li><a href="#installation">Installation / Configuration</a></li>
      </ul>
    </li>
    <li><a href="#usage">Usage / Utilisation</a></li>
    <li><a href="#roadmap">Roadmap / Feuille de route</a></li>
    <li><a href="#contributing">Contributing / Contribuant </a></li>
    <li><a href="#license">License</a></li>
    <li><a href="#contact">Contact</a></li>
    <li><a href="#acknowledgements">Acknowledgements /Remerciements</a></li>
  </ol>
</details>

<!-- ABOUT THE PROJECT -->
## A propos EvaServ

EvaServ est un ensemble de Services IRC écris en TCL et fonctionnant avec un [eggdrop (v1.9+)](http://www.eggheads.org/) pour la gestion de votre réseau IRC.
Il a été testé sur un [Unrealircd (v5.0+)](http://www.eggheads.org/) qui utilise les nouveau protocoles IRC, il est compatible avec la nouvelle génération de serveurs d'IRCD.

EvaServ est utile pour :
* La gestion des salons sur votre réseau
* ...

### Prerequisites
* [eggdrop (v1.9+)](http://www.eggheads.org/)
* [Unrealircd (v5.0+)](http://www.eggheads.org/)
  * EN: IRC server new protocol
  * FR: Serveur IRC nouveau protocol
* [Package TCL: IRCServices (v0.0.1+)](https://github.com/ZarTek-Creole/TCL-PKG-IRCServices)
* [Package TCL: ZCT (v0.0.1+)](https://github.com/ZarTek-Creole/TCL-ZCT)
* [Client Git](https://git-scm.com/downloads)
* [tcllib](https://github.com/tcltk/tcllib)
* [tcl-tls](https://core.tcl-lang.org/tcltls/home)

### Installation
1.1.  Récuperez le code EvaServ
1.1.1 Première étape, vérifier que les dépendances sont installées et présentes :
* [Package TCL: IRCServices (v0.0.1+)](https://github.com/ZarTek-Creole/TCL-PKG-IRCServices)
* [Package TCL: ZCT (v0.0.1+)](https://github.com/ZarTek-Creole/TCL-ZCT)
* [Client Git](https://git-scm.com/downloads)
* [tcllib](https://github.com/tcltk/tcllib)
* [tcl-tls](https://core.tcl-lang.org/tcltls/home)

1.1.2 Téléchargez EvaServ
Téléchargez le code d'EvaServ dans votre répertoire scripts/ de votre eggdrop

Exemple ```/home/votre-dossier/eggdrop/scripts/EvaServ```
```
git clone --recurse-submodules  github.com/ZarTek-Creole/TCL-Eva-Service /home/votre-dossier/eggdrop/scripts/EvaServ
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

[Comment créer un link Service sur UnrealIRCd](http://www.exolia.fr/guide-lire-11.html)
# premier lancement
Lors du premier lancement, aucun compte utilisateur n'existe, pour créer votre compte vous devez vous identifier
```msg EvaServ auth [Votre pseudo voulu] <votre mot de passe voulu>```
Cela aura comme effet de vous créer un compte de niveau 4 (Admin) par défaut
2. Un peu plus loin
2.1. Débug général
Si Eva Service ne se connecte pas, activez le mode debug depuis la party-line  pour voir les erreurs directement dans le fichier "logs/Eva.debug".
```
.evadebug on 
```
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

See the [open issues](github.com/ZarTek-Creole/TCL-Eva-Service/issues) for a list of proposed features (and known issues).

---
Voir les [problèmes en suspens](github.com/ZarTek-Creole/TCL-Eva-Service/issues) pour une liste des fonctionnalités proposées (et des problèmes connus).

<!-- CONTRIBUTING -->
## Contributing

Contributions are what make the open source community such an amazing place to be learn, inspire, and create. Any contributions you make are **greatly appreciated**.

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a [Pull Request](github.com/ZarTek-Creole/TCL-Eva-Service/pulls)

---
Les contributions sont ce qui font de la communauté open source un endroit incroyable pour apprendre, inspirer et créer. Toute contribution que vous apportez est ** grandement appréciée **.
1. Forkez le projet
2. Créez votre branche de fonctionnalités (`git checkout -b feature/AmazingFeature`)
3. Validez vos modifications (`git commit -m 'Add some AmazingFeature'`)
4. Poussez vers la branche (`git push origin feature/AmazingFeature`)
5. Ouvrez une [Pull Request](github.com/ZarTek-Creole/TCL-Eva-Service/pulls)

<!-- LICENSE -->
## License

Distributed under the SoonDecision License. See `LICENSE` for more information.

<!-- CONTACT -->
## Contact

ZarTek - [@ZarTek](github.com/ZarTek-Creole) - ZarTek.Creole@GMail.com

Project Link: [github.com/ZarTek-Creole/TCL-Eva-Service](github.com/ZarTek-Creole/TCL-Eva-Service)

1. Tickets
Signalez tout bug, toutes idées :
* [Creez un ticket]([#4-configuration-de-unrealircd](github.com/ZarTek-Creole/TCL-Eva-Service/issues))

2. IRC
Vous pouvez me contacter sur IRC :

   * [irc.epiknet.org 6667 #eggdrop](irc://irc.epiknet.org:6667/#eggdrop)
   * [irc.epiknet.org +6697 #eggdrop](irc://irc.epiknet.org:+6697/#eggdrop)

<!-- ACKNOWLEDGEMENTS -->
## Acknowledgements
* TiSMA de Exolia.net pour le code d'origine
* Amandine de eggdrop.Fr pour son aide/idées/testes/..
* MenzAgitat car dans mes développements il y a toujours des astuces/manière de faire, fournis par MenzAgitat ou bout code de MenzAgitat

## infos en vrac

Dans le fichier configuration vous pouvez configurer chaque commande à un niveau précis 

<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[contributors-shield]: https://img.shields.io/github/contributors/ZarTek/TCL-Eva-Service.svg?style=for-the-badge
[contributors-url]: github.com/ZarTek-Creole/TCL-Eva-Service/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/ZarTek/TCL-Eva-Service.svg?style=for-the-badge
[forks-url]: github.com/ZarTek-Creole/TCL-Eva-Service/network/members
[stars-shield]: https://img.shields.io/github/stars/ZarTek/TCL-Eva-Service.svg?style=for-the-badge
[stars-url]: github.com/ZarTek-Creole/TCL-Eva-Service/stargazers
[issues-shield]: https://img.shields.io/github/issues/ZarTek/TCL-Eva-Service.svg?style=for-the-badge
[issues-url]: github.com/ZarTek-Creole/TCL-Eva-Service/issues
[license-shield]: https://img.shields.io/github/license/ZarTek/TCL-Eva-Service.svg?style=for-the-badge
[license-url]: github.com/ZarTek-Creole/TCL-Eva-Service/blob/master/LICENSE.txt
[product-screenshot]: images/screenshot.png
