######################################
##           ____                   ##
##          |  __|_ _ ___           ##
##          |  __| | | .'|          ##
##          |____|\_/|__,|          ##
##                                  ##
##         Auteur : TiSmA           ##
##         Email : TiSmA@eXolia.fr  ##
##         Licence : GNU / GPL      ##
##                                  ##
######################################

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

set eva(path) "[file dirname [info script]]/"
proc eva:scriptdir {} { global eva; return $eva(path) }
source [eva:scriptdir]Eva.conf

###############
# Eva Fichier #
###############

if {![file exists "[eva:scriptdir]db/gestion.db"]} { set c_gestion [open "[eva:scriptdir]db/gestion.db" a+]; close $c_gestion }
if {![file exists "[eva:scriptdir]db/chan.db"]} { set c_chan [open "[eva:scriptdir]db/chan.db" a+]; close $c_chan }
if {![file exists "[eva:scriptdir]db/client.db"]} { set c_client [open "[eva:scriptdir]db/client.db" a+]; close $c_client }
if {![file exists "[eva:scriptdir]db/secu.db"]} { set c_secu [open "[eva:scriptdir]db/secu.db" a+]; close $c_secu }
if {![file exists "[eva:scriptdir]db/close.db"]} { set c_close [open "[eva:scriptdir]db/close.db" a+]; close $c_close }
if {![file exists "[eva:scriptdir]db/salon.db"]} { set c_salon [open "[eva:scriptdir]db/salon.db" a+]; close $c_salon }
if {![file exists "[eva:scriptdir]db/ident.db"]} { set c_ident [open "[eva:scriptdir]db/ident.db" a+]; close $c_ident }
if {![file exists "[eva:scriptdir]db/real.db"]} { set c_real [open "[eva:scriptdir]db/real.db" a+]; close $c_real }
if {![file exists "[eva:scriptdir]db/host.db"]} { set c_host [open "[eva:scriptdir]db/host.db" a+]; close $c_host }
if {![file exists "[eva:scriptdir]db/nick.db"]} { set c_nick [open "[eva:scriptdir]db/nick.db" a+]; close $c_nick }
if {![file exists "[eva:scriptdir]db/trust.db"]} { set c_trust [open "[eva:scriptdir]db/trust.db" a+]; close $c_trust }

#################
# Eva Commandes #
#################

set ceva(auth)          "0"
set ceva(deauth)        "0"
set ceva(copyright)     "0"
set ceva(help)          "0"
set ceva(showcommands)  "0"
set ceva(seen)          "0"
set ceva(access)        "2"
set ceva(map)           "1"
set ceva(whois)         "1"
set ceva(newpass)       "2"
set ceva(owner)         "2"
set ceva(deowner)       "2"
set ceva(protect)       "2"
set ceva(deprotect)     "2"
set ceva(ownerall)      "2"
set ceva(deownerall)    "2"
set ceva(protectall)    "2"
set ceva(deprotectall)  "2"
set ceva(op)            "2"
set ceva(deop)          "2"
set ceva(halfop)        "2"
set ceva(dehalfop)      "2"
set ceva(voice)         "2"
set ceva(devoice)       "2"
set ceva(opall)         "2"
set ceva(deopall)       "2"
set ceva(halfopall)     "2"
set ceva(dehalfopall)   "2"
set ceva(voiceall)      "2"
set ceva(devoiceall)    "2"
set ceva(kick)          "2"
set ceva(kickall)       "2"
set ceva(ban)           "2"
set ceva(nickban)       "2"
set ceva(kickban)       "2"
set ceva(unban)         "2"
set ceva(clearbans)     "2"
set ceva(kill)          "2"
set ceva(mode)          "2"
set ceva(clearmodes)    "2"
set ceva(clearallmodes) "2"
set ceva(topic)         "2"
set ceva(inviteme)      "2"
set ceva(invite)        "2"
set ceva(wallops)       "2"
set ceva(globops)       "2"
set ceva(gline)         "2"
set ceva(ungline)       "2"
set ceva(shun)         "2"
set ceva(unshun)         "2"
set ceva(shunlist)         "2"
set ceva(glinelist)     "2"
set ceva(kline)         "2"
set ceva(unkline)       "2"
set ceva(klinelist)     "2"
set ceva(clientlist)    "3"
set ceva(trustlist)     "3"
set ceva(say)           "3"
set ceva(svsnick)       "3"
set ceva(svsjoin)       "3"
set ceva(svspart)       "3"
set ceva(notice)        "3"
set ceva(clearkline)    "3"
set ceva(cleargline)    "3"
set ceva(changline)     "3"
set ceva(chankill)      "3"
set ceva(join)          "3"
set ceva(part)          "3"
set ceva(list)          "3"
set ceva(status)        "3"
set ceva(close)         "3"
set ceva(unclose)       "3"
set ceva(closelist)     "3"
set ceva(clearclose)    "3"
set ceva(nicklist)      "3"
set ceva(identlist)     "3"
set ceva(reallist)      "3"
set ceva(hostlist)      "3"
set ceva(chanlist)      "3"
set ceva(seculist)      "3"
set ceva(addnick)       "4"
set ceva(delnick)       "4"
set ceva(addident)      "4"
set ceva(delident)      "4"
set ceva(addreal)       "4"
set ceva(delreal)       "4"
set ceva(addhost)       "4"
set ceva(delhost)       "4"
set ceva(addchan)       "4"
set ceva(delchan)       "4"
set ceva(addsecu)       "4"
set ceva(delsecu)       "4"
set ceva(secu)          "4"
set ceva(addtrust)      "4"
set ceva(deltrust)      "4"
set ceva(addclient)     "4"
set ceva(delclient)     "4"
set ceva(client)        "4"
set ceva(clone)         "4"
set ceva(chanlog)       "4"
set ceva(console)       "4"
set ceva(backup)        "4"
set ceva(restart)       "4"
set ceva(die)           "4"
set ceva(maxlogin)      "4"
set ceva(protection)    "4"
set ceva(addaccess)     "4"
set ceva(delaccess)     "4"
set ceva(modaccess)     "4"

#################
# Eva Variables #
#################

set eva(version)    "1.2-rc1"
set eva(timerco)    "30"
set eva(timerdem)   "5"
set eva(timerinit)  "10"
set eva(counter)    "0"
set eva(dem)        "0"
set eva(init)       "0"
set eva(console)    "1"
set eva(login)      "1"
set eva(protection) "1"
set eva(debug)      "0"
set eva(aclone)     "0"
set eva(aclient)    "0"
set eva(secu)       "0"

##############
# Eva Config #
##############

proc eva:config {} {
	global eva
	if {![info exists eva(link)] || ![info exists eva(ip)] || ![info exists eva(port)] || ![info exists eva(pass)] || ![info exists eva(info)] || ![info exists eva(pseudo)] || ![info exists eva(ident)] || ![info exists eva(host)] || ![info exists eva(real)] || ![info exists eva(salon)] || ![info exists eva(smode)] || ![info exists eva(cmode)] || ![info exists eva(secuco)] || ![info exists eva(secutime)] || ![info exists eva(secuon)] || ![info exists eva(secuoff)] || ![info exists eva(secustop)] || ![info exists eva(numavert)] || ![info exists eva(numclone)] || ![info exists eva(rhost)] || ![info exists eva(rident)] || ![info exists eva(rreal)] || ![info exists eva(ruser)] || ![info exists eva(ravert)] || ![info exists eva(rclone)] || ![info exists eva(prefix)] || ![info exists eva(rnick)] || ![info exists eva(fraz)] || ![info exists eva(duree)] || ![info exists eva(ignore)] || ![info exists eva(rclient)] || ![info exists eva(raison)] || ![info exists eva(console_com)] || ![info exists eva(console_deco)] || ![info exists eva(console_txt)]} {
		return ok
	} elseif {$eva(link)=="" || $eva(ip)=="" || $eva(port)=="" || $eva(pass)=="" || $eva(info)=="" || $eva(pseudo)=="" || $eva(ident)=="" || $eva(host)=="" || $eva(real)=="" || $eva(salon)=="" || $eva(smode)=="" || $eva(cmode)=="" || $eva(secuco)=="" || $eva(secutime)=="" || $eva(secuon)=="" || $eva(secuoff)=="" || $eva(secustop)=="" || $eva(numavert)=="" || $eva(numclone)==""  || $eva(ravert)=="" || $eva(rclone)=="" || $eva(prefix)=="" || $eva(rnick)=="" || $eva(fraz)=="" || $eva(duree)=="" || $eva(ignore)=="" || $eva(rclient)=="" || $eva(raison)=="" || $eva(rhost)=="" || $eva(rident)=="" || $eva(rreal)=="" || $eva(ruser)=="" || $eva(console_com)=="" || $eva(console_deco)=="" || $eva(console_txt)==""} {
		return ok
	}
}

################
# Eva Putdebug #
################

proc eva:putdebug {string} {
	set deb [open logs/Eva.debug a]
	puts $deb "[clock format [clock seconds] -format "\[%H:%M\]"] $string"
	close $deb
}

###############
# Eva Refresh #
###############

proc eva:refresh {pseudo} {
	global netadmin admins vhost protect ueva
	set vuser [string tolower $pseudo]
	if {[info exists vhost($vuser)]} {
		if {[info exists protect($vhost($vuser))] && [info exists admins($vuser)]} { unset protect($vhost($vuser)) }
		unset vhost($vuser)
	}
	if {[info exists ueva($vuser)]} { unset ueva($vuser) }
	if {[info exists netadmin($vuser)]} { unset netadmin($vuser) }
	if {[info exists admins($vuser)]} { unset admins($vuser) }
}

###############
# Eva Gestion #
###############

proc eva:gestion {} {
	global eva
	set sv [open [eva:scriptdir]db/gestion.db w+]
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

proc eva:dbback {min h d m y} {
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
	if {[eva:console 1]=="ok"} { putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Backup $eva(console_deco):$eva(console_txt) Sauvegarde des databases." }
}

#############
# Eva Duree #
#############

proc eva:duree {temps} {
	switch -exact [lindex [ctime $temps] 1] {
		"Jan" { set mois "01" }
		"Feb" { set mois "02" }
		"Mar" { set mois "03" }
		"Apr" { set mois "04" }
		"May" { set mois "05" }
		"Jun" { set mois "06" }
		"Jul" { set mois "07" }
		"Aug" { set mois "08" }
		"Sep" { set mois "09" }
		"Oct" { set mois "10" }
		"Nov" { set mois "11" }
		"Dec" { set mois "12" }
	}
	switch -exact [lindex [ctime $temps] 2] {
		"1" { set jour "01" }
		"2" { set jour "02" }
		"3" { set jour "03" }
		"4" { set jour "04" }
		"5" { set jour "05" }
		"6" { set jour "06" }
		"7" { set jour "07" }
		"8" { set jour "08" }
		"9" { set jour "09" }
	}
	if {![info exists jour]} { set jour [lindex [ctime $temps] 2] }
	set heure [lindex [ctime $temps] 3]
	set annee [lindex [ctime $temps] 4]
	set seen "$jour/$mois/$annee à $heure"
	return $seen
}

##################
# Eva Chargement #
##################

proc eva:chargement {} {
	global eva trust
	catch {open [eva:scriptdir]db/trust.db r} protection
	while {![eof $protection]} { gets $protection hosts; if {$hosts!="" && ![info exists trust($hosts)]} { set trust($hosts) "1" } }
	catch {close $protection}
	catch {open [eva:scriptdir]db/gestion.db r} gestion
	while {![eof $gestion]} { gets $gestion var2; if {$var2!=""} { set [lindex $var2 0] [lindex $var2 1] } }
	catch {close $gestion}
}

###############
# Eva Console #
###############

proc eva:console {level} {
	global eva
	switch -exact $level {
		"1" { if {$eva(console)>="1"} { return ok } }
		"2" { if {$eva(console)>="2"} { return ok } }
		"3" { if {$eva(console)>="3"} { return ok } }
	}
}

##################
# Eva Protection #
##################

proc eva:protection {user level} {
	global eva netadmin admins vhost
	switch -exact $level {
		"0" { if {[info exists netadmin($user)]} { return ok } }
		"1" { if {[info exists netadmin($user)]} { return ok } elseif {[info exists admins($user)] && [matchattr $admins($user) n]} { return ok } }
		"2" { if {[info exists netadmin($user)]} { return ok } elseif {[info exists admins($user)] && [matchattr $admins($user) m]} { return ok } }
		"3" { if {[info exists netadmin($user)]} { return ok } elseif {[info exists admins($user)] && [matchattr $admins($user) o]} { return ok } }
		"4" { if {[info exists netadmin($user)]} { return ok } elseif {[info exists admins($user)] && [matchattr $admins($user) p]} { return ok } }
	}
}

#############
# Eva Rnick #
#############

proc eva:rnick {user} {
	global eva
	if {$eva(rnick)=="1"} { return "($user)" }
}

############
# Eva Secu #
############

proc eva:secu {} {
	global eva
	if {[info exists eva(maxthrottle)]} {
		putdcc $eva(idx) ":$eva(pseudo) NOTICE $*.* : $eva(secuoff)"
		catch {open "[eva:scriptdir]db/secu.db" r} liste
		while {![eof $liste]} { gets $liste salon; if {$salon!=""} { putdcc $eva(idx) ":$eva(pseudo) MODE $salon -msi" } }
		catch {close $liste}
		unset eva(maxthrottle)
	}
}

#################
# Eva Prerehash #
#################

proc eva:prerehash {arg} {
	global eva
	if {[info exists eva(idx)] && [valididx $eva(idx)]} { eva:gestion }
}

##############
# Eva Rehash #
##############

proc eva:rehash {arg} {
	global eva
	if {[info exists eva(idx)] && [valididx $eva(idx)]} { eva:chargement }
}

#################
# Eva Evenement #
#################

proc eva:evenement {arg} {
	global eva
	if {[info exists eva(idx)] && [valididx $eva(idx)]} {
		eva:gestion
		putdcc $eva(idx) ":$eva(pseudo) QUIT :$eva(raison)"
		putdcc $eva(idx) ":$eva(link) SQUIT $eva(link) :$eva(raison)"
		foreach kill [utimers] { if {[lindex $kill 1]=="eva:verif"} { killutimer [lindex $kill 2] } }
		unset eva(idx)
	}
}

#######
# Eva #
#######

proc eva:eva {nick idx arg} {
	putdcc $idx "01,01------------00 Commandes de Eva Service 01------------"
	putdcc $idx " "
	putdcc $idx "01 .evaconnect 03: 14Connexion de Eva Service"
	putdcc $idx "01 .evadeconnect 03: 14Déconnexion de Eva Service"
	putdcc $idx "01 .evadebug on/off 03: 14Mode debug de Eva Service"
	putdcc $idx "01 .evainfos 03: 14Voir les infos de Eva Service"
	putdcc $idx "01 .evauptime 03: 14Uptime de Eva Service"
	putdcc $idx "01 .evaversion 03: 14Version de Eva Service"
	putdcc $idx ""
}

###############
# Eva Connect #
###############

proc eva:connect {nick idx arg} {
	global eva
	set eva(counter) "0"
	if {[eva:config]!="ok"} {
		if {![info exists eva(idx)]} {
			putdcc $idx "01\[ 03Connexion01 \] 01 Lancement de Eva Service..."; eva:connexion
			set eva(dem) "1"; utimer $eva(timerdem) [list set eva(dem) 0]
		} else {
			if {![valididx $eva(idx)]} {
				putdcc $idx "01\[ 03Connexion01 \] 01 Lancement de Eva Service..."; eva:connexion
				set eva(dem) "1"; utimer $eva(timerdem) [list set eva(dem) 0]
			} else { putdcc $idx "01\[ 04Impossible01 \] 01 Eva Service est déjà connecté..." }
		}
	} else { putdcc $idx "01\[ 04Erreur01 \] 01 Configuration de Eva Service Incorrecte..." }
}

#################
# Eva Deconnect #
#################

proc eva:deconnect {nick idx arg} {
	global eva
	if {$eva(dem)=="0"} {
		if {[info exists eva(idx)] && [valididx $eva(idx)]} {
			eva:gestion
			putdcc $idx "01\[ 03Déconnexion01 \] 01 Arret de Eva Service..."
			putdcc $eva(idx) ":$eva(pseudo) QUIT :$eva(raison)"
			putdcc $eva(idx) ":$eva(link) SQUIT $eva(link) :$eva(raison)"
			foreach kill [utimers] { if {[lindex $kill 1]=="eva:verif"} { killutimer [lindex $kill 2] } }
			unset eva(idx)
		} else { putdcc $idx "01\[ 04Impossible01 \] 01 Eva Service n'est pas connecté..." }
	} else { putdcc $idx "01\[ 04Erreur01 \] 01 Connexion de Eva Service en cours..." }
}

##############
# Eva Uptime #
##############

proc eva:uptime {nick idx arg} {
	global eva
	if {[info exists eva(idx)] && [valididx $eva(idx)]} {
		set show ""
		set up [expr ([clock seconds] - $eva(uptime))]
		set jour [expr ($up / 86400)]
		set up [expr ($up % 86400)]
		set heure [expr ($up / 3600)]
		set up [expr ($up % 3600)]
		set minute [expr ($up / 60)]
		set seconde [expr ($up % 60)]
		if {$jour == "1"} { append show "$jour jour " } elseif {$jour > "1"} { append show "$jour jours " }
		if {$heure == "1"} { append show "$heure heure " } elseif {$heure > "1"} { append show "$heure heures " }
		if {$minute == "1"} { append show "$minute minute " } elseif {$minute > "1"} { append show "$minute minutes " }
		if {$seconde == "1"} { append show "$seconde seconde " } elseif {$seconde > "1"} { append show "$seconde secondes " }
		putdcc $idx "01\[ 03Uptime01 \] 01 $show"
	} else { putdcc $idx "01\[ 04Uptime01 \] 01 Eva Service n'est pas connecté..." }
}

###############
# Eva Version #
###############

proc eva:version {nick idx arg} {
	global eva
	putdcc $idx "01\[ 03Version01 \] 01 Eva Service $eva(version) by TiSmA"
}

#############
# Eva Infos #
#############

proc eva:infos {nick idx arg} {
	global eva version tcl_patchLevel tcl_library tcl_platform
	putdcc $idx "01,01-----------00 Infos de Eva Service 01-----------"
	putdcc $idx ""
	if {[info exists eva(idx)]}  {
		putdcc $idx "01 Statut : 03Online"
	} else { putdcc $idx "01 Statut : 04Offline" }
	if {$eva(debug)=="1"} {
		putdcc $idx "01 Debug : 03On"
	} else { putdcc $idx "01 Debug : 04Off" }
	putdcc $idx "01 Os : $tcl_platform(os) $tcl_platform(osVersion)"
	putdcc $idx "01 Tcl Version : $tcl_patchLevel"
	putdcc $idx "01 Tcl Lib : $tcl_library"
	putdcc $idx "01 Encodage : [encoding system]"
	putdcc $idx "01 Eggdrop Version : [lindex $version 0]"
	putdcc $idx "01 Config : [eva:scriptdir]Eva.conf"
	putdcc $idx "01 Noyau : [eva:scriptdir]Eva.tcl"
	putdcc $idx ""
}

#############
# Eva Debug #
#############

proc eva:debug {nick idx arg} {
	global eva
	set arg [split $arg]
	set status [string tolower [lindex $arg 0]]
	if {$status!="on" && $status!="off"} { putdcc $idx ".evadebug on/off"; return 0 }
	if {$status=="on"} {
		if {$eva(debug)=="0"} {
			set eva(debug) "1"; putdcc $idx "01\[ 03Debug01 \] 01 Activé"
		} else { putdcc $idx "Le mode debug est déjà activé." }
	} elseif {$status=="off"} {
		if {$eva(debug)=="1"} {
			set eva(debug) "0"; putdcc $idx "01\[ 03Debug01 \] 01 Désactivé"
			if {[file exists "logs/Eva.debug"]} { exec rm -rf logs/Eva.debug }
		} else { putdcc $idx "Le mode debug est déjà désactivé." }
	}
}

##############
# Eva Authed #
##############

proc eva:authed {user level} {
	global eva admins
	switch -exact $level {
		"0" { return ok }
		"1" { if {[info exists admins($user)] && [matchattr $admins($user) p]} { return ok } else { putdcc $eva(idx) ":$eva(pseudo) NOTICE $user :Accès Refusé"; return 0 } }
		"2" { if {[info exists admins($user)] && [matchattr $admins($user) o]} { return ok } else { putdcc $eva(idx) ":$eva(pseudo) NOTICE $user :Accès Refusé"; return 0 } }
		"3" { if {[info exists admins($user)] && [matchattr $admins($user) m]} { return ok } else { putdcc $eva(idx) ":$eva(pseudo) NOTICE $user :Accès Refusé"; return 0 } }
		"4" { if {[info exists admins($user)] && [matchattr $admins($user) n]} { return ok } else { putdcc $eva(idx) ":$eva(pseudo) NOTICE $user :Accès Refusé"; return 0 } }
	}
}

#############
# Eva Flood #
#############

proc eva:flood {pseudo} {
	global eva
	if {![info exists eva(flood:$pseudo)]} {
		set eva(flood:$pseudo) "1"; utimer 3 [list eva:reset $pseudo]; return ok
	} elseif {$eva(flood:$pseudo)<$eva(fraz)} {
		incr eva(flood:$pseudo) 1; return ok
	} else { if {![info exists eva(stopflood:$pseudo)]} { set eva(stopflood:$pseudo) "1" } }
}

#############
# Eva Reset #
#############

proc eva:reset {pseudo} {
	global eva
	if {[info exists eva(stopflood:$pseudo)]} {
		putdcc $eva(idx) ":$eva(pseudo) NOTICE $pseudo :Vous êtes ignoré pendant $eva(ignore) secondes."; utimer $eva(ignore) [list eva:nettoyage $pseudo]; return 0
	} else { unset eva(flood:$pseudo) }
}

#################
# Eva Nettoyage #
#################

proc eva:nettoyage {pseudo} {
	global eva
	unset eva(flood:$pseudo); unset eva(stopflood:$pseudo)
}

############
# Eva Cmds #
############

proc eva:cmds {arg} {
	global eva ceva ueva admin admins vhost protect trust
	set arg [split $arg]
	set cmd [lindex $arg 0]
	set user [lindex $arg 1]
	set vuser [string tolower $user]
	set value1 [lindex $arg 2]
	set value2 [string tolower [lindex $arg 2]]
	set value3 [lindex $arg 3]
	set value4 [string tolower [lindex $arg 3]]
	set value5 [join [lrange $arg 4 end]]
	set value6 [join [lrange $arg 3 end]]
	set value7 [join [lrange $arg 2 end]]
	set value8 [lindex $arg 4]
	set value9 [string tolower [lindex $arg 4]]
	set stop "0"
	if {[eva:authed $vuser $ceva($cmd)]!="ok"} { return 0 }
	switch -exact $cmd {
		"auth" {
			if {[lindex $arg 2]=="" || [lindex $arg 3]==""} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $user :Commande Auth : /msg $eva(pseudo) auth pseudo password"; return 0 }
			if {[passwdok [lindex $arg 2] [lindex $arg 3]]} {
				if {[matchattr [lindex $arg 2] o] || [matchattr [lindex $arg 2] m] || [matchattr [lindex $arg 2] n]} {
					if {$eva(login)=="1"} {
						foreach {pseudo login} [array get admins] {
							if {$login==[string tolower [lindex $arg 2]] && $pseudo!=$vuser} {
								putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Maximum de Login atteint."; return 0
							}
						}
					}
					if {![info exists admins($vuser)]} {
						set admins($vuser) [string tolower [lindex $arg 2]]
						if {[info exists vhost($vuser)] && ![info exists protect($vhost($vuser))]} { set protect($vhost($vuser)) "1" }
						setuser [string tolower [lindex $arg 2]] LASTON [unixtime]
						putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Authentification Réussie."
						putdcc $eva(idx) ":$eva(pseudo) INVITE $vuser #Oracle"
						if {[eva:console 1]=="ok"} { putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Auth $eva(console_deco):$eva(console_txt) $user" }
						return 0
					} else { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Vous êtes déjà authentifié."; return 0 }
				} elseif {[matchattr [lindex $arg 2] p]} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Authentification Helpeur Refusée."; return 0 }
			} else { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Accès Refusé."; return 0 }
		}
		"deauth" {
			if {[info exists admins($vuser)]} {
				if {[matchattr $admins($vuser) o] || [matchattr $admins($vuser) m] || [matchattr $admins($vuser) n]} {
					if {[info exists vhost($vuser)] && [info exists protect($vhost($vuser))]} { unset protect($vhost($vuser)) }
					unset admins($vuser); putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Déauthentification Réussie."
					if {[eva:console 1]=="ok"} { putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Deauth $eva(console_deco):$eva(console_txt) $user" }
				} elseif {[matchattr $admins($vuser) p]} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Déauthentification Helpeur Refusée."; return 0 }
			} else { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Vous n'êtes pas authentifié." }
		}
		"copyright" {
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $user :01Eva Service $eva(version) by TiSmA"
			if {[eva:console 1]=="ok"} { putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Copyright $eva(console_deco):$eva(console_txt) $user" }
		}
		"console" {
			if {$value2=="" || [regexp \[^0-3\] $value2]} {
				putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Console :\002 /msg $eva(pseudo) console 0/1/2/3"
				putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :02Level 0 04:01 Aucune console"
				putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :02Level 1 04:01 Console commande"
				putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :02Level 2 04:01 Console commande & connexion & déconnexion"
				putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :02Level 3 04:01 Toutes les consoles"
				return 0
			}
			switch -exact $value2 {
				"0" {
					set eva(console) "0"; putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Level 0 : Aucune console"
					putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Console $eva(console_deco):$eva(console_txt) $user"
				}
				"1" {
					set eva(console) "1"; putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Level 1 : Console commande"
					putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Console $eva(console_deco):$eva(console_txt) $user"
				}
				"2" {
					set eva(console) "2"; putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Level 2 : Console commande & connexion & déconnexion"
					putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Console $eva(console_deco):$eva(console_txt) $user"
				}
				"3" {
					set eva(console) "3"; putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Level 3 : Toutes les consoles"
					putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Console $eva(console_deco):$eva(console_txt) $user"
				}
			}
		}
		"chanlog" {
			if {$value2==[string tolower $eva(salon)]} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :$value1 est déjà le salon de log."; return 0 }
			if {[string index $value2 0]!="#"} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Chanlog :\002 /msg $eva(pseudo) chanlog #salon"; return 0 }
			catch {open "[eva:scriptdir]db/salon.db" r} liste1
			while {![eof $liste1]} { gets $liste1 verif1; if {![string compare -nocase $value2 $verif1]} {  putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Accès Refusé : Salon Interdit"; set stop "1"; break } }
			catch {close $liste1}; if {$stop==1} { return 0 }
			catch {open "[eva:scriptdir]db/close.db" r} liste2
			while {![eof $liste2]} { gets $liste2 verif2; if {![string compare -nocase $value2 $verif2]} {  putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Accès Refusé : Salon Fermé"; set stop "1"; break } }
			catch {close $liste2}; if {$stop==1} { return 0 }
			catch {open "[eva:scriptdir]db/chan.db" r} liste3
			while {![eof $liste3]} { gets $liste3 verif3; if {![string compare -nocase $value2 $verif3]} {  putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Accès Refusé : Salon Autojoin"; set stop "1"; break } }
			catch {close $liste3}; if {$stop==1} { return 0 }
			putdcc $eva(idx) ":$eva(pseudo) PART $eva(salon)"
			set eva(salon) $value1
			putdcc $eva(idx) ":$eva(pseudo) JOIN $eva(salon)"
			putdcc $eva(idx) ":$eva(pseudo) MODE $eva(salon) +$eva(smode)"
			if {$eva(cmode)=="q" || $eva(cmode)=="a" || $eva(cmode)=="o" || $eva(cmode)=="h" || $eva(cmode)=="v"} { putdcc $eva(idx) ":$eva(pseudo) MODE $eva(salon) +$eva(cmode) $eva(pseudo)" }
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Changement du salon de log reussi ($value1)"
			if {[eva:console 1]=="ok"} { putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Chanlog $eva(console_deco):$eva(console_txt) Changement du salon de log par $user ($value1)" }
		}
		"join" {
			if {[string index $value2 0]!="#"} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Join :\002 /msg $eva(pseudo) join #salon"; return 0 }
			if {$value2==[string tolower $eva(salon)]} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Accès Refusé : Salon de logs"; return 0 }
			catch {open "[eva:scriptdir]db/salon.db" r} liste1
			while {![eof $liste1]} { gets $liste1 verif1; if {![string compare -nocase $value2 $verif1]} {  putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Accès Refusé : Salon Interdit"; set stop "1"; break } }
			catch {close $liste1}; if {$stop==1} { return 0 }
			catch {open "[eva:scriptdir]db/close.db" r} liste2
			while {![eof $liste2]} { gets $liste2 verif2; if {![string compare -nocase $value2 $verif2]} {  putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Accès Refusé : Salon Fermé"; set stop "1"; break } }
			catch {close $liste2}; if {$stop==1} { return 0 }
			catch {open "[eva:scriptdir]db/chan.db" r} liste
			while {![eof $liste]} { gets $liste verif; if {![string compare -nocase $value2 $verif]} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :$eva(pseudo) est déjà sur $value1."; set stop "1"; break } }
			catch {close $liste}; if {$stop==1} { return 0 }
			set join [open "[eva:scriptdir]db/chan.db" a]; puts $join $value2; close $join; putdcc $eva(idx) ":$eva(pseudo) JOIN $value1"
			if {$eva(cmode)=="q" || $eva(cmode)=="a" || $eva(cmode)=="o" || $eva(cmode)=="h" || $eva(cmode)=="v"} { putdcc $eva(idx) ":$eva(pseudo) MODE $value1 +$eva(cmode) $eva(pseudo)" }
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :$eva(pseudo) entre sur $value1"
			if {[eva:console 1]=="ok"} { putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Join $eva(console_deco):$eva(console_txt) $value1 par $user" }
		}
		"part" {
			if {[string index $value2 0]!="#"} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Part :\002 /msg $eva(pseudo) part #salon"; return 0 }
			if {$value2==[string tolower $eva(salon)]} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Accès Refusé"; return 0 }
			catch {open "[eva:scriptdir]db/chan.db" r} liste
			while {![eof $liste]} { gets $liste verif; if {![string compare -nocase $value2 $verif]} { set stop 1 }; if {[string compare -nocase $value2 $verif] && $verif!=""} { lappend salle "$verif" } }
			catch {close $liste}
			if {$stop==0} {
				putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :$eva(pseudo) n'est pas sur $value1."; return 0
			} else {
				if {[info exists salle]} {
					set del [open "[eva:scriptdir]db/chan.db" w+]; foreach delchan $salle { puts $del "$delchan" }; close $del
				} else { set del [open "[eva:scriptdir]db/chan.db" w+]; close $del }
				putdcc $eva(idx) ":$eva(pseudo) PART $value1"
				putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :$eva(pseudo) part de $value1"
				if {[eva:console 1]=="ok"} { putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Part $eva(console_deco):$eva(console_txt) $value1 par $user" }
			}
		}
		"list" {
			catch {open "[eva:scriptdir]db/chan.db" r} liste
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :1,1--------- 0Autojoin salons 1---------"
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :"
			while {![eof $liste]} { gets $liste salon; if {$salon!=""} { incr stop 1; putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :01 \[03 $stop 01\] 01 $salon" } }
			catch {close $liste}
			if {$stop=="0"} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Aucun Salon" }
			if {[eva:console 1]=="ok"} { putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)List $eva(console_deco):$eva(console_txt) $user" }
		}
		"showcommands" {
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :01,01--------------------------------------- 00Commandes de Eva Service 01---------------------------------------"
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :"
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :01\[ Level Utilisateur \]"
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :02AUTH01 \[04 0 01\] | 02COPYRIGHT01 \[04 0 01\] | 02DEAUTH01 \[04 0 01\] | 02HELP01 \[04 0 01\]"
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :02SEEN01 \[04 0 01\] | 02SHOWCOMMANDS01 \[04 0 01\]"
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :"
			if {[info exists admins($vuser)] && [matchattr $admins($vuser) p]} {
				putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :01\[ Level Helpeur \]"
				putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :02MAP01 \[04 1 01\] | 02WHOIS01 \[04 1 01\]"
				putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :"
			}
			if {[info exists admins($vuser)] && [matchattr $admins($vuser) o]} {
				putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :01\[ Level Géofront \]"
				putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :02ACCESS01 \[04 2 01\] | 02BAN01 \[04 2 01\] | 02CLEARALLMODES01 \[04 2 01\] | 02CLEARBANS01 \[04 2 01\] | 02CLEARMODES01 \[04 2 01\] | 02DEHALFOP01 \[04 2 01\]"
				putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :02DEHALFOPALL01 \[04 2 01\] | 02DEOP01 \[04 2 01\] | 02DEOPALL01 \[04 2 01\] | 02DEOWNER01 \[04 2 01\] | 02DEOWNERALL01 \[04 2 01\]"
				putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :02DEPROTECT01 \[04 2 01\] | 02DEPROTECTALL01 \[04 2 01\] | 02DEVOICE01 \[04 2 01\] | 02DEVOICEALL01 \[04 2 01\] | 02GLINE01 \[04 2 01\]"
				putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :02GLINELIST01 \[04 2 01\] | 02SHUNLIST01 | \[04 2 01\] |02GLOBOPS01 \[04 2 01\] | 02HALFOP01 \[04 2 01\] | 02HALFOPALL01 \[04 2 01\] | 02INVITE01 \[04 2 01\]"
				putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :02INVITEME01 \[04 2 01\] | 02KICK01 \[04 2 01\] | 02KICKALL01 \[04 2 01\] | 02KICKBAN01 \[04 2 01\]"
				putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :02KILL01 \[04 2 01\] | 02KLINE01 \[04 2 01\] | 02KLINELIST01 \[04 2 01\] | 02MODE01 \[04 2 01\] | 02NEWPASS01 \[04 2 01\]"
				putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :02NICKBAN01 \[04 2 01\] | 02OP01 \[04 2 01\] | 02OPALL01 \[04 2 01\] | 02OWNER01 \[04 2 01\] | 02OWNERALL01 \[04 2 01\]"
				putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :02PROTECT01 \[04 2 01\] | 02PROTECTALL01 \[04 2 01\] | 02TOPIC01 \[04 2 01\] | 02UNBAN01 \[04 2 01\] | 02UNGLINE01 \[04 2 01\] | 02UNSHUN01 \[04 2 01\]"
				putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :02UNKLINE01 \[04 2 01\] | 02VOICE01 \[04 2 01\] | 02VOICEALL01 \[04 2 01\] | 02WALLOPS01 \[04 2 01\]"
				putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :"
			}
			if {[info exists admins($vuser)] && [matchattr $admins($vuser) m]} {
				putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :01\[ Level Ircop \]"
				putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :02CHANGLINE01 \[04 3 01\] | 02SHUNLIST01 | 02CHANKILL01 \[04 3 01\] | 02CHANLIST01 \[04 3 01\] | 02CLEARCLOSE01 \[04 3 01\] | 02CLEARGLINE01 \[04 3 01\]"
				putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :02CLEARKLINE01 \[04 3 01\] | 02CLIENTLIST01 \[04 3 01\] | 02CLOSE01 \[04 3 01\] | 02CLOSELIST01 \[04 3 01\] | 02HOSTLIST01 \[04 3 01\]"
				putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :02IDENTLIST01 \[04 3 01\] | 02JOIN01 \[04 3 01\] | 02LIST01 \[04 3 01\] | 02NICKLIST01 \[04 3 01\] | 02NOTICE01 \[04 3 01\]"
				putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :02PART01 \[04 3 01\] | 02REALLIST01 \[04 3 01\] | 02SAY01 \[04 3 01\] | 02SECULIST01 \[04 3 01\] | 02STATUS01 \[04 3 01\]"
				putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :02SVSJOIN01 \[04 3 01\] | 02SVSNICK01 \[04 3 01\] | 02SVSPART01 \[04 3 01\] | 02TRUSTLIST01 \[04 3 01\] | 02UNCLOSE01 \[04 3 01\]"
				putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :"
			}
			if {[info exists admins($vuser)] && [matchattr $admins($vuser) n]} {
				putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :01\[ Level Admin \]"
				putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :02ADDACCESS01 \[04 4 01\] | 02ADDCHAN01 \[04 4 01\] | 02ADDCLIENT01 \[04 4 01\] | 02ADDHOST01 \[04 4 01\] | 02ADDIDENT01 \[04 4 01\]"
				putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :02ADDNICK01 \[04 4 01\] | 02ADDREAL01 \[04 4 01\] | 02ADDSECU01 \[04 4 01\] | 02ADDTRUST01 \[04 4 01\] | 02BACKUP01 \[04 4 01\]"
				putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :02CHANLOG01 \[04 4 01\] | 02CLIENT01 \[04 4 01\] | 02CLONE01 \[04 4 01\] | 02CONSOLE01 \[04 4 01\] | 02DELACCESS01 \[04 4 01\]"
				putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :02DELCHAN01 \[04 4 01\] | 02DELCLIENT01 \[04 4 01\] | 02DELHOST01 \[04 4 01\] | 02DELIDENT01 \[04 4 01\] | 02DELNICK01 \[04 4 01\]"
				putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :02DELREAL01 \[04 4 01\] | 02DELSECU01 \[04 4 01\] | 02DELTRUST01 \[04 4 01\] | 02DIE01 \[04 4 01\] | 02MAXLOGIN01 \[04 4 01\]"
				putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :02MODACCESS01 \[04 4 01\] | 02PROTECTION01 \[04 4 01\] | 02RESTART01 \[04 4 01\] | 02SECU01 \[04 4 01\]"
				putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :"
			}
			if {[eva:console 1]=="ok"} { putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Showcommands $eva(console_deco):$eva(console_txt) $user" }
		}
		"help" {
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :01,01--------------------------------------- 00Commandes de Eva Service 01---------------------------------------"
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :"
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :01\[ Level Utilisateur \]"
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :02AUTH01 \[04 0 01\] | 02COPYRIGHT01 \[04 0 01\] | 02DEAUTH01 \[04 0 01\] | 02HELP01 \[04 0 01\]"
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :02SEEN01 \[04 0 01\] | 02SHOWCOMMANDS01 \[04 0 01\]"
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :"
			if {[info exists admins($vuser)] && [matchattr $admins($vuser) p]} {
				putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :01\[ Level Helpeur \]"
				putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :02MAP01 \[04 1 01\] | 02WHOIS01 \[04 1 01\]"
				putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :"
			}
			if {[info exists admins($vuser)] && [matchattr $admins($vuser) o]} {
				putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :01\[ Level Géofront \]"
				putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :02ACCESS01 \[04 2 01\] | 02BAN01 \[04 2 01\] | 02CLEARALLMODES01 \[04 2 01\] | 02CLEARBANS01 \[04 2 01\] | 02CLEARMODES01 \[04 2 01\] | 02DEHALFOP01 \[04 2 01\]"
				putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :02DEHALFOPALL01 \[04 2 01\] | 02DEOP01 \[04 2 01\] | 02DEOPALL01 \[04 2 01\] | 02DEOWNER01 \[04 2 01\] | 02DEOWNERALL01 \[04 2 01\]"
				putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :02DEPROTECT01 \[04 2 01\] | 02DEPROTECTALL01 \[04 2 01\] | 02DEVOICE01 \[04 2 01\] | 02DEVOICEALL01 \[04 2 01\] | 02GLINE01 \[04 2 01\] | 02SHUN01 \[04 2 01\]"
				putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :02GLINELIST01 \[04 2 01\] | 02GLOBOPS01 \[04 2 01\] | 02HALFOP01 \[04 2 01\] | 02HALFOPALL01 \[04 2 01\] | 02INVITE01 \[04 2 01\]"
				putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :02INVITEME01 \[04 2 01\] | 02KICK01 \[04 2 01\] | 02KICKALL01 \[04 2 01\] | 02KICKBAN01 \[04 2 01\]"
				putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :02KILL01 \[04 2 01\] | 02KLINE01 \[04 2 01\] | 02KLINELIST01 \[04 2 01\] | 02MODE01 \[04 2 01\] | 02NEWPASS01 \[04 2 01\]"
				putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :02NICKBAN01 \[04 2 01\] | 02OP01 \[04 2 01\] | 02OPALL01 \[04 2 01\] | 02OWNER01 \[04 2 01\] | 02OWNERALL01 \[04 2 01\]"
				putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :02PROTECT01 \[04 2 01\] | 02PROTECTALL01 \[04 2 01\] | 02TOPIC01 \[04 2 01\] | 02UNBAN01 \[04 2 01\] | 02UNGLINE01 \[04 2 01\] | 02UNSHUN01 \[04 2 01\]"
				putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :02UNKLINE01 \[04 2 01\] | 02VOICE01 \[04 2 01\] | 02VOICEALL01 \[04 2 01\] | 02WALLOPS01 \[04 2 01\]"
				putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :"
			}
			if {[info exists admins($vuser)] && [matchattr $admins($vuser) m]} {
				putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :01\[ Level Ircop \]"
				putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :02CHANGLINE01 \[04 3 01\] | 02CHANKILL01 \[04 3 01\] | 02CHANLIST01 \[04 3 01\] | 02CLEARCLOSE01 \[04 3 01\] | 02CLEARGLINE01 \[04 3 01\]"
				putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :02CLEARKLINE01 \[04 3 01\] | 02CLIENTLIST01 \[04 3 01\] | 02CLOSE01 \[04 3 01\] | 02CLOSELIST01 \[04 3 01\] | 02HOSTLIST01 \[04 3 01\]"
				putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :02IDENTLIST01 \[04 3 01\] | 02JOIN01 \[04 3 01\] | 02LIST01 \[04 3 01\] | 02NICKLIST01 \[04 3 01\] | 02NOTICE01 \[04 3 01\]"
				putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :02PART01 \[04 3 01\] | 02REALLIST01 \[04 3 01\] | 02SAY01 \[04 3 01\] | 02SECULIST01 \[04 3 01\] | 02STATUS01 \[04 3 01\]"
				putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :02SVSJOIN01 \[04 3 01\] | 02SVSNICK01 \[04 3 01\] | 02SVSPART01 \[04 3 01\] | 02TRUSTLIST01 \[04 3 01\] | 02UNCLOSE01 \[04 3 01\]"
				putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :"
			}
			if {[info exists admins($vuser)] && [matchattr $admins($vuser) n]} {
				putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :01\[ Level Admin \]"
				putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :02ADDACCESS01 \[04 4 01\] | 02ADDCHAN01 \[04 4 01\] | 02ADDCLIENT01 \[04 4 01\] | 02ADDHOST01 \[04 4 01\] | 02ADDIDENT01 \[04 4 01\]"
				putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :02ADDNICK01 \[04 4 01\] | 02ADDREAL01 \[04 4 01\] | 02ADDSECU01 \[04 4 01\] | 02ADDTRUST01 \[04 4 01\] | 02BACKUP01 \[04 4 01\]"
				putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :02CHANLOG01 \[04 4 01\] | 02CLIENT01 \[04 4 01\] | 02CLONE01 \[04 4 01\] | 02CONSOLE01 \[04 4 01\] | 02DELACCESS01 \[04 4 01\]"
				putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :02DELCHAN01 \[04 4 01\] | 02DELCLIENT01 \[04 4 01\] | 02DELHOST01 \[04 4 01\] | 02DELIDENT01 \[04 4 01\] | 02DELNICK01 \[04 4 01\]"
				putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :02DELREAL01 \[04 4 01\] | 02DELSECU01 \[04 4 01\] | 02DELTRUST01 \[04 4 01\] | 02DIE01 \[04 4 01\] | 02MAXLOGIN01 \[04 4 01\]"
				putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :02MODACCESS01 \[04 4 01\] | 02PROTECTION01 \[04 4 01\] | 02RESTART01 \[04 4 01\] | 02SECU01 \[04 4 01\]"
				putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :"
			}
			if {[eva:console 1]=="ok"} { putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Help $eva(console_deco):$eva(console_txt) $user" }
		}
		"maxlogin" {
			if {$value2!="on" && $value2!="off"} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Maxlogin :\002 /msg $eva(pseudo) maxlogin on/off"; return 0 }
			if {$value2=="on"} {
				if {$eva(login)=="0"} {
					set eva(login) "1"; putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Protection maxlogin activée"
					if {[eva:console 1]=="ok"} { putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Maxlogin $eva(console_deco):$eva(console_txt) $user" }
				} else { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :La protection maxlogin est déjà activée." }
			} elseif {$value2=="off"} {
				if {$eva(login)=="1"} {
					set eva(login) "0"; putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Protection maxlogin désactivée"
					if {[eva:console 1]=="ok"} { putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Maxlogin $eva(console_deco):$eva(console_txt) $user" }
				} else { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :La protection maxlogin est déjà désactivée." }
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
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Sauvegarde des databases réalisée."
			if {[eva:console 1]=="ok"} { putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Backup $eva(console_deco):$eva(console_txt) $user" }
		}
		"restart" {
			if {[eva:console 1]=="ok"} { putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Restart $eva(console_deco):$eva(console_txt) $user" }
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Redémarrage de Eva Service."
			eva:gestion; putdcc $eva(idx) ":$eva(pseudo) QUIT $eva(raison)"; putdcc $eva(idx) ":$eva(link) SQUIT $eva(link) :$eva(raison)"
			foreach kill [utimers] { if {[lindex $kill 1]=="eva:verif"} { killutimer [lindex $kill 2] } }
			if {[info exists eva(idx)]} { unset eva(idx) }
			set eva(counter) "0"; if {[eva:config]!="ok"} { utimer 1 eva:connexion }
		}
		"die" {
			if {[eva:console 1]=="ok"} { putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Die $eva(console_deco):$eva(console_txt) $user" }
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Arrêt de Eva Service."
			eva:gestion; putdcc $eva(idx) ":$eva(pseudo) QUIT $eva(raison)"; putdcc $eva(idx) ":$eva(link) SQUIT $eva(link) :$eva(raison)"
			foreach kill [utimers] { if {[lindex $kill 1]=="eva:verif"} { killutimer [lindex $kill 2] } }
			if {[info exists eva(idx)]} { unset eva(idx) }
		}
		"status" {
			set numuser "0"; set numident "0"; set numhost "0"; set numreal "0"; set numtrust "0"
			set numclose "0"; set numsalons "0"; set numsalon "0"; set numchan "0"; set numclient "0"; set show ""
			set up [expr ([clock seconds] - $eva(uptime))]
			set jour [expr ($up / 86400)]
			set up [expr ($up % 86400)]
			set heure [expr ($up / 3600)]
			set up [expr ($up % 3600)]
			set minute [expr ($up / 60)]
			set seconde [expr ($up % 60)]
			if {$jour == "1"} { append show "$jour jour " } elseif {$jour > "1"} { append show "$jour jours " }
			if {$heure == "1"} { append show "$heure heure " } elseif {$heure > "1"} { append show "$heure heures " }
			if {$minute == "1"} { append show "$minute minute " } elseif {$minute > "1"} { append show "$minute minutes " }
			if {$seconde == "1"} { append show "$seconde seconde " } elseif {$seconde > "1"} { append show "$seconde secondes " }
			catch {open [eva:scriptdir]db/client.db r} liste
			while {![eof $liste]} { gets $liste sclients; if {$sclients!=""} { incr numclient 1 } }
			catch {close $liste}
			catch {open [eva:scriptdir]db/chan.db r} liste2
			while {![eof $liste2]} { gets $liste2 schans; if {$schans!=""} { incr numchan 1 } }
			catch {close $liste2}
			catch {open [eva:scriptdir]db/secu.db r} liste3
			while {![eof $liste3]} { gets $liste3 ssalons; if {$ssalons!=""} { incr numsalon 1 } }
			catch {close $liste3}
			catch {open [eva:scriptdir]db/salon.db r} liste4
			while {![eof $liste4]} { gets $liste4 ssalon; if {$ssalon!=""} { incr numsalons 1 } }
			catch {close $liste4}
			catch {open [eva:scriptdir]db/close.db r} liste5
			while {![eof $liste5]} { gets $liste5 sclose; if {$sclose!=""} { incr numclose 1 } }
			catch {close $liste5}
			catch {open [eva:scriptdir]db/nick.db r} liste6
			while {![eof $liste6]} { gets $liste6 suser; if {$suser!=""} { incr numuser 1 } }
			catch {close $liste6}
			catch {open [eva:scriptdir]db/ident.db r} liste7
			while {![eof $liste7]} { gets $liste7 sident; if {$sident!=""} { incr numident 1 } }
			catch {close $liste7}
			catch {open [eva:scriptdir]db/host.db r} liste8
			while {![eof $liste8]} { gets $liste8 shost; if {$shost!=""} { incr numhost 1 } }
			catch {close $liste8}
			catch {open [eva:scriptdir]db/real.db r} liste9
			while {![eof $liste9]} { gets $liste9 sreal; if {$sreal!=""} { incr numreal 1 } }
			catch {close $liste9}
			catch {open [eva:scriptdir]db/trust.db r} liste10
			while {![eof $liste10]} { gets $liste10 strust; if {$strust!=""} { incr numtrust 1 } }
			catch {close $liste10}
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :1,1------------------ 0Status de Eva Service 1------------------"
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :"
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :02 Owner : 01$admin"
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :02 Salon de logs : 01$eva(salon)"
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :02 Salon Autojoin : 01$numchan"
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :02 Uptime : 01$show"
			switch -exact $eva(console) {
				"0" { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :02 Level Console : 010" }
				"1" { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :02 Level Console : 011" }
				"2" { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :02 Level Console : 012" }
				"3" { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :02 Level Console : 013" }
			}
			switch -exact $eva(protection) {
				"0" { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :02 Level Protection : 010" }
				"1" { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :02 Level Protection : 011" }
				"2" { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :02 Level Protection : 012" }
				"3" { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :02 Level Protection : 013" }
				"4" { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :02 Level Protection : 014" }
			}
			if {$eva(login)=="1"} {
				putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :02 Protection Maxlogin : 03On"
			} else { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :02 Protection Maxlogin : 04Off" }
			if {$eva(aclone)=="1"} {
				putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :02 Protection Clones : 03On"
			} else { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :02 Protection Clones : 04Off" }
			if {$eva(aclient)=="1"} {
				putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :02 Protection Clients IRC : 03On"
			} else { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :02 Protection Clients IRC : 04Off" }
			if {$eva(secu)=="1"} {
				putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :02 Sécurité Salons : 03On"
			} else { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :02 Sécurité Salons : 04Off" }
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :02 Nbre de Salons Sécurisés : 01$numsalon"
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :02 Nbre de Salons Fermés : 01$numclose"
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :02 Nbre de Salons Interdits : 01$numsalons"
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :02 Nbre de Pseudos Interdits : 01$numuser"
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :02 Nbre de Idents Interdits : 01$numident"
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :02 Nbre de Hostnames Interdites : 01$numhost"
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :02 Nbre de Realnames Interdits : 01$numreal"
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :02 Nbre de Clients IRC : 01$numclient"
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :02 Nbre de Trusts : 01$numtrust"
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :"
			if {[eva:console 1]=="ok"} { putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Status $eva(console_deco):$eva(console_txt) $user" }
		}
		"protection" {
			if {$value2=="" || [regexp \[^0-4\] $value2]} {
				putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Protection :\002 /msg $eva(pseudo) protection 0/1/2/3/4"
				putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :02Level 0 04:01 Aucune Protection"
				putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :02Level 1 04:01 Protection Admins"
				putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :02Level 2 04:01 Protection Admins + Ircops"
				putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :02Level 3 04:01 Protection Admins + Ircops + Géofronts"
				putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :02Level 4 04:01 Protection de tous les accès"
				return 0
			}
			switch -exact $value2 {
				"0" {
					set eva(protection) "0"; putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Level 0 : Aucune Protection"
					putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Protection $eva(console_deco):$eva(console_txt) $user"
				}
				"1" {
					set eva(protection) "1"; putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Level 1 : Protection Admins"
					putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Protection $eva(console_deco):$eva(console_txt) $user"
				}
				"2" {
					set eva(protection) "2"; putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Level 2 : Protection Admins + Ircops"
					putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Protection $eva(console_deco):$eva(console_txt) $user"
				}
				"3" {
					set eva(protection) "3"; putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Level 3 : Protection Admins + Ircops + Géofronts"
					putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Protection $eva(console_deco):$eva(console_txt) $user"
				}
				"4" {
					set eva(protection) "4"; putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Level 4 : Protection de tous les accès"
					putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Protection $eva(console_deco):$eva(console_txt) $user"
				}
			}
		}
		"newpass" {
			if {$value1==""} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Newpass :\002 /msg $eva(pseudo) newpass mot-de-passe"; return 0 }
			if {[string length $value1]<="5"} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Le mot de passe doit contenir minimum 6 caractères."; return 0 }
			setuser $admins($vuser) PASS $value1
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $user :Changement du mot de passe reussi."
			if {[eva:console 1]=="ok"} { putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Newpass $eva(console_deco):$eva(console_txt) $user" }
		}
		"map" {
			set eva(rep) $vuser
			putdcc $eva(idx) ":$eva(pseudo) LINKS"
			if {[eva:console 1]=="ok"} { putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Map $eva(console_deco):$eva(console_txt) $user" }
		}
		"seen" {
			if {$value1==""} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $user :\002Commande Seen :\002 /msg $eva(pseudo) seen pseudo"; return 0 }
			if {[validuser $value1]} {
				set annee [lindex [ctime [getuser $value1 LASTON]] 4]
				if {$annee!="1970"} { set seen [eva:duree [getuser $value1 LASTON]] } else { set seen "Jamais" }
				if {[eva:console 1]=="ok"} { putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Seen $eva(console_deco):$eva(console_txt) $user" }
				if {[matchattr $value1 n]} {
					putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :1Pseudo \[4$value11\]  Level \[03Admin1\]  Seen \[02$seen1\]"
				} elseif {[matchattr $value1 m]} {
					putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :1Pseudo \[4$value11\]  Level \[03Ircop1\]  Seen \[02$seen1\]"
				} elseif {[matchattr $value1 o]} {
					putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :1Pseudo \[4$value11\]  Level \[03Géofront1\]  Seen \[02$seen1\]"
				} elseif {[matchattr $value1 p]} {
					putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :1Pseudo \[4$value11\]  Level \[03Helpeur1\]  Seen \[02$seen1\]"
				}
			} else { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Pseudo inconnu."; return 0 }
		}
		"access" {
			if {$value1=="*" || $value1==""} {
				if {[eva:console 1]=="ok"} { putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Access $eva(console_deco):$eva(console_txt) $user" }
				putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :1,1------------------------------- 0Liste des Accès 1-------------------------------"
				putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :"
				foreach acces [userlist] {
					set annee [lindex [ctime [getuser $acces LASTON]] 4]
					if {$annee!="1970"} { set seen [eva:duree [getuser $acces LASTON]] } else { set seen "Jamais" }
					foreach {act reg} [array get admins] { if {$reg==[string tolower $acces]} { set status "03Online" } }
					if {![info exists status]} { set status "04Offline" }
					switch -exact $eva(protection) {
						"1" { if {[matchattr $acces n]} { set aprotect "03On" } }
						"2" { if {[matchattr $acces m]} { set aprotect "03On" } }
						"3" { if {[matchattr $acces o]} { set aprotect "03On" } }
						"4" { if {[matchattr $acces p]} { set aprotect "03On" } }
					}
					if {![info exists aprotect]} { set aprotect "04Off" }
					if {[matchattr $acces n]} {
						putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :01 Pseudo \[04$acces01\] 01 Level \[03Admin01\] 01 Seen \[12$seen01\]"
						putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :01 Statut \[$status01\] 01 Protection \[$aprotect01\]"
						putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :01 Mask \[02[getuser $acces HOSTS]01\]"
						putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :"
					} elseif {[matchattr $acces m]} {
						putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :01 Pseudo \[04$acces01\] 01 Level \[03Ircop01\] 01 Seen \[12$seen01\]"
						putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :01 Statut \[$status01\] 01 Protection \[$aprotect01\]"
						putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :01 Mask \[02[getuser $acces HOSTS]01\]"
						putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :"
					} elseif {[matchattr $acces o]} {
						putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :01 Pseudo \[04$acces01\] 01 Level \[03Géofront01\] 01 Seen \[12$seen01\]"
						putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :01 Statut \[$status01\] 01 Protection \[$aprotect01\]"
						putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :01 Mask \[02[getuser $acces HOSTS]01\]"
						putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :"
					} elseif {[matchattr $acces p]} {
						putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :01 Pseudo \[04$acces01\] 01 Level \[03Helpeur01\] 01 Seen \[12$seen01\]"
						putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :01 Statut \[$status01\] 01 Protection \[$aprotect01\]"
						putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :01 Mask \[02[getuser $acces HOSTS]01\]"
						putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :"
					}
					unset status; unset seen; unset aprotect
				}
			} elseif {[validuser $value1]} {
				set annee [lindex [ctime [getuser $value1 LASTON]] 4]
				if {$annee!="1970"} { set seen [eva:duree [getuser $value1 LASTON]] } else { set seen "Jamais" }
				foreach {act reg} [array get admins] { if {$reg==[string tolower $value1]} { set status "03Online" } }
				if {![info exists status]} { set status "04Offline" }
				switch -exact $eva(protection) {
					"1" { if {[matchattr $value1 n]} { set aprotect "03On" } }
					"2" { if {[matchattr $value1 m]} { set aprotect "03On" } }
					"3" { if {[matchattr $value1 o]} { set aprotect "03On" } }
					"4" { if {[matchattr $value1 p]} { set aprotect "03On" } }
				}
				if {![info exists aprotect]} { set aprotect "04Off" }
				if {[eva:console 1]=="ok"} { putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Access $eva(console_deco):$eva(console_txt) $user" }
				putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :1,1--------------------------- 0Accès de $value1 1---------------------------"
				putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :"
				if {[matchattr $value1 n]} {
					putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :01 Pseudo \[04$value101\] 01 Level \[03Admin01\] 01 Seen \[12$seen01\]"
					putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :01 Statut \[$status01\] 01 Protection \[$aprotect01\]"
					putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :01 Mask \[02[getuser $value1 HOSTS]01\]"
				} elseif {[matchattr $value1 m]} {
					putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :01 Pseudo \[04$value101\] 01 Level \[03Ircop01\]  Seen \[12$seen01\]"
					putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :01 Statut \[$status01\] 01 Protection \[$aprotect01\]"
					putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :01 Mask \[02[getuser $value1 HOSTS]01\]"
				} elseif {[matchattr $value1 o]} {
					putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :01 Pseudo \[04$value101\] 01 Level \[03Géofront01\] 01 Seen \[12$seen01\]"
					putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :01 Statut \[03$status01\] 01 Protection \[$aprotect01\]"
					putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :01 Mask \[02[getuser $value1 HOSTS]01\]"
				} elseif {[matchattr $value1 p]} {
					putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :01 Pseudo \[04$value101\] 01 Level \[03Helpeur01\] 01 Seen \[12$seen01\]"
					putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :01 Statut \[$status01\] 01 Protection \[$aprotect01\]"
					putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :01 Mask \[02[getuser $value1 HOSTS]01\]"
				}
				putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :"
			} else { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Aucun Accès." }
		}
		"owner" {
			if {[string index $value1 0]!="#"} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Owner :\002 /msg $eva(pseudo) owner #salon pseudo"; return 0 }
			if {$value4==[string tolower $eva(pseudo)] || [info exists ueva($value4)] || [eva:protection $value4 $eva(protection)]=="ok"} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $user :Accès Refusé : Pseudo Protégé"; return 0 }
			if {$value4!=""} {
				if {![info exists vhost($value4)]} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Pseudo introuvable."; return 0 }
				putdcc $eva(idx) ":$eva(pseudo) MODE $value1 +q $value3"
				if {[eva:console 1]=="ok" && $value2!=[string tolower $eva(salon)]} { putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Owner $eva(console_deco):$eva(console_txt) $value3 sur $value1 par $user" }
			} else {
				putdcc $eva(idx) ":$eva(pseudo) MODE $value1 +q $user"
				if {[eva:console 1]=="ok" && $value2!=[string tolower $eva(salon)]} { putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Owner $eva(console_deco):$eva(console_txt) $user sur $value1" }
			}
		}
		"deowner" {
			if {[string index $value1 0]!="#"} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Deowner :\002 /msg $eva(pseudo) deowner #salon pseudo"; return 0 }
			if {$value4==[string tolower $eva(pseudo)] || [info exists ueva($value4)] || [eva:protection $value4 $eva(protection)]=="ok"} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $user :Accès Refusé : Pseudo Protégé"; return 0 }
			if {$value4!=""} {
				if {![info exists vhost($value4)]} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Pseudo introuvable."; return 0 }
				putdcc $eva(idx) ":$eva(pseudo) MODE $value1 -q $value3"
				if {[eva:console 1]=="ok" && $value2!=[string tolower $eva(salon)]} { putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Deowner $eva(console_deco):$eva(console_txt) $value3 sur $value1 par $user" }
			} else {
				putdcc $eva(idx) ":$eva(pseudo) MODE $value1 -q $user"
				if {[eva:console 1]=="ok" && $value2!=[string tolower $eva(salon)]} { putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Deowner $eva(console_deco):$eva(console_txt) $user sur $value1" }
			}
		}
		"protect" {
			if {[string index $value1 0]!="#"} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Protect :\002 /msg $eva(pseudo) protect #salon pseudo"; return 0 }
			if {$value4==[string tolower $eva(pseudo)] || [info exists ueva($value4)] || [eva:protection $value4 $eva(protection)]=="ok"} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $user :Accès Refusé : Pseudo Protégé"; return 0 }
			if {$value4!=""} {
				if {![info exists vhost($value4)]} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Pseudo introuvable."; return 0 }
				putdcc $eva(idx) ":$eva(pseudo) MODE $value1 +a $value3"
				if {[eva:console 1]=="ok" && $value2!=[string tolower $eva(salon)]} { putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Protect $eva(console_deco):$eva(console_txt) $value3 sur $value1 par $user" }
			} else {
				putdcc $eva(idx) ":$eva(pseudo) MODE $value1 +a $user"
				if {[eva:console 1]=="ok" && $value2!=[string tolower $eva(salon)]} { putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Protect $eva(console_deco):$eva(console_txt) $user sur $value1" }
			}
		}
		"deprotect" {
			if {[string index $value1 0]!="#"} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Deprotect :\002 /msg $eva(pseudo) deprotect #salon pseudo"; return 0 }
			if {$value4==[string tolower $eva(pseudo)] || [info exists ueva($value4)] || [eva:protection $value4 $eva(protection)]=="ok"} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $user :Accès Refusé : Pseudo Protégé"; return 0 }
			if {$value4!=""} {
				if {![info exists vhost($value4)]} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Pseudo introuvable."; return 0 }
				putdcc $eva(idx) ":$eva(pseudo) MODE $value1 -a $value3"
				if {[eva:console 1]=="ok" && $value2!=[string tolower $eva(salon)]} { putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Deprotect $eva(console_deco):$eva(console_txt) $value3 sur $value1 par $user" }
			} else {
				putdcc $eva(idx) ":$eva(pseudo) MODE $value1 -a $user"
				if {[eva:console 1]=="ok" && $value2!=[string tolower $eva(salon)]} { putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Deprotect $eva(console_deco):$eva(console_txt) $user sur $value1" }
			}
		}
		"ownerall" {
			set eva(cmd) "ownerall"
			if {[string index $value1 0]!="#"} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Ownerall :\002 /msg $eva(pseudo) ownerall #salon"; return 0 }
			putdcc $eva(idx) ":$eva(link) NAMES $value1"
			if {[eva:console 1]=="ok" && $value2!=[string tolower $eva(salon)]} { putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Ownerall $eva(console_deco):$eva(console_txt) $value1 par $user" }
		}
		"deownerall" {
			set eva(cmd) "deownerall"
			if {[string index $value1 0]!="#"} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Deownerall :\002 /msg $eva(pseudo) deownerall #salon"; return 0 }
			putdcc $eva(idx) ":$eva(link) NAMES $value1"
			if {[eva:console 1]=="ok" && $value2!=[string tolower $eva(salon)]} { putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Deownerall $eva(console_deco):$eva(console_txt) $value1 par $user" }
		}
		"protectall" {
			set eva(cmd) "protectall"
			if {[string index $value1 0]!="#"} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Protectall :\002 /msg $eva(pseudo) protectall #salon"; return 0 }
			putdcc $eva(idx) ":$eva(link) NAMES $value1"
			if {[eva:console 1]=="ok" && $value2!=[string tolower $eva(salon)]} { putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Protectall $eva(console_deco):$eva(console_txt) $value1 par $user" }
		}
		"deprotectall" {
			set eva(cmd) "deprotectall"
			if {[string index $value1 0]!="#"} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Deprotectall :\002 /msg $eva(pseudo) deprotectall #salon"; return 0 }
			putdcc $eva(idx) ":$eva(link) NAMES $value1"
			if {[eva:console 1]=="ok" && $value2!=[string tolower $eva(salon)]} { putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Deprotectall $eva(console_deco):$eva(console_txt) $value1 par $user" }
		}
		"op" {
			if {[string index $value1 0]!="#"} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Op :\002 /msg $eva(pseudo) op #salon pseudo"; return 0 }
			if {$value4==[string tolower $eva(pseudo)] || [info exists ueva($value4)] || [eva:protection $value4 $eva(protection)]=="ok"} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $user :Accès Refusé : Pseudo Protégé"; return 0 }
			if {$value4!=""} {
				if {![info exists vhost($value4)]} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Pseudo introuvable."; return 0 }
				putdcc $eva(idx) ":$eva(pseudo) MODE $value1 +o $value3"
				if {[eva:console 1]=="ok" && $value2!=[string tolower $eva(salon)]} { putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Op $eva(console_deco):$eva(console_txt) $value3 a été opé par $user sur $value1" }
			} else {
				putdcc $eva(idx) ":$eva(pseudo) MODE $value1 +o $user"
				if {[eva:console 1]=="ok" && $value2!=[string tolower $eva(salon)]} { putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Op $eva(console_deco):$eva(console_txt) $user a été opé sur $value1" }
			}
		}
		"deop" {
			if {[string index $value1 0]!="#"} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Deop :\002 /msg $eva(pseudo) deop #salon pseudo"; return 0 }
			if {$value4==[string tolower $eva(pseudo)] || [info exists ueva($value4)] || [eva:protection $value4 $eva(protection)]=="ok"} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $user :Accès Refusé : Pseudo Protégé"; return 0 }
			if {$value4!=""} {
				if {![info exists vhost($value4)]} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Pseudo introuvable."; return 0 }
				putdcc $eva(idx) ":$eva(pseudo) MODE $value1 -o $value3"
				if {[eva:console 1]=="ok" && $value2!=[string tolower $eva(salon)]} { putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Deop $eva(console_deco):$eva(console_txt) $value3 a été déopé par $user sur $value1" }
			} else {
				putdcc $eva(idx) ":$eva(pseudo) MODE $value1 -o $user"
				if {[eva:console 1]=="ok" && $value2!=[string tolower $eva(salon)]} { putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Deop $eva(console_deco):$eva(console_txt) $user a été déopé sur $value1" }
			}
		}
		"halfop" {
			if {[string index $value1 0]!="#"} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Halfop :\002 /msg $eva(pseudo) halfop #salon pseudo"; return 0 }
			if {$value4==[string tolower $eva(pseudo)] || [info exists ueva($value4)] || [eva:protection $value4 $eva(protection)]=="ok"} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $user :Accès Refusé : Pseudo Protégé"; return 0 }
			if {$value4!=""} {
				if {![info exists vhost($value4)]} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Pseudo introuvable."; return 0 }
				putdcc $eva(idx) ":$eva(pseudo) MODE $value1 +h $value3"
				if {[eva:console 1]=="ok" && $value2!=[string tolower $eva(salon)]} { putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Halfop $eva(console_deco):$eva(console_txt) $value3 a été halfopé par $user sur $value1" }
			} else {
				putdcc $eva(idx) ":$eva(pseudo) MODE $value1 +h $user"
				if {[eva:console 1]=="ok" && $value2!=[string tolower $eva(salon)]} { putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Halfop $eva(console_deco):$eva(console_txt) $user a été halfopé sur $value1" }
			}
		}
		"dehalfop" {
			if {[string index $value1 0]!="#"} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Dehalfop :\002 /msg $eva(pseudo) dehalfop #salon pseudo"; return 0 }
			if {$value4==[string tolower $eva(pseudo)] || [info exists ueva($value4)] || [eva:protection $value4 $eva(protection)]=="ok"} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $user :Accès Refusé : Pseudo Protégé"; return 0 }
			if {$value4!=""} {
				if {![info exists vhost($value4)]} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Pseudo introuvable."; return 0 }
				putdcc $eva(idx) ":$eva(pseudo) MODE $value1 -h $value3"
				if {[eva:console 1]=="ok" && $value2!=[string tolower $eva(salon)]} { putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Dehalfop $eva(console_deco):$eva(console_txt) $value3 a été déhalfopé par $user sur $value1" }
			} else {
				putdcc $eva(idx) ":$eva(pseudo) MODE $value1 -h $user"
				if {[eva:console 1]=="ok" && $value2!=[string tolower $eva(salon)]} { putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Dehalfop $eva(console_deco):$eva(console_txt) $user a été déhalfopé sur $value1" }
			}
		}
		"voice" {
			if {[string index $value1 0]!="#"} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Voice :\002 /msg $eva(pseudo) voice #salon pseudo"; return 0 }
			if {$value4==[string tolower $eva(pseudo)] || [info exists ueva($value4)] || [eva:protection $value4 $eva(protection)]=="ok"} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $user :Accès Refusé : Pseudo Protégé"; return 0 }
			if {$value4!=""} {
				if {![info exists vhost($value4)]} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Pseudo introuvable."; return 0 }
				putdcc $eva(idx) ":$eva(pseudo) MODE $value1 +v $value3"
				if {[eva:console 1]=="ok" && $value2!=[string tolower $eva(salon)]} { putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Voice $eva(console_deco):$eva(console_txt) $value3 a été voicé par $user sur $value1" }
			} else {
				putdcc $eva(idx) ":$eva(pseudo) MODE $value1 +v $user"
				if {[eva:console 1]=="ok" && $value2!=[string tolower $eva(salon)]} { putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Voice $eva(console_deco):$eva(console_txt) $user a été voicé sur $value1" }
			}
		}
		"devoice" {
			if {[string index $value1 0]!="#"} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Devoice :\002 /msg $eva(pseudo) devoice #salon pseudo"; return 0 }
			if {$value4==[string tolower $eva(pseudo)] || [info exists ueva($value4)] || [eva:protection $value4 $eva(protection)]=="ok"} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $user :Accès Refusé : Pseudo Protégé"; return 0 }
			if {$value4!=""} {
				if {![info exists vhost($value4)]} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Pseudo introuvable."; return 0 }
				putdcc $eva(idx) ":$eva(pseudo) MODE $value1 -v $value3"
				if {[eva:console 1]=="ok" && $value2!=[string tolower $eva(salon)]} { putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Devoice $eva(console_deco):$eva(console_txt) $value3 a été dévoicé par $user sur $value1" }
			} else {
				putdcc $eva(idx) ":$eva(pseudo) MODE $value1 -v $user"
				if {[eva:console 1]=="ok" && $value2!=[string tolower $eva(salon)]} { putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Devoice $eva(console_deco):$eva(console_txt) $user a été dévoicé sur $value1" }
			}
		}
		"opall" {
			set eva(cmd) "opall"

			if {[string index $value1 0]!="#"} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Opall :\002 /msg $eva(pseudo) opall #salon"; return 0 }

			putdcc $eva(idx) ":$eva(link) NAMES $value1"

			if {[eva:console 1]=="ok" && $value2!=[string tolower $eva(salon)]} { putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Opall $eva(console_deco):$eva(console_txt) $value1 par $user" }
		}
		"deopall" {
			set eva(cmd) "deopall"
			if {[string index $value1 0]!="#"} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Deopall :\002 /msg $eva(pseudo) deopall #salon"; return 0 }
			putdcc $eva(idx) ":$eva(link) NAMES $value1"
			if {[eva:console 1]=="ok" && $value2!=[string tolower $eva(salon)]} { putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Deopall $eva(console_deco):$eva(console_txt) $value1 par $user" }
		}
		"halfopall" {
			set eva(cmd) "halfopall"
			if {[string index $value1 0]!="#"} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Halfopall :\002 /msg $eva(pseudo) halfopall #salon"; return 0 }
			putdcc $eva(idx) ":$eva(link) NAMES $value1"
			if {[eva:console 1]=="ok" && $value2!=[string tolower $eva(salon)]} { putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Halfopall $eva(console_deco):$eva(console_txt) $value1 par $user" }
		}
		"dehalfopall" {
			set eva(cmd) "dehalfopall"
			if {[string index $value1 0]!="#"} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Dehalfopall :\002 /msg $eva(pseudo) dehalfopall #salon"; return 0 }
			putdcc $eva(idx) ":$eva(link) NAMES $value1"
			if {[eva:console 1]=="ok" && $value2!=[string tolower $eva(salon)]} { putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Dehalfopall $eva(console_deco):$eva(console_txt) $value1 par $user" }
		}
		"voiceall" {
			set eva(cmd) "voiceall"
			if {[string index $value1 0]!="#"} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Voiceall :\002 /msg $eva(pseudo) voiceall #salon"; return 0 }
			putdcc $eva(idx) ":$eva(link) NAMES $value1"
			if {[eva:console 1]=="ok" && $value2!=[string tolower $eva(salon)]} { putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Voiceall $eva(console_deco):$eva(console_txt) $value1 par $user" }
		}
		"devoiceall" {
			set eva(cmd) "devoiceall"
			if {[string index $value1 0]!="#"} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Devoiceall :\002 /msg $eva(pseudo) devoiceall #salon"; return 0 }
			putdcc $eva(idx) ":$eva(link) NAMES $value1"
			if {[eva:console 1]=="ok" && $value2!=[string tolower $eva(salon)]} { putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Devoiceall $eva(console_deco):$eva(console_txt) $value1 par $user" }
		}
		"kick" {
			if {[string index $value1 0]!="#" || $value4==""} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Kick :\002 /msg $eva(pseudo) kick #salon pseudo raison"; return 0 }
			if {$value4==[string tolower $eva(pseudo)] || [info exists ueva($value4)] || [eva:protection $value4 $eva(protection)]=="ok"} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $user :Accès Refusé : Pseudo Protégé"; return 0 }
			if {$value5==""} { set value5 "Kicked" }
			putdcc $eva(idx) ":$eva(pseudo) KICK $value2 $value4 $value5 [eva:rnick $user]"
			if {[eva:console 1]=="ok" && $value2!=[string tolower $eva(salon)]} { putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Kick $eva(console_deco):$eva(console_txt) $value3 a été kické par $user sur $value1 - Raison : $value5" }
		}
		"kickall" {
			set eva(cmd) "kickall"; set eva(rep) $user
			if {[string index $value1 0]!="#"} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Kickall :\002 /msg $eva(pseudo) kickall #salon"; return 0 }
			putdcc $eva(idx) ":$eva(link) NAMES $value1"
			if {[eva:console 1]=="ok" && $value2!=[string tolower $eva(salon)]} { putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Kickall $eva(console_deco):$eva(console_txt) $value1 par $user" }
		}
		"ban" {
			if {[string index $value1 0]!="#" || $value3==""} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Ban :\002 /msg $eva(pseudo) ban #salon mask"; return 0 }
			putdcc $eva(idx) ":$eva(pseudo) MODE $value1 +b $value3"
			if {[eva:console 1]=="ok" && $value2!=[string tolower $eva(salon)]} { putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Ban $eva(console_deco):$eva(console_txt) $value3 a été banni par $user sur $value1" }
		}
		"nickban" {
			if {[string index $value1 0]!="#" || $value3==""} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Nickban :\002 /msg $eva(pseudo) nickban #salon pseudo raison"; return 0 }
			if {$value4==[string tolower $eva(pseudo)] || [info exists ueva($value4)] || [eva:protection $value4 $eva(protection)]=="ok"} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $user :Accès Refusé : Pseudo Protégé"; return 0 }
			if {![info exists vhost($value4)]} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Pseudo introuvable."; return 0 }
			if {$value5==""} { set value5 "Nick Banned" }
			putdcc $eva(idx) ":$eva(pseudo) MODE $value1 +b $value4*!*@*"
       			putdcc $eva(idx) ":$eva(pseudo) KICK $value1 $value3 $value5 [eva:rnick $user]"
			if {[eva:console 1]=="ok" && $value2!=[string tolower $eva(salon)]} { putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Nickban $eva(console_deco):$eva(console_txt) $value3 a été banni par $user sur $value1 - Raison : $value5" }
		}
		"kickban" {
			if {[string index $value1 0]!="#" || $value3==""} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Kickban :\002 /msg $eva(pseudo) kickban #salon pseudo raison"; return 0 }
			if {$value4==[string tolower $eva(pseudo)] || [info exists ueva($value4)] || [eva:protection $value4 $eva(protection)]=="ok"} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $user :Accès Refusé : Pseudo Protégé"; return 0 }
			if {![info exists vhost($value4)]} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Pseudo introuvable."; return 0 }
			if {$value5==""} { set value5 "Kick Banned" }
			putdcc $eva(idx) ":$eva(pseudo) MODE $value1 +b *!*@$vhost($value4)"
       			putdcc $eva(idx) ":$eva(pseudo) KICK $value1 $value3 $value5 [eva:rnick $user]"
			if {[eva:console 1]=="ok" && $value2!=[string tolower $eva(salon)]} { putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Kickban $eva(console_deco):$eva(console_txt) $value3 a été banni par $user sur $value1 - Raison : $value5" }
		}
		"unban" {
			if {[string index $value1 0]!="#" || $value3==""} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Unban :\002 /msg $eva(pseudo) unban #salon mask"; return 0 }
			putdcc $eva(idx) ":$eva(pseudo) MODE $value1 -b $value3"
			if {[eva:console 1]=="ok" && $value2!=[string tolower $eva(salon)]} { putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Unban $eva(console_deco):$eva(console_txt) $value3 a été débanni par $user sur $value1" }
		}
		"clearbans" {
			if {[string index $value1 0]!="#"} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Clearbans :\002 /msg $eva(pseudo) clearbans #salon"; return 0 }
			putdcc $eva(idx) ":$eva(pseudo) SVSMODE $value1 -b"
			if {[eva:console 1]=="ok" && $value2!=[string tolower $eva(salon)]} { putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Clearbans $eva(console_deco):$eva(console_txt) $value1 par $user" }
		}
		"topic" {
			if {[string index $value1 0]!="#" || $value6==""} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Topic :\002 /msg $eva(pseudo) topic #salon topic"; return 0 }
			putdcc $eva(idx) ":$eva(pseudo) TOPIC $value1 :$value6"
			if {[eva:console 1]=="ok" && $value2!=[string tolower $eva(salon)]} { putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Topic $eva(console_deco):$eva(console_txt) $user change le topic sur $value1 : $value6" }
		}
		"mode" {
			if {[string index $value1 0]!="#" || $value3==""} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Mode :\002 /msg $eva(pseudo) mode #salon +/-mode"; return 0 }
			if {$value2==[string tolower $eva(salon)]} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $user :Accès Refusé"; return 0 }
			if {![regexp ^\[\+\-\]+\[a-zA-Z\]+$ $value3]} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $user :Chanmode Incorrect"; return 0 }
			if {[string match *q* $value3] || [string match *a* $value3] ||[string match *o* $value3] ||[string match *h* $value3] ||[string match *v* $value3]} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $user :Chanmode Refusé"; return 0 }
			putdcc $eva(idx) ":$eva(pseudo) MODE $value1 $value6"
			if {[eva:console 1]=="ok" && $value2!=[string tolower $eva(salon)]} { putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Mode $eva(console_deco):$eva(console_txt) $user applique le mode $value6 sur $value1" }
		}
		"clearmodes" {
			if {[string index $value1 0]!="#"} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Clearmodes :\002 /msg $eva(pseudo) clearmodes #salon"; return 0 }
			if {$value2==[string tolower $eva(salon)]} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $user :Accès Refusé"; return 0 }
			putdcc $eva(idx) ":$eva(pseudo) MODE $value1"
		  	if {[eva:console 1]=="ok" && $value2!=[string tolower $eva(salon)]} { putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Clearmodes $eva(console_deco):$eva(console_txt) $user sur $value1" }
		}
		"clearallmodes" {
			if {[string index $value1 0]!="#"} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Clearallmodes :\002 /msg $eva(pseudo) clearallmodes #salon"; return 0 }
			if {$value2==[string tolower $eva(salon)]} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $user :Accès Refusé"; return 0 }
			putdcc $eva(idx) ":$eva(pseudo) SVSMODE $value1 -beIqaohv"
			putdcc $eva(idx) ":$eva(pseudo) MODE $value1"
			putdcc $eva(idx) ":$eva(pseudo) SVSMODE $value1 -b"
		  	if {[eva:console 1]=="ok"} { putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Clearallmodes $eva(console_deco):$eva(console_txt) $user sur $value1" }
		}
		"kill" {
			if {$value1==""} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Kill :\002 /msg $eva(pseudo) kill pseudo raison"; return 0 }
			if {$value2==[string tolower $eva(pseudo)] || [info exists ueva($value2)] || [eva:protection $value2 $eva(protection)]=="ok"} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $user :Accès Refusé : Pseudo Protégé"; return 0 }
			if {![info exists vhost($value2)]} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Pseudo introuvable."; return 0 }
			if {$value6==""} { set value6 "Killed" }
			putdcc $eva(idx) ":$eva(pseudo) KILL $value1 $value6 [eva:rnick $user]"; eva:refresh $value2
			if {[eva:console 1]=="ok"} { putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Kill $eva(console_deco):$eva(console_txt) $value1 a été killé par $user : $value6" }
		}
		"chankill" {
			set eva(cmd) "chankill"; set eva(rep) $user
			if {[string index $value1 0]!="#"} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Chankill :\002 /msg $eva(pseudo) chankill #salon"; return 0 }
			if {$value2==[string tolower $eva(salon)]} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $user :Accès Refusé"; return 0 }
			putdcc $eva(idx) ":$eva(link) NAMES $value1"
			if {[eva:console 1]=="ok"} { putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Chankill $eva(console_deco):$eva(console_txt) $value1 par $user" }
		}
		"svsjoin" {
			if {[string index $value1 0]!="#" || $value3==""} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Svsjoin :\002 /msg $eva(pseudo) svsjoin #salon pseudo"; return 0 }
			if {![info exists vhost($value4)]} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Pseudo introuvable."; return 0 }
			if {$value4==[string tolower $eva(pseudo)] || [info exists ueva($value4)] || [eva:protection $value4 $eva(protection)]=="ok"} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $user :Accès Refusé : Pseudo Protégé"; return 0 }
			putdcc $eva(idx) ":$eva(pseudo) SVSJOIN $value3 $value1"
			if {[eva:console 1]=="ok"} { putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Svsjoin $eva(console_deco):$eva(console_txt) $value3 entre sur $value1 par $user" }
		}
		"svspart" {
			if {[string index $value1 0]!="#" || $value3==""} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Svspart :\002 /msg $eva(pseudo) svspart #salon pseudo"; return 0 }
			if {![info exists vhost($value4)]} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Pseudo introuvable."; return 0 }
			if {$value4==[string tolower $eva(pseudo)] || [info exists ueva($value4)] || [eva:protection $value4 $eva(protection)]=="ok"} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $user :Accès Refusé : Pseudo Protégé"; return 0 }
			putdcc $eva(idx) ":$eva(pseudo) SVSPART $value3 $value1"
			if {[eva:console 1]=="ok"} { putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Svspart $eva(console_deco):$eva(console_txt) $value3 part de $value1 par $user" }
		}
		"svsnick" {
			if {$value1=="" || $value3==""} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Svsnick :\002 /msg $eva(pseudo) svsnick ancien-pseudo nouveau-pseudo"; return 0 }
			if {$value2==$value4} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Pseudo Identique."; return 0 }
			if {$value2==[string tolower $eva(pseudo)] || $value4==[string tolower $eva(pseudo)] || [info exists ueva($value2)] || [info exists ueva($value4)] || [eva:protection $value2 $eva(protection)]=="ok" || [eva:protection $value4 $eva(protection)]=="ok"} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $user :Accès Refusé : Pseudo Protégé"; return 0 }
			if {![info exists vhost($value2)]} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Pseudo introuvable ($value1)."; return 0 }
			if {[info exists vhost($value4)]} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Pseudo existant ($value3)."; return 0 }
			putdcc $eva(idx) ":$eva(link) SVSNICK $value1 $value3 [unixtime]"
			if {[eva:console 1]=="ok"} { putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Svsnick $eva(console_deco):$eva(console_txt) $user change le pseudo de $value1 en $value3" }
		}
		"say" {
			if {[string index $value1 0]!="#" || $value6==""} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Say :\002 /msg $eva(pseudo) say #salon message"; return 0 }
			putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $value1 :$value6"
			if {[eva:console 1]=="ok" && $value2!=[string tolower $eva(salon)]} { putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Say $eva(console_deco):$eva(console_txt) $user sur $value1 : $value6" }
		}
		"invite" {
			if {[string index $value1 0]!="#" || $value3==""} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Invite :\002 /msg $eva(pseudo) invite #salon pseudo"; return 0 }
			if {![info exists vhost($value4)]} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Pseudo introuvable."; return 0 }
			putdcc $eva(idx) ":$eva(pseudo) INVITE $value3 $value1"
			if {[eva:console 1]=="ok"} { putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Invite $eva(console_deco):$eva(console_txt) $user invite $value3 sur $value1" }
		}
		"inviteme" {
			putdcc $eva(idx) ":$eva(pseudo) INVITE $user $eva(salon)"
			if {[eva:console 1]=="ok"} { putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Inviteme $eva(console_deco):$eva(console_txt) $user" }
		}
		"wallops" {
			if {$value7==""} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Wallops :\002 /msg $eva(pseudo) wallops message"; return 0 }
			putdcc $eva(idx) ":$eva(pseudo) WALLOPS $value7 ($user)"
			if {[eva:console 1]=="ok"} { putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Wallops $eva(console_deco):$eva(console_txt) $user : $value7" }
		}
		"globops" {
			if {$value7==""} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Globops :\002 /msg $eva(pseudo) globops message"; return 0 }
			putdcc $eva(idx) ":$eva(pseudo) GLOBOPS $value7 ($user)"
			if {[eva:console 1]=="ok"} { putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Globops $eva(console_deco):$eva(console_txt) $user : $value7" }
		}
		"notice" {
			if {$value7==""} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Notice :\002 /msg $eva(pseudo) notice message"; return 0 }
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $*.* :\[Notice Globale\] $value7"
			if {[eva:console 1]=="ok"} { putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Notice $eva(console_deco):$eva(console_txt) $user" }
		}
		"whois" {
			set eva(rep) $vuser
			if {$value1==""} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Whois :\002 /msg $eva(pseudo) whois pseudo"; return 0 }
			if {![info exists vhost($value2)]} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Pseudo introuvable."; return 0 }
			putdcc $eva(idx) ":$eva(pseudo) WHOIS $value1"
			if {[eva:console 1]=="ok"} { putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Whois $eva(console_deco):$eva(console_txt) $user" }
		}
		"changline" {
			set eva(cmd) "changline"; set eva(rep) $user
			if {[string index $value1 0]!="#"} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Changline :\002 /msg $eva(pseudo) changline #salon"; return 0 }
			if {$value2==[string tolower $eva(salon)]} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $user :Accès Refusé"; return 0 }
			putdcc $eva(idx) ":$eva(link) NAMES $value1"
			if {[eva:console 1]=="ok"} { putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Changline $eva(console_deco):$eva(console_txt) $value1 par $user" }
		}
		"gline" {
			if {$value1==""} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Gline :\002 /msg $eva(pseudo) <gline ou ip> pseudo raison"; return 0 }
			if {$value2==[string tolower $eva(pseudo)] || [info exists ueva($value2)] || [eva:protection $value2 $eva(protection)]=="ok"} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $user :Accès Refusé : Pseudo Protégé"; return 0 }
			if {$value6==""} { set value6 "Glined" }
			if {[info exists vhost($value2)]} {
					putdcc $eva(idx) ":$eva(link) TKL + G * $vhost($value2) $eva(pseudo) [expr [unixtime] + $eva(duree)] [unixtime] : $value6 [eva:rnick $user] (Expire le [eva:duree [expr [unixtime] + $eva(duree)]])"
		  } elseif {[string match *.* $value1]} {
					putdcc $eva(idx) ":$eva(link) TKL + G * $value1 $eva(pseudo) [expr [unixtime] + $eva(duree)] [unixtime] : $value6 [eva:rnick $user] (Expire le [eva:duree [expr [unixtime] + $eva(duree)]])"
			} else {
					putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Pseudo introuvable."; return 0
			}
			if {[eva:console 1]=="ok"} { putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Gline $eva(console_deco):$eva(console_txt) $value1 par $user - Raison : $value6" }
		}
		"ungline" {
			if {$value1=="" ||![string match *@* $value1]} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Ungline :\002 /msg $eva(pseudo) ungline ident@host"; return 0 }
			putdcc $eva(idx) ":$eva(link) TKL - G [lindex [split $value1 @] 0] [lindex [split $value1 @] 1] $eva(pseudo)"
			if {[eva:console 1]=="ok"} { putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Ungline $eva(console_deco):$eva(console_txt) $value1 par $user" }
		}
		"shun" {
			if {$value1==""} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Shun :\002 /msg $eva(pseudo) shun <pseudo ou ip> raison"; return 0 }
			if {$value2==[string tolower $eva(pseudo)] || [info exists ueva($value2)] || [eva:protection $value2 $eva(protection)]=="ok"} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $user :Accès Refusé : Pseudo Protégé"; return 0 }
			if {$value6==""} { set value6 "Shun" }
			if {[info exists vhost($value2)]} {
					putdcc $eva(idx) ":$eva(link) TKL + s * $vhost($value2) $eva(pseudo) [expr [unixtime] + $eva(duree)] [unixtime] : $value6 [eva:rnick $user] (Expire le [eva:duree [expr [unixtime] + $eva(duree)]])"
			} elseif {[string match *.* $value1]} {
					putdcc $eva(idx) ":$eva(link) TKL + s * $value1 $eva(pseudo) [expr [unixtime] + $eva(duree)] [unixtime] : $value6 [eva:rnick $user] (Expire le [eva:duree [expr [unixtime] + $eva(duree)]])"
			} else {
					putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Pseudo introuvable."; return 0
			}
			if {[eva:console 1]=="ok"} { putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Shun $eva(console_deco):$eva(console_txt) $value1 par $user - Raison : $value6" }
		}
		"unshun" {
			if {$value1=="" ||![string match *@* $value1]} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Unshun :\002 /msg $eva(pseudo) unshun ident@host"; return 0 }
			putdcc $eva(idx) ":$eva(link) TKL - s [lindex [split $value1 @] 0] [lindex [split $value1 @] 1] $eva(pseudo)"
			if {[eva:console 1]=="ok"} { putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Unshun $eva(console_deco):$eva(console_txt) $value1 par $user" }
		}
		"kline" {
			if {$value1==""} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Kline :\002 /msg $eva(pseudo) kline <pseudo ou ip> raison"; return 0 }
			if {$value2==[string tolower $eva(pseudo)] || [info exists ueva($value2)] || [eva:protection $value2 $eva(protection)]=="ok"} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $user :Accès Refusé : Pseudo Protégé"; return 0 }
			if {$value6==""} { set value6 "Klined" }
			if {[info exists vhost($value2)]} {
					putdcc $eva(idx) ":$eva(link) TKL + k * $vhost($value2) $eva(pseudo) [expr [unixtime] + $eva(duree)] [unixtime] : $value6 [eva:rnick $user] (Expire le [eva:duree [expr [unixtime] + $eva(duree)]])"
			} elseif {[string match *.* $value1]} {
					putdcc $eva(idx) ":$eva(link) TKL + k * $value1 $eva(pseudo) [expr [unixtime] + $eva(duree)] [unixtime] : $value6 [eva:rnick $user] (Expire le [eva:duree [expr [unixtime] + $eva(duree)]])"
			} else {
					putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Pseudo introuvable."; return 0
			}
			if {[eva:console 1]=="ok"} { putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Kline $eva(console_deco):$eva(console_txt) $value1 par $user - Raison : $value6" }
		}
		"unkline" {
			if {$value1=="" || ![string match *@* $value1]} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Unkline :\002 /msg $eva(pseudo) unkline ident@host"; return 0 }
			putdcc $eva(idx) ":$eva(link) TKL - k [lindex [split $value1 @] 0] [lindex [split $value1 @] 1] $eva(pseudo)"
			if {[eva:console 1]=="ok"} { putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Unkline $eva(console_deco):$eva(console_txt) $value1 par $user" }
		}
		"glinelist" {
			set eva(cmd) "gline"; set eva(rep) $vuser
			putdcc $eva(idx) ":$eva(pseudo) STATS G"
			if {[eva:console 1]=="ok"} { putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Glinelist $eva(console_deco):$eva(console_txt) $user" }
		}
		"shunlist" {
			set eva(cmd) "shun"; set eva(rep) $vuser
			putdcc $eva(idx) ":$eva(pseudo) STATS s"
			if {[eva:console 1]=="ok"} { putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Shunlist $eva(console_deco):$eva(console_txt) $user" }
		}
		"klinelist" {
			set eva(cmd) "kline"; set eva(rep) $vuser
			putdcc $eva(idx) ":$eva(pseudo) STATS K"
			if {[eva:console 1]=="ok"} { putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Klinelist $eva(console_deco):$eva(console_txt) $user" }
		}
		"cleargline" {
			set eva(cmd) "cleargline"
			putdcc $eva(idx) ":$eva(pseudo) STATS G"
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Liste des glines vidée."
			if {[eva:console 1]=="ok"} { putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Cleargline $eva(console_deco):$eva(console_txt) $user" }
		}
		"clearkline" {
			set eva(cmd) "clearkline"
			putdcc $eva(idx) ":$eva(pseudo) STATS K"
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Liste des klines vidée."
			if {[eva:console 1]=="ok"} { putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Clearkline $eva(console_deco):$eva(console_txt) $user" }
		}
		"clientlist" {
			catch {open "[eva:scriptdir]db/client.db" r} liste
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :1,1------ 0Liste des clients IRC interdits 1------"
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :"
			while {![eof $liste]} { gets $liste version; if {$version!=""} { incr stop 1; putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :01 \[03 $stop 01\] 01 $version" } }
			catch {close $liste}
			if {$stop=="0"} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Aucun client IRC" }
			if {[eva:console 1]=="ok"} { putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Clientlist $eva(console_deco):$eva(console_txt) $user" }
		}
		"addclient" {
			if {$value7==""} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Addclient :\002 /msg $eva(pseudo) addclient version"; return 0 }
			catch {open "[eva:scriptdir]db/client.db" r} liste
			while {![eof $liste]} { gets $liste verif; if {![string compare -nocase $value7 $verif]} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :$value7 est déjà dans la liste des clients IRC interdits."; set stop "1"; break } }
			catch {close $liste}; if {$stop=="1"} { return 0 }
			set bclient [open "[eva:scriptdir]db/client.db" a]; puts $bclient [string tolower $value7]; close $bclient
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :$value7 a bien été ajouté à la liste des clients IRC interdits."
			if {[eva:console 1]=="ok"} { putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Addclient $eva(console_deco):$eva(console_txt) $user" }
		}
		"delclient" {
			if {$value7==""} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Delclient :\002 /msg $eva(pseudo) delclient version"; return 0 }
			catch {open "[eva:scriptdir]db/client.db" r} liste
			while {![eof $liste]} { gets $liste verif; if {![string compare -nocase $value7 $verif]} { set stop "1" }; if {[string compare -nocase $value7 $verif] && $verif!=""} { lappend vers "$verif" } }
			catch {close $liste}
			if {$stop=="0"} {
				putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :$value7 n'est pas dans la liste des clients IRC interdits."; return 0
			} else {
				if [info exists vers] {
					set del [open "[eva:scriptdir]db/client.db" w+]; foreach delclient $vers { puts $del "$delclient" }; close $del
				} else { set del [open "[eva:scriptdir]db/client.db" w+]; close $del }
				putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :$value7 a bien été supprimé de la liste des clients IRC interdits."
				if {[eva:console 1]=="ok"} { putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Delclient $eva(console_deco):$eva(console_txt) $user" }
			}
		}
		"addsecu" {
			if {[string index $value2 0]!="#"} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Addsecu :\002 /msg $eva(pseudo) addsecu #salon"; return 0 }
			if {$value2==[string tolower $eva(salon)]} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Accès Refusé : Salon de logs"; return 0 }
			catch {open "[eva:scriptdir]db/salon.db" r} liste1
			while {![eof $liste1]} { gets $liste1 verif1; if {![string compare -nocase $value2 $verif1]} {  putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Accès Refusé : Salon Interdit"; set stop "1"; break } }
			catch {close $liste1}; if {$stop==1} { return 0 }
			catch {open "[eva:scriptdir]db/close.db" r} liste2
			while {![eof $liste2]} { gets $liste2 verif2; if {![string compare -nocase $value2 $verif2]} {  putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Accès Refusé : Salon Fermé"; set stop "1"; break } }
			catch {close $liste2}; if {$stop==1} { return 0 }
			catch {open "[eva:scriptdir]db/secu.db" r} liste
			while {![eof $liste]} { gets $liste verif; if {![string compare -nocase $value2 $verif]} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :$value1 est déjà dans la liste des salons sécurisés."; set stop "1"; break } }
			catch {close $liste}; if {$stop==1} { return 0 }
			set join [open "[eva:scriptdir]db/secu.db" a]; puts $join $value2; close $join
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :$value1 a bien été ajouté dans la liste des salons sécurisés."
			if {[info exists eva(maxthrottle)]} { putdcc $eva(idx) ":$eva(pseudo) MODE $value1 +smi" }
			if {[eva:console 1]=="ok"} { putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Addsecu $eva(console_deco):$eva(console_txt) $user" }
		}
		"delsecu" {
			if {[string index $value2 0]!="#"} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Delsecu :\002 /msg $eva(pseudo) delsecu #salon"; return 0 }
			if {$value2==[string tolower $eva(salon)]} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Accès Refusé"; return 0 }
			catch {open "[eva:scriptdir]db/secu.db" r} liste
			while {![eof $liste]} { gets $liste verif; if {![string compare -nocase $value2 $verif]} { set stop 1 }; if {[string compare -nocase $value2 $verif] && $verif!=""} { lappend salle "$verif" } }
			catch {close $liste}
			if {$stop==0} {
				putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :$value1 n'est pas dans la liste des salons sécurisés."; return 0
			} else {
				if {[info exists salle]} {
					set del [open "[eva:scriptdir]db/secu.db" w+]; foreach delchan $salle { puts $del "$delchan" }; close $del
				} else { set del [open "[eva:scriptdir]db/secu.db" w+]; close $del }
				putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :$value1 a bien été supprimé de la liste des salons sécurisés."
				if {[info exists eva(maxthrottle)]} { putdcc $eva(idx) ":$eva(pseudo) MODE $value1 -smi" }
				if {[eva:console 1]=="ok"} { putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Delsecu $eva(console_deco):$eva(console_txt) $user" }
			}
		}
		"seculist" {
			catch {open "[eva:scriptdir]db/secu.db" r} liste
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :1,1-------- 0Salons Sécurisés 1--------"
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :"
			while {![eof $liste]} { gets $liste salon; if {$salon!=""} { incr stop 1; putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :01 \[03 $stop 01\] 01 $salon" } }
			catch {close $liste}
			if {$stop=="0"} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Aucun Salon" }
			if {[eva:console 1]=="ok"} { putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Seculist $eva(console_deco):$eva(console_txt) $user" }
		}
		"secu" {
			if {$value2!="on" && $value2!="off"} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Secu :\002 /msg $eva(pseudo) secu on/off"; return 0 }
			if {$value2=="on"} {
				if {$eva(secu)=="0"} {
					set eva(secu) "1"; putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Système de sécurité des salons activé"
					if {[eva:console 1]=="ok"} { putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Secu $eva(console_deco):$eva(console_txt) $user" }
				} else { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Le système de sécurité des salons est déjà activé." }
			} elseif {$value2=="off"} {
				if {$eva(secu)=="1"} {
					set eva(secu) "0"; putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Système de sécurité des salons désactivé"
					if {[eva:console 1]=="ok"} { putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Secu $eva(console_deco):$eva(console_txt) $user" }
				} else { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Le système de sécurité des salons est déjà désactivé." }
			}
		}
		"client" {
			if {$value2!="on" && $value2!="off"} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Client :\002 /msg $eva(pseudo) client on/off"; return 0 }
			if {$value2=="on"} {
				if {$eva(aclient)=="0"} {
					set eva(aclient) "1"; putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Protection clients IRC activée"
					if {[eva:console 1]=="ok"} { putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Client $eva(console_deco):$eva(console_txt) $user" }
				} else { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :La protection clients IRC est déjà activée." }
			} elseif {$value2=="off"} {
				if {$eva(aclient)=="1"} {
					set eva(aclient) "0"; putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Protection clients IRC désactivée"
					if {[eva:console 1]=="ok"} { putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Client $eva(console_deco):$eva(console_txt) $user" }
				} else { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :La protection clients IRC est déjà désactivée." }
			}
		}
		"clone" {
			if {$value2!="on" && $value2!="off"} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Clone :\002 /msg $eva(pseudo) clone on/off"; return 0 }
			if {$value2=="on"} {
				if {$eva(aclone)=="0"} {
					set eva(aclone) "1"; putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Protection clone activée"
					if {[eva:console 1]=="ok"} { putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Clone $eva(console_deco):$eva(console_txt) $user" }
				} else { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :La protection clone est déjà activée." }
			} elseif {$value2=="off"} {
				if {$eva(aclone)=="1"} {
					set eva(aclone) "0"; putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Protection clone désactivée"
					if {[eva:console 1]=="ok"} { putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Clone $eva(console_deco):$eva(console_txt) $user" }
				} else { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :La protection clone est déjà désactivée." }
			}
		}
		"close" {
			set eva(cmd) "close"; set eva(rep) $user
			if {[string index $value1 0]!="#"} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Close :\002 /msg $eva(pseudo) close #salon"; return 0 }
			if {$value2==[string tolower $eva(salon)]} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $user :Accès Refusé : Salon de logs"; return 0 }
			catch {open "[eva:scriptdir]db/salon.db" r} liste1
			while {![eof $liste1]} { gets $liste1 verif1; if {![string compare -nocase $value2 $verif1]} {  putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Accès Refusé : Salon Interdit"; set stop "1"; break } }
			catch {close $liste1}; if {$stop==1} { return 0 }
			catch {open "[eva:scriptdir]db/secu.db" r} liste2
			while {![eof $liste2]} { gets $liste2 verif2; if {![string compare -nocase $value2 $verif2]} {  putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Accès Refusé : Salon Sécurisé"; set stop "1"; break } }
			catch {close $liste2}; if {$stop==1} { return 0 }
			catch {open "[eva:scriptdir]db/chan.db" r} liste3
			while {![eof $liste3]} { gets $liste3 verif3; if {![string compare -nocase $value2 $verif3]} {  putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Accès Refusé : Salon Autojoin"; set stop "1"; break } }
			catch {close $liste3}; if {$stop==1} { return 0 }
			catch {open "[eva:scriptdir]db/close.db" r} liste
			while {![eof $liste]} { gets $liste verif; if {![string compare -nocase $value2 $verif]} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :$value1 est déjà dans la liste des salons fermés."; set stop "1"; break } }
			catch {close $liste}; if {$stop==1} { return 0 }
			set bclose [open "[eva:scriptdir]db/close.db" a]; puts $bclose $value2; close $bclose
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :$value1 vient d'être ajouté dans la liste des salons fermés."
			putdcc $eva(idx) ":$eva(pseudo) JOIN $value1"; putdcc $eva(idx) ":$eva(pseudo) MODE $value1 +sntio $eva(pseudo)"; putdcc $eva(idx) ":$eva(pseudo) TOPIC $value1 :1Salon Fermé le [eva:duree [unixtime]]"
			putdcc $eva(idx) ":$eva(link) NAMES $value1"
			if {[eva:console 1]=="ok"} { putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Close $eva(console_deco):$eva(console_txt) $value1 par $user" }
		}
		"unclose" {
			if {[string index $value1 0]!="#"} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Unclose :\002 /msg $eva(pseudo) unclose #salon"; return 0 }
			catch {open "[eva:scriptdir]db/close.db" r} liste
			while {![eof $liste]} { gets $liste verif; if {![string compare -nocase $value2 $verif]} { set stop 1 }; if {[string compare -nocase $value2 $verif] && $verif!=""} { lappend salon "$verif" } }
			catch {close $liste}
			if {$stop==0} {
				putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :$value1 n'est pas dans la liste des salons fermés."; return 0
			} else {
				if [info exists salon] {
					set del [open "[eva:scriptdir]db/close.db" w+]; foreach delchan $salon { puts $del "$delchan" }; close $del
				} else { set del [open "[eva:scriptdir]db/close.db" w+]; close $del }
				putdcc $eva(idx) ":$eva(pseudo) NOTICE $user :$value1 a bien été supprimé de la liste des salons fermés."
				putdcc $eva(idx) ":$eva(pseudo) MODE $value1"
				putdcc $eva(idx) ":$eva(pseudo) TOPIC $value1 :Bienvenue sur $value1"
				putdcc $eva(idx) ":$eva(pseudo) PART $value1"
				if {[eva:console 1]=="ok"} { putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Unclose $eva(console_deco):$eva(console_txt) $value1 par $user" }
			}
		}
		"closelist" {
			catch {open "[eva:scriptdir]db/close.db" r} liste
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :1,1------ 0Liste des salons fermés 1------"
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :"
			while {![eof $liste]} { gets $liste salon; if {$salon!=""} { incr stop 1; putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :1 \[03 $stop 01\] 01 $salon" } }
			catch {close $liste}
			if {$stop=="0"} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Aucun Salon." }
			if {[eva:console 1]=="ok"} { putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Closelist $eva(console_deco):$eva(console_txt) $user" }
		}
		"clearclose" {
			catch {open "[eva:scriptdir]db/close.db" r} liste
			while {![eof $liste]} {
				gets $liste salon
				if {$salon!=""} {
					putdcc $eva(idx) ":$eva(pseudo) MODE $salon"
					putdcc $eva(idx) ":$eva(pseudo) TOPIC $salon :Bienvenue sur $salon"
					putdcc $eva(idx) ":$eva(pseudo) PART $salon"
				}
			}
			catch {close $liste}
			set del [open "[eva:scriptdir]db/close.db" w+]; close $del
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $user :La liste des salons fermés à bien été vidée."
			if {[eva:console 1]=="ok"} { putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Clearclose $eva(console_deco):$eva(console_txt) $user" }
		}
		"addnick" {
			if {$value2==""} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Addnick :\002 /msg $eva(pseudo) addnick pseudo"; return 0 }
			if {[string match *$value2* [string tolower $eva(pseudo)]]} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $user :Accès Refusé : Pseudo Protégé"; return 0 }
			foreach {p n} [array get ueva] { if {[string match *$value2* $p]} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $user :Accès Refusé : Pseudo Protégé"; return 0 } }
			foreach {a r} [array get admins] { if {[string match *$value2* $r]} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $user :Accès Refusé : Pseudo Protégé"; return 0 } }
			catch {open "[eva:scriptdir]db/nick.db" r} liste
			while {![eof $liste]} { gets $liste verif; if {![string compare -nocase $value2 $verif]} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :$value1 est déjà dans la liste des pseudos interdits."; set stop "1"; break } }
			catch {close $liste}; if {$stop==1} { return 0 }
			set nick [open "[eva:scriptdir]db/nick.db" a]; puts $nick $value2; close $nick
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :$value1 a bien été ajouté dans la liste des pseudos interdits."
			if {[eva:console 1]=="ok"} { putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Addnick $eva(console_deco):$eva(console_txt) $user" }
		}
		"delnick" {
			if {$value2==""} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Delnick :\002 /msg $eva(pseudo) delnick pseudo"; return 0 }
			catch {open "[eva:scriptdir]db/nick.db" r} liste
			while {![eof $liste]} { gets $liste verif; if {![string compare -nocase $value2 $verif]} { set stop 1 }; if {[string compare -nocase $value2 $verif] && $verif!=""} { lappend pseudo "$verif" } }
			catch {close $liste}
			if {$stop==0} {
				putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :$value1 n'est pas dans la liste des pseudos interdits."; return 0
			} else {
				if {[info exists pseudo]} {
					set del [open "[eva:scriptdir]db/nick.db" w+]; foreach delnick $pseudo { puts $del "$delnick" }; close $del
				} else { set del [open "[eva:scriptdir]db/nick.db" w+]; close $del }
				putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :$value1 a bien été supprimé de la liste des pseudos interdits."
				if {[eva:console 1]=="ok"} { putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Delnick $eva(console_deco):$eva(console_txt) $user" }
			}
		}
		"nicklist" {
			catch {open "[eva:scriptdir]db/nick.db" r} liste
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :1,1--------- 0Pseudos Interdits 1---------"
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :"
			while {![eof $liste]} { gets $liste pseudo; if {$pseudo!=""} { incr stop 1; putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :01 \[03 $stop 01\] 01 $pseudo" } }
			catch {close $liste}
			if {$stop=="0"} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Aucun Pseudo" }
			if {[eva:console 1]=="ok"} { putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Nicklist $eva(console_deco):$eva(console_txt) $user" }
		}
		"addident" {
			if {$value2==""} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Addident :\002 /msg $eva(pseudo) addident ident"; return 0 }
			if {[string match *$value2* [string tolower $eva(ident)]]} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $user :Accès Refusé : Ident Protégé"; return 0 }
			catch {open "[eva:scriptdir]db/ident.db" r} liste
			while {![eof $liste]} { gets $liste verif; if {![string compare -nocase $value2 $verif]} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :$value1 est déjà dans la liste des idents interdits."; set stop "1"; break } }
			catch {close $liste}; if {$stop==1} { return 0 }
			set ident [open "[eva:scriptdir]db/ident.db" a]; puts $ident $value2; close $ident
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :$value1 a bien été ajouté dans la liste des idents interdits."
			if {[eva:console 1]=="ok"} { putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Addident $eva(console_deco):$eva(console_txt) $user" }
		}
		"delident" {
			if {$value2==""} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Delident :\002 /msg $eva(pseudo) delident ident"; return 0 }
			catch {open "[eva:scriptdir]db/ident.db" r} liste
			while {![eof $liste]} { gets $liste verif; if {![string compare -nocase $value2 $verif]} { set stop 1 }; if {[string compare -nocase $value2 $verif] && $verif!=""} { lappend ident "$verif" } }
			catch {close $liste}
			if {$stop==0} {
				putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :$value1 n'est pas dans la liste des idents interdits."; return 0
			} else {
				if {[info exists ident]} {
					set del [open "[eva:scriptdir]db/ident.db" w+]; foreach delident $ident { puts $del "$delident" }; close $del
				} else { set del [open "[eva:scriptdir]db/ident.db" w+]; close $del }
				putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :$value1 a bien été supprimé de la liste des idents interdits."
				if {[eva:console 1]=="ok"} { putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Delident $eva(console_deco):$eva(console_txt) $user" }
			}
		}
		"identlist" {
			catch {open "[eva:scriptdir]db/ident.db" r} liste
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :1,1---------- 0Idents Interdits 1----------"
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :"
			while {![eof $liste]} { gets $liste ident; if {$ident!=""} { incr stop 1; putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :01 \[03 $stop 01\] 01 $ident" } }
			catch {close $liste}
			if {$stop=="0"} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Aucun Ident" }
			if {[eva:console 1]=="ok"} { putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Identlist $eva(console_deco):$eva(console_txt) $user" }
		}
		"addreal" {
			if {$value2==""} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Addreal :\002 /msg $eva(pseudo) addreal realname"; return 0 }
			if {[string match *$value2* [string tolower $eva(real)]]} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $user :Accès Refusé : Realname Protégé"; return 0 }
			catch {open "[eva:scriptdir]db/real.db" r} liste
			while {![eof $liste]} { gets $liste verif; if {![string compare -nocase $value2 $verif]} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :$value1 est déjà dans la liste des realnames interdits."; set stop "1"; break } }
			catch {close $liste}; if {$stop==1} { return 0 }
			set real [open "[eva:scriptdir]db/real.db" a]; puts $real $value2; close $real
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :$value1 a bien été ajouté dans la liste des realnames interdits."
			if {[eva:console 1]=="ok"} { putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Addreal $eva(console_deco):$eva(console_txt) $user" }
		}
		"delreal" {
			if {$value2==""} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Delreal :\002 /msg $eva(pseudo) delreal realname"; return 0 }
			catch {open "[eva:scriptdir]db/real.db" r} liste
			while {![eof $liste]} { gets $liste verif; if {![string compare -nocase $value2 $verif]} { set stop 1 }; if {[string compare -nocase $value2 $verif] && $verif!=""} { lappend real "$verif" } }
			catch {close $liste}
			if {$stop==0} {
				putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :$value1 n'est pas dans la liste des realnames interdits."; return 0
			} else {
				if {[info exists real]} {
					set del [open "[eva:scriptdir]db/real.db" w+]; foreach delreal $real { puts $del "$delreal" }; close $del
				} else { set del [open "[eva:scriptdir]db/real.db" w+]; close $del }
				putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :$value1 a bien été supprimé de la liste des realnames interdits."
				if {[eva:console 1]=="ok"} { putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Delreal $eva(console_deco):$eva(console_txt) $user" }
			}
		}
		"reallist" {
			catch {open "[eva:scriptdir]db/real.db" r} liste
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :1,1--------- 0Realnames Interdits 1---------"
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :"
			while {![eof $liste]} { gets $liste real; if {$real!=""} { incr stop 1; putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :01 \[03 $stop 01\] 01 $real" } }
			catch {close $liste}
			if {$stop=="0"} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Aucun Realname" }
			if {[eva:console 1]=="ok"} { putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Reallist $eva(console_deco):$eva(console_txt) $user" }
		}
		"addhost" {
			if {$value2==""} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Addhost :\002 /msg $eva(pseudo) addhost hostname"; return 0 }
			if {[string match *$value2* [string tolower $eva(host)]] || [info exists protect($value2)]} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $user :Accès Refusé : Hostname Protégée"; return 0 }
			foreach {mask num} [array get trust] { if {[string match *$value2* $mask]} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $user :Accès Refusé : Hostname Trustée"; return 0 } }
			catch {open "[eva:scriptdir]db/host.db" r} liste
			while {![eof $liste]} { gets $liste verif; if {![string compare -nocase $value2 $verif]} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :$value1 est déjà dans la liste des hostnames interdites."; set stop "1"; break } }
			catch {close $liste}; if {$stop==1} { return 0 }
			set host [open "[eva:scriptdir]db/host.db" a]; puts $host $value2; close $host
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :$value1 a bien été ajouté dans la liste des hostnames interdites."
			if {[eva:console 1]=="ok"} { putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Addhost $eva(console_deco):$eva(console_txt) $user" }
		}
		"delhost" {
			if {$value2==""} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Delhost :\002 /msg $eva(pseudo) delhost hostname"; return 0 }
			catch {open "[eva:scriptdir]db/host.db" r} liste
			while {![eof $liste]} { gets $liste verif; if {![string compare -nocase $value2 $verif]} { set stop 1 }; if {[string compare -nocase $value2 $verif] && $verif!=""} { lappend host "$verif" } }
			catch {close $liste}
			if {$stop==0} {
				putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :$value1 n'est pas dans la liste des hostnames interdites."; return 0
			} else {
				if {[info exists host]} {
					set del [open "[eva:scriptdir]db/host.db" w+]; foreach delhost $host { puts $del "$delhost" }; close $del
				} else { set del [open "[eva:scriptdir]db/host.db" w+]; close $del }
				putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :$value1 a bien été supprimé de la liste des hostnames interdites."
				if {[eva:console 1]=="ok"} { putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Delhost $eva(console_deco):$eva(console_txt) $user" }
			}
		}
		"hostlist" {
			catch {open "[eva:scriptdir]db/host.db" r} liste
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :1,1----------- 0Hostnames Interdites 1-----------"
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :"
			while {![eof $liste]} { gets $liste host; if {$host!=""} { incr stop 1; putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :01 \[03 $stop 01\] 01 $host" } }
			catch {close $liste}
			if {$stop=="0"} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Aucune Hostname" }
			if {[eva:console 1]=="ok"} { putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Hostlist $eva(console_deco):$eva(console_txt) $user" }
		}
		"addchan" {
			if {[string index $value2 0]!="#"} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Addchan :\002 /msg $eva(pseudo) addchan #salon"; return 0 }
			if {[string match *[string trimleft $value2 #]* [string trimleft [string tolower $eva(salon)] #]]} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $user :Accès Refusé : Salon de logs"; return 0 }
			catch {open "[eva:scriptdir]db/chan.db" r} liste1
			while {![eof $liste1]} { gets $liste1 verif1; if {[string match *[string trimleft $value2 #]* [string trimleft $verif1 #]]} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Accès Refusé : Salon Autojoin"; set stop "1"; break } }
			catch {close $liste1}; if {$stop==1} { return 0 }
			catch {open "[eva:scriptdir]db/close.db" r} liste2
			while {![eof $liste2]} { gets $liste2 verif2; if {[string match *[string trimleft $value2 #]* [string trimleft $verif2 #]]} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Accès Refusé : Salon Fermé"; set stop "1"; break } }
			catch {close $liste2}; if {$stop==1} { return 0 }
			catch {open "[eva:scriptdir]db/secu.db" r} liste3
			while {![eof $liste3]} { gets $liste3 verif3; if {[string match *[string trimleft $value2 #]* [string trimleft $verif3 #]]} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Accès Refusé : Salon Sécurisé"; set stop "1"; break } }
			catch {close $liste3}; if {$stop==1} { return 0 }
			catch {open "[eva:scriptdir]db/salon.db" r} liste
			while {![eof $liste]} { gets $liste verif; if {![string compare -nocase $value2 $verif]} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :$value1 est déjà dans la liste des salons interdits."; set stop "1"; break } }
			catch {close $liste}; if {$stop==1} { return 0 }
			set chan [open "[eva:scriptdir]db/salon.db" a]; puts $chan $value2; close $chan
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :$value1 a bien été ajouté dans la liste des salons interdits."
			if {[eva:console 1]=="ok"} { putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Addchan $eva(console_deco):$eva(console_txt) $user" }
		}
		"delchan" {
			if {[string index $value2 0]!="#"} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Delchan :\002 /msg $eva(pseudo) delchan #salon"; return 0 }
			catch {open "[eva:scriptdir]db/salon.db" r} liste
			while {![eof $liste]} { gets $liste verif; if {![string compare -nocase $value2 $verif]} { set stop 1 }; if {[string compare -nocase $value2 $verif] && $verif!=""} { lappend chan "$verif" } }
			catch {close $liste}
			if {$stop==0} {
				putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :$value1 n'est pas dans la liste des salons interdits."; return 0
			} else {
				if {[info exists chan]} {
					set del [open "[eva:scriptdir]db/salon.db" w+]; foreach delchan $chan { puts $del "$delchan" }; close $del
				} else { set del [open "[eva:scriptdir]db/salon.db" w+]; close $del }
				putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :$value1 a bien été supprimé de la liste des salons interdits."
				if {[eva:console 1]=="ok"} { putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Delchan $eva(console_deco):$eva(console_txt) $user" }
			}
		}
		"chanlist" {
			catch {open "[eva:scriptdir]db/salon.db" r} liste
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :1,1--------- 0Salons Interdits 1---------"
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :"
			while {![eof $liste]} { gets $liste chan; if {$chan!=""} { incr stop 1; putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :01 \[03 $stop 01\] 01 $chan" } }
			catch {close $liste}
			if {$stop=="0"} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Aucun Salon" }
			if {[eva:console 1]=="ok"} { putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Chanlist $eva(console_deco):$eva(console_txt) $user" }
		}
		"addtrust" {
			if {$value2==""} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Addtrust :\002 /msg $eva(pseudo) addtrust mask"; return 0 }
			catch {open "[eva:scriptdir]db/host.db" r} liste1
			while {![eof $liste1]} { gets $liste1 verif1; if {[string match *$value2* $verif1]} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Accès Refusé : Hostname Interdite"; set stop "1"; break } }
			catch {close $liste1}; if {$stop==1} { return 0 }
			catch {open [eva:scriptdir]db/trust.db r} liste
			while {![eof $liste]} { gets $liste verif; if {$verif==$value2} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :$value1 est déjà dans la trustlist."; set stop "1"; break } }
			catch {close $liste}; if {$stop=="1"} { return 0 }
			set bprotect [open [eva:scriptdir]db/trust.db a]; puts $bprotect "$value2"; close $bprotect
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :$value1 a bien été ajoutée dans la trustlist."
			if {![info exists trust($value2)]} { set trust($value2) "1" }
			if {[eva:console 1]=="ok"} { putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Addtrust $eva(console_deco):$eva(console_txt) $user" }
		}
		"deltrust" {
			if {$value2==""} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Deltrust :\002 /msg $eva(pseudo) deltrust mask"; return 0 }
			catch {open [eva:scriptdir]db/trust.db r} liste
			while {![eof $liste]} { gets $liste verif; if {$verif==$value2} { set stop "1" }; if {$verif!=$value2 && $verif!=""} { lappend hs "$verif" } }
			catch {close $liste}
			if {$stop=="0"} {
				putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :$value1 n'est pas dans la trustlist."; return 0
			} else {
				if {[info exists hs]} {
					set del [open [eva:scriptdir]db/trust.db w+]; foreach delprotect $hs { puts $del "$delprotect" }; close $del
				} else { set del [open [eva:scriptdir]db/trust.db w+]; close $del }
				putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :$value1 a bien été supprimée de la trustlist."
				if {[info exists trust($value2)]} { unset trust($value2) }
				if {[eva:console 1]=="ok"} { putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Deltrust $eva(console_deco):$eva(console_txt) $user" }
			}
		}
		"trustlist" {
			catch {open [eva:scriptdir]db/trust.db r} liste
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :1,1----------------- 0Liste des Trusts 1-----------------"
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :"
			while {![eof $liste]} { gets $liste mask; if {$mask!=""} { incr stop 1; putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :01 \[03 $stop 01\] 01 $mask" } }
			catch {close $liste}
			if {$stop=="0"} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Aucun Trust" }
			if {[eva:console 1]=="ok"} { putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Trustlist $eva(console_deco):$eva(console_txt) $user" }
		}
		"addaccess" {
			if {$value2=="" || $value4=="" || $value8=="" || [regexp \[^1-4\] $value8]} {
				putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Addaccess :\002 /msg $eva(pseudo) addaccess pseudo password level"
				putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :02Level 1 04:01 Helpeur"
				putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :02Level 2 04:01 Géofront"
				putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :02Level 3 04:01 IRCop"
				putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :02Level 4 04:01 Admin"
				return 0
			}
			if {[string length $value2]>="10"} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Le pseudo doit contenir maximum 9 caractères."; return 0 }
			foreach verif [userlist] { if {[string tolower $value2]==[string tolower $verif]} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :$value1 est déja dans la liste des accès."; return 0 } }
			if {[string length $value4]<="5"} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Le mot de passe doit contenir minimum 6 caractères."; return 0 }
			adduser $value1; setuser $value1 PASS $value3; setuser $value1 HOSTS $value1*!*@*; setuser $value1 HOSTS -telnet!*@*
			switch -exact $value8 {
				"1" { chattr $value1 +p; set lvl "helpeurs" }
				"2" { chattr $value1 +op; set lvl "géofronts" }
				"3" { chattr $value1 +mop; set lvl "IRCops" }
				"4" { chattr $value1 +nmop; set lvl "Admins" }
			}
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :$value1 a bien été ajouté dans la liste des $lvl."
			if {[eva:console 1]=="ok"} { putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Addaccess $eva(console_deco):$eva(console_txt) $user" }
		}
		"delaccess" {
			if {$value1==""} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Delaccess :\002 /msg $eva(pseudo) delaccess pseudo"; return 0 }
			if {[string tolower $admin]==$value2} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Accès Refusé."; return 0 }
			foreach verif [userlist] {
				if {$value2==[string tolower $verif]} {
					foreach {pseudo auth} [array get admins] { if {[string tolower $auth]==$value2} { unset admins([string tolower $pseudo]) } }
					deluser $value2
					putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :$value1 a bien été supprimé de la liste des accès."
					if {[eva:console 1]=="ok"} { putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Delaccess $eva(console_deco):$eva(console_txt) $user" }
					return 0
				}
			}
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :$value1 n'est pas dans la liste des accès."
		}
		"modaccess" {
			if {$value2!="level" && $value2!="pass"} {
				putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Modaccess Pass :\002 /msg $eva(pseudo) modaccess pass pseudo mot-de-passe"
				putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Modaccess Level :\002 /msg $eva(pseudo) modaccess level pseudo level"
				return 0
			}
			switch -exact $value2 {
				"level" {
					if {$value4=="" || $value8=="" || [regexp \[^1-4\] $value8]} {
						putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Modaccess Level :\002 /msg $eva(pseudo) modaccess level pseudo level"
						putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :02Level 1 04:01 Helpeur"
						putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :02Level 2 04:01 Géofront"
						putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :02Level 3 04:01 IRCop"
						putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :02Level 4 04:01 Admin"
						return 0
					}
					if {[string tolower $admin]==$value4} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Accès Refusé."; return 0 }
					foreach verif [userlist] {
						if {$value4==[string tolower $verif]} {
							switch -exact $value8 {
								"1" { chattr $value4 -nmopjltx; chattr $value4 +p }
								"2" { chattr $value4 -nmopjltx; chattr $value4 +op }
								"3" { chattr $value4 -nmopjltx; chattr $value4 +mop }
								"4" { chattr $value4 -nmopjltx; chattr $value4 +nmop }
							}
						putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Changement du level de $value4 reussi."
						if {[eva:console 1]=="ok"} { putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Modaccess $eva(console_deco):$eva(console_txt) $user" }
						return 0
						}
					}
					putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :$value4 n'est pas dans la liste des accès."; return 0
				}
				"pass" {
					if {$value4=="" || $value8==""} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Modaccess Pass :\002 /msg $eva(pseudo) modaccess pass pseudo mot-de-passe"; return 0 }
					if {[string tolower $admin]==$value4} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Accès Refusé."; return 0 }
					foreach verif [userlist] {
						if {$value4==[string tolower $verif]} {
							if {[string length $value8]<="5"} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Le mot de passe doit contenir minimum 6 caractères."; return 0 }
							setuser $value3 PASS $value8
							putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Changement du mot de passe de $value4 reussi."
							if {[eva:console 1]=="ok"} { putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Modaccess $eva(console_deco):$eva(console_txt) $user" }
							return 0
						}
					}
					putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :$value4 n'est pas dans la liste des accès."; return 0
				}
			}
		}
	}
}

#############
# Eva Hcmds #
#############

proc eva:hcmds {arg} {
	global eva ceva
	set arg [split $arg]
	set hcmd [lindex $arg 0]
	set vuser [string tolower [lindex $arg 1]]
	if {[eva:authed $vuser $ceva($hcmd)]!="ok"} { return 0 }
	switch -exact $hcmd {
		"help" {
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Help :\002 /msg $eva(pseudo) help nom-de-la-commande"
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Permet de voir l'aide détaillée de la commande."
		}
		"auth" {
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Help :\002 /msg $eva(pseudo) auth pseudo mot-de-passe"
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Permet de vous authentifier sur $eva(pseudo)."
		}
		"deauth" {
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Help :\002 /msg $eva(pseudo) deauth"
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Permet de vous déauthentifier sur $eva(pseudo)."
		}
		"copyright" {
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Help :\002 /msg $eva(pseudo) copyright"
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Permet de voir l'auteur de $eva(pseudo)."
		}
		"showcommands" {
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Help :\002 /msg $eva(pseudo) showcommands"
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Permet de voir la liste des commandes de Eva Service."
		}
		"join" {
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Help :\002 /msg $eva(pseudo) join #salon"
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Permet de faire joindre $eva(pseudo) sur un salon."
		}
		"part" {
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Help :\002 /msg $eva(pseudo) part #salon"
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Permet de faire partir $eva(pseudo) d'un salon."
		}
		"list" {
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Help :\002 /msg $eva(pseudo) list"
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Permet de voir les autojoin salons."
		}
		"chanlog" {
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Help :\002 /msg $eva(pseudo) chanlog #salon"
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Permet de changer le salon de log de $eva(pseudo)."
		}
		"console" {
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Help :\002 /msg $eva(pseudo) console 0/1/2/3"
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :02Level 0 04:01 Aucune console"
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :02Level 1 04:01 Console commande"
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :02Level 2 04:01 Console commande & connexion & déconnexion"
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :02Level 3 04:01 Toutes les consoles"
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Permet d'activer la console des logs en fonction du level."
		}
		"maxlogin" {
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Help :\002 /msg $eva(pseudo) maxlogin on/off"
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Permet d'activer où désactiver la protection max login."
		}
		"backup" {
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Help :\002 /msg $eva(pseudo) backup"
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Permet de créer une sauvegarde des databases."
		}
		"restart" {
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Help :\002 /msg $eva(pseudo) restart"
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Permet de redémarrer Eva Service."
		}
		"die" {
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Help :\002 /msg $eva(pseudo) die"
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Permet d'arrêter Eva Service."
		}
		"status" {
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Help :\002 /msg $eva(pseudo) status"
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Permet de voir les informations de Eva Service."
		}
		"protection" {
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Help :\002 /msg $eva(pseudo) protection 0/1/2/3/4"
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :02Level 0 04:01 Aucune Protection"
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :02Level 1 04:01 Protection Admins"
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :02Level 2 04:01 Protection Admins + Ircops"
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :02Level 3 04:01 Protection Admins + Ircops + Géofronts"
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :02Level 4 04:01 Protection de tous les accès"
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Permet d'activer la protection en fonction du level."
		}
		"newpass" {
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Help :\002 /msg $eva(pseudo) newpass mot-de-passe"
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Permet de changer le mot de passe de votre accès."
		}
		"map" {
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Help :\002 /msg $eva(pseudo) map"
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Permet de voir la liste des serveurs."
		}
		"seen" {
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Help :\002 /msg $eva(pseudo) seen pseudo"
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Permet de voir la dernière authentification du pseudo."
		}
		"access" {
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Help :\002 /msg $eva(pseudo) access pseudo"
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Permet de voir l'accès du pseudo."
		}
		"owner" {
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Help :\002 /msg $eva(pseudo) owner #salon pseudo"
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Permet de mêttre un utilisateur owner d'un salon."
		}
		"deowner" {
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Help :\002 /msg $eva(pseudo) deowner #salon pseudo"
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Permet de retirer un utilisateur owner d'un salon."
		}
		"protect" {
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Help :\002 /msg $eva(pseudo) protect #salon pseudo"
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Permet de mêttre un utilisateur protect d'un salon."
		}
		"deprotect" {
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Help :\002 /msg $eva(pseudo) deprotect #salon pseudo"
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Permet de retirer un utilisateur protect d'un salon."
		}
		"ownerall" {
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Help :\002 /msg $eva(pseudo) ownerall #salon"
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Permet de mêttre tous les utilisateurs owner d'un salon."
		}
		"deownerall" {
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Help :\002 /msg $eva(pseudo) deownerall #salon"
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Permet de retirer tous les utilisateurs owner d'un salon."
		}
		"protectall" {
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Help :\002 /msg $eva(pseudo) protectall #salon"
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Permet de mêttre tous les utilisateurs protect d'un salon."
		}
		"deprotectall" {
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Help :\002 /msg $eva(pseudo) deprotectall #salon"
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Permet de retirer tous les utilisateurs protect d'un salon."
		}
		"op" {
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Help :\002 /msg $eva(pseudo) op #salon pseudo"
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Permet d'oper un utilisateur d'un salon."
		}
		"deop" {
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Help :\002 /msg $eva(pseudo) deop #salon pseudo"
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Permet de déoper un utilisateur d'un salon."
		}
		"halfop" {
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Help :\002 /msg $eva(pseudo) halfop #salon pseudo"
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Permet d'halfoper un utilisateur d'un salon."
		}
		"dehalfop" {
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Help :\002 /msg $eva(pseudo) dehalfop #salon pseudo"
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Permet de déhalfoper un utilisateur d'un salon."
		}
		"voice" {
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Help :\002 /msg $eva(pseudo) voice #salon pseudo"
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Permet de voicer un utilisateur d'un salon."
		}
		"devoice" {
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Help :\002 /msg $eva(pseudo) devoice #salon pseudo"
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Permet de dévoicer un utilisateur d'un salon."
		}
		"opall" {
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Help :\002 /msg $eva(pseudo) opall #salon"
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Permet d'oper tous les utilisateurs d'un salon."
		}
		"deopall" {
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Help :\002 /msg $eva(pseudo) deopall #salon"
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Permet de déoper tous les utilisateurs d'un salon."
		}
		"halfopall" {
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Help :\002 /msg $eva(pseudo) halfopall #salon"
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Permet d'halfoper tous les utilisateurs d'un salon."
		}
		"dehalfopall" {
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Help :\002 /msg $eva(pseudo) dehalfopall #salon"
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Permet de déhalfoper tous les utilisateurs d'un salon."
		}
		"voiceall" {
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Help :\002 /msg $eva(pseudo) voiceall #salon"
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Permet de voicer tous les utilisateurs d'un salon."
		}
		"devoiceall" {
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Help :\002 /msg $eva(pseudo) devoiceall #salon"
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Permet de dévoicer tous les utilisateurs d'un salon."
		}
		"kick" {
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Help :\002 /msg $eva(pseudo) kick #salon pseudo raison"
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Permet de kicker un utilisateur d'un salon."
		}
		"kickall" {
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Help :\002 /msg $eva(pseudo) kickall #salon"
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Permet de kicker tous les utilisateurs d'un salon."
		}
		"ban" {
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Help :\002 /msg $eva(pseudo) ban #salon mask"
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Permet de bannir un mask d'un salon."
		}
		"nickban" {
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Help :\002 /msg $eva(pseudo) nickban #salon pseudo raison"
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Permet de bannir et kicker un utilisateur d'un salon en fonction de son pseudo."
		}
		"kickban" {
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Help :\002 /msg $eva(pseudo) kickban #salon pseudo raison"
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Permet de bannir et kicker un utilisateur d'un salon."
		}
		"unban" {
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Help :\002 /msg $eva(pseudo) unban #salon mask"
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Permet de débannir un mask d'un salon."
		}
		"clearbans" {
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Help :\002 /msg $eva(pseudo) clearbans #salon"
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Permet de débannir tous les masks d'un salon."
		}
		"topic" {
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Help :\002 /msg $eva(pseudo) topic #salon topic"
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Permet de changer le topic d'un salon."
		}
		"mode" {
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Help :\002 /msg $eva(pseudo) mode #salon +/-mode"
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Permet de changer les modes d'un salon."
		}
		"clearmodes" {
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Help :\002 /msg $eva(pseudo) clearmodes #salon"
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Permet de retirer tous les modes d'un salon."
		}
		"clearallmodes" {
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Help :\002 /msg $eva(pseudo) clearallmodes #salon"
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Permet de retirer tous les modes, tous les accès et tous les bans d'un salon."
		}
		"kill" {
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Help :\002 /msg $eva(pseudo) kill pseudo raison"
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Permet de killer un utilisateur du serveur."
		}
		"chankill" {
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Help :\002 /msg $eva(pseudo) chankill #salon"
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Permet de killer tous les utilisateurs d'un salon."
		}
		"svsjoin" {
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Help :\002 /msg $eva(pseudo) svsjoin #salon pseudo"
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Permet de forcer un utilisateur à joindre un salon."
		}
		"svspart" {
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Help :\002 /msg $eva(pseudo) svspart #salon pseudo"
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Permet de forcer un utilisateur à partir d'un salon."
		}
		"svsnick" {
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Help :\002 /msg $eva(pseudo) svsnick ancien-pseudo nouveau-pseudo"
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Permet de changer le pseudo d'un utilisateur."
		}
		"say" {
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Help :\002 /msg $eva(pseudo) say #salon message"
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Permet d'envoyer un message sur un salon."
		}
		"invite" {
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Help :\002 /msg $eva(pseudo) invite #salon pseudo"
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Permet d'inviter un utilisateur sur un salon."
		}
		"inviteme" {
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Help :\002 /msg $eva(pseudo) inviteme"
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Permet de s'inviter sur $eva(salon)."
		}
		"wallops" {
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Help :\002 /msg $eva(pseudo) wallops message"
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Permet d'envoyer un message en wallops à tous les utilisateurs."
		}
		"globops" {
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Help :\002 /msg $eva(pseudo) globops message"
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Permet d'envoyer un message en globops à tous les ircops et admins."
		}
		"notice" {
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Help :\002 /msg $eva(pseudo) notice message"
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Permet d'envoyer une notice à tous les utilisateurs."
		}
		"whois" {
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Help :\002 /msg $eva(pseudo) whois pseudo"
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Permet de voir le whois d'un utilisateur."
		}
		"changline" {
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Help :\002 /msg $eva(pseudo) changline #salon"
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Permet de gline tous les utilisateurs d'un salon."
		}
		"gline" {
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Help :\002 /msg $eva(pseudo) gline <pseudo ou ip> raison"
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Permet de gline un utilisateur du serveur."
		}
		"ungline" {
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Help :\002 /msg $eva(pseudo) ungline ident@host"
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Permet de supprimer un mask de la liste des glines."
		}
		"shun" {
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Help :\002 /msg $eva(pseudo) shun <pseudo ou ip> raison"
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Permet de shun un utilisateur du serveur."
		}
		"unshun" {
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Help :\002 /msg $eva(pseudo) unshun pseudo raison"
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Permet de unshun un utilisateur du serveur."
		}
		"kline" {
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Help :\002 /msg $eva(pseudo) kline <pseudo ou ip> raison"
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Permet de kline un utilisateur du serveur."
		}
		"unkline" {
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Help :\002 /msg $eva(pseudo) unkline ident@host"
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Permet de supprimer un mask de la liste des klines."
		}
		"glinelist" {
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Help :\002 /msg $eva(pseudo) glinelist"
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Permet de voir la liste des glines."
		}
		"shunlist" {
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Help :\002 /msg $eva(pseudo) shunlist"
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Permet de voir la liste des shuns."
		}
		"klinelist" {
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Help :\002 /msg $eva(pseudo) klinelist"
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Permet de voir la liste des klines."
		}
		"cleargline" {
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Help :\002 /msg $eva(pseudo) cleargline"
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Permet de retirer tous les glines du serveur."
		}
		"clearkline" {
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Help :\002 /msg $eva(pseudo) clearkline"
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Permet de retirer tous les klines du serveur."
		}
		"clientlist" {
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Help :\002 /msg $eva(pseudo) clientlist"
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Permet de voir la liste des clients IRC interdits."
		}
		"addclient" {
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Help :\002 /msg $eva(pseudo) addclient version"
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Permet d'ajouter un client IRC interdit."
		}
		"delclient" {
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Help :\002 /msg $eva(pseudo) delclient version"
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Permet de supprimer un client IRC interdit."
		}
		"addsecu" {
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Help :\002 /msg $eva(pseudo) addsecu #salon"
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Permet d'ajouter un salon sécurisé."
		}
		"delsecu" {
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Help :\002 /msg $eva(pseudo) delsecu #salon"
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Permet de supprimer un salon sécurisé."
		}
		"seculist" {
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Help :\002 /msg $eva(pseudo) seculist"
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Permet de voir la liste des salons sécurisés."
		}
		"secu" {
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Help :\002 /msg $eva(pseudo) secu on/off"
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Permet d'activer ou désactiver le système de sécurité des salons."
		}
		"client" {
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Help :\002 /msg $eva(pseudo) client on/off"
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Permet d'activer ou désactiver les clients IRC interdits."
		}
		"clone" {
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Help :\002 /msg $eva(pseudo) clone on/off"
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Permet d'activer ou désactiver la protection clone."
		}
		"close" {
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Help :\002 /msg $eva(pseudo) close #salon"
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Permet de fermer un salon."
		}
		"unclose" {
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Help :\002 /msg $eva(pseudo) unclose #salon"
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Permet d'ouvrir un salon fermé."
		}
		"closelist" {
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Help :\002 /msg $eva(pseudo) closelist"
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Permet de voir la liste des salons fermés."
		}
		"clearclose" {
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Help :\002 /msg $eva(pseudo) clearclose"
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Permet de vider la liste des salons fermés."
		}
		"addnick" {
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Help :\002 /msg $eva(pseudo) addnick pseudo"
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Permet d'ajouter un pseudo interdit."
		}
		"delnick" {
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Help :\002 /msg $eva(pseudo) delnick pseudo"
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Permet de supprimer un pseudo interdit."
		}
		"nicklist" {
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Help :\002 /msg $eva(pseudo) nicklist"
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Permet de voir la liste des pseudos interdits."
		}
		"addident" {
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Help :\002 /msg $eva(pseudo) addident ident"
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Permet d'ajouter un ident interdit."
		}
		"delident" {
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Help :\002 /msg $eva(pseudo) delident ident"
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Permet de supprimer un ident interdit."
		}
		"identlist" {
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Help :\002 /msg $eva(pseudo) identlist"
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Permet de voir la liste des idents interdits."
		}
		"addreal" {
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Help :\002 /msg $eva(pseudo) addreal realname"
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Permet d'ajouter un realname interdit."
		}
		"delreal" {
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Help :\002 /msg $eva(pseudo) delreal realname"
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Permet de supprimer un realname interdit."
		}
		"reallist" {
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Help :\002 /msg $eva(pseudo) reallist"
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Permet de voir la liste des realnames interdits."
		}
		"addhost" {
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Help :\002 /msg $eva(pseudo) addhost hostname"
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Permet d'ajouter une hostname interdite."
		}
		"delhost" {
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Help :\002 /msg $eva(pseudo) delhost hostname"
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Permet de supprimer une hostname interdite."
		}
		"hostlist" {
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Help :\002 /msg $eva(pseudo) hostlist"
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Permet de voir la liste des hostnames interdites."
		}
		"addchan" {
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Help :\002 /msg $eva(pseudo) addchan #salon"
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Permet d'ajouter un salon interdit."
		}
		"delchan" {
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Help :\002 /msg $eva(pseudo) delchan #salon"
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Permet de supprimer un salon interdit."
		}
		"chanlist" {
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Help :\002 /msg $eva(pseudo) chanlist"
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Permet de voir la liste des salons interdits."
		}
		"addtrust" {
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Help :\002 /msg $eva(pseudo) addtrust mask"
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Permet d'ajouter un trust sur un mask."
		}
		"deltrust" {
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Help :\002 /msg $eva(pseudo) deltrust mask"
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Permet de supprimer le trust d'un mask."
		}
		"trustlist" {
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Help :\002 /msg $eva(pseudo) trustlist"
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Permet de voir la liste des trusts."
		}
		"addaccess" {
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Help :\002 /msg $eva(pseudo) addaccess pseudo password level"
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Permet d'ajouter un accès sur Eva Service."
		}
		"modaccess" {
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Help :\002 /msg $eva(pseudo) modaccess pass pseudo mot-de-passe"
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Help :\002 /msg $eva(pseudo) modaccess level pseudo level"
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Permet de modifier un accès de Eva Service."
		}
		"delaccess" {
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :\002Commande Help :\002 /msg $eva(pseudo) delaccess pseudo"
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $vuser :Permet de supprimer un accès de Eva Service."
		}
	}
}

#################
# Eva Connexion #
#################

proc eva:connexion {} {
	global eva vhost protect ueva netadmin
	if {![catch "connect $eva(ip) $eva(port)" eva(idx)]} {
		if {[info exists vhost]} { unset vhost }
		if {[info exists ueva]} { unset ueva }
		if {[info exists netadmin]} { unset netadmin }
		set eva(init) "1"; set eva(cmd) "close"; utimer $eva(timerinit) [list set eva(init) 0]
		utimer $eva(timerinit) [list unset eva(cmd)]; eva:chargement; set eva(uptime) [clock seconds]
		#putdcc $eva(idx) "PASS $eva(pass)"
		#putdcc $eva(idx) "PROTOCTL EAUTH=$eva(link) SID=999 TS=[unixtime]"
		#putdcc $eva(idx) "PROTOCTL NOQUIT NICKv2 SJOIN SJ3 CLK TKLEXT TKLEXT2 NICKIP ESVID MLOCK EXTSWHOIS"
		#putdcc $eva(idx) "SERVER $eva(link) 1 :$eva(info)"
		#putdcc $eva(idx) "NETINFO 1 [unixtime] 4000 * 0 0 0 Eva"
		#putdcc $eva(idx) "EOS"
		#putdcc $eva(idx) ":$eva(link) SQLINE $eva(pseudo) :$eva(info)"
		#putdcc $eva(idx) ":999 UID $eva(pseudo) 1 [unixtime] $eva(ident) $eva(host) 999AAAAAA 0 +ioS $eva(host) $eva(host) * :$eva(real)"
		#putdcc $eva(idx) ":999 SJOIN [unixtime] $eva(salon) +nt :@999AAAAAA"
		#putdcc $eva(idx) ":$eva(pseudo) MODE $eva(salon) +$eva(smode)"
		putdcc $eva(idx) "PROTOCTL NICKv2 SJOIN2 UMODE2 NOQUIT VL TKLEXT VHP"
		putdcc $eva(idx) "PASS $eva(pass)"
		putdcc $eva(idx) "SERVER $eva(link) 1 :$eva(info)"
		putdcc $eva(idx) ":$eva(link) SQLINE $eva(pseudo) :$eva(info)"
		putdcc $eva(idx) ":$eva(link) NICK $eva(pseudo) 1 [unixtime] $eva(ident) $eva(host) $eva(link) 0 +ioS $eva(host) :$eva(real)"
		putdcc $eva(idx) ":$eva(link) EOS"
		putdcc $eva(idx) ":$eva(pseudo) JOIN $eva(salon)"
		putdcc $eva(idx) ":$eva(pseudo) MODE $eva(salon) +$eva(smode)"
		if {$eva(cmode)=="q" || $eva(cmode)=="a" || $eva(cmode)=="o" || $eva(cmode)=="h" || $eva(cmode)=="v"} { putdcc $eva(idx) ":$eva(pseudo) MODE $eva(salon) +$eva(cmode) $eva(pseudo)" }
		catch {open "[eva:scriptdir]db/chan.db" r} autojoin
		while {![eof $autojoin]} { gets $autojoin salon; if {$salon!=""} { putdcc $eva(idx) ":$eva(pseudo) JOIN $salon"; if {$eva(cmode)=="q" || $eva(cmode)=="a" || $eva(cmode)=="o" || $eva(cmode)=="h" || $eva(cmode)=="v"} { putdcc $eva(idx) ":$eva(pseudo) MODE $salon +$eva(cmode) $eva(pseudo)" } } }
		catch {close $autojoin}
		catch {open "[eva:scriptdir]db/close.db" r} ferme
		while {![eof $ferme]} { gets $ferme salle; if {$salle!=""} { putdcc $eva(idx) ":$eva(pseudo) JOIN $salle"; putdcc $eva(idx) ":$eva(pseudo) MODE $salle +sntio $eva(pseudo)"; putdcc $eva(idx) ":$eva(pseudo) TOPIC $salle :1Salon Fermé le [eva:duree [unixtime]]"; putdcc $eva(idx) ":$eva(link) NAMES $salle" } }
		catch {close $ferme}
		incr eva(counter) 1
		control $eva(idx) eva:link
		utimer $eva(timerco) eva:verif
	} else { if {[info exists eva(idx)]} { unset eva(idx) } }
}

######################
# Eva Initialisation #
######################

proc eva:initialisation {arg} {
	global eva
	if {[eva:config]!="ok"} { eva:connexion }
}

####################
# Eva Verification #
####################

proc eva:verif {} {
	global eva
	if {[valididx $eva(idx)]} {
		utimer $eva(timerco) eva:verif
	} else {
		if {$eva(counter)<="10"} {
			if {[eva:config]!="ok"} { eva:connexion }
		} else {
			foreach kill [utimers] { if {[lindex $kill 1]=="eva:verif"} { killutimer [lindex $kill 2] } }
			if {[info exists eva(idx)]} { unset eva(idx) }
		}
	}
}

############
# Eva Link #
############
proc remove_modenicklist {data} {
	return [::tcl::string::map -nocase {
		"@" "" "&" "" "+" "" "~" "" "%" ""
	} $data]
}

proc eva:link {idx arg} {

	global eva ceva admins netadmin vhost protect ueva trust
	set arg [split $arg]
	if {$eva(debug)=="1"} { eva:putdebug "[join [lrange $arg 0 end]]" }
	switch -exact [lindex $arg 0] {
		"PING" {
			set eva(counter) "0"
			putdcc $eva(idx) "PONG [lindex $arg 1]"
		}
		"NETINFO" {
			set eva(netinfo) [lindex $arg 4]
			set eva(network) [lindex $arg 8]
			putdcc $eva(idx) "NETINFO 0 [unixtime] 0 $eva(netinfo) 0 0 0 $eva(network)"
		}
		"SQUIT" {
			set serv [lindex $arg 1]
			if {[eva:console 2]=="ok" && $eva(init)=="0"} { putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Unlink $eva(console_deco):$eva(console_txt) $serv" }
		}

		"NICK" {
			set user [string tolower [lindex $arg 1]]
			set user2 [lindex $arg 1]
			set ident [string tolower [lindex $arg 4]]
			set ident2 [lindex $arg 4]
			set host [string tolower [lindex $arg 5]]
			set host2 [lindex $arg 5]
			set servs [lindex $arg 6]
			set umode [lindex $arg 8]
			set real [string trim [string tolower [join [lrange $arg 10 end]]] :]

			if {![info exists vhost($user)]} { set vhost($user) $host }
			if {![info exists ueva($user)] && [string match *+*S* $umode]} { set ueva($user) on }
			if {[string match *+*z* $umode]} { set stype "Connexion SSL" } else { set stype "Connexion" }
			if {[eva:console 2]=="ok" && $eva(init)=="0"} { putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)$stype $eva(console_deco):$eva(console_txt) $user2 ($ident2@$host2) - (Serveur : $servs)" }
			foreach {mask num} [array get trust] { if {[string match *$mask* $host]} { return 0 } }
			if {$eva(secu)=="1" && $eva(init)=="0" && ![info exists ueva($user)] && ![info exists protect($host)]} {
				if {![info exists eva(throttle)]} {
					set eva(throttle) "1"; utimer 2 [list unset eva(throttle)]
				} elseif {$eva(throttle)<$eva(secuco)} {
					incr eva(throttle) 1
				} else {
					if {![info exists eva(maxthrottle)]} {
						putdcc $eva(idx) ":$eva(pseudo) NOTICE $*.* : $eva(secuon)"
						catch {open "[eva:scriptdir]db/secu.db" r} liste
						while {![eof $liste]} { gets $liste salon; if {$salon!=""} { putdcc $eva(idx) ":$eva(pseudo) MODE $salon +msi" } }
						catch {close $liste}
					}
					set eva(maxthrottle) "1"
					utimer $eva(secutime) eva:secu
				}
				if {[info exists eva(maxthrottle)]} { putdcc $eva(idx) ":$eva(link) TKL + G * $host $eva(pseudo) [expr [unixtime] + $eva(secutime)] [unixtime] :$eva(secustop)"; return 0 }
			}
			if {![info exists ueva($user)] && ![info exists protect($host)]} {
				catch {open [eva:scriptdir]db/host.db r} liste2
				while {![eof $liste2]} {
					gets $liste2 verif2
					if {[string match *$verif2* $host] && $verif2!=""} {
						if {[eva:console 1]=="ok" && $eva(init)=="0"} { putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Kill $eva(console_deco):$eva(console_txt) $user2 a été killé : $eva(rhost)" }
						putdcc $eva(idx) ":$eva(pseudo) KILL $user $eva(rhost)"; break; eva:refresh $user; return 0
					}
				}
				catch {close $liste2}
				catch {open [eva:scriptdir]db/ident.db r} liste3
				while {![eof $liste3]} {
					gets $liste3 verif3
					if {[string match *$verif3* $ident] && $verif3!=""} {
						if {[eva:console 1]=="ok" && $eva(init)=="0"} { putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Kill $eva(console_deco):$eva(console_txt) $user2 ($verif3) a été killé : $eva(rident)" }
						putdcc $eva(idx) ":$eva(pseudo) KILL $user $eva(rident)"; break ; eva:refresh $user; return 0
					}
				}
				catch {close $liste3}
				catch {open [eva:scriptdir]db/real.db r} liste4
				while {![eof $liste4]} {
					gets $liste4 verif4
					if {[string match *$verif4* $real] && $verif4!=""} {
						if {[eva:console 1]=="ok" && $eva(init)=="0"} { putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Kill $eva(console_deco):$eva(console_txt) $user2 (Realname: $verif4) a été killé : $eva(rreal)" }
						putdcc $eva(idx) ":$eva(pseudo) KILL $user $eva(rreal)"; break; eva:refresh $user; return 0
					}
				}
				catch {close $liste4}
				catch {open [eva:scriptdir]db/nick.db r} liste5
				while {![eof $liste5]} {
					gets $liste5 verif5
					if {[string match $verif5 $user] && $verif5!=""} {
						if {[eva:console 1]=="ok" && $eva(init)=="0"} { putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Kill $eva(console_deco):$eva(console_txt) $user2 a été killé : $eva(ruser)" }
						putdcc $eva(idx) ":$eva(pseudo) KILL $user $eva(ruser)"; break; eva:refresh $user; return 0
					}
				}
				catch {close $liste5}
			}
			if {$eva(aclient)=="1" && $eva(init)=="0" && ![info exists ueva($user)] && ![info exists protect($host)]} { putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $user :VERSION" }
			if {$eva(aclone)=="1" && ![info exists ueva($user)] && ![info exists protect($host)]} {
				set clone "0"
				foreach {u h} [array get vhost] { if {$h==$host} { incr clone 1 } }
				if {$clone==$eva(numavert)} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $user :$eva(ravert)" }
				if {$clone==$eva(numclone)} { putdcc $eva(idx) ":$eva(link) TKL + G * $host $eva(pseudo) [expr [unixtime] + $eva(duree)] [unixtime] :$eva(rclone) (Expire le [eva:duree [expr [unixtime] + $eva(duree)]])"; return 0 }
			}
		}
	}
	switch -exact [lindex $arg 1] {
		"219" {
			if {![info exists eva(aff)] && $eva(cmd)=="gline"} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $eva(rep) :Aucun Gline" }
			if {![info exists eva(aff)] && $eva(cmd)=="shun"} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $eva(rep) :Aucun shun" }
			if {![info exists eva(aff)] && $eva(cmd)=="kline"} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $eva(rep) :Aucun Kline" }
			if {[info exists eva(cmd)]} { unset eva(cmd) }
			if {[info exists eva(rep)]} { unset eva(rep) }
			if {[info exists eva(aff)]} { unset eva(aff) }
		}
		"223" {
			set host [lindex $arg 4]
			set auteur [lindex $arg 7]
			set raison [join [string trim [lrange $arg 8 end] :]]
			if {$eva(cmd)=="gline"} {
				if {![info exists eva(aff)]} {
					set eva(aff) "1"
					putdcc $eva(idx) ":$eva(pseudo) NOTICE $eva(rep) :1,1---------------------- 0Liste des Glines 1----------------------"
					putdcc $eva(idx) ":$eva(pseudo) NOTICE $eva(rep) :"
				}
				putdcc $eva(idx) ":$eva(pseudo) NOTICE $eva(rep) :Host \[03 $host 01\] | Auteur \[03 $auteur 01\] | Raison \[03 $raison 01\]"
			} elseif {$eva(cmd)=="shun"} {
				if {![info exists eva(aff)]} {
					set eva(aff) "1"
					putdcc $eva(idx) ":$eva(pseudo) NOTICE $eva(rep) :1,1---------------------- 0Liste des Shuns 1----------------------"
					putdcc $eva(idx) ":$eva(pseudo) NOTICE $eva(rep) :"
				}
				putdcc $eva(idx) ":$eva(pseudo) NOTICE $eva(rep) :Host \[03 $host 01\] | Auteur \[03 $auteur 01\] | Raison \[03 $raison 01\]"
			} elseif {$eva(cmd)=="kline"} {
				if {![info exists eva(aff)]} {
					set eva(aff) "1"
					putdcc $eva(idx) ":$eva(pseudo) NOTICE $eva(rep) :1,1---------------------- 0Liste des Klines 1----------------------"
					putdcc $eva(idx) ":$eva(pseudo) NOTICE $eva(rep) :"
				}
				putdcc $eva(idx) ":$eva(pseudo) NOTICE $eva(rep) :Host \[03 $host 01\] | Auteur \[03 $auteur 01\] | Raison \[03 $raison 01\]"
			} elseif {$eva(cmd)=="cleargline"} {
				putdcc $eva(idx) ":$eva(link) TKL - G [lindex [split $host @] 0] [lindex [split $host @] 1] $eva(pseudo)"
			} elseif {$eva(cmd)=="clearkline"} {
				putdcc $eva(idx) ":$eva(link) TKL - k [lindex [split $host @] 0] [lindex [split $host @] 1] $eva(pseudo)"
			}
		}
		"307" {
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $eva(rep) :01 \[03 NickServ 01\] 02 Oui"
		}
		"310" {
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $eva(rep) :01 \[03 Helpeur 01\] 02 Oui"
		}
		"311" {
			set nick [lindex $arg 3]
			set ident [lindex $arg 4]
			set host [lindex $arg 5]
			set real [join [string trim [lrange $arg 7 end] :]]
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $eva(rep) :1,1------------------------------ 0Whois 1------------------------------"
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $eva(rep) :"
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $eva(rep) :01 \[03 Pseudo 01\] 02 $nick"
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $eva(rep) :01 \[03 Nom Réel 01\] 02 $real"
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $eva(rep) :01 \[03 Host 01\] 02 $ident@$host"
		}
		"312" {
			set serveur [lindex $arg 4]
			set desc [join [string trim [lrange $arg 5 end] :]]
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $eva(rep) :01 \[03 Serveur 01\] 02 $serveur ($desc)"
		}
		"313" {
			set grade [join [lrange $arg 6 end]]
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $eva(rep) :01 \[03 Grade 01\] 02 $grade"
		}
		"317" {
			set idle [lindex $arg 4]
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $eva(rep) :01 \[03 Idle 01\] 02 [duration $idle]"
		}
		"318" {
			if {[info exists eva(rep)]} { unset eva(rep) }
		}
		"319" {
			set salon [join [string trim [lrange $arg 4 end] :]]
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $eva(rep) :01 \[03 Salon 01\] 02 $salon"
		}
		"320" {
			set swhois [join [string trim [lrange $arg 4 end] :]]
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $eva(rep) :01 \[03 Swhois 01\] 02 $swhois"
		}
		"324" {
			set chan [lindex $arg 3]
			set mode [join [string trimleft [lrange $arg 4 end] +]]
			putdcc $eva(idx) ":$eva(pseudo) MODE $chan -$mode"
		}
		"335" {
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $eva(rep) :01 \[03 Robot 01\] 02 Oui"
		}
		"353" {

			set userliste [string trim [string tolower [lrange $arg 5 end]] :]
			set userliste2 [string trim [lrange $arg 5 end] :]
			set chan [lindex $arg 4]
			set user [remove_modenicklist [lrange $userliste 0 end-1]]

			set user2 [remove_modenicklist $userliste2]
			set nblistenick [llength [split $user]]
			#set ident [lindex $arg 4]
			#set host [lindex $arg 5]

			foreach n [split $user] {
			if { $eva(cmd)=="ownerall" && ![info exists ueva($n)] && $n!=[string tolower $eva(pseudo)] && ![info exists admins($n)] && [eva:protection $n $eva(protection)]!="ok"} {
				putdcc $eva(idx) ":$eva(pseudo) MODE $chan +q $n"
			} elseif {$eva(cmd)=="deownerall" && ![info exists ueva($n)] && $n!=[string tolower $eva(pseudo)] && ![info exists admins($n)] && [eva:protection $n $eva(protection)]!="ok"} {
				putdcc $eva(idx) ":$eva(pseudo) MODE $chan -q $n"
			} elseif {$eva(cmd)=="protectall" && ![info exists ueva($n)] && $n!=[string tolower $eva(pseudo)] && ![info exists admins($n)] && [eva:protection $n $eva(protection)]!="ok"} {
				putdcc $eva(idx) ":$eva(pseudo) MODE $chan +a $n"
			} elseif {$eva(cmd)=="deprotectall" && ![info exists ueva($n)] && $n!=[string tolower $eva(pseudo)] && ![info exists admins($n)] && [eva:protection $n $eva(protection)]!="ok"} {
				putdcc $eva(idx) ":$eva(pseudo) MODE $chan -a $n"
			} elseif {$eva(cmd)=="opall" && ![info exists ueva($n)] && $n!=[string tolower $eva(pseudo)] && ![info exists admins($n)] && [eva:protection $n $eva(protection)]!="ok"} {
      	putdcc $eva(idx) ":$eva(pseudo) MODE $chan +o $n"
			} elseif {$eva(cmd)=="deopall" && ![info exists ueva($n)] && $n!=[string tolower $eva(pseudo)] && ![info exists admins($n)] && [eva:protection $n $eva(protection)]!="ok"} {
				putdcc $eva(idx) ":$eva(pseudo) MODE $chan -o $n"
			} elseif {$eva(cmd)=="halfopall" && ![info exists ueva($n)] && $n!=[string tolower $eva(pseudo)] && ![info exists admins($n)] && [eva:protection $n $eva(protection)]!="ok"} {
				putdcc $eva(idx) ":$eva(pseudo) MODE $chan +h $n"
			} elseif {$eva(cmd)=="dehalfopall" && ![info exists ueva($n)] && $n!=[string tolower $eva(pseudo)] && ![info exists admins($n)] && [eva:protection $n $eva(protection)]!="ok"} {
				putdcc $eva(idx) ":$eva(pseudo) MODE $chan -h $n"
			} elseif {$eva(cmd)=="voiceall" && ![info exists ueva($n)] && $n!=[string tolower $eva(pseudo)] && ![info exists admins($n)] && [eva:protection $n $eva(protection)]!="ok"} {
				putdcc $eva(idx) ":$eva(pseudo) MODE $chan +v $n"
			} elseif {$eva(cmd)=="devoiceall" && ![info exists ueva($n)] && $n!=[string tolower $eva(pseudo)] && ![info exists admins($n)] && [eva:protection $n $eva(protection)]!="ok"} {
				putdcc $eva(idx) ":$eva(pseudo) MODE $chan -v $n"
			} elseif {$eva(cmd)=="kickall" && ![info exists ueva($n)] && $n!=[string tolower $eva(pseudo)] && ![info exists admins($n)] && [eva:protection $n $eva(protection)]!="ok"} {

				putdcc $eva(idx) ":$eva(pseudo) KICK $chan $n Kicked [eva:rnick $eva(rep)]"
			} elseif {$eva(cmd)=="chankill" && ![info exists ueva($n)] && $n!=[string tolower $eva(pseudo)] && ![info exists admins($n)] && [eva:protection $n $eva(protection)]!="ok" && [eva:protection $n $eva(protection)]!="ok"} {
 				putdcc $eva(idx) ":$eva(pseudo) KILL $n Chan Killed [eva:rnick $eva(rep)]"; eva:refresh $n
			} elseif {$eva(cmd)=="changline" && ![info exists ueva($n)] && $n!=[string tolower $eva(pseudo)] && ![info exists admins($n)] && [eva:protection $n $eva(protection)]!="ok" && [eva:protection $n $eva(protection)]!="ok"} {
 				putdcc $eva(idx) ":$eva(link) TKL + G * $vhost($n) $eva(pseudo) [expr [unixtime] + $eva(duree)] [unixtime] :Chan Glined [eva:rnick $eva(rep)] (Expire le [eva:duree [expr [unixtime] + $eva(duree)]])"
			} elseif {$eva(cmd)=="badchan" && ![info exists ueva($n)] && $n!=[string tolower $eva(pseudo)] && ![info exists admins($n)] && [eva:protection $n $eva(protection)]!="ok"} {
			  putdcc $eva(idx) ":$eva(pseudo) KICK $chan $n Salon Interdit"
			} elseif { $eva(cmd)=="close" && ![info exists ueva($n)] && $n!=[string tolower $eva(pseudo)] && ![info exists admins($n)] && [eva:protection $n $eva(protection)]!="ok"} {
				if {[info exists eva(rep)]} {
					putdcc $eva(idx) ":$eva(pseudo) KICK $chan $n Closed [eva:rnick $eva(rep)]"
				} else { putdcc $eva(idx) ":$eva(pseudo) KICK $chan $n Closed" }

			}
	  	}
		}
		"364" {
			set serv [lindex $arg 3]
			set desc [join [lrange $arg 6 end]]
			if {![info exists eva(aff)]} {
				set eva(aff) "1"
				putdcc $eva(idx) ":$eva(pseudo) NOTICE $eva(rep) :1,1--------------------------------- 0Map du Réseau 1---------------------------------"
				putdcc $eva(idx) ":$eva(pseudo) NOTICE $eva(rep) :"
			}
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $eva(rep) :01Serveur \[04 $serv 01\]  Description \[03 $desc 01\]"
		}
		"365" {
			if {[info exists eva(aff)]} { unset eva(aff) }
			if {[info exists eva(rep)]} { unset eva(rep) }
		}
		"378" {
			set host [lindex $arg 7]
			set ip [lindex $arg 8]
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $eva(rep) :01 \[03 Host Décodé 01\] 02 $host"
			if {[info exists $ip]} { putdcc $eva(idx) ":$eva(pseudo) NOTICE $eva(rep) :01 \[03 Ip 01\] 02 $ip" }
		}
		"671" {
			putdcc $eva(idx) ":$eva(pseudo) NOTICE $eva(rep) :01 \[03 SSL 01\] 02 Oui"
		}
		"SERVER" {
			set serv [lindex $arg 2]
			set desc [join [string trim [lrange $arg 4 end] :]]
			if {[eva:console 2]=="ok" && $eva(init)=="0"} { putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Link $eva(console_deco):$eva(console_txt) $serv : $desc" }
		}
		"NOTICE" {
			set user [string trim [lindex $arg 0] :]
			set vuser [string tolower [string trim [lindex $arg 0] :]]
			set version [string trim [lindex $arg 3] :]
			set vdata [string tolower [join [lrange $arg 3 end]]]
			if {[eva:flood $vuser]!="ok"} { return 0 }
			if {$eva(aclient)=="1" && $version=="VERSION"} {
				catch {open [eva:scriptdir]db/client.db r} vcli
				while {![eof $vcli]} {
					gets $vcli verscli
					if {[string match *$verscli* $vdata] && $verscli!=""} {
						if {[eva:console 3]=="ok" && $eva(init)=="0"} { putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Kill $eva(console_deco):$eva(console_txt) $user a été killé : $eva(rclient)" }
						putdcc $eva(idx) ":$eva(pseudo) KILL $vuser $eva(rclient)"; eva:refresh $vuser
						break
					}
				}
				catch {close $vcli}
			}
		}
		"PRIVMSG" {
			set user [string trim [lindex $arg 0] :]
			set vuser [string tolower $user]
			set robot [string tolower [lindex $arg 2]]
			set cmds [string tolower [string trim [lindex $arg 3] :]]
			set hcmds [string tolower [lindex $arg 4]]
			set pcmds [string trim $cmds $eva(prefix)]
			set data [join [lrange $arg 4 end]]
			if {$robot==[string tolower $eva(pseudo)]} {
				if {[eva:flood $vuser]!="ok"} { return 0 }
				if {$cmds=="ping"} {
					putdcc $eva(idx) ":$eva(pseudo) NOTICE $user :\001PING [clock seconds]\001"; return 0
				} elseif {$cmds=="version"} {
					putdcc $eva(idx) ":$eva(pseudo) NOTICE $user :01Eva Service $eva(version) by TiSmA03©"; return 0
				} elseif {[info exists ceva($cmds)]} {
					if {$cmds=="help" && $hcmds!=""} {
						if {[info exists ceva($hcmds)]} { eva:hcmds "$hcmds $user $data" } else { putdcc $eva(idx) ":$eva(pseudo) NOTICE $user :Aide $hcmds Inconnue." }
					} else { eva:cmds "$cmds $user $data" }
				} else { putdcc $eva(idx) ":$eva(pseudo) NOTICE $user :Commande $cmds Inconnue." }
			}
			if {[string index $cmds 0]==$eva(prefix)} {
				if {[eva:flood $vuser]!="ok"} { return 0 }
				if {[info exists ceva($pcmds)]} {
					if {$pcmds=="help" && $hcmds!=""} {
						if {[info exists ceva($hcmds)]} { eva:hcmds "$hcmds $user $data" }
					} else { eva:cmds "$pcmds $user $data" }
				}
			}
		}
		"MODE" {
			set user [string trim [lindex $arg 0] :]
			set chan [lindex $arg 2]
			set vchan [string tolower [lindex $arg 2]]
			set umode [lindex $arg 3]
			set pmode [join [lrange $arg 4 end]]
			set unix [lindex $arg end]
			if {[eva:console 3]=="ok" && $vchan!=[string tolower $eva(salon)] && $eva(init)=="0" && [string tolower $user]!=[string tolower $eva(pseudo)]} {
				if {[regexp "^\[0-9\]\{10\}" $unix]} {
					set smode [string trim $pmode $unix]
					putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Mode $eva(console_deco):$eva(console_txt) $user applique le mode $umode $smode sur $chan"
				} else { putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Mode $eva(console_deco):$eva(console_txt) $user applique le mode $umode $pmode sur $chan" }
			}
		}
		"UMODE2" {
			set user [string tolower [string trim [lindex $arg 0] :]]
			set user2 [string trim [lindex $arg 0] :]
			set umode [lindex $arg 2]
			if {![info exists ueva($user)] && [string match *+*S* $umode]} { set ueva($user) on }
			if {![info exists netadmin($user)] && [string match *+*N* $umode]} { set netadmin($user) on }
			if {[info exists netadmin($user)] && [string match *-*N* $umode]} { unset netadmin($user) }
			if {[eva:console 3]=="ok" && $eva(init)=="0"} {
				if {[string match *+*S* $umode]} {
					putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Usermode $eva(console_deco):$eva(console_txt) $user2 est un Service Réseau"
				} elseif {[string match *-*S* $umode]} {
					putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Usermode $eva(console_deco):$eva(console_txt) $user2 n'est plus un Service Réseau"
				} elseif {[string match *+*N* $umode]} {
 					putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Usermode $eva(console_deco):$eva(console_txt) $user2 est un Administrateur Réseau"
				} elseif {[string match *-*N* $umode]} {
					putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Usermode $eva(console_deco):$eva(console_txt) $user2 n'est plus un Administrateur Réseau"
				} elseif {[string match *+*A* $umode]} {
					putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Usermode $eva(console_deco):$eva(console_txt) $user2 est un Administrateur Serveur"
				} elseif {[string match *-*A* $umode]} {
					putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Usermode $eva(console_deco):$eva(console_txt) $user2 n'est plus un Administrateur Serveur"
				} elseif {[string match *+*a* $umode]} {
					putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Usermode $eva(console_deco):$eva(console_txt) $user2 est un Administrateur Services"
				} elseif {[string match *-*a* $umode]} {
					putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Usermode $eva(console_deco):$eva(console_txt) $user2 n'est plus un Administrateur Services"
				} elseif {[string match *+*C* $umode]} {
					putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Usermode $eva(console_deco):$eva(console_txt) $user2 est un Co-Administrateur"
				} elseif {[string match *-*C* $umode]} {
					putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Usermode $eva(console_deco):$eva(console_txt) $user2 n'est plus un Co-Administrateur"
				} elseif {[string match *+*o* $umode]} {
					putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Usermode $eva(console_deco):$eva(console_txt) $user2 est un IRC Opérateur Global"
				} elseif {[string match *-*o* $umode]} {
					putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Usermode $eva(console_deco):$eva(console_txt) $user2 n'est plus un IRC Opérateur Global"
				} elseif {[string match *+*O* $umode]} {
					putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Usermode $eva(console_deco):$eva(console_txt) $user2 est un IRC Opérateur Local"
				} elseif {[string match *-*O* $umode]} {
					putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Usermode $eva(console_deco):$eva(console_txt) $user2 n'est plus un IRC Opérateur Local"
				} elseif {[string match *+*h* $umode]} {
					putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Usermode $eva(console_deco):$eva(console_txt) $user2 est un Helpeur"
				} elseif {[string match *-*h* $umode]} {
					putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Usermode $eva(console_deco):$eva(console_txt) $user2 n'est plus un Helpeur"
				}
			}
		}
		"NICK" {
			set user [string trim [lindex $arg 0] :]
			set new [lindex $arg 2]
			set vuser [string tolower [string trim [lindex $arg 0] :]]
			set vnew [string tolower [lindex $arg 2]]
			if {[info exists ueva($vuser)] && $vuser!=$vnew} { set ueva($vnew) on; unset ueva($vuser) }
			if {[info exists vhost($vuser)] && $vuser!=$vnew} { set vhost($vnew) $vhost($vuser); unset vhost($vuser) }
			if {[info exists admins($vuser)] && $vuser!=$vnew} { set admins($vnew) $admins($vuser); unset admins($vuser) }
			if {[info exists netadmin($vuser)] && $vuser!=$vnew} { set netadmin($vnew) on; unset netadmin($vuser) }
			if {[eva:console 3]=="ok" && $eva(init)=="0"} { putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Nick $eva(console_deco):$eva(console_txt) $user change son pseudo en $new" }
			if {![info exists ueva($vnew)] && ![info exists admins($vnew)] && [eva:protection $vnew $eva(protection)]!="ok"} {
				catch {open [eva:scriptdir]db/nick.db r} liste
				while {![eof $liste]} {
					gets $liste verif
					if {[string match $verif $vnew] && $verif!=""} {
						if {[eva:console 3]=="ok" && $eva(init)=="0"} { putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Kill $eva(console_deco):$eva(console_txt) $new a été killé : $eva(ruser)" }
						putdcc $eva(idx) ":$eva(pseudo) KILL $vnew $eva(ruser)"; break; eva:refresh $vnew
					}
				}
				catch {close $liste}
			}
		}
		"TOPIC" {
			set user [string trim [lindex $arg 0] :]
			set chan [lindex $arg 2]
			set vchan [string tolower $chan]
			set topic [join [string trim [lrange $arg 5 end] :]]
			if {[eva:console 3]=="ok" && $vchan!=[string tolower $eva(salon)] && $eva(init)=="0"} { putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Topic $eva(console_deco):$eva(console_txt) $user change le topic sur $chan : $topic" }
		}
		"KICK" {
			set user [string trim [lindex $arg 0] :]
			set pseudo [lindex $arg 3]
			set chan [lindex $arg 2]
			set vchan [string tolower [lindex $arg 2]]
			set raison [join [string trim [lrange $arg 4 end] :]]
			if {[eva:console 3]=="ok" && $vchan!=[string tolower $eva(salon)] && $eva(init)=="0"} { putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Kick $eva(console_deco):$eva(console_txt) $pseudo a été kické par $user sur $chan : $raison" }
		}
		"KILL" {
			set pseudo [lindex $arg 2]
			set vpseudo [string tolower [lindex $arg 2]]
			set text [join [string trim [lrange $arg 2 end] :]]
			eva:refresh $vpseudo
			if {[eva:console 1]=="ok" && $eva(init)=="0"} { putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Kill $eva(console_deco):$eva(console_txt) $pseudo : $text" }
			if {$vpseudo==[string tolower $eva(pseudo)]} {
				eva:gestion; putdcc $eva(idx) ":$eva(link) SQUIT $eva(link) :$eva(raison)"
				foreach kill [utimers] { if {[lindex $kill 1]=="eva:verif"} { killutimer [lindex $kill 2] } }
				if {[info exists eva(idx)]} { unset eva(idx) }
				set eva(counter) "0"; if {[eva:config]!="ok"} { utimer 1 eva:connexion }
			}
		}
		"GLOBOPS" {
			set user [string trim [lindex $arg 0] :]
			set vuser [string tolower [string trim [lindex $arg 0] :]]
			set text [join [string trim [lrange $arg 2 end] :]]
			if {[eva:console 3]=="ok" && $eva(init)=="0" && ![info exists ueva($vuser)]} { putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Globops $eva(console_deco):$eva(console_txt) $user : $text" }
		}
		"CHGIDENT" {
			set user [string trim [lindex $arg 0] :]
			set pseudo [lindex $arg 2]
			set ident [lindex $arg 3]
			if {[eva:console 3]=="ok" && $eva(init)=="0"} { putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Chgident $eva(console_deco):$eva(console_txt) $user change l'ident de $pseudo en $ident" }
		}
		"CHGHOST" {
			set user [string trim [lindex $arg 0] :]
			set pseudo [lindex $arg 2]
			set host [lindex $arg 3]
			if {[eva:console 3]=="ok" && $eva(init)=="0"} { putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Chghost $eva(console_deco):$eva(console_txt) $user change l'host de $pseudo en $host" }
		}
		"CHGNAME" {
			set user [string trim [lindex $arg 0] :]
			set pseudo [lindex $arg 2]
			set real [join [string trim [lrange $arg 3 end] :]]
			if {[eva:console 3]=="ok" && $eva(init)=="0"} { putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Chgname $eva(console_deco):$eva(console_txt) $user change le realname de $pseudo en $real" }
		}
		"SETHOST" {
			set user [string trim [lindex $arg 0] :]
			set host [lindex $arg 2]
			if {[eva:console 3]=="ok" && $eva(init)=="0"} { putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Sethost $eva(console_deco):$eva(console_txt) Changement de l'host de $user en $host" }
		}
		"SETIDENT" {
			set user [string trim [lindex $arg 0] :]
			set ident [lindex $arg 2]
			if {[eva:console 3]=="ok" && $eva(init)=="0"} { putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Setident $eva(console_deco):$eva(console_txt) Changement de l'ident de $user en $ident" }
		}
		"SETNAME" {
			set user [string trim [lindex $arg 0] :]
			set real [join [string trim [lrange $arg 2 end] :]]
			if {[eva:console 3]=="ok" && $eva(init)=="0"} { putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Setname $eva(console_deco):$eva(console_txt) Changement du realname de $user en $real" }
		}
		"JOIN" {
			set user [string trim [lindex $arg 0] :]
			set vuser [string tolower $user]
			set chan [string trim [lindex $arg 2] :]
			set vchan [string tolower $chan]
			if {[eva:console 3]=="ok" && $vchan!=[string tolower $eva(salon)] && $eva(init)=="0"} { putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Join $eva(console_deco):$eva(console_txt) $user entre sur $chan" }
			catch {open "[eva:scriptdir]db/salon.db" r} liste
			while {![eof $liste]} {
				gets $liste verif
				if {$verif!="" && [string match *[string trimleft $verif #]* [string trimleft $vchan #]] && $vuser!=[string tolower $eva(pseudo)] && ![info exists ueva($vuser)] && ![info exists admins($vuser)] && [eva:protection $vuser $eva(protection)]!="ok"} {
					set eva(cmd) "badchan"; putdcc $eva(idx) ":$eva(pseudo) JOIN $vchan"; putdcc $eva(idx) ":$eva(pseudo) MODE $vchan +ntsio $eva(pseudo)"
					putdcc $eva(idx) ":$eva(pseudo) TOPIC $vchan :1Salon Interdit le [eva:duree [unixtime]]"; putdcc $eva(idx) ":$eva(link) NAMES $vchan"
					if {[eva:console 3]=="ok" && $eva(init)=="0"} { putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Part $eva(console_deco):$eva(console_txt) $user part de $chan : Salon Interdit" }; break
				}
			}
			catch {close $liste}
		}
		"PART" {
			set user [string trim [lindex $arg 0] :]
			set chan [string trim [lindex $arg 2] :]
			set vchan [string tolower $chan]
			if {[eva:console 3]=="ok" && $vchan!=[string tolower $eva(salon)] && $eva(init)=="0"} { putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Part $eva(console_deco):$eva(console_txt) $user part de $chan" }
		}
		"QUIT" {
			set user [string trim [lindex $arg 0] :]
			set vuser [string tolower [string trim [lindex $arg 0] :]]
			set text [join [string trim [lrange $arg 2 end] :]]
			eva:refresh $vuser
			if {[eva:console 2]=="ok" && $eva(init)=="0"} {
				if {$text!=""} {
					putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Déconnexion $eva(console_deco):$eva(console_txt) $user a quitté l'IRC : $text"
				} else { putdcc $eva(idx) ":$eva(pseudo) PRIVMSG $eva(salon) :$eva(console_com)Déconnexion $eva(console_deco):$eva(console_txt) $user a quitté l'IRC" }
			}
		}
	}
}
