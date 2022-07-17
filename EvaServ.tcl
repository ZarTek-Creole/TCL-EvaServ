##############################################################
# ███████╗██╗   ██╗ █████╗ ███████╗███████╗██████╗ ██╗   ██╗ #
# ██╔════╝██║   ██║██╔══██╗██╔════╝██╔════╝██╔══██╗██║   ██║ #
# █████╗  ██║   ██║███████║███████╗█████╗  ██████╔╝██║   ██║ #
# ██╔══╝  ╚██╗ ██╔╝██╔══██║╚════██║██╔══╝  ██╔══██╗╚██╗ ██╔╝ #
# ███████╗ ╚████╔╝ ██║  ██║███████║███████╗██║  ██║ ╚████╔╝  #
# ╚══════╝  ╚═══╝  ╚═╝  ╚═╝╚══════╝╚══════╝╚═╝  ╚═╝  ╚═══╝   #
##############################################################
#
#	Auteur	:
#		-> ZarTek (ZarTek.Creole@GMail.Com)
#
#	Website :
#		-> github.com/ZarTek-Creole/TCL-EvaServ
#
#	Support	:
#		-> github.com/ZarTek-Creole/TCL-EvaServ/issues
#
#	Docs	:
#		-> github.com/ZarTek-Creole/TCL-EvaServ/wiki
#
#	LICENSE :
#		-> GNU General Public License v3.0
#		-> github.com/ZarTek-Creole/TCL-EvaServ/blob/main/LICENSE.txt
#
#	Code origine:
#		-> TiSmA (TiSmA@eXolia.fr)
#
##############################################################

if { [info commands ::EvaServ::uninstall] eq "::EvaServ::uninstall" } { ::EvaServ::uninstall }
namespace eval ::EvaServ {
	variable ::EvaServ::config
	variable ::EvaServ::SCRIPT
	set VARS_LIST				[list											\
		"config"																\
		"SCRIPT"																\
		"UPLINK"																\
		"SERVICE"																\
		"SERVICE_BOT"															\
		];
	array set config			[list											\
		"timerco"				"30"											\
		"timerdem"				"5"												\
		"timerinit"				"10"											\
		"counter"				"0"												\
		"dem"					"0"												\
		"init"					"0"												\
		"console"				"1"												\
		"login"					"1"												\
		"protection"			"1"												\
		"debug"					"0"												\
		"aclient"				"0"												\
		"putlog_info"			"0"												\
		"smode"					"ntsO"											\
		"chanmode"				"qo"											\
		"prefix"				"!"												\
		"rnick"					"0"												\
		"Throttling"			"5"												\
		"Flood_IgnoreTime"		"30"											\
		"gline_duration"		"86400"											\
		"rclient"				"L'accès à ce t'chat est un privilège et non un droit. (CI)"	\
		"rhost"					"L'accès à ce t'chat est un privilège et non un droit. (Ip refusé)"	\
		"rident"				"L'accès à ce t'chat est un privilège et non un droit. (IR)"	\
		"rreal"					"L'accès à ce t'chat est un privilège et non un droit. (BR)"	\
		"ruser"					"L'accès à ce t'chat est un privilège et non un droit. (BN)"	\
		"<Raison>"				"Maintenance Technique"							\
		"console_com"			"02"											\
		"console_deco"			"03"											\
		"console_txt"			"01"											\
		];
	set VARS_config			[list												\
		"timerco"																\
		"timerdem"																\
		"timerinit"																\
		"counter"																\
		"dem"																	\
		"init"																	\
		"console"																\
		"login"																	\
		"protection"															\
		"debug"																	\
		"aclient"																\
		"putlog_info"															\
		"smode"																	\
		"chanmode"																\
		"prefix"																\
		"rnick"																	\
		"Throttling"															\
		"Flood_IgnoreTime"														\
		"gline_duration"														\
		"rclient"																\
		"rhost"																	\
		"rident"																\
		"rreal"																	\
		"ruser"																	\
		"<Raison>"																\
		"console_com"															\
		"console_deco"															\
		"console_txt"															\
		"nick_length"															\
		"password_length"														\
		];
	array set SCRIPT			 [list											\
		"name"					"EvaServ Service"								\
		"version"				"1.5.20220704"									\
		"auteur"				"ZarTek"										\
		"path_dir"				"[file dirname [info script]]"					\
		"need_ircs"				"0.0.7"											\
		"need_zct"				"0.0.4"											\
		];
	set VARS_SCRIPT				 [list											\
		"name"																	\
		"version"																\
		"auteur"																\
		"path_dir"																\
		];
	set VARS_UPLINK				[list											\
		"hostname"																\
		"mode_ssl"																\
		"port"																	\
		"password"																\
		];
	set VARS_SERVICE			[list											\
		"hostname"																\
		"sid"																	\
		"use_privmsg"															\
		"mode_debug"															\
		"hostname"																\
		];
	set  VARS_SERVICE_BOT		[list											\
		"name"																	\
		"hostname"																\
		"gecos"																	\
		"mode_service"															\
		"channel"																\
		"mode_channel"															\
		"mode_user"																\
		"username"																\
		"channel_logs"															\
		];
	set  VARS_cmdhelp			[list											\
		"prefix"																\
		"cmd"																	\
		];

	proc uninstall { } {
		variable ::EvaServ::config
		variable ::EvaServ::CONNECT_ID
		variable ::EvaServ::SCRIPT

		putlog "Désallocation des ressources de \002${SCRIPT(name)}\002..." info
		${CONNECT_ID} destroy
		foreach binding [lsearch -inline -all -regexp [binds *[set ns [::tcl::string::range [namespace current] 2 end]]*] " \{?(::)?${ns}"] {
			unbind [lindex ${binding} 0] [lindex ${binding} 1] [lindex ${binding} 2] [lindex ${binding} 4]
		}
		# Arrêt des timers en cours.
		foreach running_timer [timers] {
			if { [::tcl::string::match "*[namespace current]::*" [lindex ${running_timer} 1]] } { killtimer [lindex ${running_timer} 2] }
		}
		namespace delete ::EvaServ

	}
}
namespace eval ::EvaServ::DB_USER {
	namespace import -force ::EvaServ::*
}
proc ::EvaServ::DB_USER::COUNT { } {
	set USER_COUNT	0
	foreach User [userlist] {
		if { [getuser ${User} XTRA EvaServ] != "" }  {
			incr USER_COUNT
		}
	}
	return ${USER_COUNT}
}
proc ::EvaServ::DB_USER::GET_LEVEL { USER_NAME } {
	if {
		![validuser ${USER_NAME}]  												|| \
			![dict exist [getuser ${USER_NAME}] XTRA EvaServ NIVEAU]
	} {
		return 0
	}

	return [dict get [getuser ${USER_NAME} XTRA EvaServ] NIVEAU]
}
proc ::EvaServ::DB_USER::ADD { USER_ADDER USER_NAME USER_PASS USER_NIVEAU } {
	variable ::EvaServ::commands
	variable ::EvaServ::config
	if ![dict exists ${commands} ${USER_NIVEAU}] {
		::EvaServ::SENT::MSG:TO:USER ${USER_ADDER} [format "Le niveau <b>%s</b> n'existe pas dans la configuration" ${USER_NIVEAU}]
		return 0
	}
	if [validuser ${USER_NAME}] {
		::EvaServ::SENT::MSG:TO:USER ${USER_ADDER} [format "L'utilisateur <b>%s</b> existe déjà. Opération échoué" ${USER_NAME}]
		return 0
	}
	if {
		[dict exists ${commands} ${USER_NIVEAU} attr]			&& \
			[dict get ${commands} ${USER_NIVEAU} attr] != ""
	} {
		set USER_ATTR	[dict get ${commands} ${USER_NIVEAU} attr] ;
	} else {
		::EvaServ::SENT::MSG:TO:USER ${USER_ADDER} [format "La valeur <b>attr</b> est absente pour le niveau <b>%s</b>" ${USER_NIVEAU}]
		return 0
	}
	if {
		[dict exists ${commands} ${USER_NIVEAU} name]			&& \
			[dict get ${commands} ${USER_NIVEAU} name] != ""
	} {
		set NIVEAU_NAME	[dict get ${commands} ${USER_NIVEAU} name];
	} else {
		::EvaServ::SENT::MSG:TO:USER ${USER_ADDER} [format "La valeur <b>name</b> est absente pour le niveau <b>%s</b>" ${USER_NIVEAU}]
		return 0
	}
	if { [string length ${USER_NAME}] > ${::EvaServ::config(nick_length)} } {
		::EvaServ::SENT::MSG:TO:USER ${USER_ADDER} [format "Le pseudo doit contenir maximum <b>%s</b> caractères." ${::EvaServ::config(nick_length)}];
		return 0;
	}
	if { [string length ${USER_PASS}] < ${::EvaServ::config(password_length)} } {
		::EvaServ::SENT::MSG:TO:USER ${USER_ADDER} [format "Le mot de passe doit contenir minimum <b>%s</b> caractères." ${::EvaServ::config(password_length)} ];
		return 0;
	}
	set DATE_TODAY		[strftime ${::EvaServ::config(date_format)}]
	adduser ${USER_NAME};
	setuser ${USER_NAME} PASS ${USER_PASS};
	setuser ${USER_NAME} HOSTS ${USER_NAME}*!*@*;
	setuser ${USER_NAME} HOSTS -telnet!*@*
	setuser ${USER_NAME} XTRA EvaServ	[list 									\
		"ROLE"		"${NIVEAU_NAME}"		\
		"NIVEAU"	"${USER_NIVEAU}"		\
		"ADDED_BY"	"${USER_ADDER}"			\
		"ADDED_AT"	"${DATE_TODAY}"			\
		];
	if { ${USER_ATTR} != "" } { chattr ${USER_NAME} ${USER_ATTR}; }
	catch {save}
	::EvaServ::SENT::MSG:TO:USER ${USER_ADDER} [format "<b>%s</b> a bien été ajouté dans la liste des <b>%ss</b>." ${USER_NAME} ${NIVEAU_NAME}]
	::EvaServ::SHOW:INFO:TO:CHANLOG "auth_add" [format "Le compte <b>%s</b> à été creer au rang de <b>%s</b> par <b>%s</b>" ${USER_NAME} ${NIVEAU_NAME} ${USER_ADDER}];
	return 1
}
namespace eval ::EvaServ::CMD {
	namespace import -force ::EvaServ::*
	namespace export *
}
proc ::EvaServ::CMD::GET_LIST { } {
	variable ::EvaServ::commands
	foreach level [dict keys ${commands}] {
		lappend CMD_LIST {*}[dict get ${commands} ${level} cmd]
	}
	return ${CMD_LIST}
}
proc ::EvaServ::CMD::GET_LEVEL { CMD } {
	variable ::EvaServ::commands
	foreach level [dict keys ${commands}] {
		if { [lsearch -nocase [dict get ${commands} ${level} cmd] ${CMD}] != "-1" } {
			return ${level}
		}
	}
	return -1
}
proc ::EvaServ::CMD::is_EXIST { CMD } {
	if { [lsearch -nocase [::EvaServ::CMD::GET_LIST] ${CMD}] == "-1" } { return 0 }
	return 1
}
proc ::EvaServ::CMD::SHOW_BY_LEVEL { DEST LEVEL } {
	variable ::EvaServ::commands
	set max				6;
	set l_espace		13;
	set CMD_LIST		""
	::EvaServ::SENT::MSG:TO:USER ${DEST} "<c01>\[ Level [dict get ${commands} ${LEVEL} name] - Niveau ${LEVEL} \]"
	foreach CMD [lsort [dict get ${commands} ${LEVEL} cmd]] {
		lappend CMD_LIST	"<c02>[::ZCT::TXT visuals espace ${CMD} ${l_espace}]<c01>"
		if { [incr i] > ${max}-1 } {
			unset i
			::EvaServ::SENT::MSG:TO:USER ${DEST} [join ${CMD_LIST} " | "];
			set CMD_LIST	""
		}
	}
	::EvaServ::SENT::MSG:TO:USER ${DEST} [join ${CMD_LIST} " | "];
	::EvaServ::SENT::MSG:TO:USER ${DEST} "<c>";
}
namespace eval ::EvaServ::command {
	namespace import -force ::EvaServ::*
	namespace export *
}

namespace eval ::EvaServ::command::irc {
	namespace import -force ::EvaServ::*
	namespace export *
}
proc ::EvaServ::command::irc::showcommands { IRC_USER IRC_CMD IRC_VALUE } {
	variable ::EvaServ::SCRIPT
	set IRC_USER_LOWER	[string tolower ${IRC_USER}]
	::EvaServ::SENT::MSG:TO:USER ${IRC_USER_LOWER} [format "<b><c01,01>--------------------------------------- <c00>Commandes de %s <c01>---------------------------------------" ${SCRIPT(name)}]
	::EvaServ::SHOW:CMD:DESCRIPTION:BY:LEVEL ${IRC_USER_LOWER} 0
	if {
		[info exists admins(${IRC_USER_LOWER})]							&& \
			[matchattr $admins(${IRC_USER_LOWER}) p]
	} {
		::EvaServ::SHOW:CMD:DESCRIPTION:BY:LEVEL ${IRC_USER_LOWER} 1
	}
	if {
		[info exists admins(${IRC_USER_LOWER})]							&& \
			[matchattr $admins(${IRC_USER_LOWER}) o]
	} {
		::EvaServ::SHOW:CMD:DESCRIPTION:BY:LEVEL ${USER_LOWER} 2
	}
	if {
		[info exists admins(${IRC_USER_LOWER})]							&& \
			[matchattr $admins(${USER_LIRC_USER_LOWEROWER}) m]
	} {
		::EvaServ::SHOW:CMD:DESCRIPTION:BY:LEVEL ${IRC_USER_LOWER} 3
	}
	if {
		[info exists admins(${IRC_USER_LOWER})]							&& \
			[matchattr $admins(${IRC_USER_LOWER}) n]
	} {
		::EvaServ::SHOW:CMD:DESCRIPTION:BY:LEVEL ${IRC_USER_LOWER} 4
	}
	::EvaServ::SENT::MSG:TO:USER ${IRC_USER_LOWER} [format "<c02>Aide sur une commande<c01> \[<c04> /msg %s help <la_commande> <c01>\]" ${::EvaServ::SERVICE_BOT(name)}]
	if { [::EvaServ::ShowOnPartyLine 1] } {
		::EvaServ::SHOW:INFO:TO:CHANLOG "Showcommands" "${IRC_USER}"
	}
}
proc ::EvaServ::command::irc::help { IRC_USER IRC_CMD IRC_VALUE } {
	variable ::EvaServ::cmdhelp
	variable ::EvaServ::SERVICE_BOT
	if {
		[string tolower ${IRC_CMD}] == "help" && \
			${IRC_VALUE} != ""
	} {
		set IRC_CMD 	[lindex ${IRC_VALUE}]
		set IRC_VALUE	[lrange ${IRC_VALUE} 1 end]
	}
	if { ${IRC_CMD} == "" } {
		::EvaServ::command::irc::showcommands ${IRC_USER} ${IRC_CMD} ${IRC_VALUE}
		return 1
	}
	# Verification que l'utilisateur a les droits a la commande,
	# pour afficher seulement l'aide des commandes autoriser
	if { ![::EvaServ::authed ${IRC_USER} ${IRC_CMD}] } {
		return 0
	}

	# Verification de l'existance de la variable pour la commande
	if { ![dict exists ${cmdhelp} cmd ${IRC_CMD}] } {
		::EvaServ::SENT::MSG:TO:USER ${IRC_USER} [format "Aucune aide disponible pour la commande <b>%s</b>" ${IRC_CMD}];
		return 0;
	}

	if { [dict exists ${cmdhelp} prefixe] } {
		set MESSAGE 			[format [dict get ${cmdhelp} prefixe] ${IRC_CMD} ${::EvaServ::SERVICE_BOT(name)} ${IRC_CMD}];
		if { [dict exists ${cmdhelp} cmd ${IRC_CMD} syntaxe] } {
			append MESSAGE		" [dict get ${cmdhelp} cmd ${IRC_CMD} syntaxe]";
		}
		::EvaServ::SENT::MSG:TO:USER ${IRC_USER} ${MESSAGE};
	}

	::EvaServ::SENT::MSG:TO:USER ${IRC_USER} [::EvaServ::command::help_GET_DESCRIPTION ${IRC_CMD}]
	return 1
}
proc ::EvaServ::command::help_GET_DESCRIPTION { IRC_CMD } {
	variable ::EvaServ::cmdhelp
	set IRC_CMD [string tolower ${IRC_CMD}]
	if { ![dict exists ${cmdhelp} cmd ${IRC_CMD} description_text] } {
		return [format "<c07>Aucune description disponibles"];
	}
	if {
		[dict exists ${cmdhelp} cmd ${IRC_CMD} description_val] 		&& \
			[dict get ${cmdhelp} cmd ${IRC_CMD} description_val] != ""
	} {
		return [subst [format [dict get ${cmdhelp} cmd ${IRC_CMD} description_text] {*}[subst [dict get ${cmdhelp} cmd ${IRC_CMD} description_val]]]]
	} else {
		return [subst [dict get ${cmdhelp} cmd ${IRC_CMD} description_text]]
	}

}
proc ::EvaServ::command::irc::auth { IRC_USER IRC_CMD IRC_VALUE } {
	set IRC_USER_LOWER	[string tolower ${IRC_USER}]
	# si aucun argument est fournis, on retourne l'aide
	if { [lindex ${IRC_VALUE} 0] == "" } {
		::EvaServ::command::irc::help ${IRC_USER} ${IRC_CMD} ${IRC_VALUE}
		return 0
	}
	if { [lindex ${IRC_VALUE} 1] == "" } {
		set USER_NAME	${IRC_USER}
		set USER_PASS	[lindex ${IRC_VALUE} 0]
	} else {
		set USER_NAME	[lindex ${IRC_VALUE} 0]
		set USER_PASS	[lindex ${IRC_VALUE} 1]
	}
	# Verification si des utilisateurs 'eva' exists
	if { [::EvaServ::DB_USER::COUNT] == 0 } {
		# Si aucun utilisateurs Eva, nous creons le compte en tant que ircop supreme
		if {
			![validuser ${USER_NAME}]										&& \
				[getchanhost ${USER_NAME} ${::EvaServ::SERVICE_BOT(channel)}] == ""
		} {
			::EvaServ::SENT::MSG:TO:USER ${IRC_USER} \
				[format "<b>%s</b>, pour creer votre compte ircop, vous devez être operateur sur le salon <b>%s</b>." \
				${USER_NAME} ${::EvaServ::SERVICE_BOT(channel)}];
			return 0
		}
		if ![DB_USER::ADD ${IRC_USER} ${USER_NAME} ${USER_PASS} 4] { return 0 }
	}

	if { ![passwdok ${USER_NAME} ${USER_PASS}] } {
		::EvaServ::SENT::MSG:TO:USER ${IRC_USER} [format "L'authentification à échoué, un mauvais mot de passe à été fournis."];
		::EvaServ::SHOW:INFO:TO:CHANLOG "auth" [format "L'authentification à échoué pour mauvais mot de passe pour le pseudonyme <b>%s</b> du compte de <b>%s</b> ." ${IRC_USER} ${USER_NAME}];
		return 0;
	}
	if {
		![matchattr ${USER_NAME} o]											|| \
			![matchattr ${USER_NAME} m]										|| \
			[matchattr ${USER_NAME} n]
	} {
		if { ${::EvaServ::config(login)} == 1 } {
			foreach { pseudo login } [array get admins] {
				if {
					${login} == [string tolower ${USER_NAME}]				&& \
						${pseudo} != ${IRC_USER_LOWER}
				} {
					::EvaServ::SENT::MSG:TO:USER ${IRC_USER} [format "Maximum de connexion est atteint pour <b>%s</b>." ${USER_NAME}];
					return 0;
				}
			}
		}
		if { [info exists admins(${IRC_USER_LOWER})] } {
			::EvaServ::SENT::MSG:TO:USER ${IRC_USER} "Vous êtes déjà authentifié.";
			return 0;
		}
		set admins(${IRC_USER_LOWER})		[string tolower ${USER_NAME}]
		if {
			[info exists vhost(${IRC_USER_LOWER})]							&& \
				![info exists protect($vhost(${IRC_USER_LOWER}))]
		} {
			::EvaServ::SHOW:INFO:TO:CHANLOG "Protecion du host" [format "<b>%s</b> de <b>%s</b> (Activé)" $vhost(${IRC_USER_LOWER}) ${USER_LOWER}]
			set protect($vhost(${IRC_USER_LOWER}))		1
		}
		setuser [string tolower ${USER_NAME}] LASTON [unixtime]
		::EvaServ::SENT::MSG:TO:USER ${IRC_USER} "Authentification Réussie."
		::EvaServ::FCT:SENT:SERV INVITE ${IRC_USER} ${::EvaServ::SERVICE_BOT(channel_logs)};

		if { [::EvaServ::ShowOnPartyLine 1] } {
			::EvaServ::SHOW:INFO:TO:CHANLOG "Auth" [format "L'utilisateur <b>%s</b> s'est identifié au compte <b>%s</b>." ${IRC_USER} ${USER_NAME}]
		}
		return 0

	} elseif { [matchattr ${USER_NAME} p] } {
		::EvaServ::SENT::MSG:TO:USER ${IRC_USER} "Authentification Helpeur Refusée.";
		return 0;
	}
}
proc ::EvaServ::INIT { } {
	variable ::EvaServ::SCRIPT
	variable ::EvaServ::UPLINK
	variable ::EvaServ::SERVICE
	variable ::EvaServ::SERVICE_BOT
	variable ::EvaServ::FloodControl
	variable ::EvaServ::commands
	variable ::EvaServ::cmdhelp
	variable ::EvaServ::config
	variable ::EvaServ::CMD
	variable ::EvaServ::DB
	if {
		![file exists [Script:Get:Directory]/EvaServ.conf]					&& \
			[file exists [Script:Get:Directory]/EvaServ.Example.conf]
	} {
		putlog "Vous devez configurer EvaServ. Renommer [Script:Get:Directory]/EvaServ.Example.conf en EvaServ.conf et editez-le" error
		exit
	}
	if { [ catch { source [Script:Get:Directory]/EvaServ.conf } err ] } {
		putlog "Probleme de chargement de '[Script:Get:Directory]/EvaServ.conf':\n${err}" error
		foreach ERR [split $::errorInfo "\n"] {
			putlog ${ERR}
		}
		exit
	}
	#TODO: Verifié les bind dcc (ancien code)
	bind time	- "00 00 * * *"	::EvaServ::dbback
	bind evnt	n prerestart	evenement
	bind evnt	n sighup		evenement
	bind evnt	n sigterm		evenement
	bind evnt	n sigill		evenement
	bind evnt	n sigquit		evenement
	bind evnt	n prerehash		prerehash
	bind evnt	n rehash		rehash
	bind dcc	n eva			eva
	bind dcc	n evaconnect	connect
	bind dcc	n evadeconnect	deconnect
	bind dcc	n evauptime		uptime
	bind dcc	n evaversion	version
	bind dcc	n evainfos		infos
	bind dcc	n evadebug		debug

	# Verification de la présences des paramettre dans le fichier configuration (fonction ZCT)
	::ZCT::Is:ArrayList:Exists [namespace current]
	if { ![file isdirectory "[Script:Get:Directory]/db"] } { file mkdir "[Script:Get:Directory]/db" }

	# generer les db
	Database:initialisation [list												\
		"gestion"												\
		"chan"													\
		"client"												\
		"close"													\
		"salon"													\
		"ident"													\
		"real"													\
		"host"													\
		"nick"													\
		"trust"
	];
	if {
		[file exists [Script:Get:Directory]/TCL-PKG-IRCServices/ircservices.tcl]		&& \
			[catch { source [Script:Get:Directory]/TCL-PKG-IRCServices/ircservices.tcl } err]
	} {
		die "\[${SCRIPT(name)} - Erreur\] Chargement '[Script:Get:Directory]/TCL-PKG-IRCServices/ircservices.tcl' à échoué: ${err}";
	}
	if { [catch { package require IRCServices ${SCRIPT(need_ircs)} }] } {
		putloglev o * "\00304\[${SCRIPT(name)} - erreur\]\003 ${SCRIPT(name)} nécessite le package IRCServices ${SCRIPT(need_ircs)} (ou plus) pour fonctionner, Télécharger sur 'github.com/ZarTek-Creole/TCL-PKG-IRCServices'.\nLe chargement du script a été annulé." ;
		return 0
	}

	if { [file exists [Script:Get:Directory]/TCL-ZCT/ZCT.tcl] } { catch { source [Script:Get:Directory]/TCL-ZCT/ZCT.tcl } }
	if { [catch { package require ZCT ${SCRIPT(need_zct)} } err] } {
		die "\[${PKG(name)} - erreur\] Nécessite le package ZCT ${PKG(need_zct)} (ou plus) pour fonctionner, Télécharger sur 'https://github.com/ZarTek-Creole/TCL-ZCT'.\nLe chargement du script a été annulé." ;
	} else {
		namespace import -force ::ZCT::*
	}
	Database:Load:Data
	Service:Connexion
	putlog "v${SCRIPT(version)} par ${SCRIPT(auteur)} OK." success

}

proc ::EvaServ::Service:Connexion { } {
	variable ::EvaServ::config
	variable ::EvaServ::CONNECT_ID
	variable ::EvaServ::BOT_ID
	variable ::EvaServ::SERVICE
	variable ::EvaServ::SERVICE_BOT
	variable ::EvaServ::UPLINK

	if { ${UPLINK(mode_ssl)} == 1	} { set UPLINK(port) "+${UPLINK(port)}" }
	if { ${SERVICE(sid)} != ""		} { set config(uplink_ts6) 1 } else { set config(uplink_ts6) 0 }

	set CONNECT_ID	[::IRCServices::connection]; # Creer une instance services
	SENT::PUTLOG_INFO "Connexion du link EvaServ ${SERVICE(hostname)}"
	${CONNECT_ID} connect ${UPLINK(hostname)} ${UPLINK(port)} ${UPLINK(password)} ${::EvaServ::config(uplink_ts6)} ${SERVICE(hostname)} ${SERVICE(sid)}; # Connexion de l'instance service
	if { ${SERVICE(mode_debug)} == 1 } { ${CONNECT_ID} config logger 1; ${CONNECT_ID} config debug 1; }

	set BOT_ID [${CONNECT_ID} bot]; #Creer une instance bot dans linstance services

	SENT::PUTLOG_INFO "Creation du bot service ${::EvaServ::SERVICE_BOT(name)}"
	${BOT_ID} create ${::EvaServ::SERVICE_BOT(name)} ${::EvaServ::SERVICE_BOT(username)} ${::EvaServ::SERVICE_BOT(hostname)} ${::EvaServ::SERVICE_BOT(gecos)} ${::EvaServ::SERVICE_BOT(mode_service)}]; # Creation d'un bot service
	${BOT_ID} join ${::EvaServ::SERVICE_BOT(channel)}
	${BOT_ID} registerevent EOS {
		global ::EvaServ::SERVICE_BOT
		[sid] mode ${::EvaServ::SERVICE_BOT(channel)} ${::EvaServ::SERVICE_BOT(mode_channel)}
		if { ${::EvaServ::SERVICE_BOT(mode_user)} != "" } {
			[sid] mode ${::EvaServ::SERVICE_BOT(channel)} ${::EvaServ::SERVICE_BOT(mode_user)} ${::EvaServ::SERVICE_BOT(name)}
		}
	}
	${BOT_ID} registerevent PRIVMSG {
		set IRC_CMD		[lindex [msg] 0]
		set IRC_VALUE	[lrange [msg] 1 end]
		##########################
		#--> Commandes Privés <--#
		##########################
		# si [target] ne commence pas par # c'est un pseudo
		if { [string index [target] 0] != "#" } {
			if { [catch { set OK [::EvaServ::IRC:CMD:MSG:PRIV [who2] [target] ${IRC_CMD} ${IRC_VALUE}] } EXEC_ERROR] } {
				foreach line [split ${::errorInfo} "\n"] {
					::EvaServ::SHOW:INFO:TO:CHANLOG error ${line}
					putlog ${line} error IRC:CMD:MSG:PRIV
				}
				return 0;
			} else {
				return ${OK};
			}
		}
		##########################
		#--> Commandes Salons <--#
		##########################
		# si [target] commence par # c'est un salon
		# et que le prefixe est present CMD(prefixe)
		if {
			[string index [target] 0] == "#" && \
				[string index ${IRC_CMD} 0] == ${::EvaServ::CMD(prefixe)}
		} {
			# on retire les prefix a la commande, en ce basant sur sa longueur
			set IRC_CMD [string range ${IRC_CMD} [string length ${::EvaServ::CMD(prefixe)}] end]
			if { [catch { set OK [::EvaServ::IRC:CMD:MSG:PUB [who] [target] ${IRC_CMD} ${IRC_VALUE}] } EXEC_ERROR] } {
				foreach line [split ${::errorInfo} "\n"] {
					::EvaServ::SHOW:INFO:TO:CHANLOG error ${line}
					putlog ${line} error IRC:CMD:MSG:PUB
				}
				return 0;
			} else {
				return ${OK};
			}
		}
	}
}
proc ::EvaServ::IRC:CMD:MSG:PRIV { NICK_SOURCE TARGET IRC_CMD IRC_VALUE } {
	variable ::EvaServ::config
	variable ::EvaServ::SCRIPT
	if { ![FloodControl:Check ${NICK_SOURCE}] } { return 0 }
	switch -nocase ${IRC_CMD} {
		"PING"			{
			::EvaServ::SENT::NOTICE ${NICK_SOURCE} "\001PING ${IRC_VALUE}\001";
		}
		"TIME"		{
			::EvaServ::SENT::NOTICE ${NICK_SOURCE} "\001TIME [clock format [clock seconds]]\001";
		}
		"VERSION"		{
			::EvaServ::SENT::NOTICE ${NICK_SOURCE} "\001VERSION ${SCRIPT(name)} v${SCRIPT(version)} by ${SCRIPT(auteur)} © Visit: https://git.io/JOG1k\001";
		}
		"SOURCE"		{
			::EvaServ::SENT::NOTICE ${NICK_SOURCE} "\001SOURCE https://git.io/JOG1k\001";
		}
		"FINGER"		{
			::EvaServ::SENT::NOTICE ${NICK_SOURCE} "\001FINGER [string map {" " "_"} ${SCRIPT(name)}] ${SCRIPT(version)}\001";
		}
		"USERINFO"	{
			::EvaServ::SENT::NOTICE ${NICK_SOURCE} "\001USERINFO [string map {" " "_"} ${SCRIPT(name)}] (v${SCRIPT(version)} - Visit: https://git.io/JOG1k)\001";
		}
		"CLIENTINFO"	{
			::EvaServ::SENT::NOTICE ${NICK_SOURCE} "\001CLIENTINFO CLIENTINFO PING TIME VERSION FINGER USERINFO\001";
		}
		default		{
			# Commande exists ?
			if { ![::EvaServ::CMD::is_EXIST ${IRC_CMD}] } {
				::EvaServ::SENT::MSG:TO:USER ${NICK_SOURCE} [format "Aucune aide disponible pour la commande <b>%s</b> car elle est inconnue." ${IRC_CMD}]
				return 0
			}
			if { [catch { set OK [::EvaServ::cmds ${NICK_SOURCE} ${IRC_CMD}  ${IRC_VALUE}] } EXEC_ERROR] } {
				foreach line [split ${::errorInfo} "\n"] {
					::EvaServ::SHOW:INFO:TO:CHANLOG error ${line}
					putlog ${line} error IRC:CMD:MSG:PRIV
				}
				return 0;
			} else {
				return ${OK};
			}
		}
	}
}

# Commande taper publiquement
proc ::EvaServ::IRC:CMD:MSG:PUB { IRC_USER TARGET IRC_CMD IRC_VALUE } {
	variable ::EvaServ::config
	variable ::EvaServ::SCRIPT
	if { [lsearch ${::EvaServ::CMD(PUBLIC_DISALLOW)} ${IRC_CMD}] != "-1" } {
		::EvaServ::SENT::MSG:TO:USER ${TARGET} [format "La commande <b>%s</b> est bloqué en salon." ${IRC_CMD}]
		return 0
	}
	if { ![FloodControl:Check ${IRC_USER}] } { return 0 }
	if { ${IRC_CMD} == "ping" } {
		::EvaServ::SENT::MSG:TO:USER ${IRC_USER} "\001PING [clock seconds]\001";
		return 0;
	}
	if { ${IRC_CMD} == "version" } {
		::EvaServ::SENT::MSG:TO:USER ${IRC_USER} "<c01>${SCRIPT(name)} ${SCRIPT(version)} by ${SCRIPT(auteur)}<c03>©";
		return 0;
	}
	# Commande exists ?
	if { ![::EvaServ::CMD::is_EXIST ${IRC_CMD}] } { return 0 }

	if { [catch { set OK [::EvaServ::cmds ${IRC_USER} ${IRC_CMD} ${IRC_VALUE}] } EXEC_ERROR] } {
		foreach line [split ${::errorInfo} "\n"] {
			::EvaServ::SHOW:INFO:TO:CHANLOG error ${line}
			putlog ${line} error IRC:CMD:MSG:PRIV
		}
		return 0;
	} else {
		return ${OK};
	}
}

proc ::EvaServ::Script:Get:Directory { } {
	variable ::EvaServ::SCRIPT;
	return ${SCRIPT(path_dir)}
}
proc ::EvaServ::Database:initialisation { LISTDB } {
	foreach DB_NAME ${LISTDB} {
		if { ![file exists "[Script:Get:Directory]/db/${DB_NAME}.db"] } {
			set FILE_PIPE	[open "[Script:Get:Directory]/db/${DB_NAME}.db" a+];
			close ${FILE_PIPE}
		}

	}
}
proc ::EvaServ::Database:Load:Data { } {
	variable ::EvaServ::config
	variable ::EvaServ::trust

	catch { open [Script:Get:Directory]/db/trust.db r } protection
	while { ![eof ${protection}] } {
		gets ${protection} hosts;
		if {
			${hosts} != ""													&& \
				![info exists trust(${hosts})]
		} {
			set trust(${hosts})	1
			SENT::PUTLOG_INFO "L'host '${hosts}' est chargement comme TRUST."
		}
	}
	catch { close ${protection} }
	catch { open [Script:Get:Directory]/db/gestion.db r } gestion
	while { ![eof ${gestion}] } {
		gets ${gestion} var2;
		if { ${var2} != "" } { set [lindex ${var2} 0] [lindex ${var2} 1] }
	}
	catch { close ${gestion} }
}
namespace eval ::EvaServ::SENT {
	namespace import -force ::EvaServ::*
	namespace export *
}
proc ::EvaServ::SENT::PUTLOG_INFO { MSG } {
	variable ::EvaServ::config
	if {
		[info exists ${::EvaServ::config(putlog_info)}]								&& \
			${::EvaServ::config(putlog_info)} == 1
	} {
		putlog ${MSG} info
	}
}
proc ::EvaServ::SENT::NOTICE { DEST MSG } {
	variable ::EvaServ::BOT_ID
	${BOT_ID}	notice ${DEST} [::ZCT::TXT visuals apply ${MSG}]
}

proc ::EvaServ::SENT::PRIVMSG { DEST MSG } {
	variable ::EvaServ::BOT_ID
	${BOT_ID}	privmsg ${DEST} [::ZCT::TXT visuals apply ${MSG}]
}
proc ::EvaServ::SENT::MSG:TO:USER { DEST MSG } {
	variable ::EvaServ::SERVICE
	if { ${SERVICE(use_privmsg)} == 1 } {
		foreach message [split ${MSG} "\n"] {
			::EvaServ::SENT::PRIVMSG ${DEST} ${message};
		}
	} else {
		foreach message [split ${MSG} "\n"] {
			::EvaServ::SENT::PRIVMSG ${DEST} ${message};
		}
	}
}
proc ::EvaServ::SENT::PUT_DEBUG { string } {
	set FILE_PIPE		[open logs/EvaServ.debug a]
	puts ${FILE_PIPE} "[clock format [clock seconds] -format "\[%H:%M\]"] ${string}"
	close ${FILE_PIPE}
}
proc ::EvaServ::FloodControl:Check { pseudo } {
	variable ::EvaServ::FloodControl
	variable ::EvaServ::config
	if { ![info exists FloodControl(flood:${pseudo})] } {
		set FloodControl(flood:${pseudo})		1;
		utimer 3 [list ::EvaServ::FloodControl:NoticeUser ${pseudo}];
		# No-FLOOD
		return 1
	} elseif { $FloodControl(flood:${pseudo}) < ${::EvaServ::config(Throttling)} } {
		incr FloodControl(flood:${pseudo})		1;
		# No-FLOOD
		return 1
	} else {
		if { ![info exists FloodControl(stopflood:${pseudo})] } {
			set FloodControl(stopflood:${pseudo})		1
		}
	}
	# FLOOD
	return 0
}
proc ::EvaServ::FloodControl:NoticeUser { pseudo }		{
	variable ::EvaServ::FloodControl
	if { [info exists FloodControl(stopflood:${pseudo})] } {
		::EvaServ::SENT::MSG:TO:USER ${pseudo} "Vous êtes ignoré pendant ${::EvaServ::config(Flood_IgnoreTime)} secondes.";
		utimer ${::EvaServ::config(Flood_IgnoreTime)} [list ::EvaServ::FloodControl:Reset ${pseudo}];
	} else {
		unset FloodControl(flood:${pseudo})
	}
}
proc ::EvaServ::FloodControl:Reset { pseudo } {
	variable ::EvaServ::FloodControl
	if { [info exists FloodControl(stopflood:${pseudo})] }	{ unset FloodControl(stopflood:${pseudo}) }
	if { [info exists FloodControl(flood:${pseudo})] }		{ unset FloodControl(flood:${pseudo}) }
	::EvaServ::SENT::MSG:TO:USER ${pseudo} "Vous n'êtes plus ignoré.";

}

proc ::EvaServ::authed { IRC_USER IRC_CMD } {
	variable ::EvaServ::admins
	set CMD_LEVEL	[::EvaServ::CMD::GET_LEVEL ${IRC_CMD}];
	if { ${CMD_LEVEL} == "-1" } {
		::EvaServ::SENT::MSG:TO:USER ${IRC_USER} [format "La command <b>%s</b> est inconnue." ${IRC_CMD}];
		return 0;
	}
	if {
		[::EvaServ::DB_USER::GET_LEVEL ${IRC_USER}] >= ${CMD_LEVEL}
	} {
		return 1
	}
	::EvaServ::SENT::MSG:TO:USER ${IRC_USER} [format "L'accès à la commande <b>%s</b> vous est refusée." ${IRC_CMD}];
	return 0
}
proc ::EvaServ::SHOW:CMD:DESCRIPTION:BY:LEVEL { DEST LEVEL } {
	variable ::EvaServ::commands
	set max				6;
	set l_espace		13;
	set CMD_LIST		""
	::EvaServ::SENT::MSG:TO:USER ${DEST} "<c01>\[ Level [dict get ${commands} ${LEVEL} name] - Niveau ${LEVEL} \]"
	foreach CMD [lsort [dict get ${commands} ${LEVEL} cmd]] {
		set CMD_LOWER	[string tolower ${CMD}];
		set CMD_UPPER	[string toupper ${CMD}];
		::EvaServ::SENT::MSG:TO:USER ${DEST} "<c02>[::ZCT::TXT visuals espace ${CMD_UPPER} ${l_espace}]<c01> \[<c04> [::EvaServ::command::help_GET_DESCRIPTION ${CMD_LOWER}] <c01>\]";
	}
	::EvaServ::SENT::MSG:TO:USER ${DEST} "<c>";
}
###################################################################################################################################################################################################
#TODO: Enlever les résidu de l'ancien systeme de protocol
proc ::EvaServ::sent2ppl { IDX MSG } {
	putdcc ${IDX} ${MSG}
}


proc ::EvaServ::SHOW:INFO:TO:CHANLOG { TYPE DATA } {
	variable ::EvaServ::config
	variable ::EvaServ::SERVICE_BOT
	::EvaServ::SENT::MSG:TO:USER ${::EvaServ::SERVICE_BOT(channel_logs)} "<c${::EvaServ::config(console_com)}>[::ZCT::TXT visuals espace ${TYPE} 16]<c${::EvaServ::config(console_deco)}>:<c${::EvaServ::config(console_txt)}> ${DATA}"
}

#TODO: Enlever les résidu de l'ancien systeme de protocol (suite)
proc ::EvaServ::FCT:SENT:SERV { args } {
	variable ::EvaServ::BOT_ID
	${BOT_ID} ${args}
}
proc ::EvaServ::FCT:SENT:MODE { DEST {MODE ""} {CIBLE ""} } {
	::EvaServ::FCT:SENT:SERV MODE ${DEST} ${MODE} ${CIBLE};
}
proc ::EvaServ::FCT:SET:TOPIC { DEST TOPIC } {
	::EvaServ::FCT:SENT:SERV TOPIC ${DEST} :[::ZCT::TXT visuals apply ${TOPIC}];
}
proc ::EvaServ::FCT:DATA:TO:NICK { DATA } {
	if { [string range ${DATA} 0 0] == 0 } {
		set user		[UID:CONVERT ${DATA}]
	} else {
		set user		${DATA}
	}
	return ${user};
}

proc ::EvaServ::refresh { pseudo } {
	variable ::EvaServ::netadmin
	variable ::EvaServ::admins
	variable ::EvaServ::vhost
	variable ::EvaServ::protect
	variable ::EvaServ::users
	set vuser	[string tolower ${pseudo}]
	if { [info exists vhost(${USER_LOWER})] } {
		if {
			[info exists protect($vhost(${USER_LOWER}))]					&& \
				[info exists admins(${USER_LOWER})]
		} {
			::EvaServ::SHOW:INFO:TO:CHANLOG "Protecion du host" "$vhost(${USER_LOWER}) de ${USER_LOWER} (Désactivé)"
			unset protect($vhost(${USER_LOWER}))
		}
		unset vhost(${USER_LOWER})
	}
	if { [info exists users(${USER_LOWER})] } { unset users(${USER_LOWER})		}
	if { [info exists netadmin(${USER_LOWER})] } { unset netadmin(${USER_LOWER})		}
	if { [info exists admins(${USER_LOWER})] } { unset admins(${USER_LOWER})		}
}

###############
# Eva Gestion #
###############

proc ::EvaServ::gestion { } {
	variable ::EvaServ::config
	set FILE_PIPE		[open [Script:Get:Directory]/db/gestion.db w+]
	puts ${FILE_PIPE} "SERVICE_BOT(channel_logs) ${::EvaServ::SERVICE_BOT(channel_logs)}"
	puts ${FILE_PIPE} "config(debug) ${::EvaServ::config(debug)}"
	puts ${FILE_PIPE} "config(console) ${::EvaServ::config(console)}"
	puts ${FILE_PIPE} "config(protection) ${::EvaServ::config(protection)}"
	puts ${FILE_PIPE} "config(login) ${::EvaServ::config(login)}"
	puts ${FILE_PIPE} "config(aclient) ${::EvaServ::config(aclient)}"
	close ${FILE_PIPE}
}
#TODO: mettre la liste des db en namespace parent
#TODO: personaliser les sauvegarde, quand, le nombre, et combien temps qu'on garde
proc ::EvaServ::dbback { min h d m y } {
	variable ::EvaServ::config
	gestion
	set DB_LIST	[list "gestion" "chan" "client" "close" "nick" "ident" "real" "host" "salon" "trust"]
	foreach DB_NAME ${DB_LIST} {
		exec cp -f [Script:Get:Directory]/db/${DB_NAME}.db [Script:Get:Directory]/db/${DB_NAME}.bak
	}
	if { [::EvaServ::ShowOnPartyLine 1] } {
		::EvaServ::SHOW:INFO:TO:CHANLOG "Backup" "Sauvegarde des databases."
	}
}
#TODO: exporter dans ZCT
proc ::EvaServ::duree { temps } {
	switch -exact [lindex [ctime ${temps}] 1] {
		"Jan" { set mois	"01" }
		"Feb" { set mois	"02" }
		"Mar" { set mois	"03" }
		"Apr" { set mois	"04" }
		"May" { set mois	"05" }
		"Jun" { set mois	"06" }
		"Jul" { set mois	"07" }
		"Aug" { set mois	"08" }
		"Sep" { set mois	"09" }
		"Oct" { set mois	"10" }
		"Nov" { set mois	"11" }
		"Dec" { set mois	"12" }
	}
	switch -exact [lindex [ctime ${temps}] 2] {
		1 { set jour		"01" }
		2 { set jour		"02" }
		3 { set jour		"03" }
		4 { set jour		"04" }
		5 { set jour		"05" }
		6 { set jour		"06" }
		7 { set jour		"07" }
		8 { set jour		"08" }
		9 { set jour		"09" }
	}
	if { ![info exists jour] } { set jour		[lindex [ctime ${temps}] 2] }
	set heure		[lindex [ctime ${temps}] 3]
	set annee		[lindex [ctime ${temps}] 4]
	set seen		"${jour}/${mois}/${annee} à ${heure}"
	return ${seen}
}
proc ::EvaServ::ShowOnPartyLine  { level } {
	variable ::EvaServ::config
	switch -exact ${level} {
		1	{
			if { ${::EvaServ::config(console)} >= 1 } { return 1 }
		}
		2	{
			if { ${::EvaServ::config(console)} >= 2 } { return 1 }
		}
		3	{
			if { ${::EvaServ::config(console)} >= 3 } { return 1 }
		}
		default { return 0 }
	}
}

###########################################################
# Eva Verification de securité utilisateur a la connexion #
###########################################################
proc ::EvaServ::connexion:user:security:check { nickname hostname username gecos } {
	variable ::EvaServ::config
	variable ::EvaServ::trust
	# default
	set config(ahost)			1
	set config(aident)			1
	set config(areal)			1
	set config(anick)			1

	# Lors de l'init (connexion au irc du service) on verifie rien
	if { ${::EvaServ::config(init)} == 1 } { return 0 }
	# on verifie si l'host est trusted
	foreach { mask num } [array get trust] {
		if { [string match -nocase *${mask}* ${hostname}] } {
			::EvaServ::SHOW:INFO:TO:CHANLOG "Hostname Trustée" "${mask}"
			return 0
		}
	}
	# Si l'utilisateur est proteger, on skip les verification
	if { [info exists protect(${hostname})] } {
		::EvaServ::SHOW:INFO:TO:CHANLOG "Security Check" "Aucune verification de sécurité sur ${hostname}, le hostname protegé"
		return 0
	}

	set MSG_security_check	""
	# Version client ?
	if { ${::EvaServ::config(aclient)} == 1 } { lappend MSG_security_check "Client version: On"; } else { lappend MSG_security_check "Client version: Off"; }
	# verif host?
	if { ${::EvaServ::config(ahost)} == 1 } { lappend MSG_security_check "Host: On"; } else { lappend MSG_security_check "Host: Off"; }
	# verif ident?
	if { ${::EvaServ::config(aident)} == 1 } { lappend MSG_security_check "Ident: On"; } else { lappend MSG_security_check "Ident: Off"; }
	# verif areal?
	if { ${::EvaServ::config(areal)} == 1 } { lappend MSG_security_check "Realname: On"; } else { lappend MSG_security_check "Realname: Off"; }
	# verif nick?
	if { ${::EvaServ::config(anick)} == 1 } { lappend MSG_security_check "Nick: On"; } else { lappend MSG_security_check "Nick: Off"; }

	if { [::EvaServ::ShowOnPartyLine 2] } {
		::EvaServ::SHOW:INFO:TO:CHANLOG "Security Check" [join ${MSG_security_check} " | "]
	}

	# Version client
	if { ${::EvaServ::config(aclient)} == 1	} {
		::EvaServ::SENT::MSG:TO:USER ${nickname} "\001VERSION\001"
	}
	#TODO: ca me semble repetitif , y a surement moyen de reduire
	if { ${::EvaServ::config(ahost)} == 1	} {
		catch { open [Script:Get:Directory]/db/host.db r } liste2
		while { ![eof ${liste2}] } {
			gets ${liste2} verif2
			if {
				[string match -nocase *${verif2}* ${hostname}]				&& \
					${verif2} != ""
			} {
				if {
					[::EvaServ::ShowOnPartyLine 1]										&& \
						${::EvaServ::config(init)} == 0
				} {
					::EvaServ::SHOW:INFO:TO:CHANLOG "Kill" "${nickname} a été killé : ${::EvaServ::config(rhost)}"
				}
				::EvaServ::FCT:SENT:SERV KILL ${nickname} ${::EvaServ::config(rhost)};
				break;
				refresh ${nickname};
				return 0
			}
		}
		catch { close ${liste2} }
	}
	if { ${::EvaServ::config(aident)} == 1	} {
		catch { open [Script:Get:Directory]/db/ident.db r } liste3
		while { ![eof ${liste3}] } {
			gets ${liste3} verif3
			if {
				[string match -nocase *${verif3}* ${username}]				&& \
					${verif3} != ""
			} {
				if {
					[::EvaServ::ShowOnPartyLine 1]										&& \
						${::EvaServ::config(init)} == 0
				} {
					::EvaServ::SHOW:INFO:TO:CHANLOG "Kill" "${nickname} (${verif3}) a été killé : ${::EvaServ::config(rident)}"
				}
				::EvaServ::FCT:SENT:SERV KILL ${nickname} ${::EvaServ::config(rident)};
				break ;
				refresh ${nickname};
				return 0;
			}
		}
		catch { close ${liste3} }
	}
	if { ${::EvaServ::config(areal)} == 1	} {
		catch { open [Script:Get:Directory]/db/real.db r } liste4
		while { ![eof ${liste4}] } {
			gets ${liste4} verif4
			if {
				[string match -nocase *${verif4}* ${gecos}]					&& \
					${verif4} != ""
			} {
				if {
					[::EvaServ::ShowOnPartyLine 1]										&& \
						${::EvaServ::config(init)} == 0
				} {
					::EvaServ::SHOW:INFO:TO:CHANLOG "Kill" "${nickname} (Realname: ${verif4}) a été killé : ${::EvaServ::config(rreal)}"
				}
				::EvaServ::FCT:SENT:SERV KILL ${nickname} ${::EvaServ::config(rreal)};
				break;
				refresh ${nickname};
				return 0;
			}
		}
		catch { close ${liste4} }
	}
	if { ${::EvaServ::config(anick)} == 1	} {
		catch { open [Script:Get:Directory]/db/nick.db r } liste5
		while { ![eof ${liste5}] } {
			gets ${liste5} verif5
			if {
				[string match -nocase ${verif5} ${nickname}]				&& \
					${verif5} != ""
			} {
				if {
					[::EvaServ::ShowOnPartyLine 1]										&& \
						${::EvaServ::config(init)} == 0
				} {
					::EvaServ::SHOW:INFO:TO:CHANLOG "Kill" "${nickname} a été killé : ${::EvaServ::config(ruser)}"
				}
				::EvaServ::FCT:SENT:SERV KILL ${nickname} ${::EvaServ::config(ruser)};
				break;
				refresh ${nickname};
				return 0;
			}
		}
		catch { close ${liste5} }
	}
}
#TODO: a refaire
proc ::EvaServ::protection { user {level ""} } {
	variable ::EvaServ::config
	variable ::EvaServ::netadmin
	variable ::EvaServ::admins
	variable ::EvaServ::vhost
	if { ${level} == "" } { set level ${::EvaServ::config(protection)} }
	switch -exact ${level} {
		0 {
			if { [info exists netadmin(${user})] } { return 1 }
		}
		1 {
			if { [info exists netadmin(${user})] } {
				return 1
				} elseif { [
					info exists admins(${user})]								&& \
						[matchattr $admins(${user}) n]
				} {
				return 1
			}
		}
		2 {
			if { [info exists netadmin(${user})] } {
				return 1
			} elseif {
				[info exists admins(${user})]								&& \
					[matchattr $admins(${user}) m]
			} {
				return 1
			}
		}
		3 {
			if { [info exists netadmin(${user})] } {
				return 1
			} elseif {
				[info exists admins(${user})]								&& \
					[matchattr $admins(${user}) o]
			} {
				return 1
			}
		}
		4 {
			if { [info exists netadmin(${user})] } {
				return 1
			} elseif {
				[info exists admins(${user})]								&& \
					[matchattr $admins(${user}) p]
			} {
				return 1
			}
		}
	}
}
#TODO: c'est quoi? sert a quoi?
proc ::EvaServ::rnick { user } {
	variable ::EvaServ::config
	if { ${::EvaServ::config(rnick)} == 1 } { return "(${user})" }
}
#TODO: verifié si tjs valide
proc ::EvaServ::prerehash { arg } {
	variable ::EvaServ::config
	if {
		[info exists config(idx)]											&& \
			[valididx ${::EvaServ::config(idx)}]
	} {
		gestion
	}
}

proc ::EvaServ::rehash { arg } {
	variable ::EvaServ::config
	if {
		[info exists config(idx)]											&& \
			[valididx ${::EvaServ::config(idx)}] } {
				Database:Load:Data
		}
	}

	proc ::EvaServ::evenement { arg } {
		variable ::EvaServ::config
		if {
			[info exists config(idx)]											&& \
				[valididx ${::EvaServ::config(idx)}]
		} {
			gestion
			::EvaServ::FCT:SENT:SERV QUIT :${::EvaServ::config(raison)};
			sent2socket ":${::EvaServ::config(link)} SQUIT ${::EvaServ::config(link)} :${::EvaServ::config(raison)}"
			foreach kill [utimers] {
				if { [lindex ${kill} 1] == "verif" } { killutimer [lindex ${kill} 2] }
			}
			unset config(idx)
		}
	}
	#TODO: deplacer les commande ppl dans un namespace special
	proc ::EvaServ::eva { nick idx arg } {
		variable ::EvaServ::SCRIPT
		sent2ppl ${idx} "<c01,01>------------<b><c00> Commandes de ${SCRIPT(name)} <c01>------------"
		sent2ppl ${idx} " "
		sent2ppl ${idx} "<c01> .evaconnect <c03>: <c14>Connexion de ${SCRIPT(name)}"
		sent2ppl ${idx} "<c01> .evadeconnect <c03>: <c14>Déconnexion de ${SCRIPT(name)}"
		sent2ppl ${idx} "<c01> .evadebug On/Off <c03>: <c14>Mode debug de ${SCRIPT(name)}"
		sent2ppl ${idx} "<c01> .evainfos <c03>: <c14>Voir les infos de ${SCRIPT(name)}"
		sent2ppl ${idx} "<c01> .evauptime <c03>: <c14>Uptime de ${SCRIPT(name)}"
		sent2ppl ${idx} "<c01> .evaversion <c03>: <c14>Version de ${SCRIPT(name)}"
		sent2ppl ${idx} ""
	}
	proc ::EvaServ::connect { nick idx arg } {
		variable ::EvaServ::SCRIPT
		variable ::EvaServ::config
		set config(counter)		0
		if { ![info exists config(idx)] } {
			sent2ppl ${idx} "<c01>\[ <c03>Connexion<c01> \] <c01> Lancement de ${SCRIPT(name)}...";
			connexion
			set config(dem)		1;
			utimer ${::EvaServ::config(timerdem)} [list set config(dem)		0]
		} else {
			if { ![valididx ${::EvaServ::config(idx)}] } {
				sent2ppl ${idx} "<c01>\[ <c03>Connexion<c01> \] <c01> Lancement de ${SCRIPT(name)}...";
				connexion
				set config(dem)		1;
				utimer ${::EvaServ::config(timerdem)} [list set config(dem)		0]
			} else {
				sent2ppl ${idx} "<c01>\[ <c04>Impossible<c01> \] <c01> ${SCRIPT(name)} est déjà connecté..."
			}
		}

	}

	proc ::EvaServ::deconnect { nick idx arg } {
		variable ::EvaServ::config
		if { ${::EvaServ::config(dem)} == 0 } {
			if {
				[info exists config(idx)]										&& \
					[valididx ${::EvaServ::config(idx)}]
			} {
				gestion
				sent2ppl ${idx} "<c01>\[ <c03>Déconnexion<c01> \] <c01> Arret de ${SCRIPT(name)}..."
				::EvaServ::FCT:SENT:SERV QUIT :${::EvaServ::config(raison)};
				sent2socket ":${::EvaServ::config(link)} SQUIT ${::EvaServ::config(link)} :${::EvaServ::config(raison)}"
				foreach kill [utimers] {
					if { [lindex ${kill} 1] == "verif" } { killutimer [lindex ${kill} 2] }
				}
				unset config(idx)
			} else {
				sent2ppl ${idx} "<c01>\[ <c04>Impossible<c01> \] <c01> ${SCRIPT(name)} n'est pas connecté..."
			}
		} else {
			sent2ppl ${idx} "<c01>\[ <c04>Erreur<c01> \] <c01> Connexion de ${SCRIPT(name)} en cours..."
		}
	}

	proc ::EvaServ::uptime { nick idx arg } {
		variable ::EvaServ::config
		if {
			[info exists config(idx)]											&& \
				[valididx ${::EvaServ::config(idx)}]
		} {
			set show		""
			set up			[expr ([clock seconds] - ${::EvaServ::config(uptime)})]
			set jour		[expr (${up} / 86400)]
			set up			[expr (${up} % 86400)]
			set heure		[expr (${up} / 3600)]
			set up			[expr (${up} % 3600)]
			set minute		[expr (${up} / 60)]
			set seconde		[expr (${up} % 60)]
			if { ${jour} == 1			} {
				append show "${jour} jour "
			} elseif { ${jour} > 1		} {
				append show "${jour} jours "
			}
			if { ${heure} == 1			} {
				append show "${heure} heure "
			} elseif { ${heure} > 1	} {
				append show "${heure} heures "
			}
			if { ${minute} == 1			} {
				append show "${minute} minute "
			} elseif { ${minute} > 1	 } {
				append show "${minute} minutes "
			}
			if { ${seconde} == 1		} {
				append show "${seconde} seconde "
			} elseif { ${seconde} > 1	} {
				append show "${seconde} secondes "
			}
			sent2ppl ${idx} "<c01>\[ <c03>Uptime<c01> \] <c01> ${show}"
		} else {
			sent2ppl ${idx} "<c01>\[ <c04>Uptime<c01> \] <c01> ${SCRIPT(name)} n'est pas connecté..."
		}
	}

	proc ::EvaServ::version { nick idx arg } {
		variable ::EvaServ::SCRIPT
		sent2ppl ${idx} "<c01>\[ <c03>Version<c01> \] <c01> ${SCRIPT(name)} ${SCRIPT(version)} by ${SCRIPT(auteur)}"
	}

	proc ::EvaServ::infos { nick idx arg } {
		variable ::EvaServ::SCRIPT
		variable ::EvaServ::config
		sent2ppl ${idx} "<c01,01>-----------<b><c00> Infos de ${SCRIPT(name)} <c01>-----------"
		sent2ppl ${idx} "<c>"
		if { [info exists config(idx)] }	 {
			sent2ppl ${idx} "<c01> Statut : <c03>Online"
		} else {
			sent2ppl ${idx} "<c01> Statut : <c04>Offline"
		}
		if { ${::EvaServ::config(debug)} == 1 } {
			sent2ppl ${idx} "<c01> Debug : <c03>On"
		} else {
			sent2ppl ${idx} "<c01> Debug : <c04>Off"
		}
		sent2ppl ${idx} "<c01> Os : ${::tcl_platform(os)} ${::tcl_platform(osVersion)}"
		sent2ppl ${idx} "<c01> Tcl Version : ${::tcl_patchLevel}"
		sent2ppl ${idx} "<c01> Tcl Lib : ${::tcl_library}"
		sent2ppl ${idx} "<c01> Encodage : [encoding system]"
		sent2ppl ${idx} "<c01> Eggdrop Version : [lindex ${::version} 0]"
		sent2ppl ${idx} "<c01> Config : [Script:Get:Directory]/EvaServ.conf"
		sent2ppl ${idx} "<c01> Noyau : [Script:Get:Directory]/EvaServ.tcl"
		sent2ppl ${idx} "<c>"
	}

	proc ::EvaServ::debug { nick idx arg } {
		variable ::EvaServ::config
		set arg			[split ${arg}]
		set status		[string tolower [lindex ${arg} 0]]
		if {
			${status} != "on"														&& \
				${status} != "off"
		} {
			sent2ppl ${idx} ".evadebug On/Off";
			return 0;
		}

		if { ${status} == "on" } {
			if { ${::EvaServ::config(debug)} == 0 } {
				set config(debug)		1;
				sent2ppl ${idx} "<c01>\[ <c03>Debug<c01> \] <c01>Activé"
			} else {
				sent2ppl ${idx} "Le mode debug est déjà activé."
			}
		} elseif { ${status} == "off" } {
			if { ${::EvaServ::config(debug)} == 1 } {
				set config(debug)		0;
				sent2ppl ${idx} "<c01>\[ <c03>Debug<c01> \] <c01>Désactivé"
				if { [file exists "logs/EvaServ.debug"] } { exec rm -rf logs/EvaServ.debug }
			} else {
				sent2ppl ${idx} "Le mode debug est déjà désactivé."
			}
		}
	}

	############
	# Eva Cmds #
	############
	#TODO: deplacer dans des procs propres command::irc::<cmd>
	proc ::EvaServ::cmds { IRC_USER IRC_CMD IRC_VALUE } {
		variable ::EvaServ::SCRIPT
		variable ::EvaServ::SERVICE_BOT
		variable ::EvaServ::config
		variable ::EvaServ::users
		variable ::EvaServ::admins
		variable ::EvaServ::vhost
		variable ::EvaServ::protect
		variable ::EvaServ::trust
		set stop		0
		if { ![::EvaServ::authed ${IRC_USER} ${IRC_CMD}] } { return 0 }
		if { [ catch { set OK [::EvaServ::command::irc::[string tolower ${IRC_CMD}] ${IRC_USER} ${IRC_CMD} ${IRC_VALUE}] } err ] } {
			::EvaServ::SHOW:INFO:TO:CHANLOG "ERROR" ${err};
			return 0
		} else {
			if { [::EvaServ::ShowOnPartyLine 1] } {
				::EvaServ::SHOW:INFO:TO:CHANLOG ${IRC_CMD} ${IRC_USER}
			}
			return 1
		}
		## ce qui suit est l'ancien code a exporter en proc
		return 1
		switch -exact ${IRC_CMD} {

			"deauth" {
				if { [info exists admins(${USER_LOWER})] } {
					if {
						[matchattr $admins(${USER_LOWER}) o]					|| \
							[matchattr $admins(${USER_LOWER}) m]					|| \
							[matchattr $admins(${USER_LOWER}) n]
					} {
						if {
							[info exists vhost(${USER_LOWER})]					&& \
								[info exists protect($vhost(${USER_LOWER}))]
						} {
							::EvaServ::SHOW:INFO:TO:CHANLOG "Protecion du host" "$vhost(${USER_LOWER}) de ${USER_LOWER} (Désactivé)"
							unset protect($vhost(${USER_LOWER}))
						}
						unset admins(${USER_LOWER});
						::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "Déauthentification Réussie."
						if { [::EvaServ::ShowOnPartyLine 1] } {
							::EvaServ::SHOW:INFO:TO:CHANLOG "Deauth" "${user}"
						}
					} elseif { [matchattr $admins(${USER_LOWER}) p] } {
						::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "Déauthentification Helpeur Refusée.";
						return 0;
					}

				} else {
					::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "Vous n'êtes pas authentifié."
				}
			}
			"copyright" {
				::EvaServ::SENT::MSG:TO:USER ${user} "<c01>${SCRIPT(name)} v${SCRIPT(version)} by ${SCRIPT(auteur)}"
				if { [::EvaServ::ShowOnPartyLine 1] } {
					::EvaServ::SHOW:INFO:TO:CHANLOG "Copyright" "${user}"
				}
			}
			"console" {
				if {
					${value2} == ""											|| \
						[regexp "\[^0-3\]" ${value2}]
				} {
					::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<b>Commande Console :</b> /msg ${::EvaServ::SERVICE_BOT(name)} console 0/1/2/3"
					::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<c02>Level 0 <c04>:<c01> Aucune console"
					::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<c02>Level 1 <c04>:<c01> Console commande"
					::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<c02>Level 2 <c04>:<c01> Console commande & connexion & déconnexion"
					::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<c02>Level 3 <c04>:<c01> Toutes les consoles"
					return 0
				}
				switch -exact ${value2} {
					0 {
						set config(console)		0;
						::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "Level 0 : Aucune console"
						::EvaServ::SHOW:INFO:TO:CHANLOG "Console" "${user}"
					}
					1 {
						set config(console)		1;
						::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "Level 1 : Console commande"
						::EvaServ::SHOW:INFO:TO:CHANLOG "Console" "${user}"
					}
					2 {
						set config(console)		2;
						::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "Level 2 : Console commande & connexion & déconnexion"
						::EvaServ::SHOW:INFO:TO:CHANLOG "Console" "${user}"
					}
					3 {
						set config(console)		3;
						::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "Level 3 : Toutes les consoles"
						::EvaServ::SHOW:INFO:TO:CHANLOG "Console" "${user}"
					}
				}
			}
			"chanlog" {
				if { ${value2} == [string tolower ${::EvaServ::SERVICE_BOT(channel_logs)}] } {
					::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<b>${value1}</b> est déjà le salon de log.";
					return 0
				}
				if { [string index ${value2} 0] != "#" } {
					::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<b>Commande Chanlog :</b> /msg ${::EvaServ::SERVICE_BOT(name)} chanlog <#Salon>";
					return 0
				}
				catch { open "[Script:Get:Directory]/db/salon.db" r } liste1
				while { ![eof ${liste1}] } {
					gets ${liste1} verif1;
					if { ![string compare -nocase ${value2} ${verif1}] } {
						::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "Accès Refusé : Salon Interdit";
						set stop 1;
						break
					}
				}
				catch { close ${liste1} }
				if { ${stop} == 1 } { return 0 }
				catch { open "[Script:Get:Directory]/db/close.db" r } liste2
				while { ![eof ${liste2}] } {
					gets ${liste2} verif2;
					if { ![string compare -nocase ${value2} ${verif2}] } {
						::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "Accès Refusé : Salon Fermé";
						set stop		1;
						break
					}
				}
				catch { close ${liste2} }
				if { ${stop} == 1 } { return 0 }
				catch { open "[Script:Get:Directory]/db/chan.db" r } liste3
				while { ![eof ${liste3}] } {
					gets ${liste3} verif3;
					if { ![string compare -nocase ${value2} ${verif3}] } {
						::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "Accès Refusé : Salon Autojoin";
						set stop		1;
						break
					}
				}
				catch { close ${liste3} }
				if { ${stop} == 1 } { return 0 }
				::EvaServ::FCT:SENT:SERV PART ${::EvaServ::SERVICE_BOT(channel_logs)};
				FCT:SENT:MODE ${::EvaServ::SERVICE_BOT(channel_logs)} "-O"
				set SERVICE_BOT(channel_logs)		${value1}
				::EvaServ::FCT:SENT:SERV JOIN ${::EvaServ::SERVICE_BOT(channel_logs)};
				FCT:SENT:MODE ${::EvaServ::SERVICE_BOT(channel_logs)} "+${::EvaServ::config(smode)}"
				if {
					${::EvaServ::config(chanmode)} == "q"									|| \
						${::EvaServ::config(chanmode)} == "a"									|| \
						${::EvaServ::config(chanmode)} == "o"									|| \
						${::EvaServ::config(chanmode)} == "h"									|| \
						${::EvaServ::config(chanmode)} == "v"
				} {
					FCT:SENT:MODE ${::EvaServ::SERVICE_BOT(channel_logs)} "+${::EvaServ::config(chanmode)}" ${::EvaServ::SERVICE_BOT(name)}
				}
				::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "Changement du salon de log reussi (${value1})"
				if { [::EvaServ::ShowOnPartyLine 1] } {
					::EvaServ::SHOW:INFO:TO:CHANLOG "Chanlog" "Changement du salon de log par ${user} (${value1})"
				}
			}
			"join" {
				if { [string index ${value2} 0] != "#" } {
					::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<b>Commande Join :</b> /msg ${::EvaServ::SERVICE_BOT(name)} join <#Salon>";
					return 0
				}
				if { ${value2} == [string tolower ${::EvaServ::SERVICE_BOT(channel_logs)}] } {
					::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "Accès Refusé : Salon de logs";
					return 0
				}
				catch { open "[Script:Get:Directory]/db/salon.db" r } liste1
				while { ![eof ${liste1}] } {
					gets ${liste1} verif1;
					if { ![string compare -nocase ${value2} ${verif1}] } {
						::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "Accès Refusé : Salon Interdit";
						set stop		1;
						break
					}
				}
				catch { close ${liste1} }
				if { ${stop} == 1 } { return 0 }
				catch { open "[Script:Get:Directory]/db/close.db" r } liste2
				while { ![eof ${liste2}] } {
					gets ${liste2} verif2;
					if { ![string compare -nocase ${value2} ${verif2}] } {
						::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "Accès Refusé : Salon Fermé";
						set stop		1;
						break
					}
				}
				catch { close ${liste2} }
				if { ${stop} == 1 } { return 0 }
				catch { open "[Script:Get:Directory]/db/chan.db" r } liste
				while { ![eof ${liste}] } {
					gets ${liste} verif;
					if { ![string compare -nocase ${value2} ${verif}] } {
						::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "${::EvaServ::SERVICE_BOT(name)} est déjà sur <b>${value1}</b>.";
						set stop		1;
						break
					}
				}
				catch { close ${liste} }
				if { ${stop} == 1 } { return 0 }
				set join		[open "[Script:Get:Directory]/db/chan.db" a];
				puts ${join} ${value2};
				close ${join};
				::EvaServ::FCT:SENT:SERV JOIN ${value1};
				if {
					${::EvaServ::config(chanmode)} == "q"									|| \
						${::EvaServ::config(chanmode)} == "a"									|| \
						${::EvaServ::config(chanmode)} == "o"									|| \
						${::EvaServ::config(chanmode)} == "h"									|| \
						${::EvaServ::config(chanmode)} == "v"
				} {
					FCT:SENT:MODE ${value1} "+${::EvaServ::config(chanmode)}" ${::EvaServ::SERVICE_BOT(name)}
				}
				::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "${::EvaServ::SERVICE_BOT(name)} entre sur <b>${value1}</b>"

				if { [::EvaServ::ShowOnPartyLine 1] } {
					::EvaServ::SHOW:INFO:TO:CHANLOG "Join" "${value1} par ${user}"
				}
			}
			"part" {
				if { [string index ${value2} 0] != "#" } {
					::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<b>Commande Part :</b> /msg ${::EvaServ::SERVICE_BOT(name)} part <#Salon>";
					return 0;
				}

				if { ${value2} == [string tolower ${::EvaServ::SERVICE_BOT(channel_logs)}] } {
					::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "Accès Refusé";
					return 0;
				}

				catch { open "[Script:Get:Directory]/db/chan.db" r } liste
				while { ![eof ${liste}] } {
					gets ${liste} verif;
					if { ![string compare -nocase ${value2} ${verif}] } { set stop		1 }
					if {
						[string compare -nocase ${value2} ${verif}]			&& \
							${verif} != ""
					} {
						lappend salle "${verif}"
					}
				}
				catch { close ${liste} }
				if { ${stop} == 0 } {
					::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "${::EvaServ::SERVICE_BOT(name)} n'est pas sur <b>${value1}</b>.";
					return 0;
				} else {
					if { [info exists salle] } {
						set FILE_PIPE		[open "[Script:Get:Directory]/db/chan.db" w+];
						foreach chandel ${salle} { puts ${FILE_PIPE} "${chandel}" }
						close ${FILE_PIPE}
					} else {
						set FILE_PIPE		[open "[Script:Get:Directory]/db/chan.db" w+];
						close ${FILE_PIPE}
					}
					FCT:SENT:MODE ${value1} "-sntio";
					::EvaServ::FCT:SENT:SERV PART ${value1};
					::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "${::EvaServ::SERVICE_BOT(name)} part de <b>${value1}</b>"
					if { [::EvaServ::ShowOnPartyLine 1] } {
						::EvaServ::SHOW:INFO:TO:CHANLOG "Part" "${value1} par ${user}"
					}
				}
			}
			"list" {
				catch { open "[Script:Get:Directory]/db/chan.db" r } liste
				::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<b><c1,1>--------- <c0>Autojoin salons <c1>---------"
				::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<b>"
				while { ![eof ${liste}] } {
					gets ${liste} salon;
					if { ${salon} != "" } {
						incr stop 1;
						::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<c01> \[<c03> ${stop} <c01>\] <c01> ${salon}"
					}
				}
				catch { close ${liste} }
				if { ${stop} == 0 } {
					::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "Aucun Salon"
				}
				if { [::EvaServ::ShowOnPartyLine 1] } {
					::EvaServ::SHOW:INFO:TO:CHANLOG "List" "${user}"
				}
			}

			"help" {
				return 0
				::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<b><c01,01>--------------------------------------- <c00>Commandes de ${SCRIPT(name)} <c01>---------------------------------------"
				::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<c>"
				::EvaServ::CMD::SHOW_BY_LEVEL ${USER_LOWER} 0
				if {
					[info exists admins(${USER_LOWER})]							&& \
						[matchattr $admins(${USER_LOWER}) p]
				} {
					::EvaServ::CMD::SHOW_BY_LEVEL ${USER_LOWER} 1
				}
				if {
					[info exists admins(${USER_LOWER})]							&& \
						[matchattr $admins(${USER_LOWER}) o]
				} {
					::EvaServ::CMD::SHOW_BY_LEVEL ${USER_LOWER} 2
				}
				if {
					[info exists admins(${USER_LOWER})]							&& \
						[matchattr $admins(${USER_LOWER}) m]
				} {
					::EvaServ::CMD::SHOW_BY_LEVEL ${USER_LOWER} 3
				}
				if {
					[info exists admins(${USER_LOWER})]							&& \
						[matchattr $admins(${USER_LOWER}) n]
				} {
					::EvaServ::CMD::SHOW_BY_LEVEL ${USER_LOWER} 4
				}
				::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<c02>Listes des commandes<c01> \[<c04> /msg ${::EvaServ::SERVICE_BOT(name)} showcommands <c01>\]"
				if { [::EvaServ::ShowOnPartyLine 1] } {
					::EvaServ::SHOW:INFO:TO:CHANLOG "Help" "${user}"
				}
			}
			"maxlogin" {
				if {
					${value2} != "on"											&& \
						${value2} != "off"
				} {
					::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<b>Commande Maxlogin :</b> /msg ${::EvaServ::SERVICE_BOT(name)} maxlogin On/Off";
					return 0;
				}

				if { ${value2} == "on" } {
					if { ${::EvaServ::config(login)} == 0 } {
						set config(login)		1;
						::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "Protection maxlogin activée"
						if { [::EvaServ::ShowOnPartyLine 1] } {
							::EvaServ::SHOW:INFO:TO:CHANLOG "Maxlogin" "${user}"
						}
					} else {
						::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "La protection maxlogin est déjà activée."
					}
				} elseif { ${value2} == "off" } {
					if { ${::EvaServ::config(login)} == 1 } {
						set config(login)		0;
						::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "Protection maxlogin désactivée"
						if { [::EvaServ::ShowOnPartyLine 1] } {
							::EvaServ::SHOW:INFO:TO:CHANLOG "Maxlogin" "${user}"
						}
					} else {
						::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "La protection maxlogin est déjà désactivée."
					}
				}
			}
			"backup" {
				gestion
				exec cp -f [Script:Get:Directory]/db/gestion.db [Script:Get:Directory]/db/gestion.bak
				exec cp -f [Script:Get:Directory]/db/chan.db [Script:Get:Directory]/db/chan.bak
				exec cp -f [Script:Get:Directory]/db/client.db [Script:Get:Directory]/db/client.bak
				exec cp -f [Script:Get:Directory]/db/close.db [Script:Get:Directory]/db/close.bak
				exec cp -f [Script:Get:Directory]/db/real.db [Script:Get:Directory]/db/real.bak
				exec cp -f [Script:Get:Directory]/db/ident.db [Script:Get:Directory]/db/ident.bak
				exec cp -f [Script:Get:Directory]/db/host.db [Script:Get:Directory]/db/host.bak
				exec cp -f [Script:Get:Directory]/db/nick.db [Script:Get:Directory]/db/nick.bak
				exec cp -f [Script:Get:Directory]/db/salon.db [Script:Get:Directory]/db/salon.bak
				exec cp -f [Script:Get:Directory]/db/trust.db [Script:Get:Directory]/db/trust.bak
				::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "Sauvegarde des databases réalisée."
				if { [::EvaServ::ShowOnPartyLine 1] } {
					::EvaServ::SHOW:INFO:TO:CHANLOG "Backup" "${user}"
				}
			}
			"restart" {
				if { [::EvaServ::ShowOnPartyLine 1] } {
					::EvaServ::SHOW:INFO:TO:CHANLOG "Restart" "${user}"
				}
				::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "Redémarrage de ${SCRIPT(name)}."
				gestion;
				::EvaServ::FCT:SENT:SERV QUIT ${::EvaServ::config(raison)};
				sent2socket ":${::EvaServ::config(link)} SQUIT ${::EvaServ::config(link)} :${::EvaServ::config(raison)}"
				foreach kill [utimers] {
					if { [lindex ${kill} 1] == "verif" } { killutimer [lindex ${kill} 2] }
				}
				if { [info exists config(idx)] } { unset config(idx)		}
				set config(counter)		0;
				config
				utimer 1 ::EvaServ::connexion
			}
			"die" {
				if { [::EvaServ::ShowOnPartyLine 1] } {
					::EvaServ::SHOW:INFO:TO:CHANLOG "Die" "${user}"
				}
				::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "Arrêt de ${SCRIPT(name)}."
				gestion;
				::EvaServ::FCT:SENT:SERV QUIT ${::EvaServ::config(raison)};
				sent2socket ":${::EvaServ::config(link)} SQUIT ${::EvaServ::config(link)} :${::EvaServ::config(raison)}"
				foreach kill [utimers] {
					if { [lindex ${kill} 1] == "::EvaServ::verif" } { killutimer [lindex ${kill} 2] }
				}
				if { [info exists config(idx)] } { unset config(idx)		}
			}
			"status" {
				set numuser		0;
				set numident	0;
				set numhost		0;
				set numreal		0;
				set numtrust	0
				set numclose	0;
				set numsalons	0;
				set numsalon	0;
				set numchan		0;
				set numclient	0;
				set show		""
				set up			[expr ([clock seconds] - ${::EvaServ::config(uptime))}]
				set jour		[expr (${up} / 86400)]
				set up			[expr (${up} % 86400)]
				set heure		[expr (${up} / 3600)]
				set up			[expr (${up} % 3600)]
				set minute		[expr (${up} / 60)]
				set seconde		[expr (${up} % 60)]
				if { ${jour} == 1 }			{ append show "${jour} jour " } elseif { ${jour} > 1 } { append show "${jour} jours " }
				if { ${heure} == 1 }		{ append show "${heure} heure " } elseif { ${heure} > 1 } { append show "${heure} heures " }
				if { ${minute} == 1 }		{ append show "${minute} minute " } elseif { ${minute} > 1 } { append show "${minute} minutes " }
				if { ${seconde} == 1 }		{ append show "${seconde} seconde " } elseif { ${seconde} > 1 } { append show "${seconde} secondes " }
				#TODO: ca me semble repepitiif peut etre creer une fonvrion
				catch { open [Script:Get:Directory]/db/client.db r } liste
				while { ![eof ${liste}] } 	{
					gets ${liste} sclients;
					if { ${sclients} != "" } { incr numclient 1 }
				}
				catch { close ${liste} }
				catch { open [Script:Get:Directory]/db/chan.db r } liste2
				while { ![eof ${liste2}] } 	{
					gets ${liste2} schans;
					if { ${schans} != "" } { incr numchan 1 }
				}
				catch { close ${liste2} }
				catch { open [Script:Get:Directory]/db/salon.db r } liste4
				while { ![eof ${liste4}] } {
					gets ${liste4} ssalon;
					if { ${ssalon} != "" } { incr numsalons 1 }
				}
				catch { close ${liste4} }
				catch { open [Script:Get:Directory]/db/close.db r } liste5
				while { ![eof ${liste5}] } {
					gets ${liste5} sclose;
					if { ${sclose} != "" } { incr numclose 1 }
				}
				catch { close ${liste5} }
				catch { open [Script:Get:Directory]/db/nick.db r } liste6
				while { ![eof ${liste6}] } {
					gets ${liste6} suser;
					if { ${suser} != "" } { incr numuser 1 }
				}
				catch { close ${liste6} }
				catch { open [Script:Get:Directory]/db/ident.db r } liste7
				while { ![eof ${liste7}] } {
					gets ${liste7} sident;
					if { ${sident} != "" } { incr numident 1 }
				}
				catch { close ${liste7} }
				catch { open [Script:Get:Directory]/db/host.db r } liste8
				while { ![eof ${liste8}] } {
					gets ${liste8} shost;
					if { ${shost} != "" } { incr numhost 1 }
				}
				catch { close ${liste8} }
				catch { open [Script:Get:Directory]/db/real.db r } liste9
				while { ![eof ${liste9}] } {
					gets ${liste9} sreal;
					if { ${sreal} != "" } { incr numreal 1 }
				}
				catch { close ${liste9} }
				catch { open [Script:Get:Directory]/db/trust.db r } liste10
				while { ![eof ${liste10}] } {
					gets ${liste10} strust;
					if { ${strust} != "" } { incr numtrust 1 }
				}
				catch { close ${liste10} }
				::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<b><c1,1>------------------ <c0>Status de ${SCRIPT(name)} <c1>------------------"
				::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<b>"
				::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<c02> Owner : <c01>${admin}"
				::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<c02> Salon de logs : <c01>${::EvaServ::SERVICE_BOT(channel_logs)}"
				::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<c02> Salon Autojoin : <c01>${numchan}"
				::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<c02> Uptime : <c01>${show}"
				#TODO: switch useless
				switch -exact ${::EvaServ::config(console)} {
					0 { ::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<c02> Level Console : <c01>0" }
					1 { ::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<c02> Level Console : <c01>1" }
					2 { ::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<c02> Level Console : <c01>2" }
					3 { ::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<c02> Level Console : <c01>3" }
				}
				switch -exact ${::EvaServ::config(protection)} {
					0 { ::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<c02> Level Protection : <c01>0" }
					1 { ::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<c02> Level Protection : <c01>1" }
					2 { ::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<c02> Level Protection : <c01>2" }
					3 { ::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<c02> Level Protection : <c01>3" }
					4 { ::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<c02> Level Protection : <c01>4" }
				}
				if { ${::EvaServ::config(login)} == 1 } {
					::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<c02> Protection Maxlogin : <c03>On"
				} else {
					::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<c02> Protection Maxlogin : <c04>Off"
				}
				if { ${::EvaServ::config(aclient)} == 1 } {
					::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<c02> Protection Clients IRC : <c03>On"
				} else {
					::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<c02> Protection Clients IRC : <c04>Off"
				}
				::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<c02> Nbre de Salons Fermés : <c01>${numclose}"
				::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<c02> Nbre de Salons Interdits : <c01>${numsalons}"
				::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<c02> Nbre de Pseudos Interdits : <c01>${numuser}"
				::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<c02> Nbre de Idents Interdits : <c01>${numident}"
				::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<c02> Nbre de Hostnames Interdites : <c01>${numhost}"
				::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<c02> Nbre de Realnames Interdits : <c01>${numreal}"
				::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<c02> Nbre de Clients IRC : <c01>${numclient}"
				::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<c02> Nbre de Trusts : <c01>${numtrust}"
				::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<b>"
				if { [::EvaServ::ShowOnPartyLine 1] } {
					::EvaServ::SHOW:INFO:TO:CHANLOG "Status" "${user}"
				}
			}
			"protection" {
				if {
					${value2} == ""												|| \
						[regexp "\[^0-4\]" ${value2}]
				} {
					#TODO: dynamiser les niveau
					::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<b>Commande Protection :</b> /msg ${::EvaServ::SERVICE_BOT(name)} protection <0/1/2/3/4>"
					::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<c02>Level 0 <c04>:<c01> Aucune Protection"
					::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<c02>Level 1 <c04>:<c01> Protection Admins"
					::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<c02>Level 2 <c04>:<c01> Protection Admins + Ircops"
					::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<c02>Level 3 <c04>:<c01> Protection Admins + Ircops + Géofronts"
					::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<c02>Level 4 <c04>:<c01> Protection de tous les accès"
					return 0
				}
				switch -exact ${value2} {
					0 {
						set config(protection)		0;
						::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "Level 0 : Aucune Protection"
						::EvaServ::SHOW:INFO:TO:CHANLOG "Protection" "${user}"
					}
					1 {
						set config(protection)		1;
						::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "Level 1 : Protection Admins"
						::EvaServ::SHOW:INFO:TO:CHANLOG "Protection" "${user}"
					}
					2 {
						set config(protection)		2;
						::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "Level 2 : Protection Admins + Ircops"
						::EvaServ::SHOW:INFO:TO:CHANLOG "Protection" "${user}"
					}
					3 {
						set config(protection)		3;
						::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "Level 3 : Protection Admins + Ircops + Géofronts"
						::EvaServ::SHOW:INFO:TO:CHANLOG "Protection" "${user}"
					}
					4 {
						set config(protection)		4;
						::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "Level 4 : Protection de tous les accès"
						::EvaServ::SHOW:INFO:TO:CHANLOG "Protection" "${user}"
					}
				}
			}
			"newpass" {
				if { ${value1} == "" } {
					::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<b>Commande Newpass :</b> /msg ${::EvaServ::SERVICE_BOT(name)} newpass <Mot-De-Passe>";
					return 0;
				}

				if { [string length ${value1}] <= 5 } {
					::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "Le mot de passe doit contenir minimum 6 caractères.";
					return 0;
				}

				setuser $admins(${USER_LOWER}) PASS ${value1}
				::EvaServ::SENT::MSG:TO:USER ${user} "Changement du mot de passe reussi."
				if { [::EvaServ::ShowOnPartyLine 1] } {
					::EvaServ::SHOW:INFO:TO:CHANLOG "Newpass" "${user}"
				}
			}
			"map" {
				set config(rep)		${USER_LOWER}
				::EvaServ::FCT:SENT:SERV LINKS;
				if { [::EvaServ::ShowOnPartyLine 1] } {
					::EvaServ::SHOW:INFO:TO:CHANLOG "Map" "${user}"
				}
			}
			"seen" {
				if { ${value1} == "" } {
					::EvaServ::SENT::MSG:TO:USER ${user} "<b>Commande Seen :</b> /msg ${::EvaServ::SERVICE_BOT(name)} seen <Pseudonyme>";
					return 0;
				}

				if { [validuser ${value1}] } {
					set annee		[lindex [ctime [getuser ${value1} LASTON]] 4]
					if { ${annee} != "1970" } { set seen		[duree [getuser ${value1} LASTON]] } else {
						set seen		"Jamais"
					}
					if { [::EvaServ::ShowOnPartyLine 1] } {
						::EvaServ::SHOW:INFO:TO:CHANLOG "Seen" "${user}"
					}
					if { [matchattr ${value1} n] } {
						::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<c1>Pseudo \[<c4>${value1}<c1>\] <c> Level \[<c03>Admin<c1>\] <c> Seen \[<c02>${seen}<c1>\]"
					} elseif { [matchattr ${value1} m] } {
						::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<c1>Pseudo \[<c4>${value1}<c1>\] <c> Level \[<c03>Ircop<c1>\] <c> Seen \[<c02>${seen}<c1>\]"
					} elseif { [matchattr ${value1} o] } {
						::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<c1>Pseudo \[<c4>${value1}<c1>\] <c> Level \[<c03>Géofront<c1>\] <c> Seen \[<c02>${seen}<c1>\]"
					} elseif { [matchattr ${value1} p] } {
						::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<c1>Pseudo \[<c4>${value1}<c1>\] <c> Level \[<c03>Helpeur<c1>\] <c> Seen \[<c02>${seen}<c1>\]"
					}
				} else {
					#TODO: le pseudo,yme blabla mode format
					::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "Pseudo inconnu.";
					return 0;
				}
			}
			"access" {
				if {
					${value1} == "*"											|| \
						${value1} == ""
				} {
					if { [::EvaServ::ShowOnPartyLine 1] } {
						::EvaServ::SHOW:INFO:TO:CHANLOG "Access" "${user}"
					}
					::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<b><c1,1>------------------------------- <c0>Liste des Accès <c1>-------------------------------"
					::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<b>"
					foreach acces [userlist] {
						set annee		[lindex [ctime [getuser ${acces} LASTON]] 4]
						if { ${annee} != "1970" } { set seen		[duree [getuser ${acces} LASTON]] } else {
							set seen		"Jamais"
						}
						foreach { act reg } [array get admins] {
							if { ${reg} == [string tolower ${acces}] } { set status		"<c03>Online" }
						}
						if { ![info exists status] } { set status		"<c04>Offline" }
						switch -exact ${::EvaServ::config(protection)} {
							1 {
								if { [matchattr ${acces} n] } { set aprotect		"<c03>On" }
							}
							2 {
								if { [matchattr ${acces} m] } { set aprotect		"<c03>On" }
							}
							3 {
								if { [matchattr ${acces} o] } { set aprotect		"<c03>On" }
							}
							4 {
								if { [matchattr ${acces} p] } { set aprotect		"<c03>On" }
							}
						}
						if { ![info exists aprotect] } { set aprotect		"<c04>Off" }
						#TODO: ca me semble aussi repepitig
						if { [matchattr ${acces} n] } {
							::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<c01> Pseudo \[<c04>${acces}<c01>\] <c01> Level \[<c03>Admin<c01>\] <c01> Seen \[<c12>${seen}<c01>\]"
							::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<c01> Statut \[${status}<c01>\] <c01> Protection \[${aprotect}<c01>\]"
							::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<c01> Mask \[<c02>[getuser ${acces} HOSTS]<c01>\]"
							::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<c>"
						} elseif { [matchattr ${acces} m] } {
							::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<c01> Pseudo \[<c04>${acces}<c01>\] <c01> Level \[<c03>Ircop<c01>\] <c01> Seen \[<c12>${seen}<c01>\]"
							::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<c01> Statut \[${status}<c01>\] <c01> Protection \[${aprotect}<c01>\]"
							::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<c01> Mask \[<c02>[getuser ${acces} HOSTS]<c01>\]"
							::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<c>"
						} elseif { [matchattr ${acces} o] } {
							::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<c01> Pseudo \[<c04>${acces}<c01>\] <c01> Level \[<c03>Géofront<c01>\] <c01> Seen \[<c12>${seen}<c01>\]"
							::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<c01> Statut \[${status}<c01>\] <c01> Protection \[${aprotect}<c01>\]"
							::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<c01> Mask \[<c02>[getuser ${acces} HOSTS]<c01>\]"
							::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<c>"
						} elseif { [matchattr ${acces} p] } {
							::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<c01> Pseudo \[<c04>${acces}<c01>\] <c01> Level \[<c03>Helpeur<c01>\] <c01> Seen \[<c12>${seen}<c01>\]"
							::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<c01> Statut \[${status}<c01>\] <c01> Protection \[${aprotect}<c01>\]"
							::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<c01> Mask \[<c02>[getuser ${acces} HOSTS]<c01>\]"
							::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<c>"
						}
						unset status;
						unset seen;
						unset aprotect
					}
				} elseif { [validuser ${value1}] } {
					set annee		[lindex [ctime [getuser ${value1} LASTON]] 4]
					if { ${annee} != "1970" } { set seen		[duree [getuser ${value1} LASTON]] } else {
						set seen		"Jamais"
					}
					foreach { act reg } [array get admins] {
						if { ${reg} == [string tolower ${value1}] } { set status		"<c03>Online" }
					}
					if { ![info exists status] } { set status		"<c04>Offline" }
					#TODO: sitch useless
					switch -exact ${::EvaServ::config(protection)} {
						1 {
							if { [matchattr ${value1} n] } { set aprotect		"<c03>On" }
						}
						2 {
							if { [matchattr ${value1} m] } { set aprotect		"<c03>On" }
						}
						3 {
							if { [matchattr ${value1} o] } { set aprotect		"<c03>On" }
						}
						4 {
							if { [matchattr ${value1} p] } { set aprotect		"<c03>On" }
						}
					}
					if { ![info exists aprotect] } { set aprotect		"<c04>Off" }
					if { [::EvaServ::ShowOnPartyLine 1] } {
						::EvaServ::SHOW:INFO:TO:CHANLOG "Access" "${user}"
					}
					::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<b><c1,1>--------------------------- <c0>Accès de ${value1} <c1>---------------------------"
					::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<b>"
					#TODO: a revoir
					if { [matchattr ${value1} n] } {
						::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<c01> Pseudo \[<c04>${value1}<c01>\] <c01> Level \[<c03>Admin<c01>\] <c01> Seen \[<c12>${seen}<c01>\]"
						::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<c01> Statut \[${status}<c01>\] <c01> Protection \[${aprotect}<c01>\]"
						::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<c01> Mask \[<c02>[getuser ${value1} HOSTS]<c01>\]"
					} elseif { [matchattr ${value1} m] } {
						::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<c01> Pseudo \[<c04>${value1}<c01>\] <c01> Level \[<c03>Ircop<c01>\] <c> Seen \[<c12>${seen}<c01>\]"
						::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<c01> Statut \[${status}<c01>\] <c01> Protection \[${aprotect}<c01>\]"
						::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<c01> Mask \[<c02>[getuser ${value1} HOSTS]<c01>\]"
					} elseif { [matchattr ${value1} o] } {
						::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<c01> Pseudo \[<c04>${value1}<c01>\] <c01> Level \[<c03>Géofront<c01>\] <c01> Seen \[<c12>${seen}<c01>\]"
						::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<c01> Statut \[<c03>${status}<c01>\] <c01> Protection \[${aprotect}<c01>\]"
						::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<c01> Mask \[<c02>[getuser ${value1} HOSTS]<c01>\]"
					} elseif { [matchattr ${value1} p] } {
						::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<c01> Pseudo \[<c04>${value1}<c01>\] <c01> Level \[<c03>Helpeur<c01>\] <c01> Seen \[<c12>${seen}<c01>\]"
						::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<c01> Statut \[${status}<c01>\] <c01> Protection \[${aprotect}<c01>\]"
						::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<c01> Mask \[<c02>[getuser ${value1} HOSTS]<c01>\]"
					}
					::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<c>"
				} else {
					::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "Aucun Accès."
				}
			}
			"owner" {
				if { [string index ${value1} 0] != "#" } {
					::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<b>Commande Owner :</b> /msg ${::EvaServ::SERVICE_BOT(name)} owner <#Salon> <Pseudonyme>";
					return 0;
				}

				if {
					${value4} == [string tolower ${::EvaServ::SERVICE_BOT(name)}]			|| \
						[info exists users(${value4})]								|| \
						[protection ${value4}]
				} {
					::EvaServ::SENT::MSG:TO:USER ${user} "Accès Refusé : Pseudo Protégé";
					return 0;
				}
				if { ${value4} != "" } {
					if { ![info exists vhost(${value4})] } {
						::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "Pseudo introuvable.";
						return 0
					}
					FCT:SENT:MODE ${value1} "+q" ${value3}
					if {
						[::EvaServ::ShowOnPartyLine 1]										&& \
							${value2} != [string tolower ${::EvaServ::SERVICE_BOT(channel_logs)}]
					} {
						::EvaServ::SHOW:INFO:TO:CHANLOG "Owner" "${value3} sur ${value1} par ${user}"
					}
				} else {
					FCT:SENT:MODE ${value1} "+q" ${user}
					if {
						[::EvaServ::ShowOnPartyLine 1]										&& \
							${value2} != [string tolower ${::EvaServ::SERVICE_BOT(channel_logs)}]
					} {
						::EvaServ::SHOW:INFO:TO:CHANLOG "Owner" "${user} sur ${value1}"
					}
				}
			}
			"deowner" {
				if { [string index ${value1} 0] != "#" } {
					::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<b>Commande Deowner :</b> /msg ${::EvaServ::SERVICE_BOT(name)} deowner <#Salon> <Pseudonyme>";
					return 0;
				}

				if {
					${value4} == [string tolower ${::EvaServ::SERVICE_BOT(name)}]			|| \
						[info exists users(${value4})]								|| \
						[protection ${value4}]
				} {
					::EvaServ::SENT::MSG:TO:USER ${user} "Accès Refusé : Pseudo Protégé";
					return 0;
				}

				if { ${value4} != "" } {
					if { ![info exists vhost(${value4})] } {
						::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "Pseudo introuvable.";
						return 0;
					}

					FCT:SENT:MODE ${value1} "-q" ${value3}
					if {
						[::EvaServ::ShowOnPartyLine 1]										&& \
							${value2} != [string tolower ${::EvaServ::SERVICE_BOT(channel_logs)}]
					} {
						::EvaServ::SHOW:INFO:TO:CHANLOG "Deowner" "${value3} sur ${value1} par ${user}"
					}
				} else {
					FCT:SENT:MODE ${value1} "-q" ${user}
					if {
						[::EvaServ::ShowOnPartyLine 1]										&& \
							${value2} != [string tolower ${::EvaServ::SERVICE_BOT(channel_logs)}]
					} {
						::EvaServ::SHOW:INFO:TO:CHANLOG "Deowner" "${user} sur ${value1}"
					}
				}
			}
			"protect" {
				if { [string index ${value1} 0] != "#" } {
					::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<b>Commande Protect :</b> /msg ${::EvaServ::SERVICE_BOT(name)} protect <#Salon> <Pseudonyme>";
					return 0;
				}
				if {
					${value4} == [string tolower ${::EvaServ::SERVICE_BOT(name)}]			|| \
						[info exists users(${value4})]								|| \
						[protection ${value4}]
				} {
					::EvaServ::SENT::MSG:TO:USER ${user} "Accès Refusé : Pseudo Protégé";
					return 0;
				}

				if { ${value4} != "" } {
					if { ![info exists vhost(${value4})] } {
						::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "Pseudo introuvable.";
						return 0;
					}

					FCT:SENT:MODE ${value1} "+a" ${value3}
					if {
						[::EvaServ::ShowOnPartyLine 1]										&& \
							${value2} != [string tolower ${::EvaServ::SERVICE_BOT(channel_logs)}]
					} {
						::EvaServ::SHOW:INFO:TO:CHANLOG "Protect" "${value3} sur ${value1} par ${user}"
					}
				} else {
					FCT:SENT:MODE ${value1} "+a" ${user}
					if {
						[::EvaServ::ShowOnPartyLine 1]										&& \
							${value2} != [string tolower ${::EvaServ::SERVICE_BOT(channel_logs)}]
					} {
						::EvaServ::SHOW:INFO:TO:CHANLOG "Protect" "${user} sur ${value1}"
					}
				}
			}
			"deprotect" {
				if { [string index ${value1} 0] != "#" } {
					::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<b>Commande Deprotect :</b> /msg ${::EvaServ::SERVICE_BOT(name)} deprotect <#Salon> <Pseudonyme>";
					return 0;
				}

				if {
					${value4} == [string tolower ${::EvaServ::SERVICE_BOT(name)}]			|| \
						[info exists users(${value4})]								|| \
						[protection ${value4}]
				} {
					::EvaServ::SENT::MSG:TO:USER ${user} "Accès Refusé : Pseudo Protégé";
					return 0;
				}

				if { ${value4} != "" } {
					if { ![info exists vhost(${value4})] } {
						::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "Pseudo introuvable.";
						return 0;
					}

					FCT:SENT:MODE ${value1} "-a" ${value3}
					if {
						[::EvaServ::ShowOnPartyLine 1]										&& \
							${value2} != [string tolower ${::EvaServ::SERVICE_BOT(channel_logs)}] } {
								::EvaServ::SHOW:INFO:TO:CHANLOG "Deprotect" "${value3} sur ${value1} par ${user}"
						}
					} else {
						FCT:SENT:MODE ${value1} "-a" ${user}
						if {
							[::EvaServ::ShowOnPartyLine 1]										&& \
								${value2} != [string tolower ${::EvaServ::SERVICE_BOT(channel_logs)}]
						} {
							::EvaServ::SHOW:INFO:TO:CHANLOG "Deprotect" "${user} sur ${value1}"
						}
					}
				}
				"ownerall" {
					set config(cmd)		"ownerall"
					if { [string index ${value1} 0] != "#" } {
						::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<b>Commande Ownerall :</b> /msg ${::EvaServ::SERVICE_BOT(name)} ownerall <#Salon>";
						return 0;
					}

					sent2socket ":${::EvaServ::config(link)} NAMES ${value1}"
					if {
						[::EvaServ::ShowOnPartyLine 1]										&& \
							${value2} != [string tolower ${::EvaServ::SERVICE_BOT(channel_logs)}]
					} {
						::EvaServ::SHOW:INFO:TO:CHANLOG "Ownerall" "${value1} par ${user}"
					}
				}
				"deownerall" {
					set config(cmd)		"deownerall"
					if { [string index ${value1} 0] != "#" } {
						::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<b>Commande Deownerall :</b> /msg ${::EvaServ::SERVICE_BOT(name)} deownerall <#Salon>";
						return 0;
					}

					sent2socket ":${::EvaServ::config(link)} NAMES ${value1}"
					if {
						[::EvaServ::ShowOnPartyLine 1]											&& \
							${value2} != [string tolower ${::EvaServ::SERVICE_BOT(channel_logs)}]
					} {
						::EvaServ::SHOW:INFO:TO:CHANLOG "Deownerall" "${value1} par ${user}"
					}
				}
				"protectall" {
					set config(cmd)		"protectall"
					if { [string index ${value1} 0] != "#" } {
						::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<b>Commande Protectall :</b> /msg ${::EvaServ::SERVICE_BOT(name)} protectall <#Salon>";
						return 0;
					}

					sent2socket ":${::EvaServ::config(link)} NAMES ${value1}"
					if {
						[::EvaServ::ShowOnPartyLine 1]											&& \
							${value2} != [string tolower ${::EvaServ::SERVICE_BOT(channel_logs)}]
					} {
						::EvaServ::SHOW:INFO:TO:CHANLOG "Protectall" "${value1} par ${user}"
					}
				}
				"deprotectall" {
					set config(cmd)		"deprotectall"
					if { [string index ${value1} 0] != "#" } {
						::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<b>Commande Deprotectall :</b> /msg ${::EvaServ::SERVICE_BOT(name)} deprotectall <#Salon>";
						return 0;
					}

					sent2socket ":${::EvaServ::config(link)} NAMES ${value1}"
					if {
						[::EvaServ::ShowOnPartyLine 1]											&& \
							${value2} != [string tolower ${::EvaServ::SERVICE_BOT(channel_logs)}]
					} {
						::EvaServ::SHOW:INFO:TO:CHANLOG "Deprotectall" "${value1} par ${user}"
					}
				}
				"op" {
					if { [string index ${value1} 0] != "#" } {
						::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<b>Commande Op :</b> /msg ${::EvaServ::SERVICE_BOT(name)} op <#Salon> <Pseudonyme>";
						return 0
					}
					if {
						${value4} == [string tolower ${::EvaServ::SERVICE_BOT(name)}]			|| \
							[info exists users(${value4})]								|| \
							[protection ${value4}]
					} {
						::EvaServ::SENT::MSG:TO:USER ${user} "Accès Refusé : Pseudo Protégé";
						return 0
					}
					if { ${value4} != "" } {
						if { ![info exists vhost(${value4})] } {
							::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "Pseudo introuvable.";
							return 0;
						}
						FCT:SENT:MODE ${value1} "+o" ${value3}
						if {
							[::EvaServ::ShowOnPartyLine 1]										&& \
								${value2} != [string tolower ${::EvaServ::SERVICE_BOT(channel_logs)}]
						} {
							::EvaServ::SHOW:INFO:TO:CHANLOG "Op" "${value3} a été opé par ${user} sur ${value1}"
						}
					} else {
						FCT:SENT:MODE ${value1} "+o" ${user}
						if {
							[::EvaServ::ShowOnPartyLine 1]										&& \
								${value2} != [string tolower ${::EvaServ::SERVICE_BOT(channel_logs)}]
						} {
							::EvaServ::SHOW:INFO:TO:CHANLOG "Op" "${user} a été opé sur ${value1}"
						}
					}
				}
				"deop" {
					if { [string index ${value1} 0] != "#" } {
						::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<b>Commande Deop :</b> /msg ${::EvaServ::SERVICE_BOT(name)} deop <#Salon> <Pseudonyme>";
						return 0;
					}

					if {
						${value4} == [string tolower ${::EvaServ::SERVICE_BOT(name)}]			|| \
							[info exists users(${value4})]								|| \
							[protection ${value4}]
					} {
						::EvaServ::SENT::MSG:TO:USER ${user} "Accès Refusé : Pseudo Protégé";
						return 0;
					}

					if { ${value4} != "" } {
						if { ![info exists vhost(${value4})] } {
							::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "Pseudo introuvable.";
							return 0;
						}

						FCT:SENT:MODE ${value1} "-o" ${value3}
						if {
							[::EvaServ::ShowOnPartyLine 1]										&& \
								${value2} != [string tolower ${::EvaServ::SERVICE_BOT(channel_logs)}]
						} {
							::EvaServ::SHOW:INFO:TO:CHANLOG "Deop" "${value3} a été déopé par ${user} sur ${value1}"
						}
					} else {
						FCT:SENT:MODE ${value1} "-o" ${user}
						if {
							[::EvaServ::ShowOnPartyLine 1]										&& \
								${value2} != [string tolower ${::EvaServ::SERVICE_BOT(channel_logs)}]
						} {
							::EvaServ::SHOW:INFO:TO:CHANLOG "Deop" "${user} a été déopé sur ${value1}"
						}
					}
				}
				"halfop" {
					if { [string index ${value1} 0] != "#" } {
						::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<b>Commande Halfop :</b> /msg ${::EvaServ::SERVICE_BOT(name)} halfop <#Salon> <Pseudonyme>";
						return 0;
					}
					if {
						${value4} == [string tolower ${::EvaServ::SERVICE_BOT(name)}]			|| \
							[info exists users(${value4})]								|| \
							[protection ${value4}]
					} {
						::EvaServ::SENT::MSG:TO:USER ${user} "Accès Refusé : Pseudo Protégé";
						return 0;
					}

					if { ${value4} != "" } {
						if { ![info exists vhost(${value4})] } {
							::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "Pseudo introuvable.";
							return 0;
						}

						FCT:SENT:MODE ${value1} "+h" ${value3}
						if {
							[::EvaServ::ShowOnPartyLine 1]										&& \
								${value2} != [string tolower ${::EvaServ::SERVICE_BOT(channel_logs)}]
						} {
							::EvaServ::SHOW:INFO:TO:CHANLOG "Halfop" "${value3} a été halfopé par ${user} sur ${value1}"
						}
					} else {
						FCT:SENT:MODE ${value1} "+h" ${user}
						if {
							[::EvaServ::ShowOnPartyLine 1]										&& \
								${value2} != [string tolower ${::EvaServ::SERVICE_BOT(channel_logs)}]
						} {
							::EvaServ::SHOW:INFO:TO:CHANLOG "Halfop" "${user} a été halfopé sur ${value1}"
						}
					}
				}
				"dehalfop" {
					if { [string index ${value1} 0] != "#" } {
						::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<b>Commande Dehalfop :</b> /msg ${::EvaServ::SERVICE_BOT(name)} dehalfop <#Salon> <Pseudonyme>";
						return 0;
					}

					if {
						${value4} == [string tolower ${::EvaServ::SERVICE_BOT(name)}]			|| \
							[info exists users(${value4})]								|| \
							[protection ${value4}]
					} {
						::EvaServ::SENT::MSG:TO:USER ${user} "Accès Refusé : Pseudo Protégé";
						return 0;
					}

					if { ${value4} != "" } {
						if { ![info exists vhost(${value4})] } {
							::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "Pseudo introuvable.";
							return 0;
						}

						FCT:SENT:MODE ${value1} "-h" ${value3}
						if {
							[::EvaServ::ShowOnPartyLine 1]										&& \
								${value2} != [string tolower ${::EvaServ::SERVICE_BOT(channel_logs)}]
						} {
							::EvaServ::SHOW:INFO:TO:CHANLOG "Dehalfop" "${value3} a été déhalfopé par ${user} sur ${value1}"
						}
					} else {
						FCT:SENT:MODE ${value1} "-h" ${user}
						if {
							[::EvaServ::ShowOnPartyLine 1]										&& \
								${value2} != [string tolower ${::EvaServ::SERVICE_BOT(channel_logs)}]
						} {
							::EvaServ::SHOW:INFO:TO:CHANLOG "Dehalfop" "${user} a été déhalfopé sur ${value1}"
						}
					}
				}
				"voice" {
					if { [string index ${value1} 0] != "#" } {
						::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<b>Commande Voice :</b> /msg ${::EvaServ::SERVICE_BOT(name)} voice <#Salon> <Pseudonyme>";
						return 0;
					}

					if {
						${value4} == [string tolower ${::EvaServ::SERVICE_BOT(name)}]			|| \
							[info exists users(${value4})]								|| \
							[protection ${value4}]
					} {
						::EvaServ::SENT::MSG:TO:USER ${user} "Accès Refusé : Pseudo Protégé";
						return 0;
					}

					if { ${value4} != "" } {
						if { ![info exists vhost(${value4})] } {
							::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "Pseudo introuvable.";
							return 0;
						}

						FCT:SENT:MODE ${value1} "+v" ${value3}
						if {
							[::EvaServ::ShowOnPartyLine 1]										&& \
								${value2} != [string tolower ${::EvaServ::SERVICE_BOT(channel_logs)}]
						} {
							::EvaServ::SHOW:INFO:TO:CHANLOG "Voice" "${value3} a été voicé par ${user} sur ${value1}"
						}
					} else {
						FCT:SENT:MODE ${value1} "+v" ${user}
						if {
							[::EvaServ::ShowOnPartyLine 1]										&& \
								${value2} != [string tolower ${::EvaServ::SERVICE_BOT(channel_logs)}]
						} {
							::EvaServ::SHOW:INFO:TO:CHANLOG "Voice" "${user} a été voicé sur ${value1}"
						}
					}
				}
				"devoice" {
					if { [string index ${value1} 0] != "#" } {
						::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<b>Commande Devoice :</b> /msg ${::EvaServ::SERVICE_BOT(name)} devoice <#Salon> <Pseudonyme>";
						return 0;
					}

					if {
						${value4} == [string tolower ${::EvaServ::SERVICE_BOT(name)}]			|| \
							[info exists users(${value4})]								|| \
							[protection ${value4}]
					} {
						::EvaServ::SENT::MSG:TO:USER ${user} "Accès Refusé : Pseudo Protégé";
						return 0;
					}

					if { ${value4} != "" } {
						if { ![info exists vhost(${value4})] } {
							::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "Pseudo introuvable.";
							return 0;
						}

						FCT:SENT:MODE ${value1} "-v" ${value3}
						if {
							[::EvaServ::ShowOnPartyLine 1]										&& \
								${value2} != [string tolower ${::EvaServ::SERVICE_BOT(channel_logs)}]
						} {
							::EvaServ::SHOW:INFO:TO:CHANLOG "Devoice" "${value3} a été dévoicé par ${user} sur ${value1}"
						}
					} else {
						FCT:SENT:MODE ${value1} "-v" ${user}
						if {
							[::EvaServ::ShowOnPartyLine 1]										&& \
								${value2} != [string tolower ${::EvaServ::SERVICE_BOT(channel_logs)}]
						} {
							::EvaServ::SHOW:INFO:TO:CHANLOG "Devoice" "${user} a été dévoicé sur ${value1}"
						}
					}
				}
				"opall" {
					set config(cmd)		"opall"

					if { [string index ${value1} 0] != "#" } {
						::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<b>Commande Opall :</b> /msg ${::EvaServ::SERVICE_BOT(name)} opall <#Salon>";
						return 0;
					}
					sent2socket ":${::EvaServ::config(link)} NAMES ${value1}"

					if {
						[::EvaServ::ShowOnPartyLine 1]											&& \
							${value2} != [string tolower ${::EvaServ::SERVICE_BOT(channel_logs)}]
					} {
						::EvaServ::SHOW:INFO:TO:CHANLOG "Opall" "${value1} par ${user}"
					}
				}
				"deopall" {
					set config(cmd)		"deopall"
					if { [string index ${value1} 0] != "#" } {
						::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<b>Commande Deopall :</b> /msg ${::EvaServ::SERVICE_BOT(name)} deopall <#Salon>";
						return 0;
					}

					sent2socket ":${::EvaServ::config(link)} NAMES ${value1}"
					if {
						[::EvaServ::ShowOnPartyLine 1]											&& \
							${value2} != [string tolower ${::EvaServ::SERVICE_BOT(channel_logs)}]
					} {
						::EvaServ::SHOW:INFO:TO:CHANLOG "Deopall" "${value1} par ${user}"
					}
				}
				"halfopall" {
					set config(cmd)		"halfopall"
					if { [string index ${value1} 0] != "#" } {
						::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<b>Commande Halfopall :</b> /msg ${::EvaServ::SERVICE_BOT(name)} halfopall <#Salon>";
						return 0;
					}

					sent2socket ":${::EvaServ::config(link)} NAMES ${value1}"
					if {
						[::EvaServ::ShowOnPartyLine 1]											&& \
							${value2} != [string tolower ${::EvaServ::SERVICE_BOT(channel_logs)}]
					} {
						::EvaServ::SHOW:INFO:TO:CHANLOG "Halfopall" "${value1} par ${user}"
					}
				}
				"dehalfopall" {
					set config(cmd)		"dehalfopall"
					if { [string index ${value1} 0] != "#" } {
						::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<b>Commande Dehalfopall :</b> /msg ${::EvaServ::SERVICE_BOT(name)} dehalfopall <#Salon>";
						return 0;
					}

					sent2socket ":${::EvaServ::config(link)} NAMES ${value1}"
					if {
						[::EvaServ::ShowOnPartyLine 1]											&& \
							${value2} != [string tolower ${::EvaServ::SERVICE_BOT(channel_logs)}]
					} {
						::EvaServ::SHOW:INFO:TO:CHANLOG "Dehalfopall" "${value1} par ${user}"
					}
				}
				"voiceall" {
					set config(cmd)		"voiceall"
					if { [string index ${value1} 0] != "#" } {
						::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<b>Commande Voiceall :</b> /msg ${::EvaServ::SERVICE_BOT(name)} voiceall <#Salon>";
						return 0;
					}

					sent2socket ":${::EvaServ::config(link)} NAMES ${value1}"
					if {
						[::EvaServ::ShowOnPartyLine 1]											&& \
							${value2} != [string tolower ${::EvaServ::SERVICE_BOT(channel_logs)}]
					} {
						::EvaServ::SHOW:INFO:TO:CHANLOG "Voiceall" "${value1} par ${user}"
					}
				}
				"devoiceall" {
					set config(cmd)		"devoiceall"
					if { [string index ${value1} 0] != "#" } {
						::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<b>Commande Devoiceall :</b> /msg ${::EvaServ::SERVICE_BOT(name)} devoiceall <#Salon>";
						return 0;
					}

					sent2socket ":${::EvaServ::config(link)} NAMES ${value1}"
					if {
						[::EvaServ::ShowOnPartyLine 1]											&& \
							${value2} != [string tolower ${::EvaServ::SERVICE_BOT(channel_logs)}]
					} {
						::EvaServ::SHOW:INFO:TO:CHANLOG "Devoiceall" "${value1} par ${user}"
					}
				}
				"kick" {
					if { [string index ${value1} 0] != "#"							|| \
						${value4} == ""
				} {
					::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<b>Commande Kick :</b> /msg ${::EvaServ::SERVICE_BOT(name)} kick <#Salon> <Pseudonyme> <Raison>";
					return 0;
				}

				if {
					${value4} == [string tolower ${::EvaServ::SERVICE_BOT(name)}]			|| \
						[info exists users(${value4})]								|| \
						[protection ${value4}]
				} {
					::EvaServ::SENT::MSG:TO:USER ${user} "Accès Refusé : Pseudo Protégé";
					return 0;
				}

				if { ${value5} == "" } { set value5		"Kicked" }
				::EvaServ::FCT:SENT:SERV KICK ${value2} ${value4} ${value5} [rnick ${user}];
				if {
					[::EvaServ::ShowOnPartyLine 1]											&& \
						${value2} != [string tolower ${::EvaServ::SERVICE_BOT(channel_logs)}]
				} {
					::EvaServ::SHOW:INFO:TO:CHANLOG "Kick" "${value3} a été kické par ${user} sur ${value1} - Raison : ${value5}"
				}
			}
			"kickall" {
				set config(cmd)		"kickall";
				set config(rep)		${user}
				if { [string index ${value1} 0] != "#" } {
					::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<b>Commande Kickall :</b> /msg ${::EvaServ::SERVICE_BOT(name)} kickall <#Salon>";
					return 0;
				}

				sent2socket ":${::EvaServ::config(link)} NAMES ${value1}"
				if {
					[::EvaServ::ShowOnPartyLine 1]											&& \
						${value2} != [string tolower ${::EvaServ::SERVICE_BOT(channel_logs)}]
				} {
					::EvaServ::SHOW:INFO:TO:CHANLOG "Kickall" "${value1} par ${user}"
				}
			}
			"ban" {
				if {
					[string index ${value1} 0] != "#"							|| \
						${value3} == ""
				} {
					::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<b>Commande Ban :</b> /msg ${::EvaServ::SERVICE_BOT(name)} ban <#Salon> <Mask>";
					return 0;
				}

				FCT:SENT:MODE ${value1} "+b" ${value3}
				if {
					[::EvaServ::ShowOnPartyLine 1]											&& \
						${value2} != [string tolower ${::EvaServ::SERVICE_BOT(channel_logs)}]
				} {
					::EvaServ::SHOW:INFO:TO:CHANLOG "Ban" "${value3} a été banni par ${user} sur ${value1}"
				}
			}
			"nickban" {
				if {
					[string index ${value1} 0] != "#"							|| \
						${value3} == ""
				} {
					::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<b>Commande Nickban :</b> /msg ${::EvaServ::SERVICE_BOT(name)} nickban <#Salon> <Pseudonyme> <Raison>";
					return 0;
				}

				if {
					${value4} == [string tolower ${::EvaServ::SERVICE_BOT(name)}]			|| \
						[info exists users(${value4})]								|| \
						[protection ${value4}]
				} {
					::EvaServ::SENT::MSG:TO:USER ${user} "Accès Refusé : Pseudo Protégé";
					return 0;
				}

				if { ![info exists vhost(${value4})] } {
					::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "Pseudo introuvable.";
					return 0;
				}

				if { ${value5} == "" } { set value5		"Nick Banned" }
				FCT:SENT:MODE ${value1} "+b" "${value4}*!*@*"
				::EvaServ::FCT:SENT:SERV KICK ${value1} ${value3} ${value5} [rnick ${user}];
				if {
					[::EvaServ::ShowOnPartyLine 1]											&& \
						${value2} != [string tolower ${::EvaServ::SERVICE_BOT(channel_logs)}]
				} {
					::EvaServ::SHOW:INFO:TO:CHANLOG "Nickban" "${value3} a été banni par ${user} sur ${value1} - Raison : ${value5}"
				}
			}
			"kickban" {
				if {
					[string index ${value1} 0] != "#"							|| \
						${value3} == ""
				} {
					::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<b>Commande Kickban :</b> /msg ${::EvaServ::SERVICE_BOT(name)} kickban <#Salon> <Pseudonyme> <Raison>";
					return 0;
				}

				if {
					${value4} == [string tolower ${::EvaServ::SERVICE_BOT(name)}]			|| \
						[info exists users(${value4})]								|| \
						[protection ${value4}]
				} {
					::EvaServ::SENT::MSG:TO:USER ${user} "Accès Refusé : Pseudo Protégé";
					return 0;
				}

				if { ![info exists vhost(${value4})] } {
					::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "Pseudo introuvable.";
					return 0;
				}

				if { ${value5} == "" } { set value5		"Kick Banned" }
				FCT:SENT:MODE ${value1} "+b" "*!*@$vhost(${value4})"
				::EvaServ::FCT:SENT:SERV KICK ${value1} ${value3} ${value5} [rnick ${user}];
				if {
					[::EvaServ::ShowOnPartyLine 1]											&& \
						${value2} != [string tolower ${::EvaServ::SERVICE_BOT(channel_logs)}]
				} {
					::EvaServ::SHOW:INFO:TO:CHANLOG "Kickban" "${value3} a été banni par ${user} sur ${value1} - Raison : ${value5}"
				}
			}
			"unban" {
				if {
					[string index ${value1} 0] != "#"							|| \
						${value3} == ""
				} {
					::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<b>Commande Unban :</b> /msg ${::EvaServ::SERVICE_BOT(name)} unban <#Salon> <Mask>";
					return 0;
				}

				FCT:SENT:MODE ${value1} "-b" ${value3}
				if {
					[::EvaServ::ShowOnPartyLine 1]											&& \
						${value2} != [string tolower ${::EvaServ::SERVICE_BOT(channel_logs)}]
				} {
					::EvaServ::SHOW:INFO:TO:CHANLOG "Unban" "${value3} a été débanni par ${user} sur ${value1}"
				}
			}
			"clearbans" {
				if { [string index ${value1} 0] != "#" } {
					::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<b>Commande Clearbans :</b> /msg ${::EvaServ::SERVICE_BOT(name)} clearbans <#Salon>";
					return 0;
				}

				::EvaServ::FCT:SENT:SERV SVSMODE ${value1} -b;
				if {
					[::EvaServ::ShowOnPartyLine 1]											&& \
						${value2} != [string tolower ${::EvaServ::SERVICE_BOT(channel_logs)}]
				} {
					::EvaServ::SHOW:INFO:TO:CHANLOG "Clearbans" "${value1} par ${user}"
				}
			}
			"topic" {
				if {
					[string index ${value1} 0] != "#"							|| \
						${value6} == ""
				} {
					::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<b>Commande Topic :</b> /msg ${::EvaServ::SERVICE_BOT(name)} topic <#Salon> topic";
					return 0;
				}

				FCT:SET:TOPIC ${value1} ${value6}
				if {
					[::EvaServ::ShowOnPartyLine 1]											&& \
						${value2} != [string tolower ${::EvaServ::SERVICE_BOT(channel_logs)}]
				} {
					::EvaServ::SHOW:INFO:TO:CHANLOG "Topic" "${user} change le topic sur ${value1} : ${value6}"
				}
			}
			"mode" {
				if {
					[string index ${value1} 0] != "#"							|| \
						${value3} == ""
				} {
					::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<b>Commande Mode :</b> /msg ${::EvaServ::SERVICE_BOT(name)} mode <#Salon> <+/-Mode(s)>";
					return 0;
				}

				if { ${value2} == [string tolower ${::EvaServ::SERVICE_BOT(channel_logs)}] } {
					::EvaServ::SENT::MSG:TO:USER ${user} "Accès Refusé";
					return 0;
				}

				if { ![regexp ^\[\+\-\]+\[a-zA-Z\]+$ ${value3}] } {
					::EvaServ::SENT::MSG:TO:USER ${user} "Chanmode Incorrect";
					return 0;
				}

				if {
					[string match *q* ${value3}]								|| \
						[string match *a* ${value3}]								|| \
						[string match *o* ${value3}]								|| \
						[string match *h* ${value3}]								|| \
						[string match *v* ${value3}]
				} {
					::EvaServ::SENT::MSG:TO:USER ${user} "Chanmode Refusé";
					return 0;
				}

				FCT:SENT:MODE ${value1} ${value6}
				if {
					[::EvaServ::ShowOnPartyLine 1]											&& \
						${value2} != [string tolower ${::EvaServ::SERVICE_BOT(channel_logs)}]
				} {
					::EvaServ::SHOW:INFO:TO:CHANLOG "Mode" "${user} applique le mode ${value6} sur ${value1}"
				}
			}
			"clearmodes" {
				if { [string index ${value1} 0] != "#" } {
					::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<b>Commande Clearmodes :</b> /msg ${::EvaServ::SERVICE_BOT(name)} clearmodes <#Salon>";
					return 0;
				}

				if { ${value2} == [string tolower ${::EvaServ::SERVICE_BOT(channel_logs)}] } {
					::EvaServ::SENT::MSG:TO:USER ${user} "Accès Refusé";
					return 0;
				}

				FCT:SENT:MODE ${value1}
				if {
					[::EvaServ::ShowOnPartyLine 1]											&& \
						${value2} != [string tolower ${::EvaServ::SERVICE_BOT(channel_logs)}]
				} {
					::EvaServ::SHOW:INFO:TO:CHANLOG "Clearmodes" "${user} sur ${value1}"
				}
			}
			"clearallmodes" {
				if { [string index ${value1} 0] != "#" } {
					::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<b>Commande Clearallmodes :</b> /msg ${::EvaServ::SERVICE_BOT(name)} clearallmodes <#Salon>";
					return 0;
				}

				if { ${value2} == [string tolower ${::EvaServ::SERVICE_BOT(channel_logs)}] } {
					::EvaServ::SENT::MSG:TO:USER ${user} "Accès Refusé";
					return 0;
				}
				[sid] mode ${::EvaServ::SERVICE_BOT(channel)} ${::EvaServ::SERVICE_BOT(mode_user)} ${::EvaServ::SERVICE_BOT(name)}
				::EvaServ::FCT:SENT:SERV SVSMODE ${value1} -beIqaohv;
				FCT:SENT:MODE ${value1}
				::EvaServ::FCT:SENT:SERV SVSMODE ${value1} -b;
				if { [::EvaServ::ShowOnPartyLine 1] } {
					::EvaServ::SHOW:INFO:TO:CHANLOG "Clearallmodes" "${user} sur ${value1}"
				}
			}
			"kill" {
				if { ${value1} == "" } {
					::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<b>Commande Kill :</b> /msg ${::EvaServ::SERVICE_BOT(name)} kill <Pseudonyme> <Raison>";
					return 0;
				}

				if {
					${value2} == [string tolower ${::EvaServ::SERVICE_BOT(name)}]			|| \
						[info exists users(${value2})]								|| \
						[protection ${value2}]
				} {
					::EvaServ::SENT::MSG:TO:USER ${user} "Accès Refusé : Pseudo Protégé";
					return 0;
				}

				if { ![info exists vhost(${value2})] } {
					::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "Pseudo introuvable.";
					return 0;
				}

				if { ${value6} == "" } { set value6		"Killed" }
				::EvaServ::FCT:SENT:SERV KILL ${value1} ${value6} [rnick ${user}];
				refresh ${value2}
				if { [::EvaServ::ShowOnPartyLine 1] } {
					::EvaServ::SHOW:INFO:TO:CHANLOG "Kill" "${value1} a été killé par ${user} : ${value6}"
				}
			}
			"chankill" {
				set config(cmd)		"chankill";
				set config(rep)		${user}
				if { [string index ${value1} 0] != "#" } {
					::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<b>Commande Chankill :</b> /msg ${::EvaServ::SERVICE_BOT(name)} chankill <#Salon>";
					return 0;
				}

				if { ${value2} == [string tolower ${::EvaServ::SERVICE_BOT(channel_logs)}] } {
					::EvaServ::SENT::MSG:TO:USER ${user} "Accès Refusé";
					return 0;
				}

				sent2socket ":${::EvaServ::config(link)} NAMES ${value1}"
				if { [::EvaServ::ShowOnPartyLine 1] } {
					::EvaServ::SHOW:INFO:TO:CHANLOG "Chankill" "${value1} par ${user}"
				}
			}
			"svsjoin" {
				if {
					[string index ${value1} 0] != "#"							|| \
						${value3} == ""
				} {
					::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<b>Commande Svsjoin :</b> /msg ${::EvaServ::SERVICE_BOT(name)} svsjoin <#Salon> <Pseudonyme>";
					return 0;
				}

				if { ![info exists vhost(${value4})] } {
					::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "Pseudo introuvable.";
					return 0;
				}

				if {
					${value4} == [string tolower ${::EvaServ::SERVICE_BOT(name)}]			|| \
						[info exists users(${value4})]								|| \
						[protection ${value4}]
				} {
					::EvaServ::SENT::MSG:TO:USER ${user} "Accès Refusé : Pseudo Protégé";
					return 0;
				}

				::EvaServ::FCT:SENT:SERV SVSJOIN [UID:CONVERT ${value3}] ${value1};
				if { [::EvaServ::ShowOnPartyLine 1] } {
					::EvaServ::SHOW:INFO:TO:CHANLOG "Svsjoin" "${value3} entre sur ${value1} par ${user}"
				}
			}
			"svspart" {
				if {
					[string index ${value1} 0] != "#"							|| \
						${value3} == ""
				} {
					::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<b>Commande Svspart :</b> /msg ${::EvaServ::SERVICE_BOT(name)} svspart <#Salon> <Pseudonyme>";
					return 0;
				}

				if { ![info exists vhost(${value4})] } {
					::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "Pseudo introuvable.";
					return 0;
				}

				if {
					${value4} == [string tolower ${::EvaServ::SERVICE_BOT(name)}]			|| \
						[info exists users(${value4})]								|| \
						[protection ${value4}]
				} {
					::EvaServ::SENT::MSG:TO:USER ${user} "Accès Refusé : Pseudo Protégé";
					return 0;
				}

				::EvaServ::FCT:SENT:SERV SVSPART ${value3} ${value1};
				if { [::EvaServ::ShowOnPartyLine 1] } {
					::EvaServ::SHOW:INFO:TO:CHANLOG "Svspart" "${value3} part de ${value1} par ${user}"
				}
			}
			"svsnick" {
				if {
					${value1} == ""												|| \
						${value3} == ""
				} {
					::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<b>Commande Svsnick :</b> /msg ${::EvaServ::SERVICE_BOT(name)} svsnick ancien-pseudo nouveau-<Pseudonyme>";
					return 0;
				}

				if { ${value2} == ${value4} } {
					::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "Pseudo Identique.";
					return 0;
				}

				if {
					${value2} == [string tolower ${::EvaServ::SERVICE_BOT(name)}]			|| \
						${value4} == [string tolower ${::EvaServ::SERVICE_BOT(name)}]			|| \
						[info exists users(${value2})]								|| \
						[info exists users(${value4})]								|| \
						[protection ${value2}]		|| \
						[protection ${value4}]
				} {
					::EvaServ::SENT::MSG:TO:USER ${user} "Accès Refusé : Pseudo Protégé";
					return 0;
				}

				if { ![info exists vhost(${value2})] } {
					::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "Pseudo introuvable (${value1}).";
					return 0;
				}

				if { [info exists vhost(${value4})] } {
					::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "Pseudo existant (${value3}).";
					return 0;
				}

				::EvaServ::FCT:SENT:SERV SVSNICK [UID:CONVERT ${value1}] ${value3} [unixtime];
				if {
					[info exists vhost(${value1})]								&& \
						${value1} != ${value3}
				} {
					set vhost(${value3})		$vhost(${value1});
					unset vhost(${value1})
				}
				if { [::EvaServ::ShowOnPartyLine 1] } {
					::EvaServ::SHOW:INFO:TO:CHANLOG "Svsnick" "${user} change le pseudo de ${value1} en ${value3}"
				}
			}
			"say" {
				if {
					[string index ${value1} 0] != "#"							|| \
						${value6} == ""
				} {
					::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<b>Commande Say :</b> /msg ${::EvaServ::SERVICE_BOT(name)} say <#Salon> <Message>";
					return 0;
				}

				::EvaServ::SENT::MSG:TO:USER ${value1} "${value6}"
				if {
					[::EvaServ::ShowOnPartyLine 1]											&& \
						${value2} != [string tolower ${::EvaServ::SERVICE_BOT(channel_logs)}]
				} {
					::EvaServ::SHOW:INFO:TO:CHANLOG "Say" "${user} sur ${value1} : ${value6}"
				}
			}
			"invite" {
				if {
					[string index ${value1} 0] != "#"							|| \
						${value3} == ""
				} {
					::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<b>Commande Invite :</b> /msg ${::EvaServ::SERVICE_BOT(name)} invite <#Salon> <Pseudonyme>";
					return 0;
				}

				if { ![info exists vhost(${value4})] } {
					::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "Pseudo introuvable.";
					return 0;
				}

				::EvaServ::FCT:SENT:SERV INVITE ${value3} ${value1};
				if { [::EvaServ::ShowOnPartyLine 1] } {
					::EvaServ::SHOW:INFO:TO:CHANLOG "Invite" "${user} invite ${value3} sur ${value1}"
				}
			}
			"inviteme" {
				::EvaServ::FCT:SENT:SERV INVITE ${user} ${::EvaServ::SERVICE_BOT(channel_logs)};
				if { [::EvaServ::ShowOnPartyLine 1] } {
					::EvaServ::SHOW:INFO:TO:CHANLOG "Inviteme" "${user}"
				}
			}
			"wallops" {
				if { ${value7} == "" } {
					::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<b>Commande Wallops :</b> /msg ${::EvaServ::SERVICE_BOT(name)} wallops <Message>";
					return 0;
				}

				::EvaServ::FCT:SENT:SERV WALLOPS ${value7} (${user});
				if { [::EvaServ::ShowOnPartyLine 1] } {
					::EvaServ::SHOW:INFO:TO:CHANLOG "Wallops" "${user} : ${value7}"
				}
			}
			"globops" {
				if { ${value7} == "" } {
					::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<b>Commande Globops :</b> /msg ${::EvaServ::SERVICE_BOT(name)} globops <Message>";
					return 0;
				}

				::EvaServ::FCT:SENT:SERV GLOBOPS ${value7} (${user});
				if { [::EvaServ::ShowOnPartyLine 1] } {
					::EvaServ::SHOW:INFO:TO:CHANLOG "Globops" "${user} : ${value7}"
				}
			}
			"notice" {
				if { ${value7} == "" } {
					::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<b>Commande Notice :</b> /msg ${::EvaServ::SERVICE_BOT(name)} notice <Message>";
					return 0;
				}

				::EvaServ::SENT::MSG:TO:USER "$*.*" "\[<b>Notice Globale</b>\] ${value7}"
				if { [::EvaServ::ShowOnPartyLine 1] } {
					::EvaServ::SHOW:INFO:TO:CHANLOG "Notice" "${user}"
				}
			}
			"whois" {
				set config(rep)		${USER_LOWER}
				if { ${value1} == "" } {
					::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<b>Commande Whois :</b> /msg ${::EvaServ::SERVICE_BOT(name)} whois <Pseudonyme>";
					return 0;
				}

				if { ![info exists vhost(${value2})] } {
					::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "Pseudo introuvable.";
					return 0;
				}

				::EvaServ::FCT:SENT:SERV WHOIS ${value1};
				if { [::EvaServ::ShowOnPartyLine 1] } {
					::EvaServ::SHOW:INFO:TO:CHANLOG "Whois" "${user}"
				}
			}
			"changline" {
				set config(cmd)		"changline";
				set config(rep)		${user}
				if { [string index ${value1} 0] != "#" } {
					::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<b>Commande Changline :</b> /msg ${::EvaServ::SERVICE_BOT(name)} changline <#Salon>";
					return 0;
				}

				if { ${value2} == [string tolower ${::EvaServ::SERVICE_BOT(channel_logs)}] } {
					::EvaServ::SENT::MSG:TO:USER ${user} "Accès Refusé";
					return 0;
				}

				sent2socket ":${::EvaServ::config(link)} NAMES ${value1}"
				if { [::EvaServ::ShowOnPartyLine 1] } {
					::EvaServ::SHOW:INFO:TO:CHANLOG "Changline" "${value1} par ${user}"
				}
			}
			"gline" {
				if { ${value1} == "" } {
					::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<b>Commande Gline :</b> /msg ${::EvaServ::SERVICE_BOT(name)} gline <Pseudonyme-ou-IP> <Raison>";
					return 0;
				}

				if {
					${value2} == [string tolower ${::EvaServ::SERVICE_BOT(name)}]			|| \
						[info exists users(${value2})]								|| \
						[protection ${value2}]
				} {
					::EvaServ::SENT::MSG:TO:USER ${user} "Accès Refusé : Pseudo Protégé";
					return 0;
				}

				if { ${value6} == "" } { set value6		"Glined" }
				if { [info exists vhost(${value2})] } {
					sent2socket ":${::EvaServ::config(link)} TKL + G * $vhost(${value2}) ${::EvaServ::SERVICE_BOT(name)} [expr [unixtime] + ${::EvaServ::config(gline_duration)}] [unixtime] : ${value6} [rnick ${user}] (Expire le [duree [expr [unixtime] + ${::EvaServ::config(gline_duration)}]])"
				} elseif { [string match *.* ${value1}] } {
					sent2socket ":${::EvaServ::config(link)} TKL + G * ${value1} ${::EvaServ::SERVICE_BOT(name)} [expr [unixtime] + ${::EvaServ::config(gline_duration)}] [unixtime] : ${value6} [rnick ${user}] (Expire le [duree [expr [unixtime] + ${::EvaServ::config(gline_duration)}]])"
				} else {
					::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "Pseudo introuvable.";
					return 0;
				}
				if { [::EvaServ::ShowOnPartyLine 1] } {
					::EvaServ::SHOW:INFO:TO:CHANLOG "Gline" "${value1} par ${user} - Raison : ${value6}"
				}
			}
			"ungline" {
				if {
					${value1} == ""												|| \
						![string match *@* ${value1}]
				} {
					::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<b>Commande Ungline :</b> /msg ${::EvaServ::SERVICE_BOT(name)} ungline <Ident@HostName-or-IP>";
					return 0;
				}

				sent2socket ":${::EvaServ::config(link)} TKL - G [lindex [split ${value1} @] 0] [lindex [split ${value1} @] 1] ${::EvaServ::SERVICE_BOT(name)}"
				if { [::EvaServ::ShowOnPartyLine 1] } {
					::EvaServ::SHOW:INFO:TO:CHANLOG "Ungline" "${value1} par ${user}"
				}
			}
			"shun" {
				if { ${value1} == "" } {
					::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<b>Commande Shun :</b> /msg ${::EvaServ::SERVICE_BOT(name)} shun <Pseudonyme-ou-IP> <Raison>";
					return 0;
				}

				if {
					${value2} == [string tolower ${::EvaServ::SERVICE_BOT(name)}]			|| \
						[info exists users(${value2})]								|| \
						[protection ${value2}]
				} {
					::EvaServ::SENT::MSG:TO:USER ${user} "Accès Refusé : Pseudo Protégé";
					return 0;
				}

				if { ${value6} == "" } { set value6		"Shun" }
				if { [info exists vhost(${value2})] } {
					sent2socket ":${::EvaServ::config(link)} TKL + s * $vhost(${value2}) ${::EvaServ::SERVICE_BOT(name)} [expr [unixtime] + ${::EvaServ::config(gline_duration)}] [unixtime] : ${value6} [rnick ${user}] (Expire le [duree [expr [unixtime] + ${::EvaServ::config(gline_duration)}]])"
				} elseif { [string match *.* ${value1}] } {
					sent2socket ":${::EvaServ::config(link)} TKL + s * ${value1} ${::EvaServ::SERVICE_BOT(name)} [expr [unixtime] + ${::EvaServ::config(gline_duration)}] [unixtime] : ${value6} [rnick ${user}] (Expire le [duree [expr [unixtime] + ${::EvaServ::config(gline_duration)}]])"
				} else {
					::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "Pseudo introuvable.";
					return 0;
				}
				if { [::EvaServ::ShowOnPartyLine 1] } {
					::EvaServ::SHOW:INFO:TO:CHANLOG "Shun" "${value1} par ${user} - Raison : ${value6}"
				}
			}
			"unshun" {
				if {
					${value1} == ""												|| \
						![string match *@* ${value1}]
				} {
					::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<b>Commande Unshun :</b> /msg ${::EvaServ::SERVICE_BOT(name)} unshun <Ident@HostName-or-IP>";
					return 0;
				}

				sent2socket ":${::EvaServ::config(link)} TKL - s [lindex [split ${value1} @] 0] [lindex [split ${value1} @] 1] ${::EvaServ::SERVICE_BOT(name)}"
				if { [::EvaServ::ShowOnPartyLine 1] } {
					::EvaServ::SHOW:INFO:TO:CHANLOG "Unshun" "${value1} par ${user}"
				}
			}
			"kline" {
				if { ${value1} == "" } {
					::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<b>Commande Kline :</b> /msg ${::EvaServ::SERVICE_BOT(name)} kline <Pseudonyme-ou-IP> <Raison>";
					return 0;
				}

				if {
					${value2} == [string tolower ${::EvaServ::SERVICE_BOT(name)}]			|| \
						[info exists users(${value2})]								|| \
						[protection ${value2}]
				} {
					::EvaServ::SENT::MSG:TO:USER ${user} "Accès Refusé : Pseudo Protégé";
					return 0;
				}

				if { ${value6} == "" } { set value6		"Klined" }
				if { [info exists vhost(${value2})] } {
					sent2socket ":${::EvaServ::config(link)} TKL + k * $vhost(${value2}) ${::EvaServ::SERVICE_BOT(name)} [expr [unixtime] + ${::EvaServ::config(gline_duration)}] [unixtime] : ${value6} [rnick ${user}] (Expire le [duree [expr [unixtime] + ${::EvaServ::config(gline_duration)}]])"
				} elseif { [string match *.* ${value1}] } {
					sent2socket ":${::EvaServ::config(link)} TKL + k * ${value1} ${::EvaServ::SERVICE_BOT(name)} [expr [unixtime] + ${::EvaServ::config(gline_duration)}] [unixtime] : ${value6} [rnick ${user}] (Expire le [duree [expr [unixtime] + ${::EvaServ::config(gline_duration)}]])"
				} else {
					::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "Pseudo introuvable.";
					return 0;
				}
				if { [::EvaServ::ShowOnPartyLine 1] } {
					::EvaServ::SHOW:INFO:TO:CHANLOG "Kline" "${value1} par ${user} - Raison : ${value6}"
				}
			}
			"unkline" {
				if {
					${value1} == ""												|| \
						![string match *@* ${value1}]
				} {
					::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<b>Commande Unkline :</b> /msg ${::EvaServ::SERVICE_BOT(name)} unkline <Ident@HostName-or-IP>";
					return 0;
				}

				sent2socket ":${::EvaServ::config(link)} TKL - k [lindex [split ${value1} @] 0] [lindex [split ${value1} @] 1] ${::EvaServ::SERVICE_BOT(name)}"
				if { [::EvaServ::ShowOnPartyLine 1] } {
					::EvaServ::SHOW:INFO:TO:CHANLOG "Unkline" "${value1} par ${user}"
				}
			}
			"glinelist" {
				set config(cmd)		"gline";
				set config(rep)		${USER_LOWER}
				::EvaServ::FCT:SENT:SERV STATS G;
				if { [::EvaServ::ShowOnPartyLine 1] } {
					::EvaServ::SHOW:INFO:TO:CHANLOG "Glinelist" "${user}"
				}
			}
			"shunlist" {
				set config(cmd)		"shun";
				set config(rep)		${USER_LOWER}
				::EvaServ::FCT:SENT:SERV STATS s;
				if { [::EvaServ::ShowOnPartyLine 1] } {
					::EvaServ::SHOW:INFO:TO:CHANLOG "Shunlist" "${user}"
				}
			}
			"klinelist" {
				set config(cmd)		"kline";
				set config(rep)		${USER_LOWER}
				::EvaServ::FCT:SENT:SERV STATS K;
				if { [::EvaServ::ShowOnPartyLine 1] } {
					::EvaServ::SHOW:INFO:TO:CHANLOG "Klinelist" "${user}"
				}
			}
			"cleargline" {
				set config(cmd)		"cleargline"
				::EvaServ::FCT:SENT:SERV STATS G;
				::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "Liste des glines vidée."
				if { [::EvaServ::ShowOnPartyLine 1] } {
					::EvaServ::SHOW:INFO:TO:CHANLOG "Cleargline" "${user}"
				}
			}
			"clearkline" {
				set config(cmd)		"clearkline"
				::EvaServ::FCT:SENT:SERV STATS K;
				::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "Liste des klines vidée."
				if { [::EvaServ::ShowOnPartyLine 1] } {
					::EvaServ::SHOW:INFO:TO:CHANLOG "Clearkline" "${user}"
				}
			}
			"clientlist" {
				catch { open "[Script:Get:Directory]/db/client.db" r } liste
				::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<b><c1,1>------ <c0>Liste des clients IRC interdits <c1>------"
				::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<b>"
				while { ![eof ${liste}] } {
					gets ${liste} version;
					if { ${version} != "" } {
						incr stop 1;
						::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<c01> \[<c03> ${stop} <c01>\] <c01> ${version}"
					}
				}
				catch { close ${liste} }
				if { ${stop} == 0 } {
					::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "Aucun client IRC"
				}
				if { [::EvaServ::ShowOnPartyLine 1] } {
					::EvaServ::SHOW:INFO:TO:CHANLOG "Clientlist" "${user}"
				}
			}
			"clientadd" {
				if { ${value7} == "" } {
					::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<b>Commande clientadd :</b> /msg ${::EvaServ::SERVICE_BOT(name)} clientadd version";
					return 0;
				}

				catch { open "[Script:Get:Directory]/db/client.db" r } liste
				while { ![eof ${liste}] } {
					gets ${liste} verif;
					if { ![string compare -nocase ${value7} ${verif}] } {
						::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<b>${value7}</b> est déjà dans la liste des clients IRC interdits.";
						set stop		1;
						break
					}
				}
				catch { close ${liste} }
				if { ${stop} == 1 } { return 0 }
				set bclient		[open "[Script:Get:Directory]/db/client.db" a];
				puts ${bclient} [string tolower ${value7}];
				close ${bclient}
				::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<b>${value7}</b> a bien été ajouté à la liste des clients IRC interdits."
				if { [::EvaServ::ShowOnPartyLine 1] } {
					::EvaServ::SHOW:INFO:TO:CHANLOG "clientadd" "${user}"
				}
			}
			"clientdel" {
				if { ${value7} == "" } {
					::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<b>Commande clientdel :</b> /msg ${::EvaServ::SERVICE_BOT(name)} clientdel version";
					return 0;
				}

				catch { open "[Script:Get:Directory]/db/client.db" r } liste
				while { ![eof ${liste}] } {
					gets ${liste} verif;
					if { ![string compare -nocase ${value7} ${verif}] } { set stop		1 }
					if {
						[string compare -nocase ${value7} ${verif}]				&& \
							${verif} != ""
					} {
						lappend vers "${verif}"
					}
				}
				catch { close ${liste} }
				if { ${stop} == 0 } {
					::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<b>${value7}</b> n'est pas dans la liste des clients IRC interdits.";
					return 0;
				} else {
					if [info exists vers] {
						set FILE_PIPE		[open "[Script:Get:Directory]/db/client.db" w+];
						foreach clientdel ${vers} { puts ${FILE_PIPE} "${clientdel}" }
						close ${FILE_PIPE}
					} else {
						set FILE_PIPE		[open "[Script:Get:Directory]/db/client.db" w+];
						close ${FILE_PIPE}
					}
					::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<b>${value7}</b> a bien été supprimé de la liste des clients IRC interdits."
					if { [::EvaServ::ShowOnPartyLine 1] } {
						::EvaServ::SHOW:INFO:TO:CHANLOG "clientdel" "${user}"
					}
				}
			}
			"client" {
				if {
					${value2} != "on"											&& \
						${value2} != "off"
				} {
					::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<b>Commande Client :</b> /msg ${::EvaServ::SERVICE_BOT(name)} client On/Off";
					return 0;
				}

				if { ${value2} == "on" } {
					if { ${::EvaServ::config(aclient)} == 0 } {
						set config(aclient)		1;
						::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "Protection clients IRC activée"
						if { [::EvaServ::ShowOnPartyLine 1] } {
							::EvaServ::SHOW:INFO:TO:CHANLOG "Client" "${user}"
						}
					} else {
						::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "La protection clients IRC est déjà activée."
					}
				} elseif { ${value2} == "off" } {
					if { ${::EvaServ::config(aclient)} == 1 } {
						set config(aclient)		0;
						::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "Protection clients IRC désactivée"
						if { [::EvaServ::ShowOnPartyLine 1] } {
							::EvaServ::SHOW:INFO:TO:CHANLOG "Client" "${user}"
						}
					} else {
						::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "La protection clients IRC est déjà désactivée."
					}
				}
			}
			"closeadd" {
				set config(cmd)		"closeadd";
				set config(rep)		${user}
				if { [string index ${value1} 0] != "#" } {
					::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<b>Commande Close add :</b> /msg ${::EvaServ::SERVICE_BOT(name)} closeadd <#Salon>";
					return 0;
				}

				if { ${value2} == [string tolower ${::EvaServ::SERVICE_BOT(channel_logs)}] } {
					::EvaServ::SENT::MSG:TO:USER ${user} "Accès Refusé : Salon de logs";
					return 0;
				}

				catch { open "[Script:Get:Directory]/db/salon.db" r } liste1
				while { ![eof ${liste1}] } {
					gets ${liste1} verif1;
					if { ![string compare -nocase ${value2} ${verif1}] } {
						::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "Accès Refusé : Salon Interdit";
						set stop		1;
						break
					}
				}
				catch { close ${liste1} }
				if { ${stop} == 1 } { return 0 }
				catch { open "[Script:Get:Directory]/db/chan.db" r } liste3
				while { ![eof ${liste3}] } {
					gets ${liste3} verif3;
					if { ![string compare -nocase ${value2} ${verif3}] } {
						::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "Accès Refusé : Salon Autojoin";
						set stop		1;
						break
					}
				}
				catch { close ${liste3} }
				if { ${stop} == 1 } { return 0 }
				catch { open "[Script:Get:Directory]/db/close.db" r } liste
				while { ![eof ${liste}] } {
					gets ${liste} verif;
					if { ![string compare -nocase ${value2} ${verif}] } {
						::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<b>${value1}</b> est déjà dans la liste des salons fermés.";
						set stop		1;
						break
					}
				}
				catch { close ${liste} }
				if { ${stop} == 1 } { return 0 }
				set FILE_PIPE		[open "[Script:Get:Directory]/db/close.db" a];
				puts ${FILE_PIPE} ${value2};
				close ${FILE_PIPE}
				::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<b>${value1}</b> vient d'être ajouté dans la liste des salons fermés."
				::EvaServ::FCT:SENT:SERV JOIN ${value1};
				FCT:SENT:MODE ${value1} +sntio "${::EvaServ::SERVICE_BOT(name)}";
				FCT:SET:TOPIC ${value1} "<c1>Salon Fermé le [duree [unixtime]]"
				sent2socket ":${::EvaServ::config(link)} NAMES ${value1}"
				if { [::EvaServ::ShowOnPartyLine 1] } {
					::EvaServ::SHOW:INFO:TO:CHANLOG "closeadd" "${value1} par ${user}"
				}
			}
			"closedel" {
				if { [string index ${value1} 0] != "#" } {
					::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<b>Commande closedel :</b> /msg ${::EvaServ::SERVICE_BOT(name)} closedel <#Salon>";
					return 0;
				}

				catch { open "[Script:Get:Directory]/db/close.db" r } liste
				while { ![eof ${liste}] } {
					gets ${liste} verif;
					if { ![string compare -nocase ${value2} ${verif}] } { set stop		1 }
					if {
						[string compare -nocase ${value2} ${verif}]				&& \
							${verif} != ""
					} {
						lappend salon "${verif}"
					}
				}
				catch { close ${liste} }
				if { ${stop} == 0 } {
					::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<b>${value1}</b> n'est pas dans la liste des salons fermés.";
					return 0;
				} else {
					if [info exists salon] {
						set FILE_PIPE		[open "[Script:Get:Directory]/db/close.db" w+];
						foreach chandel ${salon} { puts ${FILE_PIPE} "${chandel}" }
						close ${FILE_PIPE}
					} else {
						set FILE_PIPE		[open "[Script:Get:Directory]/db/close.db" w+];
						close ${FILE_PIPE}
					}
					::EvaServ::SENT::MSG:TO:USER ${user} "<b>${value1}</b> a bien été supprimé de la liste des salons fermés."
					FCT:SENT:MODE ${value1}
					FCT:SET:TOPIC ${value1} "Bienvenue sur ${value1}"
					::EvaServ::FCT:SENT:SERV PART ${value1};
					if { [::EvaServ::ShowOnPartyLine 1] } {
						::EvaServ::SHOW:INFO:TO:CHANLOG "closedel" "${value1} par ${user}"
					}
				}
			}
			"closelist" {
				catch { open "[Script:Get:Directory]/db/close.db" r } liste
				::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<b><c1,1>------ <c0>Liste des salons fermés <c1>------"
				::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<b>"
				while { ![eof ${liste}] } {
					gets ${liste} salon;
					if { ${salon} != "" } {
						incr stop 1;
						::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<c1> \[<c03> ${stop} <c01>\] <c01> ${salon}"
					}
				}
				catch { close ${liste} }
				if { ${stop} == 0 } {
					::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "Aucun Salon."
				}
				if { [::EvaServ::ShowOnPartyLine 1] } {
					::EvaServ::SHOW:INFO:TO:CHANLOG "Closelist" "${user}"
				}
			}
			"closeclear" {
				catch { open "[Script:Get:Directory]/db/close.db" r } liste
				while { ![eof ${liste}] } {
					gets ${liste} salon
					if { ${salon} != "" } {
						FCT:SENT:MODE ${salon}
						FCT:SET:TOPIC ${salon} "Bienvenue sur ${salon}"
						::EvaServ::FCT:SENT:SERV PART ${salon};
					}
				}
				catch { close ${liste} }
				set FILE_PIPE		[open "[Script:Get:Directory]/db/close.db" w+];
				close ${FILE_PIPE}
				::EvaServ::SENT::MSG:TO:USER ${user} "La liste des salons fermés à bien été vidée."
				if { [::EvaServ::ShowOnPartyLine 1] } {
					::EvaServ::SHOW:INFO:TO:CHANLOG "closeclear" "${user}"
				}
			}
			"nickadd" {
				if { ${value2} == "" } {
					::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<b>Commande nickadd :</b> /msg ${::EvaServ::SERVICE_BOT(name)} nickadd <Pseudonyme>";
					return 0;
				}

				if { [string match *${value2}* [string tolower ${::EvaServ::SERVICE_BOT(name)}]] } {
					::EvaServ::SENT::MSG:TO:USER ${user} "Accès Refusé : Pseudo Protégé";
					return 0;
				}

				foreach { p n } [array get users] {
					if { [string match *${value2}* ${p}] } {
						::EvaServ::SENT::MSG:TO:USER ${user} "Accès Refusé : Pseudo Protégé";
						return 0;
					}

				}
				foreach { a r } [array get admins] {
					if { [string match *${value2}* ${r}] } {
						::EvaServ::SENT::MSG:TO:USER ${user} "Accès Refusé : Pseudo Protégé";
						return 0;
					}

				}
				catch { open "[Script:Get:Directory]/db/nick.db" r } liste
				while { ![eof ${liste}] } {
					gets ${liste} verif;
					if { ![string compare -nocase ${value2} ${verif}] } {
						::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<b>${value1}</b> est déjà dans la liste des pseudos interdits.";
						set stop		1;
						break
					}
				}
				catch { close ${liste} }
				if { ${stop} == 1 } { return 0 }
				set nick		[open "[Script:Get:Directory]/db/nick.db" a];
				puts ${nick} ${value2};
				close ${nick}
				::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<b>${value1}</b> a bien été ajouté dans la liste des pseudos interdits."
				if { [::EvaServ::ShowOnPartyLine 1] } {
					::EvaServ::SHOW:INFO:TO:CHANLOG "nickadd" "${user}"
				}
			}
			"nickdel" {
				if { ${value2} == "" } {
					::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<b>Commande nickdel :</b> /msg ${::EvaServ::SERVICE_BOT(name)} nickdel <Pseudonyme>";
					return 0;
				}

				catch { open "[Script:Get:Directory]/db/nick.db" r } liste
				while { ![eof ${liste}] } {
					gets ${liste} verif;
					if { ![string compare -nocase ${value2} ${verif}] } { set stop		1 }
					if {
						[string compare -nocase ${value2} ${verif}]				&& \
							${verif} != ""
					} {
						lappend pseudo "${verif}"
					}
				}
				catch { close ${liste} }
				if { ${stop} == 0 } {
					::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<b>${value1}</b> n'est pas dans la liste des pseudos interdits.";
					return 0;
				} else {
					if { [info exists pseudo] } {
						set FILE_PIPE		[open "[Script:Get:Directory]/db/nick.db" w+];
						foreach nickdel ${pseudo} { puts ${FILE_PIPE} "$nickdel" }
						close ${FILE_PIPE}
					} else {
						set FILE_PIPE		[open "[Script:Get:Directory]/db/nick.db" w+];
						close ${FILE_PIPE}
					}
					::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<b>${value1}</b> a bien été supprimé de la liste des pseudos interdits."
					if { [::EvaServ::ShowOnPartyLine 1] } {
						::EvaServ::SHOW:INFO:TO:CHANLOG "nickdel" "${user}"
					}
				}
			}
			"nicklist" {
				catch { open "[Script:Get:Directory]/db/nick.db" r } liste
				::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<b><c1,1>--------- <c0>Pseudos Interdits <c1>---------"
				::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<b>"
				while { ![eof ${liste}] } {
					gets ${liste} pseudo;
					if { ${pseudo} != "" } {
						incr stop 1;
						::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<c01> \[<c03> ${stop} <c01>\] <c01> ${pseudo}"
					}
				}
				catch { close ${liste} }
				if { ${stop} == 0 } {
					::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "Aucun <Pseudonyme>"
				}
				if { [::EvaServ::ShowOnPartyLine 1] } {
					::EvaServ::SHOW:INFO:TO:CHANLOG "Nicklist" "${user}"
				}
			}
			"identadd" {
				if { ${value2} == "" } {
					::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<b>Commande identadd :</b> /msg ${::EvaServ::SERVICE_BOT(name)} identadd <ident>";
					return 0;
				}

				if { [string match *${value2}* [string tolower ${::EvaServ::SERVICE_BOT(username)}]] } {
					::EvaServ::SENT::MSG:TO:USER ${user} "Accès Refusé : Ident Protégé";
					return 0;
				}

				catch { open "[Script:Get:Directory]/db/ident.db" r } liste
				while { ![eof ${liste}] } {
					gets ${liste} verif;
					if { ![string compare -nocase ${value2} ${verif}] } {
						::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<b>${value1}</b> est déjà dans la liste des idents interdits.";
						set stop		1;
						break
					}
				}
				catch { close ${liste} }
				if { ${stop} == 1 } { return 0 }
				set ident		[open "[Script:Get:Directory]/db/ident.db" a];
				puts ${ident} ${value2};
				close ${ident}
				::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<b>${value1}</b> a bien été ajouté dans la liste des idents interdits."
				if { [::EvaServ::ShowOnPartyLine 1] } {
					::EvaServ::SHOW:INFO:TO:CHANLOG "identadd" "${user}"
				}
			}
			"identdel" {
				if { ${value2} == "" } {
					::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<b>Commande identdel :</b> /msg ${::EvaServ::SERVICE_BOT(name)} identdel <ident>";
					return 0;
				}

				catch { open "[Script:Get:Directory]/db/ident.db" r } liste
				while { ![eof ${liste}] } {
					gets ${liste} verif;
					if { ![string compare -nocase ${value2} ${verif}] } { set stop		1 }
					if {
						[string compare -nocase ${value2} ${verif}]				&& \
							${verif} != ""
					} {
						lappend ident "${verif}"
					}
				}
				catch { close ${liste} }
				if { ${stop} == 0 } {
					::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<b>${value1}</b> n'est pas dans la liste des idents interdits.";
					return 0;
				} else {
					if { [info exists ident] } {
						set FILE_PIPE		[open "[Script:Get:Directory]/db/ident.db" w+];
						foreach identdel ${ident} { puts ${FILE_PIPE} "$identdel" }
						close ${FILE_PIPE}
					} else {
						set FILE_PIPE		[open "[Script:Get:Directory]/db/ident.db" w+];
						close ${FILE_PIPE}
					}
					::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<b>${value1}</b> a bien été supprimé de la liste des idents interdits."
					if { [::EvaServ::ShowOnPartyLine 1] } {
						::EvaServ::SHOW:INFO:TO:CHANLOG "identdel" "${user}"
					}
				}
			}
			"identlist" {
				catch { open "[Script:Get:Directory]/db/ident.db" r } liste
				::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<b><c1,1>---------- <c0>Idents Interdits <c1>----------"
				::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<b>"
				while { ![eof ${liste}] } {
					gets ${liste} ident;
					if { ${ident} != "" } {
						incr stop 1;
						::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<c01> \[<c03> ${stop} <c01>\] <c01> ${ident}"
					}
				}
				catch { close ${liste} }
				if { ${stop} == 0 } {
					::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "Aucun <ident>"
				}
				if { [::EvaServ::ShowOnPartyLine 1] } {
					::EvaServ::SHOW:INFO:TO:CHANLOG "Identlist" "${user}"
				}
			}
			"realadd" {
				if { ${value2} == "" } {
					::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<b>Commande realadd :</b> /msg ${::EvaServ::SERVICE_BOT(name)} realadd <realname>";
					return 0;
				}

				if { [string match *${value2}* [string tolower ${::EvaServ::SERVICE_BOT(gecos)}]] } {
					::EvaServ::SENT::MSG:TO:USER ${user} "Accès Refusé : Realname Protégé";
					return 0;
				}

				catch { open "[Script:Get:Directory]/db/real.db" r } liste
				while { ![eof ${liste}] } {
					gets ${liste} verif;
					if { ![string compare -nocase ${value2} ${verif}] } {
						::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<b>${value1}</b> est déjà dans la liste des realnames interdits.";
						set stop		1;
						break
					}
				}
				catch { close ${liste} }
				if { ${stop} == 1 } { return 0 }
				set real		[open "[Script:Get:Directory]/db/real.db" a];
				puts ${real} ${value2};
				close ${real}
				::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<b>${value1}</b> a bien été ajouté dans la liste des realnames interdits."
				if { [::EvaServ::ShowOnPartyLine 1] } {
					::EvaServ::SHOW:INFO:TO:CHANLOG "realadd" "${user}"
				}
			}
			"realdel" {
				if { ${value2} == "" } {
					::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<b>Commande realdel :</b> /msg ${::EvaServ::SERVICE_BOT(name)} realdel <realname>";
					return 0;
				}

				catch { open "[Script:Get:Directory]/db/real.db" r } liste
				while { ![eof ${liste}] } {
					gets ${liste} verif;
					if { ![string compare -nocase ${value2} ${verif}] } { set stop		1 }
					if {
						[string compare -nocase ${value2} ${verif}]				&& \
							${verif} != ""
					} {
						lappend real "${verif}"
					}
				}
				catch { close ${liste} }
				if { ${stop} == 0 } {
					::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<b>${value1}</b> n'est pas dans la liste des realnames interdits.";
					return 0;
				} else {
					if { [info exists real] } {
						set FILE_PIPE		[open "[Script:Get:Directory]/db/real.db" w+];
						foreach realdel ${real} { puts ${FILE_PIPE} "$realdel" }
						close ${FILE_PIPE}
					} else {
						set FILE_PIPE		[open "[Script:Get:Directory]/db/real.db" w+];
						close ${FILE_PIPE}
					}
					::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<b>${value1}</b> a bien été supprimé de la liste des realnames interdits."
					if { [::EvaServ::ShowOnPartyLine 1] } {
						::EvaServ::SHOW:INFO:TO:CHANLOG "realdel" "${user}"
					}
				}
			}
			"reallist" {
				catch { open "[Script:Get:Directory]/db/real.db" r } liste
				::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<b><c1,1>--------- <c0>Realnames Interdits <c1>---------"
				::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<b>"
				while { ![eof ${liste}] } {
					gets ${liste} real;
					if { ${real} != "" } {
						incr stop 1;
						::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<c01> \[<c03> ${stop} <c01>\] <c01> ${real}"
					}
				}
				catch { close ${liste} }
				if { ${stop} == 0 } {
					::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "Aucun <realname>"
				}
				if { [::EvaServ::ShowOnPartyLine 1] } {
					::EvaServ::SHOW:INFO:TO:CHANLOG "Reallist" "${user}"
				}
			}
			"hostadd" {
				if { ${value2} == "" } {
					::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<b>Commande hostadd :</b> /msg ${::EvaServ::SERVICE_BOT(name)} hostadd <HostName>";
					return 0;
				}

				if {
					[string match *${value2}* [string tolower ${::EvaServ::SERVICE_BOT(hostname)}]]	|| \
						[info exists protect(${value2})]
				} {
					::EvaServ::SENT::MSG:TO:USER ${user} "Accès Refusé : Hostname Protégée";
					return 0;
				}

				foreach { mask num } [array get trust] {
					if { [string match *${value2}* ${mask}] } {
						::EvaServ::SENT::MSG:TO:USER ${user} "Accès Refusé : Hostname Trustée";
						return 0;
					}

				}
				catch { open "[Script:Get:Directory]/db/host.db" r } liste
				while { ![eof ${liste}] } {
					gets ${liste} verif;
					if { ![string compare -nocase ${value2} ${verif}] } {
						::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<b>${value1}</b> est déjà dans la liste des hostnames interdites.";
						set stop		1;
						break
					}
				}
				catch { close ${liste} }
				if { ${stop} == 1 } { return 0 }
				set host		[open "[Script:Get:Directory]/db/host.db" a];
				puts ${host} ${value2};
				close ${host}
				::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<b>${value1}</b> a bien été ajouté dans la liste des hostnames interdites."
				if { [::EvaServ::ShowOnPartyLine 1] } {
					::EvaServ::SHOW:INFO:TO:CHANLOG "hostadd" "${user}"
				}
			}
			"hostdel" {
				if { ${value2} == "" } {
					::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<b>Commande hostdel :</b> /msg ${::EvaServ::SERVICE_BOT(name)} hostdel <HostName>";
					return 0;
				}

				catch { open "[Script:Get:Directory]/db/host.db" r } liste
				while { ![eof ${liste}] } {
					gets ${liste} verif;
					if { ![string compare -nocase ${value2} ${verif}] } { set stop		1 }
					if {
						[string compare -nocase ${value2} ${verif}]				&& \
							${verif} != ""
					} {
						lappend host "${verif}"
					}
				}
				catch { close ${liste} }
				if { ${stop} == 0 } {
					::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<b>${value1}</b> n'est pas dans la liste des hostnames interdites.";
					return 0;
				} else {
					if { [info exists host] } {
						set FILE_PIPE		[open "[Script:Get:Directory]/db/host.db" w+];
						foreach hostdel ${host} { puts ${FILE_PIPE} "$hostdel" }
						close ${FILE_PIPE}
					} else {
						set FILE_PIPE		[open "[Script:Get:Directory]/db/host.db" w+];
						close ${FILE_PIPE}
					}
					::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<b>${value1}</b> a bien été supprimé de la liste des hostnames interdites."
					if { [::EvaServ::ShowOnPartyLine 1] } {
						::EvaServ::SHOW:INFO:TO:CHANLOG "hostdel" "${user}"
					}
				}
			}
			"hostlist" {
				catch { open "[Script:Get:Directory]/db/host.db" r } liste
				::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<b><c1,1>----------- <c0>Hostnames Interdites <c1>-----------"
				::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<b>"
				while { ![eof ${liste}] } {
					gets ${liste} host;
					if { ${host} != "" } {
						incr stop 1;
						::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<c01> \[<c03> ${stop} <c01>\] <c01> ${host}"
					}
				}
				catch { close ${liste} }
				if { ${stop} == 0 } {
					::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "Aucune <HostName>"
				}
				if { [::EvaServ::ShowOnPartyLine 1] } {
					::EvaServ::SHOW:INFO:TO:CHANLOG "Hostlist" "${user}"
				}
			}
			"chanadd" {
				if { [string index ${value2} 0] != "#" } {
					::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<b>Commande chanadd :</b> /msg ${::EvaServ::SERVICE_BOT(name)} chanadd <#Salon>";
					return 0;
				}

				if { [string match *[string trimleft ${value2} #]* [string trimleft [string tolower ${::EvaServ::SERVICE_BOT(channel_logs)}] #]] } {
					::EvaServ::SENT::MSG:TO:USER ${user} "Accès Refusé : Salon de logs";
					return 0;
				}

				catch { open "[Script:Get:Directory]/db/chan.db" r } liste1
				while { ![eof ${liste1}] } {
					gets ${liste1} verif1;
					if { [string match *[string trimleft ${value2} #]* [string trimleft ${verif1} #]] } {
						::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "Accès Refusé : Salon Autojoin";
						set stop		1;
						break
					}
				}
				catch { close ${liste1} }
				if { ${stop} == 1 } { return 0 }
				catch { open "[Script:Get:Directory]/db/close.db" r } liste2
				while { ![eof ${liste2}] } {
					gets ${liste2} verif2;
					if { [string match *[string trimleft ${value2} #]* [string trimleft ${verif2} #]] } {
						::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "Accès Refusé : Salon Fermé";
						set stop		1;
						break
					}
				}
				catch { close ${liste2} }
				if { ${stop} == 1 } { return 0 }
				catch { open "[Script:Get:Directory]/db/salon.db" r } liste
				while { ![eof ${liste}] } {
					gets ${liste} verif;
					if { ![string compare -nocase ${value2} ${verif}] } {
						::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<b>${value1}</b> est déjà dans la liste des salons interdits.";
						set stop		1;
						break
					}
				}
				catch { close ${liste} }
				if { ${stop} == 1 } { return 0 }
				set chan		[open "[Script:Get:Directory]/db/salon.db" a];
				puts ${chan} ${value2};
				close ${chan}
				::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<b>${value1}</b> a bien été ajouté dans la liste des salons interdits."
				if { [::EvaServ::ShowOnPartyLine 1] } {
					::EvaServ::SHOW:INFO:TO:CHANLOG "chanadd" "${user}"
				}
			}
			"chandel" {
				if { [string index ${value2} 0] != "#" } {
					::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<b>Commande chandel :</b> /msg ${::EvaServ::SERVICE_BOT(name)} chandel <#Salon>";
					return 0;
				}

				catch { open "[Script:Get:Directory]/db/salon.db" r } liste
				while { ![eof ${liste}] } {
					gets ${liste} verif;
					if { ![string compare -nocase ${value2} ${verif}] } { set stop 1; }
					if {
						[string compare -nocase ${value2} ${verif}]				&& \
							${verif} != ""
					} {
						lappend chan "${verif}";
					}
				}
				catch { close ${liste} }
				if { ${stop} == 0 } {
					::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<b>${value1}</b> n'est pas dans la liste des salons interdits.";
					return 0;
				} else {
					if { [info exists chan] } {
						set FILE_PIPE		[open "[Script:Get:Directory]/db/salon.db" w+];
						foreach chandel ${chan} { puts ${FILE_PIPE} "${chandel}" }
						close ${FILE_PIPE}
					} else {
						set FILE_PIPE		[open "[Script:Get:Directory]/db/salon.db" w+];
						close ${FILE_PIPE}
					}
					::EvaServ::FCT:SENT:SERV PART ${value1};
					::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<b>${value1}</b> a bien été supprimé de la liste des salons interdits."
					if { [::EvaServ::ShowOnPartyLine 1] } {
						::EvaServ::SHOW:INFO:TO:CHANLOG "chandel" "${user}"
					}
				}
			}
			"chanlist" {
				catch { open "[Script:Get:Directory]/db/salon.db" r } liste
				::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<b><c1,1>--------- <c0>Salons Interdits <c1>---------"
				::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<b>"
				while { ![eof ${liste}] } {
					gets ${liste} chan;
					if { ${chan} != "" } {
						incr stop 1;
						::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<c01> \[<c03> ${stop} <c01>\] <c01> ${chan}"
					}
				}
				catch { close ${liste} }
				if { ${stop} == 0 } {
					::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "Aucun Salon"
				}
				if { [::EvaServ::ShowOnPartyLine 1] } {
					::EvaServ::SHOW:INFO:TO:CHANLOG "Chanlist" "${user}"
				}
			}
			"trustadd" {
				if { ${value2} == "" } {
					::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<b>Commande trustadd :</b> /msg ${::EvaServ::SERVICE_BOT(name)} trustadd <Mask>";
					return 0;
				}

				catch { open "[Script:Get:Directory]/db/host.db" r } liste1
				while { ![eof ${liste1}] } {
					gets ${liste1} verif1;
					if { [string match *${value2}* ${verif1}] } {
						::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "Accès Refusé : Hostname Interdite";
						set stop		1;
						break
					}
				}
				catch { close ${liste1} }
				if { ${stop} == 1 } { return 0 }
				catch { open [Script:Get:Directory]/db/trust.db r } liste
				while { ![eof ${liste}] } {
					gets ${liste} verif;
					if { ${verif} == ${value2} } {
						::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<b>${value1}</b> est déjà dans la trustlist.";
						set stop		1;
						break
					}
				}
				catch { close ${liste} }
				if { ${stop} == 1 } { return 0 }
				set bprotect		[open [Script:Get:Directory]/db/trust.db a];
				puts ${bprotect} "${value2}";
				close ${bprotect}
				::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<b>${value1}</b> a bien été ajoutée dans la trustlist."
				if { ![info exists trust(${value2})] } { set trust(${value2})		1 }
				if { [::EvaServ::ShowOnPartyLine 1] } {
					::EvaServ::SHOW:INFO:TO:CHANLOG "trustadd" "${user}"
				}
			}
			"trustdel" {
				if { ${value2} == "" } {
					::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<b>Commande trustdel :</b> /msg ${::EvaServ::SERVICE_BOT(name)} trustdel <Mask>";
					return 0;
				}

				catch { open [Script:Get:Directory]/db/trust.db r } liste
				while { ![eof ${liste}] } {
					gets ${liste} verif;
					if { ${verif} == ${value2} } { set stop		1 }
					if {
						${verif} != ${value2}									&& \
							${verif} != ""
					} {
						lappend hs "${verif}"
					}
				}
				catch { close ${liste} }
				if { ${stop} == 0 } {
					::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<b>${value1}</b> n'est pas dans la trustlist.";
					return 0;
				} else {
					if { [info exists hs] } {
						set FILE_PIPE		[open [Script:Get:Directory]/db/trust.db w+];
						foreach delprotect $hs { puts ${FILE_PIPE} "$delprotect" }
						close ${FILE_PIPE}
					} else {
						set FILE_PIPE		[open [Script:Get:Directory]/db/trust.db w+];
						close ${FILE_PIPE}
					}
					::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<b>${value1}</b> a bien été supprimée de la trustlist."
					if { [info exists trust(${value2})] } { unset trust(${value2})		}
					if { [::EvaServ::ShowOnPartyLine 1] } {
						::EvaServ::SHOW:INFO:TO:CHANLOG "trustdel" "${user}"
					}
				}
			}
			"trustlist" {
				catch { open [Script:Get:Directory]/db/trust.db r } liste
				::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<b><c1,1>----------------- <c0>Liste des Trusts <c1>-----------------"
				::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<b>"
				while { ![eof ${liste}] } {
					gets ${liste} mask;
					if { ${mask} != "" } {
						incr stop 1;
						::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<c01> \[<c03> ${stop} <c01>\] <c01> ${mask}"
					}
				}
				catch { close ${liste} }
				if { ${stop} == 0 } {
					::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "Aucun Trust"
				}
				if { [::EvaServ::ShowOnPartyLine 1] } {
					::EvaServ::SHOW:INFO:TO:CHANLOG "Trustlist" "${user}"
				}
			}
			"accessadd" {
				set USER_NAME	${value2}
				set USER_PASS	${value3}
				if {
					${USER_NAME} == ""										|| \
						${USER_PASS} == ""										|| \
						${value8} == ""											|| \
						[regexp "\[^1-4\]" ${value8}]
				} {
					::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<b>Commande accessadd :</b> /msg ${::EvaServ::SERVICE_BOT(name)} accessadd <Pseudonyme> <Mot-De-Passe> <level>"
					dict for {NIVEAU DATA} $::EvaServ::commands {
						dict with DATA {
							::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<c02>Niveau ${NIVEAU} <c04>:<c01> ${name} (attr ${attr}) "
						}
					}

					return 0
				}
				return [DB_USER::ADD ${USER_LOWER} ${USER_NAME} ${USER_PASS} ${value8}]
			}
			"accessdel" {
				if { ${value1} == "" } {
					::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<b>Commande accessdel :</b> /msg ${::EvaServ::SERVICE_BOT(name)} accessdel <Pseudonyme>";
					return 0;
				}

				if { [string tolower ${admin}] == ${value2} } {
					::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "Accès Refusé.";
					return 0;
				}

				foreach verif [userlist] {
					if { ${value2} == [string tolower ${verif}] } {
						foreach { pseudo auth } [array get admins] {
							if { [string tolower ${auth}] == ${value2} } { unset admins([string tolower ${pseudo}]) }
						}
						deluser ${value2}
						::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<b>${value1}</b> a bien été supprimé de la liste des accès."
						if { [::EvaServ::ShowOnPartyLine 1] } {
							::EvaServ::SHOW:INFO:TO:CHANLOG "accessdel" "${user}"
						}
						return 0
					}
				}
				::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<b>${value1}</b> n'est pas dans la liste des accès."
			}
			"accessmod" {
				if {
					${value2} != "level"										&& \
						${value2} != "pass"
				} {
					::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<b>Commande accessmod Pass :</b> /msg ${::EvaServ::SERVICE_BOT(name)} accessmod pass <Pseudonyme> <Mot-De-Passe>"
					::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<b>Commande accessmod Level :</b> /msg ${::EvaServ::SERVICE_BOT(name)} accessmod level pseudo level"
					return 0
				}
				switch -exact ${value2} {
					"level"	{
						if {
							${value4} == ""										|| \
								${value8} == ""										|| \
								[regexp "\[^1-4\]" ${value8}]
						} {
							::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<b>Commande accessmod Level :</b> /msg ${::EvaServ::SERVICE_BOT(name)} accessmod level pseudo level"
							::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<c02>Level 1 <c04>:<c01> Helpeur"
							::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<c02>Level 2 <c04>:<c01> Géofront"
							::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<c02>Level 3 <c04>:<c01> IRCop"
							::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<c02>Level 4 <c04>:<c01> Admin"
							return 0
						}
						if { [string tolower ${admin}] == ${value4} } {
							::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "Accès Refusé.";
							return 0;
						}

						foreach verif [userlist] {
							if { ${value4} == [string tolower ${verif}] } {
								switch -exact ${value8} {
									1 {
										chattr ${value4} -nmopjltx;
										chattr ${value4} +p
									}
									2 {
										chattr ${value4} -nmopjltx;
										chattr ${value4} +op
									}
									3 {
										chattr ${value4} -nmopjltx;
										chattr ${value4} +mop
									}
									4 {
										chattr ${value4} -nmopjltx;
										chattr ${value4} +nmop
									}
								}
								::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "Changement du level de <b>${value4}</b> reussi."
								if { [::EvaServ::ShowOnPartyLine 1] } {
									::EvaServ::SHOW:INFO:TO:CHANLOG "accessmod" "${user}"
								}
								return 0
							}
						}
						::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<b>${value4}</b> n'est pas dans la liste des accès.";
						return 0;
					}
					"pass" {
						if {
							${value4} == ""									|| \
								${value8} == ""
						} {
							::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<b>Commande accessmod Pass :</b> /msg ${::EvaServ::SERVICE_BOT(name)} accessmod pass <Pseudonyme> <Mot-De-Passe>";
							return 0;
						}

						if { [string tolower ${admin}] == ${value4} } {
							::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "Accès Refusé.";
							return 0;
						}

						foreach verif [userlist] {
							if { ${value4} == [string tolower ${verif}] } {
								if { [string length ${value8}] <= 5 } {
									::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "Le mot de passe doit contenir minimum 6 caractères.";
									return 0;
								}
								setuser ${value3} PASS ${value8}
								::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "Changement du mot de passe de <b>${value4}</b> reussi."
								if { [::EvaServ::ShowOnPartyLine 1] } {
									::EvaServ::SHOW:INFO:TO:CHANLOG "accessmod" "${user}"
								}
								return 0
							}
						}
						::EvaServ::SENT::MSG:TO:USER ${USER_LOWER} "<b>${value4}</b> n'est pas dans la liste des accès.";
						return 0;
					}
				}
			}
			default {
				putlog "socket => command inconue ${IRC_VALUE}"
			}
		}
	}




	#################
	# Eva Connexion #
	#################

	proc ::EvaServ::connexion:server { } {
		variable ::EvaServ::config
		variable ::EvaServ::SERVICE_BOT
		sent2socket "EOS"
		::EvaServ::FCT:SENT:SERV SQLINE ${::EvaServ::SERVICE_BOT(name)} :Reserved for services;
		::EvaServ::FCT:SENT:SERV UID ${::EvaServ::SERVICE_BOT(name)} 1 [unixtime] ${::EvaServ::SERVICE_BOT(username)} ${::EvaServ::SERVICE_BOT(hostname)} ${::EvaServ::config(server_id)} * +qioS * * * :${::EvaServ::SERVICE_BOT(gecos)};
		::EvaServ::FCT:SENT:SERV SJOIN [unixtime] ${::EvaServ::SERVICE_BOT(channel_logs)} + :${::EvaServ::config(server_id)};
		::EvaServ::FCT:SENT:SERV MODE ${::EvaServ::SERVICE_BOT(channel_logs)} +${::EvaServ::config(smode)};
		for { set i		0 } { ${i} < [string length ${::EvaServ::config(chanmode)}] } { incr i } {
			set tmode		[string index ${::EvaServ::config(chanmode)} ${i}]
			if {
				${tmode} == "q"													|| \
					${tmode} == "a"													|| \
					${tmode} == "o"													|| \
					${tmode} == "h"													|| \
					${tmode} == "v"
			} {
				FCT:SENT:MODE ${::EvaServ::SERVICE_BOT(channel_logs)} "+${tmode}" ${::EvaServ::config(server_id)}
			}
		}
		catch { open "[Script:Get:Directory]/db/chan.db" r } autojoin
		while { ![eof ${autojoin}] } {
			gets ${autojoin} salon;
			if { ${salon} != "" } {
				::EvaServ::FCT:SENT:SERV JOIN ${salon};
				if {
					${::EvaServ::config(chanmode)} == "q"									|| \
						${::EvaServ::config(chanmode)} == "a"									|| \
						${::EvaServ::config(chanmode)} == "o"									|| \
						${::EvaServ::config(chanmode)} == "h"									|| \
						${::EvaServ::config(chanmode)} == "v"
				} {
					FCT:SENT:MODE ${salon} "+${::EvaServ::config(chanmode)}" ${::EvaServ::config(server_id)}
				}
			}
		}
		catch { close ${autojoin} }
		catch { open "[Script:Get:Directory]/db/close.db" r } ferme
		while { ![eof ${ferme}] } {
			gets ${ferme} salle;
			if { ${salle} != "" } {
				::EvaServ::FCT:SENT:SERV JOIN ${salle};
				FCT:SENT:MODE ${salle} "+sntio" ${::EvaServ::SERVICE_BOT(name)};
				FCT:SET:TOPIC ${salle} "<c1>Salon Fermé le [duree [unixtime]]";
				sent2socket ":${::EvaServ::config(link)} NAMES ${salle}"
			}
		}
		catch { close ${ferme} }
		incr config(counter) 1
		utimer ${::EvaServ::config(timerco)} ::EvaServ::verif
	}

	proc ::EvaServ::verif { } {
		variable ::EvaServ::config
		if { [valididx ${::EvaServ::config(idx)}] } {
			utimer ${::EvaServ::config(timerco)} ::EvaServ::verif
		} else {
			if { ${::EvaServ::config(counter)} <= "10" } {
				config
				connexion
			} else {
				foreach kill [utimers] {
					if { [lindex ${kill} 1] == "::EvaServ::verif" } { killutimer [lindex ${kill} 2] }
				}
				if { [info exists config(idx)] } { unset config(idx)		}
			}
		}
	}

	proc remove_modenicklist { data } {
		return [::tcl::string::map -nocase {
			"@" "" "&" "" "+" "" "~" "" "%" ""
		} ${data}]
	}
	# TODO:	verifier les fonctions et les implantés dans le nouveau systeme
	proc ::EvaServ::link { idx arg } {
		variable ::EvaServ::config
		variable ::EvaServ::commands
		variable ::EvaServ::admins
		variable ::EvaServ::netadmin
		variable ::EvaServ::vhost
		variable ::EvaServ::protect
		variable ::EvaServ::users
		variable ::EvaServ::trust
		variable UID_DB
		variable ::EvaServ::scoredb
		variable DBU_INFO
		if { ${SERVICE(mode_debug)} } { putlog "Received: ${arg}" }
		set arg	[split ${arg}]
		if { ${::EvaServ::config(debug)} == 1 } {
			::EvaServ::SENT::PUT_DEBUG "[join [lrange ${arg} 0 end]]"
		}
		set user		[FCT:DATA:TO:NICK [string trim [lindex ${arg} 0] :]]
		set vuser		[string tolower ${user}]
		switch -exact [lindex ${arg} 0] {
			"PING" {
				set config(counter)		0
				sent2socket "PONG [lindex ${arg} 1]"
			}
			"NETINFO" {
				set config(netinfo)		[lindex ${arg} 4]
				set config(network)		[lindex ${arg} 8]
				sent2socket "NETINFO 0 [unixtime] 0 ${::EvaServ::config(netinfo)} 0 0 0 ${::EvaServ::config(network)}"
			}
			"SQUIT" {
				set serv		[lindex ${arg} 1]
				if {
					[::EvaServ::ShowOnPartyLine 2]											&& \
						${::EvaServ::config(init)} == 0
				} {
					::EvaServ::SHOW:INFO:TO:CHANLOG "Unlink" "${serv}"
				}
			}
			"SERVER" {
				# Received: SERVER irc.xxx.net 1 :U5002-Fhn6OoEmM-001 Serveur networkname
				set config(ircdservname)	[lindex ${arg} 1]
				set desc		[join [string trim [lrange ${arg} 3 end] :]]
				# set serv		[lindex ${arg} 2]
				# set desc		[join [string trim [lrange ${arg} 4 end] :]]
				if { ${::EvaServ::config(init)} == 1 } {
					connexion:server
				}
			}

		}
		switch -exact [lindex ${arg} 1] {
			"MD"	{
				#:001 MD client 001E6A4GK certfp :023f2eae234f23fed481be360d744e99df957f.....
				if {
					[::EvaServ::ShowOnPartyLine 2]											&& \
						${::EvaServ::config(init)} == 0
				} {
					set user	[FCT:DATA:TO:NICK [lindex ${arg} 3]]
					set certfp	[string trim [string tolower [join [lrange ${arg} 5 end]]] :]
					::EvaServ::SHOW:INFO:TO:CHANLOG "Client CertFP" "${user} (${certfp})"
				}

			}
			"REPUTATION"	{
				#:001 REPUTATION xxx.xxx.xxx.xxx 373
				if {
					[::EvaServ::ShowOnPartyLine 2]											&& \
						${::EvaServ::config(init)} == 0
				} {
					set host	[lindex ${arg} 2]
					set score	[lindex ${arg} 3]
					set scoredb(${host}) ${score}
					set scoredb(last) "${host}|${score}"
					#::EvaServ::SHOW:INFO:TO:CHANLOG "Réputation" "score ${score} (${host})"
				}
			}

			"UID"		{
				set SID				[string range [lindex ${arg} 0] 1 end]
				set nickname		[lindex ${arg} 2]
				set nickname2		[string tolower [lindex ${arg} 2]]
				set hopcount		[lindex ${arg} 3]
				set timestamp		[lindex ${arg} 4]
				set username		[lindex ${arg} 5]
				set hostname		[lindex ${arg} 6]
				set uid				[string toupper [lindex ${arg} 7]]
				set servicestamp	[lindex ${arg} 8]
				set umodes			[lindex ${arg} 9]
				set virthost		[lindex ${arg} 10]
				set cloakedhost		[lindex ${arg} 11]
				set ip				[lindex ${arg} 12]
				set gecos			[string trim [string tolower [join [lrange ${arg} 13 end]]] :]

				set UID_DB([string		toupper ${nickname}])	${uid}
				set UID_DB([string		toupper ${uid}])		${nickname}

				if { ![info exists vhost(${nickname2})] } { set vhost(${nickname2})		${hostname} }

				# Genere une base USER infos:
				if { ![info exists DBU_INFO(${uid},VHOST)] }		{ set DBU_INFO(${uid},VHOST)		${hostname} }
				if { ![info exists DBU_INFO(${uid},IDENT)] }		{ set DBU_INFO(${uid},IDENT)		${username} }
				if { ![info exists DBU_INFO(${uid},NICK)] }		{ set DBU_INFO(${uid},NICK)		${nickname} }
				if { ![info exists DBU_INFO(${uid},REALNAME)] }	{ set DBU_INFO(${uid},REALNAME)	${gecos} }


				if {
					![info exists users(${nickname})]							&& \
						[string match *+*S* ${umodes}]
				} {
					set users(${nickname})		on
				}
				if { ![info exists users(${nickname})] } {
					connexion:user:security:check ${nickname} ${hostname} ${username} ${gecos}
				}
				if { [string match *+*z* ${umodes}] } {
					set stype		"Connexion SSL"
				} else {
					set stype		"Connexion"
				}
				if {
					[::EvaServ::ShowOnPartyLine 2]											&& \
						${::EvaServ::config(init)} == 0
				} {
					set MSG_CONNECT		"[DBU:GET ${uid} NICK]"
					append MSG_CONNECT	" ([DBU:GET ${uid} IDENT]@[DBU:GET ${uid} VHOST]) "
					append MSG_CONNECT	"- Serveur : ${::EvaServ::config(ircdservname)} "
					if { ${scoredb(last)} != "" } {
						if { ![info exists DBU_INFO(${uid},REPUTATION)] } {
							set TMP	[split ${scoredb(last)} "|"]
							set DBU_INFO(${uid},IP)			[lindex ${TMP} 0]
							set DBU_INFO(${uid},REPUTATION)	[lindex ${TMP} 1]
						}
						append MSG_CONNECT	"- Score: [DBU:GET ${uid} REPUTATION] "
					}
					append MSG_CONNECT	"- realname: [DBU:GET ${uid} REALNAME] "
					::EvaServ::SHOW:INFO:TO:CHANLOG ${stype} ${MSG_CONNECT}
				}
			}
			"219" {
				if {
					![info exists config(aff)]									&& \
						${::EvaServ::config(cmd)} == "gline"
				} {
					::EvaServ::SENT::MSG:TO:USER "${::EvaServ::config(rep)}" "Aucun Gline"
				}
				if {
					![info exists config(aff)]									&& \
						${::EvaServ::config(cmd)} == "shun"
				} {
					::EvaServ::SENT::MSG:TO:USER "${::EvaServ::config(rep)}" "Aucun shun"
				}
				if {
					![info exists config(aff)]									&& \
						${::EvaServ::config(cmd)} == "kline"
				} {
					::EvaServ::SENT::MSG:TO:USER "${::EvaServ::config(rep)}" "Aucun Kline"
				}
				if { [info exists config(cmd)] } { unset config(cmd)		}
				if { [info exists config(rep)] } { unset config(rep)		}
				if { [info exists config(aff)] } { unset config(aff)		}
			}
			"223" {
				set host		[lindex ${arg} 4]
				set auteur		[lindex ${arg} 7]
				set raison		[join [string trim [lrange ${arg} 8 end] :]]
				if { ${::EvaServ::config(cmd)} == "gline" } {
					if { ![info exists config(aff)] } {
						set config(aff)		1
						::EvaServ::SENT::MSG:TO:USER "${::EvaServ::config(rep)}" "<b><c1,1>---------------------- <c0>Liste des Glines <c1>----------------------"
						::EvaServ::SENT::MSG:TO:USER "${::EvaServ::config(rep)}" "<b>"
					}
					::EvaServ::SENT::MSG:TO:USER "${::EvaServ::config(rep)}" "Host \[<c03> ${host} <c01>\] | Auteur \[<c03> ${auteur} <c01>\] | Raison \[<c03> ${raison} <c01>\]"
				} elseif { ${::EvaServ::config(cmd)} == "shun" } {
					if { ![info exists config(aff)] } {
						set config(aff)		1
						::EvaServ::SENT::MSG:TO:USER "${::EvaServ::config(rep)}" "<b><c1,1>---------------------- <c0>Liste des Shuns <c1>----------------------"
						::EvaServ::SENT::MSG:TO:USER "${::EvaServ::config(rep)}" "<b>"
					}
					::EvaServ::SENT::MSG:TO:USER "${::EvaServ::config(rep)}" "Host \[<c03> ${host} <c01>\] | Auteur \[<c03> ${auteur} <c01>\] | Raison \[<c03> ${raison} <c01>\]"
				} elseif { ${::EvaServ::config(cmd)} == "kline" } {
					if { ![info exists config(aff)] } {
						set config(aff)		1
						::EvaServ::SENT::MSG:TO:USER "${::EvaServ::config(rep)}" "<b><c1,1>---------------------- <c0>Liste des Klines <c1>----------------------"
						::EvaServ::SENT::MSG:TO:USER "${::EvaServ::config(rep)}" "<b>"
					}
					::EvaServ::SENT::MSG:TO:USER "${::EvaServ::config(rep)}" "Host \[<c03> ${host} <c01>\] | Auteur \[<c03> ${auteur} <c01>\] | Raison \[<c03> ${raison} <c01>\]"
				} elseif { ${::EvaServ::config(cmd)} == "cleargline" } {
					sent2socket ":${::EvaServ::config(link)} TKL - G [lindex [split ${host} @] 0] [lindex [split ${host} @] 1] ${::EvaServ::SERVICE_BOT(name)}"
				} elseif { ${::EvaServ::config(cmd)} == "clearkline" } {
					sent2socket ":${::EvaServ::config(link)} TKL - k [lindex [split ${host} @] 0] [lindex [split ${host} @] 1] ${::EvaServ::SERVICE_BOT(name)}"
				}
			}
			"307" {
				::EvaServ::SENT::MSG:TO:USER "${::EvaServ::config(rep)}" "<c01> \[<c03> NickServ <c01>\] <c02> Oui"
			}
			"487" {
				::EvaServ::SENT::MSG:TO:USER "${::EvaServ::SERVICE_BOT(channel_logs)}" "<c01> \[<c03> ERREUR <c01>\] <c02> ${arg}"
			}
			"310" {
				::EvaServ::SENT::MSG:TO:USER "${::EvaServ::config(rep)}" "<c01> \[<c03> Helpeur <c01>\] <c02> Oui"
			}
			"311" {
				set nick		[lindex ${arg} 3]
				set ident		[lindex ${arg} 4]
				set host		[lindex ${arg} 5]
				set real		[join [string trim [lrange ${arg} 7 end] :]]
				::EvaServ::SENT::MSG:TO:USER "${::EvaServ::config(rep)}" "<b><c1,1>------------------------------ <c0>Whois <c1>------------------------------"
				::EvaServ::SENT::MSG:TO:USER "${::EvaServ::config(rep)}" "<b>"
				::EvaServ::SENT::MSG:TO:USER "${::EvaServ::config(rep)}" "<c01> \[<c03> <Pseudonyme> <c01>\] <c02> ${nick}"
				::EvaServ::SENT::MSG:TO:USER "${::EvaServ::config(rep)}" "<c01> \[<c03> Nom Réel <c01>\] <c02> ${real}"
				::EvaServ::SENT::MSG:TO:USER "${::EvaServ::config(rep)}" "<c01> \[<c03> Host <c01>\] <c02> ${ident}@${host}"
			}
			"312" {
				set serveur		[lindex ${arg} 4]
				set desc		[join [string trim [lrange ${arg} 5 end] :]]
				::EvaServ::SENT::MSG:TO:USER "${::EvaServ::config(rep)}" "<c01> \[<c03> Serveur <c01>\] <c02> ${serveur} (${desc})"
			}
			"313" {
				set grade		[join [lrange ${arg} 6 end]]
				::EvaServ::SENT::MSG:TO:USER "${::EvaServ::config(rep)}" "<c01> \[<c03> Grade <c01>\] <c02> ${grade}"
			}
			"317" {
				set idle		[lindex ${arg} 4]
				::EvaServ::SENT::MSG:TO:USER "${::EvaServ::config(rep)}" "<c01> \[<c03> Idle <c01>\] <c02> [duration ${idle}]"
			}
			"318" {
				if { [info exists config(rep)] } { unset config(rep)		}
			}
			"319" {
				set salon		[join [string trim [lrange ${arg} 4 end] :]]
				::EvaServ::SENT::MSG:TO:USER "${::EvaServ::config(rep)}" "<c01> \[<c03> Salon <c01>\] <c02> ${salon}"
			}
			"320" {
				set swhois		[join [string trim [lrange ${arg} 4 end] :]]
				::EvaServ::SENT::MSG:TO:USER "${::EvaServ::config(rep)}" "<c01> \[<c03> Swhois <c01>\] <c02> ${swhois}"
			}
			"324" {
				set chan		[lindex ${arg} 3]
				set mode		[join [string trimleft [lrange ${arg} 4 end] +]]
				FCT:SENT:MODE ${chan} "-${mode}"
			}
			"335" {
				::EvaServ::SENT::MSG:TO:USER "${::EvaServ::config(rep)}" "<c01> \[<c03> Robot <c01>\] <c02> Oui"
			}
			"353" {
				set userliste		[string trim [string tolower [lrange ${arg} 5 end]] :]
				set userliste2		[string trim [lrange ${arg} 5 end] :]
				set chan		[lindex ${arg} 4]
				set user		[remove_modenicklist [lrange ${userliste} 0 end-1]]

				set user2		[remove_modenicklist ${userliste2}]
				set nblistenick		[llength [split ${user}]]
				#set ident		[lindex ${arg} 4]
				#set host		[lindex ${arg} 5]

				foreach n [split ${user}] {
					if {
						${::EvaServ::config(cmd)} == "ownerall"							&& \
							![info exists users(${n})]								&& \
							${n} != [string tolower ${::EvaServ::SERVICE_BOT(name)}]			&& \
							![info exists admins(${n})]								&& \
							![protection ${n}]
					} {
						FCT:SENT:MODE ${chan} "+q" ${n}
					} elseif {
						${::EvaServ::config(cmd)} == "deownerall"								&& \
							![info exists users(${n})]									&& \
							${n} != [string tolower ${::EvaServ::SERVICE_BOT(name)}]				&& \
							![info exists admins(${n})]									&& \
							![protection ${n}]
					} {
						FCT:SENT:MODE ${chan} "-q" ${n}
					} elseif {
						${::EvaServ::config(cmd)} == "protectall"								&& \
							![info exists users(${n})]									&& \
							${n} != [string tolower ${::EvaServ::SERVICE_BOT(name)}]				&& \
							![info exists admins(${n})]									&& \
							![protection ${n}]
					} {
						FCT:SENT:MODE ${chan} "+a" ${n}
					} elseif {
						${::EvaServ::config(cmd)} == "deprotectall"							&& \
							![info exists users(${n})]									&& \
							${n} != [string tolower ${::EvaServ::SERVICE_BOT(name)}]				&& \
							![info exists admins(${n})]									&& \
							![protection ${n}]
					} {
						FCT:SENT:MODE ${chan} "-a" ${n}
					} elseif {
						${::EvaServ::config(cmd)} == "opall"									&& \
							![info exists users(${n})]									&& \
							${n} != [string tolower ${::EvaServ::SERVICE_BOT(name)}]				&& \
							![info exists admins(${n})]									&& \
							![protection ${n}]
					} {
						FCT:SENT:MODE ${chan} "+o" ${n}
					} elseif {
						${::EvaServ::config(cmd)} == "deopall"									&& \
							![info exists users(${n})]									&& \
							${n} != [string tolower ${::EvaServ::SERVICE_BOT(name)}]				&& \
							![info exists admins(${n})]									&& \
							![protection ${n}]
					} {
						FCT:SENT:MODE ${chan} "-o" ${n}
					} elseif {
						${::EvaServ::config(cmd)} == "halfopall"								&& \
							![info exists users(${n})]									&& \
							${n} != [string tolower ${::EvaServ::SERVICE_BOT(name)}]				&& \
							![info exists admins(${n})]									&& \
							![protection ${n}]
					} {
						FCT:SENT:MODE ${chan} "+h" ${n}
					} elseif {
						${::EvaServ::config(cmd)} == "dehalfopall"								&& \
							![info exists users(${n})]									&& \
							${n} != [string tolower ${::EvaServ::SERVICE_BOT(name)}]				&& \
							![info exists admins(${n})]									&& \
							![protection ${n}]
					} {
						FCT:SENT:MODE ${chan} "-h" ${n}
					} elseif {
						${::EvaServ::config(cmd)} == "voiceall"								&& \
							![info exists users(${n})]									&& \
							${n} != [string tolower ${::EvaServ::SERVICE_BOT(name)}]				&& \
							![info exists admins(${n})]									&& \
							![protection ${n}]
					} {
						FCT:SENT:MODE ${chan} "+v" ${n}
					} elseif {
						${::EvaServ::config(cmd)} == "devoiceall"								&& \
							![info exists users(${n})]									&& \
							${n} != [string tolower ${::EvaServ::SERVICE_BOT(name)}]				&& \
							![info exists admins(${n})]									&& \
							![protection ${n}]
					} {
						FCT:SENT:MODE ${chan} "-v" ${n}
					} elseif {
						${::EvaServ::config(cmd)} == "kickall"									&& \
							![info exists users(${n})]									&& \
							${n} != [string tolower ${::EvaServ::SERVICE_BOT(name)}]				&& \
							![info exists admins(${n})]								&& \
							![protection ${n}]
					} {
						::EvaServ::FCT:SENT:SERV KICK ${chan} ${n} Kicked [rnick ${::EvaServ::config(rep)}];
					} elseif {
						${::EvaServ::config(cmd)} == "chankill"								&& \
							![info exists users(${n})]									&& \
							${n} != [string tolower ${::EvaServ::SERVICE_BOT(name)}]				&& \
							![info exists admins(${n})]									&& \
							![protection ${n}]
					} {
						::EvaServ::FCT:SENT:SERV KILL ${n} Chan Killed [rnick ${::EvaServ::config(rep)}];
						refresh ${n}
					} elseif {
						${::EvaServ::config(cmd)} == "changline"								&& \
							![info exists users(${n})]									&& \
							${n} != [string tolower ${::EvaServ::SERVICE_BOT(name)}]				&& \
							![info exists admins(${n})]									&& \
							![protection ${n}]
					} {
						sent2socket ":${::EvaServ::config(link)} TKL + G * $vhost(${n}) ${::EvaServ::SERVICE_BOT(name)} [expr [unixtime] + ${::EvaServ::config(gline_duration)}] [unixtime] :Chan Glined [rnick ${::EvaServ::config(rep)}] (Expire le [duree [expr [unixtime] + ${::EvaServ::config(gline_duration)}]])"
					} elseif {
						${::EvaServ::config(cmd)} == "badchan"									&& \
							![info exists users(${n})]									&& \
							${n} != [string tolower ${::EvaServ::SERVICE_BOT(name)}]				&& \
							![info exists admins(${n})]									&& \
							![protection ${n}]
					} {
						::EvaServ::FCT:SENT:SERV KICK ${chan} ${n} Salon Interdit;
					} elseif {
						${::EvaServ::config(cmd)} == "closeadd"								&& \
							![info exists users(${n})]									&& \
							${n} != [string tolower ${::EvaServ::SERVICE_BOT(name)}]				&& \
							![info exists admins(${n})]									&& \
							![protection ${n}]
					} {
						if { [info exists config(rep)] } {
							::EvaServ::FCT:SENT:SERV KICK ${chan} ${n} Closed [rnick ${::EvaServ::config(rep)}];
						} else {
							::EvaServ::FCT:SENT:SERV KICK ${chan} ${n} Closed;
						}

					}
				}
			}
			"364" {
				set serv		[lindex ${arg} 3]
				set desc		[join [lrange ${arg} 6 end]]
				if { ![info exists config(aff)] } {
					set config(aff)		1
					::EvaServ::SENT::MSG:TO:USER "${::EvaServ::config(rep)}" "<b><c1,1>--------------------------------- <c0>Map du Réseau <c1>---------------------------------"
					::EvaServ::SENT::MSG:TO:USER "${::EvaServ::config(rep)}" "<b>"
				}
				::EvaServ::SENT::MSG:TO:USER "${::EvaServ::config(rep)}" "<c01>Serveur \[<c04> ${serv} <c01>\] <c> Description \[<c03> ${desc} <c01>\]"
			}
			"365" {
				if { [info exists config(aff)] } { unset config(aff)		}
				if { [info exists config(rep)] } { unset config(rep)		}
			}
			"378" {
				set host		[lindex ${arg} 7]
				set ip		[lindex ${arg} 8]
				::EvaServ::SENT::MSG:TO:USER "${::EvaServ::config(rep)}" "<c01> \[<c03> Host Décodé <c01>\] <c02> ${host}"
				if { [info exists ${ip}] } {
					::EvaServ::SENT::MSG:TO:USER "${::EvaServ::config(rep)}" "<c01> \[<c03> Ip <c01>\] <c02> ${ip}"
				}
			}
			"671" {
				::EvaServ::SENT::MSG:TO:USER "${::EvaServ::config(rep)}" "<c01> \[<c03> SSL <c01>\] <c02> Oui"
			}
			"SERVER" {
				set serv		[lindex ${arg} 2]
				set desc		[join [string trim [lrange ${arg} 4 end] :]]
				if {
					[::EvaServ::ShowOnPartyLine 2]												&& \
						${::EvaServ::config(init)} == 0
				} {
					::EvaServ::SHOW:INFO:TO:CHANLOG "Link" "${serv} : ${desc}"
				}
			}
			"NOTICE" {
				#Received: :001FKJTPQ NOTICE 00CAAAAAB :VERSION HexChat 2.14.2 / Linux 5.4.0-66-generic [x86_64/1,30GHz/SMP]
				set version		[string trim [lindex ${arg} 3] :]
				set vdata		[string trim [join [lrange ${arg} 4 end]] \001]
				if { ![FloodControl:Check ${vuser}] } { return 0 }
				if {
					${::EvaServ::config(aclient)} == 1											&& \
						${version} == "\001VERSION"
				} {
					::EvaServ::SHOW:INFO:TO:CHANLOG "Client Version" "${USER_LOWER} : ${vdata}"
					catch { open [Script:Get:Directory]/db/client.db r } vcli
					while { ![eof ${vcli}] } {
						gets ${vcli} verscli
						if { ${verscli} != "" } { continue }
						if { [string match *${verscli}* ${vdata}] } {
							if {
								[::EvaServ::ShowOnPartyLine 3]									&& \
									${::EvaServ::config(init)} == 0
							} {
								::EvaServ::SHOW:INFO:TO:CHANLOG "Kill" "${user} a été killé : ${::EvaServ::config(rclient)}"
							}
							::EvaServ::FCT:SENT:SERV KILL ${USER_LOWER} ${::EvaServ::config(rclient)};
							refresh ${USER_LOWER}
							break
						}
					}
					catch { close ${vcli} }
				}
			}
			"MODE" {
				set chan		[lindex ${arg} 2]
				set vchan		[string tolower [lindex ${arg} 2]]
				set umode		[lindex ${arg} 3]
				set pmode		[join [lrange ${arg} 4 end]]
				set unix		[lindex ${arg} end]
				if {
					[::EvaServ::ShowOnPartyLine 3]												&& \
						${vchan} != [string tolower ${::EvaServ::SERVICE_BOT(channel_logs)}]		&& \
						${::EvaServ::config(init)} == 0											&& \
						[string tolower ${user}] != [string tolower ${::EvaServ::SERVICE_BOT(name)}]
				} {
					if { [regexp "^\[0-9\]\{10\}" ${unix}] } {
						set smode		[string trim ${pmode} ${unix}]
						::EvaServ::SHOW:INFO:TO:CHANLOG "Mode" "${user} applique le mode ${umode} ${smode} sur ${chan}"
					} else {
						::EvaServ::SHOW:INFO:TO:CHANLOG "Mode" "${user} applique le mode ${umode} ${pmode} sur ${chan}"
					}
				}
			}
			"UMODE2" {
				set umode		[lindex ${arg} 2]
				if {
					![info exists users(${user})]									&& \
						[string match *+*S* ${umode}]
				} {
					set users(${user})		on
				}
				if {
					![info exists netadmin(${user})]								&& \
						[string match *+*N* ${umode}]
				} {
					set netadmin(${user})		on
				}
				if {
					[info exists netadmin(${user})]									&& \
						[string match *-*N* ${umode}]
				} {
					unset netadmin(${user})
				}
				if {
					[::EvaServ::ShowOnPartyLine 3]												&& \
						${::EvaServ::config(init)} == 0
				} {
					if { [string match *+*S* ${umode}] } {
						::EvaServ::SHOW:INFO:TO:CHANLOG "Usermode" "${user} est un Service Réseau"
					} elseif { [string match *-*S* ${umode}] } {
						::EvaServ::SHOW:INFO:TO:CHANLOG "Usermode" "${user} n'est plus un Service Réseau"
					} elseif { [string match *+*N* ${umode}] } {
						::EvaServ::SHOW:INFO:TO:CHANLOG "Usermode" "${user} est un Administrateur Réseau"
					} elseif { [string match *-*N* ${umode}] } {
						::EvaServ::SHOW:INFO:TO:CHANLOG "Usermode" "${user} n'est plus un Administrateur Réseau"
					} elseif { [string match *+*A* ${umode}] } {
						::EvaServ::SHOW:INFO:TO:CHANLOG "Usermode" "${user} est un Administrateur Serveur"
					} elseif { [string match *-*A* ${umode}] } {
						::EvaServ::SHOW:INFO:TO:CHANLOG "Usermode" "${user} n'est plus un Administrateur Serveur"
					} elseif { [string match *+*a* ${umode}] } {
						::EvaServ::SHOW:INFO:TO:CHANLOG "Usermode" "${user} est un Administrateur Services"
					} elseif { [string match *-*a* ${umode}] } {
						::EvaServ::SHOW:INFO:TO:CHANLOG "Usermode" "${user} n'est plus un Administrateur Services"
					} elseif { [string match *+*C* ${umode}] } {
						::EvaServ::SHOW:INFO:TO:CHANLOG "Usermode" "${user} est un Co-Administrateur"
					} elseif { [string match *-*C* ${umode}] } {
						::EvaServ::SHOW:INFO:TO:CHANLOG "Usermode" "${user} n'est plus un Co-Administrateur"
					} elseif { [string match *+*o* ${umode}] } {
						::EvaServ::SHOW:INFO:TO:CHANLOG "Usermode" "${user} est un IRC Opérateur Global"
					} elseif { [string match *-*o* ${umode}] } {
						::EvaServ::SHOW:INFO:TO:CHANLOG "Usermode" "${user} n'est plus un IRC Opérateur Global"
					} elseif { [string match *+*O* ${umode}] } {
						::EvaServ::SHOW:INFO:TO:CHANLOG "Usermode" "${user} est un IRC Opérateur Local"
					} elseif { [string match *-*O* ${umode}] } {
						::EvaServ::SHOW:INFO:TO:CHANLOG "Usermode" "${user} n'est plus un IRC Opérateur Local"
					} elseif { [string match *+*h* ${umode}] } {
						::EvaServ::SHOW:INFO:TO:CHANLOG "Usermode" "${user} est un Helpeur"
					} elseif { [string match *-*h* ${umode}] } {
						::EvaServ::SHOW:INFO:TO:CHANLOG "Usermode" "${user} n'est plus un Helpeur"
					}
				}
			}
			"NICK" {
				set new			[lindex ${arg} 2]
				set vnew		[string tolower [lindex ${arg} 2]]

				set NICK_NEW	[lindex ${arg} 2]
				set NICK_OLD	[FCT:DATA:TO:NICK [string trim [lindex ${arg} 0] :]]
				set UID			[UID:CONVERT ${USER_LOWER}]
				set UID_DB([string toupper ${UID}])		${NICK_NEW}
				set UID_DB([string toupper ${NICK_NEW}])	${UID}
				set	unset UID_DB([string toupper ${NICK_OLD}])

				# [21:54:07] Received: :001PSYE4B NICK Amand[CoucouHibou] 1616792047
				if {
					[info exists users(${USER_LOWER})]								&& \
						${USER_LOWER} != ${vnew}
				} {
					set users(${vnew})		on;
					unset users(${USER_LOWER})
				}
				if {
					[info exists vhost(${USER_LOWER})]								&& \
						${USER_LOWER} != ${vnew}
				} {
					set vhost(${vnew})		$vhost(${USER_LOWER});
					unset vhost(${USER_LOWER})
				}
				if {
					[info exists admins(${USER_LOWER})]								&& \
						${USER_LOWER} != ${vnew}
				} {
					set admins(${vnew})		$admins(${USER_LOWER});
					unset admins(${USER_LOWER})
				}
				if {
					[info exists netadmin(${USER_LOWER})]							&& \
						${USER_LOWER} != ${vnew} } {
							set netadmin(${vnew})		on;
						unset netadmin(${USER_LOWER})
					}
					if {
						[::EvaServ::ShowOnPartyLine 3]												&& \
							${::EvaServ::config(init)} == 0
					} {
						::EvaServ::SHOW:INFO:TO:CHANLOG "Nick" "${user} change son pseudo en ${new}"
					}
					if {
						![info exists users(${vnew})]									&& \
							![info exists admins(${vnew})]									&& \
							[protection ${vnew}]
					} {
						catch { open [Script:Get:Directory]/db/nick.db r } liste
						while { ![eof ${liste}] } {
							gets ${liste} verif
							if {
								[string match ${verif} ${vnew}]							&& \
									${verif} != ""
							} {
								if {
									[::EvaServ::ShowOnPartyLine 3]									&& \
										${::EvaServ::config(init)} == 0
								} {
									::EvaServ::SHOW:INFO:TO:CHANLOG "Kill" "${new} a été killé : ${::EvaServ::config(ruser)}"
								}
								::EvaServ::FCT:SENT:SERV KILL ${vnew} ${::EvaServ::config(ruser)};
								break;
								refresh ${vnew}
							}
						}
						catch { close ${liste} }
					}
				}
				"TOPIC" {
					set chan		[lindex ${arg} 2]
					set vchan		[string tolower ${chan}]
					set topic		[join [string trim [lrange ${arg} 5 end] :]]
					if {
						[::EvaServ::ShowOnPartyLine 3]												&& \
							${vchan} != [string tolower ${::EvaServ::SERVICE_BOT(channel_logs)}]	&& \
							${::EvaServ::config(init)} == 0
					} {
						::EvaServ::SHOW:INFO:TO:CHANLOG "Topic" "${user} change le topic sur ${chan} : ${topic}<c>"
					}
				}
				"KICK" {
					set pseudo		[UID:CONVERT [lindex ${arg} 3]]
					set chan		[lindex ${arg} 2]
					set vchan		[string tolower [lindex ${arg} 2]]
					set raison		[join [string trim [lrange ${arg} 4 end] :]]
					if {
						[::EvaServ::ShowOnPartyLine 3]												&& \
							${vchan} != [string tolower ${::EvaServ::SERVICE_BOT(channel_logs)}]	&& \
							${::EvaServ::config(init)} == 0
					} {
						::EvaServ::SHOW:INFO:TO:CHANLOG "Kick" "${pseudo} a été kické par ${user} sur ${chan} : ${raison}<c>"
					}
				}
				"KILL" {
					set pseudo		[lindex ${arg} 2]
					set vpseudo		[string tolower [lindex ${arg} 2]]
					set text		[join [string trim [lrange ${arg} 2 end] :]]
					refresh ${vpseudo}
					if {
						[::EvaServ::ShowOnPartyLine 1]												&& \
							${::EvaServ::config(init)} == 0
					} {
						::EvaServ::SHOW:INFO:TO:CHANLOG "Kill" "${pseudo} : ${text}<c>"
					}
					if { ${vpseudo} == [string tolower ${::EvaServ::SERVICE_BOT(name)}] } {
						gestion;
						sent2socket ":${::EvaServ::config(link)} SQUIT ${::EvaServ::config(link)} :${::EvaServ::config(raison)}"
						foreach kill [utimers] {
							if { [lindex ${kill} 1] == "::EvaServ::verif" } { killutimer [lindex ${kill} 2] }
						}
						if { [info exists config(idx)] } { unset config(idx)		}
						set config(counter)		0;
						config
						utimer 1 ::EvaServ::connexion
					}
				}
				"GLOBOPS" {
					set text		[join [string trim [lrange ${arg} 2 end] :]]
					if {
						[::EvaServ::ShowOnPartyLine 3]												&& \
							${::EvaServ::config(init)} == 0										&& \
							![info exists users(${USER_LOWER})]
					} {
						::EvaServ::SHOW:INFO:TO:CHANLOG "Globops" "${user} : ${text}<c>"
					}
				}
				"CHGIDENT" {
					set pseudo		[lindex ${arg} 2]
					set ident		[lindex ${arg} 3]
					if {
						[::EvaServ::ShowOnPartyLine 3]												&& \
							${::EvaServ::config(init)} == 0
					} {
						::EvaServ::SHOW:INFO:TO:CHANLOG "Chgident" "${user} change l'ident de ${pseudo} en ${ident}"
					}
				}
				"CHGHOST" {
					set pseudo		[FCT:DATA:TO:NICK [lindex ${arg} 2]]
					set host		[lindex ${arg} 3]
					if {
						[::EvaServ::ShowOnPartyLine 3]												&& \
							${::EvaServ::config(init)} == 0
					} {
						::EvaServ::SHOW:INFO:TO:CHANLOG "Chghost" "${user} change l'host de ${pseudo} en ${host}"
					}
				}
				"CHGNAME" {
					set pseudo		[lindex ${arg} 2]
					set real		[join [string trim [lrange ${arg} 3 end] :]]
					if {
						[::EvaServ::ShowOnPartyLine 3]												&& \
							${::EvaServ::config(init)} == 0
					} {
						::EvaServ::SHOW:INFO:TO:CHANLOG "Chgname" "${user} change le realname de ${pseudo} en ${real}"
					}
				}
				"SETHOST" {
					set host		[lindex ${arg} 2]
					if {
						[::EvaServ::ShowOnPartyLine 3]												&& \
							${::EvaServ::config(init)} == 0
					} {
						::EvaServ::SHOW:INFO:TO:CHANLOG "Sethost" "Changement de l'host de ${user} en ${host}"
					}
				}
				"SETIDENT" {
					set ident		[lindex ${arg} 2]
					if {
						[::EvaServ::ShowOnPartyLine 3]												&& \
							${::EvaServ::config(init)} == 0
					} {
						::EvaServ::SHOW:INFO:TO:CHANLOG "Setident" "Changement de l'ident de ${user} en ${ident}"
					}
				}
				"SETNAME" {
					set real		[join [string trim [lrange ${arg} 2 end] :]]
					if {
						[::EvaServ::ShowOnPartyLine 3]											&& \
							${::EvaServ::config(init)} == 0
					} {
						::EvaServ::SHOW:INFO:TO:CHANLOG "Setname" "Changement du realname de ${user} en ${real}"
					}
				}
				"SJOIN" {
					#	[20:40:16] Received: :001 SJOIN 1616246465 #Amandine :001119S0G
					set user		[FCT:DATA:TO:NICK [string trim [lindex ${arg} 4] :]]
					set vuser		[string tolower ${user}]
					set chan		[lindex ${arg} 3]
					set vchan		[string tolower ${chan}]
					if {
						[::EvaServ::ShowOnPartyLine 3]												&& \
							${vchan} != [string tolower ${::EvaServ::SERVICE_BOT(channel_logs)}]		&& \
							${::EvaServ::config(init)} == 0
					} {
						::EvaServ::SHOW:INFO:TO:CHANLOG "Join" "${user} entre sur ${chan}"
					}
					catch { open "[Script:Get:Directory]/db/salon.db" r } liste
					while { ![eof ${liste}] } {
						gets ${liste} verif
						if {
							${verif} != ""												&& \
								[string match *[string trimleft ${verif} #]* [string trimleft ${vchan} #]]	&& \
								${USER_LOWER} != [string tolower ${::EvaServ::SERVICE_BOT(name)}]		&& \
								![info exists users(${USER_LOWER})]							&& \
								![info exists admins(${USER_LOWER})]						&& \
								[protection ${USER_LOWER}]
						} {
							set config(cmd)		"badchan";
							::EvaServ::FCT:SENT:SERV JOIN ${vchan};
							FCT:SENT:MODE ${vchan} "+ntsio" ${::EvaServ::SERVICE_BOT(name)}
							FCT:SET:TOPIC ${vchan} "<c1>Salon Interdit le [duree [unixtime]]";
							sent2socket ":${::EvaServ::config(link)} NAMES ${vchan}"
							if {
								[::EvaServ::ShowOnPartyLine 3]										&& \
									${::EvaServ::config(init)} == 0
							} {
								::EvaServ::SHOW:INFO:TO:CHANLOG "Part" "${user} part de ${chan} : Salon Interdit"
							}
							break
						}
					}
					catch { close ${liste} }
				}
				"PART" {
					set chan		[string trim [lindex ${arg} 2] :]
					set vchan		[string tolower ${chan}]
					if {
						[::EvaServ::ShowOnPartyLine 3]												&& \
							${vchan} != [string tolower ${::EvaServ::SERVICE_BOT(channel_logs)}]		&& \
							${::EvaServ::config(init)} == 0
					} {
						::EvaServ::SHOW:INFO:TO:CHANLOG "Part" "${user} part de ${chan}"
					}
				}
				"QUIT" {
					set text		[join [string trim [lrange ${arg} 2 end] :]]
					refresh ${USER_LOWER}

					if {
						[::EvaServ::ShowOnPartyLine 2]												&& \
							${::EvaServ::config(init)} == 0
					} {
						if { ${text} != "" } {
							::EvaServ::SHOW:INFO:TO:CHANLOG "Déconnexion" "${user} a quitté l'IRC : ${text} - ([DBU:GET ${user} IDENT]@[DBU:GET ${user} VHOST])"
						} else {
							::EvaServ::SHOW:INFO:TO:CHANLOG "Déconnexion" "${user} a quitté l'IRC - ([DBU:GET ${user} IDENT]@[DBU:GET ${user} VHOST])"
						}
					}
				}
			}
		}
		::EvaServ::INIT