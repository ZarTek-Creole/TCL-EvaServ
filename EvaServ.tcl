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
	variable config
	set config(scriptname)	"EvaServ Service"
	set config(version)		"1.5.20210421"
	set config(auteur)		"ZarTek"

	set config(path)		"[file dirname [info script]]/"
	set config(timerco)		30
	set config(timerdem)	5
	set config(timerinit)	10
	set config(counter)		0
	set config(dem)			0
	set config(init)		0
	set config(console)		1
	set config(login)		1
	set config(protection)	1
	set config(debug)		0
	set config(aclient)		0
	array set DBU_INFO		""
	array set UID_DB		""
	set scoredb(last)		""

	proc uninstall {args} {
		variable config
		variable CONNECT_ID

		::EvaServ::putlog "Désallocation des ressources de \002[set config(scriptname)]\002..." info
		$CONNECT_ID destroy
		foreach binding [lsearch -inline -all -regexp [binds *[set ns [::tcl::string::range [namespace current] 2 end]]*] " \{?(::)?$ns"] {
			unbind [lindex $binding 0] [lindex $binding 1] [lindex $binding 2] [lindex $binding 4]
		}
		# Arrêt des timers en cours.
		foreach running_timer [timers] {
			if { [::tcl::string::match "*[namespace current]::*" [lindex $running_timer 1]] } { killtimer [lindex $running_timer 2] }
		}
		namespace delete ::EvaServ
	}
	
	foreach {color_name value} { red 1 yellow 3 cyan 5 magenta 6 blue 4 green 2 } {
		proc color_$color_name {} "return \033\\\[01\\;3${value}m"
	}
	proc colors_end {} {
		return \033\[\;0m
	}
	proc putlog { text {level_name ""} {text_name ""} } {
		variable config
		if { $text_name == "" } {
			if { $level_name != "" } {
				set text_name " - $level_name"
			} else {
				set text_name ""
			}
		} else {
			set text_name " - $text_name"
		}
		switch -nocase $level_name {
			"error"		{ puts "[color_red]\[[set config(scriptname)]$text_name\][colors_end] [color_blue]$text[colors_end]" }
			"warning"	{ puts "[color_yellow]\[[set config(scriptname)]$text_name\][colors_end] [color_blue]$text[colors_end]" }
			"notice"	{ puts "[color_cyan]\[[set config(scriptname)]$text_name\][colors_end] [color_blue]$text[colors_end]" }
			"debug"		{ puts "[color_magenta]\[[set config(scriptname)]$text_name\][colors_end] [color_blue]$text[colors_end]" }
			"info"		{ puts "[color_blue]\[[set config(scriptname)]$text_name\][colors_end] [color_blue]$text[colors_end]" }
			"success"	{ puts "[color_green]\[[set config(scriptname)]$text_name\][colors_end] [color_blue]$text[colors_end]" }
			default		{ puts "\[[set config(scriptname)]$text_name\] [color_blue]$text[colors_end]" }
		}
	}
}
proc ::EvaServ::INIT { } {
	variable config
	variable FloodControl
	variable commands
	
	if { [ catch { source [::EvaServ::Script:Get:Directory]EvaServ.conf } err ] } { 
		::EvaServ::putlog "Probleme de chargement de '[::EvaServ::Script:Get:Directory]EvaServ.conf':\n$err" error
		exit
	} 
	bind time	- "00 00 * * *"	::EvaServ::dbback
	#bind evnt	n init-server	::EvaServ::initialisation
	bind evnt	n prerestart	::EvaServ::evenement
	bind evnt	n sighup		::EvaServ::evenement
	bind evnt	n sigterm		::EvaServ::evenement
	bind evnt	n sigill		::EvaServ::evenement
	bind evnt	n sigquit		::EvaServ::evenement
	bind evnt	n prerehash		::EvaServ::prerehash
	bind evnt	n rehash		::EvaServ::rehash
	bind dcc	n eva			::EvaServ::eva
	bind dcc	n evaconnect	::EvaServ::connect
	bind dcc	n evadeconnect	::EvaServ::deconnect
	bind dcc	n evauptime		::EvaServ::uptime
	bind dcc	n evaversion	::EvaServ::version
	bind dcc	n evainfos		::EvaServ::infos
	bind dcc	n evadebug		::EvaServ::debug
	
	::EvaServ::Config:File:Check
	if { ![file isdirectory "[::EvaServ::Script:Get:Directory]db"] } { file mkdir "[::EvaServ::Script:Get:Directory]db" }

	# generer les db
	::EvaServ::Database:initialisation [list \
						"gestion"	\
						"chan"		\
						"client"	\
						"close"		\
						"salon"		\
						"ident"		\
						"real"		\
						"host"		\
						"nick"		\
						"trust"		
					];
	if {
		[file exists ${DIR(CUR)}/TCL-PKG-IRCServices/ircservices.tcl] && \
			[catch { source ${DIR(CUR)}/TCL-PKG-IRCServices/ircservices.tcl } err]
	} {
		die "\[${SCRIPT(name)} - Erreur\] Chargement '${DIR(CUR)}/TCL-PKG-IRCServices/ircservices.tcl' à échoué: ${err}";
	}
	if { [catch { package require IRCServices 0.0.1 }] } { putloglev o * "\00304\[[set config(scriptname)] - erreur\]\003 [set config(scriptname)] nécessite le package IRCServices 0.0.1 (ou plus) pour fonctionner, Télécharger sur 'github.com/ZarTek-Creole/TCL-PKG-IRCServices'. Le chargement du script a été annulé." ; return }

	::EvaServ::Database:Load:Data
	::EvaServ::Service:Connexion
	::EvaServ::putlog "v[set config(version)] par [set config(auteur)] OK." success
}
proc ::EvaServ::Service:Connexion { } {
	variable config
	variable CONNECT_ID
	variable BOT_ID
	
	if { $config(uplink_ssl) == 1		} { set config(uplink_port) "+$config(uplink_port)" }
	if { $config(serverinfo_id) != ""	} { set config(uplink_ts6) 1 } else { set config(uplink_ts6) 0 }
	
	set CONNECT_ID [::IRCServices::connection]; # Creer une instance services
	::EvaServ::putlog:info "Connexion du link service $config(serverinfo_name)"
	$CONNECT_ID connect $config(uplink_host) $config(uplink_port) $config(uplink_password) $config(uplink_ts6) $config(serverinfo_name) $config(serverinfo_id); # Connexion de l'instance service
	if { $config(uplink_debug) == 1} { $CONNECT_ID config logger 1; $CONNECT_ID config debug 1; }

	set BOT_ID [$CONNECT_ID bot]; #Creer une instance bot dans linstance services
	
	::EvaServ::putlog:info "Creation du bot service $config(service_nick)"
	$BOT_ID create $config(service_nick) $config(service_user) $config(service_host) $config(service_gecos) $config(service_modes)]; # Creation d'un bot service
	$BOT_ID join $config(service_channel)
	$BOT_ID registerevent EOS {
		global ::EvaServ::config
		[sid] mode $config(service_channel) $config(service_chanmodes)
		if { $config(service_usermodes) != "" } { 
			[sid] mode $config(service_channel) $config(service_usermodes) $config(service_nick)
		}
		
		
	}
	$BOT_ID registerevent PRIVMSG {
		set cmd		[lindex [msg] 0]
		set data	[lrange [msg] 1 end]
		##########################
		#--> Commandes Privés <--#
		##########################
		# si [target] ne commence pas par # c'est un pseudo
		if { [string index [target] 0] != "#"} {
			::EvaServ::IRC:CMD:MSG:PRIV [who2] [target] $cmd $data 
		}
		##########################
		#--> Commandes Salons <--#
		##########################
		# si [target] commence par # c'est un salon
		if { [string index [target] 0] == "#"} {
			::EvaServ::IRC:CMD:MSG:PUB [who] [target] $cmd $data 
		}
	}; # Creer un event sur PRIVMSG
	
}
proc ::EvaServ::IRC:CMD:MSG:PRIV { sender destination cmd data } {
	variable config
	if { [::EvaServ::FloodControl:Check $sender] != "ok" } {
		return 0
	}
	putlog "::EvaServ::IRC:CMD:MSG:PRIV $sender $destination $cmd $data"
	switch -nocase $cmd {
		"PING"	{
			::EvaServ::SENT:NOTICE $sender "\001PING $data\001";
		}
		"TIME"	{
			::EvaServ::SENT:NOTICE $sender "\001TIME [clock format [clock seconds]]\001";
		}
		"VERSION"	{
			::EvaServ::SENT:NOTICE $sender "\001VERSION $config(scriptname) v$config(version) by $config(auteur) © Visit: https://git.io/JOG1k\001";
		}
		"SOURCE"	{
			::EvaServ::SENT:NOTICE $sender "\001SOURCE https://git.io/JOG1k\001";
		}
		"FINGER"	{
			::EvaServ::SENT:NOTICE $sender "\001FINGER [string map {" " "_"} $config(scriptname)] $config(version)\001";
		}
		"USERINFO"	{
			::EvaServ::SENT:NOTICE $sender "\001USERINFO [string map {" " "_"} $config(scriptname)] (v$config(version) - Visit: https://git.io/JOG1k)\001";
		}
		"CLIENTINFO"	{
			::EvaServ::SENT:NOTICE $sender "\001CLIENTINFO CLIENTINFO PING TIME VERSION FINGER USERINFO\001";
		}
		default		{
			if { [::EvaServ::CMD:EXIST $cmd] } { 
				set CommandHelp [lindex $data 0]
				if { $cmd == "help" && $CommandHelp != "" } {
	 				if { [::EvaServ::CMD:EXIST $CommandHelp] } {
	 					::EvaServ::Commands:Help $sender $data
	 				} else {
	 					::EvaServ::SENT:MSG:TO:USER $user "Aide <b>$CommandHelp</b> Inconnue."
	 				}
	 			} else {
	 				::EvaServ::cmds "$cmds $user $data"
	 			}
				::EvaServ::Commands:Help $sender $data
			} else {
 				::EvaServ::SENT:MSG:TO:USER $sender "Commande <b>$cmd</b> Inconnue."
			}
		}
	}
}
proc ::EvaServ::IRC:CMD:MSG:PUB { sender destination cmd data } {
	variable config
	if { [::EvaServ::FloodControl:Check $sender] != "ok" } { 
		return 0
	}
	putlog "::EvaServ::IRC:CMD:MSG:PUB $sender $destination $cmd $data"

}
	# "PRIVMSG" {
	# 	set vuser		[string tolower $user]
	# 	set robotUID	[string tolower [lindex $arg 2]]
	# 	set cmds		[string tolower [string trim [lindex $arg 3] :]]
	# 	set CommandHelp	[string tolower [lindex $arg 4]]
	# 	set pcmds		[string trim $cmds $config(prefix)]
	# 	set data		[join [lrange $arg 4 end]]
	# 	if { [string toupper $robotUID] == [::EvaServ::UID:CONVERT $config(service_nick)] } {
			

	# 		if { $cmds == "ping" } {
	# 			::EvaServ::SENT:MSG:TO:USER $user "\001PING [clock seconds]\001";
	# 			return 0;
	# 		} elseif { $cmds == "version" } {
	# 			::EvaServ::SENT:MSG:TO:USER $user "<c01>$config(scriptname) $config(version) by TiSmA/ZarTek<c03>©";
	# 			return 0;
	# 			# verifie si c une command eva :

	# 		} elseif { [::EvaServ::CMD:EXIST $cmds] } {

	# 			# si c help
	# 			if { $cmds == "help" && $CommandHelp != "" } {

	# 				# verifie si c une command eva
	# 				if { [::EvaServ::CMD:EXIST $CommandHelp] } {
	# 					::EvaServ::Commands:Help "$CommandHelp $user $data"
	# 				} else {
	# 					::EvaServ::SENT:MSG:TO:USER $user "Aide <b>$CommandHelp</b> Inconnue."
	# 				}
	# 			} else {
	# 				::EvaServ::cmds "$cmds $user $data"
	# 			}
	# 		} else {
	# 			::EvaServ::SENT:MSG:TO:USER $user "Commande <b>$cmds</b> Inconnue."
	# 		}
	# 	}
	# 	if { [string index $cmds 0] == $config(prefix) } {
	# 		if { [::EvaServ::FloodControl:Check $vuser] != "ok" } { return 0 }
	# 		if { [::EvaServ::CMD:EXIST $pcmds] } {
	# 			if { $pcmds == "help" && $CommandHelp != "" } {
	# 				if { [::EvaServ::CMD:EXIST $CommandHelp] } {
	# 					::EvaServ::Commands:Help "$CommandHelp $user $data"
	# 				}
	# 			} else {
	# 				::EvaServ::cmds "$pcmds $user $data"
	# 			}
	# 		}
	# 	}
	# }
proc ::EvaServ::Config:File:Check { } {
	variable config
	variable FloodControl
	set CONF_LIST	[list 							\
							"uplink_host"			\
							"uplink_ssl"			\
							"uplink_port"			\
							"uplink_password"		\
							"serverinfo_name"		\
							"serverinfo_descr"		\
							"serverinfo_id"			\
							"uplink_useprivmsg"		\
							"uplink_debug"			\
							"service_nick"			\
							"service_user"			\
							"service_host"			\
							"service_gecos"			\
							"service_modes"			\
							"service_channel"		\
							"service_chanmodes"		\
							"service_usermodes"		\
							"prefix"				\
							"rnick"					\
							"duree"					\
							"rclient"				\
							"rhost"					\
							"rident"				\
							"rreal"					\
							"ruser"					\
							"raison"				\
							"console_com"			\
							"console_deco"			\
							"console_txt"];
	foreach CONF $CONF_LIST {
		if { ![info exists config($CONF)] } {
			::EvaServ::putlog "Configuration de $config(scriptname) Incorrecte... 'config($CONF)' Paramettre manquant" error
			exit
		}
		if { $config($CONF) == "" } {
			::EvaServ::putlog "Configuration de $config(scriptname) Incorrecte... 'config($CONF)' Valeur vide" error
			exit
		}
	}
	set FloodControl_LIST	[list 					\
								"Throttling"		\
								"IgnoreTime"];
	foreach CONF $FloodControl_LIST {
		putlog "[array get FloodControl]"
		if { ![info exists FloodControl($CONF)] } {
			::EvaServ::putlog "Configuration de $config(scriptname) Incorrecte... 'FloodControl($CONF)' Paramettre manquant" error
			exit
		}
		if { $FloodControl($CONF) == "" } {
			::EvaServ::putlog "Configuration de $config(scriptname) Incorrecte... 'FloodControl($CONF)' Valeur vide" error
			exit
		}
	}
}
proc ::EvaServ::Script:Get:Directory { } {
	variable config;
	return $config(path)
}
proc ::EvaServ::Database:initialisation { LISTDB } {
	foreach DB_NAME $LISTDB {
		if { ![file exists "[::EvaServ::Script:Get:Directory]db/${DB_NAME}.db"] } {
			set FILE_PIPE	[open "[::EvaServ::Script:Get:Directory]db/${DB_NAME}.db" a+];
			close $FILE_PIPE
		}

	}
}
proc ::EvaServ::Database:Load:Data { } {
	variable config
	variable trust

	catch { open [::EvaServ::Script:Get:Directory]db/trust.db r } protection
	while { ![eof $protection] } {
		gets $protection hosts;
		if { $hosts != "" && ![info exists trust($hosts)] } { 
			set trust($hosts)	1
			::EvaServ::putlog:info "L'host '$hosts' est chargement comme TRUST."
		}
	}
	catch { close $protection }
	catch { open [::EvaServ::Script:Get:Directory]db/gestion.db r } gestion
	while { ![eof $gestion] } {
		gets $gestion var2;
		if { $var2 != "" } { set [lindex $var2 0] [lindex $var2 1] }
	}
	catch { close $gestion }
}
proc ::EvaServ::putlog:info { MSG } {
	variable config
	if { [info exists config(putlog_info)] && $config(putlog_info) == 1 } { 
		::EvaServ::putlog $MSG info
	}
}
proc ::EvaServ::SENT:NOTICE { DEST MSG } {
	variable BOT_ID
	$BOT_ID	notice $DEST [::EvaServ::FCT:apply_visuals $MSG]
}

proc ::EvaServ::SENT:PRIVMSG { DEST MSG } {
	variable BOT_ID
	$BOT_ID	privmsg $DEST [::EvaServ::FCT:apply_visuals $MSG]
}
proc ::EvaServ::SENT:MSG:TO:USER { DEST MSG } {
	variable config
	if { $config(uplink_useprivmsg) == 1 } {
		::EvaServ::SENT:PRIVMSG $DEST $MSG;
	} else {
		::EvaServ::SENT:NOTICE $DEST $MSG;
	}
}
proc ::EvaServ::FloodControl:Check { pseudo } {
	variable FloodControl
	if { ![info exists FloodControl(flood:$pseudo)] } {
		set FloodControl(flood:$pseudo)		1;
		utimer 3 [list ::EvaServ::FloodControl:NoticeUser $pseudo];
		return ok
	} elseif { $FloodControl(flood:$pseudo) < $FloodControl(Throttling) } {
		incr FloodControl(flood:$pseudo) 1;
		return ok
	} else {
		if { ![info exists FloodControl(stopflood:$pseudo)] } { 
			set FloodControl(stopflood:$pseudo)		1 
		}
	}
}
proc ::EvaServ::FloodControl:NoticeUser { pseudo }		{
	variable FloodControl
	if { [info exists FloodControl(stopflood:$pseudo)] } {
		::EvaServ::SENT:MSG:TO:USER $pseudo "Vous êtes ignoré pendant $FloodControl(IgnoreTime) secondes.";
		utimer $FloodControl(IgnoreTime) [list ::EvaServ::FloodControl:Reset $pseudo];
	} else {
		unset FloodControl(flood:$pseudo)
	}
}
proc ::EvaServ::FloodControl:Reset { pseudo } {
	variable FloodControl
	if { [info exists FloodControl(stopflood:$pseudo)] }	{ unset FloodControl(stopflood:$pseudo) }
	if { [info exists FloodControl(flood:$pseudo)] }		{ unset FloodControl(flood:$pseudo) }
	::EvaServ::SENT:MSG:TO:USER $pseudo "Vous n'êtes plus ignoré.";
	
}
###############################################################################
### Substitution des symboles couleur/gras/soulignement/...
###############################################################################
# Modification de la fonction de MenzAgitat
# <cXX> : Ajouter un Couleur avec le code XX : <c01>; <c02,01>
# </c>  : Enlever la Couleur (refermer la deniere declaration <cXX>) : </c>
# <b>   : Ajouter le style Bold/gras
# </b>  : Enlever le style Bold/gras
# <u>   : Ajouter le style Underline/souligner
# </u>  : Enlever le style Underline/souligner
# <i>   : Ajouter le style Italic/Italique
# <s>   : Enlever les styles precedent
proc ::EvaServ::FCT:apply_visuals { data } {
	regsub -all -nocase {<c([0-9]{0,2}(,[0-9]{0,2})?)?>|</c([0-9]{0,2}(,[0-9]{0,2})?)?>} $data "\003\\1" data
	regsub -all -nocase {<b>|</b>} $data "\002" data
	regsub -all -nocase {<u>|</u>} $data "\037" data
	regsub -all -nocase {<i>|</i>} $data "\026" data
	return [regsub -all -nocase {<s>} $data "\017"]
}
proc ::EvaServ::FCT:Remove_visuals { data } {
	regsub -all -nocase {<c([0-9]{0,2}(,[0-9]{0,2})?)?>|</c([0-9]{0,2}(,[0-9]{0,2})?)?>} $data "" data
	regsub -all -nocase {<b>|</b>} $data "" data
	regsub -all -nocase {<u>|</u>} $data "" data
	regsub -all -nocase {<i>|</i>} $data "" data
	return [regsub -all -nocase {<s>} $data ""]
}
proc ::EvaServ::authed { user cmd } {
	variable admins
	switch -exact [::EvaServ::CMD:TO:LEVEL $cmd] {
		0 { return ok }
		1 {
			if { [info exists admins($user)] && [matchattr $admins($user) p] } {
				return ok
			} else {
				::EvaServ::SENT:MSG:TO:USER $user "Accès Refusé";
				return 0
			}
		}
		2 {
			if { [info exists admins($user)] && [matchattr $admins($user) o] } {
				return ok
			} else {
				::EvaServ::SENT:MSG:TO:USER $user "Accès Refusé";
				return 0;
			}
		}
		3 {
			if { [info exists admins($user)] && [matchattr $admins($user) m] } {
				return ok;
			} else {

				::EvaServ::SENT:MSG:TO:USER $user "Accès Refusé";
				return 0;
			}
		}
		4 {
			if { [info exists admins($user)] && [matchattr $admins($user) n] } {
				return ok;
			} else {

				::EvaServ::SENT:MSG:TO:USER $user "Accès Refusé";
				return 0;
			}
		}
		-1 {
			::EvaServ::SENT:MSG:TO:USER $user "Command inconnue";
			return 0;
		}
		default {
			::EvaServ::SENT:MSG:TO:USER $user "Niveau inconnue";
			return 0;
		}
	}
}
###################################################################################################################################################################################################

proc ::EvaServ::sent2socket { MSG } {
	variable config
	if { $config(sdebug) } {
		putlog "Sent: $MSG"
	}
	putdcc $config(idx)  $MSG
}
proc ::EvaServ::sent2ppl { IDX MSG } {
	putdcc $IDX $MSG
}
proc ::EvaServ::SHOW:CMD:BY:LEVEL { DEST LEVEL } {
	variable commands
	set max				6;
	set l_espace		13;
	set CMD_LIST		""
	::EvaServ::SENT:MSG:TO:USER $DEST "<c01>\[ Level [dict get $commands $LEVEL name] - Niveau $LEVEL \]"
	foreach CMD [lsort [dict get $commands $LEVEL cmd]] {
		lappend CMD_LIST	"<c02>[::EvaServ::FCT:TXT:ESPACE:DISPLAY $CMD $l_espace]<c01>"
		if { [incr i] > $max-1 } {
			unset i
			::EvaServ::SENT:MSG:TO:USER $DEST [join $CMD_LIST " | "];
			set CMD_LIST	""
		}
	}
	::EvaServ::SENT:MSG:TO:USER $DEST [join $CMD_LIST " | "];
	::EvaServ::SENT:MSG:TO:USER $DEST "<c>";
}
proc ::EvaServ::SHOW:CMD:DESCRIPTION:BY:LEVEL { DEST LEVEL } {
	variable commands
	set max				6;
	set l_espace		13;
	set CMD_LIST		""
	::EvaServ::SENT:MSG:TO:USER $DEST "<c01>\[ Level [dict get $commands $LEVEL name] - Niveau $LEVEL \]"
	foreach CMD [lsort [dict get $commands $LEVEL cmd]] {
		set CMD_LOWER	[string tolower $CMD];
		set CMD_UPPER	[string toupper $CMD];
		if { [info commands [subst ::EvaServ::help:description:${CMD_LOWER}]] != "" } {
			::EvaServ::SENT:MSG:TO:USER $DEST "<c02>[::EvaServ::FCT:TXT:ESPACE:DISPLAY $CMD_UPPER $l_espace]<c01> \[<c04> [[subst ::EvaServ::help:description:${CMD_LOWER}]] <c01>\]";
		} else {
			::EvaServ::SENT:MSG:TO:USER $DEST "<c02>[::EvaServ::FCT:TXT:ESPACE:DISPLAY $CMD_UPPER $l_espace]<c01> \[<c07> Aucune description disponibles <c01>\]";
		}
	}
	::EvaServ::SENT:MSG:TO:USER $DEST "<c>";
}
proc ::EvaServ::SHOW:INFO:TO:CHANLOG { TYPE DATA } {
	variable config
	::EvaServ::SENT:MSG:TO:USER $config(salon) "<c$config(console_com)>[::EvaServ::FCT:TXT:ESPACE:DISPLAY $TYPE 16]<c$config(console_deco)>:<c$config(console_txt)> $DATA"
}
proc ::EvaServ::CMD:LIST { } {
	variable commands
	foreach level [dict keys $commands] {
		lappend CMD_LIST {*}[dict get $commands $level cmd]
	}
	return $CMD_LIST
}
proc ::EvaServ::CMD:TO:LEVEL { CMD } {
	variable commands
	foreach level [dict keys $commands] {
		if { [lsearch -nocase [dict get $commands $level cmd] $CMD] != "-1" } {
			return $level
		}
	}
	return -1
}
proc ::EvaServ::CMD:EXIST { CMD } {
	if { [lsearch -nocase [::EvaServ::CMD:LIST] $CMD] == "-1" } { return 0 }
	return 1
}
proc ::EvaServ::UID:CONVERT { ID } {
	variable UID_DB
	if { [info exists UID_DB([string toupper $ID])] } {
		return "$UID_DB([string toupper $ID])"
	} else {
		return $ID
	}
}

proc ::EvaServ::DBU:GET { UID WHAT } {
	variable DBU_INFO
	set UID	[::EvaServ::FCT:DATA:TO:UID [string toupper $UID]]
	if { [info exists DBU_INFO($UID,$WHAT)] } {
		return "$DBU_INFO($UID,$WHAT)";
	} else {
		return -1;
	}
}

proc ::EvaServ::FCT:SENT:MODE { DEST {MODE ""} {CIBLE ""} } {
	variable config
	::EvaServ::sent2socket ":$config(server_id) MODE $DEST $MODE $CIBLE"
}
proc ::EvaServ::FCT:SET:TOPIC { DEST TOPIC } {
	variable config
	::EvaServ::sent2socket ":$config(server_id) TOPIC $DEST :[::EvaServ::FCT:apply_visuals $TOPIC]"
}
proc ::EvaServ::FCT:DATA:TO:NICK { DATA } {
	if { [string range $DATA 0 0] == 0 } {
		set user		[::EvaServ::UID:CONVERT $DATA]
	} else {
		set user		$DATA
	}
	return $user;
}
proc ::EvaServ::FCT:DATA:TO:UID { DATA } {
	if { [string range $DATA 0 0] == 0 } {
		set UID		$DATA
	} else {
		set UID		[::EvaServ::UID:CONVERT $DATA]
	}
	return $UID;
}
proc ::EvaServ::FCT:TXT:ESPACE:DISPLAY { text length } {
	set text			[string trim $text]
	set text_length		[string length $text];
	set espace_length	[expr ($length - $text_length)/2.0]
	set ESPACE_TMP		[split $espace_length .]
	set ESPACE_ENTIER	[lindex $ESPACE_TMP 0]
	set ESPACE_DECIMAL	[lindex $ESPACE_TMP 1]
	if { $ESPACE_DECIMAL == 0 } {
		set espace_one			[string repeat " " $ESPACE_ENTIER];
		set espace_two			[string repeat " " $ESPACE_ENTIER];
		return "$espace_one$text$espace_two"
	} else {
		set espace_one			[string repeat " " $ESPACE_ENTIER];
		set espace_two			[string repeat " " [expr ($ESPACE_ENTIER+1)]];
		return "$espace_one$text$espace_two"
	}

}






proc ::EvaServ::putdebug { string } {
	set deb		[open logs/EvaServ.debug a]
	puts $deb "[clock format [clock seconds] -format "\[%H:%M\]"] $string"
	close $deb
}

proc ::EvaServ::refresh { pseudo } {
	variable netadmin 
	variable admins 
	variable vhost 
	variable protect 
	variable users
	set vuser	[string tolower $pseudo]
	if { [info exists vhost($vuser)] } {
		if { [info exists protect($vhost($vuser))] && [info exists admins($vuser)] } {
			::EvaServ::SHOW:INFO:TO:CHANLOG "Protecion du host" "$vhost($vuser) de $vuser (Désactivé)"
			unset protect($vhost($vuser))
		}
		unset vhost($vuser)
	}
	if { [info exists users($vuser)] } { unset users($vuser)		}
	if { [info exists netadmin($vuser)] } { unset netadmin($vuser)		}
	if { [info exists admins($vuser)] } { unset admins($vuser)		}
}

###############
# Eva Gestion #
###############

proc ::EvaServ::gestion { } {
	variable config
	set sv		[open [::EvaServ::Script:Get:Directory]db/gestion.db w+]
	puts $sv "config(salon) $config(salon)"
	puts $sv "config(debug) $config(debug)"
	puts $sv "config(console) $config(console)"
	puts $sv "config(protection) $config(protection)"
	puts $sv "config(login) $config(login)"
	puts $sv "config(aclient) $config(aclient)"
	close $sv
}

proc ::EvaServ::dbback { min h d m y } {
	variable config
	::EvaServ::gestion
	set DB_LIST	[list "gestion" "chan" "client" "close" "nick" "ident" "real" "host" "salon" "trust"]
	foreach DB_NAME $DB_LIST {
		exec cp -f [::EvaServ::Script:Get:Directory]db/${DB_NAME}.db [::EvaServ::Script:Get:Directory]db/${DB_NAME}.bak
	}
	if { [::EvaServ::console 1] == "ok" } {
		::EvaServ::SHOW:INFO:TO:CHANLOG "Backup" "Sauvegarde des databases."
	}
}

proc ::EvaServ::duree { temps } {
	switch -exact [lindex [ctime $temps] 1] {
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
	switch -exact [lindex [ctime $temps] 2] {
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
	if { ![info exists jour] } { set jour		[lindex [ctime $temps] 2] }
	set heure		[lindex [ctime $temps] 3]
	set annee		[lindex [ctime $temps] 4]
	set seen		"$jour/$mois/$annee à $heure"
	return $seen
}


proc ::EvaServ::console { level } {
	variable config
	switch -exact $level {
		1	{
			if { $config(console)>=1 } { return ok }
		}
		2	{
			if { $config(console)>=2 } { return ok }
		}
		3	{
			if { $config(console)>=3 } { return ok }
		}
	}
}

###########################################################
# Eva Verification de securité utilisateur a la connexion #
###########################################################
proc ::EvaServ::connexion:user:security:check { nickname hostname username gecos } {
	variable config
	variable trust
	# default
	set config(ahost)			1
	set config(aident)			1
	set config(areal)			1
	set config(anick)			1
	
	# Lors de l'init (connexion au irc du service) on verifie rien
	if { $config(init) == 1 } { return 0 }
	# on verifie si l'host est trusted
	foreach { mask num } [array get trust] {
		if { [string match -nocase *$mask* $hostname] } {
			::EvaServ::SHOW:INFO:TO:CHANLOG "Hostname Trustée" "$mask"
			return 0
		}
	}
	# Si l'utilisateur est proteger, on skip les verification
	if { [info exists protect($hostname)] } {
		::EvaServ::SHOW:INFO:TO:CHANLOG "Security Check" "Aucune verification de sécurité sur $hostname, le hostname protegé"
		return 0
	}
	
	set MSG_security_check	""
	# Version client ?
	if { $config(aclient) == 1 } { lappend MSG_security_check "Client version: On"; } else { lappend MSG_security_check "Client version: Off"; }
	# verif host?
	if { $config(ahost) == 1 } { lappend MSG_security_check "Host: On"; } else { lappend MSG_security_check "Host: Off"; }
	# verif ident?
	if { $config(aident) == 1 } { lappend MSG_security_check "Ident: On"; } else { lappend MSG_security_check "Ident: Off"; }
	# verif areal?
	if { $config(areal) == 1 } { lappend MSG_security_check "Realname: On"; } else { lappend MSG_security_check "Realname: Off"; }
	# verif nick?
	if { $config(anick) == 1 } { lappend MSG_security_check "Nick: On"; } else { lappend MSG_security_check "Nick: Off"; }

	if { [::EvaServ::console 2] == "ok" } {
		::EvaServ::SHOW:INFO:TO:CHANLOG "Security Check" [join $MSG_security_check " | "]
	}
	

	# Version client
	if { $config(aclient) == 1	} {
		::EvaServ::SENT:MSG:TO:USER $nickname "\001VERSION\001"
	}

	if { $config(ahost) == 1 	} {
		catch { open [::EvaServ::Script:Get:Directory]db/host.db r } liste2
		while { ![eof $liste2] } {
			gets $liste2 verif2
			if { [string match -nocase *$verif2* $hostname] && $verif2 != "" } {
				if { [::EvaServ::console 1] == "ok" && $config(init) == 0 } {
					::EvaServ::SHOW:INFO:TO:CHANLOG "Kill" "$nickname a été killé : $config(rhost)"
				}
				::EvaServ::sent2socket ":$config(server_id) KILL $nickname $config(rhost)";
				break;
				::EvaServ::refresh $nickname;
				return 0
			}
		}
		catch { close $liste2 }
	}
	if { $config(aident) == 1 	} {
		catch { open [::EvaServ::Script:Get:Directory]db/ident.db r } liste3
		while { ![eof $liste3] } {
			gets $liste3 verif3
			if { [string match -nocase *$verif3* $username] && $verif3 != "" } {
				if { [::EvaServ::console 1] == "ok" && $config(init) == 0 } {
					::EvaServ::SHOW:INFO:TO:CHANLOG "Kill" "$nickname ($verif3) a été killé : $config(rident)"
				}
				::EvaServ::sent2socket ":$config(server_id) KILL $nickname $config(rident)";
				break ;
				::EvaServ::refresh $nickname;
				return 0;
			}
		}
		catch { close $liste3 }
	}
	if { $config(areal) == 1 	} {
		catch { open [::EvaServ::Script:Get:Directory]db/real.db r } liste4
		while { ![eof $liste4] } {
			gets $liste4 verif4
			if { [string match -nocase *$verif4* $gecos] && $verif4 != "" } {
				if { [::EvaServ::console 1] == "ok" && $config(init) == 0 } {
					::EvaServ::SHOW:INFO:TO:CHANLOG "Kill" "$nickname (Realname: $verif4) a été killé : $config(rreal)"
				}
				::EvaServ::sent2socket ":$config(server_id) KILL $nickname $config(rreal)";
				break;
				::EvaServ::refresh $nickname;
				return 0;
			}
		}
		catch { close $liste4 }
	}
	if { $config(anick) == 1 	} {
		catch { open [::EvaServ::Script:Get:Directory]db/nick.db r } liste5
		while { ![eof $liste5] } {
			gets $liste5 verif5
			if { [string match -nocase $verif5 $nickname] && $verif5 != "" } {
				if { [::EvaServ::console 1] == "ok" && $config(init) == 0 } {
					::EvaServ::SHOW:INFO:TO:CHANLOG "Kill" "$nickname a été killé : $config(ruser)"
				}
				::EvaServ::sent2socket ":$config(server_id) KILL $nickname $config(ruser)";
				break;
				::EvaServ::refresh $nickname;
				return 0;
			}
		}
		catch { close $liste5 }
	}
}

proc ::EvaServ::protection { user level } {
	variable config
	variable netadmin
	variable admins
	variable vhost
	switch -exact $level {
		0 {
			if { [info exists netadmin($user)] } { return ok }
		}
		1 {
			if { [info exists netadmin($user)] } {
				return ok
				} elseif { [
					info exists admins($user)] && \
						[matchattr $admins($user) n]
				} {
				return ok
			}
		}
		2 {
			if { [info exists netadmin($user)] } {
				return ok
			} elseif {
				[info exists admins($user)] && \
					[matchattr $admins($user) m]
			} {
				return ok
			}
		}
		3 {
			if { [info exists netadmin($user)] } {
				return ok
			} elseif {
				[info exists admins($user)] && \
					[matchattr $admins($user) o]
			} {
				return ok
			}
		}
		4 {
			if { [info exists netadmin($user)] } {
				return ok
			} elseif {
				[info exists admins($user)] && \
					[matchattr $admins($user) p]
			} {
				return ok
			}
		}
	}
}

proc ::EvaServ::rnick { user } {
	variable config
	if { $config(rnick) == 1 } { return "($user)" }
}


proc ::EvaServ::prerehash { arg } {
	variable config
	if { [info exists config(idx)] && [valididx $config(idx)] } {
		::EvaServ::gestion
	}
}

proc ::EvaServ::rehash { arg } {
	variable config
	if { [info exists config(idx)] && [valididx $config(idx)] } {
		::EvaServ::Database:Load:Data
	}
}

proc ::EvaServ::evenement { arg } {
	variable config
	if { [info exists config(idx)] && [valididx $config(idx)] } {
		::EvaServ::gestion
		::EvaServ::sent2socket ":$config(server_id) QUIT :$config(raison)"
		::EvaServ::sent2socket ":$config(link) SQUIT $config(link) :$config(raison)"
		foreach kill [utimers] {
			if { [lindex $kill 1] == "::EvaServ::verif" } { killutimer [lindex $kill 2] }
		}
		unset config(idx)
	}
}

proc ::EvaServ::eva { nick idx arg } {
	::EvaServ::sent2ppl $idx "<c01,01>------------<b><c00> Commandes de $config(scriptname) <c01>------------"
	::EvaServ::sent2ppl $idx " "
	::EvaServ::sent2ppl $idx "<c01> .evaconnect <c03>: <c14>Connexion de $config(scriptname)"
	::EvaServ::sent2ppl $idx "<c01> .evadeconnect <c03>: <c14>Déconnexion de $config(scriptname)"
	::EvaServ::sent2ppl $idx "<c01> .evadebug on/off <c03>: <c14>Mode debug de $config(scriptname)"
	::EvaServ::sent2ppl $idx "<c01> .evainfos <c03>: <c14>Voir les infos de $config(scriptname)"
	::EvaServ::sent2ppl $idx "<c01> .evauptime <c03>: <c14>Uptime de $config(scriptname)"
	::EvaServ::sent2ppl $idx "<c01> .evaversion <c03>: <c14>Version de $config(scriptname)"
	::EvaServ::sent2ppl $idx ""
}
proc ::EvaServ::connect { nick idx arg } {
	variable config
	set config(counter)		0
	if { ![info exists config(idx)] } {
		::EvaServ::sent2ppl $idx "<c01>\[ <c03>Connexion<c01> \] <c01> Lancement de $config(scriptname)...";
		::EvaServ::connexion
		set config(dem)		1;
		utimer $config(timerdem) [list set config(dem)		0]
	} else {
		if { ![valididx $config(idx)] } {
			::EvaServ::sent2ppl $idx "<c01>\[ <c03>Connexion<c01> \] <c01> Lancement de $config(scriptname)...";
			::EvaServ::connexion
			set config(dem)		1;
			utimer $config(timerdem) [list set config(dem)		0]
		} else {
			::EvaServ::sent2ppl $idx "<c01>\[ <c04>Impossible<c01> \] <c01> $config(scriptname) est déjà connecté..."
		}
	}

}

proc ::EvaServ::deconnect { nick idx arg } {
	variable config
	if { $config(dem) == 0 } {
		if { [info exists config(idx)] && [valididx $config(idx)] } {
			::EvaServ::gestion
			::EvaServ::sent2ppl $idx "<c01>\[ <c03>Déconnexion<c01> \] <c01> Arret de $config(scriptname)..."
			::EvaServ::sent2socket ":$config(server_id) QUIT :$config(raison)"
			::EvaServ::sent2socket ":$config(link) SQUIT $config(link) :$config(raison)"
			foreach kill [utimers] {
				if { [lindex $kill 1] == "::EvaServ::verif" } { killutimer [lindex $kill 2] }
			}
			unset config(idx)
		} else {
			::EvaServ::sent2ppl $idx "<c01>\[ <c04>Impossible<c01> \] <c01> $config(scriptname) n'est pas connecté..."
		}
	} else {
		::EvaServ::sent2ppl $idx "<c01>\[ <c04>Erreur<c01> \] <c01> Connexion de $config(scriptname) en cours..."
	}
}

proc ::EvaServ::uptime { nick idx arg } {
	variable config
	if { [info exists config(idx)] && [valididx $config(idx)] } {
		set show		""
		set up			[expr ([clock seconds] - $config(uptime))]
		set jour		[expr ($up / 86400)]
		set up			[expr ($up % 86400)]
		set heure		[expr ($up / 3600)]
		set up			[expr ($up % 3600)]
		set minute		[expr ($up / 60)]
		set seconde		[expr ($up % 60)]
		if { $jour == 1 } { append show "$jour jour " } elseif { $jour > 1 } { append show "$jour jours " }
		if { $heure == 1 } { append show "$heure heure " } elseif { $heure > 1 } { append show "$heure heures " }
		if { $minute == 1 } { append show "$minute minute " } elseif { $minute > 1 } { append show "$minute minutes " }
		if { $seconde == 1 } { append show "$seconde seconde " } elseif { $seconde > 1 } { append show "$seconde secondes " }
		::EvaServ::sent2ppl $idx "<c01>\[ <c03>Uptime<c01> \] <c01> $show"
	} else {
		::EvaServ::sent2ppl $idx "<c01>\[ <c04>Uptime<c01> \] <c01> $config(scriptname) n'est pas connecté..."
	}
}

proc ::EvaServ::version { nick idx arg } {
	variable config
	::EvaServ::sent2ppl $idx "<c01>\[ <c03>Version<c01> \] <c01> $config(scriptname) $config(version) by ZarTek"
}

proc ::EvaServ::infos { nick idx arg } {
	variable config
	variable version
	variable tcl_patchLevel
	variable tcl_library
	variable tcl_platform
	::EvaServ::sent2ppl $idx "<c01,01>-----------<b><c00> Infos de $config(scriptname) <c01>-----------"
	::EvaServ::sent2ppl $idx "<c>"
	if { [info exists config(idx)] }	 {
		::EvaServ::sent2ppl $idx "<c01> Statut : <c03>Online"
	} else {
		::EvaServ::sent2ppl $idx "<c01> Statut : <c04>Offline"
	}
	if { $config(debug) == 1 } {
		::EvaServ::sent2ppl $idx "<c01> Debug : <c03>On"
	} else {
		::EvaServ::sent2ppl $idx "<c01> Debug : <c04>Off"
	}
	::EvaServ::sent2ppl $idx "<c01> Os : $tcl_platform(os) $tcl_platform(osVersion)"
	::EvaServ::sent2ppl $idx "<c01> Tcl Version : $tcl_patchLevel"
	::EvaServ::sent2ppl $idx "<c01> Tcl Lib : $tcl_library"
	::EvaServ::sent2ppl $idx "<c01> Encodage : [encoding system]"
	::EvaServ::sent2ppl $idx "<c01> Eggdrop Version : [lindex $version 0]"
	::EvaServ::sent2ppl $idx "<c01> Config : [::EvaServ::Script:Get:Directory]EvaServ.conf"
	::EvaServ::sent2ppl $idx "<c01> Noyau : [::EvaServ::Script:Get:Directory]EvaServ.tcl"
	::EvaServ::sent2ppl $idx "<c>"
}

proc ::EvaServ::debug { nick idx arg } {
	variable config
	set arg			[split $arg]
	set status		[string tolower [lindex $arg 0]]
	if { $status != "on" && $status != "off" } {
		::EvaServ::sent2ppl $idx ".evadebug on/off";
		return 0;
	}

	if { $status == "on" } {
		if { $config(debug) == 0 } {
			set config(debug)		1;
			::EvaServ::sent2ppl $idx "<c01>\[ <c03>Debug<c01> \] <c01> Activé"
		} else {
			::EvaServ::sent2ppl $idx "Le mode debug est déjà activé."
		}
	} elseif { $status == "off" } {
		if { $config(debug) == 1 } {
			set config(debug)		0;
			::EvaServ::sent2ppl $idx "<c01>\[ <c03>Debug<c01> \] <c01> Désactivé"
			if { [file exists "logs/EvaServ.debug"] } { exec rm -rf logs/EvaServ.debug }
		} else {
			::EvaServ::sent2ppl $idx "Le mode debug est déjà désactivé."
		}
	}
}






#################
# Eva Nettoyage #
#################



############
# Eva Cmds #
############

proc ::EvaServ::cmds { arg } {
	variable config
	variable users
	variable admin
	variable admins
	variable vhost
	variable protect
	variable trust
	set arg		[split $arg]
	set cmd		[lindex $arg 0]
	set user	[lindex $arg 1]
	set vuser	[string tolower $user]
	set value1	[lindex $arg 2]
	set value2	[string tolower [lindex $arg 2]]
	set value3	[lindex $arg 3]
	set value4	[string tolower [lindex $arg 3]]
	set value5	[join [lrange $arg 4 end]]
	set value6	[join [lrange $arg 3 end]]
	set value7	[join [lrange $arg 2 end]]
	set value8	[lindex $arg 4]
	set value9	[string tolower [lindex $arg 4]]
	set stop	0
	if { [::EvaServ::authed $vuser $cmd] != "ok" } { return 0 }
	switch -exact $cmd {
		"auth" {
			if { [lindex $arg 2] == "" || [lindex $arg 3] == "" } {
				::EvaServ::sent2socket ":$config(server_id) NOTICE [::EvaServ::UID:CONVERT $user] :<b>Commande Auth :</b> /msg $config(service_nick) auth pseudo password";
				return 0
			}
			if { [passwdok [lindex $arg 2] [lindex $arg 3]] } {
				if { [matchattr [lindex $arg 2] o] || [matchattr [lindex $arg 2] m] || [matchattr [lindex $arg 2] n] } {
					if { $config(login) == 1 } {
						foreach { pseudo login } [array get admins] {
							if { $login == [string tolower [lindex $arg 2]] && $pseudo!=$vuser } {
								::EvaServ::sent2socket ":$config(server_id) NOTICE [::EvaServ::UID:CONVERT $vuser] :Maximum de Login atteint.";
								return 0;
							}
						}
					}
					if { ![info exists admins($vuser)] } {
						set admins($vuser)		[string tolower [lindex $arg 2]]
						if { [info exists vhost($vuser)] && ![info exists protect($vhost($vuser))] } {
							::EvaServ::SHOW:INFO:TO:CHANLOG "Protecion du host" "$vhost($vuser) de $vuser (Activé)"
							set protect($vhost($vuser))		1
						}
						setuser [string tolower [lindex $arg 2]] LASTON [unixtime]
						::EvaServ::SENT:MSG:TO:USER $vuser "Authentification Réussie."
						::EvaServ::sent2socket ":$config(server_id) INVITE $vuser $config(salon)"
						if { [::EvaServ::console 1] == "ok" } {
							::EvaServ::SHOW:INFO:TO:CHANLOG "Auth" "$user"
						}
						return 0
					} else {
						::EvaServ::SENT:MSG:TO:USER $vuser "Vous êtes déjà authentifié.";
						return 0;
					}
				} elseif { [matchattr [lindex $arg 2] p] } {
					::EvaServ::SENT:MSG:TO:USER $vuser "Authentification Helpeur Refusée.";
					return 0;
				}

			} else {
				::EvaServ::SENT:MSG:TO:USER $vuser "Accès Refusé.";
				return 0;
			}
		}
		"deauth" {
			if { [info exists admins($vuser)] } {
				if { [matchattr $admins($vuser) o] || [matchattr $admins($vuser) m] || [matchattr $admins($vuser) n] } {
					if { [info exists vhost($vuser)] && [info exists protect($vhost($vuser))] } {
						::EvaServ::SHOW:INFO:TO:CHANLOG "Protecion du host" "$vhost($vuser) de $vuser (Désactivé)"
						unset protect($vhost($vuser))
					}
					unset admins($vuser);
					::EvaServ::SENT:MSG:TO:USER $vuser "Déauthentification Réussie."
					if { [::EvaServ::console 1] == "ok" } {
						::EvaServ::SHOW:INFO:TO:CHANLOG "Deauth" "$user"
					}
				} elseif { [matchattr $admins($vuser) p] } {
					::EvaServ::SENT:MSG:TO:USER $vuser "Déauthentification Helpeur Refusée.";
					return 0;
				}

			} else {
				::EvaServ::SENT:MSG:TO:USER $vuser "Vous n'êtes pas authentifié."
			}
		}
		"copyright" {
			::EvaServ::SENT:MSG:TO:USER $user "<c01>$config(scriptname) $config(version) by TiSmA/ZarTek"
			if { [::EvaServ::console 1] == "ok" } {
				::EvaServ::SHOW:INFO:TO:CHANLOG "Copyright" "$user"
			}
		}
		"console" {
			if { $value2 == "" || [regexp \[^0-3\] $value2] } {
				::EvaServ::SENT:MSG:TO:USER $vuser "<b>Commande Console :</b> /msg $config(service_nick) console 0/1/2/3"
				::EvaServ::SENT:MSG:TO:USER $vuser "<c02>Level 0 <c04>:<c01> Aucune console"
				::EvaServ::SENT:MSG:TO:USER $vuser "<c02>Level 1 <c04>:<c01> Console commande"
				::EvaServ::SENT:MSG:TO:USER $vuser "<c02>Level 2 <c04>:<c01> Console commande & connexion & déconnexion"
				::EvaServ::SENT:MSG:TO:USER $vuser "<c02>Level 3 <c04>:<c01> Toutes les consoles"
				return 0
			}
			switch -exact $value2 {
				0 {
					set config(console)		0;
					::EvaServ::SENT:MSG:TO:USER $vuser "Level 0 : Aucune console"
					::EvaServ::SHOW:INFO:TO:CHANLOG "Console" "$user"
				}
				1 {
					set config(console)		1;
					::EvaServ::SENT:MSG:TO:USER $vuser "Level 1 : Console commande"
					::EvaServ::SHOW:INFO:TO:CHANLOG "Console" "$user"
				}
				2 {
					set config(console)		2;
					::EvaServ::SENT:MSG:TO:USER $vuser "Level 2 : Console commande & connexion & déconnexion"
					::EvaServ::SHOW:INFO:TO:CHANLOG "Console" "$user"
				}
				3 {
					set config(console)		3;
					::EvaServ::SENT:MSG:TO:USER $vuser "Level 3 : Toutes les consoles"
					::EvaServ::SHOW:INFO:TO:CHANLOG "Console" "$user"
				}
			}
		}
		"chanlog" {
			if { $value2 == [string tolower $config(salon)] } {
				::EvaServ::SENT:MSG:TO:USER $vuser "<b>$value1</b> est déjà le salon de log.";
				return 0
			}
			if { [string index $value2 0] != "#" } {
				::EvaServ::SENT:MSG:TO:USER $vuser "<b>Commande Chanlog :</b> /msg $config(service_nick) chanlog #salon";
				return 0
			}
			catch { open "[::EvaServ::Script:Get:Directory]db/salon.db" r } liste1
			while { ![eof $liste1] } {
				gets $liste1 verif1;
				if { ![string compare -nocase $value2 $verif1] } {
					::EvaServ::SENT:MSG:TO:USER $vuser "Accès Refusé : Salon Interdit";
					set stop 1;
					break
				}
			}
			catch { close $liste1 }
			if { $stop == 1 } { return 0 }
			catch { open "[::EvaServ::Script:Get:Directory]db/close.db" r } liste2
			while { ![eof $liste2] } {
				gets $liste2 verif2;
				if { ![string compare -nocase $value2 $verif2] } {
					::EvaServ::SENT:MSG:TO:USER $vuser "Accès Refusé : Salon Fermé";
					set stop		1;
					break
				}
			}
			catch { close $liste2 }
			if { $stop == 1 } { return 0 }
			catch { open "[::EvaServ::Script:Get:Directory]db/chan.db" r } liste3
			while { ![eof $liste3] } {
				gets $liste3 verif3;
				if { ![string compare -nocase $value2 $verif3] } {
					::EvaServ::SENT:MSG:TO:USER $vuser "Accès Refusé : Salon Autojoin";
					set stop		1;
					break
				}
			}
			catch { close $liste3 }
			if { $stop == 1 } { return 0 }
			::EvaServ::sent2socket ":$config(server_id) PART $config(salon)"
			::EvaServ::FCT:SENT:MODE $config(salon) "-O"
			set config(salon)		$value1
			::EvaServ::sent2socket ":$config(server_id) JOIN $config(salon)"
			::EvaServ::FCT:SENT:MODE $config(salon) "+$config(smode)"
			if { $config(cmode) == "q" || $config(cmode) == "a" || $config(cmode) == "o" || $config(cmode) == "h" || $config(cmode) == "v" } {
				::EvaServ::FCT:SENT:MODE $config(salon) "+$config(cmode)" $config(service_nick)
			}
			::EvaServ::SENT:MSG:TO:USER $vuser "Changement du salon de log reussi ($value1)"
			if { [::EvaServ::console 1] == "ok" } {
				::EvaServ::SHOW:INFO:TO:CHANLOG "Chanlog" "Changement du salon de log par $user ($value1)"
			}
		}
		"join" {
			if { [string index $value2 0] != "#" } {
				::EvaServ::SENT:MSG:TO:USER $vuser "<b>Commande Join :</b> /msg $config(service_nick) join #salon";
				return 0
			}
			if { $value2 == [string tolower $config(salon)] } {
				::EvaServ::SENT:MSG:TO:USER $vuser "Accès Refusé : Salon de logs";
				return 0
			}
			catch { open "[::EvaServ::Script:Get:Directory]db/salon.db" r } liste1
			while { ![eof $liste1] } {
				gets $liste1 verif1;
				if { ![string compare -nocase $value2 $verif1] } {
					::EvaServ::SENT:MSG:TO:USER $vuser "Accès Refusé : Salon Interdit";
					set stop		1;
					break
				}
			}
			catch { close $liste1 }
			if { $stop == 1 } { return 0 }
			catch { open "[::EvaServ::Script:Get:Directory]db/close.db" r } liste2
			while { ![eof $liste2] } {
				gets $liste2 verif2;
				if { ![string compare -nocase $value2 $verif2] } {
					::EvaServ::SENT:MSG:TO:USER $vuser "Accès Refusé : Salon Fermé";
					set stop		1;
					break
				}
			}
			catch { close $liste2 }
			if { $stop == 1 } { return 0 }
			catch { open "[::EvaServ::Script:Get:Directory]db/chan.db" r } liste
			while { ![eof $liste] } {
				gets $liste verif;
				if { ![string compare -nocase $value2 $verif] } {
					::EvaServ::SENT:MSG:TO:USER $vuser "$config(service_nick) est déjà sur <b>$value1</b>.";
					set stop		1;
					break
				}
			}
			catch { close $liste }
			if { $stop == 1 } { return 0 }
			set join		[open "[::EvaServ::Script:Get:Directory]db/chan.db" a];
			puts $join $value2;
			close $join;
			::EvaServ::sent2socket ":$config(server_id) JOIN $value1"
			if { $config(cmode) == "q" || $config(cmode) == "a" || $config(cmode) == "o" || $config(cmode) == "h" || $config(cmode) == "v" } {
				::EvaServ::FCT:SENT:MODE $value1 "+$config(cmode)" $config(service_nick)
			}
			::EvaServ::SENT:MSG:TO:USER $vuser "$config(service_nick) entre sur <b>$value1</b>"

			if { [::EvaServ::console 1] == "ok" } {
				::EvaServ::SHOW:INFO:TO:CHANLOG "Join" "$value1 par $user"
			}
		}
		"part" {
			if { [string index $value2 0] != "#" } {
				::EvaServ::SENT:MSG:TO:USER $vuser "<b>Commande Part :</b> /msg $config(service_nick) part #salon";
				return 0;
			}

			if { $value2 == [string tolower $config(salon)] } {
				::EvaServ::SENT:MSG:TO:USER $vuser "Accès Refusé";
				return 0;
			}

			catch { open "[::EvaServ::Script:Get:Directory]db/chan.db" r } liste
			while { ![eof $liste] } {
				gets $liste verif;
				if { ![string compare -nocase $value2 $verif] } { set stop		1 }
				if { [string compare -nocase $value2 $verif] && $verif != "" } { lappend salle "$verif" }
			}
			catch { close $liste }
			if { $stop == 0 } {
				::EvaServ::SENT:MSG:TO:USER $vuser "$config(service_nick) n'est pas sur <b>$value1</b>.";
				return 0;
			} else {
				if { [info exists salle] } {
					set del		[open "[::EvaServ::Script:Get:Directory]db/chan.db" w+];
					foreach chandel $salle { puts $del "$chandel" }
					close $del
				} else {
					set del		[open "[::EvaServ::Script:Get:Directory]db/chan.db" w+];
					close $del
				}
				::EvaServ::FCT:SENT:MODE $value1 "-sntio";
				::EvaServ::sent2socket ":$config(server_id) PART $value1"
				::EvaServ::SENT:MSG:TO:USER $vuser "$config(service_nick) part de <b>$value1</b>"
				if { [::EvaServ::console 1] == "ok" } {
					::EvaServ::SHOW:INFO:TO:CHANLOG "Part" "$value1 par $user"
				}
			}
		}
		"list" {
			catch { open "[::EvaServ::Script:Get:Directory]db/chan.db" r } liste
			::EvaServ::SENT:MSG:TO:USER $vuser "<b><c1,1>--------- <c0>Autojoin salons <c1>---------"
			::EvaServ::SENT:MSG:TO:USER $vuser "<b>"
			while { ![eof $liste] } {
				gets $liste salon;
				if { $salon != "" } {
					incr stop 1;
					::EvaServ::SENT:MSG:TO:USER $vuser "<c01> \[<c03> $stop <c01>\] <c01> $salon"
				}
			}
			catch { close $liste }
			if { $stop == 0 } {
				::EvaServ::SENT:MSG:TO:USER $vuser "Aucun Salon"
			}
			if { [::EvaServ::console 1] == "ok" } {
				::EvaServ::SHOW:INFO:TO:CHANLOG "List" "$user"
			}
		}
		"showcommands" {
			::EvaServ::SENT:MSG:TO:USER $vuser "<b><c01,01>--------------------------------------- <c00>Commandes de $config(scriptname) <c01>---------------------------------------"
			::EvaServ::SHOW:CMD:DESCRIPTION:BY:LEVEL $vuser 0
			if { [info exists admins($vuser)] && [matchattr $admins($vuser) p] } {
				::EvaServ::SHOW:CMD:DESCRIPTION:BY:LEVEL $vuser 1
			}
			if { [info exists admins($vuser)] && [matchattr $admins($vuser) o] } {
				::EvaServ::SHOW:CMD:DESCRIPTION:BY:LEVEL $vuser 2
			}
			if { [info exists admins($vuser)] && [matchattr $admins($vuser) m] } {
				::EvaServ::SHOW:CMD:DESCRIPTION:BY:LEVEL $vuser 3
			}
			if { [info exists admins($vuser)] && [matchattr $admins($vuser) n] } {
				::EvaServ::SHOW:CMD:DESCRIPTION:BY:LEVEL $vuser 4
			}
			::EvaServ::SENT:MSG:TO:USER $vuser "<c02>Aide sur une commande<c01> \[<c04> /msg $config(service_nick) help <la_commande> <c01>\]"
			if { [::EvaServ::console 1] == "ok" } {
				::EvaServ::SHOW:INFO:TO:CHANLOG "Showcommands" "$user"
			}
		}
		"help" {
			::EvaServ::SENT:MSG:TO:USER $vuser "<b><c01,01>--------------------------------------- <c00>Commandes de $config(scriptname) <c01>---------------------------------------"
			::EvaServ::SENT:MSG:TO:USER $vuser "<c>"
			::EvaServ::SHOW:CMD:BY:LEVEL $vuser 0
			if { [info exists admins($vuser)] && [matchattr $admins($vuser) p] } {
				::EvaServ::SHOW:CMD:BY:LEVEL $vuser 1
			}
			if { [info exists admins($vuser)] && [matchattr $admins($vuser) o] } {
				::EvaServ::SHOW:CMD:BY:LEVEL $vuser 2
			}
			if { [info exists admins($vuser)] && [matchattr $admins($vuser) m] } {
				::EvaServ::SHOW:CMD:BY:LEVEL $vuser 3
			}
			if { [info exists admins($vuser)] && [matchattr $admins($vuser) n] } {
				::EvaServ::SHOW:CMD:BY:LEVEL $vuser 4
			}
			::EvaServ::SENT:MSG:TO:USER $vuser "<c02>Listes des commandes<c01> \[<c04> /msg $config(service_nick) showcommands <c01>\]"
			if { [::EvaServ::console 1] == "ok" } {
				::EvaServ::SHOW:INFO:TO:CHANLOG "Help" "$user"
			}
		}
		"maxlogin" {
			if { $value2 != "on" && $value2 != "off" } {
				::EvaServ::SENT:MSG:TO:USER $vuser "<b>Commande Maxlogin :</b> /msg $config(service_nick) maxlogin on/off";
				return 0;
			}

			if { $value2 == "on" } {
				if { $config(login) == 0 } {
					set config(login)		1;
					::EvaServ::SENT:MSG:TO:USER $vuser "Protection maxlogin activée"
					if { [::EvaServ::console 1] == "ok" } {
						::EvaServ::SHOW:INFO:TO:CHANLOG "Maxlogin" "$user"
					}
				} else {
					::EvaServ::SENT:MSG:TO:USER $vuser "La protection maxlogin est déjà activée."
				}
			} elseif { $value2 == "off" } {
				if { $config(login) == 1 } {
					set config(login)		0;
					::EvaServ::SENT:MSG:TO:USER $vuser "Protection maxlogin désactivée"
					if { [::EvaServ::console 1] == "ok" } {
						::EvaServ::SHOW:INFO:TO:CHANLOG "Maxlogin" "$user"
					}
				} else {
					::EvaServ::SENT:MSG:TO:USER $vuser "La protection maxlogin est déjà désactivée."
				}
			}
		}
		"backup" {
			::EvaServ::gestion
			exec cp -f [::EvaServ::Script:Get:Directory]db/gestion.db [::EvaServ::Script:Get:Directory]db/gestion.bak
			exec cp -f [::EvaServ::Script:Get:Directory]db/chan.db [::EvaServ::Script:Get:Directory]db/chan.bak
			exec cp -f [::EvaServ::Script:Get:Directory]db/client.db [::EvaServ::Script:Get:Directory]db/client.bak
			exec cp -f [::EvaServ::Script:Get:Directory]db/close.db [::EvaServ::Script:Get:Directory]db/close.bak
			exec cp -f [::EvaServ::Script:Get:Directory]db/real.db [::EvaServ::Script:Get:Directory]db/real.bak
			exec cp -f [::EvaServ::Script:Get:Directory]db/ident.db [::EvaServ::Script:Get:Directory]db/ident.bak
			exec cp -f [::EvaServ::Script:Get:Directory]db/host.db [::EvaServ::Script:Get:Directory]db/host.bak
			exec cp -f [::EvaServ::Script:Get:Directory]db/nick.db [::EvaServ::Script:Get:Directory]db/nick.bak
			exec cp -f [::EvaServ::Script:Get:Directory]db/salon.db [::EvaServ::Script:Get:Directory]db/salon.bak
			exec cp -f [::EvaServ::Script:Get:Directory]db/trust.db [::EvaServ::Script:Get:Directory]db/trust.bak
			::EvaServ::SENT:MSG:TO:USER $vuser "Sauvegarde des databases réalisée."
			if { [::EvaServ::console 1] == "ok" } {
				::EvaServ::SHOW:INFO:TO:CHANLOG "Backup" "$user"
			}
		}
		"restart" {
			if { [::EvaServ::console 1] == "ok" } {
				::EvaServ::SHOW:INFO:TO:CHANLOG "Restart" "$user"
			}
			::EvaServ::SENT:MSG:TO:USER $vuser "Redémarrage de $config(scriptname)."
			::EvaServ::gestion;
			::EvaServ::sent2socket ":$config(server_id) QUIT $config(raison)";
			::EvaServ::sent2socket ":$config(link) SQUIT $config(link) :$config(raison)"
			foreach kill [utimers] {
				if { [lindex $kill 1] == "::EvaServ::verif" } { killutimer [lindex $kill 2] }
			}
			if { [info exists config(idx)] } { unset config(idx)		}
			set config(counter)		0;
			::EvaServ::config
			utimer 1 ::EvaServ::connexion
		}
		"die" {
			if { [::EvaServ::console 1] == "ok" } {
				::EvaServ::SHOW:INFO:TO:CHANLOG "Die" "$user"
			}
			::EvaServ::SENT:MSG:TO:USER $vuser "Arrêt de $config(scriptname)."
			::EvaServ::gestion;
			::EvaServ::sent2socket ":$config(server_id) QUIT $config(raison)";
			::EvaServ::sent2socket ":$config(link) SQUIT $config(link) :$config(raison)"
			foreach kill [utimers] {
				if { [lindex $kill 1] == "::EvaServ::verif" } { killutimer [lindex $kill 2] }
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
			set up			[expr ([clock seconds] - $config(uptime))]
			set jour		[expr ($up / 86400)]
			set up			[expr ($up % 86400)]
			set heure		[expr ($up / 3600)]
			set up			[expr ($up % 3600)]
			set minute		[expr ($up / 60)]
			set seconde		[expr ($up % 60)]
			if { $jour == 1 }		{ append show "$jour jour " } elseif { $jour > 1 } { append show "$jour jours " }
			if { $heure == 1 }		{ append show "$heure heure " } elseif { $heure > 1 } { append show "$heure heures " }
			if { $minute == 1 }		{ append show "$minute minute " } elseif { $minute > 1 } { append show "$minute minutes " }
			if { $seconde == 1 }	{ append show "$seconde seconde " } elseif { $seconde > 1 } { append show "$seconde secondes " }
			catch { open [::EvaServ::Script:Get:Directory]db/client.db r } liste
			while { ![eof $liste] } {
				gets $liste sclients;
				if { $sclients != "" } { incr numclient 1 }
			}
			catch { close $liste }
			catch { open [::EvaServ::Script:Get:Directory]db/chan.db r } liste2
			while { ![eof $liste2] } {
				gets $liste2 schans;
				if { $schans != "" } { incr numchan 1 }
			}
			catch { close $liste2 }
			catch { open [::EvaServ::Script:Get:Directory]db/salon.db r } liste4
			while { ![eof $liste4] } {
				gets $liste4 ssalon;
				if { $ssalon != "" } { incr numsalons 1 }
			}
			catch { close $liste4 }
			catch { open [::EvaServ::Script:Get:Directory]db/close.db r } liste5
			while { ![eof $liste5] } {
				gets $liste5 sclose;
				if { $sclose != "" } { incr numclose 1 }
			}
			catch { close $liste5 }
			catch { open [::EvaServ::Script:Get:Directory]db/nick.db r } liste6
			while { ![eof $liste6] } {
				gets $liste6 suser;
				if { $suser != "" } { incr numuser 1 }
			}
			catch { close $liste6 }
			catch { open [::EvaServ::Script:Get:Directory]db/ident.db r } liste7
			while { ![eof $liste7] } {
				gets $liste7 sident;
				if { $sident != "" } { incr numident 1 }
			}
			catch { close $liste7 }
			catch { open [::EvaServ::Script:Get:Directory]db/host.db r } liste8
			while { ![eof $liste8] } {
				gets $liste8 shost;
				if { $shost != "" } { incr numhost 1 }
			}
			catch { close $liste8 }
			catch { open [::EvaServ::Script:Get:Directory]db/real.db r } liste9
			while { ![eof $liste9] } {
				gets $liste9 sreal;
				if { $sreal != "" } { incr numreal 1 }
			}
			catch { close $liste9 }
			catch { open [::EvaServ::Script:Get:Directory]db/trust.db r } liste10
			while { ![eof $liste10] } {
				gets $liste10 strust;
				if { $strust != "" } { incr numtrust 1 }
			}
			catch { close $liste10 }
			::EvaServ::SENT:MSG:TO:USER $vuser "<b><c1,1>------------------ <c0>Status de $config(scriptname) <c1>------------------"
			::EvaServ::SENT:MSG:TO:USER $vuser "<b>"
			::EvaServ::SENT:MSG:TO:USER $vuser "<c02> Owner : <c01>$admin"
			::EvaServ::SENT:MSG:TO:USER $vuser "<c02> Salon de logs : <c01>$config(salon)"
			::EvaServ::SENT:MSG:TO:USER $vuser "<c02> Salon Autojoin : <c01>$numchan"
			::EvaServ::SENT:MSG:TO:USER $vuser "<c02> Uptime : <c01>$show"
			switch -exact $config(console) {
				0 { ::EvaServ::SENT:MSG:TO:USER $vuser "<c02> Level Console : <c01>0" }
				1 { ::EvaServ::SENT:MSG:TO:USER $vuser "<c02> Level Console : <c01>1" }
				2 { ::EvaServ::SENT:MSG:TO:USER $vuser "<c02> Level Console : <c01>2" }
				3 { ::EvaServ::SENT:MSG:TO:USER $vuser "<c02> Level Console : <c01>3" }
			}
			switch -exact $config(protection) {
				0 { ::EvaServ::SENT:MSG:TO:USER $vuser "<c02> Level Protection : <c01>0" }
				1 { ::EvaServ::SENT:MSG:TO:USER $vuser "<c02> Level Protection : <c01>1" }
				2 { ::EvaServ::SENT:MSG:TO:USER $vuser "<c02> Level Protection : <c01>2" }
				3 { ::EvaServ::SENT:MSG:TO:USER $vuser "<c02> Level Protection : <c01>3" }
				4 { ::EvaServ::SENT:MSG:TO:USER $vuser "<c02> Level Protection : <c01>4" }
			}
			if { $config(login) == 1 } {
				::EvaServ::SENT:MSG:TO:USER $vuser "<c02> Protection Maxlogin : <c03>On"
			} else {
				::EvaServ::SENT:MSG:TO:USER $vuser "<c02> Protection Maxlogin : <c04>Off"
			}
			if { $config(aclient) == 1 } {
				::EvaServ::SENT:MSG:TO:USER $vuser "<c02> Protection Clients IRC : <c03>On"
			} else {
				::EvaServ::SENT:MSG:TO:USER $vuser "<c02> Protection Clients IRC : <c04>Off"
			}
			::EvaServ::SENT:MSG:TO:USER $vuser "<c02> Nbre de Salons Fermés : <c01>$numclose"
			::EvaServ::SENT:MSG:TO:USER $vuser "<c02> Nbre de Salons Interdits : <c01>$numsalons"
			::EvaServ::SENT:MSG:TO:USER $vuser "<c02> Nbre de Pseudos Interdits : <c01>$numuser"
			::EvaServ::SENT:MSG:TO:USER $vuser "<c02> Nbre de Idents Interdits : <c01>$numident"
			::EvaServ::SENT:MSG:TO:USER $vuser "<c02> Nbre de Hostnames Interdites : <c01>$numhost"
			::EvaServ::SENT:MSG:TO:USER $vuser "<c02> Nbre de Realnames Interdits : <c01>$numreal"
			::EvaServ::SENT:MSG:TO:USER $vuser "<c02> Nbre de Clients IRC : <c01>$numclient"
			::EvaServ::SENT:MSG:TO:USER $vuser "<c02> Nbre de Trusts : <c01>$numtrust"
			::EvaServ::SENT:MSG:TO:USER $vuser "<b>"
			if { [::EvaServ::console 1] == "ok" } {
				::EvaServ::SHOW:INFO:TO:CHANLOG "Status" "$user"
			}
		}
		"protection" {
			if { $value2 == "" || [regexp \[^0-4\] $value2] } {
				::EvaServ::SENT:MSG:TO:USER $vuser "<b>Commande Protection :</b> /msg $config(service_nick) protection 0/1/2/3/4"
				::EvaServ::SENT:MSG:TO:USER $vuser "<c02>Level 0 <c04>:<c01> Aucune Protection"
				::EvaServ::SENT:MSG:TO:USER $vuser "<c02>Level 1 <c04>:<c01> Protection Admins"
				::EvaServ::SENT:MSG:TO:USER $vuser "<c02>Level 2 <c04>:<c01> Protection Admins + Ircops"
				::EvaServ::SENT:MSG:TO:USER $vuser "<c02>Level 3 <c04>:<c01> Protection Admins + Ircops + Géofronts"
				::EvaServ::SENT:MSG:TO:USER $vuser "<c02>Level 4 <c04>:<c01> Protection de tous les accès"
				return 0
			}
			switch -exact $value2 {
				0 {
					set config(protection)		0;
					::EvaServ::SENT:MSG:TO:USER $vuser "Level 0 : Aucune Protection"
					::EvaServ::SHOW:INFO:TO:CHANLOG "Protection" "$user"
				}
				1 {
					set config(protection)		1;
					::EvaServ::SENT:MSG:TO:USER $vuser "Level 1 : Protection Admins"
					::EvaServ::SHOW:INFO:TO:CHANLOG "Protection" "$user"
				}
				2 {
					set config(protection)		2;
					::EvaServ::SENT:MSG:TO:USER $vuser "Level 2 : Protection Admins + Ircops"
					::EvaServ::SHOW:INFO:TO:CHANLOG "Protection" "$user"
				}
				3 {
					set config(protection)		3;
					::EvaServ::SENT:MSG:TO:USER $vuser "Level 3 : Protection Admins + Ircops + Géofronts"
					::EvaServ::SHOW:INFO:TO:CHANLOG "Protection" "$user"
				}
				4 {
					set config(protection)		4;
					::EvaServ::SENT:MSG:TO:USER $vuser "Level 4 : Protection de tous les accès"
					::EvaServ::SHOW:INFO:TO:CHANLOG "Protection" "$user"
				}
			}
		}
		"newpass" {
			if { $value1 == "" } {
				::EvaServ::SENT:MSG:TO:USER $vuser "<b>Commande Newpass :</b> /msg $config(service_nick) newpass mot-de-passe";
				return 0;
			}

			if { [string length $value1] <= 5 } {
				::EvaServ::SENT:MSG:TO:USER $vuser "Le mot de passe doit contenir minimum 6 caractères.";
				return 0;
			}

			setuser $admins($vuser) PASS $value1
			::EvaServ::SENT:MSG:TO:USER $user "Changement du mot de passe reussi."
			if { [::EvaServ::console 1] == "ok" } {
				::EvaServ::SHOW:INFO:TO:CHANLOG "Newpass" "$user"
			}
		}
		"map" {
			set config(rep)		$vuser
			::EvaServ::sent2socket ":$config(server_id) LINKS"
			if { [::EvaServ::console 1] == "ok" } {
				::EvaServ::SHOW:INFO:TO:CHANLOG "Map" "$user"
			}
		}
		"seen" {
			if { $value1 == "" } {
				::EvaServ::SENT:MSG:TO:USER $user "<b>Commande Seen :</b> /msg $config(service_nick) seen pseudo";
				return 0;
			}

			if { [validuser $value1] } {
				set annee		[lindex [ctime [getuser $value1 LASTON]] 4]
				if { $annee != "1970" } { set seen		[::EvaServ::duree [getuser $value1 LASTON]] } else {
					set seen		"Jamais"
				}
				if { [::EvaServ::console 1] == "ok" } {
					::EvaServ::SHOW:INFO:TO:CHANLOG "Seen" "$user"
				}
				if { [matchattr $value1 n] } {
					::EvaServ::SENT:MSG:TO:USER $vuser "<c1>Pseudo \[<c4>$value1<c1>\] <c> Level \[<c03>Admin<c1>\] <c> Seen \[<c02>$seen<c1>\]"
				} elseif { [matchattr $value1 m] } {
					::EvaServ::SENT:MSG:TO:USER $vuser "<c1>Pseudo \[<c4>$value1<c1>\] <c> Level \[<c03>Ircop<c1>\] <c> Seen \[<c02>$seen<c1>\]"
				} elseif { [matchattr $value1 o] } {
					::EvaServ::SENT:MSG:TO:USER $vuser "<c1>Pseudo \[<c4>$value1<c1>\] <c> Level \[<c03>Géofront<c1>\] <c> Seen \[<c02>$seen<c1>\]"
				} elseif { [matchattr $value1 p] } {
					::EvaServ::SENT:MSG:TO:USER $vuser "<c1>Pseudo \[<c4>$value1<c1>\] <c> Level \[<c03>Helpeur<c1>\] <c> Seen \[<c02>$seen<c1>\]"
				}
			} else {
				::EvaServ::SENT:MSG:TO:USER $vuser "Pseudo inconnu.";
				return 0;
			}
		}
		"access" {
			if { $value1 == "*" || $value1 == "" } {
				if { [::EvaServ::console 1] == "ok" } {
					::EvaServ::SHOW:INFO:TO:CHANLOG "Access" "$user"
				}
				::EvaServ::SENT:MSG:TO:USER $vuser "<b><c1,1>------------------------------- <c0>Liste des Accès <c1>-------------------------------"
				::EvaServ::SENT:MSG:TO:USER $vuser "<b>"
				foreach acces [userlist] {
					set annee		[lindex [ctime [getuser $acces LASTON]] 4]
					if { $annee != "1970" } { set seen		[::EvaServ::duree [getuser $acces LASTON]] } else {
						set seen		"Jamais"
					}
					foreach { act reg } [array get admins] {
						if { $reg == [string tolower $acces] } { set status		"<c03>Online" }
					}
					if { ![info exists status] } { set status		"<c04>Offline" }
					switch -exact $config(protection) {
						1 {
							if { [matchattr $acces n] } { set aprotect		"<c03>On" }
						}
						2 {
							if { [matchattr $acces m] } { set aprotect		"<c03>On" }
						}
						3 {
							if { [matchattr $acces o] } { set aprotect		"<c03>On" }
						}
						4 {
							if { [matchattr $acces p] } { set aprotect		"<c03>On" }
						}
					}
					if { ![info exists aprotect] } { set aprotect		"<c04>Off" }
					if { [matchattr $acces n] } {
						::EvaServ::SENT:MSG:TO:USER $vuser "<c01> Pseudo \[<c04>$acces<c01>\] <c01> Level \[<c03>Admin<c01>\] <c01> Seen \[<c12>$seen<c01>\]"
						::EvaServ::SENT:MSG:TO:USER $vuser "<c01> Statut \[$status<c01>\] <c01> Protection \[$aprotect<c01>\]"
						::EvaServ::SENT:MSG:TO:USER $vuser "<c01> Mask \[<c02>[getuser $acces HOSTS]<c01>\]"
						::EvaServ::SENT:MSG:TO:USER $vuser "<c>"
					} elseif { [matchattr $acces m] } {
						::EvaServ::SENT:MSG:TO:USER $vuser "<c01> Pseudo \[<c04>$acces<c01>\] <c01> Level \[<c03>Ircop<c01>\] <c01> Seen \[<c12>$seen<c01>\]"
						::EvaServ::SENT:MSG:TO:USER $vuser "<c01> Statut \[$status<c01>\] <c01> Protection \[$aprotect<c01>\]"
						::EvaServ::SENT:MSG:TO:USER $vuser "<c01> Mask \[<c02>[getuser $acces HOSTS]<c01>\]"
						::EvaServ::SENT:MSG:TO:USER $vuser "<c>"
					} elseif { [matchattr $acces o] } {
						::EvaServ::SENT:MSG:TO:USER $vuser "<c01> Pseudo \[<c04>$acces<c01>\] <c01> Level \[<c03>Géofront<c01>\] <c01> Seen \[<c12>$seen<c01>\]"
						::EvaServ::SENT:MSG:TO:USER $vuser "<c01> Statut \[$status<c01>\] <c01> Protection \[$aprotect<c01>\]"
						::EvaServ::SENT:MSG:TO:USER $vuser "<c01> Mask \[<c02>[getuser $acces HOSTS]<c01>\]"
						::EvaServ::SENT:MSG:TO:USER $vuser "<c>"
					} elseif { [matchattr $acces p] } {
						::EvaServ::SENT:MSG:TO:USER $vuser "<c01> Pseudo \[<c04>$acces<c01>\] <c01> Level \[<c03>Helpeur<c01>\] <c01> Seen \[<c12>$seen<c01>\]"
						::EvaServ::SENT:MSG:TO:USER $vuser "<c01> Statut \[$status<c01>\] <c01> Protection \[$aprotect<c01>\]"
						::EvaServ::SENT:MSG:TO:USER $vuser "<c01> Mask \[<c02>[getuser $acces HOSTS]<c01>\]"
						::EvaServ::SENT:MSG:TO:USER $vuser "<c>"
					}
					unset status;
					unset seen;
					unset aprotect
				}
			} elseif { [validuser $value1] } {
				set annee		[lindex [ctime [getuser $value1 LASTON]] 4]
				if { $annee != "1970" } { set seen		[::EvaServ::duree [getuser $value1 LASTON]] } else {
					set seen		"Jamais"
				}
				foreach { act reg } [array get admins] {
					if { $reg == [string tolower $value1] } { set status		"<c03>Online" }
				}
				if { ![info exists status] } { set status		"<c04>Offline" }
				switch -exact $config(protection) {
					1 {
						if { [matchattr $value1 n] } { set aprotect		"<c03>On" }
					}
					2 {
						if { [matchattr $value1 m] } { set aprotect		"<c03>On" }
					}
					3 {
						if { [matchattr $value1 o] } { set aprotect		"<c03>On" }
					}
					4 {
						if { [matchattr $value1 p] } { set aprotect		"<c03>On" }
					}
				}
				if { ![info exists aprotect] } { set aprotect		"<c04>Off" }
				if { [::EvaServ::console 1] == "ok" } {
					::EvaServ::SHOW:INFO:TO:CHANLOG "Access" "$user"
				}
				::EvaServ::SENT:MSG:TO:USER $vuser "<b><c1,1>--------------------------- <c0>Accès de $value1 <c1>---------------------------"
				::EvaServ::SENT:MSG:TO:USER $vuser "<b>"
				if { [matchattr $value1 n] } {
					::EvaServ::SENT:MSG:TO:USER $vuser "<c01> Pseudo \[<c04>$value1<c01>\] <c01> Level \[<c03>Admin<c01>\] <c01> Seen \[<c12>$seen<c01>\]"
					::EvaServ::SENT:MSG:TO:USER $vuser "<c01> Statut \[$status<c01>\] <c01> Protection \[$aprotect<c01>\]"
					::EvaServ::SENT:MSG:TO:USER $vuser "<c01> Mask \[<c02>[getuser $value1 HOSTS]<c01>\]"
				} elseif { [matchattr $value1 m] } {
					::EvaServ::SENT:MSG:TO:USER $vuser "<c01> Pseudo \[<c04>$value1<c01>\] <c01> Level \[<c03>Ircop<c01>\] <c> Seen \[<c12>$seen<c01>\]"
					::EvaServ::SENT:MSG:TO:USER $vuser "<c01> Statut \[$status<c01>\] <c01> Protection \[$aprotect<c01>\]"
					::EvaServ::SENT:MSG:TO:USER $vuser "<c01> Mask \[<c02>[getuser $value1 HOSTS]<c01>\]"
				} elseif { [matchattr $value1 o] } {
					::EvaServ::SENT:MSG:TO:USER $vuser "<c01> Pseudo \[<c04>$value1<c01>\] <c01> Level \[<c03>Géofront<c01>\] <c01> Seen \[<c12>$seen<c01>\]"
					::EvaServ::SENT:MSG:TO:USER $vuser "<c01> Statut \[<c03>$status<c01>\] <c01> Protection \[$aprotect<c01>\]"
					::EvaServ::SENT:MSG:TO:USER $vuser "<c01> Mask \[<c02>[getuser $value1 HOSTS]<c01>\]"
				} elseif { [matchattr $value1 p] } {
					::EvaServ::SENT:MSG:TO:USER $vuser "<c01> Pseudo \[<c04>$value1<c01>\] <c01> Level \[<c03>Helpeur<c01>\] <c01> Seen \[<c12>$seen<c01>\]"
					::EvaServ::SENT:MSG:TO:USER $vuser "<c01> Statut \[$status<c01>\] <c01> Protection \[$aprotect<c01>\]"
					::EvaServ::SENT:MSG:TO:USER $vuser "<c01> Mask \[<c02>[getuser $value1 HOSTS]<c01>\]"
				}
				::EvaServ::SENT:MSG:TO:USER $vuser "<c>"
			} else {
				::EvaServ::SENT:MSG:TO:USER $vuser "Aucun Accès."
			}
		}
		"owner" {
			if { [string index $value1 0] != "#" } {
				::EvaServ::SENT:MSG:TO:USER $vuser "<b>Commande Owner :</b> /msg $config(service_nick) owner #salon pseudo";
				return 0;
			}

			if { $value4 == [string tolower $config(service_nick)] || [info exists users($value4)] || [::EvaServ::protection $value4 $config(protection)] == "ok" } {
				::EvaServ::SENT:MSG:TO:USER $user "Accès Refusé : Pseudo Protégé";
				return 0;
			}
			if { $value4 != "" } {
				if { ![info exists vhost($value4)] } {
					::EvaServ::SENT:MSG:TO:USER $vuser "Pseudo introuvable.";
					return 0
				}
				::EvaServ::FCT:SENT:MODE $value1 "+q" $value3
				if { [::EvaServ::console 1] == "ok" && $value2!=[string tolower $config(salon)] } {
					::EvaServ::SHOW:INFO:TO:CHANLOG "Owner" "$value3 sur $value1 par $user"
				}
			} else {
				::EvaServ::FCT:SENT:MODE $value1 "+q" $user
				if { [::EvaServ::console 1] == "ok" && $value2!=[string tolower $config(salon)] } {
					::EvaServ::SHOW:INFO:TO:CHANLOG "Owner" "$user sur $value1"
				}
			}
		}
		"deowner" {
			if { [string index $value1 0] != "#" } {
				::EvaServ::SENT:MSG:TO:USER $vuser "<b>Commande Deowner :</b> /msg $config(service_nick) deowner #salon pseudo";
				return 0;
			}

			if { $value4 == [string tolower $config(service_nick)] || [info exists users($value4)] || [::EvaServ::protection $value4 $config(protection)] == "ok" } {
				::EvaServ::SENT:MSG:TO:USER $user "Accès Refusé : Pseudo Protégé";
				return 0;
			}

			if { $value4 != "" } {
				if { ![info exists vhost($value4)] } {
					::EvaServ::SENT:MSG:TO:USER $vuser "Pseudo introuvable.";
					return 0;
				}

				::EvaServ::FCT:SENT:MODE $value1 "-q" $value3
				if { [::EvaServ::console 1] == "ok" && $value2!=[string tolower $config(salon)] } {
					::EvaServ::SHOW:INFO:TO:CHANLOG "Deowner" "$value3 sur $value1 par $user"
				}
			} else {
				::EvaServ::FCT:SENT:MODE $value1 "-q" $user
				if { [::EvaServ::console 1] == "ok" && $value2!=[string tolower $config(salon)] } {
					::EvaServ::SHOW:INFO:TO:CHANLOG "Deowner" "$user sur $value1"
				}
			}
		}
		"protect" {
			if { [string index $value1 0] != "#" } {
				::EvaServ::SENT:MSG:TO:USER $vuser "<b>Commande Protect :</b> /msg $config(service_nick) protect #salon pseudo";
				return 0;
			}

			if { $value4 == [string tolower $config(service_nick)] || [info exists users($value4)] || [::EvaServ::protection $value4 $config(protection)] == "ok" } {
				::EvaServ::SENT:MSG:TO:USER $user "Accès Refusé : Pseudo Protégé";
				return 0;
			}

			if { $value4 != "" } {
				if { ![info exists vhost($value4)] } {
					::EvaServ::SENT:MSG:TO:USER $vuser "Pseudo introuvable.";
					return 0;
				}

				::EvaServ::FCT:SENT:MODE $value1 "+a" $value3
				if { [::EvaServ::console 1] == "ok" && $value2!=[string tolower $config(salon)] } {
					::EvaServ::SHOW:INFO:TO:CHANLOG "Protect" "$value3 sur $value1 par $user"
				}
			} else {
				::EvaServ::FCT:SENT:MODE $value1 "+a" $user
				if { [::EvaServ::console 1] == "ok" && $value2!=[string tolower $config(salon)] } {
					::EvaServ::SHOW:INFO:TO:CHANLOG "Protect" "$user sur $value1"
				}
			}
		}
		"deprotect" {
			if { [string index $value1 0] != "#" } {
				::EvaServ::SENT:MSG:TO:USER $vuser "<b>Commande Deprotect :</b> /msg $config(service_nick) deprotect #salon pseudo";
				return 0;
			}

			if { $value4 == [string tolower $config(service_nick)] || [info exists users($value4)] || [::EvaServ::protection $value4 $config(protection)] == "ok" } {
				::EvaServ::SENT:MSG:TO:USER $user "Accès Refusé : Pseudo Protégé";
				return 0;
			}

			if { $value4 != "" } {
				if { ![info exists vhost($value4)] } {
					::EvaServ::SENT:MSG:TO:USER $vuser "Pseudo introuvable.";
					return 0;
				}

				::EvaServ::FCT:SENT:MODE $value1 "-a" $value3
				if { [::EvaServ::console 1] == "ok" && $value2!=[string tolower $config(salon)] } {
					::EvaServ::SHOW:INFO:TO:CHANLOG "Deprotect" "$value3 sur $value1 par $user"
				}
			} else {
				::EvaServ::FCT:SENT:MODE $value1 "-a" $user
				if { [::EvaServ::console 1] == "ok" && $value2!=[string tolower $config(salon)] } {
					::EvaServ::SHOW:INFO:TO:CHANLOG "Deprotect" "$user sur $value1"
				}
			}
		}
		"ownerall" {
			set config(cmd)		"ownerall"
			if { [string index $value1 0] != "#" } {
				::EvaServ::SENT:MSG:TO:USER $vuser "<b>Commande Ownerall :</b> /msg $config(service_nick) ownerall #salon";
				return 0;
			}

			::EvaServ::sent2socket ":$config(link) NAMES $value1"
			if { [::EvaServ::console 1] == "ok" && $value2!=[string tolower $config(salon)] } {
				::EvaServ::SHOW:INFO:TO:CHANLOG "Ownerall" "$value1 par $user"
			}
		}
		"deownerall" {
			set config(cmd)		"deownerall"
			if { [string index $value1 0] != "#" } {
				::EvaServ::SENT:MSG:TO:USER $vuser "<b>Commande Deownerall :</b> /msg $config(service_nick) deownerall #salon";
				return 0;
			}

			::EvaServ::sent2socket ":$config(link) NAMES $value1"
			if { [::EvaServ::console 1] == "ok" && $value2!=[string tolower $config(salon)] } {
				::EvaServ::SHOW:INFO:TO:CHANLOG "Deownerall" "$value1 par $user"
			}
		}
		"protectall" {
			set config(cmd)		"protectall"
			if { [string index $value1 0] != "#" } {
				::EvaServ::SENT:MSG:TO:USER $vuser "<b>Commande Protectall :</b> /msg $config(service_nick) protectall #salon";
				return 0;
			}

			::EvaServ::sent2socket ":$config(link) NAMES $value1"
			if { [::EvaServ::console 1] == "ok" && $value2!=[string tolower $config(salon)] } {
				::EvaServ::SHOW:INFO:TO:CHANLOG "Protectall" "$value1 par $user"
			}
		}
		"deprotectall" {
			set config(cmd)		"deprotectall"
			if { [string index $value1 0] != "#" } {
				::EvaServ::SENT:MSG:TO:USER $vuser "<b>Commande Deprotectall :</b> /msg $config(service_nick) deprotectall #salon";
				return 0;
			}

			::EvaServ::sent2socket ":$config(link) NAMES $value1"
			if { [::EvaServ::console 1] == "ok" && $value2!=[string tolower $config(salon)] } {
				::EvaServ::SHOW:INFO:TO:CHANLOG "Deprotectall" "$value1 par $user"
			}
		}
		"op" {
			if { [string index $value1 0] != "#" } {
				::EvaServ::SENT:MSG:TO:USER $vuser "<b>Commande Op :</b> /msg $config(service_nick) op #salon pseudo";
				return 0
			}
			if { $value4 == [string tolower $config(service_nick)] || [info exists users($value4)] || [::EvaServ::protection $value4 $config(protection)] == "ok" } {
				::EvaServ::SENT:MSG:TO:USER $user "Accès Refusé : Pseudo Protégé";
				return 0
			}
			if { $value4 != "" } {
				if { ![info exists vhost($value4)] } {
					::EvaServ::SENT:MSG:TO:USER $vuser "Pseudo introuvable.";
					return 0;
				}
				::EvaServ::FCT:SENT:MODE $value1 "+o" $value3
				if { [::EvaServ::console 1] == "ok" && $value2!=[string tolower $config(salon)] } {
					::EvaServ::SHOW:INFO:TO:CHANLOG "Op" "$value3 a été opé par $user sur $value1"
				}
			} else {
				::EvaServ::FCT:SENT:MODE $value1 "+o" $user
				if { [::EvaServ::console 1] == "ok" && $value2!=[string tolower $config(salon)] } {
					::EvaServ::SHOW:INFO:TO:CHANLOG "Op" "$user a été opé sur $value1"
				}
			}
		}
		"deop" {
			if { [string index $value1 0] != "#" } {
				::EvaServ::SENT:MSG:TO:USER $vuser "<b>Commande Deop :</b> /msg $config(service_nick) deop #salon pseudo";
				return 0;
			}

			if { $value4 == [string tolower $config(service_nick)] || [info exists users($value4)] || [::EvaServ::protection $value4 $config(protection)] == "ok" } {
				::EvaServ::SENT:MSG:TO:USER $user "Accès Refusé : Pseudo Protégé";
				return 0;
			}

			if { $value4 != "" } {
				if { ![info exists vhost($value4)] } {
					::EvaServ::SENT:MSG:TO:USER $vuser "Pseudo introuvable.";
					return 0;
				}

				::EvaServ::FCT:SENT:MODE $value1 "-o" $value3
				if { [::EvaServ::console 1] == "ok" && $value2!=[string tolower $config(salon)] } {
					::EvaServ::SHOW:INFO:TO:CHANLOG "Deop" "$value3 a été déopé par $user sur $value1"
				}
			} else {
				::EvaServ::FCT:SENT:MODE $value1 "-o" $user
				if { [::EvaServ::console 1] == "ok" && $value2!=[string tolower $config(salon)] } {
					::EvaServ::SHOW:INFO:TO:CHANLOG "Deop" "$user a été déopé sur $value1"
				}
			}
		}
		"halfop" {
			if { [string index $value1 0] != "#" } {
				::EvaServ::SENT:MSG:TO:USER $vuser "<b>Commande Halfop :</b> /msg $config(service_nick) halfop #salon pseudo";
				return 0;
			}

			if { $value4 == [string tolower $config(service_nick)] || [info exists users($value4)] || [::EvaServ::protection $value4 $config(protection)] == "ok" } {
				::EvaServ::SENT:MSG:TO:USER $user "Accès Refusé : Pseudo Protégé";
				return 0;
			}

			if { $value4 != "" } {
				if { ![info exists vhost($value4)] } {
					::EvaServ::SENT:MSG:TO:USER $vuser "Pseudo introuvable.";
					return 0;
				}

				::EvaServ::FCT:SENT:MODE $value1 "+h" $value3
				if { [::EvaServ::console 1] == "ok" && $value2!=[string tolower $config(salon)] } {
					::EvaServ::SHOW:INFO:TO:CHANLOG "Halfop" "$value3 a été halfopé par $user sur $value1"
				}
			} else {
				::EvaServ::FCT:SENT:MODE $value1 "+h" $user
				if { [::EvaServ::console 1] == "ok" && $value2!=[string tolower $config(salon)] } {
					::EvaServ::SHOW:INFO:TO:CHANLOG "Halfop" "$user a été halfopé sur $value1"
				}
			}
		}
		"dehalfop" {
			if { [string index $value1 0] != "#" } {
				::EvaServ::SENT:MSG:TO:USER $vuser "<b>Commande Dehalfop :</b> /msg $config(service_nick) dehalfop #salon pseudo";
				return 0;
			}

			if { $value4 == [string tolower $config(service_nick)] || [info exists users($value4)] || [::EvaServ::protection $value4 $config(protection)] == "ok" } {
				::EvaServ::SENT:MSG:TO:USER $user "Accès Refusé : Pseudo Protégé";
				return 0;
			}

			if { $value4 != "" } {
				if { ![info exists vhost($value4)] } {
					::EvaServ::SENT:MSG:TO:USER $vuser "Pseudo introuvable.";
					return 0;
				}

				::EvaServ::FCT:SENT:MODE $value1 "-h" $value3
				if { [::EvaServ::console 1] == "ok" && $value2!=[string tolower $config(salon)] } {
					::EvaServ::SHOW:INFO:TO:CHANLOG "Dehalfop" "$value3 a été déhalfopé par $user sur $value1"
				}
			} else {
				::EvaServ::FCT:SENT:MODE $value1 "-h" $user
				if { [::EvaServ::console 1] == "ok" && $value2!=[string tolower $config(salon)] } {
					::EvaServ::SHOW:INFO:TO:CHANLOG "Dehalfop" "$user a été déhalfopé sur $value1"
				}
			}
		}
		"voice" {
			if { [string index $value1 0] != "#" } {
				::EvaServ::SENT:MSG:TO:USER $vuser "<b>Commande Voice :</b> /msg $config(service_nick) voice #salon pseudo";
				return 0;
			}

			if { $value4 == [string tolower $config(service_nick)] || [info exists users($value4)] || [::EvaServ::protection $value4 $config(protection)] == "ok" } {
				::EvaServ::SENT:MSG:TO:USER $user "Accès Refusé : Pseudo Protégé";
				return 0;
			}

			if { $value4 != "" } {
				if { ![info exists vhost($value4)] } {
					::EvaServ::SENT:MSG:TO:USER $vuser "Pseudo introuvable.";
					return 0;
				}

				::EvaServ::FCT:SENT:MODE $value1 "+v" $value3
				if { [::EvaServ::console 1] == "ok" && $value2!=[string tolower $config(salon)] } {
					::EvaServ::SHOW:INFO:TO:CHANLOG "Voice" "$value3 a été voicé par $user sur $value1"
				}
			} else {
				::EvaServ::FCT:SENT:MODE $value1 "+v" $user
				if { [::EvaServ::console 1] == "ok" && $value2!=[string tolower $config(salon)] } {
					::EvaServ::SHOW:INFO:TO:CHANLOG "Voice" "$user a été voicé sur $value1"
				}
			}
		}
		"devoice" {
			if { [string index $value1 0] != "#" } {
				::EvaServ::SENT:MSG:TO:USER $vuser "<b>Commande Devoice :</b> /msg $config(service_nick) devoice #salon pseudo";
				return 0;
			}

			if { $value4 == [string tolower $config(service_nick)] || [info exists users($value4)] || [::EvaServ::protection $value4 $config(protection)] == "ok" } {
				::EvaServ::SENT:MSG:TO:USER $user "Accès Refusé : Pseudo Protégé";
				return 0;
			}

			if { $value4 != "" } {
				if { ![info exists vhost($value4)] } {
					::EvaServ::SENT:MSG:TO:USER $vuser "Pseudo introuvable.";
					return 0;
				}

				::EvaServ::FCT:SENT:MODE $value1 "-v" $value3
				if { [::EvaServ::console 1] == "ok" && $value2!=[string tolower $config(salon)] } {
					::EvaServ::SHOW:INFO:TO:CHANLOG "Devoice" "$value3 a été dévoicé par $user sur $value1"
				}
			} else {
				::EvaServ::FCT:SENT:MODE $value1 "-v" $user
				if { [::EvaServ::console 1] == "ok" && $value2!=[string tolower $config(salon)] } {
					::EvaServ::SHOW:INFO:TO:CHANLOG "Devoice" "$user a été dévoicé sur $value1"
				}
			}
		}
		"opall" {
			set config(cmd)		"opall"

			if { [string index $value1 0] != "#" } {
				::EvaServ::SENT:MSG:TO:USER $vuser "<b>Commande Opall :</b> /msg $config(service_nick) opall #salon";
				return 0;
			}
			::EvaServ::sent2socket ":$config(link) NAMES $value1"

			if { [::EvaServ::console 1] == "ok" && $value2!=[string tolower $config(salon)] } {
				::EvaServ::SHOW:INFO:TO:CHANLOG "Opall" "$value1 par $user"
			}
		}
		"deopall" {
			set config(cmd)		"deopall"
			if { [string index $value1 0] != "#" } {
				::EvaServ::SENT:MSG:TO:USER $vuser "<b>Commande Deopall :</b> /msg $config(service_nick) deopall #salon";
				return 0;
			}

			::EvaServ::sent2socket ":$config(link) NAMES $value1"
			if { [::EvaServ::console 1] == "ok" && $value2!=[string tolower $config(salon)] } {
				::EvaServ::SHOW:INFO:TO:CHANLOG "Deopall" "$value1 par $user"
			}
		}
		"halfopall" {
			set config(cmd)		"halfopall"
			if { [string index $value1 0] != "#" } {
				::EvaServ::SENT:MSG:TO:USER $vuser "<b>Commande Halfopall :</b> /msg $config(service_nick) halfopall #salon";
				return 0;
			}

			::EvaServ::sent2socket ":$config(link) NAMES $value1"
			if { [::EvaServ::console 1] == "ok" && $value2!=[string tolower $config(salon)] } {
				::EvaServ::SHOW:INFO:TO:CHANLOG "Halfopall" "$value1 par $user"
			}
		}
		"dehalfopall" {
			set config(cmd)		"dehalfopall"
			if { [string index $value1 0] != "#" } {
				::EvaServ::SENT:MSG:TO:USER $vuser "<b>Commande Dehalfopall :</b> /msg $config(service_nick) dehalfopall #salon";
				return 0;
			}

			::EvaServ::sent2socket ":$config(link) NAMES $value1"
			if { [::EvaServ::console 1] == "ok" && $value2!=[string tolower $config(salon)] } {
				::EvaServ::SHOW:INFO:TO:CHANLOG "Dehalfopall" "$value1 par $user"
			}
		}
		"voiceall" {
			set config(cmd)		"voiceall"
			if { [string index $value1 0] != "#" } {
				::EvaServ::SENT:MSG:TO:USER $vuser "<b>Commande Voiceall :</b> /msg $config(service_nick) voiceall #salon";
				return 0;
			}

			::EvaServ::sent2socket ":$config(link) NAMES $value1"
			if { [::EvaServ::console 1] == "ok" && $value2!=[string tolower $config(salon)] } {
				::EvaServ::SHOW:INFO:TO:CHANLOG "Voiceall" "$value1 par $user"
			}
		}
		"devoiceall" {
			set config(cmd)		"devoiceall"
			if { [string index $value1 0] != "#" } {
				::EvaServ::SENT:MSG:TO:USER $vuser "<b>Commande Devoiceall :</b> /msg $config(service_nick) devoiceall #salon";
				return 0;
			}

			::EvaServ::sent2socket ":$config(link) NAMES $value1"
			if { [::EvaServ::console 1] == "ok" && $value2!=[string tolower $config(salon)] } {
				::EvaServ::SHOW:INFO:TO:CHANLOG "Devoiceall" "$value1 par $user"
			}
		}
		"kick" {
			if { [string index $value1 0] != "#" || $value4 == "" } {
				::EvaServ::SENT:MSG:TO:USER $vuser "<b>Commande Kick :</b> /msg $config(service_nick) kick #salon pseudo raison";
				return 0;
			}

			if { $value4 == [string tolower $config(service_nick)] || [info exists users($value4)] || [::EvaServ::protection $value4 $config(protection)] == "ok" } {
				::EvaServ::SENT:MSG:TO:USER $user "Accès Refusé : Pseudo Protégé";
				return 0;
			}

			if { $value5 == "" } { set value5		"Kicked" }
			::EvaServ::sent2socket ":$config(server_id) KICK $value2 $value4 $value5 [::EvaServ::rnick $user]"
			if { [::EvaServ::console 1] == "ok" && $value2!=[string tolower $config(salon)] } {
				::EvaServ::SHOW:INFO:TO:CHANLOG "Kick" "$value3 a été kické par $user sur $value1 - Raison : $value5"
			}
		}
		"kickall" {
			set config(cmd)		"kickall";
			set config(rep)		$user
			if { [string index $value1 0] != "#" } {
				::EvaServ::SENT:MSG:TO:USER $vuser "<b>Commande Kickall :</b> /msg $config(service_nick) kickall #salon";
				return 0;
			}

			::EvaServ::sent2socket ":$config(link) NAMES $value1"
			if { [::EvaServ::console 1] == "ok" && $value2!=[string tolower $config(salon)] } {
				::EvaServ::SHOW:INFO:TO:CHANLOG "Kickall" "$value1 par $user"
			}
		}
		"ban" {
			if { [string index $value1 0] != "#" || $value3 == "" } {
				::EvaServ::SENT:MSG:TO:USER $vuser "<b>Commande Ban :</b> /msg $config(service_nick) ban #salon mask";
				return 0;
			}

			::EvaServ::FCT:SENT:MODE $value1 "+b" $value3
			if { [::EvaServ::console 1] == "ok" && $value2!=[string tolower $config(salon)] } {
				::EvaServ::SHOW:INFO:TO:CHANLOG "Ban" "$value3 a été banni par $user sur $value1"
			}
		}
		"nickban" {
			if { [string index $value1 0] != "#" || $value3 == "" } {
				::EvaServ::SENT:MSG:TO:USER $vuser "<b>Commande Nickban :</b> /msg $config(service_nick) nickban #salon pseudo raison";
				return 0;
			}

			if { $value4 == [string tolower $config(service_nick)] || [info exists users($value4)] || [::EvaServ::protection $value4 $config(protection)] == "ok" } {
				::EvaServ::SENT:MSG:TO:USER $user "Accès Refusé : Pseudo Protégé";
				return 0;
			}

			if { ![info exists vhost($value4)] } {
				::EvaServ::SENT:MSG:TO:USER $vuser "Pseudo introuvable.";
				return 0;
			}

			if { $value5 == "" } { set value5		"Nick Banned" }
			::EvaServ::FCT:SENT:MODE $value1 "+b" "$value4*!*@*"
			::EvaServ::sent2socket ":$config(server_id) KICK $value1 $value3 $value5 [::EvaServ::rnick $user]"
			if { [::EvaServ::console 1] == "ok" && $value2!=[string tolower $config(salon)] } {
				::EvaServ::SHOW:INFO:TO:CHANLOG "Nickban" "$value3 a été banni par $user sur $value1 - Raison : $value5"
			}
		}
		"kickban" {
			if { [string index $value1 0] != "#" || $value3 == "" } {
				::EvaServ::SENT:MSG:TO:USER $vuser "<b>Commande Kickban :</b> /msg $config(service_nick) kickban #salon pseudo raison";
				return 0;
			}

			if { $value4 == [string tolower $config(service_nick)] || [info exists users($value4)] || [::EvaServ::protection $value4 $config(protection)] == "ok" } {
				::EvaServ::SENT:MSG:TO:USER $user "Accès Refusé : Pseudo Protégé";
				return 0;
			}

			if { ![info exists vhost($value4)] } {
				::EvaServ::SENT:MSG:TO:USER $vuser "Pseudo introuvable.";
				return 0;
			}

			if { $value5 == "" } { set value5		"Kick Banned" }
			::EvaServ::FCT:SENT:MODE $value1 "+b" "*!*@$vhost($value4)"
			::EvaServ::sent2socket ":$config(server_id) KICK $value1 $value3 $value5 [::EvaServ::rnick $user]"
			if { [::EvaServ::console 1] == "ok" && $value2!=[string tolower $config(salon)] } {
				::EvaServ::SHOW:INFO:TO:CHANLOG "Kickban" "$value3 a été banni par $user sur $value1 - Raison : $value5"
			}
		}
		"unban" {
			if { [string index $value1 0] != "#" || $value3 == "" } {
				::EvaServ::SENT:MSG:TO:USER $vuser "<b>Commande Unban :</b> /msg $config(service_nick) unban #salon mask";
				return 0;
			}

			::EvaServ::FCT:SENT:MODE $value1 "-b" $value3
			if { [::EvaServ::console 1] == "ok" && $value2!=[string tolower $config(salon)] } {
				::EvaServ::SHOW:INFO:TO:CHANLOG "Unban" "$value3 a été débanni par $user sur $value1"
			}
		}
		"clearbans" {
			if { [string index $value1 0] != "#" } {
				::EvaServ::SENT:MSG:TO:USER $vuser "<b>Commande Clearbans :</b> /msg $config(service_nick) clearbans #salon";
				return 0;
			}

			::EvaServ::sent2socket ":$config(server_id) SVSMODE $value1 -b"
			if { [::EvaServ::console 1] == "ok" && $value2!=[string tolower $config(salon)] } {
				::EvaServ::SHOW:INFO:TO:CHANLOG "Clearbans" "$value1 par $user"
			}
		}
		"topic" {
			if { [string index $value1 0] != "#" || $value6 == "" } {
				::EvaServ::SENT:MSG:TO:USER $vuser "<b>Commande Topic :</b> /msg $config(service_nick) topic #salon topic";
				return 0;
			}

			::EvaServ::FCT:SET:TOPIC $value1 $value6
			if { [::EvaServ::console 1] == "ok" && $value2!=[string tolower $config(salon)] } {
				::EvaServ::SHOW:INFO:TO:CHANLOG "Topic" "$user change le topic sur $value1 : $value6"
			}
		}
		"mode" {
			if { [string index $value1 0] != "#" || $value3 == "" } {
				::EvaServ::SENT:MSG:TO:USER $vuser "<b>Commande Mode :</b> /msg $config(service_nick) mode #salon +/-mode";
				return 0;
			}

			if { $value2 == [string tolower $config(salon)] } {
				::EvaServ::SENT:MSG:TO:USER $user "Accès Refusé";
				return 0;
			}

			if { ![regexp ^\[\+\-\]+\[a-zA-Z\]+$ $value3] } {
				::EvaServ::SENT:MSG:TO:USER $user "Chanmode Incorrect";
				return 0;
			}

			if { [string match *q* $value3] || [string match *a* $value3] ||[string match *o* $value3] ||[string match *h* $value3] ||[string match *v* $value3] } {
				::EvaServ::SENT:MSG:TO:USER $user "Chanmode Refusé";
				return 0;
			}

			::EvaServ::FCT:SENT:MODE $value1 $value6
			if { [::EvaServ::console 1] == "ok" && $value2!=[string tolower $config(salon)] } {
				::EvaServ::SHOW:INFO:TO:CHANLOG "Mode" "$user applique le mode $value6 sur $value1"
			}
		}
		"clearmodes" {
			if { [string index $value1 0] != "#" } {
				::EvaServ::SENT:MSG:TO:USER $vuser "<b>Commande Clearmodes :</b> /msg $config(service_nick) clearmodes #salon";
				return 0;
			}

			if { $value2 == [string tolower $config(salon)] } {
				::EvaServ::SENT:MSG:TO:USER $user "Accès Refusé";
				return 0;
			}

			::EvaServ::FCT:SENT:MODE $value1
			if { [::EvaServ::console 1] == "ok" && $value2!=[string tolower $config(salon)] } {
				::EvaServ::SHOW:INFO:TO:CHANLOG "Clearmodes" "$user sur $value1"
			}
		}
		"clearallmodes" {
			if { [string index $value1 0] != "#" } {
				::EvaServ::SENT:MSG:TO:USER $vuser "<b>Commande Clearallmodes :</b> /msg $config(service_nick) clearallmodes #salon";
				return 0;
			}

			if { $value2 == [string tolower $config(salon)] } {
				::EvaServ::SENT:MSG:TO:USER $user "Accès Refusé";
				return 0;
			}

			::EvaServ::sent2socket ":$config(server_id) SVSMODE $value1 -beIqaohv"
			::EvaServ::FCT:SENT:MODE $value1
			::EvaServ::sent2socket ":$config(server_id) SVSMODE $value1 -b"
			if { [::EvaServ::console 1] == "ok" } {
				::EvaServ::SHOW:INFO:TO:CHANLOG "Clearallmodes" "$user sur $value1"
			}
		}
		"kill" {
			if { $value1 == "" } {
				::EvaServ::SENT:MSG:TO:USER $vuser "<b>Commande Kill :</b> /msg $config(service_nick) kill pseudo raison";
				return 0;
			}

			if { $value2 == [string tolower $config(service_nick)] || [info exists users($value2)] || [::EvaServ::protection $value2 $config(protection)] == "ok" } {
				::EvaServ::SENT:MSG:TO:USER $user "Accès Refusé : Pseudo Protégé";
				return 0;
			}

			if { ![info exists vhost($value2)] } {
				::EvaServ::SENT:MSG:TO:USER $vuser "Pseudo introuvable.";
				return 0;
			}

			if { $value6 == "" } { set value6		"Killed" }
			::EvaServ::sent2socket ":$config(server_id) KILL $value1 $value6 [::EvaServ::rnick $user]";
			::EvaServ::refresh $value2
			if { [::EvaServ::console 1] == "ok" } {
				::EvaServ::SHOW:INFO:TO:CHANLOG "Kill" "$value1 a été killé par $user : $value6"
			}
		}
		"chankill" {
			set config(cmd)		"chankill";
			set config(rep)		$user
			if { [string index $value1 0] != "#" } {
				::EvaServ::SENT:MSG:TO:USER $vuser "<b>Commande Chankill :</b> /msg $config(service_nick) chankill #salon";
				return 0;
			}

			if { $value2 == [string tolower $config(salon)] } {
				::EvaServ::SENT:MSG:TO:USER $user "Accès Refusé";
				return 0;
			}

			::EvaServ::sent2socket ":$config(link) NAMES $value1"
			if { [::EvaServ::console 1] == "ok" } {
				::EvaServ::SHOW:INFO:TO:CHANLOG "Chankill" "$value1 par $user"
			}
		}
		"svsjoin" {
			if { [string index $value1 0] != "#" || $value3 == "" } {
				::EvaServ::SENT:MSG:TO:USER $vuser "<b>Commande Svsjoin :</b> /msg $config(service_nick) svsjoin #salon pseudo";
				return 0;
			}

			if { ![info exists vhost($value4)] } {
				::EvaServ::SENT:MSG:TO:USER $vuser "Pseudo introuvable.";
				return 0;
			}

			if { $value4 == [string tolower $config(service_nick)] || [info exists users($value4)] || [::EvaServ::protection $value4 $config(protection)] == "ok" } {
				::EvaServ::SENT:MSG:TO:USER $user "Accès Refusé : Pseudo Protégé";
				return 0;
			}

			::EvaServ::sent2socket ":$config(server_id) SVSJOIN [::EvaServ::UID:CONVERT $value3] $value1"
			if { [::EvaServ::console 1] == "ok" } {
				::EvaServ::SHOW:INFO:TO:CHANLOG "Svsjoin" "$value3 entre sur $value1 par $user"
			}
		}
		"svspart" {
			if { [string index $value1 0] != "#" || $value3 == "" } {
				::EvaServ::SENT:MSG:TO:USER $vuser "<b>Commande Svspart :</b> /msg $config(service_nick) svspart #salon pseudo";
				return 0;
			}

			if { ![info exists vhost($value4)] } {
				::EvaServ::SENT:MSG:TO:USER $vuser "Pseudo introuvable.";
				return 0;
			}

			if { $value4 == [string tolower $config(service_nick)] || [info exists users($value4)] || [::EvaServ::protection $value4 $config(protection)] == "ok" } {
				::EvaServ::SENT:MSG:TO:USER $user "Accès Refusé : Pseudo Protégé";
				return 0;
			}

			::EvaServ::sent2socket ":$config(server_id) SVSPART $value3 $value1"
			if { [::EvaServ::console 1] == "ok" } {
				::EvaServ::SHOW:INFO:TO:CHANLOG "Svspart" "$value3 part de $value1 par $user"
			}
		}
		"svsnick" {
			if { $value1 == "" || $value3 == "" } {
				::EvaServ::SENT:MSG:TO:USER $vuser "<b>Commande Svsnick :</b> /msg $config(service_nick) svsnick ancien-pseudo nouveau-pseudo";
				return 0;
			}

			if { $value2==$value4 } {
				::EvaServ::SENT:MSG:TO:USER $vuser "Pseudo Identique.";
				return 0;
			}

			if { $value2 == [string tolower $config(service_nick)] || $value4 == [string tolower $config(service_nick)] || [info exists users($value2)] || [info exists users($value4)] || [::EvaServ::protection $value2 $config(protection)] == "ok" || [::EvaServ::protection $value4 $config(protection)] == "ok" } {
				::EvaServ::SENT:MSG:TO:USER $user "Accès Refusé : Pseudo Protégé";
				return 0;
			}

			if { ![info exists vhost($value2)] } {
				::EvaServ::SENT:MSG:TO:USER $vuser "Pseudo introuvable ($value1).";
				return 0;
			}

			if { [info exists vhost($value4)] } {
				::EvaServ::SENT:MSG:TO:USER $vuser "Pseudo existant ($value3).";
				return 0;
			}

			::EvaServ::sent2socket ":$config(SID) SVSNICK [::EvaServ::UID:CONVERT $value1] $value3 [unixtime]"
			if { [info exists vhost($value1)] && $value1!=$value3 } {
				set vhost($value3)		$vhost($value1);
				unset vhost($value1)
			}
			if { [::EvaServ::console 1] == "ok" } {
				::EvaServ::SHOW:INFO:TO:CHANLOG "Svsnick" "$user change le pseudo de $value1 en $value3"
			}
		}
		"say" {
			if { [string index $value1 0] != "#" || $value6 == "" } {
				::EvaServ::SENT:MSG:TO:USER $vuser "<b>Commande Say :</b> /msg $config(service_nick) say #salon message";
				return 0;
			}

			::EvaServ::SENT:MSG:TO:USER $value1 "$value6"
			if { [::EvaServ::console 1] == "ok" && $value2!=[string tolower $config(salon)] } {
				::EvaServ::SHOW:INFO:TO:CHANLOG "Say" "$user sur $value1 : $value6"
			}
		}
		"invite" {
			if { [string index $value1 0] != "#" || $value3 == "" } {
				::EvaServ::SENT:MSG:TO:USER $vuser "<b>Commande Invite :</b> /msg $config(service_nick) invite #salon pseudo";
				return 0;
			}

			if { ![info exists vhost($value4)] } {
				::EvaServ::SENT:MSG:TO:USER $vuser "Pseudo introuvable.";
				return 0;
			}

			::EvaServ::sent2socket ":$config(server_id) INVITE $value3 $value1"
			if { [::EvaServ::console 1] == "ok" } {
				::EvaServ::SHOW:INFO:TO:CHANLOG "Invite" "$user invite $value3 sur $value1"
			}
		}
		"inviteme" {
			::EvaServ::sent2socket ":$config(server_id) INVITE $user $config(salon)"
			if { [::EvaServ::console 1] == "ok" } {
				::EvaServ::SHOW:INFO:TO:CHANLOG "Inviteme" "$user"
			}
		}
		"wallops" {
			if { $value7 == "" } {
				::EvaServ::SENT:MSG:TO:USER $vuser "<b>Commande Wallops :</b> /msg $config(service_nick) wallops message";
				return 0;
			}

			::EvaServ::sent2socket ":$config(server_id) WALLOPS $value7 ($user)"
			if { [::EvaServ::console 1] == "ok" } {
				::EvaServ::SHOW:INFO:TO:CHANLOG "Wallops" "$user : $value7"
			}
		}
		"globops" {
			if { $value7 == "" } {
				::EvaServ::SENT:MSG:TO:USER $vuser "<b>Commande Globops :</b> /msg $config(service_nick) globops message";
				return 0;
			}

			::EvaServ::sent2socket ":$config(server_id) GLOBOPS $value7 ($user)"
			if { [::EvaServ::console 1] == "ok" } {
				::EvaServ::SHOW:INFO:TO:CHANLOG "Globops" "$user : $value7"
			}
		}
		"notice" {
			if { $value7 == "" } {
				::EvaServ::SENT:MSG:TO:USER $vuser "<b>Commande Notice :</b> /msg $config(service_nick) notice message";
				return 0;
			}

			::EvaServ::SENT:MSG:TO:USER "$*.*" "\[<b>Notice Globale</b>\] $value7"
			if { [::EvaServ::console 1] == "ok" } {
				::EvaServ::SHOW:INFO:TO:CHANLOG "Notice" "$user"
			}
		}
		"whois" {
			set config(rep)		$vuser
			if { $value1 == "" } {
				::EvaServ::SENT:MSG:TO:USER $vuser "<b>Commande Whois :</b> /msg $config(service_nick) whois pseudo";
				return 0;
			}

			if { ![info exists vhost($value2)] } {
				::EvaServ::SENT:MSG:TO:USER $vuser "Pseudo introuvable.";
				return 0;
			}

			::EvaServ::sent2socket ":$config(server_id) WHOIS $value1"
			if { [::EvaServ::console 1] == "ok" } {
				::EvaServ::SHOW:INFO:TO:CHANLOG "Whois" "$user"
			}
		}
		"changline" {
			set config(cmd)		"changline";
			set config(rep)		$user
			if { [string index $value1 0] != "#" } {
				::EvaServ::SENT:MSG:TO:USER $vuser "<b>Commande Changline :</b> /msg $config(service_nick) changline #salon";
				return 0;
			}

			if { $value2 == [string tolower $config(salon)] } {
				::EvaServ::SENT:MSG:TO:USER $user "Accès Refusé";
				return 0;
			}

			::EvaServ::sent2socket ":$config(link) NAMES $value1"
			if { [::EvaServ::console 1] == "ok" } {
				::EvaServ::SHOW:INFO:TO:CHANLOG "Changline" "$value1 par $user"
			}
		}
		"gline" {
			if { $value1 == "" } {
				::EvaServ::SENT:MSG:TO:USER $vuser "<b>Commande Gline :</b> /msg $config(service_nick) gline <pseudo ou ip> raison";
				return 0;
			}

			if { $value2 == [string tolower $config(service_nick)] || [info exists users($value2)] || [::EvaServ::protection $value2 $config(protection)] == "ok" } {
				::EvaServ::SENT:MSG:TO:USER $user "Accès Refusé : Pseudo Protégé";
				return 0;
			}

			if { $value6 == "" } { set value6		"Glined" }
			if { [info exists vhost($value2)] } {
				::EvaServ::sent2socket ":$config(link) TKL + G * $vhost($value2) $config(service_nick) [expr [unixtime] + $config(duree)] [unixtime] : $value6 [::EvaServ::rnick $user] (Expire le [::EvaServ::duree [expr [unixtime] + $config(duree)]])"
			} elseif { [string match *.* $value1] } {
				::EvaServ::sent2socket ":$config(link) TKL + G * $value1 $config(service_nick) [expr [unixtime] + $config(duree)] [unixtime] : $value6 [::EvaServ::rnick $user] (Expire le [::EvaServ::duree [expr [unixtime] + $config(duree)]])"
			} else {
				::EvaServ::SENT:MSG:TO:USER $vuser "Pseudo introuvable.";
				return 0;
			}
			if { [::EvaServ::console 1] == "ok" } {
				::EvaServ::SHOW:INFO:TO:CHANLOG "Gline" "$value1 par $user - Raison : $value6"
			}
		}
		"ungline" {
			if { $value1 == "" ||![string match *@* $value1] } {
				::EvaServ::SENT:MSG:TO:USER $vuser "<b>Commande Ungline :</b> /msg $config(service_nick) ungline ident@host";
				return 0;
			}

			::EvaServ::sent2socket ":$config(link) TKL - G [lindex [split $value1 @] 0] [lindex [split $value1 @] 1] $config(service_nick)"
			if { [::EvaServ::console 1] == "ok" } {
				::EvaServ::SHOW:INFO:TO:CHANLOG "Ungline" "$value1 par $user"
			}
		}
		"shun" {
			if { $value1 == "" } {
				::EvaServ::SENT:MSG:TO:USER $vuser "<b>Commande Shun :</b> /msg $config(service_nick) shun <pseudo ou ip> raison";
				return 0;
			}

			if { $value2 == [string tolower $config(service_nick)] || [info exists users($value2)] || [::EvaServ::protection $value2 $config(protection)] == "ok" } {
				::EvaServ::SENT:MSG:TO:USER $user "Accès Refusé : Pseudo Protégé";
				return 0;
			}

			if { $value6 == "" } { set value6		"Shun" }
			if { [info exists vhost($value2)] } {
				::EvaServ::sent2socket ":$config(link) TKL + s * $vhost($value2) $config(service_nick) [expr [unixtime] + $config(duree)] [unixtime] : $value6 [::EvaServ::rnick $user] (Expire le [::EvaServ::duree [expr [unixtime] + $config(duree)]])"
			} elseif { [string match *.* $value1] } {
				::EvaServ::sent2socket ":$config(link) TKL + s * $value1 $config(service_nick) [expr [unixtime] + $config(duree)] [unixtime] : $value6 [::EvaServ::rnick $user] (Expire le [::EvaServ::duree [expr [unixtime] + $config(duree)]])"
			} else {
				::EvaServ::SENT:MSG:TO:USER $vuser "Pseudo introuvable.";
				return 0;
			}
			if { [::EvaServ::console 1] == "ok" } {
				::EvaServ::SHOW:INFO:TO:CHANLOG "Shun" "$value1 par $user - Raison : $value6"
			}
		}
		"unshun" {
			if { $value1 == "" ||![string match *@* $value1] } {
				::EvaServ::SENT:MSG:TO:USER $vuser "<b>Commande Unshun :</b> /msg $config(service_nick) unshun ident@host";
				return 0;
			}

			::EvaServ::sent2socket ":$config(link) TKL - s [lindex [split $value1 @] 0] [lindex [split $value1 @] 1] $config(service_nick)"
			if { [::EvaServ::console 1] == "ok" } {
				::EvaServ::SHOW:INFO:TO:CHANLOG "Unshun" "$value1 par $user"
			}
		}
		"kline" {
			if { $value1 == "" } {
				::EvaServ::SENT:MSG:TO:USER $vuser "<b>Commande Kline :</b> /msg $config(service_nick) kline <pseudo ou ip> raison";
				return 0;
			}

			if { $value2 == [string tolower $config(service_nick)] || [info exists users($value2)] || [::EvaServ::protection $value2 $config(protection)] == "ok" } {
				::EvaServ::SENT:MSG:TO:USER $user "Accès Refusé : Pseudo Protégé";
				return 0;
			}

			if { $value6 == "" } { set value6		"Klined" }
			if { [info exists vhost($value2)] } {
				::EvaServ::sent2socket ":$config(link) TKL + k * $vhost($value2) $config(service_nick) [expr [unixtime] + $config(duree)] [unixtime] : $value6 [::EvaServ::rnick $user] (Expire le [::EvaServ::duree [expr [unixtime] + $config(duree)]])"
			} elseif { [string match *.* $value1] } {
				::EvaServ::sent2socket ":$config(link) TKL + k * $value1 $config(service_nick) [expr [unixtime] + $config(duree)] [unixtime] : $value6 [::EvaServ::rnick $user] (Expire le [::EvaServ::duree [expr [unixtime] + $config(duree)]])"
			} else {
				::EvaServ::SENT:MSG:TO:USER $vuser "Pseudo introuvable.";
				return 0;
			}
			if { [::EvaServ::console 1] == "ok" } {
				::EvaServ::SHOW:INFO:TO:CHANLOG "Kline" "$value1 par $user - Raison : $value6"
			}
		}
		"unkline" {
			if { $value1 == "" || ![string match *@* $value1] } {
				::EvaServ::SENT:MSG:TO:USER $vuser "<b>Commande Unkline :</b> /msg $config(service_nick) unkline ident@host";
				return 0;
			}

			::EvaServ::sent2socket ":$config(link) TKL - k [lindex [split $value1 @] 0] [lindex [split $value1 @] 1] $config(service_nick)"
			if { [::EvaServ::console 1] == "ok" } {
				::EvaServ::SHOW:INFO:TO:CHANLOG "Unkline" "$value1 par $user"
			}
		}
		"glinelist" {
			set config(cmd)		"gline";
			set config(rep)		$vuser
			::EvaServ::sent2socket ":$config(server_id) STATS G"
			if { [::EvaServ::console 1] == "ok" } {
				::EvaServ::SHOW:INFO:TO:CHANLOG "Glinelist" "$user"
			}
		}
		"shunlist" {
			set config(cmd)		"shun";
			set config(rep)		$vuser
			::EvaServ::sent2socket ":$config(server_id) STATS s"
			if { [::EvaServ::console 1] == "ok" } {
				::EvaServ::SHOW:INFO:TO:CHANLOG "Shunlist" "$user"
			}
		}
		"klinelist" {
			set config(cmd)		"kline";
			set config(rep)		$vuser
			::EvaServ::sent2socket ":$config(server_id) STATS K"
			if { [::EvaServ::console 1] == "ok" } {
				::EvaServ::SHOW:INFO:TO:CHANLOG "Klinelist" "$user"
			}
		}
		"cleargline" {
			set config(cmd)		"cleargline"
			::EvaServ::sent2socket ":$config(server_id) STATS G"
			::EvaServ::SENT:MSG:TO:USER $vuser "Liste des glines vidée."
			if { [::EvaServ::console 1] == "ok" } {
				::EvaServ::SHOW:INFO:TO:CHANLOG "Cleargline" "$user"
			}
		}
		"clearkline" {
			set config(cmd)		"clearkline"
			::EvaServ::sent2socket ":$config(server_id) STATS K"
			::EvaServ::SENT:MSG:TO:USER $vuser "Liste des klines vidée."
			if { [::EvaServ::console 1] == "ok" } {
				::EvaServ::SHOW:INFO:TO:CHANLOG "Clearkline" "$user"
			}
		}
		"clientlist" {
			catch { open "[::EvaServ::Script:Get:Directory]db/client.db" r } liste
			::EvaServ::SENT:MSG:TO:USER $vuser "<b><c1,1>------ <c0>Liste des clients IRC interdits <c1>------"
			::EvaServ::SENT:MSG:TO:USER $vuser "<b>"
			while { ![eof $liste] } {
				gets $liste version;
				if { $version != "" } {
					incr stop 1;
					::EvaServ::SENT:MSG:TO:USER $vuser "<c01> \[<c03> $stop <c01>\] <c01> $version"
				}
			}
			catch { close $liste }
			if { $stop == 0 } {
				::EvaServ::SENT:MSG:TO:USER $vuser "Aucun client IRC"
			}
			if { [::EvaServ::console 1] == "ok" } {
				::EvaServ::SHOW:INFO:TO:CHANLOG "Clientlist" "$user"
			}
		}
		"clientadd" {
			if { $value7 == "" } {
				::EvaServ::SENT:MSG:TO:USER $vuser "<b>Commande clientadd :</b> /msg $config(service_nick) clientadd version";
				return 0;
			}

			catch { open "[::EvaServ::Script:Get:Directory]db/client.db" r } liste
			while { ![eof $liste] } {
				gets $liste verif;
				if { ![string compare -nocase $value7 $verif] } {
					::EvaServ::SENT:MSG:TO:USER $vuser "<b>$value7</b> est déjà dans la liste des clients IRC interdits.";
					set stop		1;
					break
				}
			}
			catch { close $liste }
			if { $stop == 1 } { return 0 }
			set bclient		[open "[::EvaServ::Script:Get:Directory]db/client.db" a];
			puts $bclient [string tolower $value7];
			close $bclient
			::EvaServ::SENT:MSG:TO:USER $vuser "<b>$value7</b> a bien été ajouté à la liste des clients IRC interdits."
			if { [::EvaServ::console 1] == "ok" } {
				::EvaServ::SHOW:INFO:TO:CHANLOG "clientadd" "$user"
			}
		}
		"clientdel" {
			if { $value7 == "" } {
				::EvaServ::SENT:MSG:TO:USER $vuser "<b>Commande clientdel :</b> /msg $config(service_nick) clientdel version";
				return 0;
			}

			catch { open "[::EvaServ::Script:Get:Directory]db/client.db" r } liste
			while { ![eof $liste] } {
				gets $liste verif;
				if { ![string compare -nocase $value7 $verif] } { set stop		1 }
				if { [string compare -nocase $value7 $verif] && $verif != "" } { lappend vers "$verif" }
			}
			catch { close $liste }
			if { $stop == 0 } {
				::EvaServ::SENT:MSG:TO:USER $vuser "<b>$value7</b> n'est pas dans la liste des clients IRC interdits.";
				return 0;
			} else {
				if [info exists vers] {
					set del		[open "[::EvaServ::Script:Get:Directory]db/client.db" w+];
					foreach clientdel $vers { puts $del "$clientdel" }
					close $del
				} else {
					set del		[open "[::EvaServ::Script:Get:Directory]db/client.db" w+];
					close $del
				}
				::EvaServ::SENT:MSG:TO:USER $vuser "<b>$value7</b> a bien été supprimé de la liste des clients IRC interdits."
				if { [::EvaServ::console 1] == "ok" } {
					::EvaServ::SHOW:INFO:TO:CHANLOG "clientdel" "$user"
				}
			}
		}
		"client" {
			if { $value2 != "on" && $value2 != "off" } {
				::EvaServ::SENT:MSG:TO:USER $vuser "<b>Commande Client :</b> /msg $config(service_nick) client on/off";
				return 0;
			}

			if { $value2 == "on" } {
				if { $config(aclient) == 0 } {
					set config(aclient)		1;
					::EvaServ::SENT:MSG:TO:USER $vuser "Protection clients IRC activée"
					if { [::EvaServ::console 1] == "ok" } {
						::EvaServ::SHOW:INFO:TO:CHANLOG "Client" "$user"
					}
				} else {
					::EvaServ::SENT:MSG:TO:USER $vuser "La protection clients IRC est déjà activée."
				}
			} elseif { $value2 == "off" } {
				if { $config(aclient) == 1 } {
					set config(aclient)		0;
					::EvaServ::SENT:MSG:TO:USER $vuser "Protection clients IRC désactivée"
					if { [::EvaServ::console 1] == "ok" } {
						::EvaServ::SHOW:INFO:TO:CHANLOG "Client" "$user"
					}
				} else {
					::EvaServ::SENT:MSG:TO:USER $vuser "La protection clients IRC est déjà désactivée."
				}
			}
		}
		"closeadd" {
			set config(cmd)		"closeadd";
			set config(rep)		$user
			if { [string index $value1 0] != "#" } {
				::EvaServ::SENT:MSG:TO:USER $vuser "<b>Commande Close add :</b> /msg $config(service_nick) closeadd #salon";
				return 0;
			}

			if { $value2 == [string tolower $config(salon)] } {
				::EvaServ::SENT:MSG:TO:USER $user "Accès Refusé : Salon de logs";
				return 0;
			}

			catch { open "[::EvaServ::Script:Get:Directory]db/salon.db" r } liste1
			while { ![eof $liste1] } {
				gets $liste1 verif1;
				if { ![string compare -nocase $value2 $verif1] } {
					::EvaServ::SENT:MSG:TO:USER $vuser "Accès Refusé : Salon Interdit";
					set stop		1;
					break
				}
			}
			catch { close $liste1 }
			if { $stop == 1 } { return 0 }
			catch { open "[::EvaServ::Script:Get:Directory]db/chan.db" r } liste3
			while { ![eof $liste3] } {
				gets $liste3 verif3;
				if { ![string compare -nocase $value2 $verif3] } {
					::EvaServ::SENT:MSG:TO:USER $vuser "Accès Refusé : Salon Autojoin";
					set stop		1;
					break
				}
			}
			catch { close $liste3 }
			if { $stop == 1 } { return 0 }
			catch { open "[::EvaServ::Script:Get:Directory]db/close.db" r } liste
			while { ![eof $liste] } {
				gets $liste verif;
				if { ![string compare -nocase $value2 $verif] } {
					::EvaServ::SENT:MSG:TO:USER $vuser "<b>$value1</b> est déjà dans la liste des salons fermés.";
					set stop		1;
					break
				}
			}
			catch { close $liste }
			if { $stop == 1 } { return 0 }
			set bclose		[open "[::EvaServ::Script:Get:Directory]db/close.db" a];
			puts $bclose $value2;
			close $bclose
			::EvaServ::SENT:MSG:TO:USER $vuser "<b>$value1</b> vient d'être ajouté dans la liste des salons fermés."
			::EvaServ::sent2socket ":$config(server_id) JOIN $value1";
			::EvaServ::FCT:SENT:MODE $value1 +sntio "$config(service_nick)";
			::EvaServ::FCT:SET:TOPIC $value1 "<c1>Salon Fermé le [::EvaServ::duree [unixtime]]"
			::EvaServ::sent2socket ":$config(link) NAMES $value1"
			if { [::EvaServ::console 1] == "ok" } {
				::EvaServ::SHOW:INFO:TO:CHANLOG "closeadd" "$value1 par $user"
			}
		}
		"closedel" {
			if { [string index $value1 0] != "#" } {
				::EvaServ::SENT:MSG:TO:USER $vuser "<b>Commande closedel :</b> /msg $config(service_nick) closedel #salon";
				return 0;
			}

			catch { open "[::EvaServ::Script:Get:Directory]db/close.db" r } liste
			while { ![eof $liste] } {
				gets $liste verif;
				if { ![string compare -nocase $value2 $verif] } { set stop		1 }
				if { [string compare -nocase $value2 $verif] && $verif != "" } { lappend salon "$verif" }
			}
			catch { close $liste }
			if { $stop == 0 } {
				::EvaServ::SENT:MSG:TO:USER $vuser "<b>$value1</b> n'est pas dans la liste des salons fermés.";
				return 0;
			} else {
				if [info exists salon] {
					set del		[open "[::EvaServ::Script:Get:Directory]db/close.db" w+];
					foreach chandel $salon { puts $del "$chandel" }
					close $del
				} else {
					set del		[open "[::EvaServ::Script:Get:Directory]db/close.db" w+];
					close $del
				}
				::EvaServ::SENT:MSG:TO:USER $user "<b>$value1</b> a bien été supprimé de la liste des salons fermés."
				::EvaServ::FCT:SENT:MODE $value1
				::EvaServ::FCT:SET:TOPIC $value1 "Bienvenue sur $value1"
				::EvaServ::sent2socket ":$config(server_id) PART $value1"
				if { [::EvaServ::console 1] == "ok" } {
					::EvaServ::SHOW:INFO:TO:CHANLOG "closedel" "$value1 par $user"
				}
			}
		}
		"closelist" {
			catch { open "[::EvaServ::Script:Get:Directory]db/close.db" r } liste
			::EvaServ::SENT:MSG:TO:USER $vuser "<b><c1,1>------ <c0>Liste des salons fermés <c1>------"
			::EvaServ::SENT:MSG:TO:USER $vuser "<b>"
			while { ![eof $liste] } {
				gets $liste salon;
				if { $salon != "" } {
					incr stop 1;
					::EvaServ::SENT:MSG:TO:USER $vuser "<c1> \[<c03> $stop <c01>\] <c01> $salon"
				}
			}
			catch { close $liste }
			if { $stop == 0 } {
				::EvaServ::SENT:MSG:TO:USER $vuser "Aucun Salon."
			}
			if { [::EvaServ::console 1] == "ok" } {
				::EvaServ::SHOW:INFO:TO:CHANLOG "Closelist" "$user"
			}
		}
		"closeclear" {
			catch { open "[::EvaServ::Script:Get:Directory]db/close.db" r } liste
			while { ![eof $liste] } {
				gets $liste salon
				if { $salon != "" } {
					::EvaServ::FCT:SENT:MODE $salon
					::EvaServ::FCT:SET:TOPIC $salon "Bienvenue sur $salon"
					::EvaServ::sent2socket ":$config(server_id) PART $salon"
				}
			}
			catch { close $liste }
			set del		[open "[::EvaServ::Script:Get:Directory]db/close.db" w+];
			close $del
			::EvaServ::SENT:MSG:TO:USER $user "La liste des salons fermés à bien été vidée."
			if { [::EvaServ::console 1] == "ok" } {
				::EvaServ::SHOW:INFO:TO:CHANLOG "closeclear" "$user"
			}
		}
		"nickadd" {
			if { $value2 == "" } {
				::EvaServ::SENT:MSG:TO:USER $vuser "<b>Commande nickadd :</b> /msg $config(service_nick) nickadd pseudo";
				return 0;
			}

			if { [string match *$value2* [string tolower $config(service_nick)]] } {
				::EvaServ::SENT:MSG:TO:USER $user "Accès Refusé : Pseudo Protégé";
				return 0;
			}

			foreach { p n } [array get users] {
				if { [string match *$value2* $p] } {
					::EvaServ::SENT:MSG:TO:USER $user "Accès Refusé : Pseudo Protégé";
					return 0;
				}

			}
			foreach { a r } [array get admins] {
				if { [string match *$value2* $r] } {
					::EvaServ::SENT:MSG:TO:USER $user "Accès Refusé : Pseudo Protégé";
					return 0;
				}

			}
			catch { open "[::EvaServ::Script:Get:Directory]db/nick.db" r } liste
			while { ![eof $liste] } {
				gets $liste verif;
				if { ![string compare -nocase $value2 $verif] } {
					::EvaServ::SENT:MSG:TO:USER $vuser "<b>$value1</b> est déjà dans la liste des pseudos interdits.";
					set stop		1;
					break
				}
			}
			catch { close $liste }
			if { $stop == 1 } { return 0 }
			set nick		[open "[::EvaServ::Script:Get:Directory]db/nick.db" a];
			puts $nick $value2;
			close $nick
			::EvaServ::SENT:MSG:TO:USER $vuser "<b>$value1</b> a bien été ajouté dans la liste des pseudos interdits."
			if { [::EvaServ::console 1] == "ok" } {
				::EvaServ::SHOW:INFO:TO:CHANLOG "nickadd" "$user"
			}
		}
		"nickdel" {
			if { $value2 == "" } {
				::EvaServ::SENT:MSG:TO:USER $vuser "<b>Commande nickdel :</b> /msg $config(service_nick) nickdel pseudo";
				return 0;
			}

			catch { open "[::EvaServ::Script:Get:Directory]db/nick.db" r } liste
			while { ![eof $liste] } {
				gets $liste verif;
				if { ![string compare -nocase $value2 $verif] } { set stop		1 }
				if { [string compare -nocase $value2 $verif] && $verif != "" } { lappend pseudo "$verif" }
			}
			catch { close $liste }
			if { $stop == 0 } {
				::EvaServ::SENT:MSG:TO:USER $vuser "<b>$value1</b> n'est pas dans la liste des pseudos interdits.";
				return 0;
			} else {
				if { [info exists pseudo] } {
					set del		[open "[::EvaServ::Script:Get:Directory]db/nick.db" w+];
					foreach nickdel $pseudo { puts $del "$nickdel" }
					close $del
				} else {
					set del		[open "[::EvaServ::Script:Get:Directory]db/nick.db" w+];
					close $del
				}
				::EvaServ::SENT:MSG:TO:USER $vuser "<b>$value1</b> a bien été supprimé de la liste des pseudos interdits."
				if { [::EvaServ::console 1] == "ok" } {
					::EvaServ::SHOW:INFO:TO:CHANLOG "nickdel" "$user"
				}
			}
		}
		"nicklist" {
			catch { open "[::EvaServ::Script:Get:Directory]db/nick.db" r } liste
			::EvaServ::SENT:MSG:TO:USER $vuser "<b><c1,1>--------- <c0>Pseudos Interdits <c1>---------"
			::EvaServ::SENT:MSG:TO:USER $vuser "<b>"
			while { ![eof $liste] } {
				gets $liste pseudo;
				if { $pseudo != "" } {
					incr stop 1;
					::EvaServ::SENT:MSG:TO:USER $vuser "<c01> \[<c03> $stop <c01>\] <c01> $pseudo"
				}
			}
			catch { close $liste }
			if { $stop == 0 } {
				::EvaServ::SENT:MSG:TO:USER $vuser "Aucun Pseudo"
			}
			if { [::EvaServ::console 1] == "ok" } {
				::EvaServ::SHOW:INFO:TO:CHANLOG "Nicklist" "$user"
			}
		}
		"identadd" {
			if { $value2 == "" } {
				::EvaServ::SENT:MSG:TO:USER $vuser "<b>Commande identadd :</b> /msg $config(service_nick) identadd ident";
				return 0;
			}

			if { [string match *$value2* [string tolower $config(ident)]] } {
				::EvaServ::SENT:MSG:TO:USER $user "Accès Refusé : Ident Protégé";
				return 0;
			}

			catch { open "[::EvaServ::Script:Get:Directory]db/ident.db" r } liste
			while { ![eof $liste] } {
				gets $liste verif;
				if { ![string compare -nocase $value2 $verif] } {
					::EvaServ::SENT:MSG:TO:USER $vuser "<b>$value1</b> est déjà dans la liste des idents interdits.";
					set stop		1;
					break
				}
			}
			catch { close $liste }
			if { $stop == 1 } { return 0 }
			set ident		[open "[::EvaServ::Script:Get:Directory]db/ident.db" a];
			puts $ident $value2;
			close $ident
			::EvaServ::SENT:MSG:TO:USER $vuser "<b>$value1</b> a bien été ajouté dans la liste des idents interdits."
			if { [::EvaServ::console 1] == "ok" } {
				::EvaServ::SHOW:INFO:TO:CHANLOG "identadd" "$user"
			}
		}
		"identdel" {
			if { $value2 == "" } {
				::EvaServ::SENT:MSG:TO:USER $vuser "<b>Commande identdel :</b> /msg $config(service_nick) identdel ident";
				return 0;
			}

			catch { open "[::EvaServ::Script:Get:Directory]db/ident.db" r } liste
			while { ![eof $liste] } {
				gets $liste verif;
				if { ![string compare -nocase $value2 $verif] } { set stop		1 }
				if { [string compare -nocase $value2 $verif] && $verif != "" } { lappend ident "$verif" }
			}
			catch { close $liste }
			if { $stop == 0 } {
				::EvaServ::SENT:MSG:TO:USER $vuser "<b>$value1</b> n'est pas dans la liste des idents interdits.";
				return 0;
			} else {
				if { [info exists ident] } {
					set del		[open "[::EvaServ::Script:Get:Directory]db/ident.db" w+];
					foreach identdel $ident { puts $del "$identdel" }
					close $del
				} else {
					set del		[open "[::EvaServ::Script:Get:Directory]db/ident.db" w+];
					close $del
				}
				::EvaServ::SENT:MSG:TO:USER $vuser "<b>$value1</b> a bien été supprimé de la liste des idents interdits."
				if { [::EvaServ::console 1] == "ok" } {
					::EvaServ::SHOW:INFO:TO:CHANLOG "identdel" "$user"
				}
			}
		}
		"identlist" {
			catch { open "[::EvaServ::Script:Get:Directory]db/ident.db" r } liste
			::EvaServ::SENT:MSG:TO:USER $vuser "<b><c1,1>---------- <c0>Idents Interdits <c1>----------"
			::EvaServ::SENT:MSG:TO:USER $vuser "<b>"
			while { ![eof $liste] } {
				gets $liste ident;
				if { $ident != "" } {
					incr stop 1;
					::EvaServ::SENT:MSG:TO:USER $vuser "<c01> \[<c03> $stop <c01>\] <c01> $ident"
				}
			}
			catch { close $liste }
			if { $stop == 0 } {
				::EvaServ::SENT:MSG:TO:USER $vuser "Aucun Ident"
			}
			if { [::EvaServ::console 1] == "ok" } {
				::EvaServ::SHOW:INFO:TO:CHANLOG "Identlist" "$user"
			}
		}
		"realadd" {
			if { $value2 == "" } {
				::EvaServ::SENT:MSG:TO:USER $vuser "<b>Commande realadd :</b> /msg $config(service_nick) realadd realname";
				return 0;
			}

			if { [string match *$value2* [string tolower $config(real)]] } {
				::EvaServ::SENT:MSG:TO:USER $user "Accès Refusé : Realname Protégé";
				return 0;
			}

			catch { open "[::EvaServ::Script:Get:Directory]db/real.db" r } liste
			while { ![eof $liste] } {
				gets $liste verif;
				if { ![string compare -nocase $value2 $verif] } {
					::EvaServ::SENT:MSG:TO:USER $vuser "<b>$value1</b> est déjà dans la liste des realnames interdits.";
					set stop		1;
					break
				}
			}
			catch { close $liste }
			if { $stop == 1 } { return 0 }
			set real		[open "[::EvaServ::Script:Get:Directory]db/real.db" a];
			puts $real $value2;
			close $real
			::EvaServ::SENT:MSG:TO:USER $vuser "<b>$value1</b> a bien été ajouté dans la liste des realnames interdits."
			if { [::EvaServ::console 1] == "ok" } {
				::EvaServ::SHOW:INFO:TO:CHANLOG "realadd" "$user"
			}
		}
		"realdel" {
			if { $value2 == "" } {
				::EvaServ::SENT:MSG:TO:USER $vuser "<b>Commande realdel :</b> /msg $config(service_nick) realdel realname";
				return 0;
			}

			catch { open "[::EvaServ::Script:Get:Directory]db/real.db" r } liste
			while { ![eof $liste] } {
				gets $liste verif;
				if { ![string compare -nocase $value2 $verif] } { set stop		1 }
				if { [string compare -nocase $value2 $verif] && $verif != "" } { lappend real "$verif" }
			}
			catch { close $liste }
			if { $stop == 0 } {
				::EvaServ::SENT:MSG:TO:USER $vuser "<b>$value1</b> n'est pas dans la liste des realnames interdits.";
				return 0;
			} else {
				if { [info exists real] } {
					set del		[open "[::EvaServ::Script:Get:Directory]db/real.db" w+];
					foreach realdel $real { puts $del "$realdel" }
					close $del
				} else {
					set del		[open "[::EvaServ::Script:Get:Directory]db/real.db" w+];
					close $del
				}
				::EvaServ::SENT:MSG:TO:USER $vuser "<b>$value1</b> a bien été supprimé de la liste des realnames interdits."
				if { [::EvaServ::console 1] == "ok" } {
					::EvaServ::SHOW:INFO:TO:CHANLOG "realdel" "$user"
				}
			}
		}
		"reallist" {
			catch { open "[::EvaServ::Script:Get:Directory]db/real.db" r } liste
			::EvaServ::SENT:MSG:TO:USER $vuser "<b><c1,1>--------- <c0>Realnames Interdits <c1>---------"
			::EvaServ::SENT:MSG:TO:USER $vuser "<b>"
			while { ![eof $liste] } {
				gets $liste real;
				if { $real != "" } {
					incr stop 1;
					::EvaServ::SENT:MSG:TO:USER $vuser "<c01> \[<c03> $stop <c01>\] <c01> $real"
				}
			}
			catch { close $liste }
			if { $stop == 0 } {
				::EvaServ::SENT:MSG:TO:USER $vuser "Aucun Realname"
			}
			if { [::EvaServ::console 1] == "ok" } {
				::EvaServ::SHOW:INFO:TO:CHANLOG "Reallist" "$user"
			}
		}
		"hostadd" {
			if { $value2 == "" } {
				::EvaServ::SENT:MSG:TO:USER $vuser "<b>Commande hostadd :</b> /msg $config(service_nick) hostadd hostname";
				return 0;
			}

			if { [string match *$value2* [string tolower $config(host)]] || [info exists protect($value2)] } {
				::EvaServ::SENT:MSG:TO:USER $user "Accès Refusé : Hostname Protégée";
				return 0;
			}

			foreach { mask num } [array get trust] {
				if { [string match *$value2* $mask] } {
					::EvaServ::SENT:MSG:TO:USER $user "Accès Refusé : Hostname Trustée";
					return 0;
				}

			}
			catch { open "[::EvaServ::Script:Get:Directory]db/host.db" r } liste
			while { ![eof $liste] } {
				gets $liste verif;
				if { ![string compare -nocase $value2 $verif] } {
					::EvaServ::SENT:MSG:TO:USER $vuser "<b>$value1</b> est déjà dans la liste des hostnames interdites.";
					set stop		1;
					break
				}
			}
			catch { close $liste }
			if { $stop == 1 } { return 0 }
			set host		[open "[::EvaServ::Script:Get:Directory]db/host.db" a];
			puts $host $value2;
			close $host
			::EvaServ::SENT:MSG:TO:USER $vuser "<b>$value1</b> a bien été ajouté dans la liste des hostnames interdites."
			if { [::EvaServ::console 1] == "ok" } {
				::EvaServ::SHOW:INFO:TO:CHANLOG "hostadd" "$user"
			}
		}
		"hostdel" {
			if { $value2 == "" } {
				::EvaServ::SENT:MSG:TO:USER $vuser "<b>Commande hostdel :</b> /msg $config(service_nick) hostdel hostname";
				return 0;
			}

			catch { open "[::EvaServ::Script:Get:Directory]db/host.db" r } liste
			while { ![eof $liste] } {
				gets $liste verif;
				if { ![string compare -nocase $value2 $verif] } { set stop		1 }
				if { [string compare -nocase $value2 $verif] && $verif != "" } { lappend host "$verif" }
			}
			catch { close $liste }
			if { $stop == 0 } {
				::EvaServ::SENT:MSG:TO:USER $vuser "<b>$value1</b> n'est pas dans la liste des hostnames interdites.";
				return 0;
			} else {
				if { [info exists host] } {
					set del		[open "[::EvaServ::Script:Get:Directory]db/host.db" w+];
					foreach hostdel $host { puts $del "$hostdel" }
					close $del
				} else {
					set del		[open "[::EvaServ::Script:Get:Directory]db/host.db" w+];
					close $del
				}
				::EvaServ::SENT:MSG:TO:USER $vuser "<b>$value1</b> a bien été supprimé de la liste des hostnames interdites."
				if { [::EvaServ::console 1] == "ok" } {
					::EvaServ::SHOW:INFO:TO:CHANLOG "hostdel" "$user"
				}
			}
		}
		"hostlist" {
			catch { open "[::EvaServ::Script:Get:Directory]db/host.db" r } liste
			::EvaServ::SENT:MSG:TO:USER $vuser "<b><c1,1>----------- <c0>Hostnames Interdites <c1>-----------"
			::EvaServ::SENT:MSG:TO:USER $vuser "<b>"
			while { ![eof $liste] } {
				gets $liste host;
				if { $host != "" } {
					incr stop 1;
					::EvaServ::SENT:MSG:TO:USER $vuser "<c01> \[<c03> $stop <c01>\] <c01> $host"
				}
			}
			catch { close $liste }
			if { $stop == 0 } {
				::EvaServ::SENT:MSG:TO:USER $vuser "Aucune Hostname"
			}
			if { [::EvaServ::console 1] == "ok" } {
				::EvaServ::SHOW:INFO:TO:CHANLOG "Hostlist" "$user"
			}
		}
		"chanadd" {
			if { [string index $value2 0] != "#" } {
				::EvaServ::SENT:MSG:TO:USER $vuser "<b>Commande chanadd :</b> /msg $config(service_nick) chanadd #salon";
				return 0;
			}

			if { [string match *[string trimleft $value2 #]* [string trimleft [string tolower $config(salon)] #]] } {
				::EvaServ::SENT:MSG:TO:USER $user "Accès Refusé : Salon de logs";
				return 0;
			}

			catch { open "[::EvaServ::Script:Get:Directory]db/chan.db" r } liste1
			while { ![eof $liste1] } {
				gets $liste1 verif1;
				if { [string match *[string trimleft $value2 #]* [string trimleft $verif1 #]] } {
					::EvaServ::SENT:MSG:TO:USER $vuser "Accès Refusé : Salon Autojoin";
					set stop		1;
					break
				}
			}
			catch { close $liste1 }
			if { $stop == 1 } { return 0 }
			catch { open "[::EvaServ::Script:Get:Directory]db/close.db" r } liste2
			while { ![eof $liste2] } {
				gets $liste2 verif2;
				if { [string match *[string trimleft $value2 #]* [string trimleft $verif2 #]] } {
					::EvaServ::SENT:MSG:TO:USER $vuser "Accès Refusé : Salon Fermé";
					set stop		1;
					break
				}
			}
			catch { close $liste2 }
			if { $stop == 1 } { return 0 }
			catch { open "[::EvaServ::Script:Get:Directory]db/salon.db" r } liste
			while { ![eof $liste] } {
				gets $liste verif;
				if { ![string compare -nocase $value2 $verif] } {
					::EvaServ::SENT:MSG:TO:USER $vuser "<b>$value1</b> est déjà dans la liste des salons interdits.";
					set stop		1;
					break
				}
			}
			catch { close $liste }
			if { $stop == 1 } { return 0 }
			set chan		[open "[::EvaServ::Script:Get:Directory]db/salon.db" a];
			puts $chan $value2;
			close $chan
			::EvaServ::SENT:MSG:TO:USER $vuser "<b>$value1</b> a bien été ajouté dans la liste des salons interdits."
			if { [::EvaServ::console 1] == "ok" } {
				::EvaServ::SHOW:INFO:TO:CHANLOG "chanadd" "$user"
			}
		}
		"chandel" {
			if { [string index $value2 0] != "#" } {
				::EvaServ::SENT:MSG:TO:USER $vuser "<b>Commande chandel :</b> /msg $config(service_nick) chandel #salon";
				return 0;
			}

			catch { open "[::EvaServ::Script:Get:Directory]db/salon.db" r } liste
			while { ![eof $liste] } {
				gets $liste verif;
				if { ![string compare -nocase $value2 $verif] } { set stop 1; }
				if { [string compare -nocase $value2 $verif] && $verif != "" } { lappend chan "$verif"; }
			}
			catch { close $liste }
			if { $stop == 0 } {
				::EvaServ::SENT:MSG:TO:USER $vuser "<b>$value1</b> n'est pas dans la liste des salons interdits.";
				return 0;
			} else {
				if { [info exists chan] } {
					set FILE_PIPE		[open "[::EvaServ::Script:Get:Directory]db/salon.db" w+];
					foreach chandel $chan { puts $FILE_PIPE "$chandel" }
					close $FILE_PIPE
				} else {
					set FILE_PIPE		[open "[::EvaServ::Script:Get:Directory]db/salon.db" w+];
					close $FILE_PIPE
				}
				::EvaServ::sent2socket ":$config(server_id) PART $value1"
				::EvaServ::SENT:MSG:TO:USER $vuser "<b>$value1</b> a bien été supprimé de la liste des salons interdits."
				if { [::EvaServ::console 1] == "ok" } {
					::EvaServ::SHOW:INFO:TO:CHANLOG "chandel" "$user"
				}
			}
		}
		"chanlist" {
			catch { open "[::EvaServ::Script:Get:Directory]db/salon.db" r } liste
			::EvaServ::SENT:MSG:TO:USER $vuser "<b><c1,1>--------- <c0>Salons Interdits <c1>---------"
			::EvaServ::SENT:MSG:TO:USER $vuser "<b>"
			while { ![eof $liste] } {
				gets $liste chan;
				if { $chan != "" } {
					incr stop 1;
					::EvaServ::SENT:MSG:TO:USER $vuser "<c01> \[<c03> $stop <c01>\] <c01> $chan"
				}
			}
			catch { close $liste }
			if { $stop == 0 } {
				::EvaServ::SENT:MSG:TO:USER $vuser "Aucun Salon"
			}
			if { [::EvaServ::console 1] == "ok" } {
				::EvaServ::SHOW:INFO:TO:CHANLOG "Chanlist" "$user"
			}
		}
		"trustadd" {
			if { $value2 == "" } {
				::EvaServ::SENT:MSG:TO:USER $vuser "<b>Commande trustadd :</b> /msg $config(service_nick) trustadd mask";
				return 0;
			}

			catch { open "[::EvaServ::Script:Get:Directory]db/host.db" r } liste1
			while { ![eof $liste1] } {
				gets $liste1 verif1;
				if { [string match *$value2* $verif1] } {
					::EvaServ::SENT:MSG:TO:USER $vuser "Accès Refusé : Hostname Interdite";
					set stop		1;
					break
				}
			}
			catch { close $liste1 }
			if { $stop == 1 } { return 0 }
			catch { open [::EvaServ::Script:Get:Directory]db/trust.db r } liste
			while { ![eof $liste] } {
				gets $liste verif;
				if { $verif==$value2 } {
					::EvaServ::SENT:MSG:TO:USER $vuser "<b>$value1</b> est déjà dans la trustlist.";
					set stop		1;
					break
				}
			}
			catch { close $liste }
			if { $stop == 1 } { return 0 }
			set bprotect		[open [::EvaServ::Script:Get:Directory]db/trust.db a];
			puts $bprotect "$value2";
			close $bprotect
			::EvaServ::SENT:MSG:TO:USER $vuser "<b>$value1</b> a bien été ajoutée dans la trustlist."
			if { ![info exists trust($value2)] } { set trust($value2)		1 }
			if { [::EvaServ::console 1] == "ok" } {
				::EvaServ::SHOW:INFO:TO:CHANLOG "trustadd" "$user"
			}
		}
		"trustdel" {
			if { $value2 == "" } {
				::EvaServ::SENT:MSG:TO:USER $vuser "<b>Commande trustdel :</b> /msg $config(service_nick) trustdel mask";
				return 0;
			}

			catch { open [::EvaServ::Script:Get:Directory]db/trust.db r } liste
			while { ![eof $liste] } {
				gets $liste verif;
				if { $verif==$value2 } { set stop		1 }
				if { $verif!=$value2 && $verif != "" } { lappend hs "$verif" }
			}
			catch { close $liste }
			if { $stop == 0 } {
				::EvaServ::SENT:MSG:TO:USER $vuser "<b>$value1</b> n'est pas dans la trustlist.";
				return 0;
			} else {
				if { [info exists hs] } {
					set del		[open [::EvaServ::Script:Get:Directory]db/trust.db w+];
					foreach delprotect $hs { puts $del "$delprotect" }
					close $del
				} else {
					set del		[open [::EvaServ::Script:Get:Directory]db/trust.db w+];
					close $del
				}
				::EvaServ::SENT:MSG:TO:USER $vuser "<b>$value1</b> a bien été supprimée de la trustlist."
				if { [info exists trust($value2)] } { unset trust($value2)		}
				if { [::EvaServ::console 1] == "ok" } {
					::EvaServ::SHOW:INFO:TO:CHANLOG "trustdel" "$user"
				}
			}
		}
		"trustlist" {
			catch { open [::EvaServ::Script:Get:Directory]db/trust.db r } liste
			::EvaServ::SENT:MSG:TO:USER $vuser "<b><c1,1>----------------- <c0>Liste des Trusts <c1>-----------------"
			::EvaServ::SENT:MSG:TO:USER $vuser "<b>"
			while { ![eof $liste] } {
				gets $liste mask;
				if { $mask != "" } {
					incr stop 1;
					::EvaServ::SENT:MSG:TO:USER $vuser "<c01> \[<c03> $stop <c01>\] <c01> $mask"
				}
			}
			catch { close $liste }
			if { $stop == 0 } {
				::EvaServ::SENT:MSG:TO:USER $vuser "Aucun Trust"
			}
			if { [::EvaServ::console 1] == "ok" } {
				::EvaServ::SHOW:INFO:TO:CHANLOG "Trustlist" "$user"
			}
		}
		"accessadd" {
			if {
				$value2 == "" || \
					$value4 == "" || \
					$value8 == "" || \
					[regexp \[^1-4\] $value8]
			} {
				::EvaServ::SENT:MSG:TO:USER $vuser "<b>Commande accessadd :</b> /msg $config(service_nick) accessadd pseudo password level"
				::EvaServ::SENT:MSG:TO:USER $vuser "<c02>Level 1 <c04>:<c01> Helpeur"
				::EvaServ::SENT:MSG:TO:USER $vuser "<c02>Level 2 <c04>:<c01> Géofront"
				::EvaServ::SENT:MSG:TO:USER $vuser "<c02>Level 3 <c04>:<c01> IRCop"
				::EvaServ::SENT:MSG:TO:USER $vuser "<c02>Level 4 <c04>:<c01> Admin"
				return 0
			}
			if { [string length $value2]>="10" } {
				::EvaServ::SENT:MSG:TO:USER $vuser "Le pseudo doit contenir maximum 9 caractères.";
				return 0;
			}

			foreach verif [userlist] {
				if { [string tolower $value2] == [string tolower $verif] } {
					::EvaServ::SENT:MSG:TO:USER $vuser "<b>$value1</b> est déja dans la liste des accès.";
					return 0;
				}

			}
			if { [string length $value4] <= 5 } {
				::EvaServ::SENT:MSG:TO:USER $vuser "Le mot de passe doit contenir minimum 6 caractères.";
				return 0;
			}

			adduser $value1;
			setuser $value1 PASS $value3;
			setuser $value1 HOSTS $value1*!*@*;
			setuser $value1 HOSTS -telnet!*@*
			switch -exact $value8 {
				1 {
					chattr $value1 +p;
					set lvl		"helpeurs"
				}
				2 {
					chattr $value1 +op;
					set lvl		"géofronts"
				}
				3 {
					chattr $value1 +mop;
					set lvl		"IRCops"
				}
				4 {
					chattr $value1 +nmop;
					set lvl		"Admins"
				}
			}
			::EvaServ::SENT:MSG:TO:USER $vuser "<b>$value1</b> a bien été ajouté dans la liste des $lvl."
			if { [::EvaServ::console 1] == "ok" } {
				::EvaServ::SHOW:INFO:TO:CHANLOG "accessadd" "$user"
			}
		}
		"accessdel" {
			if { $value1 == "" } {
				::EvaServ::SENT:MSG:TO:USER $vuser "<b>Commande accessdel :</b> /msg $config(service_nick) accessdel pseudo";
				return 0;
			}

			if { [string tolower $admin] == $value2 } {
				::EvaServ::SENT:MSG:TO:USER $vuser "Accès Refusé.";
				return 0;
			}

			foreach verif [userlist] {
				if { $value2 == [string tolower $verif] } {
					foreach { pseudo auth } [array get admins] {
						if { [string tolower $auth] == $value2 } { unset admins([string tolower $pseudo]) }
					}
					deluser $value2
					::EvaServ::SENT:MSG:TO:USER $vuser "<b>$value1</b> a bien été supprimé de la liste des accès."
					if { [::EvaServ::console 1] == "ok" } {
						::EvaServ::SHOW:INFO:TO:CHANLOG "accessdel" "$user"
					}
					return 0
				}
			}
			::EvaServ::SENT:MSG:TO:USER $vuser "<b>$value1</b> n'est pas dans la liste des accès."
		}
		"accessmod" {
			if { $value2 != "level" && $value2 != "pass" } {
				::EvaServ::SENT:MSG:TO:USER $vuser "<b>Commande accessmod Pass :</b> /msg $config(service_nick) accessmod pass pseudo mot-de-passe"
				::EvaServ::SENT:MSG:TO:USER $vuser "<b>Commande accessmod Level :</b> /msg $config(service_nick) accessmod level pseudo level"
				return 0
			}
			switch -exact $value2 {
				"level"	{
					if {
						$value4 == "" || \
							$value8 == "" || \
							[regexp \[^1-4\] $value8]
					} {
						::EvaServ::SENT:MSG:TO:USER $vuser "<b>Commande accessmod Level :</b> /msg $config(service_nick) accessmod level pseudo level"
						::EvaServ::SENT:MSG:TO:USER $vuser "<c02>Level 1 <c04>:<c01> Helpeur"
						::EvaServ::SENT:MSG:TO:USER $vuser "<c02>Level 2 <c04>:<c01> Géofront"
						::EvaServ::SENT:MSG:TO:USER $vuser "<c02>Level 3 <c04>:<c01> IRCop"
						::EvaServ::SENT:MSG:TO:USER $vuser "<c02>Level 4 <c04>:<c01> Admin"
						return 0
					}
					if { [string tolower $admin] == $value4 } {
						::EvaServ::SENT:MSG:TO:USER $vuser "Accès Refusé.";
						return 0;
					}

					foreach verif [userlist] {
						if { $value4 == [string tolower $verif] } {
							switch -exact $value8 {
								1 {
									chattr $value4 -nmopjltx;
									chattr $value4 +p
								}
								2 {
									chattr $value4 -nmopjltx;
									chattr $value4 +op
								}
								3 {
									chattr $value4 -nmopjltx;
									chattr $value4 +mop
								}
								4 {
									chattr $value4 -nmopjltx;
									chattr $value4 +nmop
								}
							}
							::EvaServ::SENT:MSG:TO:USER $vuser "Changement du level de <b>$value4</b> reussi."
							if { [::EvaServ::console 1] == "ok" } {
								::EvaServ::SHOW:INFO:TO:CHANLOG "accessmod" "$user"
							}
							return 0
						}
					}
					::EvaServ::SENT:MSG:TO:USER $vuser "<b>$value4</b> n'est pas dans la liste des accès.";
					return 0;
				}
				"pass" {
					if { $value4 == "" || $value8 == "" } {
						::EvaServ::SENT:MSG:TO:USER $vuser "<b>Commande accessmod Pass :</b> /msg $config(service_nick) accessmod pass pseudo mot-de-passe";
						return 0;
					}

					if { [string tolower $admin] == $value4 } {
						::EvaServ::SENT:MSG:TO:USER $vuser "Accès Refusé.";
						return 0;
					}

					foreach verif [userlist] {
						if { $value4 == [string tolower $verif] } {
							if { [string length $value8] <= 5 } {
								::EvaServ::SENT:MSG:TO:USER $vuser "Le mot de passe doit contenir minimum 6 caractères.";
								return 0;
							}
							setuser $value3 PASS $value8
							::EvaServ::SENT:MSG:TO:USER $vuser "Changement du mot de passe de <b>$value4</b> reussi."
							if { [::EvaServ::console 1] == "ok" } {
								::EvaServ::SHOW:INFO:TO:CHANLOG "accessmod" "$user"
							}
							return 0
						}
					}
					::EvaServ::SENT:MSG:TO:USER $vuser "<b>$value4</b> n'est pas dans la liste des accès.";
					return 0;
				}
			}
		}
		default {
			putlog "socket => command inconue $arg"
		}
	}
}
proc ::EvaServ::help:description:help {}			{ return "Permet de voir l'aide détaillée de la commande." }
proc ::EvaServ::help:description:auth {}			{
	variable config
	return "Permet de vous authentifier sur $config(service_nick)."
}
proc ::EvaServ::help:description:copyright {}		{
	variable config
	return "Permet de voir l'auteur de $config(service_nick)."
}
proc ::EvaServ::help:description:deauth {}			{
	variable config
	return "Permet de vous déauthentifier sur $config(service_nick)."
}
proc ::EvaServ::help:description:seen {}			{ return "Permet de voir la dernière authentification du pseudo." }
proc ::EvaServ::help:description:showcommands {}	{
	variable config
	 return "Permet de voir la liste des commandes de $config(scriptname)."
}
proc ::EvaServ::help:description:map {}				{ return "Permet de voir la liste des serveurs." }
proc ::EvaServ::help:description:whois {}			{ return "Permet de voir le whois d'un utilisateur." }
proc ::EvaServ::help:description:access {}			{ return "Permet de voir l'accès du pseudo." }
proc ::EvaServ::help:description:ban {}				{ return "Permet de bannir un mask d'un salon." }
proc ::EvaServ::help:description:clearallmodes {}	{ return "Permet de retirer tous les modes, tous les accès et tous les bans d'un salon." }
proc ::EvaServ::help:description:clearbans {}		{ return "Permet de débannir tous les masks d'un salon." }
proc ::EvaServ::help:description:clearmodes {}		{ return "Permet de retirer tous les modes d'un salon." }
proc ::EvaServ::help:description:dehalfop {}		{ return "Permet de déhalfoper un utilisateur d'un salon." }
proc ::EvaServ::help:description:dehalfopall {}		{ return "Permet de déhalfoper tous les utilisateurs d'un salon." }
proc ::EvaServ::help:description:deop {}			{ return "Permet de déoper un utilisateur d'un salon." }
proc ::EvaServ::help:description:deopall {}			{ return "Permet de déoper tous les utilisateurs d'un salon." }
proc ::EvaServ::help:description:deowner {}			{ return "Permet de retirer un utilisateur owner d'un salon." }
proc ::EvaServ::help:description:deownerall {}		{ return "Permet de retirer tous les utilisateurs owner d'un salon." }
proc ::EvaServ::help:description:deprotect {}		{ return "Permet de retirer un utilisateur protect d'un salon." }
proc ::EvaServ::help:description:deprotectall {}	{ return "Permet de retirer tous les utilisateurs protect d'un salon." }
proc ::EvaServ::help:description:devoice {}			{ return "Permet de dévoicer un utilisateur d'un salon." }
proc ::EvaServ::help:description:devoiceall {}		{ return "Permet de dévoicer tous les utilisateurs d'un salon." }
proc ::EvaServ::help:description:gline {}			{ return "Permet de gline un utilisateur du serveur." }
proc ::EvaServ::help:description:glinelist {}		{ return "Permet de voir la liste des glines." }
proc ::EvaServ::help:description:shunlist {}		{ return "Permet de voir la liste des shuns." }
proc ::EvaServ::help:description:globops {}			{ return "Permet d'envoyer un message en globops à tous les ircops et admins." }
proc ::EvaServ::help:description:halfop {}			{ return "Permet d'halfoper un utilisateur d'un salon." }
proc ::EvaServ::help:description:halfopall {}		{ return "Permet d'halfoper tous les utilisateurs d'un salon." }
proc ::EvaServ::help:description:invite {}			{ return "Permet d'inviter un utilisateur sur un salon." }
proc ::EvaServ::help:description:inviteme {}		{
	variable config
	return "Permet de s'inviter sur $config(salon)."
}
proc ::EvaServ::help:description:kick {}			{ return "Permet de kicker un utilisateur d'un salon." }
proc ::EvaServ::help:description:kickall {}			{ return "Permet de kicker tous les utilisateurs d'un salon." }
proc ::EvaServ::help:description:kickban {}			{ return "Permet de bannir et kicker un utilisateur d'un salon." }
proc ::EvaServ::help:description:kill {}			{ return "Permet de killer un utilisateur du serveur." }
proc ::EvaServ::help:description:kline {}			{ return "Permet de kline un utilisateur du serveur." }
proc ::EvaServ::help:description:klinelist {}		{ return "Permet de voir la liste des klines."}
proc ::EvaServ::help:description:mode {}			{ return "Permet de changer les modes d'un salon." }
proc ::EvaServ::help:description:newpass {}			{ return "Permet de changer le mot de passe de votre accès." }
proc ::EvaServ::help:description:nickban {}			{ return "Permet de bannir et kicker un utilisateur d'un salon en fonction de son pseudo." }
proc ::EvaServ::help:description:op {}				{ return "Permet d'oper un utilisateur d'un salon." }
proc ::EvaServ::help:description:opall {}			{ return "Permet d'oper tous les utilisateurs d'un salon." }
proc ::EvaServ::help:description:owner {}			{ return "Permet de mêttre un utilisateur owner d'un salon." }
proc ::EvaServ::help:description:ownerall {}		{ return "Permet de mêttre tous les utilisateurs owner d'un salon." }
proc ::EvaServ::help:description:protect {}			{ return "Permet de mêttre un utilisateur protect d'un salon." }
proc ::EvaServ::help:description:protectall {}		{ return "Permet de mêttre tous les utilisateurs protect d'un salon." }
proc ::EvaServ::help:description:topic {}			{ return "Permet de changer le topic d'un salon." }
proc ::EvaServ::help:description:unban {}			{ return "Permet de débannir un mask d'un salon."}
proc ::EvaServ::help:description:ungline {}			{ return "Permet de supprimer un mask de la liste des glines." }
proc ::EvaServ::help:description:unshun {}			{ return "Permet de unshun un utilisateur du serveur." }
proc ::EvaServ::help:description:unkline {}			{ return "Permet de supprimer un mask de la liste des klines." }
proc ::EvaServ::help:description:voice {}			{ return "Permet de voicer un utilisateur d'un salon." }
proc ::EvaServ::help:description:voiceall {}		{ return "Permet de voicer tous les utilisateurs d'un salon." }
proc ::EvaServ::help:description:wallops {}			{ return "Permet d'envoyer un message en wallops à tous les utilisateurs." }
proc ::EvaServ::help:description:changline {}		{ return "Permet de gline tous les utilisateurs d'un salon." }
proc ::EvaServ::help:description:chankill {}		{ return "Permet de killer tous les utilisateurs d'un salon." }
proc ::EvaServ::help:description:chanlist {}		{ return "Permet de voir la liste des salons interdits." }
proc ::EvaServ::help:description:closeclear {}		{ return "Permet de vider la liste des salons fermés." }
proc ::EvaServ::help:description:cleargline {}		{ return "Permet de retirer tous les glines du serveur." }
proc ::EvaServ::help:description:clearkline {}		{ return "Permet de retirer tous les klines du serveur." }
proc ::EvaServ::help:description:clientlist {}		{ return "Permet de voir la liste des clients IRC interdits."}
proc ::EvaServ::help:description:closeadd {}		{ return "Permet de fermer un salon." }
proc ::EvaServ::help:description:closelist {}		{ return "Permet de voir la liste des salons fermés." }
proc ::EvaServ::help:description:hostlist {}		{ return "Permet de voir la liste des hostnames interdites." }
proc ::EvaServ::help:description:identlist {}		{ return "Permet de voir la liste des idents interdits." }
proc ::EvaServ::help:description:join {}			{
	variable config
	return "Permet de faire joindre $config(service_nick) sur un salon."
}
proc ::EvaServ::help:description:list {}			{ return "Permet de voir les autojoin salons."}
proc ::EvaServ::help:description:nicklist {}		{ return "Permet de voir la liste des pseudos interdits." }
proc ::EvaServ::help:description:notice {}			{ return "Permet d'envoyer une notice à tous les utilisateurs."}
proc ::EvaServ::help:description:part {}			{
	variable config
	return "Permet de faire partir $config(service_nick) d'un salon."
}
proc ::EvaServ::help:description:reallist {}		{ return "Permet de voir la liste des realnames interdits." }
proc ::EvaServ::help:description:say {}				{ return "Permet d'envoyer un message sur un salon." }
proc ::EvaServ::help:description:status {}			{ return "Permet de voir les informations de $config(scriptname)." }
proc ::EvaServ::help:description:svsjoin {}			{ return "Permet de forcer un utilisateur à joindre un salon." }
proc ::EvaServ::help:description:svsnick {}			{ return "Permet de changer le pseudo d'un utilisateur."}
proc ::EvaServ::help:description:svspart {}			{ return "Permet de forcer un utilisateur à partir d'un salon." }
proc ::EvaServ::help:description:trustlist {}		{ return "Permet de voir la liste des trusts." }
proc ::EvaServ::help:description:closedel {}		{ return "Permet d'ouvrir un salon fermé." }
proc ::EvaServ::help:description:accessadd {}		{ return "Permet d'ajouter un accès sur $config(scriptname)." }
proc ::EvaServ::help:description:chanadd {}			{ return "Permet d'ajouter un salon interdit." }
proc ::EvaServ::help:description:clientadd {}		{ return "Permet d'ajouter un client IRC interdit." }
proc ::EvaServ::help:description:hostadd {}			{ return "Permet d'ajouter une hostname interdite." }
proc ::EvaServ::help:description:identadd {}		{ return "Permet d'ajouter un ident interdit." }
proc ::EvaServ::help:description:nickadd {}			{ return "Permet d'ajouter un pseudo interdit." }
proc ::EvaServ::help:description:realadd {}			{ return "Permet d'ajouter un realname interdit." }
proc ::EvaServ::help:description:trustadd {}		{ return "Permet d'ajouter un trust sur un mask." }
proc ::EvaServ::help:description:backup {}			{ return "Permet de créer une sauvegarde des databases." }
proc ::EvaServ::help:description:chanlog {}			{
	variable config
	return "Permet de changer le salon de log de $config(service_nick)."
}
proc ::EvaServ::help:description:client {}			{ return "Permet d'activer ou désactiver les clients IRC interdits." }
proc ::EvaServ::help:description:console {}			{ return "Permet d'activer la console des logs en fonction du level." }
proc ::EvaServ::help:description:accessdel {}		{ return "Permet de supprimer un accès de $config(scriptname)." }
proc ::EvaServ::help:description:chandel {}			{ return "Permet de supprimer un salon interdit." }
proc ::EvaServ::help:description:clientdel {}		{ return "Permet de supprimer un client IRC interdit." }
proc ::EvaServ::help:description:hostdel {}			{ return "Permet de supprimer une hostname interdite." }
proc ::EvaServ::help:description:identdel {}		{ return "Permet de supprimer un ident interdit." }
proc ::EvaServ::help:description:nickdel {}			{ return "Permet de supprimer un pseudo interdit." }
proc ::EvaServ::help:description:realdel {}			{ return "Permet de supprimer un realname interdit." }
proc ::EvaServ::help:description:trustdel {}		{ return "Permet de supprimer le trust d'un mask." }
proc ::EvaServ::help:description:die {}				{ return "Permet d'arrêter $config(scriptname)." }
proc ::EvaServ::help:description:maxlogin {}		{ return "Permet d'activer où désactiver la protection max login." }
proc ::EvaServ::help:description:accessmod {}		{ return "Permet de modifier un accès de $config(scriptname)." }
proc ::EvaServ::help:description:protection {}		{ return "Permet d'activer la protection en fonction du level." }
proc ::EvaServ::help:description:restart {}			{ return "Permet de redémarrer $config(scriptname)." }
proc ::EvaServ::help:description:shun {}			{ return "Permet de shun un utilisateur du serveur." }


proc ::EvaServ::Commands:Help { sender hcmd } {
	variable config
	if { [::EvaServ::authed $sender $hcmd] != "ok" } { return 0 }
	switch -exact $hcmd {
		"help" {
			::EvaServ::SENT:MSG:TO:USER $sender "<b>Commande Help :</b> /msg $config(service_nick) help nom-de-la-commande"
			::EvaServ::SENT:MSG:TO:USER $sender [::EvaServ::help:description:help]
		}
		"auth" {
			::EvaServ::SENT:MSG:TO:USER $sender "<b>Commande Help :</b> /msg $config(service_nick) auth pseudo mot-de-passe"
			::EvaServ::SENT:MSG:TO:USER $sender [::EvaServ::help:description:auth]
		}
		"copyright" {
			::EvaServ::SENT:MSG:TO:USER $sender "<b>Commande Help :</b> /msg $config(service_nick) copyright"
			::EvaServ::SENT:MSG:TO:USER $sender [::EvaServ::help:description:copyright]
		}
		"deauth" {
			::EvaServ::SENT:MSG:TO:USER $sender "<b>Commande Help :</b> /msg $config(service_nick) deauth"
			::EvaServ::SENT:MSG:TO:USER $sender [::EvaServ::help:description:deauth]
		}
		"seen" {
			::EvaServ::SENT:MSG:TO:USER $sender "<b>Commande Help :</b> /msg $config(service_nick) seen pseudo"
			::EvaServ::SENT:MSG:TO:USER $sender [::EvaServ::help:description:seen]
		}
		"showcommands" {
			::EvaServ::SENT:MSG:TO:USER $sender "<b>Commande Help :</b> /msg $config(service_nick) showcommands"
			::EvaServ::SENT:MSG:TO:USER $sender [::EvaServ::help:description:showcommands]
		}
		"map" {
			::EvaServ::SENT:MSG:TO:USER $sender "<b>Commande Help :</b> /msg $config(service_nick) map"
			::EvaServ::SENT:MSG:TO:USER $sender [::EvaServ::help:description:map]
		}
		"whois" {
			::EvaServ::SENT:MSG:TO:USER $sender "<b>Commande Help :</b> /msg $config(service_nick) whois pseudo"
			::EvaServ::SENT:MSG:TO:USER $sender [::EvaServ::help:description:whois]
		}
		"shun" {
			::EvaServ::SENT:MSG:TO:USER $sender "<b>Commande Help :</b> /msg $config(service_nick) shun <pseudo ou ip> raison"
			::EvaServ::SENT:MSG:TO:USER $sender [::EvaServ::help:description:shun]
		}
		"access" {
			::EvaServ::SENT:MSG:TO:USER $sender "<b>Commande Help :</b> /msg $config(service_nick) access pseudo"
			::EvaServ::SENT:MSG:TO:USER $sender [::EvaServ::help:description:access]
		}
		"ban" {
			::EvaServ::SENT:MSG:TO:USER $sender "<b>Commande Help :</b> /msg $config(service_nick) ban #salon mask"
			::EvaServ::SENT:MSG:TO:USER $sender [::EvaServ::help:description:ban]
		}
		"clearallmodes" {
			::EvaServ::SENT:MSG:TO:USER $sender "<b>Commande Help :</b> /msg $config(service_nick) clearallmodes #salon"
			::EvaServ::SENT:MSG:TO:USER $sender [::EvaServ::help:description:clearallmodes]
		}
		"clearbans" {
			::EvaServ::SENT:MSG:TO:USER $sender "<b>Commande Help :</b> /msg $config(service_nick) clearbans #salon"
			::EvaServ::SENT:MSG:TO:USER $sender [::EvaServ::help:description:clearbans]
		}
		"clearmodes" {
			::EvaServ::SENT:MSG:TO:USER $sender "<b>Commande Help :</b> /msg $config(service_nick) clearmodes #salon"
			::EvaServ::SENT:MSG:TO:USER $sender [::EvaServ::help:description:clearmodes]
		}
		"dehalfop" {
			::EvaServ::SENT:MSG:TO:USER $sender "<b>Commande Help :</b> /msg $config(service_nick) dehalfop #salon pseudo"
			::EvaServ::SENT:MSG:TO:USER $sender [::EvaServ::help:description:dehalfop]
		}
		"dehalfopall" {
			::EvaServ::SENT:MSG:TO:USER $sender "<b>Commande Help :</b> /msg $config(service_nick) dehalfopall #salon"
			::EvaServ::SENT:MSG:TO:USER $sender [::EvaServ::help:description:dehalfopall]
		}
		"deop" {
			::EvaServ::SENT:MSG:TO:USER $sender "<b>Commande Help :</b> /msg $config(service_nick) deop #salon pseudo"
			::EvaServ::SENT:MSG:TO:USER $sender [::EvaServ::help:description:deop]
		}
		"deopall" {
			::EvaServ::SENT:MSG:TO:USER $sender "<b>Commande Help :</b> /msg $config(service_nick) deopall #salon"
			::EvaServ::SENT:MSG:TO:USER $sender [::EvaServ::help:description:deopall]
		}
		"deowner" {
			::EvaServ::SENT:MSG:TO:USER $sender "<b>Commande Help :</b> /msg $config(service_nick) deowner #salon pseudo"
			::EvaServ::SENT:MSG:TO:USER $sender [::EvaServ::help:description:deowner]
		}
		"deownerall" {
			::EvaServ::SENT:MSG:TO:USER $sender "<b>Commande Help :</b> /msg $config(service_nick) deownerall #salon"
			::EvaServ::SENT:MSG:TO:USER $sender [::EvaServ::help:description:deownerall]
		}
		"deprotect" {
			::EvaServ::SENT:MSG:TO:USER $sender "<b>Commande Help :</b> /msg $config(service_nick) deprotect #salon pseudo"
			::EvaServ::SENT:MSG:TO:USER $sender [::EvaServ::help:description:deprotect]
		}
		"deprotectall" {
			::EvaServ::SENT:MSG:TO:USER $sender "<b>Commande Help :</b> /msg $config(service_nick) deprotectall #salon"
			::EvaServ::SENT:MSG:TO:USER $sender [::EvaServ::help:description:deprotectall]
		}
		"devoice" {
			::EvaServ::SENT:MSG:TO:USER $sender "<b>Commande Help :</b> /msg $config(service_nick) devoice #salon pseudo"
			::EvaServ::SENT:MSG:TO:USER $sender [::EvaServ::help:description:devoice]
		}
		"devoiceall" {
			::EvaServ::SENT:MSG:TO:USER $sender "<b>Commande Help :</b> /msg $config(service_nick) devoiceall #salon"
			::EvaServ::SENT:MSG:TO:USER $sender [::EvaServ::help:description:devoiceall]
		}
		"gline" {
			::EvaServ::SENT:MSG:TO:USER $sender "<b>Commande Help :</b> /msg $config(service_nick) gline <pseudo ou ip> raison"
			::EvaServ::SENT:MSG:TO:USER $sender [::EvaServ::help:description:gline]
		}
		"glinelist" {
			::EvaServ::SENT:MSG:TO:USER $sender "<b>Commande Help :</b> /msg $config(service_nick) glinelist"
			::EvaServ::SENT:MSG:TO:USER $sender [::EvaServ::help:description:glinelist]
		}
		"shunlist" {
			::EvaServ::SENT:MSG:TO:USER $sender "<b>Commande Help :</b> /msg $config(service_nick) shunlist"
			::EvaServ::SENT:MSG:TO:USER $sender [::EvaServ::help:description:shunlist]
		}
		"globops" {
			::EvaServ::SENT:MSG:TO:USER $sender "<b>Commande Help :</b> /msg $config(service_nick) globops message"
			::EvaServ::SENT:MSG:TO:USER $sender [::EvaServ::help:description:globops]
		}
		"halfop" {
			::EvaServ::SENT:MSG:TO:USER $sender "<b>Commande Help :</b> /msg $config(service_nick) halfop #salon pseudo"
			::EvaServ::SENT:MSG:TO:USER $sender [::EvaServ::help:description:halfop]
		}
		"halfopall" {
			::EvaServ::SENT:MSG:TO:USER $sender "<b>Commande Help :</b> /msg $config(service_nick) halfopall #salon"
			::EvaServ::SENT:MSG:TO:USER $sender [::EvaServ::help:description:halfopall]
		}
		"invite" {
			::EvaServ::SENT:MSG:TO:USER $sender "<b>Commande Help :</b> /msg $config(service_nick) invite #salon pseudo"
			::EvaServ::SENT:MSG:TO:USER $sender [::EvaServ::help:description:invite]
		}
		"inviteme" {
			::EvaServ::SENT:MSG:TO:USER $sender "<b>Commande Help :</b> /msg $config(service_nick) inviteme"
			::EvaServ::SENT:MSG:TO:USER $sender [::EvaServ::help:description:inviteme]
		}
		"kick" {
			::EvaServ::SENT:MSG:TO:USER $sender "<b>Commande Help :</b> /msg $config(service_nick) kick #salon pseudo raison"
			::EvaServ::SENT:MSG:TO:USER $sender [::EvaServ::help:description:kick]
		}
		"kickall" {
			::EvaServ::SENT:MSG:TO:USER $sender "<b>Commande Help :</b> /msg $config(service_nick) kickall #salon"
			::EvaServ::SENT:MSG:TO:USER $sender [::EvaServ::help:description:kickall]
		}
		"kickban" {
			::EvaServ::SENT:MSG:TO:USER $sender "<b>Commande Help :</b> /msg $config(service_nick) kickban #salon pseudo raison"
			::EvaServ::SENT:MSG:TO:USER $sender [::EvaServ::help:description:kickban]
		}
		"kill" {
			::EvaServ::SENT:MSG:TO:USER $sender "<b>Commande Help :</b> /msg $config(service_nick) kill pseudo raison"
			::EvaServ::SENT:MSG:TO:USER $sender [::EvaServ::help:description:kill]
		}
		"kline" {
			::EvaServ::SENT:MSG:TO:USER $sender "<b>Commande Help :</b> /msg $config(service_nick) kline <pseudo ou ip> raison"
			::EvaServ::SENT:MSG:TO:USER $sender [::EvaServ::help:description:kline]
		}
		"klinelist" {
			::EvaServ::SENT:MSG:TO:USER $sender "<b>Commande Help :</b> /msg $config(service_nick) klinelist"
			::EvaServ::SENT:MSG:TO:USER $sender [::EvaServ::help:description:klinelist]
		}
		"mode" {
			::EvaServ::SENT:MSG:TO:USER $sender "<b>Commande Help :</b> /msg $config(service_nick) mode #salon +/-mode"
			::EvaServ::SENT:MSG:TO:USER $sender [::EvaServ::help:description:mode]
		}
		"newpass" {
			::EvaServ::SENT:MSG:TO:USER $sender "<b>Commande Help :</b> /msg $config(service_nick) newpass mot-de-passe"
			::EvaServ::SENT:MSG:TO:USER $sender [::EvaServ::help:description:newpass]
		}
		"nickban" {
			::EvaServ::SENT:MSG:TO:USER $sender "<b>Commande Help :</b> /msg $config(service_nick) nickban #salon pseudo raison"
			::EvaServ::SENT:MSG:TO:USER $sender [::EvaServ::help:description:nickban]
		}
		"op" {
			::EvaServ::SENT:MSG:TO:USER $sender "<b>Commande Help :</b> /msg $config(service_nick) op #salon pseudo"
			::EvaServ::SENT:MSG:TO:USER $sender [::EvaServ::help:description:op]
		}
		"opall" {
			::EvaServ::SENT:MSG:TO:USER $sender "<b>Commande Help :</b> /msg $config(service_nick) opall #salon"
			::EvaServ::SENT:MSG:TO:USER $sender [::EvaServ::help:description:opall]
		}
		"owner" {
			::EvaServ::SENT:MSG:TO:USER $sender "<b>Commande Help :</b> /msg $config(service_nick) owner #salon pseudo"
			::EvaServ::SENT:MSG:TO:USER $sender [::EvaServ::help:description:owner]
		}
		"ownerall" {
			::EvaServ::SENT:MSG:TO:USER $sender "<b>Commande Help :</b> /msg $config(service_nick) ownerall #salon"
			::EvaServ::SENT:MSG:TO:USER $sender [::EvaServ::help:description:ownerall]
		}
		"protect" {
			::EvaServ::SENT:MSG:TO:USER $sender "<b>Commande Help :</b> /msg $config(service_nick) protect #salon pseudo"
			::EvaServ::SENT:MSG:TO:USER $sender [::EvaServ::help:description:protect]
		}
		"protectall" {
			::EvaServ::SENT:MSG:TO:USER $sender "<b>Commande Help :</b> /msg $config(service_nick) protectall #salon"
			::EvaServ::SENT:MSG:TO:USER $sender [::EvaServ::help:description:protectall]
		}
		"topic" {
			::EvaServ::SENT:MSG:TO:USER $sender "<b>Commande Help :</b> /msg $config(service_nick) topic #salon topic"
			::EvaServ::SENT:MSG:TO:USER $sender [::EvaServ::help:description:topic]
		}
		"unban" {
			::EvaServ::SENT:MSG:TO:USER $sender "<b>Commande Help :</b> /msg $config(service_nick) unban #salon mask"
			::EvaServ::SENT:MSG:TO:USER $sender [::EvaServ::help:description:unban]
		}
		"ungline" {
			::EvaServ::SENT:MSG:TO:USER $sender "<b>Commande Help :</b> /msg $config(service_nick) ungline ident@host"
			::EvaServ::SENT:MSG:TO:USER $sender [::EvaServ::help:description:ungline]
		}
		"unshun" {
			::EvaServ::SENT:MSG:TO:USER $sender "<b>Commande Help :</b> /msg $config(service_nick) unshun pseudo raison"
			::EvaServ::SENT:MSG:TO:USER $sender [::EvaServ::help:description:unshun]
		}
		"unkline" {
			::EvaServ::SENT:MSG:TO:USER $sender "<b>Commande Help :</b> /msg $config(service_nick) unkline ident@host"
			::EvaServ::SENT:MSG:TO:USER $sender [::EvaServ::help:description:unkline]
		}

		"voice" {
			::EvaServ::SENT:MSG:TO:USER $sender "<b>Commande Help :</b> /msg $config(service_nick) voice #salon pseudo"
			::EvaServ::SENT:MSG:TO:USER $sender [::EvaServ::help:description:voice]
		}
		"voiceall" {
			::EvaServ::SENT:MSG:TO:USER $sender "<b>Commande Help :</b> /msg $config(service_nick) voiceall #salon"
			::EvaServ::SENT:MSG:TO:USER $sender [::EvaServ::help:description:voiceall]
		}
		"wallops" {
			::EvaServ::SENT:MSG:TO:USER $sender "<b>Commande Help :</b> /msg $config(service_nick) wallops message"
			::EvaServ::SENT:MSG:TO:USER $sender [::EvaServ::help:description:wallops]
		}
		"changline" {
			::EvaServ::SENT:MSG:TO:USER $sender "<b>Commande Help :</b> /msg $config(service_nick) changline #salon"
			::EvaServ::SENT:MSG:TO:USER $sender [::EvaServ::help:description:changline]
		}
		"chankill" {
			::EvaServ::SENT:MSG:TO:USER $sender "<b>Commande Help :</b> /msg $config(service_nick) chankill #salon"
			::EvaServ::SENT:MSG:TO:USER $sender [::EvaServ::help:description:chankill]
		}
		"chanlist" {
			::EvaServ::SENT:MSG:TO:USER $sender "<b>Commande Help :</b> /msg $config(service_nick) chanlist"
			::EvaServ::SENT:MSG:TO:USER $sender [::EvaServ::help:description:chanlist]
		}
		"closeclear" {
			::EvaServ::SENT:MSG:TO:USER $sender "<b>Commande Help :</b> /msg $config(service_nick) closeclear"
			::EvaServ::SENT:MSG:TO:USER $sender [::EvaServ::help:description:closeclear]
		}
		"cleargline" {
			::EvaServ::SENT:MSG:TO:USER $sender "<b>Commande Help :</b> /msg $config(service_nick) cleargline"
			::EvaServ::SENT:MSG:TO:USER $sender [::EvaServ::help:description:cleargline]
		}
		"clearkline" {
			::EvaServ::SENT:MSG:TO:USER $sender "<b>Commande Help :</b> /msg $config(service_nick) clearkline"
			::EvaServ::SENT:MSG:TO:USER $sender [::EvaServ::help:description:clearkline]
		}
		"clientlist" {
			::EvaServ::SENT:MSG:TO:USER $sender "<b>Commande Help :</b> /msg $config(service_nick) clientlist"
			::EvaServ::SENT:MSG:TO:USER $sender [::EvaServ::help:description:clientlist]
		}
		"closeadd" {
			::EvaServ::SENT:MSG:TO:USER $sender "<b>Commande Help :</b> /msg $config(service_nick) closeadd #salon"
			::EvaServ::SENT:MSG:TO:USER $sender [::EvaServ::help:description:closeadd]
		}
		"closelist" {
			::EvaServ::SENT:MSG:TO:USER $sender "<b>Commande Help :</b> /msg $config(service_nick) closelist"
			::EvaServ::SENT:MSG:TO:USER $sender [::EvaServ::help:description:closelist]
		}
		"hostlist" {
			::EvaServ::SENT:MSG:TO:USER $sender "<b>Commande Help :</b> /msg $config(service_nick) hostlist"
			::EvaServ::SENT:MSG:TO:USER $sender [::EvaServ::help:description:hostlist]
		}
		"identlist" {
			::EvaServ::SENT:MSG:TO:USER $sender "<b>Commande Help :</b> /msg $config(service_nick) identlist"
			::EvaServ::SENT:MSG:TO:USER $sender [::EvaServ::help:description:identlist]
		}
		"join" {
			::EvaServ::SENT:MSG:TO:USER $sender "<b>Commande Help :</b> /msg $config(service_nick) join #salon"
			::EvaServ::SENT:MSG:TO:USER $sender [::EvaServ::help:description:join]
		}
		"list" {
			::EvaServ::SENT:MSG:TO:USER $sender "<b>Commande Help :</b> /msg $config(service_nick) list"
			::EvaServ::SENT:MSG:TO:USER $sender [::EvaServ::help:description:list]
		}
		"nicklist" {
			::EvaServ::SENT:MSG:TO:USER $sender "<b>Commande Help :</b> /msg $config(service_nick) nicklist"
			::EvaServ::SENT:MSG:TO:USER $sender [::EvaServ::help:description:nicklist]
		}
		"notice" {
			::EvaServ::SENT:MSG:TO:USER $sender "<b>Commande Help :</b> /msg $config(service_nick) notice message"
			::EvaServ::SENT:MSG:TO:USER $sender [::EvaServ::help:description:notice]
		}
		"part" {
			::EvaServ::SENT:MSG:TO:USER $sender "<b>Commande Help :</b> /msg $config(service_nick) part #salon"
			::EvaServ::SENT:MSG:TO:USER $sender [::EvaServ::help:description:part]
		}
		"reallist" {
			::EvaServ::SENT:MSG:TO:USER $sender "<b>Commande Help :</b> /msg $config(service_nick) reallist"
			::EvaServ::SENT:MSG:TO:USER $sender [::EvaServ::help:description:reallist]
		}
		"say" {
			::EvaServ::SENT:MSG:TO:USER $sender "<b>Commande Help :</b> /msg $config(service_nick) say #salon message"
			::EvaServ::SENT:MSG:TO:USER $sender [::EvaServ::help:description:say]
		}
		"status" {
			::EvaServ::SENT:MSG:TO:USER $sender "<b>Commande Help :</b> /msg $config(service_nick) status"
			::EvaServ::SENT:MSG:TO:USER $sender [::EvaServ::help:description:status]
		}
		"svsjoin" {
			::EvaServ::SENT:MSG:TO:USER $sender "<b>Commande Help :</b> /msg $config(service_nick) svsjoin #salon pseudo"
			::EvaServ::SENT:MSG:TO:USER $sender [::EvaServ::help:description:svsjoin]
		}
		"svsnick" {
			::EvaServ::SENT:MSG:TO:USER $sender "<b>Commande Help :</b> /msg $config(service_nick) svsnick ancien-pseudo nouveau-pseudo"
			::EvaServ::SENT:MSG:TO:USER $sender [::EvaServ::help:description:svsnick]
		}
		"svspart" {
			::EvaServ::SENT:MSG:TO:USER $sender "<b>Commande Help :</b> /msg $config(service_nick) svspart #salon pseudo"
			::EvaServ::SENT:MSG:TO:USER $sender [::EvaServ::help:description:svspart]
		}
		"trustlist" {
			::EvaServ::SENT:MSG:TO:USER $sender "<b>Commande Help :</b> /msg $config(service_nick) trustlist"
			::EvaServ::SENT:MSG:TO:USER $sender [::EvaServ::help:description:trustlist]
		}
		"closedel" {
			::EvaServ::SENT:MSG:TO:USER $sender "<b>Commande Help :</b> /msg $config(service_nick) closedel #salon"
			::EvaServ::SENT:MSG:TO:USER $sender [::EvaServ::help:description:closedel]
		}
		"accessadd" {
			::EvaServ::SENT:MSG:TO:USER $sender "<b>Commande Help :</b> /msg $config(service_nick) accessadd pseudo password level"
			::EvaServ::SENT:MSG:TO:USER $sender [::EvaServ::help:description:accessadd]
		}
		"chanadd" {
			::EvaServ::SENT:MSG:TO:USER $sender "<b>Commande Help :</b> /msg $config(service_nick) chanadd #salon"
			::EvaServ::SENT:MSG:TO:USER $sender [::EvaServ::help:description:chanadd]
		}
		"clientadd" {
			::EvaServ::SENT:MSG:TO:USER $sender "<b>Commande Help :</b> /msg $config(service_nick) clientadd version"
			::EvaServ::SENT:MSG:TO:USER $sender [::EvaServ::help:description:clientadd]
		}
		"hostadd" {
			::EvaServ::SENT:MSG:TO:USER $sender "<b>Commande Help :</b> /msg $config(service_nick) hostadd hostname"
			::EvaServ::SENT:MSG:TO:USER $sender [::EvaServ::help:description:hostadd]
		}
		"identadd" {
			::EvaServ::SENT:MSG:TO:USER $sender "<b>Commande Help :</b> /msg $config(service_nick) identadd ident"
			::EvaServ::SENT:MSG:TO:USER $sender [::EvaServ::help:description:identadd]
		}
		"nickadd" {
			::EvaServ::SENT:MSG:TO:USER $sender "<b>Commande Help :</b> /msg $config(service_nick) nickadd pseudo"
			::EvaServ::SENT:MSG:TO:USER $sender [::EvaServ::help:description:nickadd]
		}
		"realadd" {
			::EvaServ::SENT:MSG:TO:USER $sender "<b>Commande Help :</b> /msg $config(service_nick) realadd realname"
			::EvaServ::SENT:MSG:TO:USER $sender [::EvaServ::help:description:realadd]
		}
		"trustadd" {
			::EvaServ::SENT:MSG:TO:USER $sender "<b>Commande Help :</b> /msg $config(service_nick) trustadd mask"
			::EvaServ::SENT:MSG:TO:USER $sender [::EvaServ::help:description:trustadd]
		}
		"backup" {
			::EvaServ::SENT:MSG:TO:USER $sender "<b>Commande Help :</b> /msg $config(service_nick) backup"
			::EvaServ::SENT:MSG:TO:USER $sender [::EvaServ::help:description:backup]
		}
		"chanlog" {
			::EvaServ::SENT:MSG:TO:USER $sender "<b>Commande Help :</b> /msg $config(service_nick) chanlog #salon"
			::EvaServ::SENT:MSG:TO:USER $sender [::EvaServ::help:description:chanlog]
		}
		"client" {
			::EvaServ::SENT:MSG:TO:USER $sender "<b>Commande Help :</b> /msg $config(service_nick) client on/off"
			::EvaServ::SENT:MSG:TO:USER $sender [::EvaServ::help:description:client]
		}
		"console" {
			::EvaServ::SENT:MSG:TO:USER $sender "<b>Commande Help :</b> /msg $config(service_nick) console 0/1/2/3"
			::EvaServ::SENT:MSG:TO:USER $sender "<c02>Level 0 <c04>:<c01> Aucune console"
			::EvaServ::SENT:MSG:TO:USER $sender "<c02>Level 1 <c04>:<c01> Console commande"
			::EvaServ::SENT:MSG:TO:USER $sender "<c02>Level 2 <c04>:<c01> Console commande & connexion & déconnexion"
			::EvaServ::SENT:MSG:TO:USER $sender "<c02>Level 3 <c04>:<c01> Toutes les consoles"
			::EvaServ::SENT:MSG:TO:USER $sender [::EvaServ::help:description:console]
		}
		"accessdel" {
			::EvaServ::SENT:MSG:TO:USER $sender "<b>Commande Help :</b> /msg $config(service_nick) accessdel pseudo"
			::EvaServ::SENT:MSG:TO:USER $sender [::EvaServ::help:description:accessdel]
		}
		"chandel" {
			::EvaServ::SENT:MSG:TO:USER $sender "<b>Commande Help :</b> /msg $config(service_nick) chandel #salon"
			::EvaServ::SENT:MSG:TO:USER $sender [::EvaServ::help:description:chandel]
		}
		"clientdel" {
			::EvaServ::SENT:MSG:TO:USER $sender "<b>Commande Help :</b> /msg $config(service_nick) clientdel version"
			::EvaServ::SENT:MSG:TO:USER $sender [::EvaServ::help:description:clientdel]
		}
		"hostdel" {
			::EvaServ::SENT:MSG:TO:USER $sender "<b>Commande Help :</b> /msg $config(service_nick) hostdel hostname"
			::EvaServ::SENT:MSG:TO:USER $sender [::EvaServ::help:description:hostdel]
		}
		"identdel" {
			::EvaServ::SENT:MSG:TO:USER $sender "<b>Commande Help :</b> /msg $config(service_nick) identdel ident"
			::EvaServ::SENT:MSG:TO:USER $sender [::EvaServ::help:description:identdel]
		}
		"nickdel" {
			::EvaServ::SENT:MSG:TO:USER $sender "<b>Commande Help :</b> /msg $config(service_nick) nickdel pseudo"
			::EvaServ::SENT:MSG:TO:USER $sender [::EvaServ::help:description:nickdel]
		}
		"realdel" {
			::EvaServ::SENT:MSG:TO:USER $sender "<b>Commande Help :</b> /msg $config(service_nick) realdel realname"
			::EvaServ::SENT:MSG:TO:USER $sender [::EvaServ::help:description:realdel]
		}
		"trustdel" {
			::EvaServ::SENT:MSG:TO:USER $sender "<b>Commande Help :</b> /msg $config(service_nick) trustdel mask"
			::EvaServ::SENT:MSG:TO:USER $sender [::EvaServ::help:description:trustdel]
		}
		"die" {
			::EvaServ::SENT:MSG:TO:USER $sender "<b>Commande Help :</b> /msg $config(service_nick) die"
			::EvaServ::SENT:MSG:TO:USER $sender [::EvaServ::help:description:die]
		}
		"maxlogin" {
			::EvaServ::SENT:MSG:TO:USER $sender "<b>Commande Help :</b> /msg $config(service_nick) maxlogin on/off"
			::EvaServ::SENT:MSG:TO:USER $sender [::EvaServ::help:description:maxlogin]
		}
		"accessmod" {
			::EvaServ::SENT:MSG:TO:USER $sender "<b>Commande Help :</b> /msg $config(service_nick) accessmod pass pseudo mot-de-passe"
			::EvaServ::SENT:MSG:TO:USER $sender "<b>Commande Help :</b> /msg $config(service_nick) accessmod level pseudo level"
			::EvaServ::SENT:MSG:TO:USER $sender [::EvaServ::help:description:accessmod]
		}
		"protection" {
			::EvaServ::SENT:MSG:TO:USER $sender "<b>Commande Help :</b> /msg $config(service_nick) protection 0/1/2/3/4"
			::EvaServ::SENT:MSG:TO:USER $sender "<c02>Level 0 <c04>:<c01> Aucune Protection"
			::EvaServ::SENT:MSG:TO:USER $sender "<c02>Level 1 <c04>:<c01> Protection Admins"
			::EvaServ::SENT:MSG:TO:USER $sender "<c02>Level 2 <c04>:<c01> Protection Admins + Ircops"
			::EvaServ::SENT:MSG:TO:USER $sender "<c02>Level 3 <c04>:<c01> Protection Admins + Ircops + Géofronts"
			::EvaServ::SENT:MSG:TO:USER $sender "<c02>Level 4 <c04>:<c01> Protection de tous les accès"
			::EvaServ::SENT:MSG:TO:USER $sender [::EvaServ::help:description:protection]
		}
		"restart" {
			::EvaServ::SENT:MSG:TO:USER $sender "<b>Commande Help :</b> /msg $config(service_nick) restart"
			::EvaServ::SENT:MSG:TO:USER $sender [::EvaServ::help:description:restart]
		}
	}
}

#################
# Eva Connexion #
#################

proc ::EvaServ::connexion:server { } {
	variable config
	::EvaServ::sent2socket "EOS"
	::EvaServ::sent2socket ":$config(SID) SQLINE $config(service_nick) :Reserved for services"
	::EvaServ::sent2socket ":$config(SID) UID $config(service_nick) 1 [unixtime] $config(ident) $config(host) $config(server_id) * +qioS * * * :$config(real)"
	::EvaServ::sent2socket ":$config(SID) SJOIN [unixtime] $config(salon) + :$config(server_id)"
	::EvaServ::sent2socket ":$config(SID) MODE $config(salon) +$config(smode)"
	for { set i		0 } { $i < [string length $config(cmode)] } { incr i } {
		set tmode		[string index $config(cmode) $i]
		if { $tmode == "q" || $tmode == "a" || $tmode == "o" || $tmode == "h" || $tmode == "v" } {
			::EvaServ::FCT:SENT:MODE $config(salon) "+$tmode" $config(server_id)
		}
	}
	catch { open "[::EvaServ::Script:Get:Directory]db/chan.db" r } autojoin
	while { ![eof $autojoin] } {
		gets $autojoin salon;
		if { $salon != "" } {
			::EvaServ::sent2socket ":$config(server_id) JOIN $salon";
			if { $config(cmode) == "q" || $config(cmode) == "a" || $config(cmode) == "o" || $config(cmode) == "h" || $config(cmode) == "v" } {
				::EvaServ::FCT:SENT:MODE $salon "+$config(cmode)" $config(server_id)
			}
		}
	}
	catch { close $autojoin }
	catch { open "[::EvaServ::Script:Get:Directory]db/close.db" r } ferme
	while { ![eof $ferme] } {
		gets $ferme salle;
		if { $salle != "" } {
			::EvaServ::sent2socket ":$config(server_id) JOIN $salle";
			::EvaServ::FCT:SENT:MODE $salle "+sntio" $config(service_nick);
			::EvaServ::FCT:SET:TOPIC $salle "<c1>Salon Fermé le [::EvaServ::duree [unixtime]]";
			::EvaServ::sent2socket ":$config(link) NAMES $salle"
		}
	}
	catch { close $ferme }
	incr config(counter) 1
	utimer $config(timerco) ::EvaServ::verif
}

proc ::EvaServ::verif { } {
	variable config
	if { [valididx $config(idx)] } {
		utimer $config(timerco) ::EvaServ::verif
	} else {
		if { $config(counter)<="10" } {
			::EvaServ::config
			::EvaServ::connexion
		} else {
			foreach kill [utimers] {
				if { [lindex $kill 1] == "::EvaServ::verif" } { killutimer [lindex $kill 2] }
			}
			if { [info exists config(idx)] } { unset config(idx)		}
		}
	}
}

proc remove_modenicklist { data } {
	return [::tcl::string::map -nocase {
		"@" "" "&" "" "+" "" "~" "" "%" ""
	} $data]
}

proc ::EvaServ::link { idx arg } {
	variable config
	variable commands
	variable admins
	variable netadmin
	variable vhost
	variable protect
	variable users
	variable trust
	variable UID_DB
	variable scoredb
	variable DBU_INFO
	if { $config(sdebug) } { putlog "Received: $arg" }
	set arg	[split $arg]
	if { $config(debug) == 1 } {
		::EvaServ::putdebug "[join [lrange $arg 0 end]]"
	}
	set user		[::EvaServ::FCT:DATA:TO:NICK [string trim [lindex $arg 0] :]]
	set vuser		[string tolower $user]
	switch -exact [lindex $arg 0] {
		"PING" {
			set config(counter)		0
			::EvaServ::sent2socket "PONG [lindex $arg 1]"
		}
		"NETINFO" {
			set config(netinfo)		[lindex $arg 4]
			set config(network)		[lindex $arg 8]
			::EvaServ::sent2socket "NETINFO 0 [unixtime] 0 $config(netinfo) 0 0 0 $config(network)"
		}
		"SQUIT" {
			set serv		[lindex $arg 1]
			if { [::EvaServ::console 2] == "ok" && $config(init) == 0 } {
				::EvaServ::SHOW:INFO:TO:CHANLOG "Unlink" "$serv"
			}
		}
		"SERVER" {
			# Received: SERVER irc.xxx.net 1 :U5002-Fhn6OoEmM-001 Serveur networkname
			set config(ircdservname)	[lindex $arg 1]
			set desc		[join [string trim [lrange $arg 3 end] :]]
			# set serv		[lindex $arg 2]
			# set desc		[join [string trim [lrange $arg 4 end] :]]
			if { $config(init) == 1 } {
				::EvaServ::connexion:server
			}
		}

	}
	switch -exact [lindex $arg 1] {
		"MD"	{
			#:001 MD client 001E6A4GK certfp :023f2eae234f23fed481be360d744e99df957f.....
			if { [::EvaServ::console 2] == "ok" && $config(init) == 0 } {
				set user	[::EvaServ::FCT:DATA:TO:NICK [lindex $arg 3]]
				set certfp	[string trim [string tolower [join [lrange $arg 5 end]]] :]
				::EvaServ::SHOW:INFO:TO:CHANLOG "Client CertFP" "$user ($certfp)"
			}

		}
		"REPUTATION"	{
			#:001 REPUTATION xxx.xxx.xxx.xxx 373
			if { [::EvaServ::console 2] == "ok" && $config(init) == 0 } {
				set host	[lindex $arg 2]
				set score	[lindex $arg 3]
				set scoredb($host) $score
				set scoredb(last) "$host|$score"
				#::EvaServ::SHOW:INFO:TO:CHANLOG "Réputation" "score $score ($host)"
			}
		}

		"UID"		{
			set SID				[string range [lindex $arg 0] 1 end]
			set nickname		[lindex $arg 2]
			set nickname2		[string tolower [lindex $arg 2]]
			set hopcount		[lindex $arg 3]
			set timestamp		[lindex $arg 4]
			set username		[lindex $arg 5]
			set hostname		[lindex $arg 6]
			set uid				[string toupper [lindex $arg 7]]
			set servicestamp	[lindex $arg 8]
			set umodes			[lindex $arg 9]
			set virthost		[lindex $arg 10]
			set cloakedhost		[lindex $arg 11]
			set ip				[lindex $arg 12]
			set gecos			[string trim [string tolower [join [lrange $arg 13 end]]] :]

			set UID_DB([string		toupper $nickname])	$uid
			set UID_DB([string		toupper $uid])		$nickname

			if { ![info exists vhost($nickname2)] } { set vhost($nickname2)		$hostname }

			# Genere une base USER infos:
			if { ![info exists DBU_INFO($uid,VHOST)] }		{ set DBU_INFO($uid,VHOST)		$hostname }
			if { ![info exists DBU_INFO($uid,IDENT)] }		{ set DBU_INFO($uid,IDENT)		$username }
			if { ![info exists DBU_INFO($uid,NICK)] }		{ set DBU_INFO($uid,NICK)		$nickname }
			if { ![info exists DBU_INFO($uid,REALNAME)] }	{ set DBU_INFO($uid,REALNAME)	$gecos }
			

			if { ![info exists users($nickname)] && [string match *+*S* $umodes] } {
				set users($nickname)		on
			}
			if { ![info exists users($nickname)] } { 
				::EvaServ::connexion:user:security:check $nickname $hostname $username $gecos
			}
			if { [string match *+*z* $umodes] } {
				set stype		"Connexion SSL"
			} else {
				set stype		"Connexion"
			}
			if { [::EvaServ::console 2] == "ok" && $config(init) == 0 } {
				set MSG_CONNECT		"[::EvaServ::DBU:GET $uid NICK]"
				append MSG_CONNECT	" ([::EvaServ::DBU:GET $uid IDENT]@[::EvaServ::DBU:GET $uid VHOST]) "
				append MSG_CONNECT	"- Serveur : $config(ircdservname) "
				if { $scoredb(last) != "" } {
					if { ![info exists DBU_INFO($uid,REPUTATION)] } {
						set TMP	[split $scoredb(last) "|"]
						set DBU_INFO($uid,IP)			[lindex $TMP 0]
						set DBU_INFO($uid,REPUTATION)	[lindex $TMP 1]
					}
					append MSG_CONNECT	"- Score: [::EvaServ::DBU:GET $uid REPUTATION] "
				}
				append MSG_CONNECT	"- realname: [::EvaServ::DBU:GET $uid REALNAME] "
				::EvaServ::SHOW:INFO:TO:CHANLOG $stype $MSG_CONNECT
			}
		}
		"219" {
			if { ![info exists config(aff)] && $config(cmd) == "gline" } {
				::EvaServ::SENT:MSG:TO:USER "$config(rep)" "Aucun Gline"
			}
			if { ![info exists config(aff)] && $config(cmd) == "shun" } {
				::EvaServ::SENT:MSG:TO:USER "$config(rep)" "Aucun shun"
			}
			if { ![info exists config(aff)] && $config(cmd) == "kline" } {
				::EvaServ::SENT:MSG:TO:USER "$config(rep)" "Aucun Kline"
			}
			if { [info exists config(cmd)] } { unset config(cmd)		}
			if { [info exists config(rep)] } { unset config(rep)		}
			if { [info exists config(aff)] } { unset config(aff)		}
		}
		"223" {
			set host		[lindex $arg 4]
			set auteur		[lindex $arg 7]
			set raison		[join [string trim [lrange $arg 8 end] :]]
			if { $config(cmd) == "gline" } {
				if { ![info exists config(aff)] } {
					set config(aff)		1
					::EvaServ::SENT:MSG:TO:USER "$config(rep)" "<b><c1,1>---------------------- <c0>Liste des Glines <c1>----------------------"
					::EvaServ::SENT:MSG:TO:USER "$config(rep)" "<b>"
				}
				::EvaServ::SENT:MSG:TO:USER "$config(rep)" "Host \[<c03> $host <c01>\] | Auteur \[<c03> $auteur <c01>\] | Raison \[<c03> $raison <c01>\]"
			} elseif { $config(cmd) == "shun" } {
				if { ![info exists config(aff)] } {
					set config(aff)		1
					::EvaServ::SENT:MSG:TO:USER "$config(rep)" "<b><c1,1>---------------------- <c0>Liste des Shuns <c1>----------------------"
					::EvaServ::SENT:MSG:TO:USER "$config(rep)" "<b>"
				}
				::EvaServ::SENT:MSG:TO:USER "$config(rep)" "Host \[<c03> $host <c01>\] | Auteur \[<c03> $auteur <c01>\] | Raison \[<c03> $raison <c01>\]"
			} elseif { $config(cmd) == "kline" } {
				if { ![info exists config(aff)] } {
					set config(aff)		1
					::EvaServ::SENT:MSG:TO:USER "$config(rep)" "<b><c1,1>---------------------- <c0>Liste des Klines <c1>----------------------"
					::EvaServ::SENT:MSG:TO:USER "$config(rep)" "<b>"
				}
				::EvaServ::SENT:MSG:TO:USER "$config(rep)" "Host \[<c03> $host <c01>\] | Auteur \[<c03> $auteur <c01>\] | Raison \[<c03> $raison <c01>\]"
			} elseif { $config(cmd) == "cleargline" } {
				::EvaServ::sent2socket ":$config(link) TKL - G [lindex [split $host @] 0] [lindex [split $host @] 1] $config(service_nick)"
			} elseif { $config(cmd) == "clearkline" } {
				::EvaServ::sent2socket ":$config(link) TKL - k [lindex [split $host @] 0] [lindex [split $host @] 1] $config(service_nick)"
			}
		}
		"307" {
			::EvaServ::SENT:MSG:TO:USER "$config(rep)" "<c01> \[<c03> NickServ <c01>\] <c02> Oui"
		}
		"487" {
			::EvaServ::SENT:MSG:TO:USER "$config(salon)" "<c01> \[<c03> ERREUR <c01>\] <c02> $arg"
		}
		"310" {
			::EvaServ::SENT:MSG:TO:USER "$config(rep)" "<c01> \[<c03> Helpeur <c01>\] <c02> Oui"
		}
		"311" {
			set nick		[lindex $arg 3]
			set ident		[lindex $arg 4]
			set host		[lindex $arg 5]
			set real		[join [string trim [lrange $arg 7 end] :]]
			::EvaServ::SENT:MSG:TO:USER "$config(rep)" "<b><c1,1>------------------------------ <c0>Whois <c1>------------------------------"
			::EvaServ::SENT:MSG:TO:USER "$config(rep)" "<b>"
			::EvaServ::SENT:MSG:TO:USER "$config(rep)" "<c01> \[<c03> Pseudo <c01>\] <c02> $nick"
			::EvaServ::SENT:MSG:TO:USER "$config(rep)" "<c01> \[<c03> Nom Réel <c01>\] <c02> $real"
			::EvaServ::SENT:MSG:TO:USER "$config(rep)" "<c01> \[<c03> Host <c01>\] <c02> $ident@$host"
		}
		"312" {
			set serveur		[lindex $arg 4]
			set desc		[join [string trim [lrange $arg 5 end] :]]
			::EvaServ::SENT:MSG:TO:USER "$config(rep)" "<c01> \[<c03> Serveur <c01>\] <c02> $serveur ($desc)"
		}
		"313" {
			set grade		[join [lrange $arg 6 end]]
			::EvaServ::SENT:MSG:TO:USER "$config(rep)" "<c01> \[<c03> Grade <c01>\] <c02> $grade"
		}
		"317" {
			set idle		[lindex $arg 4]
			::EvaServ::SENT:MSG:TO:USER "$config(rep)" "<c01> \[<c03> Idle <c01>\] <c02> [duration $idle]"
		}
		"318" {
			if { [info exists config(rep)] } { unset config(rep)		}
		}
		"319" {
			set salon		[join [string trim [lrange $arg 4 end] :]]
			::EvaServ::SENT:MSG:TO:USER "$config(rep)" "<c01> \[<c03> Salon <c01>\] <c02> $salon"
		}
		"320" {
			set swhois		[join [string trim [lrange $arg 4 end] :]]
			::EvaServ::SENT:MSG:TO:USER "$config(rep)" "<c01> \[<c03> Swhois <c01>\] <c02> $swhois"
		}
		"324" {
			set chan		[lindex $arg 3]
			set mode		[join [string trimleft [lrange $arg 4 end] +]]
			::EvaServ::FCT:SENT:MODE $chan "-$mode"
		}
		"335" {
			::EvaServ::SENT:MSG:TO:USER "$config(rep)" "<c01> \[<c03> Robot <c01>\] <c02> Oui"
		}
		"353" {

			set userliste		[string trim [string tolower [lrange $arg 5 end]] :]
			set userliste2		[string trim [lrange $arg 5 end] :]
			set chan		[lindex $arg 4]
			set user		[remove_modenicklist [lrange $userliste 0 end-1]]

			set user2		[remove_modenicklist $userliste2]
			set nblistenick		[llength [split $user]]
			#set ident		[lindex $arg 4]
			#set host		[lindex $arg 5]

			foreach n [split $user] {
				if { $config(cmd) == "ownerall" && \
					![info exists users($n)] && \
						$n!=[string tolower $config(service_nick)] && \
						![info exists admins($n)] && \
						[::EvaServ::protection $n $config(protection)] != "ok"
				} {
				::EvaServ::FCT:SENT:MODE $chan "+q" $n
			} elseif {
				$config(cmd) == "deownerall" && \
					![info exists users($n)] && \
					$n!=[string tolower $config(service_nick)] && \
					![info exists admins($n)] && \
					[::EvaServ::protection $n $config(protection)] != "ok"
			} {
				::EvaServ::FCT:SENT:MODE $chan "-q" $n
			} elseif {
				$config(cmd) == "protectall" && \
					![info exists users($n)] && \
					$n!=[string tolower $config(service_nick)] && \
					![info exists admins($n)] && \
					[::EvaServ::protection $n $config(protection)] != "ok"
			} {
				::EvaServ::FCT:SENT:MODE $chan "+a" $n
			} elseif {
				$config(cmd) == "deprotectall" && \
					![info exists users($n)] && \
					$n!=[string tolower $config(service_nick)] && \
					![info exists admins($n)] && \
					[::EvaServ::protection $n $config(protection)] != "ok"
			} {
				::EvaServ::FCT:SENT:MODE $chan "-a" $n
			} elseif {
				$config(cmd) == "opall" && \
					![info exists users($n)] && \
					$n!=[string tolower $config(service_nick)] && \
					![info exists admins($n)] && \
					[::EvaServ::protection $n $config(protection)] != "ok"
			} {
				::EvaServ::FCT:SENT:MODE $chan "+o" $n
			} elseif {
				$config(cmd) == "deopall" && \
					![info exists users($n)] && \
					$n!=[string tolower $config(service_nick)] && \
					![info exists admins($n)] && \
					[::EvaServ::protection $n $config(protection)] != "ok"
			} {
				::EvaServ::FCT:SENT:MODE $chan "-o" $n
			} elseif {
				$config(cmd) == "halfopall" && \
					![info exists users($n)] && \
					$n!=[string tolower $config(service_nick)] && \
					![info exists admins($n)] && \
					[::EvaServ::protection $n $config(protection)] != "ok"
			} {
				::EvaServ::FCT:SENT:MODE $chan "+h" $n
			} elseif {
				$config(cmd) == "dehalfopall" && \
					![info exists users($n)] && \
					$n!=[string tolower $config(service_nick)] && \
					![info exists admins($n)] && \
					[::EvaServ::protection $n $config(protection)] != "ok"
			} {
				::EvaServ::FCT:SENT:MODE $chan "-h" $n
			} elseif {
				$config(cmd) == "voiceall" && \
					![info exists users($n)] && \
					$n!=[string tolower $config(service_nick)] && \
					![info exists admins($n)] && \
					[::EvaServ::protection $n $config(protection)] != "ok"
			} {
				::EvaServ::FCT:SENT:MODE $chan "+v" $n
			} elseif {
				$config(cmd) == "devoiceall" && \
					![info exists users($n)] && \
					$n!=[string tolower $config(service_nick)] && \
					![info exists admins($n)] && \
					[::EvaServ::protection $n $config(protection)] != "ok"
			} {
				::EvaServ::FCT:SENT:MODE $chan "-v" $n
			} elseif {
				$config(cmd) == "kickall" && \
					![info exists users($n)] && \
					$n!=[string tolower $config(service_nick)] && \
					![info exists admins($n)] && \
					[::EvaServ::protection $n $config(protection)] != "ok"
			} {

				::EvaServ::sent2socket ":$config(server_id) KICK $chan $n Kicked [::EvaServ::rnick $config(rep)]"
			} elseif {
				$config(cmd) == "chankill" && \
					![info exists users($n)] && \
					$n!=[string tolower $config(service_nick)] && \
					![info exists admins($n)] && \
					[::EvaServ::protection $n $config(protection)] != "ok" && [::EvaServ::protection $n $config(protection)] != "ok"
			} {
				::EvaServ::sent2socket ":$config(server_id) KILL $n Chan Killed [::EvaServ::rnick $config(rep)]";
				::EvaServ::refresh $n
			} elseif {
				$config(cmd) == "changline" && \
					![info exists users($n)] && \
					$n!=[string tolower $config(service_nick)] && \
					![info exists admins($n)] && \
					[::EvaServ::protection $n $config(protection)] != "ok" && [::EvaServ::protection $n $config(protection)] != "ok"
			} {
				::EvaServ::sent2socket ":$config(link) TKL + G * $vhost($n) $config(service_nick) [expr [unixtime] + $config(duree)] [unixtime] :Chan Glined [::EvaServ::rnick $config(rep)] (Expire le [::EvaServ::duree [expr [unixtime] + $config(duree)]])"
			} elseif {
				$config(cmd) == "badchan" && \
					![info exists users($n)] && \
					$n!=[string tolower $config(service_nick)] && \
					![info exists admins($n)] && \
					[::EvaServ::protection $n $config(protection)] != "ok"
			} {
				::EvaServ::sent2socket ":$config(server_id) KICK $chan $n Salon Interdit"
			} elseif {
				$config(cmd) == "closeadd" && \
					![info exists users($n)] && \
					$n!=[string tolower $config(service_nick)] && \
					![info exists admins($n)] && \
					[::EvaServ::protection $n $config(protection)] != "ok"
			} {
				if { [info exists config(rep)] } {
					::EvaServ::sent2socket ":$config(server_id) KICK $chan $n Closed [::EvaServ::rnick $config(rep)]"
				} else {
					::EvaServ::sent2socket ":$config(server_id) KICK $chan $n Closed"
				}

			}
		}
	}
	"364" {
		set serv		[lindex $arg 3]
		set desc		[join [lrange $arg 6 end]]
		if { ![info exists config(aff)] } {
			set config(aff)		1
			::EvaServ::SENT:MSG:TO:USER "$config(rep)" "<b><c1,1>--------------------------------- <c0>Map du Réseau <c1>---------------------------------"
			::EvaServ::SENT:MSG:TO:USER "$config(rep)" "<b>"
		}
		::EvaServ::SENT:MSG:TO:USER "$config(rep)" "<c01>Serveur \[<c04> $serv <c01>\] <c> Description \[<c03> $desc <c01>\]"
	}
	"365" {
		if { [info exists config(aff)] } { unset config(aff)		}
		if { [info exists config(rep)] } { unset config(rep)		}
	}
	"378" {
		set host		[lindex $arg 7]
		set ip		[lindex $arg 8]
		::EvaServ::SENT:MSG:TO:USER "$config(rep)" "<c01> \[<c03> Host Décodé <c01>\] <c02> $host"
		if { [info exists $ip] } {
			::EvaServ::SENT:MSG:TO:USER "$config(rep)" "<c01> \[<c03> Ip <c01>\] <c02> $ip"
		}
	}
	"671" {
		::EvaServ::SENT:MSG:TO:USER "$config(rep)" "<c01> \[<c03> SSL <c01>\] <c02> Oui"
	}
	"SERVER" {
		set serv		[lindex $arg 2]
		set desc		[join [string trim [lrange $arg 4 end] :]]
		if { [::EvaServ::console 2] == "ok" && $config(init) == 0 } {
			::EvaServ::SHOW:INFO:TO:CHANLOG "Link" "$serv : $desc"
		}
	}
	"NOTICE" {
		#Received: :001FKJTPQ NOTICE 00CAAAAAB :VERSION HexChat 2.14.2 / Linux 5.4.0-66-generic [x86_64/1,30GHz/SMP]
		set version		[string trim [lindex $arg 3] :]
		set vdata		[string trim [join [lrange $arg 4 end]] \001]
		if { [::EvaServ::FloodControl:Check $vuser] != "ok" } { return 0 }
		if { $config(aclient) == 1 && $version == "\001VERSION" } {
			::EvaServ::SHOW:INFO:TO:CHANLOG "Client Version" "$vuser : $vdata"
			catch { open [::EvaServ::Script:Get:Directory]db/client.db r } vcli
			while { ![eof $vcli] } {
				gets $vcli verscli
				if {$verscli != "" } { continue }
				if { [string match *$verscli* $vdata] } {
					if { [::EvaServ::console 3] == "ok" && $config(init) == 0 } {
						::EvaServ::SHOW:INFO:TO:CHANLOG "Kill" "$user a été killé : $config(rclient)"
					}
					::EvaServ::sent2socket ":$config(server_id) KILL $vuser $config(rclient)";
					::EvaServ::refresh $vuser
					break
				}
			}
			catch { close $vcli }
		}
	}
	"MODE" {
		set chan		[lindex $arg 2]
		set vchan		[string tolower [lindex $arg 2]]
		set umode		[lindex $arg 3]
		set pmode		[join [lrange $arg 4 end]]
		set unix		[lindex $arg end]
		if {
			[::EvaServ::console 3] == "ok" && \
				$vchan!=[string tolower $config(salon)] && \
				$config(init) == 0 && \
				[string tolower $user]!=[string tolower $config(service_nick)]
		} {
			if {[regexp "^\[0-9\]\{10\}" $unix]} {
				set smode		[string trim $pmode $unix]
				::EvaServ::SHOW:INFO:TO:CHANLOG "Mode" "$user applique le mode $umode $smode sur $chan"
			} else {
				::EvaServ::SHOW:INFO:TO:CHANLOG "Mode" "$user applique le mode $umode $pmode sur $chan"
			}
		}
	}
	"UMODE2" {
		set umode		[lindex $arg 2]
		if { ![info exists users($user)] && [string match *+*S* $umode] } { set users($user)		on }
		if { ![info exists netadmin($user)] && [string match *+*N* $umode] } { set netadmin($user)		on }
		if { [info exists netadmin($user)] && [string match *-*N* $umode] } { unset netadmin($user)		}
		if { [::EvaServ::console 3] == "ok" && $config(init) == 0 } {
			if { [string match *+*S* $umode] } {
				::EvaServ::SHOW:INFO:TO:CHANLOG "Usermode" "$user est un Service Réseau"
			} elseif { [string match *-*S* $umode] } {
				::EvaServ::SHOW:INFO:TO:CHANLOG "Usermode" "$user n'est plus un Service Réseau"
			} elseif { [string match *+*N* $umode] } {
				::EvaServ::SHOW:INFO:TO:CHANLOG "Usermode" "$user est un Administrateur Réseau"
			} elseif { [string match *-*N* $umode] } {
				::EvaServ::SHOW:INFO:TO:CHANLOG "Usermode" "$user n'est plus un Administrateur Réseau"
			} elseif { [string match *+*A* $umode] } {
				::EvaServ::SHOW:INFO:TO:CHANLOG "Usermode" "$user est un Administrateur Serveur"
			} elseif { [string match *-*A* $umode] } {
				::EvaServ::SHOW:INFO:TO:CHANLOG "Usermode" "$user n'est plus un Administrateur Serveur"
			} elseif { [string match *+*a* $umode] } {
				::EvaServ::SHOW:INFO:TO:CHANLOG "Usermode" "$user est un Administrateur Services"
			} elseif { [string match *-*a* $umode] } {
				::EvaServ::SHOW:INFO:TO:CHANLOG "Usermode" "$user n'est plus un Administrateur Services"
			} elseif { [string match *+*C* $umode] } {
				::EvaServ::SHOW:INFO:TO:CHANLOG "Usermode" "$user est un Co-Administrateur"
			} elseif { [string match *-*C* $umode] } {
				::EvaServ::SHOW:INFO:TO:CHANLOG "Usermode" "$user n'est plus un Co-Administrateur"
			} elseif { [string match *+*o* $umode] } {
				::EvaServ::SHOW:INFO:TO:CHANLOG "Usermode" "$user est un IRC Opérateur Global"
			} elseif { [string match *-*o* $umode] } {
				::EvaServ::SHOW:INFO:TO:CHANLOG "Usermode" "$user n'est plus un IRC Opérateur Global"
			} elseif { [string match *+*O* $umode] } {
				::EvaServ::SHOW:INFO:TO:CHANLOG "Usermode" "$user est un IRC Opérateur Local"
			} elseif { [string match *-*O* $umode] } {
				::EvaServ::SHOW:INFO:TO:CHANLOG "Usermode" "$user n'est plus un IRC Opérateur Local"
			} elseif { [string match *+*h* $umode] } {
				::EvaServ::SHOW:INFO:TO:CHANLOG "Usermode" "$user est un Helpeur"
			} elseif { [string match *-*h* $umode] } {
				::EvaServ::SHOW:INFO:TO:CHANLOG "Usermode" "$user n'est plus un Helpeur"
			}
		}
	}
	"NICK" {
		set new			[lindex $arg 2]
		set vnew		[string tolower [lindex $arg 2]]
		
		set NICK_NEW	[lindex $arg 2]
		set NICK_OLD	[::EvaServ::FCT:DATA:TO:NICK [string trim [lindex $arg 0] :]]
		set UID			[::EvaServ::UID:CONVERT $vuser]
		set UID_DB([string toupper $UID])		$NICK_NEW
		set UID_DB([string toupper $NICK_NEW])	$UID
		set	unset UID_DB([string toupper $NICK_OLD])

		# [21:54:07] Received: :001PSYE4B NICK Amand[CoucouHibou] 1616792047
		if { [info exists users($vuser)] && $vuser!=$vnew } {
			set users($vnew)		on;
			unset users($vuser)
		}
		if { [info exists vhost($vuser)] && $vuser!=$vnew } {
			set vhost($vnew)		$vhost($vuser);
			unset vhost($vuser)
		}
		if { [info exists admins($vuser)] && $vuser!=$vnew } {
			set admins($vnew)		$admins($vuser);
			unset admins($vuser)
		}
		if { [info exists netadmin($vuser)] && $vuser!=$vnew } {
			set netadmin($vnew)		on;
			unset netadmin($vuser)
		}
		if { [::EvaServ::console 3] == "ok" && $config(init) == 0 } {
			::EvaServ::SHOW:INFO:TO:CHANLOG "Nick" "$user change son pseudo en $new"
		}
		if {
			![info exists users($vnew)] && \
				![info exists admins($vnew)] && \
				[::EvaServ::protection $vnew $config(protection)] != "ok"
		} {
			catch { open [::EvaServ::Script:Get:Directory]db/nick.db r } liste
			while { ![eof $liste] } {
				gets $liste verif
				if { [string match $verif $vnew] && $verif != "" } {
					if { [::EvaServ::console 3] == "ok" && $config(init) == 0 } {
						::EvaServ::SHOW:INFO:TO:CHANLOG "Kill" "$new a été killé : $config(ruser)"
					}
					::EvaServ::sent2socket ":$config(server_id) KILL $vnew $config(ruser)";
					break;
					::EvaServ::refresh $vnew
				}
			}
			catch { close $liste }
		}
	}
	"TOPIC" {
		set chan		[lindex $arg 2]
		set vchan		[string tolower $chan]
		set topic		[join [string trim [lrange $arg 5 end] :]]
		if {
			[::EvaServ::console 3] == "ok" && \
				$vchan!=[string tolower $config(salon)] && \
				$config(init) == 0
		} {
			::EvaServ::SHOW:INFO:TO:CHANLOG "Topic" "$user change le topic sur $chan : $topic<c>"
		}
	}
	"KICK" {
		set pseudo		[::EvaServ::UID:CONVERT [lindex $arg 3]]
		set chan		[lindex $arg 2]
		set vchan		[string tolower [lindex $arg 2]]
		set raison		[join [string trim [lrange $arg 4 end] :]]
		if {
			[::EvaServ::console 3] == "ok" && \
				$vchan!=[string tolower $config(salon)] && \
				$config(init) == 0
		} {
			::EvaServ::SHOW:INFO:TO:CHANLOG "Kick" "$pseudo a été kické par $user sur $chan : $raison<c>"
		}
	}
	"KILL" {
		set pseudo		[lindex $arg 2]
		set vpseudo		[string tolower [lindex $arg 2]]
		set text		[join [string trim [lrange $arg 2 end] :]]
		::EvaServ::refresh $vpseudo
		if { [::EvaServ::console 1] == "ok" && $config(init) == 0 } {
			::EvaServ::SHOW:INFO:TO:CHANLOG "Kill" "$pseudo : $text<c>"
		}
		if { $vpseudo == [string tolower $config(service_nick)] } {
			::EvaServ::gestion;
			::EvaServ::sent2socket ":$config(link) SQUIT $config(link) :$config(raison)"
			foreach kill [utimers] {
				if { [lindex $kill 1] == "::EvaServ::verif" } { killutimer [lindex $kill 2] }
			}
			if { [info exists config(idx)] } { unset config(idx)		}
			set config(counter)		0;
			::EvaServ::config
			utimer 1 ::EvaServ::connexion
		}
	}
	"GLOBOPS" {
		set text		[join [string trim [lrange $arg 2 end] :]]
		if {
			[::EvaServ::console 3] == "ok" && \
				$config(init) == 0 && \
				![info exists users($vuser)]
		} {
			::EvaServ::SHOW:INFO:TO:CHANLOG "Globops" "$user : $text<c>"
		}
	}
	"CHGIDENT" {
		set pseudo		[lindex $arg 2]
		set ident		[lindex $arg 3]
		if { [::EvaServ::console 3] == "ok" && $config(init) == 0 } {
			::EvaServ::SHOW:INFO:TO:CHANLOG "Chgident" "$user change l'ident de $pseudo en $ident"
		}
	}
	"CHGHOST" {
		set pseudo		[::EvaServ::FCT:DATA:TO:NICK [lindex $arg 2]]
		set host		[lindex $arg 3]
		if { [::EvaServ::console 3] == "ok" && $config(init) == 0 } {
			::EvaServ::SHOW:INFO:TO:CHANLOG "Chghost" "$user change l'host de $pseudo en $host"
		}
	}
	"CHGNAME" {
		set pseudo		[lindex $arg 2]
		set real		[join [string trim [lrange $arg 3 end] :]]
		if { [::EvaServ::console 3] == "ok" && $config(init) == 0 } {
			::EvaServ::SHOW:INFO:TO:CHANLOG "Chgname" "$user change le realname de $pseudo en $real"
		}
	}
	"SETHOST" {
		set host		[lindex $arg 2]
		if { [::EvaServ::console 3] == "ok" && $config(init) == 0 } {
			::EvaServ::SHOW:INFO:TO:CHANLOG "Sethost" "Changement de l'host de $user en $host"
		}
	}
	"SETIDENT" {
		set ident		[lindex $arg 2]
		if { [::EvaServ::console 3] == "ok" && $config(init) == 0 } {
			::EvaServ::SHOW:INFO:TO:CHANLOG "Setident" "Changement de l'ident de $user en $ident"
		}
	}
	"SETNAME" {
		set real		[join [string trim [lrange $arg 2 end] :]]
		if { [::EvaServ::console 3] == "ok" && $config(init) == 0 } {
			::EvaServ::SHOW:INFO:TO:CHANLOG "Setname" "Changement du realname de $user en $real"
		}
	}
	"SJOIN" {
		#	[20:40:16] Received: :001 SJOIN 1616246465 #Amandine :001119S0G
		set user		[::EvaServ::FCT:DATA:TO:NICK [string trim [lindex $arg 4] :]]
		set vuser		[string tolower $user]
		set chan		[lindex $arg 3]
		set vchan		[string tolower $chan]
		if {
			[::EvaServ::console 3] == "ok" && \
				$vchan!=[string tolower $config(salon)] && \
				$config(init) == 0
		} {
			::EvaServ::SHOW:INFO:TO:CHANLOG "Join" "$user entre sur $chan"
		}
		catch { open "[::EvaServ::Script:Get:Directory]db/salon.db" r } liste
		while { ![eof $liste] } {
			gets $liste verif
			if {
				$verif != "" && \
					[string match *[string trimleft $verif #]* [string trimleft $vchan #]] && \
					$vuser!=[string tolower $config(service_nick)] && \
					![info exists users($vuser)] && \
					![info exists admins($vuser)] && \
					[::EvaServ::protection $vuser $config(protection)] != "ok"
			} {
				set config(cmd)		"badchan";
				::EvaServ::sent2socket ":$config(server_id) JOIN $vchan";
				::EvaServ::FCT:SENT:MODE $vchan "+ntsio" $config(service_nick)
				::EvaServ::FCT:SET:TOPIC $vchan "<c1>Salon Interdit le [::EvaServ::duree [unixtime]]";
				::EvaServ::sent2socket ":$config(link) NAMES $vchan"
				if { [::EvaServ::console 3] == "ok" && $config(init) == 0 } {
					::EvaServ::SHOW:INFO:TO:CHANLOG "Part" "$user part de $chan : Salon Interdit"
				}
				break
			}
		}
		catch { close $liste }
	}
	"PART" {
		set chan		[string trim [lindex $arg 2] :]
		set vchan		[string tolower $chan]
		if {
			[::EvaServ::console 3] == "ok" && \
				$vchan!=[string tolower $config(salon)] && \
				$config(init) == 0
		} {
			::EvaServ::SHOW:INFO:TO:CHANLOG "Part" "$user part de $chan"
		}
	}
	"QUIT" {
		set text		[join [string trim [lrange $arg 2 end] :]]
		::EvaServ::refresh $vuser

		if { [::EvaServ::console 2] == "ok" && $config(init) == 0 } {
			if { $text != "" } {
				::EvaServ::SHOW:INFO:TO:CHANLOG "Déconnexion" "$user a quitté l'IRC : $text - ([::EvaServ::DBU:GET $user IDENT]@[::EvaServ::DBU:GET $user VHOST])"
			} else {
				::EvaServ::SHOW:INFO:TO:CHANLOG "Déconnexion" "$user a quitté l'IRC - ([::EvaServ::DBU:GET $user IDENT]@[::EvaServ::DBU:GET $user VHOST])"
			}
		}
	}
}
}

::EvaServ::INIT