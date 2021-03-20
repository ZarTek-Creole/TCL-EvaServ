######################################
##			 ____					##
##			|  __|_ _ ___			##
##			|  __| | | .'|			##
##			|____|\_/|__,|			##
##									##
##		   Auteur : TiSmA			##
##		   Email : TiSmA@eXolia.fr	##
##		   Licence : GNU / GPL		##
##									##
######################################
# Version 1.4	:
#	auteur	:
#		https://github.com/MalaGaM/tcl-eva
#	support	:
#		https://github.com/MalaGaM/tcl-eva/issues
#
#	change:
#		+ Prise en charge des nouveau protocol IRC
#		+ Nettoyage/formatage du code
#		+ creation du repertoire /db si manquant
#		+ creation proc eva:sent2socket pour envoyer vers le socket
#		+ ....
#
############
# Eva Bind #
############


bind time - "00 00 * * *" eva:dbback
bind evnt n init-server eva:initialisation
bind evnt n prerestart eva:evenement
bind evnt n sighup eva:evenement
bind evnt n sigterm eva:evenement
bind evnt n sigill eva:evenement
bind evnt n sigquit eva:evenement
bind evnt n prerehash eva:prerehash
bind evnt n rehash eva:rehash
bind dcc n eva eva:eva
bind dcc n evaconnect eva:connect
bind dcc n evadeconnect eva:deconnect
bind dcc n evauptime eva:uptime
bind dcc n evaversion eva:version
bind dcc n evainfos eva:infos
bind dcc n evadebug eva:debug

#################
# Eva Scriptdir #
#################

set eva(path)	"[file dirname [info script]]/"
proc eva:scriptdir { } {
	global eva;
	return $eva(path)
}
proc eva:sent2socket { idx arg } {
	global eva
	if { $eva(DEBUG) } { putlog "Sent: $arg" }
	putdcc $idx $arg
}
source [eva:scriptdir]Eva.conf

###############
# Eva Fichier #
###############
if { [file isdirectory "[eva:scriptdir]db"] } { file mkdir "[eva:scriptdir]db" }
if { ![file exists "[eva:scriptdir]db/gestion.db"] } { set c_gestion	[open "[eva:scriptdir]db/gestion.db" a+]; close $c_gestion }
if { ![file exists "[eva:scriptdir]db/chan.db"] } { set c_chan		[open "[eva:scriptdir]db/chan.db" a+]; close $c_chan }
if { ![file exists "[eva:scriptdir]db/client.db"] } { set c_client	[open "[eva:scriptdir]db/client.db" a+]; close $c_client }
if { ![file exists "[eva:scriptdir]db/secu.db"] } { set c_secu		[open "[eva:scriptdir]db/secu.db" a+]; close $c_secu }
if { ![file exists "[eva:scriptdir]db/close.db"] } { set c_close		[open "[eva:scriptdir]db/close.db" a+]; close $c_close }
if { ![file exists "[eva:scriptdir]db/salon.db"] } { set c_salon		[open "[eva:scriptdir]db/salon.db" a+]; close $c_salon }
if { ![file exists "[eva:scriptdir]db/ident.db"] } { set c_ident		[open "[eva:scriptdir]db/ident.db" a+]; close $c_ident }
if { ![file exists "[eva:scriptdir]db/real.db"] } { set c_real		[open "[eva:scriptdir]db/real.db" a+]; close $c_real }
if { ![file exists "[eva:scriptdir]db/host.db"] } { set c_host		[open "[eva:scriptdir]db/host.db" a+]; close $c_host }
if { ![file exists "[eva:scriptdir]db/nick.db"] } { set c_nick		[open "[eva:scriptdir]db/nick.db" a+]; close $c_nick }
if { ![file exists "[eva:scriptdir]db/trust.db"] } { set c_trust		[open "[eva:scriptdir]db/trust.db" a+]; close $c_trust }

#################
# Eva Commandes #
#################

set ceva(auth)			0
set ceva(deauth)		0
set ceva(copyright)		0
set ceva(help)			0
set ceva(showcommands)	0
set ceva(seen)			0
set ceva(access)		2
set ceva(map)			1
set ceva(whois)			1
set ceva(newpass)		2
set ceva(owner)			2
set ceva(deowner)		2
set ceva(protect)		2
set ceva(deprotect)		2
set ceva(ownerall)		2
set ceva(deownerall)	2
set ceva(protectall)	2
set ceva(deprotectall)	2
set ceva(op)			2
set ceva(deop)			2
set ceva(halfop)		2
set ceva(dehalfop)		2
set ceva(voice)			2
set ceva(devoice)		2
set ceva(opall)			2
set ceva(deopall)		2
set ceva(halfopall)		2
set ceva(dehalfopall)	2
set ceva(voiceall)		2
set ceva(devoiceall)	2
set ceva(kick)			2
set ceva(kickall)		2
set ceva(ban)			2
set ceva(nickban)		2
set ceva(kickban)		2
set ceva(unban)			2
set ceva(clearbans)		2
set ceva(kill)			2
set ceva(mode)			2
set ceva(clearmodes)	2
set ceva(clearallmodes)	2
set ceva(topic)			2
set ceva(inviteme)		2
set ceva(invite)		2
set ceva(wallops)		2
set ceva(globops)		2
set ceva(gline)			2
set ceva(ungline)		2
set ceva(shun)			2
set ceva(unshun)		2
set ceva(shunlist)		2
set ceva(glinelist)		2
set ceva(kline)			2
set ceva(unkline)		2
set ceva(klinelist)		2
set ceva(clientlist)	3
set ceva(trustlist)		3
set ceva(say)			3
set ceva(svsnick)		3
set ceva(svsjoin)		3
set ceva(svspart)		3
set ceva(notice)		3
set ceva(clearkline)	3
set ceva(cleargline)	3
set ceva(changline)		3
set ceva(chankill)		3
set ceva(join)			3
set ceva(part)			3
set ceva(list)			3
set ceva(status)		3
set ceva(close)			3
set ceva(unclose)		3
set ceva(closelist)		3
set ceva(clearclose)	3
set ceva(nicklist)		3
set ceva(identlist)		3
set ceva(reallist)		3
set ceva(hostlist)		3
set ceva(chanlist)		3
set ceva(seculist)		3
set ceva(addnick)		4
set ceva(delnick)		4
set ceva(addident)		4
set ceva(delident)		4
set ceva(addreal)		4
set ceva(delreal)		4
set ceva(addhost)		4
set ceva(delhost)		4
set ceva(addchan)		4
set ceva(delchan)		4
set ceva(addsecu)		4
set ceva(delsecu)		4
set ceva(secu)			4
set ceva(addtrust)		4
set ceva(deltrust)		4
set ceva(addclient)		4
set ceva(delclient)		4
set ceva(client)		4
set ceva(clone)			4
set ceva(chanlog)		4
set ceva(console)		4
set ceva(backup)		4
set ceva(restart)		4
set ceva(die)			4
set ceva(maxlogin)		4
set ceva(protection)	4
set ceva(addaccess)		4
set ceva(delaccess)		4
set ceva(modaccess)		4

#################
# Eva Variables #
#################

set eva(version)		"1.4"
set eva(timerco)		30
set eva(timerdem)		5
set eva(timerinit)		10
set eva(counter)		0
set eva(dem)			0
set eva(init)			0
set eva(console)		1
set eva(login)			1
set eva(protection)		1
set eva(debug)			0
set eva(aclone)			0
set eva(aclient)		0
set eva(secu)			0

#################
# Eva fonctions #
#################


array set UID_DB		""
proc eva:UID:CONVERT { ID } {
	global UID_DB
	if { [info exists UID_DB([string toupper $ID])] } {
		return "$UID_DB([string toupper $ID])"
	} else {
		return $ID
	}
}
proc eva:FCT:SENT:NOTICE { WHO MSG } {
	global eva
	eva:sent2socket $eva(idx) ":$eva(server_id) NOTICE $WHO :$MSG"
}

##############
# Eva Config #
##############
proc eva:config { } {
	global eva
	if { ![info exists eva(link)] || ![info exists eva(ip)] || ![info exists eva(port)] || ![info exists eva(pass)] || ![info exists eva(info)] || ![info exists eva(SID)] || ![info exists eva(pseudo)] || ![info exists eva(DEBUG)] || ![info exists eva(ident)] || ![info exists eva(host)] || ![info exists eva(real)] || ![info exists eva(salon)] || ![info exists eva(smode)] || ![info exists eva(cmode)] || ![info exists eva(secuco)] || ![info exists eva(secutime)] || ![info exists eva(secuon)] || ![info exists eva(secuoff)] || ![info exists eva(secustop)] || ![info exists eva(numavert)] || ![info exists eva(numclone)] || ![info exists eva(rhost)] || ![info exists eva(rident)] || ![info exists eva(rreal)] || ![info exists eva(ruser)] || ![info exists eva(ravert)] || ![info exists eva(rclone)] || ![info exists eva(prefix)] || ![info exists eva(rnick)] || ![info exists eva(fraz)] || ![info exists eva(duree)] || ![info exists eva(ignore)] || ![info exists eva(rclient)] || ![info exists eva(raison)] || ![info exists eva(console_com)] || ![info exists eva(console_deco)] || ![info exists eva(console_txt)] } {
		return ok
	} elseif { $eva(link)=="" || $eva(ip)=="" || $eva(port)=="" || $eva(pass)=="" || $eva(info)=="" || $eva(SID)=="" || $eva(pseudo)=="" || $eva(DEBUG)=="" || $eva(ident)=="" || $eva(host)=="" || $eva(real)=="" || $eva(salon)=="" || $eva(smode)=="" || $eva(cmode)=="" || $eva(secuco)=="" || $eva(secutime)=="" || $eva(secuon)=="" || $eva(secuoff)=="" || $eva(secustop)=="" || $eva(numavert)=="" || $eva(numclone)==""	 || $eva(ravert)=="" || $eva(rclone)=="" || $eva(prefix)=="" || $eva(rnick)=="" || $eva(fraz)=="" || $eva(duree)=="" || $eva(ignore)=="" || $eva(rclient)=="" || $eva(raison)=="" || $eva(rhost)=="" || $eva(rident)=="" || $eva(rreal)=="" || $eva(ruser)=="" || $eva(console_com)=="" || $eva(console_deco)=="" || $eva(console_txt)=="" } {
		return ok
	}
}

################
# Eva Putdebug #
################

proc eva:putdebug { string } {
	set deb		[open logs/Eva.debug a]
	puts $deb "[clock format [clock seconds] -format "\[%H:%M\]"] $string"
	close $deb
}

###############
# Eva Refresh #
###############

proc eva:refresh { pseudo } {
	global netadmin admins vhost protect ueva
	set vuser	[string tolower $pseudo]
	if { [info exists vhost($vuser)] } {
		if { [info exists protect($vhost($vuser))] && [info exists admins($vuser)] } { unset protect($vhost($vuser))		}
		unset vhost($vuser)
	}
	if { [info exists ueva($vuser)] } { unset ueva($vuser)		}
	if { [info exists netadmin($vuser)] } { unset netadmin($vuser)		}
	if { [info exists admins($vuser)] } { unset admins($vuser)		}
}

###############
# Eva Gestion #
###############

proc eva:gestion { } {
	global eva
	set sv		[open [eva:scriptdir]db/gestion.db w+]
	puts $sv "eva(salon) $eva(salon)"
	puts $sv "eva(debug) $eva(debug)"
	puts $sv "eva(console) $eva(console)"
	puts $sv "eva(protection) $eva(protection)"
	puts $sv "eva(login) $eva(login)"
	puts $sv "eva(aclone) $eva(aclone)"
	puts $sv "eva(aclient) $eva(aclient)"
	puts $sv "eva(secu) $eva(secu)"
	close $sv
}

##############
# Eva Dbback #
##############

proc eva:dbback { min h d m y } {
	global eva
	eva:gestion
	exec cp -f [eva:scriptdir]db/gestion.db [eva:scriptdir]db/gestion.bak
	exec cp -f [eva:scriptdir]db/chan.db [eva:scriptdir]db/chan.bak
	exec cp -f [eva:scriptdir]db/client.db [eva:scriptdir]db/client.bak
	exec cp -f [eva:scriptdir]db/secu.db [eva:scriptdir]db/secu.bak
	exec cp -f [eva:scriptdir]db/close.db [eva:scriptdir]db/close.bak
	exec cp -f [eva:scriptdir]db/nick.db [eva:scriptdir]db/nick.bak
	exec cp -f [eva:scriptdir]db/ident.db [eva:scriptdir]db/ident.bak
	exec cp -f [eva:scriptdir]db/real.db [eva:scriptdir]db/real.bak
	exec cp -f [eva:scriptdir]db/host.db [eva:scriptdir]db/host.bak
	exec cp -f [eva:scriptdir]db/salon.db [eva:scriptdir]db/salon.bak
	exec cp -f [eva:scriptdir]db/trust.db [eva:scriptdir]db/trust.bak
	if { [eva:console 1]=="ok" } {
		eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Backup \003$eva(console_deco):\003$eva(console_txt) Sauvegarde des databases."
	}
}

#############
# Eva Duree #
#############

proc eva:duree { temps } {
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

##################
# Eva Chargement #
##################

proc eva:chargement { } {
	global eva trust
	catch { open [eva:scriptdir]db/trust.db r } protection
	while { ![eof $protection] } {
		gets $protection hosts;
		if { $hosts!="" && ![info exists trust($hosts)] } { set trust($hosts)	1 }
	}
	catch { close $protection }
	catch { open [eva:scriptdir]db/gestion.db r } gestion
	while { ![eof $gestion] } {
		gets $gestion var2;
		if { $var2!="" } { set [lindex		$var2 0] [lindex $var2 1] }
	}
	catch { close $gestion }
}

###############
# Eva Console #
###############

proc eva:console { level } {
	global eva
	switch -exact $level {
		1	{
			if { $eva(console)>=1 } { return ok }
		}
		2	{
			if { $eva(console)>=2 } { return ok }
		}
		3	{
			if { $eva(console)>=3 } { return ok }
		}
	}
}

##################
# Eva Protection #
##################

proc eva:protection { user level } {
	global eva netadmin admins vhost
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

#############
# Eva Rnick #
#############

proc eva:rnick { user } {
	global eva
	if { $eva(rnick)==1 } { return "($user)" }
}

############
# Eva Secu #
############

proc eva:secu { } {
	global eva
	if { [info exists eva(maxthrottle)] } {
		
		eva:FCT:SENT:NOTICE "$*.*" " $eva(secuoff)"
		catch { open "[eva:scriptdir]db/secu.db" r } liste
		while { ![eof $liste] } {
			gets $liste salon;
			if { $salon!="" } {
				eva:sent2socket $eva(idx) ":$eva(server_id) MODE $salon -msi"
			}
		}
		catch { close $liste }
		unset eva(maxthrottle)
	}
}

#################
# Eva Prerehash #
#################

proc eva:prerehash { arg } {
	global eva
	if { [info exists eva(idx)] && [valididx $eva(idx)] } {
		eva:gestion
	}
}

##############
# Eva Rehash #
##############

proc eva:rehash { arg } {
	global eva
	if { [info exists eva(idx)] && [valididx $eva(idx)] } {
		eva:chargement
	}
}

#################
# Eva Evenement #
#################

proc eva:evenement { arg } {
	global eva
	if { [info exists eva(idx)] && [valididx $eva(idx)] } {
		eva:gestion
		eva:sent2socket $eva(idx) ":$eva(server_id) QUIT :$eva(raison)"
		eva:sent2socket $eva(idx) ":$eva(link) SQUIT $eva(link) :$eva(raison)"
		foreach kill [utimers] {
			if { [lindex $kill 1]=="eva:verif" } { killutimer [lindex $kill 2] }
		}
		unset eva(idx)
	}
}

#######
# Eva #
#######

proc eva:eva { nick idx arg } {
	eva:sent2socket $idx "\00301,01------------\002\00300 Commandes de Eva Service \00301------------"
	eva:sent2socket $idx " "
	eva:sent2socket $idx "\00301 .evaconnect \00303: \00314Connexion de Eva Service"
	eva:sent2socket $idx "\00301 .evadeconnect \00303: \00314Déconnexion de Eva Service"
	eva:sent2socket $idx "\00301 .evadebug on/off \00303: \00314Mode debug de Eva Service"
	eva:sent2socket $idx "\00301 .evainfos \00303: \00314Voir les infos de Eva Service"
	eva:sent2socket $idx "\00301 .evauptime \00303: \00314Uptime de Eva Service"
	eva:sent2socket $idx "\00301 .evaversion \00303: \00314Version de Eva Service"
	eva:sent2socket $idx ""
}

###############
# Eva Connect #
###############

proc eva:connect { nick idx arg } {
	global eva
	set eva(counter)		0
	if { [eva:config]!="ok" } {
		if { ![info exists eva(idx)] } {
			eva:sent2socket $idx "\00301\[ \00303Connexion\00301 \] \00301 Lancement de Eva Service..."; eva:connexion
			set eva(dem)		1; utimer $eva(timerdem) [list set eva(dem)		0]
		} else {
			if { ![valididx $eva(idx)] } {
				eva:sent2socket $idx "\00301\[ \00303Connexion\00301 \] \00301 Lancement de Eva Service..."; eva:connexion
				set eva(dem)		1; utimer $eva(timerdem) [list set eva(dem)		0]
			} else {
				eva:sent2socket $idx "\00301\[ \00304Impossible\00301 \] \00301 Eva Service est déjà connecté..."
			}
		}
	} else {
		eva:sent2socket $idx "\00301\[ \00304Erreur\00301 \] \00301 Configuration de Eva Service Incorrecte..."
	}
}

#################
# Eva Deconnect #
#################

proc eva:deconnect { nick idx arg } {
	global eva
	if { $eva(dem)==0 } {
		if { [info exists eva(idx)] && [valididx $eva(idx)] } {
			eva:gestion
			eva:sent2socket $idx "\00301\[ \00303Déconnexion\00301 \] \00301 Arret de Eva Service..."
			eva:sent2socket $eva(idx) ":$eva(server_id) QUIT :$eva(raison)"
			eva:sent2socket $eva(idx) ":$eva(link) SQUIT $eva(link) :$eva(raison)"
			foreach kill [utimers] {
				if { [lindex $kill 1]=="eva:verif" } { killutimer [lindex $kill 2] }
			}
			unset eva(idx)
		} else {
			eva:sent2socket $idx "\00301\[ \00304Impossible\00301 \] \00301 Eva Service n'est pas connecté..."
		}
	} else {
		eva:sent2socket $idx "\00301\[ \00304Erreur\00301 \] \00301 Connexion de Eva Service en cours..."
	}
}

##############
# Eva Uptime #
##############

proc eva:uptime { nick idx arg } {
	global eva
	if { [info exists eva(idx)] && [valididx $eva(idx)] } {
		set show		""
		set up		[expr ([clock seconds] - $eva(uptime))]
		set jour		[expr ($up / 86400)]
		set up		[expr ($up % 86400)]
		set heure		[expr ($up / 3600)]
		set up		[expr ($up % 3600)]
		set minute		[expr ($up / 60)]
		set seconde		[expr ($up % 60)]
		if { $jour == 1 } { append show "$jour jour " } elseif { $jour > 1 } { append show "$jour jours " }
		if { $heure == 1 } { append show "$heure heure " } elseif { $heure > 1 } { append show "$heure heures " }
		if { $minute == 1 } { append show "$minute minute " } elseif { $minute > 1 } { append show "$minute minutes " }
		if { $seconde == 1 } { append show "$seconde seconde " } elseif { $seconde > 1 } { append show "$seconde secondes " }
		eva:sent2socket $idx "\00301\[ \00303Uptime\00301 \] \00301 $show"
	} else {
		eva:sent2socket $idx "\00301\[ \00304Uptime\00301 \] \00301 Eva Service n'est pas connecté..."
	}
}

###############
# Eva Version #
###############

proc eva:version { nick idx arg } {
	global eva
	eva:sent2socket $idx "\00301\[ \00303Version\00301 \] \00301 Eva Service $eva(version) by TiSmA"
}

#############
# Eva Infos #
#############

proc eva:infos { nick idx arg } {
	global eva version tcl_patchLevel tcl_library tcl_platform
	eva:sent2socket $idx "\00301,01-----------\002\00300 Infos de Eva Service \00301-----------"
	eva:sent2socket $idx "\003"
	if { [info exists eva(idx)] }	 {
		eva:sent2socket $idx "\00301 Statut : \00303Online"
	} else {
		eva:sent2socket $idx "\00301 Statut : \00304Offline"
	}
	if { $eva(debug)==1 } {
		eva:sent2socket $idx "\00301 Debug : \00303On"
	} else {
		eva:sent2socket $idx "\00301 Debug : \00304Off"
	}
	eva:sent2socket $idx "\00301 Os : $tcl_platform(os) $tcl_platform(osVersion)"
	eva:sent2socket $idx "\00301 Tcl Version : $tcl_patchLevel"
	eva:sent2socket $idx "\00301 Tcl Lib : $tcl_library"
	eva:sent2socket $idx "\00301 Encodage : [encoding system]"
	eva:sent2socket $idx "\00301 Eggdrop Version : [lindex $version 0]"
	eva:sent2socket $idx "\00301 Config : [eva:scriptdir]Eva.conf"
	eva:sent2socket $idx "\00301 Noyau : [eva:scriptdir]Eva.tcl"
	eva:sent2socket $idx "\003"
}

#############
# Eva Debug #
#############

proc eva:debug { nick idx arg } {
	global eva
	set arg			[split $arg]
	set status		[string tolower [lindex $arg 0]]
	if { $status!="on" && $status!="off" } {
		eva:sent2socket $idx ".evadebug on/off";
		return 0;
	}

	if { $status=="on" } {
		if { $eva(debug)==0 } {
			set eva(debug)		1; eva:sent2socket $idx "\00301\[ \00303Debug\00301 \] \00301 Activé"
		} else {
			eva:sent2socket $idx "Le mode debug est déjà activé."
		}
	} elseif { $status=="off" } {
		if { $eva(debug)==1 } {
			set eva(debug)		0; eva:sent2socket $idx "\00301\[ \00303Debug\00301 \] \00301 Désactivé"
			if { [file exists "logs/Eva.debug"] } { exec rm -rf logs/Eva.debug }
		} else {
			eva:sent2socket $idx "Le mode debug est déjà désactivé."
		}
	}
}

##############
# Eva Authed #
##############

proc eva:authed { user level } {
	global eva admins
	switch -exact $level {
		0 { return ok }
		1 {
			if { [info exists admins($user)] && [matchattr $admins($user) p] } {
				return ok
			} else {
				eva:FCT:SENT:NOTICE "$user" "Accès Refusé";
				return 0
			}
		}
		2 {
			if { [info exists admins($user)] && [matchattr $admins($user) o] } {
				return ok
			} else {
				eva:FCT:SENT:NOTICE "$user" "Accès Refusé";
				return 0;

			}
		}
		3 {
			if { [info exists admins($user)] && [matchattr $admins($user) m] } {
				return ok;
			} else {

				eva:FCT:SENT:NOTICE "$user" "Accès Refusé";
				return 0;

			}
		}
		4 {
			if { [info exists admins($user)] && [matchattr $admins($user) n] } {
				return ok;
			} else {

				eva:FCT:SENT:NOTICE "$user" "Accès Refusé";
				return 0;

			}
		}
	}
}

#############
# Eva Flood #
#############

proc eva:flood { pseudo } {
	global eva
	if { ![info exists eva(flood:$pseudo)] } {
		set eva(flood:$pseudo)		1; utimer 3 [list eva:reset $pseudo];		return ok
	} elseif { $eva(flood:$pseudo)<$eva(fraz) } {
		incr eva(flood:$pseudo) 1; return ok
	} else {
		if { ![info exists eva(stopflood:$pseudo)] } { set eva(stopflood:$pseudo)		1 }
	}
}

#############
# Eva Reset #
#############

proc eva:reset { pseudo }		{
	global eva
	if { [info exists eva(stopflood:$pseudo)] } {
		eva:FCT:SENT:NOTICE "$pseudo" "Vous êtes ignoré pendant $eva(ignore) secondes."; utimer $eva(ignore) [list eva:nettoyage $pseudo];
		return 0;

	} else {
		unset eva(flood:$pseudo)
	}
}

#################
# Eva Nettoyage #
#################

proc eva:nettoyage { pseudo } {
	global eva
	unset eva(flood:$pseudo);		unset eva(stopflood:$pseudo)
}

############
# Eva Cmds #
############

proc eva:cmds { arg } {
	global eva ceva ueva admin admins vhost protect trust
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

	if { [eva:authed $vuser $ceva($cmd)]!="ok" } { return 0 }
	switch -exact $cmd {
		"auth" {
			if { [lindex $arg 2]=="" || [lindex $arg 3]=="" } {
				eva:sent2socket $eva(idx) ":$eva(server_id) NOTICE [eva:UID:CONVERT $user] :\002Commande Auth :\002 /msg $eva(pseudo) auth pseudo password";
				return 0
			}
			if { [passwdok [lindex $arg 2] [lindex $arg 3]] } {
				if { [matchattr [lindex $arg 2] o] || [matchattr [lindex $arg 2] m] || [matchattr [lindex $arg 2] n] } {
					if { $eva(login)==1 } {
						foreach { pseudo login } [array get admins] {
							if { $login==[string tolower [lindex $arg 2]] && $pseudo!=$vuser } {
								eva:sent2socket $eva(idx) ":$eva(server_id) NOTICE [eva:UID:CONVERT $vuser] :Maximum de Login atteint.";
								return 0;

							}
						}
					}
					if { ![info exists admins($vuser)] } {
						set admins($vuser)		[string tolower [lindex $arg 2]]
						if { [info exists vhost($vuser)] && ![info exists protect($vhost($vuser))] } { set protect($vhost($vuser))		1 }
						setuser [string tolower [lindex $arg 2]] LASTON [unixtime]
						eva:FCT:SENT:NOTICE "$vuser" "Authentification Réussie."
						eva:sent2socket $eva(idx) ":$eva(server_id) INVITE $vuser $eva(salon)"
						if { [eva:console 1]=="ok" } {
							eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Auth \003$eva(console_deco):\003$eva(console_txt) $user"
						}
						return 0
					} else {
						eva:FCT:SENT:NOTICE "$vuser" "Vous êtes déjà authentifié.";
						return 0;

					}
				} elseif { [matchattr [lindex $arg 2] p] } {
					eva:FCT:SENT:NOTICE "$vuser" "Authentification Helpeur Refusée.";
					return 0;
				}

			} else {
				eva:FCT:SENT:NOTICE "$vuser" "Accès Refusé.";
				return 0;

			}
		}
		"deauth" {
			if { [info exists admins($vuser)] } {
				if { [matchattr $admins($vuser) o] || [matchattr $admins($vuser) m] || [matchattr $admins($vuser) n] } {
					if { [info exists vhost($vuser)] && [info exists protect($vhost($vuser))] } { unset protect($vhost($vuser))		}
					unset admins($vuser);
					eva:FCT:SENT:NOTICE "$vuser" "Déauthentification Réussie."
					if { [eva:console 1]=="ok" } {
						eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Deauth \003$eva(console_deco):\003$eva(console_txt) $user"
					}
				} elseif { [matchattr $admins($vuser) p] } {
					eva:FCT:SENT:NOTICE "$vuser" "Déauthentification Helpeur Refusée.";
					return 0;
				}

			} else {
				eva:FCT:SENT:NOTICE "$vuser" "Vous n'êtes pas authentifié."
			}
		}
		"copyright" {
			eva:FCT:SENT:NOTICE "$user" "\00301Eva Service $eva(version) by TiSmA"
			if { [eva:console 1]=="ok" } {
				eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Copyright \003$eva(console_deco):\003$eva(console_txt) $user"
			}
		}
		"console" {
			if { $value2=="" || [regexp \[^0-3\] $value2] } {
				eva:FCT:SENT:NOTICE "$vuser" "\002Commande Console :\002 /msg $eva(pseudo) console 0/1/2/3"
				eva:FCT:SENT:NOTICE "$vuser" "\00302Level 0 \00304:\00301 Aucune console"
				eva:FCT:SENT:NOTICE "$vuser" "\00302Level 1 \00304:\00301 Console commande"
				eva:FCT:SENT:NOTICE "$vuser" "\00302Level 2 \00304:\00301 Console commande & connexion & déconnexion"
				eva:FCT:SENT:NOTICE "$vuser" "\00302Level 3 \00304:\00301 Toutes les consoles"
				return 0
			}
			switch -exact $value2 {
				0 {
					set eva(console)		0; eva:FCT:SENT:NOTICE "$vuser" "Level 0 : Aucune console"
					eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Console \003$eva(console_deco):\003$eva(console_txt) $user"
				}
				1 {
					set eva(console)		1; eva:FCT:SENT:NOTICE "$vuser" "Level 1 : Console commande"
					eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Console \003$eva(console_deco):\003$eva(console_txt) $user"
				}
				2 {
					set eva(console)		2; eva:FCT:SENT:NOTICE "$vuser" "Level 2 : Console commande & connexion & déconnexion"
					eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Console \003$eva(console_deco):\003$eva(console_txt) $user"
				}
				3 {
					set eva(console)		3; eva:FCT:SENT:NOTICE "$vuser" "Level 3 : Toutes les consoles"
					eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Console \003$eva(console_deco):\003$eva(console_txt) $user"
				}
			}
		}
		"chanlog" {
			if { $value2==[string tolower $eva(salon)] } {
				eva:FCT:SENT:NOTICE "$vuser" "\002$value1\002 est déjà le salon de log.";
				return 0
			}
			if { [string index $value2 0]!="#" } {
				eva:FCT:SENT:NOTICE "$vuser" "\002Commande Chanlog :\002 /msg $eva(pseudo) chanlog #salon";
				return 0
			}
			catch { open "[eva:scriptdir]db/salon.db" r } liste1
			while { ![eof $liste1] } {
				gets $liste1 verif1;
				if { ![string compare -nocase $value2 $verif1] } {
					eva:FCT:SENT:NOTICE "$vuser" "Accès Refusé : Salon Interdit";
					set stop		1;
					break
				}
			}
			catch { close $liste1 };
			if { $stop==1 } { return 0 }
			catch { open "[eva:scriptdir]db/close.db" r } liste2
			while { ![eof $liste2] } {
				gets $liste2 verif2;
				if { ![string compare -nocase $value2 $verif2] } {
					eva:FCT:SENT:NOTICE "$vuser" "Accès Refusé : Salon Fermé";
					set stop		1;
					break
				}
			}
			catch { close $liste2 };
			if { $stop==1 } { return 0 }
			catch { open "[eva:scriptdir]db/chan.db" r } liste3
			while { ![eof $liste3] } {
				gets $liste3 verif3;
				if { ![string compare -nocase $value2 $verif3] } {
					eva:FCT:SENT:NOTICE "$vuser" "Accès Refusé : Salon Autojoin";
					set stop		1;
					break
				}
			}
			catch { close $liste3 };
			if { $stop==1 } { return 0 }
			eva:sent2socket $eva(idx) ":$eva(server_id) PART $eva(salon)"
			set eva(salon)		$value1
			eva:sent2socket $eva(idx) ":$eva(server_id) JOIN $eva(salon)"
			eva:sent2socket $eva(idx) ":$eva(server_id) MODE $eva(salon) +$eva(smode)"
			if { $eva(cmode)=="q" || $eva(cmode)=="a" || $eva(cmode)=="o" || $eva(cmode)=="h" || $eva(cmode)=="v" } {
				eva:sent2socket $eva(idx) ":$eva(server_id) MODE $eva(salon) +$eva(cmode) $eva(SID)"
			}
			eva:FCT:SENT:NOTICE "$vuser" "Changement du salon de log reussi ($value1)"
			if { [eva:console 1]=="ok" } {
				eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Chanlog \003$eva(console_deco):\003$eva(console_txt) Changement du salon de log par $user ($value1)"
			}
		}
		"join" {
			if { [string index $value2 0]!="#" } {
				eva:FCT:SENT:NOTICE "$vuser" "\002Commande Join :\002 /msg $eva(pseudo) join #salon";
				return 0
			}
			if { $value2==[string tolower $eva(salon)] } {
				eva:FCT:SENT:NOTICE "$vuser" "Accès Refusé : Salon de logs";
				return 0
			}
			catch { open "[eva:scriptdir]db/salon.db" r } liste1
			while { ![eof $liste1] } {
				gets $liste1 verif1;
				if { ![string compare -nocase $value2 $verif1] } {
					eva:FCT:SENT:NOTICE "$vuser" "Accès Refusé : Salon Interdit";
					set stop		1;
					break
				}
			}
			catch { close $liste1 };
			if { $stop==1 } { return 0 }
			catch { open "[eva:scriptdir]db/close.db" r } liste2
			while { ![eof $liste2] } {
				gets $liste2 verif2;
				if { ![string compare -nocase $value2 $verif2] } {
					eva:FCT:SENT:NOTICE "$vuser" "Accès Refusé : Salon Fermé";
					set stop		1;
					break
				}
			}
			catch { close $liste2 };
			if { $stop==1 } { return 0 }
			catch { open "[eva:scriptdir]db/chan.db" r } liste
			while { ![eof $liste] } {
				gets $liste verif;
				if { ![string compare -nocase $value2 $verif] } {
					eva:FCT:SENT:NOTICE "$vuser" "$eva(server_id) est déjà sur \002$value1\002.";
					set stop		1;
					break
				}
			}
			catch { close $liste };
			if { $stop==1 } { return 0 }
			set join		[open "[eva:scriptdir]db/chan.db" a]; puts $join $value2; close $join; eva:sent2socket $eva(idx) ":$eva(server_id) JOIN $value1"
			if { $eva(cmode)=="q" || $eva(cmode)=="a" || $eva(cmode)=="o" || $eva(cmode)=="h" || $eva(cmode)=="v" } {
				eva:sent2socket $eva(idx) ":$eva(server_id) MODE $value1 +$eva(cmode) $eva(SID)"
			}
			eva:FCT:SENT:NOTICE "$vuser" "$eva(server_id) entre sur \002$value1\002"

			if { [eva:console 1]=="ok" } {
				eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Join \003$eva(console_deco):\003$eva(console_txt) $value1 par $user"
			}
		}
		"part" {
			if { [string index $value2 0]!="#" } {
				eva:FCT:SENT:NOTICE "$vuser" "\002Commande Part :\002 /msg $eva(pseudo) part #salon";
				return 0;
			}

			if { $value2==[string tolower $eva(salon)] } {
				eva:FCT:SENT:NOTICE "$vuser" "Accès Refusé";
				return 0;
			}

			catch { open "[eva:scriptdir]db/chan.db" r } liste
			while { ![eof $liste] } {
				gets $liste verif;
				if { ![string compare -nocase $value2 $verif] } { set stop		1 };
				if { [string compare -nocase $value2 $verif] && $verif!="" } { lappend salle "$verif" }
			}
			catch { close $liste }
			if { $stop==0 } {
				eva:FCT:SENT:NOTICE "$vuser" "$eva(server_id) n'est pas sur \002$value1\002.";
				return 0;

			} else {
				if { [info exists salle] } {
					set del		[open "[eva:scriptdir]db/chan.db" w+]; foreach delchan $salle { puts $del "$delchan" }; close $del
				} else {
					set del		[open "[eva:scriptdir]db/chan.db" w+]; close $del
				}
				eva:sent2socket $eva(idx) ":$eva(server_id) PART $value1"
				eva:FCT:SENT:NOTICE "$vuser" "$eva(server_id) part de \002$value1\002"
				if { [eva:console 1]=="ok" } {
					eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Part \003$eva(console_deco):\003$eva(console_txt) $value1 par $user"
				}
			}
		}
		"list" {
			catch { open "[eva:scriptdir]db/chan.db" r } liste
			eva:FCT:SENT:NOTICE "$vuser" "\002\0031,1--------- \0030Autojoin salons \0031---------"
			eva:FCT:SENT:NOTICE "$vuser" "\002"
			while { ![eof $liste] } {
				gets $liste salon;
				if { $salon!="" } { incr stop 1; eva:FCT:SENT:NOTICE "$vuser" "\00301 \[\00303 $stop \00301\] \00301 $salon" }
			}
			catch { close $liste }
			if { $stop==0 } {
				eva:FCT:SENT:NOTICE "$vuser" "Aucun Salon"
			}
			if { [eva:console 1]=="ok" } {
				eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)List \003$eva(console_deco):\003$eva(console_txt) $user"
			}
		}
		"showcommands" {
			eva:FCT:SENT:NOTICE "$vuser" "\002\00301,01--------------------------------------- \00300Commandes de Eva Service \00301---------------------------------------"
			eva:FCT:SENT:NOTICE "$vuser" "\003"
			eva:FCT:SENT:NOTICE "$vuser" "\00301\[ Level Utilisateur \]"
			eva:FCT:SENT:NOTICE "$vuser" "\00302AUTH\00301 \[\00304 0 \00301\] | \00302COPYRIGHT\00301 \[\00304 0 \00301\] | \00302DEAUTH\00301 \[\00304 0 \00301\] | \00302HELP\00301 \[\00304 0 \00301\]"
			eva:FCT:SENT:NOTICE "$vuser" "\00302SEEN\00301 \[\00304 0 \00301\] | \00302SHOWCOMMANDS\00301 \[\00304 0 \00301\]"
			eva:FCT:SENT:NOTICE "$vuser" "\003"
			if { [info exists admins($vuser)] && [matchattr $admins($vuser) p] } {
				eva:FCT:SENT:NOTICE "$vuser" "\00301\[ Level Helpeur \]"
				eva:FCT:SENT:NOTICE "$vuser" "\00302MAP\00301 \[\00304 1 \00301\] | \00302WHOIS\00301 \[\00304 1 \00301\]"
				eva:FCT:SENT:NOTICE "$vuser" "\003"
			}
			if { [info exists admins($vuser)] && [matchattr $admins($vuser) o] } {
				eva:FCT:SENT:NOTICE "$vuser" "\00301\[ Level Géofront \]"
				eva:FCT:SENT:NOTICE "$vuser" "\00302ACCESS\00301 \[\00304 2 \00301\] | \00302BAN\00301 \[\00304 2 \00301\] | \00302CLEARALLMODES\00301 \[\00304 2 \00301\] | \00302CLEARBANS\00301 \[\00304 2 \00301\] | \00302CLEARMODES\00301 \[\00304 2 \00301\] | \00302DEHALFOP\00301 \[\00304 2 \00301\]"
				eva:FCT:SENT:NOTICE "$vuser" "\00302DEHALFOPALL\00301 \[\00304 2 \00301\] | \00302DEOP\00301 \[\00304 2 \00301\] | \00302DEOPALL\00301 \[\00304 2 \00301\] | \00302DEOWNER\00301 \[\00304 2 \00301\] | \00302DEOWNERALL\00301 \[\00304 2 \00301\]"
				eva:FCT:SENT:NOTICE "$vuser" "\00302DEPROTECT\00301 \[\00304 2 \00301\] | \00302DEPROTECTALL\00301 \[\00304 2 \00301\] | \00302DEVOICE\00301 \[\00304 2 \00301\] | \00302DEVOICEALL\00301 \[\00304 2 \00301\] | \00302GLINE\00301 \[\00304 2 \00301\]"
				eva:FCT:SENT:NOTICE "$vuser" "\00302GLINELIST\00301 \[\00304 2 \00301\] | \00302SHUNLIST\00301 | \[\00304 2 \00301\] |\00302GLOBOPS\00301 \[\00304 2 \00301\] | \00302HALFOP\00301 \[\00304 2 \00301\] | \00302HALFOPALL\00301 \[\00304 2 \00301\] | \00302INVITE\00301 \[\00304 2 \00301\]"
				eva:FCT:SENT:NOTICE "$vuser" "\00302INVITEME\00301 \[\00304 2 \00301\] | \00302KICK\00301 \[\00304 2 \00301\] | \00302KICKALL\00301 \[\00304 2 \00301\] | \00302KICKBAN\00301 \[\00304 2 \00301\]"
				eva:FCT:SENT:NOTICE "$vuser" "\00302KILL\00301 \[\00304 2 \00301\] | \00302KLINE\00301 \[\00304 2 \00301\] | \00302KLINELIST\00301 \[\00304 2 \00301\] | \00302MODE\00301 \[\00304 2 \00301\] | \00302NEWPASS\00301 \[\00304 2 \00301\]"
				eva:FCT:SENT:NOTICE "$vuser" "\00302NICKBAN\00301 \[\00304 2 \00301\] | \00302OP\00301 \[\00304 2 \00301\] | \00302OPALL\00301 \[\00304 2 \00301\] | \00302OWNER\00301 \[\00304 2 \00301\] | \00302OWNERALL\00301 \[\00304 2 \00301\]"
				eva:FCT:SENT:NOTICE "$vuser" "\00302PROTECT\00301 \[\00304 2 \00301\] | \00302PROTECTALL\00301 \[\00304 2 \00301\] | \00302TOPIC\00301 \[\00304 2 \00301\] | \00302UNBAN\00301 \[\00304 2 \00301\] | \00302UNGLINE\00301 \[\00304 2 \00301\] | \00302UNSHUN\00301 \[\00304 2 \00301\]"
				eva:FCT:SENT:NOTICE "$vuser" "\00302UNKLINE\00301 \[\00304 2 \00301\] | \00302VOICE\00301 \[\00304 2 \00301\] | \00302VOICEALL\00301 \[\00304 2 \00301\] | \00302WALLOPS\00301 \[\00304 2 \00301\]"
				eva:FCT:SENT:NOTICE "$vuser" "\003"
			}
			if { [info exists admins($vuser)] && [matchattr $admins($vuser) m] } {
				eva:FCT:SENT:NOTICE "$vuser" "\00301\[ Level Ircop \]"
				eva:FCT:SENT:NOTICE "$vuser" "\00302CHANGLINE\00301 \[\00304 3 \00301\] | \00302SHUNLIST\00301 | \00302CHANKILL\00301 \[\00304 3 \00301\] | \00302CHANLIST\00301 \[\00304 3 \00301\] | \00302CLEARCLOSE\00301 \[\00304 3 \00301\] | \00302CLEARGLINE\00301 \[\00304 3 \00301\]"
				eva:FCT:SENT:NOTICE "$vuser" "\00302CLEARKLINE\00301 \[\00304 3 \00301\] | \00302CLIENTLIST\00301 \[\00304 3 \00301\] | \00302CLOSE\00301 \[\00304 3 \00301\] | \00302CLOSELIST\00301 \[\00304 3 \00301\] | \00302HOSTLIST\00301 \[\00304 3 \00301\]"
				eva:FCT:SENT:NOTICE "$vuser" "\00302IDENTLIST\00301 \[\00304 3 \00301\] | \00302JOIN\00301 \[\00304 3 \00301\] | \00302LIST\00301 \[\00304 3 \00301\] | \00302NICKLIST\00301 \[\00304 3 \00301\] | \00302NOTICE\00301 \[\00304 3 \00301\]"
				eva:FCT:SENT:NOTICE "$vuser" "\00302PART\00301 \[\00304 3 \00301\] | \00302REALLIST\00301 \[\00304 3 \00301\] | \00302SAY\00301 \[\00304 3 \00301\] | \00302SECULIST\00301 \[\00304 3 \00301\] | \00302STATUS\00301 \[\00304 3 \00301\]"
				eva:FCT:SENT:NOTICE "$vuser" "\00302SVSJOIN\00301 \[\00304 3 \00301\] | \00302SVSNICK\00301 \[\00304 3 \00301\] | \00302SVSPART\00301 \[\00304 3 \00301\] | \00302TRUSTLIST\00301 \[\00304 3 \00301\] | \00302UNCLOSE\00301 \[\00304 3 \00301\]"
				eva:FCT:SENT:NOTICE "$vuser" "\003"
			}
			if { [info exists admins($vuser)] && [matchattr $admins($vuser) n] } {
				eva:FCT:SENT:NOTICE "$vuser" "\00301\[ Level Admin \]"
				eva:FCT:SENT:NOTICE "$vuser" "\00302ADDACCESS\00301 \[\00304 4 \00301\] | \00302ADDCHAN\00301 \[\00304 4 \00301\] | \00302ADDCLIENT\00301 \[\00304 4 \00301\] | \00302ADDHOST\00301 \[\00304 4 \00301\] | \00302ADDIDENT\00301 \[\00304 4 \00301\]"
				eva:FCT:SENT:NOTICE "$vuser" "\00302ADDNICK\00301 \[\00304 4 \00301\] | \00302ADDREAL\00301 \[\00304 4 \00301\] | \00302ADDSECU\00301 \[\00304 4 \00301\] | \00302ADDTRUST\00301 \[\00304 4 \00301\] | \00302BACKUP\00301 \[\00304 4 \00301\]"
				eva:FCT:SENT:NOTICE "$vuser" "\00302CHANLOG\00301 \[\00304 4 \00301\] | \00302CLIENT\00301 \[\00304 4 \00301\] | \00302CLONE\00301 \[\00304 4 \00301\] | \00302CONSOLE\00301 \[\00304 4 \00301\] | \00302DELACCESS\00301 \[\00304 4 \00301\]"
				eva:FCT:SENT:NOTICE "$vuser" "\00302DELCHAN\00301 \[\00304 4 \00301\] | \00302DELCLIENT\00301 \[\00304 4 \00301\] | \00302DELHOST\00301 \[\00304 4 \00301\] | \00302DELIDENT\00301 \[\00304 4 \00301\] | \00302DELNICK\00301 \[\00304 4 \00301\]"
				eva:FCT:SENT:NOTICE "$vuser" "\00302DELREAL\00301 \[\00304 4 \00301\] | \00302DELSECU\00301 \[\00304 4 \00301\] | \00302DELTRUST\00301 \[\00304 4 \00301\] | \00302DIE\00301 \[\00304 4 \00301\] | \00302MAXLOGIN\00301 \[\00304 4 \00301\]"
				eva:FCT:SENT:NOTICE "$vuser" "\00302MODACCESS\00301 \[\00304 4 \00301\] | \00302PROTECTION\00301 \[\00304 4 \00301\] | \00302RESTART\00301 \[\00304 4 \00301\] | \00302SECU\00301 \[\00304 4 \00301\]"
				eva:FCT:SENT:NOTICE "$vuser" "\003"
			}
			if { [eva:console 1]=="ok" } {
				eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Showcommands \003$eva(console_deco):\003$eva(console_txt) $user"
			}
		}
		"help" {
			eva:FCT:SENT:NOTICE "$vuser" "\002\00301,01--------------------------------------- \00300Commandes de Eva Service \00301---------------------------------------"
			eva:FCT:SENT:NOTICE "$vuser" "\003"
			eva:FCT:SENT:NOTICE "$vuser" "\00301\[ Level Utilisateur \]"
			eva:FCT:SENT:NOTICE "$vuser" "\00302AUTH\00301 \[\00304 0 \00301\] | \00302COPYRIGHT\00301 \[\00304 0 \00301\] | \00302DEAUTH\00301 \[\00304 0 \00301\] | \00302HELP\00301 \[\00304 0 \00301\]"
			eva:FCT:SENT:NOTICE "$vuser" "\00302SEEN\00301 \[\00304 0 \00301\] | \00302SHOWCOMMANDS\00301 \[\00304 0 \00301\]"
			eva:FCT:SENT:NOTICE "$vuser" "\003"
			if { [info exists admins($vuser)] && [matchattr $admins($vuser) p] } {
				eva:FCT:SENT:NOTICE "$vuser" "\00301\[ Level Helpeur \]"
				eva:FCT:SENT:NOTICE "$vuser" "\00302MAP\00301 \[\00304 1 \00301\] | \00302WHOIS\00301 \[\00304 1 \00301\]"
				eva:FCT:SENT:NOTICE "$vuser" "\003"
			}
			if { [info exists admins($vuser)] && [matchattr $admins($vuser) o] } {
				eva:FCT:SENT:NOTICE "$vuser" "\00301\[ Level Géofront \]"
				eva:FCT:SENT:NOTICE "$vuser" "\00302ACCESS\00301 \[\00304 2 \00301\] | \00302BAN\00301 \[\00304 2 \00301\] | \00302CLEARALLMODES\00301 \[\00304 2 \00301\] | \00302CLEARBANS\00301 \[\00304 2 \00301\] | \00302CLEARMODES\00301 \[\00304 2 \00301\] | \00302DEHALFOP\00301 \[\00304 2 \00301\]"
				eva:FCT:SENT:NOTICE "$vuser" "\00302DEHALFOPALL\00301 \[\00304 2 \00301\] | \00302DEOP\00301 \[\00304 2 \00301\] | \00302DEOPALL\00301 \[\00304 2 \00301\] | \00302DEOWNER\00301 \[\00304 2 \00301\] | \00302DEOWNERALL\00301 \[\00304 2 \00301\]"
				eva:FCT:SENT:NOTICE "$vuser" "\00302DEPROTECT\00301 \[\00304 2 \00301\] | \00302DEPROTECTALL\00301 \[\00304 2 \00301\] | \00302DEVOICE\00301 \[\00304 2 \00301\] | \00302DEVOICEALL\00301 \[\00304 2 \00301\] | \00302GLINE\00301 \[\00304 2 \00301\] | \00302SHUN\00301 \[\00304 2 \00301\]"
				eva:FCT:SENT:NOTICE "$vuser" "\00302GLINELIST\00301 \[\00304 2 \00301\] | \00302GLOBOPS\00301 \[\00304 2 \00301\] | \00302HALFOP\00301 \[\00304 2 \00301\] | \00302HALFOPALL\00301 \[\00304 2 \00301\] | \00302INVITE\00301 \[\00304 2 \00301\]"
				eva:FCT:SENT:NOTICE "$vuser" "\00302INVITEME\00301 \[\00304 2 \00301\] | \00302KICK\00301 \[\00304 2 \00301\] | \00302KICKALL\00301 \[\00304 2 \00301\] | \00302KICKBAN\00301 \[\00304 2 \00301\]"
				eva:FCT:SENT:NOTICE "$vuser" "\00302KILL\00301 \[\00304 2 \00301\] | \00302KLINE\00301 \[\00304 2 \00301\] | \00302KLINELIST\00301 \[\00304 2 \00301\] | \00302MODE\00301 \[\00304 2 \00301\] | \00302NEWPASS\00301 \[\00304 2 \00301\]"
				eva:FCT:SENT:NOTICE "$vuser" "\00302NICKBAN\00301 \[\00304 2 \00301\] | \00302OP\00301 \[\00304 2 \00301\] | \00302OPALL\00301 \[\00304 2 \00301\] | \00302OWNER\00301 \[\00304 2 \00301\] | \00302OWNERALL\00301 \[\00304 2 \00301\]"
				eva:FCT:SENT:NOTICE "$vuser" "\00302PROTECT\00301 \[\00304 2 \00301\] | \00302PROTECTALL\00301 \[\00304 2 \00301\] | \00302TOPIC\00301 \[\00304 2 \00301\] | \00302UNBAN\00301 \[\00304 2 \00301\] | \00302UNGLINE\00301 \[\00304 2 \00301\] | \00302UNSHUN\00301 \[\00304 2 \00301\]"
				eva:FCT:SENT:NOTICE "$vuser" "\00302UNKLINE\00301 \[\00304 2 \00301\] | \00302VOICE\00301 \[\00304 2 \00301\] | \00302VOICEALL\00301 \[\00304 2 \00301\] | \00302WALLOPS\00301 \[\00304 2 \00301\]"
				eva:FCT:SENT:NOTICE "$vuser" "\003"
			}
			if { [info exists admins($vuser)] && [matchattr $admins($vuser) m] } {
				eva:FCT:SENT:NOTICE "$vuser" "\00301\[ Level Ircop \]"
				eva:FCT:SENT:NOTICE "$vuser" "\00302CHANGLINE\00301 \[\00304 3 \00301\] | \00302CHANKILL\00301 \[\00304 3 \00301\] | \00302CHANLIST\00301 \[\00304 3 \00301\] | \00302CLEARCLOSE\00301 \[\00304 3 \00301\] | \00302CLEARGLINE\00301 \[\00304 3 \00301\]"
				eva:FCT:SENT:NOTICE "$vuser" "\00302CLEARKLINE\00301 \[\00304 3 \00301\] | \00302CLIENTLIST\00301 \[\00304 3 \00301\] | \00302CLOSE\00301 \[\00304 3 \00301\] | \00302CLOSELIST\00301 \[\00304 3 \00301\] | \00302HOSTLIST\00301 \[\00304 3 \00301\]"
				eva:FCT:SENT:NOTICE "$vuser" "\00302IDENTLIST\00301 \[\00304 3 \00301\] | \00302JOIN\00301 \[\00304 3 \00301\] | \00302LIST\00301 \[\00304 3 \00301\] | \00302NICKLIST\00301 \[\00304 3 \00301\] | \00302NOTICE\00301 \[\00304 3 \00301\]"
				eva:FCT:SENT:NOTICE "$vuser" "\00302PART\00301 \[\00304 3 \00301\] | \00302REALLIST\00301 \[\00304 3 \00301\] | \00302SAY\00301 \[\00304 3 \00301\] | \00302SECULIST\00301 \[\00304 3 \00301\] | \00302STATUS\00301 \[\00304 3 \00301\]"
				eva:FCT:SENT:NOTICE "$vuser" "\00302SVSJOIN\00301 \[\00304 3 \00301\] | \00302SVSNICK\00301 \[\00304 3 \00301\] | \00302SVSPART\00301 \[\00304 3 \00301\] | \00302TRUSTLIST\00301 \[\00304 3 \00301\] | \00302UNCLOSE\00301 \[\00304 3 \00301\]"
				eva:FCT:SENT:NOTICE "$vuser" "\003"
			}
			if { [info exists admins($vuser)] && [matchattr $admins($vuser) n] } {
				eva:FCT:SENT:NOTICE "$vuser" "\00301\[ Level Admin \]"
				eva:FCT:SENT:NOTICE "$vuser" "\00302ADDACCESS\00301 \[\00304 4 \00301\] | \00302ADDCHAN\00301 \[\00304 4 \00301\] | \00302ADDCLIENT\00301 \[\00304 4 \00301\] | \00302ADDHOST\00301 \[\00304 4 \00301\] | \00302ADDIDENT\00301 \[\00304 4 \00301\]"
				eva:FCT:SENT:NOTICE "$vuser" "\00302ADDNICK\00301 \[\00304 4 \00301\] | \00302ADDREAL\00301 \[\00304 4 \00301\] | \00302ADDSECU\00301 \[\00304 4 \00301\] | \00302ADDTRUST\00301 \[\00304 4 \00301\] | \00302BACKUP\00301 \[\00304 4 \00301\]"
				eva:FCT:SENT:NOTICE "$vuser" "\00302CHANLOG\00301 \[\00304 4 \00301\] | \00302CLIENT\00301 \[\00304 4 \00301\] | \00302CLONE\00301 \[\00304 4 \00301\] | \00302CONSOLE\00301 \[\00304 4 \00301\] | \00302DELACCESS\00301 \[\00304 4 \00301\]"
				eva:FCT:SENT:NOTICE "$vuser" "\00302DELCHAN\00301 \[\00304 4 \00301\] | \00302DELCLIENT\00301 \[\00304 4 \00301\] | \00302DELHOST\00301 \[\00304 4 \00301\] | \00302DELIDENT\00301 \[\00304 4 \00301\] | \00302DELNICK\00301 \[\00304 4 \00301\]"
				eva:FCT:SENT:NOTICE "$vuser" "\00302DELREAL\00301 \[\00304 4 \00301\] | \00302DELSECU\00301 \[\00304 4 \00301\] | \00302DELTRUST\00301 \[\00304 4 \00301\] | \00302DIE\00301 \[\00304 4 \00301\] | \00302MAXLOGIN\00301 \[\00304 4 \00301\]"
				eva:FCT:SENT:NOTICE "$vuser" "\00302MODACCESS\00301 \[\00304 4 \00301\] | \00302PROTECTION\00301 \[\00304 4 \00301\] | \00302RESTART\00301 \[\00304 4 \00301\] | \00302SECU\00301 \[\00304 4 \00301\]"
				eva:FCT:SENT:NOTICE "$vuser" "\003"
			}
			if { [eva:console 1]=="ok" } {
				eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Help \003$eva(console_deco):\003$eva(console_txt) $user"
			}
		}
		"maxlogin" {
			if { $value2!="on" && $value2!="off" } {
				eva:FCT:SENT:NOTICE "$vuser" "\002Commande Maxlogin :\002 /msg $eva(pseudo) maxlogin on/off";
				return 0;
			}

			if { $value2=="on" } {
				if { $eva(login)==0 } {
					set eva(login)		1; eva:FCT:SENT:NOTICE "$vuser" "Protection maxlogin activée"
					if { [eva:console 1]=="ok" } {
						eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Maxlogin \003$eva(console_deco):\003$eva(console_txt) $user"
					}
				} else {
					eva:FCT:SENT:NOTICE "$vuser" "La protection maxlogin est déjà activée."
				}
			} elseif { $value2=="off" } {
				if { $eva(login)==1 } {
					set eva(login)		0; eva:FCT:SENT:NOTICE "$vuser" "Protection maxlogin désactivée"
					if { [eva:console 1]=="ok" } {
						eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Maxlogin \003$eva(console_deco):\003$eva(console_txt) $user"
					}
				} else {
					eva:FCT:SENT:NOTICE "$vuser" "La protection maxlogin est déjà désactivée."
				}
			}
		}
		"backup" {
			eva:gestion
			exec cp -f [eva:scriptdir]db/gestion.db [eva:scriptdir]db/gestion.bak
			exec cp -f [eva:scriptdir]db/chan.db [eva:scriptdir]db/chan.bak
			exec cp -f [eva:scriptdir]db/client.db [eva:scriptdir]db/client.bak
			exec cp -f [eva:scriptdir]db/secu.db [eva:scriptdir]db/secu.bak
			exec cp -f [eva:scriptdir]db/close.db [eva:scriptdir]db/close.bak
			exec cp -f [eva:scriptdir]db/real.db [eva:scriptdir]db/real.bak
			exec cp -f [eva:scriptdir]db/ident.db [eva:scriptdir]db/ident.bak
			exec cp -f [eva:scriptdir]db/host.db [eva:scriptdir]db/host.bak
			exec cp -f [eva:scriptdir]db/nick.db [eva:scriptdir]db/nick.bak
			exec cp -f [eva:scriptdir]db/salon.db [eva:scriptdir]db/salon.bak
			exec cp -f [eva:scriptdir]db/trust.db [eva:scriptdir]db/trust.bak
			eva:FCT:SENT:NOTICE "$vuser" "Sauvegarde des databases réalisée."
			if { [eva:console 1]=="ok" } {
				eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Backup \003$eva(console_deco):\003$eva(console_txt) $user"
			}
		}
		"restart" {
			if { [eva:console 1]=="ok" } {
				eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Restart \003$eva(console_deco):\003$eva(console_txt) $user"
			}
			eva:FCT:SENT:NOTICE "$vuser" "Redémarrage de Eva Service."
			eva:gestion; eva:sent2socket $eva(idx) ":$eva(server_id) QUIT $eva(raison)"; eva:sent2socket $eva(idx) ":$eva(link) SQUIT $eva(link) :$eva(raison)"
			foreach kill [utimers] {
				if { [lindex $kill 1]=="eva:verif" } { killutimer [lindex $kill 2] }
			}
			if { [info exists eva(idx)] } { unset eva(idx)		}
			set eva(counter)		0;
			if { [eva:config]!="ok" } { utimer 1 eva:connexion
		}
	}
	"die" {
		if { [eva:console 1]=="ok" } {
			eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Die \003$eva(console_deco):\003$eva(console_txt) $user"
		}
		eva:FCT:SENT:NOTICE "$vuser" "Arrêt de Eva Service."
		eva:gestion; eva:sent2socket $eva(idx) ":$eva(server_id) QUIT $eva(raison)"; eva:sent2socket $eva(idx) ":$eva(link) SQUIT $eva(link) :$eva(raison)"
		foreach kill [utimers] {
			if { [lindex $kill 1]=="eva:verif" } { killutimer [lindex $kill 2] }
		}
		if { [info exists eva(idx)] } { unset eva(idx)		}
	}
	"status" {
		set numuser		0;
		set numident		0;
		set numhost		0;
		set numreal		0;
		set numtrust		0
		set numclose		0;
		set numsalons		0;
		set numsalon		0;
		set numchan		0;
		set numclient		0;
		set show		""
		set up		[expr ([clock seconds] - $eva(uptime))]
		set jour		[expr ($up / 86400)]
		set up		[expr ($up % 86400)]
		set heure		[expr ($up / 3600)]
		set up		[expr ($up % 3600)]
		set minute		[expr ($up / 60)]
		set seconde		[expr ($up % 60)]
		if { $jour == 1 } { append show "$jour jour " } elseif { $jour > 1 } { append show "$jour jours " }
		if { $heure == 1 } { append show "$heure heure " } elseif { $heure > 1 } { append show "$heure heures " }
		if { $minute == 1 } { append show "$minute minute " } elseif { $minute > 1 } { append show "$minute minutes " }
		if { $seconde == 1 } { append show "$seconde seconde " } elseif { $seconde > 1 } { append show "$seconde secondes " }
		catch { open [eva:scriptdir]db/client.db r } liste
		while { ![eof $liste] } {
			gets $liste sclients;
			if { $sclients!="" } { incr numclient 1 }
		}
		catch { close $liste }
		catch { open [eva:scriptdir]db/chan.db r } liste2
		while { ![eof $liste2] } {
			gets $liste2 schans;
			if { $schans!="" } { incr numchan 1 }
		}
		catch { close $liste2 }
		catch { open [eva:scriptdir]db/secu.db r } liste3
		while { ![eof $liste3] } {
			gets $liste3 ssalons;
			if { $ssalons!="" } { incr numsalon 1 }
		}
		catch { close $liste3 }
		catch { open [eva:scriptdir]db/salon.db r } liste4
		while { ![eof $liste4] } {
			gets $liste4 ssalon;
			if { $ssalon!="" } { incr numsalons 1 }
		}
		catch { close $liste4 }
		catch { open [eva:scriptdir]db/close.db r } liste5
		while { ![eof $liste5] } {
			gets $liste5 sclose;
			if { $sclose!="" } { incr numclose 1 }
		}
		catch { close $liste5 }
		catch { open [eva:scriptdir]db/nick.db r } liste6
		while { ![eof $liste6] } {
			gets $liste6 suser;
			if { $suser!="" } { incr numuser 1 }
		}
		catch { close $liste6 }
		catch { open [eva:scriptdir]db/ident.db r } liste7
		while { ![eof $liste7] } {
			gets $liste7 sident;
			if { $sident!="" } { incr numident 1 }
		}
		catch { close $liste7 }
		catch { open [eva:scriptdir]db/host.db r } liste8
		while { ![eof $liste8] } {
			gets $liste8 shost;
			if { $shost!="" } { incr numhost 1 }
		}
		catch { close $liste8 }
		catch { open [eva:scriptdir]db/real.db r } liste9
		while { ![eof $liste9] } {
			gets $liste9 sreal;
			if { $sreal!="" } { incr numreal 1 }
		}
		catch { close $liste9 }
		catch { open [eva:scriptdir]db/trust.db r } liste10
		while { ![eof $liste10] } {
			gets $liste10 strust;
			if { $strust!="" } { incr numtrust 1 }
		}
		catch { close $liste10 }
		eva:FCT:SENT:NOTICE "$vuser" "\002\0031,1------------------ \0030Status de Eva Service \0031------------------"
		eva:FCT:SENT:NOTICE "$vuser" "\002"
		eva:FCT:SENT:NOTICE "$vuser" "\00302 Owner : \00301$admin"
		eva:FCT:SENT:NOTICE "$vuser" "\00302 Salon de logs : \00301$eva(salon)"
		eva:FCT:SENT:NOTICE "$vuser" "\00302 Salon Autojoin : \00301$numchan"
		eva:FCT:SENT:NOTICE "$vuser" "\00302 Uptime : \00301$show"
		switch -exact $eva(console) {
			0 { eva:FCT:SENT:NOTICE "$vuser" "\00302 Level Console : \003010" }
			1 { eva:FCT:SENT:NOTICE "$vuser" "\00302 Level Console : \003011" }
			2 { eva:FCT:SENT:NOTICE "$vuser" "\00302 Level Console : \003012" }
			3 { eva:FCT:SENT:NOTICE "$vuser" "\00302 Level Console : \003013" }
		}
		switch -exact $eva(protection) {
			0 { eva:FCT:SENT:NOTICE "$vuser" "\00302 Level Protection : \003010" }
			1 { eva:FCT:SENT:NOTICE "$vuser" "\00302 Level Protection : \003011" }
			2 { eva:FCT:SENT:NOTICE "$vuser" "\00302 Level Protection : \003012" }
			3 { eva:FCT:SENT:NOTICE "$vuser" "\00302 Level Protection : \003013" }
			4 { eva:FCT:SENT:NOTICE "$vuser" "\00302 Level Protection : \003014" }
		}
		if { $eva(login)==1 } {
			eva:FCT:SENT:NOTICE "$vuser" "\00302 Protection Maxlogin : \00303On"
		} else {
			eva:FCT:SENT:NOTICE "$vuser" "\00302 Protection Maxlogin : \00304Off"
		}
		if { $eva(aclone)==1 } {
			eva:FCT:SENT:NOTICE "$vuser" "\00302 Protection Clones : \00303On"
		} else {
			eva:FCT:SENT:NOTICE "$vuser" "\00302 Protection Clones : \00304Off"
		}
		if { $eva(aclient)==1 } {
			eva:FCT:SENT:NOTICE "$vuser" "\00302 Protection Clients IRC : \00303On"
		} else {
			eva:FCT:SENT:NOTICE "$vuser" "\00302 Protection Clients IRC : \00304Off"
		}
		if { $eva(secu)==1 } {
			eva:FCT:SENT:NOTICE "$vuser" "\00302 Sécurité Salons : \00303On"
		} else {
			eva:FCT:SENT:NOTICE "$vuser" "\00302 Sécurité Salons : \00304Off"
		}
		eva:FCT:SENT:NOTICE "$vuser" "\00302 Nbre de Salons Sécurisés : \00301$numsalon"
		eva:FCT:SENT:NOTICE "$vuser" "\00302 Nbre de Salons Fermés : \00301$numclose"
		eva:FCT:SENT:NOTICE "$vuser" "\00302 Nbre de Salons Interdits : \00301$numsalons"
		eva:FCT:SENT:NOTICE "$vuser" "\00302 Nbre de Pseudos Interdits : \00301$numuser"
		eva:FCT:SENT:NOTICE "$vuser" "\00302 Nbre de Idents Interdits : \00301$numident"
		eva:FCT:SENT:NOTICE "$vuser" "\00302 Nbre de Hostnames Interdites : \00301$numhost"
		eva:FCT:SENT:NOTICE "$vuser" "\00302 Nbre de Realnames Interdits : \00301$numreal"
		eva:FCT:SENT:NOTICE "$vuser" "\00302 Nbre de Clients IRC : \00301$numclient"
		eva:FCT:SENT:NOTICE "$vuser" "\00302 Nbre de Trusts : \00301$numtrust"
		eva:FCT:SENT:NOTICE "$vuser" "\002"
		if { [eva:console 1]=="ok" } {
			eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Status \003$eva(console_deco):\003$eva(console_txt) $user"
		}
	}
	"protection" {
		if { $value2=="" || [regexp \[^0-4\] $value2] } {
			eva:FCT:SENT:NOTICE "$vuser" "\002Commande Protection :\002 /msg $eva(pseudo) protection 0/1/2/3/4"
			eva:FCT:SENT:NOTICE "$vuser" "\00302Level 0 \00304:\00301 Aucune Protection"
			eva:FCT:SENT:NOTICE "$vuser" "\00302Level 1 \00304:\00301 Protection Admins"
			eva:FCT:SENT:NOTICE "$vuser" "\00302Level 2 \00304:\00301 Protection Admins + Ircops"
			eva:FCT:SENT:NOTICE "$vuser" "\00302Level 3 \00304:\00301 Protection Admins + Ircops + Géofronts"
			eva:FCT:SENT:NOTICE "$vuser" "\00302Level 4 \00304:\00301 Protection de tous les accès"
			return 0
		}
		switch -exact $value2 {
			0 {
				set eva(protection)		0; eva:FCT:SENT:NOTICE "$vuser" "Level 0 : Aucune Protection"
				eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Protection \003$eva(console_deco):\003$eva(console_txt) $user"
			}
			1 {
				set eva(protection)		1; eva:FCT:SENT:NOTICE "$vuser" "Level 1 : Protection Admins"
				eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Protection \003$eva(console_deco):\003$eva(console_txt) $user"
			}
			2 {
				set eva(protection)		2; eva:FCT:SENT:NOTICE "$vuser" "Level 2 : Protection Admins + Ircops"
				eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Protection \003$eva(console_deco):\003$eva(console_txt) $user"
			}
			3 {
				set eva(protection)		3; eva:FCT:SENT:NOTICE "$vuser" "Level 3 : Protection Admins + Ircops + Géofronts"
				eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Protection \003$eva(console_deco):\003$eva(console_txt) $user"
			}
			4 {
				set eva(protection)		4; eva:FCT:SENT:NOTICE "$vuser" "Level 4 : Protection de tous les accès"
				eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Protection \003$eva(console_deco):\003$eva(console_txt) $user"
			}
		}
	}
	"newpass" {
		if { $value1=="" } {
			eva:FCT:SENT:NOTICE "$vuser" "\002Commande Newpass :\002 /msg $eva(pseudo) newpass mot-de-passe";
			return 0;
		}

		if { [string length $value1]<=5 } {
			eva:FCT:SENT:NOTICE "$vuser" "Le mot de passe doit contenir minimum 6 caractères.";
			return 0;
		}

		setuser $admins($vuser) PASS $value1
		eva:FCT:SENT:NOTICE "$user" "Changement du mot de passe reussi."
		if { [eva:console 1]=="ok" } {
			eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Newpass \003$eva(console_deco):\003$eva(console_txt) $user"
		}
	}
	"map" {
		set eva(rep)		$vuser
		eva:sent2socket $eva(idx) ":$eva(server_id) LINKS"
		if { [eva:console 1]=="ok" } {
			eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Map \003$eva(console_deco):\003$eva(console_txt) $user"
		}
	}
	"seen" {
		if { $value1=="" } {
			eva:FCT:SENT:NOTICE "$user" "\002Commande Seen :\002 /msg $eva(pseudo) seen pseudo";
			return 0;
		}

		if { [validuser $value1] } {
			set annee		[lindex [ctime [getuser $value1 LASTON]] 4]
			if { $annee!="1970" } { set seen		[eva:duree [getuser $value1 LASTON]] } else {
				set seen		"Jamais"
			}
			if { [eva:console 1]=="ok" } {
				eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Seen \003$eva(console_deco):\003$eva(console_txt) $user"
			}
			if { [matchattr $value1 n] } {
				eva:FCT:SENT:NOTICE "$vuser" "\0031Pseudo \[\0034$value1\0031\] \003 Level \[\00303Admin\0031\] \003 Seen \[\00302$seen\0031\]"
			} elseif { [matchattr $value1 m] } {
				eva:FCT:SENT:NOTICE "$vuser" "\0031Pseudo \[\0034$value1\0031\] \003 Level \[\00303Ircop\0031\] \003 Seen \[\00302$seen\0031\]"
			} elseif { [matchattr $value1 o] } {
				eva:FCT:SENT:NOTICE "$vuser" "\0031Pseudo \[\0034$value1\0031\] \003 Level \[\00303Géofront\0031\] \003 Seen \[\00302$seen\0031\]"
			} elseif { [matchattr $value1 p] } {
				eva:FCT:SENT:NOTICE "$vuser" "\0031Pseudo \[\0034$value1\0031\] \003 Level \[\00303Helpeur\0031\] \003 Seen \[\00302$seen\0031\]"
			}
		} else {
			eva:FCT:SENT:NOTICE "$vuser" "Pseudo inconnu.";
			return 0;

		}
	}
	"access" {
		if { $value1=="*" || $value1=="" } {
			if { [eva:console 1]=="ok" } {
				eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Access \003$eva(console_deco):\003$eva(console_txt) $user"
			}
			eva:FCT:SENT:NOTICE "$vuser" "\002\0031,1------------------------------- \0030Liste des Accès \0031-------------------------------"
			eva:FCT:SENT:NOTICE "$vuser" "\002"
			foreach acces [userlist] {
				set annee		[lindex [ctime [getuser $acces LASTON]] 4]
				if { $annee!="1970" } { set seen		[eva:duree [getuser $acces LASTON]] } else {
					set seen		"Jamais"
				}
				foreach { act reg } [array get admins] {
					if { $reg==[string tolower $acces] } { set status		"\00303Online" }
				}
				if { ![info exists status] } { set status		"\00304Offline" }
				switch -exact $eva(protection) {
					1 {
						if { [matchattr $acces n] } { set aprotect		"\00303On" }
					}
					2 {
						if { [matchattr $acces m] } { set aprotect		"\00303On" }
					}
					3 {
						if { [matchattr $acces o] } { set aprotect		"\00303On" }
					}
					4 {
						if { [matchattr $acces p] } { set aprotect		"\00303On" }
					}
				}
				if { ![info exists aprotect] } { set aprotect		"\00304Off" }
				if { [matchattr $acces n] } {
					eva:FCT:SENT:NOTICE "$vuser" "\00301 Pseudo \[\00304$acces\00301\] \00301 Level \[\00303Admin\00301\] \00301 Seen \[\00312$seen\00301\]"
					eva:FCT:SENT:NOTICE "$vuser" "\00301 Statut \[$status\00301\] \00301 Protection \[$aprotect\00301\]"
					eva:FCT:SENT:NOTICE "$vuser" "\00301 Mask \[\00302[getuser $acces HOSTS]\00301\]"
					eva:FCT:SENT:NOTICE "$vuser" "\003"
				} elseif { [matchattr $acces m] } {
					eva:FCT:SENT:NOTICE "$vuser" "\00301 Pseudo \[\00304$acces\00301\] \00301 Level \[\00303Ircop\00301\] \00301 Seen \[\00312$seen\00301\]"
					eva:FCT:SENT:NOTICE "$vuser" "\00301 Statut \[$status\00301\] \00301 Protection \[$aprotect\00301\]"
					eva:FCT:SENT:NOTICE "$vuser" "\00301 Mask \[\00302[getuser $acces HOSTS]\00301\]"
					eva:FCT:SENT:NOTICE "$vuser" "\003"
				} elseif { [matchattr $acces o] } {
					eva:FCT:SENT:NOTICE "$vuser" "\00301 Pseudo \[\00304$acces\00301\] \00301 Level \[\00303Géofront\00301\] \00301 Seen \[\00312$seen\00301\]"
					eva:FCT:SENT:NOTICE "$vuser" "\00301 Statut \[$status\00301\] \00301 Protection \[$aprotect\00301\]"
					eva:FCT:SENT:NOTICE "$vuser" "\00301 Mask \[\00302[getuser $acces HOSTS]\00301\]"
					eva:FCT:SENT:NOTICE "$vuser" "\003"
				} elseif { [matchattr $acces p] } {
					eva:FCT:SENT:NOTICE "$vuser" "\00301 Pseudo \[\00304$acces\00301\] \00301 Level \[\00303Helpeur\00301\] \00301 Seen \[\00312$seen\00301\]"
					eva:FCT:SENT:NOTICE "$vuser" "\00301 Statut \[$status\00301\] \00301 Protection \[$aprotect\00301\]"
					eva:FCT:SENT:NOTICE "$vuser" "\00301 Mask \[\00302[getuser $acces HOSTS]\00301\]"
					eva:FCT:SENT:NOTICE "$vuser" "\003"
				}
				unset status;		unset seen;		unset aprotect
			}
		} elseif { [validuser $value1] } {
			set annee		[lindex [ctime [getuser $value1 LASTON]] 4]
			if { $annee!="1970" } { set seen		[eva:duree [getuser $value1 LASTON]] } else {
				set seen		"Jamais"
			}
			foreach { act reg } [array get admins] {
				if { $reg==[string tolower $value1] } { set status		"\00303Online" }
			}
			if { ![info exists status] } { set status		"\00304Offline" }
			switch -exact $eva(protection) {
				1 {
					if { [matchattr $value1 n] } { set aprotect		"\00303On" }
				}
				2 {
					if { [matchattr $value1 m] } { set aprotect		"\00303On" }
				}
				3 {
					if { [matchattr $value1 o] } { set aprotect		"\00303On" }
				}
				4 {
					if { [matchattr $value1 p] } { set aprotect		"\00303On" }
				}
			}
			if { ![info exists aprotect] } { set aprotect		"\00304Off" }
			if { [eva:console 1]=="ok" } {
				eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Access \003$eva(console_deco):\003$eva(console_txt) $user"
			}
			eva:FCT:SENT:NOTICE "$vuser" "\002\0031,1--------------------------- \0030Accès de $value1 \0031---------------------------"
			eva:FCT:SENT:NOTICE "$vuser" "\002"
			if { [matchattr $value1 n] } {
				eva:FCT:SENT:NOTICE "$vuser" "\00301 Pseudo \[\00304$value1\00301\] \00301 Level \[\00303Admin\00301\] \00301 Seen \[\00312$seen\00301\]"
				eva:FCT:SENT:NOTICE "$vuser" "\00301 Statut \[$status\00301\] \00301 Protection \[$aprotect\00301\]"
				eva:FCT:SENT:NOTICE "$vuser" "\00301 Mask \[\00302[getuser $value1 HOSTS]\00301\]"
			} elseif { [matchattr $value1 m] } {
				eva:FCT:SENT:NOTICE "$vuser" "\00301 Pseudo \[\00304$value1\00301\] \00301 Level \[\00303Ircop\00301\] \003 Seen \[\00312$seen\00301\]"
				eva:FCT:SENT:NOTICE "$vuser" "\00301 Statut \[$status\00301\] \00301 Protection \[$aprotect\00301\]"
				eva:FCT:SENT:NOTICE "$vuser" "\00301 Mask \[\00302[getuser $value1 HOSTS]\00301\]"
			} elseif { [matchattr $value1 o] } {
				eva:FCT:SENT:NOTICE "$vuser" "\00301 Pseudo \[\00304$value1\00301\] \00301 Level \[\00303Géofront\00301\] \00301 Seen \[\00312$seen\00301\]"
				eva:FCT:SENT:NOTICE "$vuser" "\00301 Statut \[\00303$status\00301\] \00301 Protection \[$aprotect\00301\]"
				eva:FCT:SENT:NOTICE "$vuser" "\00301 Mask \[\00302[getuser $value1 HOSTS]\00301\]"
			} elseif { [matchattr $value1 p] } {
				eva:FCT:SENT:NOTICE "$vuser" "\00301 Pseudo \[\00304$value1\00301\] \00301 Level \[\00303Helpeur\00301\] \00301 Seen \[\00312$seen\00301\]"
				eva:FCT:SENT:NOTICE "$vuser" "\00301 Statut \[$status\00301\] \00301 Protection \[$aprotect\00301\]"
				eva:FCT:SENT:NOTICE "$vuser" "\00301 Mask \[\00302[getuser $value1 HOSTS]\00301\]"
			}
			eva:FCT:SENT:NOTICE "$vuser" "\003"
		} else {
			eva:FCT:SENT:NOTICE "$vuser" "Aucun Accès."
		}
	}
	"owner" {
		if { [string index $value1 0]!="#" } {
			eva:FCT:SENT:NOTICE "$vuser" "\002Commande Owner :\002 /msg $eva(pseudo) owner #salon pseudo";
			return 0;
		}

		if { $value4==[string tolower $eva(SID)] || [info exists ueva($value4)] || [eva:protection $value4 $eva(protection)]=="ok" } {
			eva:FCT:SENT:NOTICE "$user" "Accès Refusé : Pseudo Protégé";
			return 0;

		}
		if { $value4!="" } {
			if { ![info exists vhost($value4)] } {
				eva:FCT:SENT:NOTICE "$vuser" "Pseudo introuvable.";
				return 0
			}
			eva:sent2socket $eva(idx) ":$eva(server_id) MODE $value1 +q $value3"
			if { [eva:console 1]=="ok" && $value2!=[string tolower $eva(salon)] } {
				eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Owner \003$eva(console_deco):\003$eva(console_txt) $value3 sur $value1 par $user"
			}
		} else {
			eva:sent2socket $eva(idx) ":$eva(server_id) MODE $value1 +q $user"
			if { [eva:console 1]=="ok" && $value2!=[string tolower $eva(salon)] } {
				eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Owner \003$eva(console_deco):\003$eva(console_txt) $user sur $value1"
			}
		}
	}
	"deowner" {
		if { [string index $value1 0]!="#" } {
			eva:FCT:SENT:NOTICE "$vuser" "\002Commande Deowner :\002 /msg $eva(pseudo) deowner #salon pseudo";
			return 0;
		}

		if { $value4==[string tolower $eva(SID)] || [info exists ueva($value4)] || [eva:protection $value4 $eva(protection)]=="ok" } {
			eva:FCT:SENT:NOTICE "$user" "Accès Refusé : Pseudo Protégé";
			return 0;
		}

		if { $value4!="" } {
			if { ![info exists vhost($value4)] } {
				eva:FCT:SENT:NOTICE "$vuser" "Pseudo introuvable.";
				return 0;
			}

			eva:sent2socket $eva(idx) ":$eva(server_id) MODE $value1 -q $value3"
			if { [eva:console 1]=="ok" && $value2!=[string tolower $eva(salon)] } {
				eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Deowner \003$eva(console_deco):\003$eva(console_txt) $value3 sur $value1 par $user"
			}
		} else {
			eva:sent2socket $eva(idx) ":$eva(server_id) MODE $value1 -q $user"
			if { [eva:console 1]=="ok" && $value2!=[string tolower $eva(salon)] } {
				eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Deowner \003$eva(console_deco):\003$eva(console_txt) $user sur $value1"
			}
		}
	}
	"protect" {
		if { [string index $value1 0]!="#" } {
			eva:FCT:SENT:NOTICE "$vuser" "\002Commande Protect :\002 /msg $eva(pseudo) protect #salon pseudo";
			return 0;
		}

		if { $value4==[string tolower $eva(SID)] || [info exists ueva($value4)] || [eva:protection $value4 $eva(protection)]=="ok" } {
			eva:FCT:SENT:NOTICE "$user" "Accès Refusé : Pseudo Protégé";
			return 0;
		}

		if { $value4!="" } {
			if { ![info exists vhost($value4)] } {
				eva:FCT:SENT:NOTICE "$vuser" "Pseudo introuvable.";
				return 0;
			}

			eva:sent2socket $eva(idx) ":$eva(server_id) MODE $value1 +a $value3"
			if { [eva:console 1]=="ok" && $value2!=[string tolower $eva(salon)] } {
				eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Protect \003$eva(console_deco):\003$eva(console_txt) $value3 sur $value1 par $user"
			}
		} else {
			eva:sent2socket $eva(idx) ":$eva(server_id) MODE $value1 +a $user"
			if { [eva:console 1]=="ok" && $value2!=[string tolower $eva(salon)] } {
				eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Protect \003$eva(console_deco):\003$eva(console_txt) $user sur $value1"
			}
		}
	}
	"deprotect" {
		if { [string index $value1 0]!="#" } {
			eva:FCT:SENT:NOTICE "$vuser" "\002Commande Deprotect :\002 /msg $eva(pseudo) deprotect #salon pseudo";
			return 0;
		}

		if { $value4==[string tolower $eva(SID)] || [info exists ueva($value4)] || [eva:protection $value4 $eva(protection)]=="ok" } {
			eva:FCT:SENT:NOTICE "$user" "Accès Refusé : Pseudo Protégé";
			return 0;
		}

		if { $value4!="" } {
			if { ![info exists vhost($value4)] } {
				eva:FCT:SENT:NOTICE "$vuser" "Pseudo introuvable.";
				return 0;
			}

			eva:sent2socket $eva(idx) ":$eva(server_id) MODE $value1 -a $value3"
			if { [eva:console 1]=="ok" && $value2!=[string tolower $eva(salon)] } {
				eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Deprotect \003$eva(console_deco):\003$eva(console_txt) $value3 sur $value1 par $user"
			}
		} else {
			eva:sent2socket $eva(idx) ":$eva(server_id) MODE $value1 -a $user"
			if { [eva:console 1]=="ok" && $value2!=[string tolower $eva(salon)] } {
				eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Deprotect \003$eva(console_deco):\003$eva(console_txt) $user sur $value1"
			}
		}
	}
	"ownerall" {
		set eva(cmd)		"ownerall"
		if { [string index $value1 0]!="#" } {
			eva:FCT:SENT:NOTICE "$vuser" "\002Commande Ownerall :\002 /msg $eva(pseudo) ownerall #salon";
			return 0;
		}

		eva:sent2socket $eva(idx) ":$eva(link) NAMES $value1"
		if { [eva:console 1]=="ok" && $value2!=[string tolower $eva(salon)] } {
			eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Ownerall \003$eva(console_deco):\003$eva(console_txt) $value1 par $user"
		}
	}
	"deownerall" {
		set eva(cmd)		"deownerall"
		if { [string index $value1 0]!="#" } {
			eva:FCT:SENT:NOTICE "$vuser" "\002Commande Deownerall :\002 /msg $eva(pseudo) deownerall #salon";
			return 0;
		}

		eva:sent2socket $eva(idx) ":$eva(link) NAMES $value1"
		if { [eva:console 1]=="ok" && $value2!=[string tolower $eva(salon)] } {
			eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Deownerall \003$eva(console_deco):\003$eva(console_txt) $value1 par $user"
		}
	}
	"protectall" {
		set eva(cmd)		"protectall"
		if { [string index $value1 0]!="#" } {
			eva:FCT:SENT:NOTICE "$vuser" "\002Commande Protectall :\002 /msg $eva(pseudo) protectall #salon";
			return 0;
		}

		eva:sent2socket $eva(idx) ":$eva(link) NAMES $value1"
		if { [eva:console 1]=="ok" && $value2!=[string tolower $eva(salon)] } {
			eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Protectall \003$eva(console_deco):\003$eva(console_txt) $value1 par $user"
		}
	}
	"deprotectall" {
		set eva(cmd)		"deprotectall"
		if { [string index $value1 0]!="#" } {
			eva:FCT:SENT:NOTICE "$vuser" "\002Commande Deprotectall :\002 /msg $eva(pseudo) deprotectall #salon";
			return 0;
		}

		eva:sent2socket $eva(idx) ":$eva(link) NAMES $value1"
		if { [eva:console 1]=="ok" && $value2!=[string tolower $eva(salon)] } {
			eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Deprotectall \003$eva(console_deco):\003$eva(console_txt) $value1 par $user"
		}
	}
	"op" {
		if { [string index $value1 0]!="#" } {
			eva:FCT:SENT:NOTICE "$vuser" "\002Commande Op :\002 /msg $eva(pseudo) op #salon pseudo";
			return 0
		}
		if { $value4 == [string tolower $eva(SID)] || [info exists ueva($value4)] || [eva:protection $value4 $eva(protection)]=="ok" } {
			eva:FCT:SENT:NOTICE "$user" "Accès Refusé : Pseudo Protégé";
			return 0
		}
		if { $value4!="" } {
			if { ![info exists vhost($value4)] } {
				eva:FCT:SENT:NOTICE "$vuser" "Pseudo introuvable.";
				return 0;

			}
			eva:sent2socket $eva(idx) ":$eva(server_id) MODE $value1 +o $value3"
			if { [eva:console 1]=="ok" && $value2!=[string tolower $eva(salon)] } {
				eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Op \003$eva(console_deco):\003$eva(console_txt) $value3 a été opé par $user sur $value1"
			}
		} else {
			eva:sent2socket $eva(idx) ":$eva(server_id) MODE $value1 +o $user"
			if { [eva:console 1]=="ok" && $value2!=[string tolower $eva(salon)] } {
				eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Op \003$eva(console_deco):\003$eva(console_txt) $user a été opé sur $value1"
			}
		}
	}
	"deop" {
		if { [string index $value1 0]!="#" } {
			eva:FCT:SENT:NOTICE "$vuser" "\002Commande Deop :\002 /msg $eva(pseudo) deop #salon pseudo";
			return 0;
		}

		if { $value4==[string tolower $eva(SID)] || [info exists ueva($value4)] || [eva:protection $value4 $eva(protection)]=="ok" } {
			eva:FCT:SENT:NOTICE "$user" "Accès Refusé : Pseudo Protégé";
			return 0;
		}

		if { $value4!="" } {
			if { ![info exists vhost($value4)] } {
				eva:FCT:SENT:NOTICE "$vuser" "Pseudo introuvable.";
				return 0;
			}

			eva:sent2socket $eva(idx) ":$eva(server_id) MODE $value1 -o $value3"
			if { [eva:console 1]=="ok" && $value2!=[string tolower $eva(salon)] } {
				eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Deop \003$eva(console_deco):\003$eva(console_txt) $value3 a été déopé par $user sur $value1"
			}
		} else {
			eva:sent2socket $eva(idx) ":$eva(server_id) MODE $value1 -o $user"
			if { [eva:console 1]=="ok" && $value2!=[string tolower $eva(salon)] } {
				eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Deop \003$eva(console_deco):\003$eva(console_txt) $user a été déopé sur $value1"
			}
		}
	}
	"halfop" {
		if { [string index $value1 0]!="#" } {
			eva:FCT:SENT:NOTICE "$vuser" "\002Commande Halfop :\002 /msg $eva(pseudo) halfop #salon pseudo";
			return 0;
		}

		if { $value4==[string tolower $eva(SID)] || [info exists ueva($value4)] || [eva:protection $value4 $eva(protection)]=="ok" } {
			eva:FCT:SENT:NOTICE "$user" "Accès Refusé : Pseudo Protégé";
			return 0;
		}

		if { $value4!="" } {
			if { ![info exists vhost($value4)] } {
				eva:FCT:SENT:NOTICE "$vuser" "Pseudo introuvable.";
				return 0;
			}

			eva:sent2socket $eva(idx) ":$eva(server_id) MODE $value1 +h $value3"
			if { [eva:console 1]=="ok" && $value2!=[string tolower $eva(salon)] } {
				eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Halfop \003$eva(console_deco):\003$eva(console_txt) $value3 a été halfopé par $user sur $value1"
			}
		} else {
			eva:sent2socket $eva(idx) ":$eva(server_id) MODE $value1 +h $user"
			if { [eva:console 1]=="ok" && $value2!=[string tolower $eva(salon)] } {
				eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Halfop \003$eva(console_deco):\003$eva(console_txt) $user a été halfopé sur $value1"
			}
		}
	}
	"dehalfop" {
		if { [string index $value1 0]!="#" } {
			eva:FCT:SENT:NOTICE "$vuser" "\002Commande Dehalfop :\002 /msg $eva(pseudo) dehalfop #salon pseudo";
			return 0;
		}

		if { $value4==[string tolower $eva(SID)] || [info exists ueva($value4)] || [eva:protection $value4 $eva(protection)]=="ok" } {
			eva:FCT:SENT:NOTICE "$user" "Accès Refusé : Pseudo Protégé";
			return 0;
		}

		if { $value4!="" } {
			if { ![info exists vhost($value4)] } {
				eva:FCT:SENT:NOTICE "$vuser" "Pseudo introuvable.";
				return 0;
			}

			eva:sent2socket $eva(idx) ":$eva(server_id) MODE $value1 -h $value3"
			if { [eva:console 1]=="ok" && $value2!=[string tolower $eva(salon)] } {
				eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Dehalfop \003$eva(console_deco):\003$eva(console_txt) $value3 a été déhalfopé par $user sur $value1"
			}
		} else {
			eva:sent2socket $eva(idx) ":$eva(server_id) MODE $value1 -h $user"
			if { [eva:console 1]=="ok" && $value2!=[string tolower $eva(salon)] } {
				eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Dehalfop \003$eva(console_deco):\003$eva(console_txt) $user a été déhalfopé sur $value1"
			}
		}
	}
	"voice" {
		if { [string index $value1 0]!="#" } {
			eva:FCT:SENT:NOTICE "$vuser" "\002Commande Voice :\002 /msg $eva(pseudo) voice #salon pseudo";
			return 0;
		}

		if { $value4==[string tolower $eva(SID)] || [info exists ueva($value4)] || [eva:protection $value4 $eva(protection)]=="ok" } {
			eva:FCT:SENT:NOTICE "$user" "Accès Refusé : Pseudo Protégé";
			return 0;
		}

		if { $value4!="" } {
			if { ![info exists vhost($value4)] } {
				eva:FCT:SENT:NOTICE "$vuser" "Pseudo introuvable.";
				return 0;
			}

			eva:sent2socket $eva(idx) ":$eva(server_id) MODE $value1 +v $value3"
			if { [eva:console 1]=="ok" && $value2!=[string tolower $eva(salon)] } {
				eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Voice \003$eva(console_deco):\003$eva(console_txt) $value3 a été voicé par $user sur $value1"
			}
		} else {
			eva:sent2socket $eva(idx) ":$eva(server_id) MODE $value1 +v $user"
			if { [eva:console 1]=="ok" && $value2!=[string tolower $eva(salon)] } {
				eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Voice \003$eva(console_deco):\003$eva(console_txt) $user a été voicé sur $value1"
			}
		}
	}
	"devoice" {
		if { [string index $value1 0]!="#" } {
			eva:FCT:SENT:NOTICE "$vuser" "\002Commande Devoice :\002 /msg $eva(pseudo) devoice #salon pseudo";
			return 0;
		}

		if { $value4==[string tolower $eva(SID)] || [info exists ueva($value4)] || [eva:protection $value4 $eva(protection)]=="ok" } {
			eva:FCT:SENT:NOTICE "$user" "Accès Refusé : Pseudo Protégé";
			return 0;
		}

		if { $value4!="" } {
			if { ![info exists vhost($value4)] } {
				eva:FCT:SENT:NOTICE "$vuser" "Pseudo introuvable.";
				return 0;
			}

			eva:sent2socket $eva(idx) ":$eva(server_id) MODE $value1 -v $value3"
			if { [eva:console 1]=="ok" && $value2!=[string tolower $eva(salon)] } {
				eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Devoice \003$eva(console_deco):\003$eva(console_txt) $value3 a été dévoicé par $user sur $value1"
			}
		} else {
			eva:sent2socket $eva(idx) ":$eva(server_id) MODE $value1 -v $user"
			if { [eva:console 1]=="ok" && $value2!=[string tolower $eva(salon)] } {
				eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Devoice \003$eva(console_deco):\003$eva(console_txt) $user a été dévoicé sur $value1"
			}
		}
	}
	"opall" {
		set eva(cmd)		"opall"

		if { [string index $value1 0]!="#" } {
			eva:FCT:SENT:NOTICE "$vuser" "\002Commande Opall :\002 /msg $eva(pseudo) opall #salon";
			return 0;
		}


		eva:sent2socket $eva(idx) ":$eva(link) NAMES $value1"

		if { [eva:console 1]=="ok" && $value2!=[string tolower $eva(salon)] } {
			eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Opall \003$eva(console_deco):\003$eva(console_txt) $value1 par $user"
		}
	}
	"deopall" {
		set eva(cmd)		"deopall"
		if { [string index $value1 0]!="#" } {
			eva:FCT:SENT:NOTICE "$vuser" "\002Commande Deopall :\002 /msg $eva(pseudo) deopall #salon";
			return 0;
		}

		eva:sent2socket $eva(idx) ":$eva(link) NAMES $value1"
		if { [eva:console 1]=="ok" && $value2!=[string tolower $eva(salon)] } {
			eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Deopall \003$eva(console_deco):\003$eva(console_txt) $value1 par $user"
		}
	}
	"halfopall" {
		set eva(cmd)		"halfopall"
		if { [string index $value1 0]!="#" } {
			eva:FCT:SENT:NOTICE "$vuser" "\002Commande Halfopall :\002 /msg $eva(pseudo) halfopall #salon";
			return 0;
		}

		eva:sent2socket $eva(idx) ":$eva(link) NAMES $value1"
		if { [eva:console 1]=="ok" && $value2!=[string tolower $eva(salon)] } {
			eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Halfopall \003$eva(console_deco):\003$eva(console_txt) $value1 par $user"
		}
	}
	"dehalfopall" {
		set eva(cmd)		"dehalfopall"
		if { [string index $value1 0]!="#" } {
			eva:FCT:SENT:NOTICE "$vuser" "\002Commande Dehalfopall :\002 /msg $eva(pseudo) dehalfopall #salon";
			return 0;
		}

		eva:sent2socket $eva(idx) ":$eva(link) NAMES $value1"
		if { [eva:console 1]=="ok" && $value2!=[string tolower $eva(salon)] } {
			eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Dehalfopall \003$eva(console_deco):\003$eva(console_txt) $value1 par $user"
		}
	}
	"voiceall" {
		set eva(cmd)		"voiceall"
		if { [string index $value1 0]!="#" } {
			eva:FCT:SENT:NOTICE "$vuser" "\002Commande Voiceall :\002 /msg $eva(pseudo) voiceall #salon";
			return 0;
		}

		eva:sent2socket $eva(idx) ":$eva(link) NAMES $value1"
		if { [eva:console 1]=="ok" && $value2!=[string tolower $eva(salon)] } {
			eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Voiceall \003$eva(console_deco):\003$eva(console_txt) $value1 par $user"
		}
	}
	"devoiceall" {
		set eva(cmd)		"devoiceall"
		if { [string index $value1 0]!="#" } {
			eva:FCT:SENT:NOTICE "$vuser" "\002Commande Devoiceall :\002 /msg $eva(pseudo) devoiceall #salon";
			return 0;
		}

		eva:sent2socket $eva(idx) ":$eva(link) NAMES $value1"
		if { [eva:console 1]=="ok" && $value2!=[string tolower $eva(salon)] } {
			eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Devoiceall \003$eva(console_deco):\003$eva(console_txt) $value1 par $user"
		}
	}
	"kick" {
		if { [string index $value1 0]!="#" || $value4=="" } {
			eva:FCT:SENT:NOTICE "$vuser" "\002Commande Kick :\002 /msg $eva(pseudo) kick #salon pseudo raison";
			return 0;
		}

		if { $value4==[string tolower $eva(SID)] || [info exists ueva($value4)] || [eva:protection $value4 $eva(protection)]=="ok" } {
			eva:FCT:SENT:NOTICE "$user" "Accès Refusé : Pseudo Protégé";
			return 0;
		}

		if { $value5=="" } { set value5		"Kicked" }
		eva:sent2socket $eva(idx) ":$eva(server_id) KICK $value2 $value4 $value5 [eva:rnick $user]"
		if { [eva:console 1]=="ok" && $value2!=[string tolower $eva(salon)] } {
			eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Kick \003$eva(console_deco):\003$eva(console_txt) $value3 a été kické par $user sur $value1 - Raison : $value5"
		}
	}
	"kickall" {
		set eva(cmd)		"kickall";
		set eva(rep)		$user
		if { [string index $value1 0]!="#" } {
			eva:FCT:SENT:NOTICE "$vuser" "\002Commande Kickall :\002 /msg $eva(pseudo) kickall #salon";
			return 0;
		}

		eva:sent2socket $eva(idx) ":$eva(link) NAMES $value1"
		if { [eva:console 1]=="ok" && $value2!=[string tolower $eva(salon)] } {
			eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Kickall \003$eva(console_deco):\003$eva(console_txt) $value1 par $user"
		}
	}
	"ban" {
		if { [string index $value1 0]!="#" || $value3=="" } {
			eva:FCT:SENT:NOTICE "$vuser" "\002Commande Ban :\002 /msg $eva(pseudo) ban #salon mask";
			return 0;
		}

		eva:sent2socket $eva(idx) ":$eva(server_id) MODE $value1 +b $value3"
		if { [eva:console 1]=="ok" && $value2!=[string tolower $eva(salon)] } {
			eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Ban \003$eva(console_deco):\003$eva(console_txt) $value3 a été banni par $user sur $value1"
		}
	}
	"nickban" {
		if { [string index $value1 0]!="#" || $value3=="" } {
			eva:FCT:SENT:NOTICE "$vuser" "\002Commande Nickban :\002 /msg $eva(pseudo) nickban #salon pseudo raison";
			return 0;
		}

		if { $value4==[string tolower $eva(SID)] || [info exists ueva($value4)] || [eva:protection $value4 $eva(protection)]=="ok" } {
			eva:FCT:SENT:NOTICE "$user" "Accès Refusé : Pseudo Protégé";
			return 0;
		}

		if { ![info exists vhost($value4)] } {
			eva:FCT:SENT:NOTICE "$vuser" "Pseudo introuvable.";
			return 0;
		}

		if { $value5=="" } { set value5		"Nick Banned" }
		eva:sent2socket $eva(idx) ":$eva(server_id) MODE $value1 +b $value4*!*@*"
		eva:sent2socket $eva(idx) ":$eva(server_id) KICK $value1 $value3 $value5 [eva:rnick $user]"
		if { [eva:console 1]=="ok" && $value2!=[string tolower $eva(salon)] } {
			eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Nickban \003$eva(console_deco):\003$eva(console_txt) $value3 a été banni par $user sur $value1 - Raison : $value5"
		}
	}
	"kickban" {
		if { [string index $value1 0]!="#" || $value3=="" } {
			eva:FCT:SENT:NOTICE "$vuser" "\002Commande Kickban :\002 /msg $eva(pseudo) kickban #salon pseudo raison";
			return 0;
		}

		if { $value4==[string tolower $eva(SID)] || [info exists ueva($value4)] || [eva:protection $value4 $eva(protection)]=="ok" } {
			eva:FCT:SENT:NOTICE "$user" "Accès Refusé : Pseudo Protégé";
			return 0;
		}

		if { ![info exists vhost($value4)] } {
			eva:FCT:SENT:NOTICE "$vuser" "Pseudo introuvable.";
			return 0;
		}

		if { $value5=="" } { set value5		"Kick Banned" }
		eva:sent2socket $eva(idx) ":$eva(server_id) MODE $value1 +b *!*@$vhost($value4)"
		eva:sent2socket $eva(idx) ":$eva(server_id) KICK $value1 $value3 $value5 [eva:rnick $user]"
		if { [eva:console 1]=="ok" && $value2!=[string tolower $eva(salon)] } {
			eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Kickban \003$eva(console_deco):\003$eva(console_txt) $value3 a été banni par $user sur $value1 - Raison : $value5"
		}
	}
	"unban" {
		if { [string index $value1 0]!="#" || $value3=="" } {
			eva:FCT:SENT:NOTICE "$vuser" "\002Commande Unban :\002 /msg $eva(pseudo) unban #salon mask";
			return 0;
		}

		eva:sent2socket $eva(idx) ":$eva(server_id) MODE $value1 -b $value3"
		if { [eva:console 1]=="ok" && $value2!=[string tolower $eva(salon)] } {
			eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Unban \003$eva(console_deco):\003$eva(console_txt) $value3 a été débanni par $user sur $value1"
		}
	}
	"clearbans" {
		if { [string index $value1 0]!="#" } {
			eva:FCT:SENT:NOTICE "$vuser" "\002Commande Clearbans :\002 /msg $eva(pseudo) clearbans #salon";
			return 0;
		}

		eva:sent2socket $eva(idx) ":$eva(server_id) SVSMODE $value1 -b"
		if { [eva:console 1]=="ok" && $value2!=[string tolower $eva(salon)] } {
			eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Clearbans \003$eva(console_deco):\003$eva(console_txt) $value1 par $user"
		}
	}
	"topic" {
		if { [string index $value1 0]!="#" || $value6=="" } {
			eva:FCT:SENT:NOTICE "$vuser" "\002Commande Topic :\002 /msg $eva(pseudo) topic #salon topic";
			return 0;
		}

		eva:sent2socket $eva(idx) ":$eva(server_id) TOPIC $value1 :$value6"
		if { [eva:console 1]=="ok" && $value2!=[string tolower $eva(salon)] } {
			eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Topic \003$eva(console_deco):\003$eva(console_txt) $user change le topic sur $value1 : $value6"
		}
	}
	"mode" {
		if { [string index $value1 0]!="#" || $value3=="" } {
			eva:FCT:SENT:NOTICE "$vuser" "\002Commande Mode :\002 /msg $eva(pseudo) mode #salon +/-mode";
			return 0;
		}

		if { $value2==[string tolower $eva(salon)] } {
			eva:FCT:SENT:NOTICE "$user" "Accès Refusé";
			return 0;
		}

		if { ![regexp ^\[\+\-\]+\[a-zA-Z\]+$ $value3] } {
			eva:FCT:SENT:NOTICE "$user" "Chanmode Incorrect";
			return 0;
		}

		if { [string match *q* $value3] || [string match *a* $value3] ||[string match *o* $value3] ||[string match *h* $value3] ||[string match *v* $value3] } {
			eva:FCT:SENT:NOTICE "$user" "Chanmode Refusé";
			return 0;
		}

		eva:sent2socket $eva(idx) ":$eva(server_id) MODE $value1 $value6"
		if { [eva:console 1]=="ok" && $value2!=[string tolower $eva(salon)] } {
			eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Mode \003$eva(console_deco):\003$eva(console_txt) $user applique le mode $value6 sur $value1"
		}
	}
	"clearmodes" {
		if { [string index $value1 0]!="#" } {
			eva:FCT:SENT:NOTICE "$vuser" "\002Commande Clearmodes :\002 /msg $eva(pseudo) clearmodes #salon";
			return 0;
		}

		if { $value2==[string tolower $eva(salon)] } {
			eva:FCT:SENT:NOTICE "$user" "Accès Refusé";
			return 0;
		}

		eva:sent2socket $eva(idx) ":$eva(server_id) MODE $value1"
		if { [eva:console 1]=="ok" && $value2!=[string tolower $eva(salon)] } {
			eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Clearmodes \003$eva(console_deco):\003$eva(console_txt) $user sur $value1"
		}
	}
	"clearallmodes" {
		if { [string index $value1 0]!="#" } {
			eva:FCT:SENT:NOTICE "$vuser" "\002Commande Clearallmodes :\002 /msg $eva(pseudo) clearallmodes #salon";
			return 0;
		}

		if { $value2==[string tolower $eva(salon)] } {
			eva:FCT:SENT:NOTICE "$user" "Accès Refusé";
			return 0;
		}

		eva:sent2socket $eva(idx) ":$eva(server_id) SVSMODE $value1 -beIqaohv"
		eva:sent2socket $eva(idx) ":$eva(server_id) MODE $value1"
		eva:sent2socket $eva(idx) ":$eva(server_id) SVSMODE $value1 -b"
		if { [eva:console 1]=="ok" } {
			eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Clearallmodes \003$eva(console_deco):\003$eva(console_txt) $user sur $value1"
		}
	}
	"kill" {
		if { $value1=="" } {
			eva:FCT:SENT:NOTICE "$vuser" "\002Commande Kill :\002 /msg $eva(pseudo) kill pseudo raison";
			return 0;
		}

		if { $value2==[string tolower $eva(SID)] || [info exists ueva($value2)] || [eva:protection $value2 $eva(protection)]=="ok" } {
			eva:FCT:SENT:NOTICE "$user" "Accès Refusé : Pseudo Protégé";
			return 0;
		}

		if { ![info exists vhost($value2)] } {
			eva:FCT:SENT:NOTICE "$vuser" "Pseudo introuvable.";
			return 0;
		}

		if { $value6=="" } { set value6		"Killed" }
		eva:sent2socket $eva(idx) ":$eva(server_id) KILL $value1 $value6 [eva:rnick $user]"; eva:refresh $value2
		if { [eva:console 1]=="ok" } {
			eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Kill \003$eva(console_deco):\003$eva(console_txt) $value1 a été killé par $user : $value6"
		}
	}
	"chankill" {
		set eva(cmd)		"chankill";
		set eva(rep)		$user
		if { [string index $value1 0]!="#" } {
			eva:FCT:SENT:NOTICE "$vuser" "\002Commande Chankill :\002 /msg $eva(pseudo) chankill #salon";
			return 0;
		}

		if { $value2==[string tolower $eva(salon)] } {
			eva:FCT:SENT:NOTICE "$user" "Accès Refusé";
			return 0;
		}

		eva:sent2socket $eva(idx) ":$eva(link) NAMES $value1"
		if { [eva:console 1]=="ok" } {
			eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Chankill \003$eva(console_deco):\003$eva(console_txt) $value1 par $user"
		}
	}
	"svsjoin" {
		if { [string index $value1 0]!="#" || $value3=="" } {
			eva:FCT:SENT:NOTICE "$vuser" "\002Commande Svsjoin :\002 /msg $eva(pseudo) svsjoin #salon pseudo";
			return 0;
		}

		if { ![info exists vhost($value4)] } {
			eva:FCT:SENT:NOTICE "$vuser" "Pseudo introuvable.";
			return 0;
		}

		if { $value4==[string tolower $eva(SID)] || [info exists ueva($value4)] || [eva:protection $value4 $eva(protection)]=="ok" } {
			eva:FCT:SENT:NOTICE "$user" "Accès Refusé : Pseudo Protégé";
			return 0;
		}

		eva:sent2socket $eva(idx) ":$eva(server_id) SVSJOIN [eva:UID:CONVERT $value3] $value1"
		if { [eva:console 1]=="ok" } {
			eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Svsjoin \003$eva(console_deco):\003$eva(console_txt) $value3 entre sur $value1 par $user"
		}
	}
	"svspart" {
		if { [string index $value1 0]!="#" || $value3=="" } {
			eva:FCT:SENT:NOTICE "$vuser" "\002Commande Svspart :\002 /msg $eva(pseudo) svspart #salon pseudo";
			return 0;
		}

		if { ![info exists vhost($value4)] } {
			eva:FCT:SENT:NOTICE "$vuser" "Pseudo introuvable.";
			return 0;
		}

		if { $value4==[string tolower $eva(SID)] || [info exists ueva($value4)] || [eva:protection $value4 $eva(protection)]=="ok" } {
			eva:FCT:SENT:NOTICE "$user" "Accès Refusé : Pseudo Protégé";
			return 0;
		}

		eva:sent2socket $eva(idx) ":$eva(server_id) SVSPART $value3 $value1"
		if { [eva:console 1]=="ok" } {
			eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Svspart \003$eva(console_deco):\003$eva(console_txt) $value3 part de $value1 par $user"
		}
	}
	"svsnick" {
		if { $value1=="" || $value3=="" } {
			eva:FCT:SENT:NOTICE "$vuser" "\002Commande Svsnick :\002 /msg $eva(pseudo) svsnick ancien-pseudo nouveau-pseudo";
			return 0;
		}

		if { $value2==$value4 } {
			eva:FCT:SENT:NOTICE "$vuser" "Pseudo Identique.";
			return 0;
		}

		if { $value2==[string tolower $eva(SID)] || $value4==[string tolower $eva(SID)] || [info exists ueva($value2)] || [info exists ueva($value4)] || [eva:protection $value2 $eva(protection)]=="ok" || [eva:protection $value4 $eva(protection)]=="ok" } {
			eva:FCT:SENT:NOTICE "$user" "Accès Refusé : Pseudo Protégé";
			return 0;
		}

		if { ![info exists vhost($value2)] } {
			eva:FCT:SENT:NOTICE "$vuser" "Pseudo introuvable ($value1).";
			return 0;
		}

		if { [info exists vhost($value4)] } {
			eva:FCT:SENT:NOTICE "$vuser" "Pseudo existant ($value3).";
			return 0;
		}

		eva:sent2socket $eva(idx) ":$eva(link) SVSNICK $value1 $value3 [unixtime]"
		if { [eva:console 1]=="ok" } {
			eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Svsnick \003$eva(console_deco):\003$eva(console_txt) $user change le pseudo de $value1 en $value3"
		}
	}
	"say" {
		if { [string index $value1 0]!="#" || $value6=="" } {
			eva:FCT:SENT:NOTICE "$vuser" "\002Commande Say :\002 /msg $eva(pseudo) say #salon message";
			return 0;
		}

		eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $value1 :$value6"
		if { [eva:console 1]=="ok" && $value2!=[string tolower $eva(salon)] } {
			eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Say \003$eva(console_deco):\003$eva(console_txt) $user sur $value1 : $value6"
		}
	}
	"invite" {
		if { [string index $value1 0]!="#" || $value3=="" } {
			eva:FCT:SENT:NOTICE "$vuser" "\002Commande Invite :\002 /msg $eva(pseudo) invite #salon pseudo";
			return 0;
		}

		if { ![info exists vhost($value4)] } {
			eva:FCT:SENT:NOTICE "$vuser" "Pseudo introuvable.";
			return 0;
		}

		eva:sent2socket $eva(idx) ":$eva(server_id) INVITE $value3 $value1"
		if { [eva:console 1]=="ok" } {
			eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Invite \003$eva(console_deco):\003$eva(console_txt) $user invite $value3 sur $value1"
		}
	}
	"inviteme" {
		eva:sent2socket $eva(idx) ":$eva(server_id) INVITE $user $eva(salon)"
		if { [eva:console 1]=="ok" } {
			eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Inviteme \003$eva(console_deco):\003$eva(console_txt) $user"
		}
	}
	"wallops" {
		if { $value7=="" } {
			eva:FCT:SENT:NOTICE "$vuser" "\002Commande Wallops :\002 /msg $eva(pseudo) wallops message";
			return 0;
		}

		eva:sent2socket $eva(idx) ":$eva(server_id) WALLOPS $value7 ($user)"
		if { [eva:console 1]=="ok" } {
			eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Wallops \003$eva(console_deco):\003$eva(console_txt) $user : $value7"
		}
	}
	"globops" {
		if { $value7=="" } {
			eva:FCT:SENT:NOTICE "$vuser" "\002Commande Globops :\002 /msg $eva(pseudo) globops message";
			return 0;
		}

		eva:sent2socket $eva(idx) ":$eva(server_id) GLOBOPS $value7 ($user)"
		if { [eva:console 1]=="ok" } {
			eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Globops \003$eva(console_deco):\003$eva(console_txt) $user : $value7"
		}
	}
	"notice" {
		if { $value7=="" } {
			eva:FCT:SENT:NOTICE "$vuser" "\002Commande Notice :\002 /msg $eva(pseudo) notice message";
			return 0;
		}

		eva:FCT:SENT:NOTICE "$*.*" "\[\002Notice Globale\002\] $value7"
		if { [eva:console 1]=="ok" } {
			eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Notice \003$eva(console_deco):\003$eva(console_txt) $user"
		}
	}
	"whois" {
		set eva(rep)		$vuser
		if { $value1=="" } {
			eva:FCT:SENT:NOTICE "$vuser" "\002Commande Whois :\002 /msg $eva(pseudo) whois pseudo";
			return 0;
		}

		if { ![info exists vhost($value2)] } {
			eva:FCT:SENT:NOTICE "$vuser" "Pseudo introuvable.";
			return 0;
		}

		eva:sent2socket $eva(idx) ":$eva(server_id) WHOIS $value1"
		if { [eva:console 1]=="ok" } {
			eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Whois \003$eva(console_deco):\003$eva(console_txt) $user"
		}
	}
	"changline" {
		set eva(cmd)		"changline";
		set eva(rep)		$user
		if { [string index $value1 0]!="#" } {
			eva:FCT:SENT:NOTICE "$vuser" "\002Commande Changline :\002 /msg $eva(pseudo) changline #salon";
			return 0;
		}

		if { $value2==[string tolower $eva(salon)] } {
			eva:FCT:SENT:NOTICE "$user" "Accès Refusé";
			return 0;
		}

		eva:sent2socket $eva(idx) ":$eva(link) NAMES $value1"
		if { [eva:console 1]=="ok" } {
			eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Changline \003$eva(console_deco):\003$eva(console_txt) $value1 par $user"
		}
	}
	"gline" {
		if { $value1=="" } {
			eva:FCT:SENT:NOTICE "$vuser" "\002Commande Gline :\002 /msg $eva(pseudo) <gline ou ip> pseudo raison";
			return 0;
		}

		if { $value2==[string tolower $eva(SID)] || [info exists ueva($value2)] || [eva:protection $value2 $eva(protection)]=="ok" } {
			eva:FCT:SENT:NOTICE "$user" "Accès Refusé : Pseudo Protégé";
			return 0;
		}

		if { $value6=="" } { set value6		"Glined" }
		if { [info exists vhost($value2)] } {
			eva:sent2socket $eva(idx) ":$eva(link) TKL + G * $vhost($value2) $eva(SID) [expr [unixtime] + $eva(duree)] [unixtime] : $value6 [eva:rnick $user] (Expire le [eva:duree [expr [unixtime] + $eva(duree)]])"
		} elseif { [string match *.* $value1] } {
			eva:sent2socket $eva(idx) ":$eva(link) TKL + G * $value1 $eva(SID) [expr [unixtime] + $eva(duree)] [unixtime] : $value6 [eva:rnick $user] (Expire le [eva:duree [expr [unixtime] + $eva(duree)]])"
		} else {
			eva:FCT:SENT:NOTICE "$vuser" "Pseudo introuvable.";
			return 0;

		}
		if { [eva:console 1]=="ok" } {
			eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Gline \003$eva(console_deco):\003$eva(console_txt) $value1 par $user - Raison : $value6"
		}
	}
	"ungline" {
		if { $value1=="" ||![string match *@* $value1] } {
			eva:FCT:SENT:NOTICE "$vuser" "\002Commande Ungline :\002 /msg $eva(pseudo) ungline ident@host";
			return 0;
		}

		eva:sent2socket $eva(idx) ":$eva(link) TKL - G [lindex [split $value1 @] 0] [lindex [split $value1 @] 1] $eva(SID)"
		if { [eva:console 1]=="ok" } {
			eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Ungline \003$eva(console_deco):\003$eva(console_txt) $value1 par $user"
		}
	}
	"shun" {
		if { $value1=="" } {
			eva:FCT:SENT:NOTICE "$vuser" "\002Commande Shun :\002 /msg $eva(pseudo) shun <pseudo ou ip> raison";
			return 0;
		}

		if { $value2==[string tolower $eva(SID)] || [info exists ueva($value2)] || [eva:protection $value2 $eva(protection)]=="ok" } {
			eva:FCT:SENT:NOTICE "$user" "Accès Refusé : Pseudo Protégé";
			return 0;
		}

		if { $value6=="" } { set value6		"Shun" }
		if { [info exists vhost($value2)] } {
			eva:sent2socket $eva(idx) ":$eva(link) TKL + s * $vhost($value2) $eva(SID) [expr [unixtime] + $eva(duree)] [unixtime] : $value6 [eva:rnick $user] (Expire le [eva:duree [expr [unixtime] + $eva(duree)]])"
		} elseif { [string match *.* $value1] } {
			eva:sent2socket $eva(idx) ":$eva(link) TKL + s * $value1 $eva(SID) [expr [unixtime] + $eva(duree)] [unixtime] : $value6 [eva:rnick $user] (Expire le [eva:duree [expr [unixtime] + $eva(duree)]])"
		} else {
			eva:FCT:SENT:NOTICE "$vuser" "Pseudo introuvable.";
			return 0;

		}
		if { [eva:console 1]=="ok" } {
			eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Shun \003$eva(console_deco):\003$eva(console_txt) $value1 par $user - Raison : $value6"
		}
	}
	"unshun" {
		if { $value1=="" ||![string match *@* $value1] } {
			eva:FCT:SENT:NOTICE "$vuser" "\002Commande Unshun :\002 /msg $eva(pseudo) unshun ident@host";
			return 0;
		}

		eva:sent2socket $eva(idx) ":$eva(link) TKL - s [lindex [split $value1 @] 0] [lindex [split $value1 @] 1] $eva(SID)"
		if { [eva:console 1]=="ok" } {
			eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Unshun \003$eva(console_deco):\003$eva(console_txt) $value1 par $user"
		}
	}
	"kline" {
		if { $value1=="" } {
			eva:FCT:SENT:NOTICE "$vuser" "\002Commande Kline :\002 /msg $eva(pseudo) kline <pseudo ou ip> raison";
			return 0;
		}

		if { $value2==[string tolower $eva(SID)] || [info exists ueva($value2)] || [eva:protection $value2 $eva(protection)]=="ok" } {
			eva:FCT:SENT:NOTICE "$user" "Accès Refusé : Pseudo Protégé";
			return 0;
		}

		if { $value6=="" } { set value6		"Klined" }
		if { [info exists vhost($value2)] } {
			eva:sent2socket $eva(idx) ":$eva(link) TKL + k * $vhost($value2) $eva(SID) [expr [unixtime] + $eva(duree)] [unixtime] : $value6 [eva:rnick $user] (Expire le [eva:duree [expr [unixtime] + $eva(duree)]])"
		} elseif { [string match *.* $value1] } {
			eva:sent2socket $eva(idx) ":$eva(link) TKL + k * $value1 $eva(SID) [expr [unixtime] + $eva(duree)] [unixtime] : $value6 [eva:rnick $user] (Expire le [eva:duree [expr [unixtime] + $eva(duree)]])"
		} else {
			eva:FCT:SENT:NOTICE "$vuser" "Pseudo introuvable.";
			return 0;

		}
		if { [eva:console 1]=="ok" } {
			eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Kline \003$eva(console_deco):\003$eva(console_txt) $value1 par $user - Raison : $value6"
		}
	}
	"unkline" {
		if { $value1=="" || ![string match *@* $value1] } {
			eva:FCT:SENT:NOTICE "$vuser" "\002Commande Unkline :\002 /msg $eva(pseudo) unkline ident@host";
			return 0;
		}

		eva:sent2socket $eva(idx) ":$eva(link) TKL - k [lindex [split $value1 @] 0] [lindex [split $value1 @] 1] $eva(SID)"
		if { [eva:console 1]=="ok" } {
			eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Unkline \003$eva(console_deco):\003$eva(console_txt) $value1 par $user"
		}
	}
	"glinelist" {
		set eva(cmd)		"gline";
		set eva(rep)		$vuser
		eva:sent2socket $eva(idx) ":$eva(server_id) STATS G"
		if { [eva:console 1]=="ok" } {
			eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Glinelist \003$eva(console_deco):\003$eva(console_txt) $user"
		}
	}
	"shunlist" {
		set eva(cmd)		"shun";
		set eva(rep)		$vuser
		eva:sent2socket $eva(idx) ":$eva(server_id) STATS s"
		if { [eva:console 1]=="ok" } {
			eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Shunlist \003$eva(console_deco):\003$eva(console_txt) $user"
		}
	}
	"klinelist" {
		set eva(cmd)		"kline";
		set eva(rep)		$vuser
		eva:sent2socket $eva(idx) ":$eva(server_id) STATS K"
		if { [eva:console 1]=="ok" } {
			eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Klinelist \003$eva(console_deco):\003$eva(console_txt) $user"
		}
	}
	"cleargline" {
		set eva(cmd)		"cleargline"
		eva:sent2socket $eva(idx) ":$eva(server_id) STATS G"
		eva:FCT:SENT:NOTICE "$vuser" "Liste des glines vidée."
		if { [eva:console 1]=="ok" } {
			eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Cleargline \003$eva(console_deco):\003$eva(console_txt) $user"
		}
	}
	"clearkline" {
		set eva(cmd)		"clearkline"
		eva:sent2socket $eva(idx) ":$eva(server_id) STATS K"
		eva:FCT:SENT:NOTICE "$vuser" "Liste des klines vidée."
		if { [eva:console 1]=="ok" } {
			eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Clearkline \003$eva(console_deco):\003$eva(console_txt) $user"
		}
	}
	"clientlist" {
		catch { open "[eva:scriptdir]db/client.db" r } liste
		eva:FCT:SENT:NOTICE "$vuser" "\002\0031,1------ \0030Liste des clients IRC interdits \0031------"
		eva:FCT:SENT:NOTICE "$vuser" "\002"
		while { ![eof $liste] } {
			gets $liste version;
			if { $version!="" } { incr stop 1; eva:FCT:SENT:NOTICE "$vuser" "\00301 \[\00303 $stop \00301\] \00301 $version" }
		}
		catch { close $liste }
		if { $stop==0 } {
			eva:FCT:SENT:NOTICE "$vuser" "Aucun client IRC"
		}
		if { [eva:console 1]=="ok" } {
			eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Clientlist \003$eva(console_deco):\003$eva(console_txt) $user"
		}
	}
	"addclient" {
		if { $value7=="" } {
			eva:FCT:SENT:NOTICE "$vuser" "\002Commande Addclient :\002 /msg $eva(pseudo) addclient version";
			return 0;
		}

		catch { open "[eva:scriptdir]db/client.db" r } liste
		while { ![eof $liste] } {
			gets $liste verif;
			if { ![string compare -nocase $value7 $verif] } {
				eva:FCT:SENT:NOTICE "$vuser" "\002$value7\002 est déjà dans la liste des clients IRC interdits.";
				set stop		1;
				break
			}
		}
		catch { close $liste };
		if { $stop==1 } { return 0 }
		set bclient		[open "[eva:scriptdir]db/client.db" a]; puts $bclient [string tolower $value7]; close $bclient
		eva:FCT:SENT:NOTICE "$vuser" "\002$value7\002 a bien été ajouté à la liste des clients IRC interdits."
		if { [eva:console 1]=="ok" } {
			eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Addclient \003$eva(console_deco):\003$eva(console_txt) $user"
		}
	}
	"delclient" {
		if { $value7=="" } {
			eva:FCT:SENT:NOTICE "$vuser" "\002Commande Delclient :\002 /msg $eva(pseudo) delclient version";
			return 0;
		}

		catch { open "[eva:scriptdir]db/client.db" r } liste
		while { ![eof $liste] } {
			gets $liste verif;
			if { ![string compare -nocase $value7 $verif] } { set stop		1 };
			if { [string compare -nocase $value7 $verif] && $verif!="" } { lappend vers "$verif" }
		}
		catch { close $liste }
		if { $stop==0 } {
			eva:FCT:SENT:NOTICE "$vuser" "\002$value7\002 n'est pas dans la liste des clients IRC interdits.";
			return 0;

		} else {
			if [info exists vers] {
				set del		[open "[eva:scriptdir]db/client.db" w+]; foreach delclient $vers { puts $del "$delclient" }; close $del
			} else {
				set del		[open "[eva:scriptdir]db/client.db" w+]; close $del
			}
			eva:FCT:SENT:NOTICE "$vuser" "\002$value7\002 a bien été supprimé de la liste des clients IRC interdits."
			if { [eva:console 1]=="ok" } {
				eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Delclient \003$eva(console_deco):\003$eva(console_txt) $user"
			}
		}
	}
	"addsecu" {
		if { [string index $value2 0]!="#" } {
			eva:FCT:SENT:NOTICE "$vuser" "\002Commande Addsecu :\002 /msg $eva(pseudo) addsecu #salon";
			return 0;
		}

		if { $value2==[string tolower $eva(salon)] } {
			eva:FCT:SENT:NOTICE "$vuser" "Accès Refusé : Salon de logs";
			return 0;
		}

		catch { open "[eva:scriptdir]db/salon.db" r } liste1
		while { ![eof $liste1] } {
			gets $liste1 verif1;
			if { ![string compare -nocase $value2 $verif1] } {
				eva:FCT:SENT:NOTICE "$vuser" "Accès Refusé : Salon Interdit";
				set stop		1;
				break
			}
		}
		catch { close $liste1 };
		if { $stop==1 } { return 0 }
		catch { open "[eva:scriptdir]db/close.db" r } liste2
		while { ![eof $liste2] } {
			gets $liste2 verif2;
			if { ![string compare -nocase $value2 $verif2] } {
				eva:FCT:SENT:NOTICE "$vuser" "Accès Refusé : Salon Fermé";
				set stop		1;
				break
			}
		}
		catch { close $liste2 };
		if { $stop==1 } { return 0 }
		catch { open "[eva:scriptdir]db/secu.db" r } liste
		while { ![eof $liste] } {
			gets $liste verif;
			if { ![string compare -nocase $value2 $verif] } {
				eva:FCT:SENT:NOTICE "$vuser" "\002$value1\002 est déjà dans la liste des salons sécurisés.";
				set stop		1;
				break
			}
		}
		catch { close $liste };
		if { $stop==1 } { return 0 }
		set join		[open "[eva:scriptdir]db/secu.db" a]; puts $join $value2; close $join
		eva:FCT:SENT:NOTICE "$vuser" "\002$value1\002 a bien été ajouté dans la liste des salons sécurisés."
		if { [info exists eva(maxthrottle)] } {
			eva:sent2socket $eva(idx) ":$eva(server_id) MODE $value1 +smi"
		}
		if { [eva:console 1]=="ok" } {
			eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Addsecu \003$eva(console_deco):\003$eva(console_txt) $user"
		}
	}
	"delsecu" {
		if { [string index $value2 0]!="#" } {
			eva:FCT:SENT:NOTICE "$vuser" "\002Commande Delsecu :\002 /msg $eva(pseudo) delsecu #salon";
			return 0;
		}

		if { $value2==[string tolower $eva(salon)] } {
			eva:FCT:SENT:NOTICE "$vuser" "Accès Refusé";
			return 0;
		}

		catch { open "[eva:scriptdir]db/secu.db" r } liste
		while { ![eof $liste] } {
			gets $liste verif;
			if { ![string compare -nocase $value2 $verif] } { set stop		1 };
			if { [string compare -nocase $value2 $verif] && $verif!="" } { lappend salle "$verif" }
		}
		catch { close $liste }
		if { $stop==0 } {
			eva:FCT:SENT:NOTICE "$vuser" "\002$value1\002 n'est pas dans la liste des salons sécurisés.";
			return 0;

		} else {
			if { [info exists salle] } {
				set del		[open "[eva:scriptdir]db/secu.db" w+]; foreach delchan $salle { puts $del "$delchan" }; close $del
			} else {
				set del		[open "[eva:scriptdir]db/secu.db" w+]; close $del
			}
			eva:FCT:SENT:NOTICE "$vuser" "\002$value1\002 a bien été supprimé de la liste des salons sécurisés."
			if { [info exists eva(maxthrottle)] } {
				eva:sent2socket $eva(idx) ":$eva(server_id) MODE $value1 -smi"
			}
			if { [eva:console 1]=="ok" } {
				eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Delsecu \003$eva(console_deco):\003$eva(console_txt) $user"
			}
		}
	}
	"seculist" {
		catch { open "[eva:scriptdir]db/secu.db" r } liste
		eva:FCT:SENT:NOTICE "$vuser" "\002\0031,1-------- \0030Salons Sécurisés \0031--------"
		eva:FCT:SENT:NOTICE "$vuser" "\002"
		while { ![eof $liste] } {
			gets $liste salon;
			if { $salon!="" } { incr stop 1; eva:FCT:SENT:NOTICE "$vuser" "\00301 \[\00303 $stop \00301\] \00301 $salon" }
		}
		catch { close $liste }
		if { $stop==0 } {
			eva:FCT:SENT:NOTICE "$vuser" "Aucun Salon"
		}
		if { [eva:console 1]=="ok" } {
			eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Seculist \003$eva(console_deco):\003$eva(console_txt) $user"
		}
	}
	"secu" {
		if { $value2!="on" && $value2!="off" } {
			eva:FCT:SENT:NOTICE "$vuser" "\002Commande Secu :\002 /msg $eva(pseudo) secu on/off";
			return 0;
		}

		if { $value2=="on" } {
			if { $eva(secu)==0 } {
				set eva(secu)		1; eva:FCT:SENT:NOTICE "$vuser" "Système de sécurité des salons activé"
				if { [eva:console 1]=="ok" } {
					eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Secu \003$eva(console_deco):\003$eva(console_txt) $user"
				}
			} else {
				eva:FCT:SENT:NOTICE "$vuser" "Le système de sécurité des salons est déjà activé."
			}
		} elseif { $value2=="off" } {
			if { $eva(secu)==1 } {
				set eva(secu)		0; eva:FCT:SENT:NOTICE "$vuser" "Système de sécurité des salons désactivé"
				if { [eva:console 1]=="ok" } {
					eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Secu \003$eva(console_deco):\003$eva(console_txt) $user"
				}
			} else {
				eva:FCT:SENT:NOTICE "$vuser" "Le système de sécurité des salons est déjà désactivé."
			}
		}
	}
	"client" {
		if { $value2!="on" && $value2!="off" } {
			eva:FCT:SENT:NOTICE "$vuser" "\002Commande Client :\002 /msg $eva(pseudo) client on/off";
			return 0;
		}

		if { $value2=="on" } {
			if { $eva(aclient)==0 } {
				set eva(aclient)		1; eva:FCT:SENT:NOTICE "$vuser" "Protection clients IRC activée"
				if { [eva:console 1]=="ok" } {
					eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Client \003$eva(console_deco):\003$eva(console_txt) $user"
				}
			} else {
				eva:FCT:SENT:NOTICE "$vuser" "La protection clients IRC est déjà activée."
			}
		} elseif { $value2=="off" } {
			if { $eva(aclient)==1 } {
				set eva(aclient)		0; eva:FCT:SENT:NOTICE "$vuser" "Protection clients IRC désactivée"
				if { [eva:console 1]=="ok" } {
					eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Client \003$eva(console_deco):\003$eva(console_txt) $user"
				}
			} else {
				eva:FCT:SENT:NOTICE "$vuser" "La protection clients IRC est déjà désactivée."
			}
		}
	}
	"clone" {
		if { $value2!="on" && $value2!="off" } {
			eva:FCT:SENT:NOTICE "$vuser" "\002Commande Clone :\002 /msg $eva(pseudo) clone on/off";
			return 0;
		}

		if { $value2=="on" } {
			if { $eva(aclone)==0 } {
				set eva(aclone)		1; eva:FCT:SENT:NOTICE "$vuser" "Protection clone activée"
				if { [eva:console 1]=="ok" } {
					eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Clone \003$eva(console_deco):\003$eva(console_txt) $user"
				}
			} else {
				eva:FCT:SENT:NOTICE "$vuser" "La protection clone est déjà activée."
			}
		} elseif { $value2=="off" } {
			if { $eva(aclone)==1 } {
				set eva(aclone)		0; eva:FCT:SENT:NOTICE "$vuser" "Protection clone désactivée"
				if { [eva:console 1]=="ok" } {
					eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Clone \003$eva(console_deco):\003$eva(console_txt) $user"
				}
			} else {
				eva:FCT:SENT:NOTICE "$vuser" "La protection clone est déjà désactivée."
			}
		}
	}
	"close" {
		set eva(cmd)		"close";
		set eva(rep)		$user
		if { [string index $value1 0]!="#" } {
			eva:FCT:SENT:NOTICE "$vuser" "\002Commande Close :\002 /msg $eva(pseudo) close #salon";
			return 0;
		}

		if { $value2==[string tolower $eva(salon)] } {
			eva:FCT:SENT:NOTICE "$user" "Accès Refusé : Salon de logs";
			return 0;
		}

		catch { open "[eva:scriptdir]db/salon.db" r } liste1
		while { ![eof $liste1] } {
			gets $liste1 verif1;
			if { ![string compare -nocase $value2 $verif1] } {
				eva:FCT:SENT:NOTICE "$vuser" "Accès Refusé : Salon Interdit";
				set stop		1;
				break
			}
		}
		catch { close $liste1 };
		if { $stop==1 } { return 0 }
		catch { open "[eva:scriptdir]db/secu.db" r } liste2
		while { ![eof $liste2] } {
			gets $liste2 verif2;
			if { ![string compare -nocase $value2 $verif2] } {
				eva:FCT:SENT:NOTICE "$vuser" "Accès Refusé : Salon Sécurisé";
				set stop		1;
				break
			}
		}
		catch { close $liste2 };
		if { $stop==1 } { return 0 }
		catch { open "[eva:scriptdir]db/chan.db" r } liste3
		while { ![eof $liste3] } {
			gets $liste3 verif3;
			if { ![string compare -nocase $value2 $verif3] } {
				eva:FCT:SENT:NOTICE "$vuser" "Accès Refusé : Salon Autojoin";
				set stop		1;
				break
			}
		}
		catch { close $liste3 };
		if { $stop==1 } { return 0 }
		catch { open "[eva:scriptdir]db/close.db" r } liste
		while { ![eof $liste] } {
			gets $liste verif;
			if { ![string compare -nocase $value2 $verif] } {
				eva:FCT:SENT:NOTICE "$vuser" "\002$value1\002 est déjà dans la liste des salons fermés.";
				set stop		1;
				break
			}
		}
		catch { close $liste };
		if { $stop==1 } { return 0 }
		set bclose		[open "[eva:scriptdir]db/close.db" a]; puts $bclose $value2; close $bclose
		eva:FCT:SENT:NOTICE "$vuser" "\002$value1\002 vient d'être ajouté dans la liste des salons fermés."
		eva:sent2socket $eva(idx) ":$eva(server_id) JOIN $value1"; eva:sent2socket $eva(idx) ":$eva(server_id) MODE $value1 +sntio $eva(SID)"; eva:sent2socket $eva(idx) ":$eva(server_id) TOPIC $value1 :\0031Salon Fermé le [eva:duree [unixtime]]"
		eva:sent2socket $eva(idx) ":$eva(link) NAMES $value1"
		if { [eva:console 1]=="ok" } {
			eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Close \003$eva(console_deco):\003$eva(console_txt) $value1 par $user"
		}
	}
	"unclose" {
		if { [string index $value1 0]!="#" } {
			eva:FCT:SENT:NOTICE "$vuser" "\002Commande Unclose :\002 /msg $eva(pseudo) unclose #salon";
			return 0;
		}

		catch { open "[eva:scriptdir]db/close.db" r } liste
		while { ![eof $liste] } {
			gets $liste verif;
			if { ![string compare -nocase $value2 $verif] } { set stop		1 };
			if { [string compare -nocase $value2 $verif] && $verif!="" } { lappend salon "$verif" }
		}
		catch { close $liste }
		if { $stop==0 } {
			eva:FCT:SENT:NOTICE "$vuser" "\002$value1\002 n'est pas dans la liste des salons fermés.";
			return 0;

		} else {
			if [info exists salon] {
				set del		[open "[eva:scriptdir]db/close.db" w+]; foreach delchan $salon { puts $del "$delchan" }; close $del
			} else {
				set del		[open "[eva:scriptdir]db/close.db" w+]; close $del
			}
			eva:FCT:SENT:NOTICE "$user" "\002$value1\002 a bien été supprimé de la liste des salons fermés."
			eva:sent2socket $eva(idx) ":$eva(server_id) MODE $value1"
			eva:sent2socket $eva(idx) ":$eva(server_id) TOPIC $value1 :Bienvenue sur $value1"
			eva:sent2socket $eva(idx) ":$eva(server_id) PART $value1"
			if { [eva:console 1]=="ok" } {
				eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Unclose \003$eva(console_deco):\003$eva(console_txt) $value1 par $user"
			}
		}
	}
	"closelist" {
		catch { open "[eva:scriptdir]db/close.db" r } liste
		eva:FCT:SENT:NOTICE "$vuser" "\002\0031,1------ \0030Liste des salons fermés \0031------"
		eva:FCT:SENT:NOTICE "$vuser" "\002"
		while { ![eof $liste] } {
			gets $liste salon;
			if { $salon!="" } { incr stop 1; eva:FCT:SENT:NOTICE "$vuser" "\0031 \[\00303 $stop \00301\] \00301 $salon" }
		}
		catch { close $liste }
		if { $stop==0 } {
			eva:FCT:SENT:NOTICE "$vuser" "Aucun Salon."
		}
		if { [eva:console 1]=="ok" } {
			eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Closelist \003$eva(console_deco):\003$eva(console_txt) $user"
		}
	}
	"clearclose" {
		catch { open "[eva:scriptdir]db/close.db" r } liste
		while { ![eof $liste] } {
			gets $liste salon
			if { $salon!="" } {
				eva:sent2socket $eva(idx) ":$eva(server_id) MODE $salon"
				eva:sent2socket $eva(idx) ":$eva(server_id) TOPIC $salon :Bienvenue sur $salon"
				eva:sent2socket $eva(idx) ":$eva(server_id) PART $salon"
			}
		}
		catch { close $liste }
		set del		[open "[eva:scriptdir]db/close.db" w+]; close $del
		eva:FCT:SENT:NOTICE "$user" "La liste des salons fermés à bien été vidée."
		if { [eva:console 1]=="ok" } {
			eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Clearclose \003$eva(console_deco):\003$eva(console_txt) $user"
		}
	}
	"addnick" {
		if { $value2=="" } {
			eva:FCT:SENT:NOTICE "$vuser" "\002Commande Addnick :\002 /msg $eva(pseudo) addnick pseudo";
			return 0;
		}

		if { [string match *$value2* [string tolower $eva(SID)]] } {
			eva:FCT:SENT:NOTICE "$user" "Accès Refusé : Pseudo Protégé";
			return 0;
		}

		foreach { p n } [array get ueva] {
			if { [string match *$value2* $p] } {
				eva:FCT:SENT:NOTICE "$user" "Accès Refusé : Pseudo Protégé";
				return 0;
			}

		}
		foreach { a r } [array get admins] {
			if { [string match *$value2* $r] } {
				eva:FCT:SENT:NOTICE "$user" "Accès Refusé : Pseudo Protégé";
				return 0;
			}

		}
		catch { open "[eva:scriptdir]db/nick.db" r } liste
		while { ![eof $liste] } {
			gets $liste verif;
			if { ![string compare -nocase $value2 $verif] } {
				eva:FCT:SENT:NOTICE "$vuser" "\002$value1\002 est déjà dans la liste des pseudos interdits.";
				set stop		1;
				break
			}
		}
		catch { close $liste };
		if { $stop==1 } { return 0 }
		set nick		[open "[eva:scriptdir]db/nick.db" a]; puts $nick $value2; close $nick
		eva:FCT:SENT:NOTICE "$vuser" "\002$value1\002 a bien été ajouté dans la liste des pseudos interdits."
		if { [eva:console 1]=="ok" } {
			eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Addnick \003$eva(console_deco):\003$eva(console_txt) $user"
		}
	}
	"delnick" {
		if { $value2=="" } {
			eva:FCT:SENT:NOTICE "$vuser" "\002Commande Delnick :\002 /msg $eva(pseudo) delnick pseudo";
			return 0;
		}

		catch { open "[eva:scriptdir]db/nick.db" r } liste
		while { ![eof $liste] } {
			gets $liste verif;
			if { ![string compare -nocase $value2 $verif] } { set stop		1 };
			if { [string compare -nocase $value2 $verif] && $verif!="" } { lappend pseudo "$verif" }
		}
		catch { close $liste }
		if { $stop==0 } {
			eva:FCT:SENT:NOTICE "$vuser" "\002$value1\002 n'est pas dans la liste des pseudos interdits.";
			return 0;

		} else {
			if { [info exists pseudo] } {
				set del		[open "[eva:scriptdir]db/nick.db" w+]; foreach delnick $pseudo { puts $del "$delnick" }; close $del
			} else {
				set del		[open "[eva:scriptdir]db/nick.db" w+]; close $del
			}
			eva:FCT:SENT:NOTICE "$vuser" "\002$value1\002 a bien été supprimé de la liste des pseudos interdits."
			if { [eva:console 1]=="ok" } {
				eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Delnick \003$eva(console_deco):\003$eva(console_txt) $user"
			}
		}
	}
	"nicklist" {
		catch { open "[eva:scriptdir]db/nick.db" r } liste
		eva:FCT:SENT:NOTICE "$vuser" "\002\0031,1--------- \0030Pseudos Interdits \0031---------"
		eva:FCT:SENT:NOTICE "$vuser" "\002"
		while { ![eof $liste] } {
			gets $liste pseudo;
			if { $pseudo!="" } { incr stop 1; eva:FCT:SENT:NOTICE "$vuser" "\00301 \[\00303 $stop \00301\] \00301 $pseudo" }
		}
		catch { close $liste }
		if { $stop==0 } {
			eva:FCT:SENT:NOTICE "$vuser" "Aucun Pseudo"
		}
		if { [eva:console 1]=="ok" } {
			eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Nicklist \003$eva(console_deco):\003$eva(console_txt) $user"
		}
	}
	"addident" {
		if { $value2=="" } {
			eva:FCT:SENT:NOTICE "$vuser" "\002Commande Addident :\002 /msg $eva(pseudo) addident ident";
			return 0;
		}

		if { [string match *$value2* [string tolower $eva(ident)]] } {
			eva:FCT:SENT:NOTICE "$user" "Accès Refusé : Ident Protégé";
			return 0;
		}

		catch { open "[eva:scriptdir]db/ident.db" r } liste
		while { ![eof $liste] } {
			gets $liste verif;
			if { ![string compare -nocase $value2 $verif] } {
				eva:FCT:SENT:NOTICE "$vuser" "\002$value1\002 est déjà dans la liste des idents interdits.";
				set stop		1;
				break
			}
		}
		catch { close $liste };
		if { $stop==1 } { return 0 }
		set ident		[open "[eva:scriptdir]db/ident.db" a]; puts $ident $value2; close $ident
		eva:FCT:SENT:NOTICE "$vuser" "\002$value1\002 a bien été ajouté dans la liste des idents interdits."
		if { [eva:console 1]=="ok" } {
			eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Addident \003$eva(console_deco):\003$eva(console_txt) $user"
		}
	}
	"delident" {
		if { $value2=="" } {
			eva:FCT:SENT:NOTICE "$vuser" "\002Commande Delident :\002 /msg $eva(pseudo) delident ident";
			return 0;
		}

		catch { open "[eva:scriptdir]db/ident.db" r } liste
		while { ![eof $liste] } {
			gets $liste verif;
			if { ![string compare -nocase $value2 $verif] } { set stop		1 };
			if { [string compare -nocase $value2 $verif] && $verif!="" } { lappend ident "$verif" }
		}
		catch { close $liste }
		if { $stop==0 } {
			eva:FCT:SENT:NOTICE "$vuser" "\002$value1\002 n'est pas dans la liste des idents interdits.";
			return 0;

		} else {
			if { [info exists ident] } {
				set del		[open "[eva:scriptdir]db/ident.db" w+]; foreach delident $ident { puts $del "$delident" }; close $del
			} else {
				set del		[open "[eva:scriptdir]db/ident.db" w+]; close $del
			}
			eva:FCT:SENT:NOTICE "$vuser" "\002$value1\002 a bien été supprimé de la liste des idents interdits."
			if { [eva:console 1]=="ok" } {
				eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Delident \003$eva(console_deco):\003$eva(console_txt) $user"
			}
		}
	}
	"identlist" {
		catch { open "[eva:scriptdir]db/ident.db" r } liste
		eva:FCT:SENT:NOTICE "$vuser" "\002\0031,1---------- \0030Idents Interdits \0031----------"
		eva:FCT:SENT:NOTICE "$vuser" "\002"
		while { ![eof $liste] } {
			gets $liste ident;
			if { $ident!="" } { incr stop 1; eva:FCT:SENT:NOTICE "$vuser" "\00301 \[\00303 $stop \00301\] \00301 $ident" }
		}
		catch { close $liste }
		if { $stop==0 } {
			eva:FCT:SENT:NOTICE "$vuser" "Aucun Ident"
		}
		if { [eva:console 1]=="ok" } {
			eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Identlist \003$eva(console_deco):\003$eva(console_txt) $user"
		}
	}
	"addreal" {
		if { $value2=="" } {
			eva:FCT:SENT:NOTICE "$vuser" "\002Commande Addreal :\002 /msg $eva(pseudo) addreal realname";
			return 0;
		}

		if { [string match *$value2* [string tolower $eva(real)]] } {
			eva:FCT:SENT:NOTICE "$user" "Accès Refusé : Realname Protégé";
			return 0;
		}

		catch { open "[eva:scriptdir]db/real.db" r } liste
		while { ![eof $liste] } {
			gets $liste verif;
			if { ![string compare -nocase $value2 $verif] } {
				eva:FCT:SENT:NOTICE "$vuser" "\002$value1\002 est déjà dans la liste des realnames interdits.";
				set stop		1;
				break
			}
		}
		catch { close $liste };
		if { $stop==1 } { return 0 }
		set real		[open "[eva:scriptdir]db/real.db" a]; puts $real $value2; close $real
		eva:FCT:SENT:NOTICE "$vuser" "\002$value1\002 a bien été ajouté dans la liste des realnames interdits."
		if { [eva:console 1]=="ok" } {
			eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Addreal \003$eva(console_deco):\003$eva(console_txt) $user"
		}
	}
	"delreal" {
		if { $value2=="" } {
			eva:FCT:SENT:NOTICE "$vuser" "\002Commande Delreal :\002 /msg $eva(pseudo) delreal realname";
			return 0;
		}

		catch { open "[eva:scriptdir]db/real.db" r } liste
		while { ![eof $liste] } {
			gets $liste verif;
			if { ![string compare -nocase $value2 $verif] } { set stop		1 };
			if { [string compare -nocase $value2 $verif] && $verif!="" } { lappend real "$verif" }
		}
		catch { close $liste }
		if { $stop==0 } {
			eva:FCT:SENT:NOTICE "$vuser" "\002$value1\002 n'est pas dans la liste des realnames interdits.";
			return 0;

		} else {
			if { [info exists real] } {
				set del		[open "[eva:scriptdir]db/real.db" w+]; foreach delreal $real { puts $del "$delreal" }; close $del
			} else {
				set del		[open "[eva:scriptdir]db/real.db" w+]; close $del
			}
			eva:FCT:SENT:NOTICE "$vuser" "\002$value1\002 a bien été supprimé de la liste des realnames interdits."
			if { [eva:console 1]=="ok" } {
				eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Delreal \003$eva(console_deco):\003$eva(console_txt) $user"
			}
		}
	}
	"reallist" {
		catch { open "[eva:scriptdir]db/real.db" r } liste
		eva:FCT:SENT:NOTICE "$vuser" "\002\0031,1--------- \0030Realnames Interdits \0031---------"
		eva:FCT:SENT:NOTICE "$vuser" "\002"
		while { ![eof $liste] } {
			gets $liste real;
			if { $real!="" } { incr stop 1; eva:FCT:SENT:NOTICE "$vuser" "\00301 \[\00303 $stop \00301\] \00301 $real" }
		}
		catch { close $liste }
		if { $stop==0 } {
			eva:FCT:SENT:NOTICE "$vuser" "Aucun Realname"
		}
		if { [eva:console 1]=="ok" } {
			eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Reallist \003$eva(console_deco):\003$eva(console_txt) $user"
		}
	}
	"addhost" {
		if { $value2=="" } {
			eva:FCT:SENT:NOTICE "$vuser" "\002Commande Addhost :\002 /msg $eva(pseudo) addhost hostname";
			return 0;
		}

		if { [string match *$value2* [string tolower $eva(host)]] || [info exists protect($value2)] } {
			eva:FCT:SENT:NOTICE "$user" "Accès Refusé : Hostname Protégée";
			return 0;
		}

		foreach { mask num } [array get trust] {
			if { [string match *$value2* $mask] } {
				eva:FCT:SENT:NOTICE "$user" "Accès Refusé : Hostname Trustée";
				return 0;
			}

		}
		catch { open "[eva:scriptdir]db/host.db" r } liste
		while { ![eof $liste] } {
			gets $liste verif;
			if { ![string compare -nocase $value2 $verif] } {
				eva:FCT:SENT:NOTICE "$vuser" "\002$value1\002 est déjà dans la liste des hostnames interdites.";
				set stop		1;
				break
			}
		}
		catch { close $liste };
		if { $stop==1 } { return 0 }
		set host		[open "[eva:scriptdir]db/host.db" a]; puts $host $value2; close $host
		eva:FCT:SENT:NOTICE "$vuser" "\002$value1\002 a bien été ajouté dans la liste des hostnames interdites."
		if { [eva:console 1]=="ok" } {
			eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Addhost \003$eva(console_deco):\003$eva(console_txt) $user"
		}
	}
	"delhost" {
		if { $value2=="" } {
			eva:FCT:SENT:NOTICE "$vuser" "\002Commande Delhost :\002 /msg $eva(pseudo) delhost hostname";
			return 0;
		}

		catch { open "[eva:scriptdir]db/host.db" r } liste
		while { ![eof $liste] } {
			gets $liste verif;
			if { ![string compare -nocase $value2 $verif] } { set stop		1 };
			if { [string compare -nocase $value2 $verif] && $verif!="" } { lappend host "$verif" }
		}
		catch { close $liste }
		if { $stop==0 } {
			eva:FCT:SENT:NOTICE "$vuser" "\002$value1\002 n'est pas dans la liste des hostnames interdites.";
			return 0;

		} else {
			if { [info exists host] } {
				set del		[open "[eva:scriptdir]db/host.db" w+]; foreach delhost $host { puts $del "$delhost" }; close $del
			} else {
				set del		[open "[eva:scriptdir]db/host.db" w+]; close $del
			}
			eva:FCT:SENT:NOTICE "$vuser" "\002$value1\002 a bien été supprimé de la liste des hostnames interdites."
			if { [eva:console 1]=="ok" } {
				eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Delhost \003$eva(console_deco):\003$eva(console_txt) $user"
			}
		}
	}
	"hostlist" {
		catch { open "[eva:scriptdir]db/host.db" r } liste
		eva:FCT:SENT:NOTICE "$vuser" "\002\0031,1----------- \0030Hostnames Interdites \0031-----------"
		eva:FCT:SENT:NOTICE "$vuser" "\002"
		while { ![eof $liste] } {
			gets $liste host;
			if { $host!="" } { incr stop 1; eva:FCT:SENT:NOTICE "$vuser" "\00301 \[\00303 $stop \00301\] \00301 $host" }
		}
		catch { close $liste }
		if { $stop==0 } {
			eva:FCT:SENT:NOTICE "$vuser" "Aucune Hostname"
		}
		if { [eva:console 1]=="ok" } {
			eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Hostlist \003$eva(console_deco):\003$eva(console_txt) $user"
		}
	}
	"addchan" {
		if { [string index $value2 0]!="#" } {
			eva:FCT:SENT:NOTICE "$vuser" "\002Commande Addchan :\002 /msg $eva(pseudo) addchan #salon";
			return 0;
		}

		if { [string match *[string trimleft $value2 #]* [string trimleft [string tolower $eva(salon)] #]] } {
			eva:FCT:SENT:NOTICE "$user" "Accès Refusé : Salon de logs";
			return 0;
		}

		catch { open "[eva:scriptdir]db/chan.db" r } liste1
		while { ![eof $liste1] } {
			gets $liste1 verif1;
			if { [string match *[string trimleft $value2 #]* [string trimleft $verif1 #]] } {
				eva:FCT:SENT:NOTICE "$vuser" "Accès Refusé : Salon Autojoin";
				set stop		1;
				break
			}
		}
		catch { close $liste1 };
		if { $stop==1 } { return 0 }
		catch { open "[eva:scriptdir]db/close.db" r } liste2
		while { ![eof $liste2] } {
			gets $liste2 verif2;
			if { [string match *[string trimleft $value2 #]* [string trimleft $verif2 #]] } {
				eva:FCT:SENT:NOTICE "$vuser" "Accès Refusé : Salon Fermé";
				set stop		1;
				break
			}
		}
		catch { close $liste2 };
		if { $stop==1 } { return 0 }
		catch { open "[eva:scriptdir]db/secu.db" r } liste3
		while { ![eof $liste3] } {
			gets $liste3 verif3;
			if { [string match *[string trimleft $value2 #]* [string trimleft $verif3 #]] } {
				eva:FCT:SENT:NOTICE "$vuser" "Accès Refusé : Salon Sécurisé";
				set stop		1;
				break
			}
		}
		catch { close $liste3 };
		if { $stop==1 } { return 0 }
		catch { open "[eva:scriptdir]db/salon.db" r } liste
		while { ![eof $liste] } {
			gets $liste verif;
			if { ![string compare -nocase $value2 $verif] } {
				eva:FCT:SENT:NOTICE "$vuser" "\002$value1\002 est déjà dans la liste des salons interdits.";
				set stop		1;
				break
			}
		}
		catch { close $liste };
		if { $stop==1 } { return 0 }
		set chan		[open "[eva:scriptdir]db/salon.db" a]; puts $chan $value2; close $chan
		eva:FCT:SENT:NOTICE "$vuser" "\002$value1\002 a bien été ajouté dans la liste des salons interdits."
		if { [eva:console 1]=="ok" } {
			eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Addchan \003$eva(console_deco):\003$eva(console_txt) $user"
		}
	}
	"delchan" {
		if { [string index $value2 0]!="#" } {
			eva:FCT:SENT:NOTICE "$vuser" "\002Commande Delchan :\002 /msg $eva(pseudo) delchan #salon";
			return 0;
		}

		catch { open "[eva:scriptdir]db/salon.db" r } liste
		while { ![eof $liste] } {
			gets $liste verif;
			if { ![string compare -nocase $value2 $verif] } { set stop		1 };
			if { [string compare -nocase $value2 $verif] && $verif!="" } { lappend chan "$verif" }
		}
		catch { close $liste }
		if { $stop==0 } {
			eva:FCT:SENT:NOTICE "$vuser" "\002$value1\002 n'est pas dans la liste des salons interdits.";
			return 0;

		} else {
			if { [info exists chan] } {
				set del		[open "[eva:scriptdir]db/salon.db" w+]; foreach delchan $chan { puts $del "$delchan" }; close $del
			} else {
				set del		[open "[eva:scriptdir]db/salon.db" w+]; close $del
			}
			eva:FCT:SENT:NOTICE "$vuser" "\002$value1\002 a bien été supprimé de la liste des salons interdits."
			if { [eva:console 1]=="ok" } {
				eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Delchan \003$eva(console_deco):\003$eva(console_txt) $user"
			}
		}
	}
	"chanlist" {
		catch { open "[eva:scriptdir]db/salon.db" r } liste
		eva:FCT:SENT:NOTICE "$vuser" "\002\0031,1--------- \0030Salons Interdits \0031---------"
		eva:FCT:SENT:NOTICE "$vuser" "\002"
		while { ![eof $liste] } {
			gets $liste chan;
			if { $chan!="" } { incr stop 1; eva:FCT:SENT:NOTICE "$vuser" "\00301 \[\00303 $stop \00301\] \00301 $chan" }
		}
		catch { close $liste }
		if { $stop==0 } {
			eva:FCT:SENT:NOTICE "$vuser" "Aucun Salon"
		}
		if { [eva:console 1]=="ok" } {
			eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Chanlist \003$eva(console_deco):\003$eva(console_txt) $user"
		}
	}
	"addtrust" {
		if { $value2=="" } {
			eva:FCT:SENT:NOTICE "$vuser" "\002Commande Addtrust :\002 /msg $eva(pseudo) addtrust mask";
			return 0;
		}

		catch { open "[eva:scriptdir]db/host.db" r } liste1
		while { ![eof $liste1] } {
			gets $liste1 verif1;
			if { [string match *$value2* $verif1] } {
				eva:FCT:SENT:NOTICE "$vuser" "Accès Refusé : Hostname Interdite";
				set stop		1;
				break
			}
		}
		catch { close $liste1 };
		if { $stop==1 } { return 0 }
		catch { open [eva:scriptdir]db/trust.db r } liste
		while { ![eof $liste] } {
			gets $liste verif;
			if { $verif==$value2 } {
				eva:FCT:SENT:NOTICE "$vuser" "\002$value1\002 est déjà dans la trustlist.";
				set stop		1;
				break
			}
		}
		catch { close $liste };
		if { $stop==1 } { return 0 }
		set bprotect		[open [eva:scriptdir]db/trust.db a]; puts $bprotect "$value2"; close $bprotect
		eva:FCT:SENT:NOTICE "$vuser" "\002$value1\002 a bien été ajoutée dans la trustlist."
		if { ![info exists trust($value2)] } { set trust($value2)		1 }
		if { [eva:console 1]=="ok" } {
			eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Addtrust \003$eva(console_deco):\003$eva(console_txt) $user"
		}
	}
	"deltrust" {
		if { $value2=="" } {
			eva:FCT:SENT:NOTICE "$vuser" "\002Commande Deltrust :\002 /msg $eva(pseudo) deltrust mask";
			return 0;
		}

		catch { open [eva:scriptdir]db/trust.db r } liste
		while { ![eof $liste] } {
			gets $liste verif;
			if { $verif==$value2 } { set stop		1 };
			if { $verif!=$value2 && $verif!="" } { lappend hs "$verif" }
		}
		catch { close $liste }
		if { $stop==0 } {
			eva:FCT:SENT:NOTICE "$vuser" "\002$value1\002 n'est pas dans la trustlist.";
			return 0;

		} else {
			if { [info exists hs] } {
				set del		[open [eva:scriptdir]db/trust.db w+]; foreach delprotect $hs { puts $del "$delprotect" }; close $del
			} else {
				set del		[open [eva:scriptdir]db/trust.db w+]; close $del
			}
			eva:FCT:SENT:NOTICE "$vuser" "\002$value1\002 a bien été supprimée de la trustlist."
			if { [info exists trust($value2)] } { unset trust($value2)		}
			if { [eva:console 1]=="ok" } {
				eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Deltrust \003$eva(console_deco):\003$eva(console_txt) $user"
			}
		}
	}
	"trustlist" {
		catch { open [eva:scriptdir]db/trust.db r } liste
		eva:FCT:SENT:NOTICE "$vuser" "\002\0031,1----------------- \0030Liste des Trusts \0031-----------------"
		eva:FCT:SENT:NOTICE "$vuser" "\002"
		while { ![eof $liste] } {
			gets $liste mask;
			if { $mask!="" } { incr stop 1; eva:FCT:SENT:NOTICE "$vuser" "\00301 \[\00303 $stop \00301\] \00301 $mask" }
		}
		catch { close $liste }
		if { $stop==0 } {
			eva:FCT:SENT:NOTICE "$vuser" "Aucun Trust"
		}
		if { [eva:console 1]=="ok" } {
			eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Trustlist \003$eva(console_deco):\003$eva(console_txt) $user"
		}
	}
	"addaccess" {
		if { $value2=="" || $value4=="" || $value8=="" || [regexp \[^1-4\] $value8] } {
			eva:FCT:SENT:NOTICE "$vuser" "\002Commande Addaccess :\002 /msg $eva(pseudo) addaccess pseudo password level"
			eva:FCT:SENT:NOTICE "$vuser" "\00302Level 1 \00304:\00301 Helpeur"
			eva:FCT:SENT:NOTICE "$vuser" "\00302Level 2 \00304:\00301 Géofront"
			eva:FCT:SENT:NOTICE "$vuser" "\00302Level 3 \00304:\00301 IRCop"
			eva:FCT:SENT:NOTICE "$vuser" "\00302Level 4 \00304:\00301 Admin"
			return 0
		}
		if { [string length $value2]>="10" } {
			eva:FCT:SENT:NOTICE "$vuser" "Le pseudo doit contenir maximum 9 caractères.";
			return 0;
		}

		foreach verif [userlist] {
			if { [string tolower $value2]==[string tolower $verif] } {
				eva:FCT:SENT:NOTICE "$vuser" "\002$value1\002 est déja dans la liste des accès.";
				return 0;
			}

		}
		if { [string length $value4]<=5 } {
			eva:FCT:SENT:NOTICE "$vuser" "Le mot de passe doit contenir minimum 6 caractères.";
			return 0;
		}

		adduser $value1;
		setuser $value1 PASS $value3;
		setuser $value1 HOSTS $value1*!*@*;
		setuser $value1 HOSTS -telnet!*@*
		switch -exact $value8 {
			1 { chattr $value1 +p;
				set lvl		"helpeurs"
			}
			2 { chattr $value1 +op;
				set lvl		"géofronts"
			}
			3 { chattr $value1 +mop;
				set lvl		"IRCops"
			}
			4 { chattr $value1 +nmop;
				set lvl		"Admins"
			}
		}
		eva:FCT:SENT:NOTICE "$vuser" "\002$value1\002 a bien été ajouté dans la liste des $lvl."
		if { [eva:console 1]=="ok" } {
		eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Addaccess \003$eva(console_deco):\003$eva(console_txt) $user"
	}
}
"delaccess" {
	if { $value1=="" } {
		eva:FCT:SENT:NOTICE "$vuser" "\002Commande Delaccess :\002 /msg $eva(pseudo) delaccess pseudo";
		return 0;
	}

	if { [string tolower $admin]==$value2 } {
		eva:FCT:SENT:NOTICE "$vuser" "Accès Refusé.";
		return 0;
	}

	foreach verif [userlist] {
		if { $value2==[string tolower $verif] } {
			foreach { pseudo auth } [array get admins] {
				if { [string tolower $auth]==$value2 } { unset admins([string		tolower $pseudo]) }
			}
			deluser $value2
			eva:FCT:SENT:NOTICE "$vuser" "\002$value1\002 a bien été supprimé de la liste des accès."
			if { [eva:console 1]=="ok" } {
				eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Delaccess \003$eva(console_deco):\003$eva(console_txt) $user"
			}
			return 0
		}
	}
	eva:FCT:SENT:NOTICE "$vuser" "\002$value1\002 n'est pas dans la liste des accès."
}
"modaccess" {
	if { $value2!="level" && $value2!="pass" } {
		eva:FCT:SENT:NOTICE "$vuser" "\002Commande Modaccess Pass :\002 /msg $eva(pseudo) modaccess pass pseudo mot-de-passe"
		eva:FCT:SENT:NOTICE "$vuser" "\002Commande Modaccess Level :\002 /msg $eva(pseudo) modaccess level pseudo level"
		return 0
	}
	switch -exact $value2 {
		"level" {
			if { $value4=="" || $value8=="" || [regexp \[^1-4\] $value8] } {
				eva:FCT:SENT:NOTICE "$vuser" "\002Commande Modaccess Level :\002 /msg $eva(pseudo) modaccess level pseudo level"
				eva:FCT:SENT:NOTICE "$vuser" "\00302Level 1 \00304:\00301 Helpeur"
				eva:FCT:SENT:NOTICE "$vuser" "\00302Level 2 \00304:\00301 Géofront"
				eva:FCT:SENT:NOTICE "$vuser" "\00302Level 3 \00304:\00301 IRCop"
				eva:FCT:SENT:NOTICE "$vuser" "\00302Level 4 \00304:\00301 Admin"
				return 0
			}
			if { [string tolower $admin]==$value4 } {
				eva:FCT:SENT:NOTICE "$vuser" "Accès Refusé.";
				return 0;
			}

			foreach verif [userlist] {
				if { $value4==[string tolower $verif] } {
					switch -exact $value8 {
						1 { chattr $value4 -nmopjltx; chattr $value4 +p }
						2 { chattr $value4 -nmopjltx; chattr $value4 +op }
						3 { chattr $value4 -nmopjltx; chattr $value4 +mop }
						4 { chattr $value4 -nmopjltx; chattr $value4 +nmop }
					}
					eva:FCT:SENT:NOTICE "$vuser" "Changement du level de \002$value4\002 reussi."
					if { [eva:console 1]=="ok" } {
						eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Modaccess \003$eva(console_deco):\003$eva(console_txt) $user"
					}
					return 0
				}
			}
			eva:FCT:SENT:NOTICE "$vuser" "\002$value4\002 n'est pas dans la liste des accès.";
			return 0;

		}
		"pass" {
			if { $value4=="" || $value8=="" } {
				eva:FCT:SENT:NOTICE "$vuser" "\002Commande Modaccess Pass :\002 /msg $eva(pseudo) modaccess pass pseudo mot-de-passe";
				return 0;
			}

			if { [string tolower $admin]==$value4 } {
				eva:FCT:SENT:NOTICE "$vuser" "Accès Refusé.";
				return 0;
			}

			foreach verif [userlist] {
				if { $value4==[string tolower $verif] } {
					if { [string length $value8]<=5 } {
						eva:FCT:SENT:NOTICE "$vuser" "Le mot de passe doit contenir minimum 6 caractères.";
						return 0;
					}

					setuser $value3 PASS $value8
					eva:FCT:SENT:NOTICE "$vuser" "Changement du mot de passe de \002$value4\002 reussi."
					if { [eva:console 1]=="ok" } {
						eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Modaccess \003$eva(console_deco):\003$eva(console_txt) $user"
					}
					return 0
				}
			}
			eva:FCT:SENT:NOTICE "$vuser" "\002$value4\002 n'est pas dans la liste des accès.";
			return 0;

		}
	}
}
}
}

#############
# Eva Hcmds #
#############

proc eva:hcmds { arg } {
	global eva ceva
	set arg			[split $arg]
	set hcmd		[lindex $arg 0]
	set vuser		[string tolower [lindex $arg 1]]
	set vuserUID	[eva:UID:CONVERT $vuser]
	if { [eva:authed $vuser $ceva($hcmd)]!="ok" } { return 0 }
	switch -exact $hcmd {
		"help" {
			eva:FCT:SENT:NOTICE "$vuserUID" "\002Commande Help :\002 /msg $eva(pseudo) help nom-de-la-commande"
			eva:FCT:SENT:NOTICE "$vuserUID" "Permet de voir l'aide détaillée de la commande."
		}
		"auth" {
			eva:FCT:SENT:NOTICE "$vuserUID" "\002Commande Help :\002 /msg $eva(pseudo) auth pseudo mot-de-passe"
			eva:FCT:SENT:NOTICE "$vuserUID" "Permet de vous authentifier sur $eva(pseudo)."
		}
		"deauth" {
			eva:FCT:SENT:NOTICE "$vuserUID" "\002Commande Help :\002 /msg $eva(pseudo) deauth"
			eva:FCT:SENT:NOTICE "$vuserUID" "Permet de vous déauthentifier sur $eva(pseudo)."
		}
		"copyright" {
			eva:FCT:SENT:NOTICE "$vuserUID" "\002Commande Help :\002 /msg $eva(pseudo) copyright"
			eva:FCT:SENT:NOTICE "$vuserUID" "Permet de voir l'auteur de $eva(pseudo)."
		}
		"showcommands" {
			eva:FCT:SENT:NOTICE "$vuserUID" "\002Commande Help :\002 /msg $eva(pseudo) showcommands"
			eva:FCT:SENT:NOTICE "$vuserUID" "Permet de voir la liste des commandes de Eva Service."
		}
		"join" {
			eva:FCT:SENT:NOTICE "$vuserUID" "\002Commande Help :\002 /msg $eva(pseudo) join #salon"
			eva:FCT:SENT:NOTICE "$vuserUID" "Permet de faire joindre $eva(pseudo) sur un salon."
		}
		"part" {
			eva:FCT:SENT:NOTICE "$vuserUID" "\002Commande Help :\002 /msg $eva(pseudo) part #salon"
			eva:FCT:SENT:NOTICE "$vuserUID" "Permet de faire partir $eva(pseudo) d'un salon."
		}
		"list" {
			eva:FCT:SENT:NOTICE "$vuserUID" "\002Commande Help :\002 /msg $eva(pseudo) list"
			eva:FCT:SENT:NOTICE "$vuserUID" "Permet de voir les autojoin salons."
		}
		"chanlog" {
			eva:FCT:SENT:NOTICE "$vuserUID" "\002Commande Help :\002 /msg $eva(pseudo) chanlog #salon"
			eva:FCT:SENT:NOTICE "$vuserUID" "Permet de changer le salon de log de $eva(pseudo)."
		}
		"console" {
			eva:FCT:SENT:NOTICE "$vuserUID" "\002Commande Help :\002 /msg $eva(pseudo) console 0/1/2/3"
			eva:FCT:SENT:NOTICE "$vuserUID" "\00302Level 0 \00304:\00301 Aucune console"
			eva:FCT:SENT:NOTICE "$vuserUID" "\00302Level 1 \00304:\00301 Console commande"
			eva:FCT:SENT:NOTICE "$vuserUID" "\00302Level 2 \00304:\00301 Console commande & connexion & déconnexion"
			eva:FCT:SENT:NOTICE "$vuserUID" "\00302Level 3 \00304:\00301 Toutes les consoles"
			eva:FCT:SENT:NOTICE "$vuserUID" "Permet d'activer la console des logs en fonction du level."
		}
		"maxlogin" {
			eva:FCT:SENT:NOTICE "$vuserUID" "\002Commande Help :\002 /msg $eva(pseudo) maxlogin on/off"
			eva:FCT:SENT:NOTICE "$vuserUID" "Permet d'activer où désactiver la protection max login."
		}
		"backup" {
			eva:FCT:SENT:NOTICE "$vuserUID" "\002Commande Help :\002 /msg $eva(pseudo) backup"
			eva:FCT:SENT:NOTICE "$vuserUID" "Permet de créer une sauvegarde des databases."
		}
		"restart" {
			eva:FCT:SENT:NOTICE "$vuserUID" "\002Commande Help :\002 /msg $eva(pseudo) restart"
			eva:FCT:SENT:NOTICE "$vuserUID" "Permet de redémarrer Eva Service."
		}
		"die" {
			eva:FCT:SENT:NOTICE "$vuserUID" "\002Commande Help :\002 /msg $eva(pseudo) die"
			eva:FCT:SENT:NOTICE "$vuserUID" "Permet d'arrêter Eva Service."
		}
		"status" {
			eva:FCT:SENT:NOTICE "$vuserUID" "\002Commande Help :\002 /msg $eva(pseudo) status"
			eva:FCT:SENT:NOTICE "$vuserUID" "Permet de voir les informations de Eva Service."
		}
		"protection" {
			eva:FCT:SENT:NOTICE "$vuserUID" "\002Commande Help :\002 /msg $eva(pseudo) protection 0/1/2/3/4"
			eva:FCT:SENT:NOTICE "$vuserUID" "\00302Level 0 \00304:\00301 Aucune Protection"
			eva:FCT:SENT:NOTICE "$vuserUID" "\00302Level 1 \00304:\00301 Protection Admins"
			eva:FCT:SENT:NOTICE "$vuserUID" "\00302Level 2 \00304:\00301 Protection Admins + Ircops"
			eva:FCT:SENT:NOTICE "$vuserUID" "\00302Level 3 \00304:\00301 Protection Admins + Ircops + Géofronts"
			eva:FCT:SENT:NOTICE "$vuserUID" "\00302Level 4 \00304:\00301 Protection de tous les accès"
			eva:FCT:SENT:NOTICE "$vuserUID" "Permet d'activer la protection en fonction du level."
		}
		"newpass" {
			eva:FCT:SENT:NOTICE "$vuserUID" "\002Commande Help :\002 /msg $eva(pseudo) newpass mot-de-passe"
			eva:FCT:SENT:NOTICE "$vuserUID" "Permet de changer le mot de passe de votre accès."
		}
		"map" {
			eva:FCT:SENT:NOTICE "$vuserUID" "\002Commande Help :\002 /msg $eva(pseudo) map"
			eva:FCT:SENT:NOTICE "$vuserUID" "Permet de voir la liste des serveurs."
		}
		"seen" {
			eva:FCT:SENT:NOTICE "$vuserUID" "\002Commande Help :\002 /msg $eva(pseudo) seen pseudo"
			eva:FCT:SENT:NOTICE "$vuserUID" "Permet de voir la dernière authentification du pseudo."
		}
		"access" {
			eva:FCT:SENT:NOTICE "$vuserUID" "\002Commande Help :\002 /msg $eva(pseudo) access pseudo"
			eva:FCT:SENT:NOTICE "$vuserUID" "Permet de voir l'accès du pseudo."
		}
		"owner" {
			eva:FCT:SENT:NOTICE "$vuserUID" "\002Commande Help :\002 /msg $eva(pseudo) owner #salon pseudo"
			eva:FCT:SENT:NOTICE "$vuserUID" "Permet de mêttre un utilisateur owner d'un salon."
		}
		"deowner" {
			eva:FCT:SENT:NOTICE "$vuserUID" "\002Commande Help :\002 /msg $eva(pseudo) deowner #salon pseudo"
			eva:FCT:SENT:NOTICE "$vuserUID" "Permet de retirer un utilisateur owner d'un salon."
		}
		"protect" {
			eva:FCT:SENT:NOTICE "$vuserUID" "\002Commande Help :\002 /msg $eva(pseudo) protect #salon pseudo"
			eva:FCT:SENT:NOTICE "$vuserUID" "Permet de mêttre un utilisateur protect d'un salon."
		}
		"deprotect" {
			eva:FCT:SENT:NOTICE "$vuserUID" "\002Commande Help :\002 /msg $eva(pseudo) deprotect #salon pseudo"
			eva:FCT:SENT:NOTICE "$vuserUID" "Permet de retirer un utilisateur protect d'un salon."
		}
		"ownerall" {
			eva:FCT:SENT:NOTICE "$vuserUID" "\002Commande Help :\002 /msg $eva(pseudo) ownerall #salon"
			eva:FCT:SENT:NOTICE "$vuserUID" "Permet de mêttre tous les utilisateurs owner d'un salon."
		}
		"deownerall" {
			eva:FCT:SENT:NOTICE "$vuserUID" "\002Commande Help :\002 /msg $eva(pseudo) deownerall #salon"
			eva:FCT:SENT:NOTICE "$vuserUID" "Permet de retirer tous les utilisateurs owner d'un salon."
		}
		"protectall" {
			eva:FCT:SENT:NOTICE "$vuserUID" "\002Commande Help :\002 /msg $eva(pseudo) protectall #salon"
			eva:FCT:SENT:NOTICE "$vuserUID" "Permet de mêttre tous les utilisateurs protect d'un salon."
		}
		"deprotectall" {
			eva:FCT:SENT:NOTICE "$vuserUID" "\002Commande Help :\002 /msg $eva(pseudo) deprotectall #salon"
			eva:FCT:SENT:NOTICE "$vuserUID" "Permet de retirer tous les utilisateurs protect d'un salon."
		}
		"op" {
			eva:FCT:SENT:NOTICE "$vuserUID" "\002Commande Help :\002 /msg $eva(pseudo) op #salon pseudo"
			eva:FCT:SENT:NOTICE "$vuserUID" "Permet d'oper un utilisateur d'un salon."
		}
		"deop" {
			eva:FCT:SENT:NOTICE "$vuserUID" "\002Commande Help :\002 /msg $eva(pseudo) deop #salon pseudo"
			eva:FCT:SENT:NOTICE "$vuserUID" "Permet de déoper un utilisateur d'un salon."
		}
		"halfop" {
			eva:FCT:SENT:NOTICE "$vuserUID" "\002Commande Help :\002 /msg $eva(pseudo) halfop #salon pseudo"
			eva:FCT:SENT:NOTICE "$vuserUID" "Permet d'halfoper un utilisateur d'un salon."
		}
		"dehalfop" {
			eva:FCT:SENT:NOTICE "$vuserUID" "\002Commande Help :\002 /msg $eva(pseudo) dehalfop #salon pseudo"
			eva:FCT:SENT:NOTICE "$vuserUID" "Permet de déhalfoper un utilisateur d'un salon."
		}
		"voice" {
			eva:FCT:SENT:NOTICE "$vuserUID" "\002Commande Help :\002 /msg $eva(pseudo) voice #salon pseudo"
			eva:FCT:SENT:NOTICE "$vuserUID" "Permet de voicer un utilisateur d'un salon."
		}
		"devoice" {
			eva:FCT:SENT:NOTICE "$vuserUID" "\002Commande Help :\002 /msg $eva(pseudo) devoice #salon pseudo"
			eva:FCT:SENT:NOTICE "$vuserUID" "Permet de dévoicer un utilisateur d'un salon."
		}
		"opall" {
			eva:FCT:SENT:NOTICE "$vuserUID" "\002Commande Help :\002 /msg $eva(pseudo) opall #salon"
			eva:FCT:SENT:NOTICE "$vuserUID" "Permet d'oper tous les utilisateurs d'un salon."
		}
		"deopall" {
			eva:FCT:SENT:NOTICE "$vuserUID" "\002Commande Help :\002 /msg $eva(pseudo) deopall #salon"
			eva:FCT:SENT:NOTICE "$vuserUID" "Permet de déoper tous les utilisateurs d'un salon."
		}
		"halfopall" {
			eva:FCT:SENT:NOTICE "$vuserUID" "\002Commande Help :\002 /msg $eva(pseudo) halfopall #salon"
			eva:FCT:SENT:NOTICE "$vuserUID" "Permet d'halfoper tous les utilisateurs d'un salon."
		}
		"dehalfopall" {
			eva:FCT:SENT:NOTICE "$vuserUID" "\002Commande Help :\002 /msg $eva(pseudo) dehalfopall #salon"
			eva:FCT:SENT:NOTICE "$vuserUID" "Permet de déhalfoper tous les utilisateurs d'un salon."
		}
		"voiceall" {
			eva:FCT:SENT:NOTICE "$vuserUID" "\002Commande Help :\002 /msg $eva(pseudo) voiceall #salon"
			eva:FCT:SENT:NOTICE "$vuserUID" "Permet de voicer tous les utilisateurs d'un salon."
		}
		"devoiceall" {
			eva:FCT:SENT:NOTICE "$vuserUID" "\002Commande Help :\002 /msg $eva(pseudo) devoiceall #salon"
			eva:FCT:SENT:NOTICE "$vuserUID" "Permet de dévoicer tous les utilisateurs d'un salon."
		}
		"kick" {
			eva:FCT:SENT:NOTICE "$vuserUID" "\002Commande Help :\002 /msg $eva(pseudo) kick #salon pseudo raison"
			eva:FCT:SENT:NOTICE "$vuserUID" "Permet de kicker un utilisateur d'un salon."
		}
		"kickall" {
			eva:FCT:SENT:NOTICE "$vuserUID" "\002Commande Help :\002 /msg $eva(pseudo) kickall #salon"
			eva:FCT:SENT:NOTICE "$vuserUID" "Permet de kicker tous les utilisateurs d'un salon."
		}
		"ban" {
			eva:FCT:SENT:NOTICE "$vuserUID" "\002Commande Help :\002 /msg $eva(pseudo) ban #salon mask"
			eva:FCT:SENT:NOTICE "$vuserUID" "Permet de bannir un mask d'un salon."
		}
		"nickban" {
			eva:FCT:SENT:NOTICE "$vuserUID" "\002Commande Help :\002 /msg $eva(pseudo) nickban #salon pseudo raison"
			eva:FCT:SENT:NOTICE "$vuserUID" "Permet de bannir et kicker un utilisateur d'un salon en fonction de son pseudo."
		}
		"kickban" {
			eva:FCT:SENT:NOTICE "$vuserUID" "\002Commande Help :\002 /msg $eva(pseudo) kickban #salon pseudo raison"
			eva:FCT:SENT:NOTICE "$vuserUID" "Permet de bannir et kicker un utilisateur d'un salon."
		}
		"unban" {
			eva:FCT:SENT:NOTICE "$vuserUID" "\002Commande Help :\002 /msg $eva(pseudo) unban #salon mask"
			eva:FCT:SENT:NOTICE "$vuserUID" "Permet de débannir un mask d'un salon."
		}
		"clearbans" {
			eva:FCT:SENT:NOTICE "$vuserUID" "\002Commande Help :\002 /msg $eva(pseudo) clearbans #salon"
			eva:FCT:SENT:NOTICE "$vuserUID" "Permet de débannir tous les masks d'un salon."
		}
		"topic" {
			eva:FCT:SENT:NOTICE "$vuserUID" "\002Commande Help :\002 /msg $eva(pseudo) topic #salon topic"
			eva:FCT:SENT:NOTICE "$vuserUID" "Permet de changer le topic d'un salon."
		}
		"mode" {
			eva:FCT:SENT:NOTICE "$vuserUID" "\002Commande Help :\002 /msg $eva(pseudo) mode #salon +/-mode"
			eva:FCT:SENT:NOTICE "$vuserUID" "Permet de changer les modes d'un salon."
		}
		"clearmodes" {
			eva:FCT:SENT:NOTICE "$vuserUID" "\002Commande Help :\002 /msg $eva(pseudo) clearmodes #salon"
			eva:FCT:SENT:NOTICE "$vuserUID" "Permet de retirer tous les modes d'un salon."
		}
		"clearallmodes" {
			eva:FCT:SENT:NOTICE "$vuserUID" "\002Commande Help :\002 /msg $eva(pseudo) clearallmodes #salon"
			eva:FCT:SENT:NOTICE "$vuserUID" "Permet de retirer tous les modes, tous les accès et tous les bans d'un salon."
		}
		"kill" {
			eva:FCT:SENT:NOTICE "$vuserUID" "\002Commande Help :\002 /msg $eva(pseudo) kill pseudo raison"
			eva:FCT:SENT:NOTICE "$vuserUID" "Permet de killer un utilisateur du serveur."
		}
		"chankill" {
			eva:FCT:SENT:NOTICE "$vuserUID" "\002Commande Help :\002 /msg $eva(pseudo) chankill #salon"
			eva:FCT:SENT:NOTICE "$vuserUID" "Permet de killer tous les utilisateurs d'un salon."
		}
		"svsjoin" {
			eva:FCT:SENT:NOTICE "$vuserUID" "\002Commande Help :\002 /msg $eva(pseudo) svsjoin #salon pseudo"
			eva:FCT:SENT:NOTICE "$vuserUID" "Permet de forcer un utilisateur à joindre un salon."
		}
		"svspart" {
			eva:FCT:SENT:NOTICE "$vuserUID" "\002Commande Help :\002 /msg $eva(pseudo) svspart #salon pseudo"
			eva:FCT:SENT:NOTICE "$vuserUID" "Permet de forcer un utilisateur à partir d'un salon."
		}
		"svsnick" {
			eva:FCT:SENT:NOTICE "$vuserUID" "\002Commande Help :\002 /msg $eva(pseudo) svsnick ancien-pseudo nouveau-pseudo"
			eva:FCT:SENT:NOTICE "$vuserUID" "Permet de changer le pseudo d'un utilisateur."
		}
		"say" {
			eva:FCT:SENT:NOTICE "$vuserUID" "\002Commande Help :\002 /msg $eva(pseudo) say #salon message"
			eva:FCT:SENT:NOTICE "$vuserUID" "Permet d'envoyer un message sur un salon."
		}
		"invite" {
			eva:FCT:SENT:NOTICE "$vuserUID" "\002Commande Help :\002 /msg $eva(pseudo) invite #salon pseudo"
			eva:FCT:SENT:NOTICE "$vuserUID" "Permet d'inviter un utilisateur sur un salon."
		}
		"inviteme" {
			eva:FCT:SENT:NOTICE "$vuserUID" "\002Commande Help :\002 /msg $eva(pseudo) inviteme"
			eva:FCT:SENT:NOTICE "$vuserUID" "Permet de s'inviter sur $eva(salon)."
		}
		"wallops" {
			eva:FCT:SENT:NOTICE "$vuserUID" "\002Commande Help :\002 /msg $eva(pseudo) wallops message"
			eva:FCT:SENT:NOTICE "$vuserUID" "Permet d'envoyer un message en wallops à tous les utilisateurs."
		}
		"globops" {
			eva:FCT:SENT:NOTICE "$vuserUID" "\002Commande Help :\002 /msg $eva(pseudo) globops message"
			eva:FCT:SENT:NOTICE "$vuserUID" "Permet d'envoyer un message en globops à tous les ircops et admins."
		}
		"notice" {
			eva:FCT:SENT:NOTICE "$vuserUID" "\002Commande Help :\002 /msg $eva(pseudo) notice message"
			eva:FCT:SENT:NOTICE "$vuserUID" "Permet d'envoyer une notice à tous les utilisateurs."
		}
		"whois" {
			eva:FCT:SENT:NOTICE "$vuserUID" "\002Commande Help :\002 /msg $eva(pseudo) whois pseudo"
			eva:FCT:SENT:NOTICE "$vuserUID" "Permet de voir le whois d'un utilisateur."
		}
		"changline" {
			eva:FCT:SENT:NOTICE "$vuserUID" "\002Commande Help :\002 /msg $eva(pseudo) changline #salon"
			eva:FCT:SENT:NOTICE "$vuserUID" "Permet de gline tous les utilisateurs d'un salon."
		}
		"gline" {
			eva:FCT:SENT:NOTICE "$vuserUID" "\002Commande Help :\002 /msg $eva(pseudo) gline <pseudo ou ip> raison"
			eva:FCT:SENT:NOTICE "$vuserUID" "Permet de gline un utilisateur du serveur."
		}
		"ungline" {
			eva:FCT:SENT:NOTICE "$vuserUID" "\002Commande Help :\002 /msg $eva(pseudo) ungline ident@host"
			eva:FCT:SENT:NOTICE "$vuserUID" "Permet de supprimer un mask de la liste des glines."
		}
		"shun" {
			eva:FCT:SENT:NOTICE "$vuserUID" "\002Commande Help :\002 /msg $eva(pseudo) shun <pseudo ou ip> raison"
			eva:FCT:SENT:NOTICE "$vuserUID" "Permet de shun un utilisateur du serveur."
		}
		"unshun" {
			eva:FCT:SENT:NOTICE "$vuserUID" "\002Commande Help :\002 /msg $eva(pseudo) unshun pseudo raison"
			eva:FCT:SENT:NOTICE "$vuserUID" "Permet de unshun un utilisateur du serveur."
		}
		"kline" {
			eva:FCT:SENT:NOTICE "$vuserUID" "\002Commande Help :\002 /msg $eva(pseudo) kline <pseudo ou ip> raison"
			eva:FCT:SENT:NOTICE "$vuserUID" "Permet de kline un utilisateur du serveur."
		}
		"unkline" {
			eva:FCT:SENT:NOTICE "$vuserUID" "\002Commande Help :\002 /msg $eva(pseudo) unkline ident@host"
			eva:FCT:SENT:NOTICE "$vuserUID" "Permet de supprimer un mask de la liste des klines."
		}
		"glinelist" {
			eva:FCT:SENT:NOTICE "$vuserUID" "\002Commande Help :\002 /msg $eva(pseudo) glinelist"
			eva:FCT:SENT:NOTICE "$vuserUID" "Permet de voir la liste des glines."
		}
		"shunlist" {
			eva:FCT:SENT:NOTICE "$vuserUID" "\002Commande Help :\002 /msg $eva(pseudo) shunlist"
			eva:FCT:SENT:NOTICE "$vuserUID" "Permet de voir la liste des shuns."
		}
		"klinelist" {
			eva:FCT:SENT:NOTICE "$vuserUID" "\002Commande Help :\002 /msg $eva(pseudo) klinelist"
			eva:FCT:SENT:NOTICE "$vuserUID" "Permet de voir la liste des klines."
		}
		"cleargline" {
			eva:FCT:SENT:NOTICE "$vuserUID" "\002Commande Help :\002 /msg $eva(pseudo) cleargline"
			eva:FCT:SENT:NOTICE "$vuserUID" "Permet de retirer tous les glines du serveur."
		}
		"clearkline" {
			eva:FCT:SENT:NOTICE "$vuserUID" "\002Commande Help :\002 /msg $eva(pseudo) clearkline"
			eva:FCT:SENT:NOTICE "$vuserUID" "Permet de retirer tous les klines du serveur."
		}
		"clientlist" {
			eva:FCT:SENT:NOTICE "$vuserUID" "\002Commande Help :\002 /msg $eva(pseudo) clientlist"
			eva:FCT:SENT:NOTICE "$vuserUID" "Permet de voir la liste des clients IRC interdits."
		}
		"addclient" {
			eva:FCT:SENT:NOTICE "$vuserUID" "\002Commande Help :\002 /msg $eva(pseudo) addclient version"
			eva:FCT:SENT:NOTICE "$vuserUID" "Permet d'ajouter un client IRC interdit."
		}
		"delclient" {
			eva:FCT:SENT:NOTICE "$vuserUID" "\002Commande Help :\002 /msg $eva(pseudo) delclient version"
			eva:FCT:SENT:NOTICE "$vuserUID" "Permet de supprimer un client IRC interdit."
		}
		"addsecu" {
			eva:FCT:SENT:NOTICE "$vuserUID" "\002Commande Help :\002 /msg $eva(pseudo) addsecu #salon"
			eva:FCT:SENT:NOTICE "$vuserUID" "Permet d'ajouter un salon sécurisé."
		}
		"delsecu" {
			eva:FCT:SENT:NOTICE "$vuserUID" "\002Commande Help :\002 /msg $eva(pseudo) delsecu #salon"
			eva:FCT:SENT:NOTICE "$vuserUID" "Permet de supprimer un salon sécurisé."
		}
		"seculist" {
			eva:FCT:SENT:NOTICE "$vuserUID" "\002Commande Help :\002 /msg $eva(pseudo) seculist"
			eva:FCT:SENT:NOTICE "$vuserUID" "Permet de voir la liste des salons sécurisés."
		}
		"secu" {
			eva:FCT:SENT:NOTICE "$vuserUID" "\002Commande Help :\002 /msg $eva(pseudo) secu on/off"
			eva:FCT:SENT:NOTICE "$vuserUID" "Permet d'activer ou désactiver le système de sécurité des salons."
		}
		"client" {
			eva:FCT:SENT:NOTICE "$vuserUID" "\002Commande Help :\002 /msg $eva(pseudo) client on/off"
			eva:FCT:SENT:NOTICE "$vuserUID" "Permet d'activer ou désactiver les clients IRC interdits."
		}
		"clone" {
			eva:FCT:SENT:NOTICE "$vuserUID" "\002Commande Help :\002 /msg $eva(pseudo) clone on/off"
			eva:FCT:SENT:NOTICE "$vuserUID" "Permet d'activer ou désactiver la protection clone."
		}
		"close" {
			eva:FCT:SENT:NOTICE "$vuserUID" "\002Commande Help :\002 /msg $eva(pseudo) close #salon"
			eva:FCT:SENT:NOTICE "$vuserUID" "Permet de fermer un salon."
		}
		"unclose" {
			eva:FCT:SENT:NOTICE "$vuserUID" "\002Commande Help :\002 /msg $eva(pseudo) unclose #salon"
			eva:FCT:SENT:NOTICE "$vuserUID" "Permet d'ouvrir un salon fermé."
		}
		"closelist" {
			eva:FCT:SENT:NOTICE "$vuserUID" "\002Commande Help :\002 /msg $eva(pseudo) closelist"
			eva:FCT:SENT:NOTICE "$vuserUID" "Permet de voir la liste des salons fermés."
		}
		"clearclose" {
			eva:FCT:SENT:NOTICE "$vuserUID" "\002Commande Help :\002 /msg $eva(pseudo) clearclose"
			eva:FCT:SENT:NOTICE "$vuserUID" "Permet de vider la liste des salons fermés."
		}
		"addnick" {
			eva:FCT:SENT:NOTICE "$vuserUID" "\002Commande Help :\002 /msg $eva(pseudo) addnick pseudo"
			eva:FCT:SENT:NOTICE "$vuserUID" "Permet d'ajouter un pseudo interdit."
		}
		"delnick" {
			eva:FCT:SENT:NOTICE "$vuserUID" "\002Commande Help :\002 /msg $eva(pseudo) delnick pseudo"
			eva:FCT:SENT:NOTICE "$vuserUID" "Permet de supprimer un pseudo interdit."
		}
		"nicklist" {
			eva:FCT:SENT:NOTICE "$vuserUID" "\002Commande Help :\002 /msg $eva(pseudo) nicklist"
			eva:FCT:SENT:NOTICE "$vuserUID" "Permet de voir la liste des pseudos interdits."
		}
		"addident" {
			eva:FCT:SENT:NOTICE "$vuserUID" "\002Commande Help :\002 /msg $eva(pseudo) addident ident"
			eva:FCT:SENT:NOTICE "$vuserUID" "Permet d'ajouter un ident interdit."
		}
		"delident" {
			eva:FCT:SENT:NOTICE "$vuserUID" "\002Commande Help :\002 /msg $eva(pseudo) delident ident"
			eva:FCT:SENT:NOTICE "$vuserUID" "Permet de supprimer un ident interdit."
		}
		"identlist" {
			eva:FCT:SENT:NOTICE "$vuserUID" "\002Commande Help :\002 /msg $eva(pseudo) identlist"
			eva:FCT:SENT:NOTICE "$vuserUID" "Permet de voir la liste des idents interdits."
		}
		"addreal" {
			eva:FCT:SENT:NOTICE "$vuserUID" "\002Commande Help :\002 /msg $eva(pseudo) addreal realname"
			eva:FCT:SENT:NOTICE "$vuserUID" "Permet d'ajouter un realname interdit."
		}
		"delreal" {
			eva:FCT:SENT:NOTICE "$vuserUID" "\002Commande Help :\002 /msg $eva(pseudo) delreal realname"
			eva:FCT:SENT:NOTICE "$vuserUID" "Permet de supprimer un realname interdit."
		}
		"reallist" {
			eva:FCT:SENT:NOTICE "$vuserUID" "\002Commande Help :\002 /msg $eva(pseudo) reallist"
			eva:FCT:SENT:NOTICE "$vuserUID" "Permet de voir la liste des realnames interdits."
		}
		"addhost" {
			eva:FCT:SENT:NOTICE "$vuserUID" "\002Commande Help :\002 /msg $eva(pseudo) addhost hostname"
			eva:FCT:SENT:NOTICE "$vuserUID" "Permet d'ajouter une hostname interdite."
		}
		"delhost" {
			eva:FCT:SENT:NOTICE "$vuserUID" "\002Commande Help :\002 /msg $eva(pseudo) delhost hostname"
			eva:FCT:SENT:NOTICE "$vuserUID" "Permet de supprimer une hostname interdite."
		}
		"hostlist" {
			eva:FCT:SENT:NOTICE "$vuserUID" "\002Commande Help :\002 /msg $eva(pseudo) hostlist"
			eva:FCT:SENT:NOTICE "$vuserUID" "Permet de voir la liste des hostnames interdites."
		}
		"addchan" {
			eva:FCT:SENT:NOTICE "$vuserUID" "\002Commande Help :\002 /msg $eva(pseudo) addchan #salon"
			eva:FCT:SENT:NOTICE "$vuserUID" "Permet d'ajouter un salon interdit."
		}
		"delchan" {
			eva:FCT:SENT:NOTICE "$vuserUID" "\002Commande Help :\002 /msg $eva(pseudo) delchan #salon"
			eva:FCT:SENT:NOTICE "$vuserUID" "Permet de supprimer un salon interdit."
		}
		"chanlist" {
			eva:FCT:SENT:NOTICE "$vuserUID" "\002Commande Help :\002 /msg $eva(pseudo) chanlist"
			eva:FCT:SENT:NOTICE "$vuserUID" "Permet de voir la liste des salons interdits."
		}
		"addtrust" {
			eva:FCT:SENT:NOTICE "$vuserUID" "\002Commande Help :\002 /msg $eva(pseudo) addtrust mask"
			eva:FCT:SENT:NOTICE "$vuserUID" "Permet d'ajouter un trust sur un mask."
		}
		"deltrust" {
			eva:FCT:SENT:NOTICE "$vuserUID" "\002Commande Help :\002 /msg $eva(pseudo) deltrust mask"
			eva:FCT:SENT:NOTICE "$vuserUID" "Permet de supprimer le trust d'un mask."
		}
		"trustlist" {
			eva:FCT:SENT:NOTICE "$vuserUID" "\002Commande Help :\002 /msg $eva(pseudo) trustlist"
			eva:FCT:SENT:NOTICE "$vuserUID" "Permet de voir la liste des trusts."
		}
		"addaccess" {
			eva:FCT:SENT:NOTICE "$vuserUID" "\002Commande Help :\002 /msg $eva(pseudo) addaccess pseudo password level"
			eva:FCT:SENT:NOTICE "$vuserUID" "Permet d'ajouter un accès sur Eva Service."
		}
		"modaccess" {
			eva:FCT:SENT:NOTICE "$vuserUID" "\002Commande Help :\002 /msg $eva(pseudo) modaccess pass pseudo mot-de-passe"
			eva:FCT:SENT:NOTICE "$vuserUID" "\002Commande Help :\002 /msg $eva(pseudo) modaccess level pseudo level"
			eva:FCT:SENT:NOTICE "$vuserUID" "Permet de modifier un accès de Eva Service."
		}
		"delaccess" {
			eva:FCT:SENT:NOTICE "$vuserUID" "\002Commande Help :\002 /msg $eva(pseudo) delaccess pseudo"
			eva:FCT:SENT:NOTICE "$vuserUID" "Permet de supprimer un accès de Eva Service."
		}
	}
}

#################
# Eva Connexion #
#################

proc eva:connexion { } {
	global eva vhost protect ueva netadmin UID_DB
	if { $eva(DEBUG) } { putlog "connect $eva(ip) $eva(port)" }
	if { ![catch "connect $eva(ip) $eva(port)" eva(idx)] } {
		control $eva(idx) eva:link
		if { [info exists vhost] } { unset vhost	}
		if { [info exists ueva] } { unset ueva		}
		if { [info exists netadmin] } { unset netadmin		}
		set eva(init)		1;
		set eva(cmd)		"close"; utimer $eva(timerinit) [list set eva(init)		0]
		utimer $eva(timerinit) [list unset eva(cmd)];		eva:chargement;
		set eva(uptime)		[clock seconds]
		set eva(server_id)			[string toupper	"${eva(SID)}AAAAAB"]
		eva:sent2socket $eva(idx) ":$eva(SID) PASS :$eva(pass)"
		eva:sent2socket $eva(idx) ":$eva(SID) PROTOCTL NICKv2 VHP UMODE2 NICKIP SJOIN SJOIN2 SJ3 NOQUIT TKLEXT MLOCK SID"
		eva:sent2socket $eva(idx) ":$eva(SID) PROTOCTL EAUTH=$eva(link),,,Eva-$eva(version)"
		eva:sent2socket $eva(idx) ":$eva(SID) PROTOCTL SID=$eva(SID)"
		eva:sent2socket $eva(idx) ":$eva(SID) SERVER $eva(link) 1 :Services for IRC Networks"
		eva:sent2socket $eva(idx) ":$eva(SID) $eva(pseudo) :Reserved for services"
		eva:sent2socket $eva(idx) ":$eva(SID) UID $eva(pseudo) 1 [unixtime] $eva(ident) $eva(host) $eva(server_id) * +ioS * * * :$eva(real)"
		eva:sent2socket $eva(idx) ":$eva(SID) SJOIN [unixtime] $eva(salon) + :$eva(server_id)"
		eva:sent2socket $eva(idx) ":$eva(SID) MODE $eva(salon) +$eva(smode)"

		set UID_DB([string		toupper $eva(pseudo)])	$eva(server_id)
		set UID_DB($eva(server_id))					$eva(pseudo)
		set vhost([string		tolower $eva(pseudo)])	$eva(host)

		for { set i		0 } { $i < [string length $eva(cmode)] } { incr i } {
			set tmode		[string index $eva(cmode) $i]
			if { $tmode=="q" || $tmode=="a" || $tmode=="o" || $tmode=="h" || $tmode=="v" } {
				eva:sent2socket $eva(idx) ":$eva(server_id) MODE $eva(salon) +$tmode $eva(server_id)"
			}
		}
		catch { open "[eva:scriptdir]db/chan.db" r } autojoin
		while { ![eof $autojoin] } {
			gets $autojoin salon;
			if { $salon!="" } {
				eva:sent2socket $eva(idx) ":$eva(server_id) JOIN $salon";
				if { $eva(cmode)=="q" || $eva(cmode)=="a" || $eva(cmode)=="o" || $eva(cmode)=="h" || $eva(cmode)=="v" } {
					eva:sent2socket $eva(idx) ":$eva(server_id) MODE $salon +$eva(cmode) $eva(server_id)"
				}
			}
		}
		catch { close $autojoin }
		catch { open "[eva:scriptdir]db/close.db" r } ferme
		while { ![eof $ferme] } {
			gets $ferme salle;
			if { $salle!="" } {
				eva:sent2socket $eva(idx) ":$eva(server_id) JOIN $salle";
				eva:sent2socket $eva(idx) ":$eva(server_id) MODE $salle +sntio $eva(SID)";
				eva:sent2socket $eva(idx) ":$eva(server_id) TOPIC $salle :\0031Salon Fermé le [eva:duree [unixtime]]";
				eva:sent2socket $eva(idx) ":$eva(link) NAMES $salle"
			}
		}
		catch { close $ferme }
		incr eva(counter) 1

		utimer $eva(timerco) eva:verif

	} else {

		if { [info exists eva(idx)] } { unset eva(idx)		}
	}
}

######################
# Eva Initialisation #
######################

proc eva:initialisation { arg } {
	global eva
	if { [eva:config]!="ok" } {
		eva:connexion
	}
}

####################
# Eva Verification #
####################

proc eva:verif { } {
	global eva
	if { [valididx $eva(idx)] } {
		utimer $eva(timerco) eva:verif
	} else {
		if { $eva(counter)<="10" } {
			if { [eva:config]!="ok" } {
				eva:connexion
			}
		} else {
			foreach kill [utimers] {
				if { [lindex $kill 1]=="eva:verif" } { killutimer [lindex $kill 2] }
			}
			if { [info exists eva(idx)] } { unset eva(idx)		}
		}
	}
}

############
# Eva Link #
############
proc remove_modenicklist { data } {
	return [::tcl::string::map -nocase {
		"@" "" "&" "" "+" "" "~" "" "%" ""
	} $data]
}

proc eva:link { idx arg } {
	global eva ceva admins netadmin vhost protect ueva trust UID_DB
	if { $eva(DEBUG) } { putlog "Received:([lindex $arg 1]) $arg" }
	set arg	[split $arg]
	if { $eva(debug)==1 } {
		eva:putdebug "[join [lrange $arg 0 end]]"
	}
	switch -exact [lindex $arg 1] {
		"UID"		{
			set SID				[string range [lindex $arg 0] 1 end]
			set nickname		[lindex $arg 2]
			set nickname2		[string tolower [lindex $arg 2]]
			set hopcount		[lindex $arg 3]
			set timestamp		[lindex $arg 4]
			set username		[lindex $arg 5]
			set hostname		[lindex $arg 6]
			set uid				[lindex $arg 7]
			set servicestamp	[lindex $arg 8]
			set umodes			[lindex $arg 9]
			set virthost		[lindex $arg 10]
			set cloakedhost		[lindex $arg 11]
			set ip				[lindex $arg 12]
			set gecos			[string trim [string tolower [join [lrange $arg 13 end]]] :]

			set UID_DB([string		toupper $nickname])	$uid
			set UID_DB([string		toupper $uid])		$nickname


			set servs		[lindex $arg 6]
			if { ![info exists vhost($nickname2)] } {
				set vhost($nickname2)		$hostname
			}
			if { ![info exists ueva($nickname)] && [string match *+*S* $umodes] } {
				set ueva($nickname)		on
			}
			if { [string match *+*z* $umodes] } {
				set stype		"Connexion SSL"
			} else {
				set stype		"Connexion"
			}
			if { [eva:console 2]=="ok" && $eva(init)==0 } {
				eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)$stype \003$eva(console_deco):\003$eva(console_txt) $nickname2 ($username@$hostname) - (Serveur : $servs)"
			}
			foreach { mask num } [array get trust] {
				if { [string match *$mask* $hostname] } { return 0 }
			}
			if {
				$eva(secu)==1 && \
					$eva(init)==0 && \
					![info exists ueva($nickname)] && \
					![info exists protect($hostname)]
			} {
				if { ![info exists eva(throttle)] } {
					set eva(throttle)		1;
					utimer 2 [list unset eva(throttle)]
				} elseif { $eva(throttle)<$eva(secuco) } {
					incr eva(throttle) 1
				} else {
					if { ![info exists eva(maxthrottle)] } {
						eva:FCT:SENT:NOTICE "$*.*" " $eva(secuon)"
						catch { open "[eva:scriptdir]db/secu.db" r } liste
						while { ![eof $liste] } {
							gets $liste salon;
							if { $salon!="" } {
								eva:sent2socket $eva(idx) ":$eva(server_id) MODE $salon +msi"
							}
						}
						catch { close $liste }
					}
					set eva(maxthrottle)		1
					utimer $eva(secutime) eva:secu
				}
				if { [info exists eva(maxthrottle)] } {
					eva:sent2socket $eva(idx) ":$eva(link) TKL + G * $hostname $eva(SID) [expr [unixtime] + $eva(secutime)] [unixtime] :$eva(secustop)";
					return 0;
				}

			}
			if { ![info exists ueva($nickname)] && ![info exists protect($hostname)] } {
				catch { open [eva:scriptdir]db/host.db r } liste2
				while { ![eof $liste2] } {
					gets $liste2 verif2
					if { [string match *$verif2* $hostname] && $verif2!="" } {
						if { [eva:console 1]=="ok" && $eva(init)==0 } {
							eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Kill \003$eva(console_deco):\003$eva(console_txt) $nickname2 a été killé : $eva(rhost)"
						}
						eva:sent2socket $eva(idx) ":$eva(server_id) KILL $nickname $eva(rhost)";
						break;
						eva:refresh $nickname;
						return 0
					}
				}
				catch { close $liste2 }
				catch { open [eva:scriptdir]db/ident.db r } liste3
				while { ![eof $liste3] } {
					gets $liste3 verif3
					if { [string match *$verif3* $username] && $verif3!="" } {
						if { [eva:console 1]=="ok" && $eva(init)==0 } {
							eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Kill \003$eva(console_deco):\003$eva(console_txt) $nickname2 ($verif3) a été killé : $eva(rident)"
						}
						eva:sent2socket $eva(idx) ":$eva(server_id) KILL $nickname $eva(rident)";
						break ; eva:refresh $nickname;
						return 0;

					}
				}
				catch { close $liste3 }
				catch { open [eva:scriptdir]db/real.db r } liste4
				while { ![eof $liste4] } {
					gets $liste4 verif4
					if { [string match *$verif4* $gecos] && $verif4!="" } {
						if { [eva:console 1]=="ok" && $eva(init)==0 } {
							eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Kill \003$eva(console_deco):\003$eva(console_txt) $nickname2 (Realname: $verif4) a été killé : $eva(rreal)"
						}
						eva:sent2socket $eva(idx) ":$eva(server_id) KILL $nickname $eva(rreal)";
						break; eva:refresh $nickname;
						return 0;

					}
				}
				catch { close $liste4 }
				catch { open [eva:scriptdir]db/nick.db r } liste5
				while { ![eof $liste5] } {
					gets $liste5 verif5
					if { [string match $verif5 $nickname] && $verif5!="" } {
						if { [eva:console 1]=="ok" && $eva(init)==0 } {
							eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Kill \003$eva(console_deco):\003$eva(console_txt) $nickname2 a été killé : $eva(ruser)"
						}
						eva:sent2socket $eva(idx) ":$eva(server_id) KILL $nickname $eva(ruser)";
						break; eva:refresh $nickname;
						return 0;

					}
				}
				catch { close $liste5 }
			}
			if {
				$eva(aclient)==1 && \
					$eva(init)==0 && \
					![info exists ueva($nickname)] && \
					![info exists protect($hostname)]
			} {
				eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $nickname :VERSION"
			}
			if {
				$eva(aclone)==1 && \
					![info exists ueva($nickname)] && \
					![info exists protect($hostname)]
			} {
				set clone		0
				foreach { u h } [array get vhost] {
					if { $h==$hostname } { incr clone 1 }
				}
				if { $clone==$eva(numavert) } {
					eva:FCT:SENT:NOTICE "$nickname" "$eva(ravert)"
				}
				if { $clone==$eva(numclone) } {
					eva:sent2socket $eva(idx) ":$eva(link) TKL + G * $hostname $eva(SID) [expr [unixtime] + $eva(duree)] [unixtime] :$eva(rclone) (Expire le [eva:duree [expr [unixtime] + $eva(duree)]])";
					return 0;
				}

			}
		}
	}
	switch -exact [lindex $arg 0] {
		"PING" {
			set eva(counter)		0
			eva:sent2socket $eva(idx) "PONG [lindex $arg 1]"
		}
		"NETINFO" {
			set eva(netinfo)		[lindex $arg 4]
			set eva(network)		[lindex $arg 8]
			eva:sent2socket $eva(idx) "NETINFO 0 [unixtime] 0 $eva(netinfo) 0 0 0 $eva(network)"
		}
		"SQUIT" {
			set serv		[lindex $arg 1]
			if { [eva:console 2]=="ok" && $eva(init)==0 } {
				eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Unlink \003$eva(console_deco):\003$eva(console_txt) $serv"
			}
		}

	}
	switch -exact [lindex $arg 1] {
		"219" {
			if { ![info exists eva(aff)] && $eva(cmd)=="gline" } {
				eva:FCT:SENT:NOTICE "$eva(rep)" "Aucun Gline"
			}
			if { ![info exists eva(aff)] && $eva(cmd)=="shun" } {
				eva:FCT:SENT:NOTICE "$eva(rep)" "Aucun shun"
			}
			if { ![info exists eva(aff)] && $eva(cmd)=="kline" } {
				eva:FCT:SENT:NOTICE "$eva(rep)" "Aucun Kline"
			}
			if { [info exists eva(cmd)] } { unset eva(cmd)		}
			if { [info exists eva(rep)] } { unset eva(rep)		}
			if { [info exists eva(aff)] } { unset eva(aff)		}
		}
		"223" {
			set host		[lindex $arg 4]
			set auteur		[lindex $arg 7]
			set raison		[join [string trim [lrange $arg 8 end] :]]
			if { $eva(cmd)=="gline" } {
				if { ![info exists eva(aff)] } {
					set eva(aff)		1
					eva:FCT:SENT:NOTICE "$eva(rep)" "\002\0031,1---------------------- \0030Liste des Glines \0031----------------------"
					eva:FCT:SENT:NOTICE "$eva(rep)" "\002"
				}
				eva:FCT:SENT:NOTICE "$eva(rep)" "Host \[\00303 $host \00301\] | Auteur \[\00303 $auteur \00301\] | Raison \[\00303 $raison \00301\]"
			} elseif { $eva(cmd)=="shun" } {
				if { ![info exists eva(aff)] } {
					set eva(aff)		1
					eva:FCT:SENT:NOTICE "$eva(rep)" "\002\0031,1---------------------- \0030Liste des Shuns \0031----------------------"
					eva:FCT:SENT:NOTICE "$eva(rep)" "\002"
				}
				eva:FCT:SENT:NOTICE "$eva(rep)" "Host \[\00303 $host \00301\] | Auteur \[\00303 $auteur \00301\] | Raison \[\00303 $raison \00301\]"
			} elseif { $eva(cmd)=="kline" } {
				if { ![info exists eva(aff)] } {
					set eva(aff)		1
					eva:FCT:SENT:NOTICE "$eva(rep)" "\002\0031,1---------------------- \0030Liste des Klines \0031----------------------"
					eva:FCT:SENT:NOTICE "$eva(rep)" "\002"
				}
				eva:FCT:SENT:NOTICE "$eva(rep)" "Host \[\00303 $host \00301\] | Auteur \[\00303 $auteur \00301\] | Raison \[\00303 $raison \00301\]"
			} elseif { $eva(cmd)=="cleargline" } {
				eva:sent2socket $eva(idx) ":$eva(link) TKL - G [lindex [split $host @] 0] [lindex [split $host @] 1] $eva(SID)"
			} elseif { $eva(cmd)=="clearkline" } {
				eva:sent2socket $eva(idx) ":$eva(link) TKL - k [lindex [split $host @] 0] [lindex [split $host @] 1] $eva(SID)"
			}
		}
		"307" {
			eva:FCT:SENT:NOTICE "$eva(rep)" "\00301 \[\00303 NickServ \00301\] \00302 Oui"
		}
		"310" {
			eva:FCT:SENT:NOTICE "$eva(rep)" "\00301 \[\00303 Helpeur \00301\] \00302 Oui"
		}
		"311" {
			set nick		[lindex $arg 3]
			set ident		[lindex $arg 4]
			set host		[lindex $arg 5]
			set real		[join [string trim [lrange $arg 7 end] :]]
			eva:FCT:SENT:NOTICE "$eva(rep)" "\002\0031,1------------------------------ \0030Whois \0031------------------------------"
			eva:FCT:SENT:NOTICE "$eva(rep)" "\002"
			eva:FCT:SENT:NOTICE "$eva(rep)" "\00301 \[\00303 Pseudo \00301\] \00302 $nick"
			eva:FCT:SENT:NOTICE "$eva(rep)" "\00301 \[\00303 Nom Réel \00301\] \00302 $real"
			eva:FCT:SENT:NOTICE "$eva(rep)" "\00301 \[\00303 Host \00301\] \00302 $ident@$host"
		}
		"312" {
			set serveur		[lindex $arg 4]
			set desc		[join [string trim [lrange $arg 5 end] :]]
			eva:FCT:SENT:NOTICE "$eva(rep)" "\00301 \[\00303 Serveur \00301\] \00302 $serveur ($desc)"
		}
		"313" {
			set grade		[join [lrange $arg 6 end]]
			eva:FCT:SENT:NOTICE "$eva(rep)" "\00301 \[\00303 Grade \00301\] \00302 $grade"
		}
		"317" {
			set idle		[lindex $arg 4]
			eva:FCT:SENT:NOTICE "$eva(rep)" "\00301 \[\00303 Idle \00301\] \00302 [duration $idle]"
		}
		"318" {
			if { [info exists eva(rep)] } { unset eva(rep)		}
		}
		"319" {
			set salon		[join [string trim [lrange $arg 4 end] :]]
			eva:FCT:SENT:NOTICE "$eva(rep)" "\00301 \[\00303 Salon \00301\] \00302 $salon"
		}
		"320" {
			set swhois		[join [string trim [lrange $arg 4 end] :]]
			eva:FCT:SENT:NOTICE "$eva(rep)" "\00301 \[\00303 Swhois \00301\] \00302 $swhois"
		}
		"324" {
			set chan		[lindex $arg 3]
			set mode		[join [string trimleft [lrange $arg 4 end] +]]
			eva:sent2socket $eva(idx) ":$eva(server_id) MODE $chan -$mode"
		}
		"335" {
			eva:FCT:SENT:NOTICE "$eva(rep)" "\00301 \[\00303 Robot \00301\] \00302 Oui"
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
				if { $eva(cmd)=="ownerall" && \
					![info exists ueva($n)] && \
						$n!=[string tolower $eva(SID)] && \
						![info exists admins($n)] && \
						[eva:protection $n $eva(protection)]!="ok"
				} {
				eva:sent2socket $eva(idx) ":$eva(server_id) MODE $chan +q $n"
			} elseif {
				$eva(cmd)=="deownerall" && \
					![info exists ueva($n)] && \
					$n!=[string tolower $eva(SID)] && \
					![info exists admins($n)] && \
					[eva:protection $n $eva(protection)]!="ok"
			} {
				eva:sent2socket $eva(idx) ":$eva(server_id) MODE $chan -q $n"
			} elseif {
				$eva(cmd)=="protectall" && \
					![info exists ueva($n)] && \
					$n!=[string tolower $eva(SID)] && \
					![info exists admins($n)] && \
					[eva:protection $n $eva(protection)]!="ok"
			} {
				eva:sent2socket $eva(idx) ":$eva(server_id) MODE $chan +a $n"
			} elseif {
				$eva(cmd)=="deprotectall" && \
					![info exists ueva($n)] && \
					$n!=[string tolower $eva(SID)] && \
					![info exists admins($n)] && \
					[eva:protection $n $eva(protection)]!="ok"
			} {
				eva:sent2socket $eva(idx) ":$eva(server_id) MODE $chan -a $n"
			} elseif {
				$eva(cmd)=="opall" && \
					![info exists ueva($n)] && \
					$n!=[string tolower $eva(SID)] && \
					![info exists admins($n)] && \
					[eva:protection $n $eva(protection)]!="ok"
			} {
				eva:sent2socket $eva(idx) ":$eva(server_id) MODE $chan +o $n"
			} elseif {
				$eva(cmd)=="deopall" && \
					![info exists ueva($n)] && \
					$n!=[string tolower $eva(SID)] && \
					![info exists admins($n)] && \
					[eva:protection $n $eva(protection)]!="ok"
			} {
				eva:sent2socket $eva(idx) ":$eva(server_id) MODE $chan -o $n"
			} elseif {
				$eva(cmd)=="halfopall" && \
					![info exists ueva($n)] && \
					$n!=[string tolower $eva(SID)] && \
					![info exists admins($n)] && \
					[eva:protection $n $eva(protection)]!="ok"
			} {
				eva:sent2socket $eva(idx) ":$eva(server_id) MODE $chan +h $n"
			} elseif {
				$eva(cmd)=="dehalfopall" && \
					![info exists ueva($n)] && \
					$n!=[string tolower $eva(SID)] && \
					![info exists admins($n)] && \
					[eva:protection $n $eva(protection)]!="ok"
			} {
				eva:sent2socket $eva(idx) ":$eva(server_id) MODE $chan -h $n"
			} elseif {
				$eva(cmd)=="voiceall" && \
					![info exists ueva($n)] && \
					$n!=[string tolower $eva(SID)] && \
					![info exists admins($n)] && \
					[eva:protection $n $eva(protection)]!="ok"
			} {
				eva:sent2socket $eva(idx) ":$eva(server_id) MODE $chan +v $n"
			} elseif {
				$eva(cmd)=="devoiceall" && \
					![info exists ueva($n)] && \
					$n!=[string tolower $eva(SID)] && \
					![info exists admins($n)] && \
					[eva:protection $n $eva(protection)]!="ok"
			} {
				eva:sent2socket $eva(idx) ":$eva(server_id) MODE $chan -v $n"
			} elseif {
				$eva(cmd)=="kickall" && \
					![info exists ueva($n)] && \
					$n!=[string tolower $eva(SID)] && \
					![info exists admins($n)] && \
					[eva:protection $n $eva(protection)]!="ok"
			} {

				eva:sent2socket $eva(idx) ":$eva(server_id) KICK $chan $n Kicked [eva:rnick $eva(rep)]"
			} elseif {
				$eva(cmd)=="chankill" && \
					![info exists ueva($n)] && \
					$n!=[string tolower $eva(SID)] && \
					![info exists admins($n)] && \
					[eva:protection $n $eva(protection)]!="ok" && [eva:protection $n $eva(protection)]!="ok"
			} {
				eva:sent2socket $eva(idx) ":$eva(server_id) KILL $n Chan Killed [eva:rnick $eva(rep)]"; eva:refresh $n
			} elseif {
				$eva(cmd)=="changline" && \
					![info exists ueva($n)] && \
					$n!=[string tolower $eva(SID)] && \
					![info exists admins($n)] && \
					[eva:protection $n $eva(protection)]!="ok" && [eva:protection $n $eva(protection)]!="ok"
			} {
				eva:sent2socket $eva(idx) ":$eva(link) TKL + G * $vhost($n) $eva(SID) [expr [unixtime] + $eva(duree)] [unixtime] :Chan Glined [eva:rnick $eva(rep)] (Expire le [eva:duree [expr [unixtime] + $eva(duree)]])"
			} elseif {
				$eva(cmd)=="badchan" && \
					![info exists ueva($n)] && \
					$n!=[string tolower $eva(SID)] && \
					![info exists admins($n)] && \
					[eva:protection $n $eva(protection)]!="ok"
			} {
				eva:sent2socket $eva(idx) ":$eva(server_id) KICK $chan $n Salon Interdit"
			} elseif {
				$eva(cmd)=="close" && \
					![info exists ueva($n)] && \
					$n!=[string tolower $eva(SID)] && \
					![info exists admins($n)] && \
					[eva:protection $n $eva(protection)]!="ok"
			} {
				if { [info exists eva(rep)] } {
					eva:sent2socket $eva(idx) ":$eva(server_id) KICK $chan $n Closed [eva:rnick $eva(rep)]"
				} else {
					eva:sent2socket $eva(idx) ":$eva(server_id) KICK $chan $n Closed"
				}

			}
		}
	}
	"364" {
		set serv		[lindex $arg 3]
		set desc		[join [lrange $arg 6 end]]
		if { ![info exists eva(aff)] } {
			set eva(aff)		1
			eva:FCT:SENT:NOTICE "$eva(rep)" "\002\0031,1--------------------------------- \0030Map du Réseau \0031---------------------------------"
			eva:FCT:SENT:NOTICE "$eva(rep)" "\002"
		}
		eva:FCT:SENT:NOTICE "$eva(rep)" "\00301Serveur \[\00304 $serv \00301\] \003 Description \[\00303 $desc \00301\]"
	}
	"365" {
		if { [info exists eva(aff)] } { unset eva(aff)		}
		if { [info exists eva(rep)] } { unset eva(rep)		}
	}
	"378" {
		set host		[lindex $arg 7]
		set ip		[lindex $arg 8]
		eva:FCT:SENT:NOTICE "$eva(rep)" "\00301 \[\00303 Host Décodé \00301\] \00302 $host"
		if { [info exists $ip] } {
			eva:FCT:SENT:NOTICE "$eva(rep)" "\00301 \[\00303 Ip \00301\] \00302 $ip"
		}
	}
	"671" {
		eva:FCT:SENT:NOTICE "$eva(rep)" "\00301 \[\00303 SSL \00301\] \00302 Oui"
	}
	"SERVER" {
		set serv		[lindex $arg 2]
		set desc		[join [string trim [lrange $arg 4 end] :]]
		if { [eva:console 2]=="ok" && $eva(init)==0 } {
			eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Link \003$eva(console_deco):\003$eva(console_txt) $serv : $desc"
		}
	}
	"NOTICE" {
		set user		[string trim [lindex $arg 0] :]
		set vuser		[string tolower [string trim [lindex $arg 0] :]]
		set version		[string trim [lindex $arg 3] :]
		set vdata		[string tolower [join [lrange $arg 3 end]]]
		if { [eva:flood $vuser]!="ok" } { return 0 }
		if { $eva(aclient)==1 && $version=="VERSION" } {
			catch { open [eva:scriptdir]db/client.db r } vcli
			while { ![eof $vcli] } {
				gets $vcli verscli
				if { [string match *$verscli* $vdata] && $verscli!="" } {
					if { [eva:console 3]=="ok" && $eva(init)==0 } {
						eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Kill \003$eva(console_deco):\003$eva(console_txt) $user a été killé : $eva(rclient)"
					}
					eva:sent2socket $eva(idx) ":$eva(server_id) KILL $vuser $eva(rclient)"; eva:refresh $vuser
					break
				}
			}
			catch { close $vcli }
		}
	}
	"PRIVMSG" {
		set USER_TMP	[string trim [lindex $arg 0] :]
		# si user est en format : 001119S0G alors c un UID
		if { [string range $USER_TMP 0 0] == 0 } {
			set userUID		$USER_TMP
			set user		[eva:UID:CONVERT $USER_TMP]

		} else {
			set userUID		[eva:UID:CONVERT $USER_TMP]
			set user		$USER_TMP
		}
		set user		[eva:UID:CONVERT $userUID]
		set vuserUID	[string tolower $user]
		set vuser		[eva:UID:CONVERT $vuserUID]
		set robotUID	[string tolower [lindex $arg 2]]
		set cmds		[string tolower [string trim [lindex $arg 3] :]]
		set hcmds		[string tolower [lindex $arg 4]]
		set pcmds		[string trim $cmds $eva(prefix)]
		set data		[join [lrange $arg 4 end]]
		if { [string toupper $robotUID] == [eva:UID:CONVERT $eva(pseudo)] } {
			if { [eva:flood $vuser] != "ok" } { return 0 }

			if { $cmds=="ping" } {
				eva:FCT:SENT:NOTICE "$user" "\001PING [clock seconds]\001";
				return 0;


			} elseif { $cmds=="version" } {
				eva:FCT:SENT:NOTICE "$user" "\00301Eva Service $eva(version) by TiSmA\00303©";
				return 0;


				# verifie si c une command eva :

			} elseif { [info exists ceva($cmds)] } {

				# si c help
				if { $cmds=="help" && $hcmds!="" } {

					# verifie si c une command eva
					if { [info exists ceva($hcmds)] } {
						eva:hcmds "$hcmds $user $data"
					} else {
						eva:FCT:SENT:NOTICE "$user" "Aide \002$hcmds\002 Inconnue."
					}
				} else {
					eva:cmds "$cmds $user $data"
				}
			} else {
				eva:FCT:SENT:NOTICE "$user" "Commande \002$cmds\002 Inconnue."
			}
		}
		if { [string index $cmds 0] == $eva(prefix) } {
			if { [eva:flood $vuser]!="ok" } { return 0 }
			if { [info exists ceva($pcmds)] } {
				if { $pcmds=="help" && $hcmds!="" } {
					if { [info exists ceva($hcmds)] } {
						eva:hcmds "$hcmds $user $data"
					}
				} else {
					eva:cmds "$pcmds $user $data"
				}
			}
		}
	}
	"MODE" {
		set user		[string trim [lindex $arg 0] :]
		set chan		[lindex $arg 2]
		set vchan		[string tolower [lindex $arg 2]]
		set umode		[lindex $arg 3]
		set pmode		[join [lrange $arg 4 end]]
		set unix		[lindex $arg end]
		if {
			[eva:console 3]=="ok" && \
				$vchan!=[string tolower $eva(salon)] && \
				$eva(init)==0 && \
				[string tolower $user]!=[string tolower $eva(SID)]
		} {
			if {[regexp "^\[0-9\]\{10\}" $unix]} {
				set smode		[string trim $pmode $unix]
				eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Mode \003$eva(console_deco):\003$eva(console_txt) $user applique le mode $umode $smode sur $chan"
			} else {
				eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Mode \003$eva(console_deco):\003$eva(console_txt) $user applique le mode $umode $pmode sur $chan"
			}
		}
	}
	"UMODE2" {
		set user		[string tolower [string trim [lindex $arg 0] :]]
		set user2		[string trim [lindex $arg 0] :]
		set umode		[lindex $arg 2]
		if { ![info exists ueva($user)] && [string match *+*S* $umode] } { set ueva($user)		on }
		if { ![info exists netadmin($user)] && [string match *+*N* $umode] } { set netadmin($user)		on }
		if { [info exists netadmin($user)] && [string match *-*N* $umode] } { unset netadmin($user)		}
		if { [eva:console 3]=="ok" && $eva(init)==0 } {
			if { [string match *+*S* $umode] } {
				eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Usermode \003$eva(console_deco):\003$eva(console_txt) $user2 est un Service Réseau"
			} elseif { [string match *-*S* $umode] } {
				eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Usermode \003$eva(console_deco):\003$eva(console_txt) $user2 n'est plus un Service Réseau"
			} elseif { [string match *+*N* $umode] } {
				eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Usermode \003$eva(console_deco):\003$eva(console_txt) $user2 est un Administrateur Réseau"
			} elseif { [string match *-*N* $umode] } {
				eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Usermode \003$eva(console_deco):\003$eva(console_txt) $user2 n'est plus un Administrateur Réseau"
			} elseif { [string match *+*A* $umode] } {
				eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Usermode \003$eva(console_deco):\003$eva(console_txt) $user2 est un Administrateur Serveur"
			} elseif { [string match *-*A* $umode] } {
				eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Usermode \003$eva(console_deco):\003$eva(console_txt) $user2 n'est plus un Administrateur Serveur"
			} elseif { [string match *+*a* $umode] } {
				eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Usermode \003$eva(console_deco):\003$eva(console_txt) $user2 est un Administrateur Services"
			} elseif { [string match *-*a* $umode] } {
				eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Usermode \003$eva(console_deco):\003$eva(console_txt) $user2 n'est plus un Administrateur Services"
			} elseif { [string match *+*C* $umode] } {
				eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Usermode \003$eva(console_deco):\003$eva(console_txt) $user2 est un Co-Administrateur"
			} elseif { [string match *-*C* $umode] } {
				eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Usermode \003$eva(console_deco):\003$eva(console_txt) $user2 n'est plus un Co-Administrateur"
			} elseif { [string match *+*o* $umode] } {
				eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Usermode \003$eva(console_deco):\003$eva(console_txt) $user2 est un IRC Opérateur Global"
			} elseif { [string match *-*o* $umode] } {
				eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Usermode \003$eva(console_deco):\003$eva(console_txt) $user2 n'est plus un IRC Opérateur Global"
			} elseif { [string match *+*O* $umode] } {
				eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Usermode \003$eva(console_deco):\003$eva(console_txt) $user2 est un IRC Opérateur Local"
			} elseif { [string match *-*O* $umode] } {
				eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Usermode \003$eva(console_deco):\003$eva(console_txt) $user2 n'est plus un IRC Opérateur Local"
			} elseif { [string match *+*h* $umode] } {
				eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Usermode \003$eva(console_deco):\003$eva(console_txt) $user2 est un Helpeur"
			} elseif { [string match *-*h* $umode] } {
				eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Usermode \003$eva(console_deco):\003$eva(console_txt) $user2 n'est plus un Helpeur"
			}
		}
	}
	"NICK" {
		set user		[string trim [lindex $arg 0] :]
		set new		[lindex $arg 2]
		set vuser		[string tolower [string trim [lindex $arg 0] :]]
		set vnew		[string tolower [lindex $arg 2]]
		if { [info exists ueva($vuser)] && $vuser!=$vnew } { set ueva($vnew)		on; unset ueva($vuser)		}
		if { [info exists vhost($vuser)] && $vuser!=$vnew } { set vhost($vnew)		$vhost($vuser); unset vhost($vuser)		}
		if { [info exists admins($vuser)] && $vuser!=$vnew } { set admins($vnew)		$admins($vuser); unset admins($vuser)		}
		if { [info exists netadmin($vuser)] && $vuser!=$vnew } { set netadmin($vnew)		on; unset netadmin($vuser)		}
		if { [eva:console 3]=="ok" && $eva(init)==0 } {
			eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Nick \003$eva(console_deco):\003$eva(console_txt) $user change son pseudo en $new"
		}
		if {
			![info exists ueva($vnew)] && \
				![info exists admins($vnew)] && \
				[eva:protection $vnew $eva(protection)]!="ok"
		} {
			catch { open [eva:scriptdir]db/nick.db r } liste
			while { ![eof $liste] } {
				gets $liste verif
				if { [string match $verif $vnew] && $verif!="" } {
					if { [eva:console 3]=="ok" && $eva(init)==0 } {
						eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Kill \003$eva(console_deco):\003$eva(console_txt) $new a été killé : $eva(ruser)"
					}
					eva:sent2socket $eva(idx) ":$eva(server_id) KILL $vnew $eva(ruser)";
					break; eva:refresh $vnew
				}
			}
			catch { close $liste }
		}
	}
	"TOPIC" {
		set user		[string trim [lindex $arg 0] :]
		set chan		[lindex $arg 2]
		set vchan		[string tolower $chan]
		set topic		[join [string trim [lrange $arg 5 end] :]]
		if {
			[eva:console 3]=="ok" && \
				$vchan!=[string tolower $eva(salon)] && \
				$eva(init)==0
		} {
			eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Topic \003$eva(console_deco):\003$eva(console_txt) $user change le topic sur $chan : $topic\003"
		}
	}
	"KICK" {
		set user		[string trim [lindex $arg 0] :]
		set pseudo		[lindex $arg 3]
		set chan		[lindex $arg 2]
		set vchan		[string tolower [lindex $arg 2]]
		set raison		[join [string trim [lrange $arg 4 end] :]]
		if {
			[eva:console 3]=="ok" && \
				$vchan!=[string tolower $eva(salon)] && \
				$eva(init)==0
		} {
			eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Kick \003$eva(console_deco):\003$eva(console_txt) $pseudo a été kické par $user sur $chan : $raison\003"
		}
	}
	"KILL" {
		set pseudo		[lindex $arg 2]
		set vpseudo		[string tolower [lindex $arg 2]]
		set text		[join [string trim [lrange $arg 2 end] :]]
		eva:refresh $vpseudo
		if { [eva:console 1]=="ok" && $eva(init)==0 } {
			eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Kill \003$eva(console_deco):\003$eva(console_txt) $pseudo : $text\003"
		}
		if { $vpseudo==[string tolower $eva(SID)] } {
			eva:gestion; eva:sent2socket $eva(idx) ":$eva(link) SQUIT $eva(link) :$eva(raison)"
			foreach kill [utimers] {
				if { [lindex $kill 1]=="eva:verif" } { killutimer [lindex $kill 2] }
			}
			if { [info exists eva(idx)] } { unset eva(idx)		}
			set eva(counter)		0;
			if { [eva:config]!="ok" } { utimer 1 eva:connexion
		}
	}
}
"GLOBOPS" {
	set user		[string trim [lindex $arg 0] :]
	set vuser		[string tolower [string trim [lindex $arg 0] :]]
	set text		[join [string trim [lrange $arg 2 end] :]]
	if {
		[eva:console 3]=="ok" && \
			$eva(init)==0 && \
			![info exists ueva($vuser)]
	} {
		eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Globops \003$eva(console_deco):\003$eva(console_txt) $user : $text\003"
	}
}
"CHGIDENT" {
	set user		[string trim [lindex $arg 0] :]
	set pseudo		[lindex $arg 2]
	set ident		[lindex $arg 3]
	if { [eva:console 3]=="ok" && $eva(init)==0 } {
		eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Chgident \003$eva(console_deco):\003$eva(console_txt) $user change l'ident de $pseudo en $ident"
	}
}
"CHGHOST" {
	set user		[string trim [lindex $arg 0] :]
	set pseudo		[lindex $arg 2]
	set host		[lindex $arg 3]
	if { [eva:console 3]=="ok" && $eva(init)==0 } {
		eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Chghost \003$eva(console_deco):\003$eva(console_txt) $user change l'host de $pseudo en $host"
	}
}
"CHGNAME" {
	set user		[string trim [lindex $arg 0] :]
	set pseudo		[lindex $arg 2]
	set real		[join [string trim [lrange $arg 3 end] :]]
	if { [eva:console 3]=="ok" && $eva(init)==0 } {
		eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Chgname \003$eva(console_deco):\003$eva(console_txt) $user change le realname de $pseudo en $real"
	}
}
"SETHOST" {
	set user		[string trim [lindex $arg 0] :]
	set host		[lindex $arg 2]
	if { [eva:console 3]=="ok" && $eva(init)==0 } {
		eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Sethost \003$eva(console_deco):\003$eva(console_txt) Changement de l'host de $user en $host"
	}
}
"SETIDENT" {
	set user		[string trim [lindex $arg 0] :]
	set ident		[lindex $arg 2]
	if { [eva:console 3]=="ok" && $eva(init)==0 } {
		eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Setident \003$eva(console_deco):\003$eva(console_txt) Changement de l'ident de $user en $ident"
	}
}
"SETNAME" {
	set user		[string trim [lindex $arg 0] :]
	set real		[join [string trim [lrange $arg 2 end] :]]
	if { [eva:console 3]=="ok" && $eva(init)==0 } {
		eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Setname \003$eva(console_deco):\003$eva(console_txt) Changement du realname de $user en $real"
	}
}
"JOIN" {
	set user		[string trim [lindex $arg 0] :]
	set vuser		[string tolower $user]
	set chan		[string trim [lindex $arg 2] :]
	set vchan		[string tolower $chan]
	if {
		[eva:console 3]=="ok" && \
			$vchan!=[string tolower $eva(salon)] && \
			$eva(init)==0 } {
				eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Join \003$eva(console_deco):\003$eva(console_txt) $user entre sur $chan"
		}
		catch { open "[eva:scriptdir]db/salon.db" r } liste
		while { ![eof $liste] } {
			gets $liste verif
			if {
				$verif!="" && \
					[string match *[string trimleft $verif #]* [string trimleft $vchan #]] && \
					$vuser!=[string tolower $eva(SID)] && \
					![info exists ueva($vuser)] && \
					![info exists admins($vuser)] && \
					[eva:protection $vuser $eva(protection)]!="ok"
			} {
				set eva(cmd)		"badchan"; eva:sent2socket $eva(idx) ":$eva(server_id) JOIN $vchan"; eva:sent2socket $eva(idx) ":$eva(server_id) MODE $vchan +ntsio $eva(SID)"
				eva:sent2socket $eva(idx) ":$eva(server_id) TOPIC $vchan :\0031Salon Interdit le [eva:duree [unixtime]]"; eva:sent2socket $eva(idx) ":$eva(link) NAMES $vchan"
				if { [eva:console 3]=="ok" && $eva(init)==0 } {
					eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Part \003$eva(console_deco):\003$eva(console_txt) $user part de $chan : Salon Interdit"
					};
					break
				}
			}
			catch { close $liste }
		}
		"PART" {
			set user		[string trim [lindex $arg 0] :]
			set chan		[string trim [lindex $arg 2] :]
			set vchan		[string tolower $chan]
			if {
				[eva:console 3]=="ok" && \
					$vchan!=[string tolower $eva(salon)] && \
					$eva(init)==0
			} {
				eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Part \003$eva(console_deco):\003$eva(console_txt) $user part de $chan"
			}
		}
		"QUIT" {
			set user		[string trim [lindex $arg 0] :]
			set vuser		[string tolower [string trim [lindex $arg 0] :]]
			set text		[join [string trim [lrange $arg 2 end] :]]
			eva:refresh $vuser
			if { [eva:console 2]=="ok" && $eva(init)==0 } {
				if { $text!="" } {
					eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Déconnexion \003$eva(console_deco):\003$eva(console_txt) $user a quitté l'IRC : $text"
				} else {
					eva:sent2socket $eva(idx) ":$eva(server_id) PRIVMSG $eva(salon) :\003$eva(console_com)Déconnexion \003$eva(console_deco):\003$eva(console_txt) $user a quitté l'IRC"
				}
			}
		}
	}
}
