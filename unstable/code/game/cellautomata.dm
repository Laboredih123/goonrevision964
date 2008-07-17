/obj/landmark/New()

	..()
	src.tag = text("landmark*[]", src.name)
	src.invisibility = 101

	if (name == "shuttle")
		shuttle_z = src.z
		del(src)

	if (name == "airtunnel_stop")
		airtunnel_stop = src.x

	if (name == "airtunnel_start")
		airtunnel_start = src.x

	if (name == "airtunnel_bottom")
		airtunnel_bottom = src.y

	if (name == "monkey")
		monkeystart += src.loc
		del(src)

	if (name == "blobstart")
		blobstart += src.loc
		del(src)
	return

/obj/start/New()

	..()
	src.tag = text("start*[]", src.name)
	src.invisibility = 100
	return

/obj/sp_start/New()

	src.tag = text("spstart[]", src.name)
	src.invisibility = 100
	return

/obj/admins/Topic(href, href_list)
	..()
	if (usr.client != src.owner)
		world << text("\blue [] has attempted to override the admin panel!", usr.key)
		world.log << text("ADMIN: [] tried to use the admin panel without authorization.", usr.key)
		return


	if(href_list["vmode"])

		if ((src.rank in list( "Moderator", "Supervisor", "Administrator", "Major Administrator", "Primary Administrator" )))
			vote.mode = text2num(href_list["vmode"])-1 	// hack to yield 0=restart, 1=changemode
			vote.voting = 1						// now voting
			vote.votetime = world.timeofday + config.vote_period*10	// when the vote will end

			spawn(config.vote_period*10)
				vote.endvote()

			world << "\red<B>*** A vote to [vote.mode?"change game mode":"restart"] has been initiated by Admin [usr.key].</B>"
			world << "\red     You have [vote.timetext(config.vote_period)] to vote."

			world.log_admin("Voting to [vote.mode?"change mode":"restart round"] forced by admin [usr.key]")

			for(var/mob/CM in world)
				if(CM.client)
					if(config.vote_no_default || (config.vote_no_dead && CM.is_dead) || !CM.client.authenticated)
						CM.client.vote = "none"
					else
						CM.client.vote = "default"

	if(href_list["votekill"])
		if ((src.rank in list( "Moderator", "Supervisor", "Administrator", "Major Administrator", "Primary Administrator" )))

			world << "\red <B>***Voting aborted by [usr.key].</B>"

			world.log_admin("Voting aborted by [usr.key]")

			vote.voting = 0
			vote.nextvotetime = world.timeofday + 10*config.vote_delay

			for(var/mob/M in world)		// clear vote window from all clients
				if(M.client)
					M << browse(null, "window=vote")
					M.client.showvote = 0


	if (href_list["vt_rst"])
		if (src.rank in list("Administrator", "Major Administrator", "Primary Administrator"))
			config.allow_vote_restart = !config.allow_vote_restart
			world << "<B>Player restart voting toggled to [config.allow_vote_restart ? "On" : "Off"]</B>."

			world.log_admin("Restart voting toggled to [config.allow_vote_restart ? "On" : "Off"] by [usr.key].")

			if(config.allow_vote_restart)
				vote.nextvotetime = world.timeofday
			update()

	if (href_list["vt_mode"])
		if (src.rank in list("Administrator", "Major Administrator", "Primary Administrator"))
			config.allow_vote_mode = !config.allow_vote_mode
			world << "<B>Player mode voting toggled to [config.allow_vote_mode ? "On" : "Off"]</B>."
			world.log_admin("Mode voting toggled to [config.allow_vote_mode ? "On" : "Off"] by [usr.key].")

			if(config.allow_vote_mode)
				vote.nextvotetime = world.timeofday
			update()

	if (href_list["boot"])
		if ((src.rank in list( "Moderator", "Supervisor", "Administrator", "Major Administrator", "Primary Administrator" )))
			var/dat = "<B>Boot Player:</B><HR>"
			for(var/mob/M in world)
				dat += text("<A href='?src=\ref[];boot2=\ref[]'>N:[] R:[] (K:[]) (IP:[])</A><BR>", src, M, M.name, M.spawn_name, (M.client ? M.client : "No client"), M.last_known_ip)
				//Foreach goto(103)
			usr << browse(dat, "window=boot")
	if (href_list["boot2"])
		if ((src.rank in list( "Moderator", "Supervisor", "Administrator", "Major Administrator", "Primary Administrator" )))
			var/mob/M = locate(href_list["boot2"])
			if (ismob(M))
				if ((M.client && M.client.holder && M.client.holder.rank >= src.rank))
					alert("You cannot perform this. Action you must be of a higher administrative rank!", null, null, null, null, null)
					return
				world.log_admin("[usr.key] booted [M.key].")
				//M.client = null
				del(M.client)
	if (href_list["ban"])
		if ((src.rank in list( "Moderator", "Supervisor", "Administrator", "Major Administrator", "Primary Administrator" )))
			var/dat = "<B>Ban Player:</B><HR>"
			for(var/mob/M in world)
				dat += text("<A href='?src=\ref[];ban2=\ref[]'>N: [] R: [] (K: []) (IP: [])</A><BR>", src, M, M.name, M.spawn_name, (M.client ? M.client : "No client"), M.last_known_ip)
				//Foreach goto(362)
			dat += "<HR><B>Unban Player:</B><HR>"
			for(var/t in banned)
				dat += text("<A href='?src=\ref[];unban2=[]'>K: []</A><BR>", src, ckey(t), t)
				//Foreach goto(424)
			usr << browse(dat, "window=ban")
	if (href_list["ban2"])
		if ((src.rank in list( "Moderator", "Supervisor", "Administrator", "Major Administrator", "Primary Administrator" )))
			var/mob/M = locate(href_list["ban2"])
			if (ismob(M))
				if ((M.client && M.client.holder && M.client.holder.rank >= src.rank))
					alert("You cannot perform this. Action you must be of a higher administrative rank!", null, null, null, null, null)
					return
				world.log_admin("[usr.key] banned [M.key].")
				banned += ckey(M.key)
				//M.client = null
				del(M.client)
	if (href_list["unban2"])
		if ((src.rank in list( "Moderator", "Supervisor", "Administrator", "Major Administrator", "Primary Administrator" )))
			var/t = href_list["unban2"]
			if (t)
				banned -= t
			world.log_admin("[usr.key] unbanned [t].")
	if (href_list["mute"])
		if ((src.rank in list( "Moderator", "Supervisor", "Administrator", "Major Administrator", "Primary Administrator" )))
			var/dat = "<B>Mute/Unmute Player:</B><HR>"
			for(var/mob/M in world)
				dat += text("<A href='?src=\ref[];mute2=\ref[]'>N:[] R:[] (K:[]) (IP: []) \[[]\]</A><BR>", src, M, M.name, M.spawn_name, (M.client ? M.client : "No client"), M.last_known_ip, (M.muted ? "Muted" : "Voiced"))
				//Foreach goto(757)
			usr << browse(dat, "window=mute")
	if (href_list["mute2"])
		if ((src.rank in list( "Moderator", "Supervisor", "Administrator", "Major Administrator", "Primary Administrator" )))
			var/mob/M = locate(href_list["mute2"])
			if (ismob(M))
				if ((M.client && M.client.holder && M.client.holder.rank >= src.rank))
					alert("You cannot perform this. Action you must be of a higher administrative rank!", null, null, null, null, null)
					return
				world.log_admin("[usr.key] altered [M.key]'s mute status.")
				M.muted = !( M.muted )
	if (href_list["restart"])
		if ((src.rank in list( "Game Master", "Supervisor", "Administrator", "Major Administrator", "Primary Administrator" )))
			var/dat = text("<B>Restart game?</B><HR>\n<BR>\n<A href='?src=\ref[];restart2=1'>Yes</A>\n", src)
			usr << browse(dat, "window=restart")
	if (href_list["restart2"])
		if ((src.rank in list( "Game Master", "Supervisor", "Administrator", "Major Administrator", "Primary Administrator" )))
			world << text("\red <B> Restarting world!</B>\blue  Initiated by []!", usr.key)
			world.log_admin("[usr.key] initiated a reboot.")
			sleep(50)
			world.Reboot()
	if (href_list["restart3"])
		if ((src.rank in list( "Game Master", "Supervisor", "Administrator", "Major Administrator", "Primary Administrator" )))
			if( alert("Reboot server?",,"Yes","No") == "No")
				return
			world << text("\red <B> Rebooting world!</B>\blue  Initiated by []!", usr.key)
			world.log_admin("[usr.key] initiated an immediate reboot.")
			world.Reboot()
	if (href_list["c_mode"])
		if ((src.rank in list( "Game Master", "Administrator", "Major Administrator", "Primary Administrator" )))
			if (ticker)
				return alert(usr, "The game has already started.", null, null, null, null)
			var/dat = text("<B>What mode do you wish to play?</B><HR>\n<A href='?src=\ref[];c_mode2=secret'>Secret</A><br>\n<A href='?src=\ref[];c_mode2=random'>Random</A><br>\n<A href='?src=\ref[];c_mode2=traitor'>Traitor</A><br>\n<A href='?src=\ref[];c_mode2=meteor'>Meteor</A><br>\n<A href='?src=\ref[];c_mode2=extended'>Extended</A><br>\n<A href='?src=\ref[];c_mode2=monkey'>Monkey</A><br>\n<A href='?src=\ref[];c_mode2=nuclear'>Nuclear Emergency</A><br>\n<A href='?src=\ref[];c_mode2=blob'>Blob</A><br>\n<A href='?src=\ref[];c_mode2=sandbox'>Sandbox</A><br>\n\nNow: []\n", src, src, src, src, src, src, src, src, src, master_mode)
			usr << browse(dat, "window=c_mode")
	if (href_list["c_mode2"])
		if ((src.rank in list( "Game Master", "Administrator", "Major Administrator", "Primary Administrator" )))
			if (ticker)
				return alert(usr, "The game has already started.", null, null, null, null)
			switch(href_list["c_mode2"])
				if("secret")
					master_mode = "secret"
				if("random")
					master_mode = "random"
				if("traitor")
					master_mode = "traitor"
				if("meteor")
					master_mode = "meteor"
				if("extended")
					master_mode = "extended"
				if("monkey")
					master_mode = "monkey"
				if("nuclear")
					master_mode = "nuclear"
				if("megamonkey")
					master_mode = "megamonkey"
				if("blob")
					master_mode = "blob"
				if("sandbox")
					master_mode = "sandbox"
				else
			world.log_admin("[usr.key] set the mode as [master_mode].")
			world << text("\blue <B>The mode is now: []</B>", master_mode)

			var/F = file(persistent_file)
			fdel(F)
			F << master_mode

	if (href_list["l_ban"])
		var/dat = "<HR><B>Banned Keys:</B><HR>"
		for(var/t in banned)
			dat += text("[]<BR>", ckey(t))
			//Foreach goto(1424)
		if ((src.rank in list( "Moderator", "Supervisor", "Administrator", "Major Administrator", "Primary Administrator" )))
			dat += text("<HR><A href='?src=\ref[];boot=1'>Goto Ban Control Screen</A>", src)
		usr << browse(dat, "window=ban_k")
	if (href_list["l_keys"])
		var/dat = "<B>Keys:</B><HR>"
		for(var/mob/M in world)
			if (M.client)
				dat += text("[]<BR>", M.client.ckey)
			//Foreach goto(1525)
		usr << browse(dat, "window=keys")
	if (href_list["l_players"])
		var/dat = "<table><tr><th>Name</th><th>Spawn name</th><th>Client</th><th>IP</th><th>Authorized?</th></tr>"
		for(var/mob/M in world)
			dat += "<tr>"
			dat += "<td>[M.name]</td>"
			dat += "<td>[M.spawn_name]</td>"
			dat += "<td>[M.client ? M.client : "No client"]</td>"
			dat += "<td>[M.last_known_ip]</td>"
			if(M.client)
				if(!M.client.authenticated && !M.client.authenticating)
					dat += "<td><a href='?src=\ref[src];adminauth=\ref[M]'>Authorize</a>"
				else
					dat += "<td>Authorized</td>"
			else
				dat += "<td>No client</td>"
			dat += "</tr>"
		dat += "</table>"
		usr << browse(dat, "window=players")
	if (href_list["adminauth"])
		if ((src.rank in list( "Moderator", "Supervisor", "Administrator", "Major Administrator", "Primary Administrator" )))
			var/mob/M = locate(href_list["adminauth"])
			if (ismob(M) && !M.client.authenticated && !M.client.authenticating)
				M.client.verbs -= /client/proc/authorize
				M.client.authenticated = text("admin/[]", usr.client.authenticated)
				world.log_admin(text("ADMIN: [] authorized []", usr.key, M.spawn_name))
				M.client << text("You have been authorized by []", usr.key)
	if (href_list["g_send"])
		var/t = input("Global message to send:", "Admin Announce", null, null)  as message
		if (t)
			world << "\blue <B>[usr.key] Announces:</B>\n \t [t]"
			world.log_admin("Announce: [usr.key] : [t]")
	if (href_list["p_send"])
		var/dat = "<B>To whom are you sending a message?</B><HR>"
		for(var/mob/M in world)
			dat += "<A href='?src=\ref[usr];priv_msg=\ref[M]'>N:[M.name] R:[M.spawn_name] (K:[(M.client ? M.client : "No client")])</A><BR>"
			//Foreach goto(1737)
		usr << browse(dat, "window=p_send")

	/*
	if (href_list["p_send2"])
		if (locate(href_list["p_send2"]))
			var/mob/M = locate(href_list["p_send2"])
			if (!( ismob(M) ))
				return
			var/t = input("Message:", text("Private message to []", M.key), null, null)  as text
			if (!( t ))
				return
			if (M.client && M.client.holder)
				M << text("\blue Admin PM from-<B><A href='?src=\ref[];p_send2=\ref[]'>[]</A></B>: []", M.client.holder, usr, usr.key, t)
			else
				M << text("\blue Admin PM from-<B>[]</B>: []", usr.key, t)
			usr << text("\blue Admin PM to-<B><A href='?src=\ref[];p_send2=\ref[]'>[]</A></B>: []", src, M, M.key, t)
			world.log_admin("PM: [usr.key]->[M.key] : [t]")
	*/

	if (href_list["m_item"])
		var/X = typesof(/obj/item/weapon)
		var/Q = input("What item?", null, null, null)  as null|anything in X
		if (!( Q ))
			return
		new Q( usr.loc )
		world.log_admin("[usr.key] created a [Q]")
	if (href_list["m_obj"])
		var/X = typesof(/obj) - typesof(/obj/item)
		var/Q = input("What object?", null, null, null)  as null|anything in X
		if (!( Q ))
			return
		new Q( usr.loc )
		world.log_admin("[usr.key] created a [Q]")
	if (href_list["dna"])
		if ((src.rank in list( "Game Master", "Administrator", "Major Administrator", "Primary Administrator" )))
			var/dat = "<B>Registered DNA sequences:</B><HR>"
			for(var/M in reg_dna)
				dat += text("\t [] = []<BR>", M, reg_dna[text("[]", M)])
				//Foreach goto(2171)
			usr << browse(dat, "window=dna")
	if (href_list["t_ooc"])
		if ((src.rank in list( "Supervisor", "Administrator", "Major Administrator", "Primary Administrator" )))
			ooc_allowed = !( ooc_allowed )
			if (ooc_allowed)
				world << "<B>The OOC channel has been globally enabled!</B>"
			else
				world << "<B>The OOC channel has been globally disabled!</B>"
			world.log_admin("[usr.key] toggled OOC.")
	if (href_list["startnow"])
		if ((src.rank in list( "Supervisor", "Administrator", "Major Administrator", "Primary Administrator" )))
			world << "<B>The game will now start immediately thanks to [usr.key]!</B>"
			going = 1
			if (!ticker)
				ticker = new /datum/control/gameticker()
				spawn (0)
					world.log_admin("[usr.key] used start_now")
					ticker.process()
				data_core = new /obj/datacore()
	if (href_list["toggle_enter"])
		if ((src.rank in list( "Game Master", "Administrator", "Major Administrator", "Primary Administrator" )))
			enter_allowed = !( enter_allowed )
			if (!( enter_allowed ))
				world << "<B>You may no longer enter the game.</B>"
			else
				world << "<B>You may now enter the game.</B>"
			world.log_admin("[usr.key] toggled new player game entering.")
			world.update_stat()
			update()
	if (href_list["toggle_ai"])
		if ((src.rank in list( "Game Master", "Administrator", "Major Administrator", "Primary Administrator" )))
			config.allow_ai = !( config.allow_ai )
			if (!( config.allow_ai ))
				world << "<B>The AI job is no longer chooseable.</B>"
			else
				world << "<B>The AI job is chooseable now.</B>"
			world.log_admin("[usr.key] toggled AI allowed.")
			world.update_stat()
			update()
	if (href_list["toggle_abandon"])
		if ((src.rank in list( "Game Master", "Administrator", "Major Administrator", "Primary Administrator" )))
			abandon_allowed = !( abandon_allowed )
			if (abandon_allowed)
				world << "<B>You may now abandon mob.</B>"
			else
				world << "<B>Live or Die Mode Activated</B>"
				world.log_admin("[usr.key] toggled abandon mob to [abandon_allowed ? "On" : "Off"].")
			world.update_stat()
			update()
	if (href_list["delay"])
		if ((src.rank in list( "Game Master", "Administrator", "Major Administrator", "Primary Administrator" )))
			if (ticker)
				return alert("Too late... The game has already started!", null, null, null, null, null)
			going = !( going )
			if (!( going ))
				world << text("<B>The game start has been delayed by [] (Administrator to SS13)</B>", usr.key)
				world.log_admin("[usr.key] delayed the game.")
			else
				world << text("<B>The game will start soon thanks to [] (Administrator to SS13)</B>", usr.key)
				world.log_admin("[usr.key] removed the delay.")
	if (href_list["secrets"])
		if ((src.rank in list( "Game Master", "Administrator", "Major Administrator", "Primary Administrator" )))
			var/dat = {"
<B>What secret do you wish to activate?</B><HR>
<A href='?src=\ref[src];secrets2=sec_clothes'>Remove 'internal' clothing</A><BR>
<A href='?src=\ref[src];secrets2=sec_all_clothes'>Remove ALL clothing</A><BR>
<A href='?src=\ref[src];secrets2=sec_classic1'>Remove firesuits, grilles, and pods</A><BR>
<A href='?src=\ref[src];secrets2=clear_bombs'>Remove all bombs currently  existence</A><BR>
<A href='?src=\ref[src];secrets2=list_bombers'>Show a list of all people who made a bomb</A><BR>
<A href='?src=\ref[src];secrets2=check_antagonist'>Show the key of the traitor</A><BR>
<A href='?src=\ref[src];secrets2=toxic'>Toxic Air (WARNING: dangerous)</A><BR>
<A href='?src=\ref[src];secrets2=power'>Make all areas powered</A><BR>
<A href='?src=\ref[src];secrets2=wave'>Spawn a wave of meteors</A><BR>"}

			usr << browse(dat, "window=secrets")
	if (href_list["secrets2"])
		if ((src.rank in list( "Game Master", "Administrator", "Major Administrator", "Primary Administrator" )))
			var/ok = 0
			switch(href_list["secrets2"])
				if("sec_clothes")
					for(var/obj/item/weapon/clothing/under/O in world)
						//O = null
						del(O)
						//Foreach goto(2781)
					ok = 1
				if("sec_all_clothes")
					for(var/obj/item/weapon/clothing/O in world)
						//O = null
						del(O)
						//Foreach goto(2833)
					ok = 1
				if("sec_classic1")
					for(var/obj/item/weapon/clothing/suit/firesuit/O in world)
						//O = null
						del(O)
						//Foreach goto(2885)
					for(var/obj/grille/O in world)
						//O = null
						del(O)
						//Foreach goto(2928)
					for(var/obj/machinery/vehicle/pod/O in world)
						for(var/mob/M in src)
							M.loc = src.loc
							if (M.client)
								M.client.perspective = MOB_PERSPECTIVE
								M.client.eye = M
							//Foreach goto(3001)
						//O = null
						del(O)
						//Foreach goto(2971)
					ok = 1
				if("clear_bombs")
					for(var/obj/item/weapon/assembly/r_i_ptank/O in world)
						del(O)
					for(var/obj/item/weapon/assembly/m_i_ptank/O in world)
						del(O)
					for(var/obj/item/weapon/assembly/t_i_ptank/O in world)
						del(O)
					ok = 1
				if("list_bombers")
					var/dat = "<B>Don't be insane about this list</B> Get the facts. They also could have disarmed one.<HR>"
					for(var/l in bombers)
						dat += text("[] 'made' a bomb.<BR>", l)
						//Foreach goto(3149)
					usr << browse(dat, "window=bombers")
				if("toxic")
					for(var/obj/machinery/atmoalter/siphs/fullairsiphon/O in world)
						O.t_status = 3
						//Foreach goto(3194)
					for(var/obj/machinery/atmoalter/siphs/scrubbers/O in world)
						O.t_status = 1
						O.t_per = 1000000.0
						//Foreach goto(3234)
					for(var/obj/machinery/atmoalter/canister/O in world)
						if (!( istype(O, /obj/machinery/atmoalter/canister/oxygencanister) ))
							O.t_status = 1
							O.t_per = 1000000.0
						else
							O.t_status = 3
						//Foreach goto(3282)
				if("check_antagonist")
					if (ticker)
						if (ticker.killer)
							if (ticker.killer.ckey)
								alert(text("The traitor's key is [].", ticker.killer.ckey), null, null, null, null, null)
							else
								alert("It seems like the traitor logged out...", null, null, null, null, null)
						else
							alert("There is no traitor.", null, null, null, null, null)
					else
						alert("The game has not started yet.", null, null, null, null, null)
				if("power")
					world.log_admin("[usr.key] used secret [href_list["secrets2"]]")

					for(var/area/A in world)
						A.requires_power = 0
						A.power_light = 1
						A.power_equip = 1
						A.power_environ = 1

						A.power_change()
				if("wave")
					world.log_admin("[usr.key] used secret [href_list["secrets2"]]")
					meteor_wave()
				else
			if (usr)
				world.log_admin("[usr.key] used secret [href_list["secrets2"]]")
				if (ok)
					world << text("<B>A secret has been activated by []!</B>", usr.key)
	return

/obj/admins/proc/update()

	var/dat
	var/lvl = 0
	switch(src.rank)
		if("Moderator")
			lvl = 1
		if("Game Master")
			lvl = 2
		if("Supervisor")
			lvl = 3
		if("Administrator")
			lvl = 4
		if("Major Administrator")
			lvl = 5
		if("Primary Administrator")
			lvl = 6



	switch(src.screen)
		if(1.0)

			dat += "<center><B>Admin Control Console</B></center><hr>\n"

			if(lvl>=4)
				dat += {"
	<A href='?src=\ref[src];boot=1'>Boot Player/Key</A><br>
	<A href='?src=\ref[src];ban=1'>Ban/Unban Player/Key</A><br>
	<A href='?src=\ref[src];mute=1'>Mute/Unmute Player/Key</A><br>
	"}
			dat += "<br>"

			if(lvl!=1)
				dat += "<A href='?src=\ref[src];t_ooc=1'>Toggle OOC</A><br>"
				dat += "<A href='?src=\ref[src];delay=1'>Delay Game</A><br>"
				dat += "<A href='?src=\ref[src];startnow=1'>Start Round Now</A><br>"

			if(lvl >=3 )
				dat += "<A href='?src=\ref[src];toggle_enter=1'>Toggle Entering [enter_allowed]</A><br>"
				dat += "<A href='?src=\ref[src];toggle_abandon=1'>Toggle Abandon [abandon_allowed]</A><br>"
				dat += "<A href='?src=\ref[src];toggle_ai=1'>Toggle AI [config.allow_ai]</A><br>"

				dat += "<A href='?src=\ref[src];c_mode=1'>Change Game Mode</A><br>"
			if(lvl >= 2)
				dat += "<A href='?src=\ref[src];restart=1'>Restart Game</A><br>"
				dat += "<A href='?src=\ref[src];restart3=1'>Immediate Reboot</A><br>"

			dat += "<BR>"

			if(lvl!=1)
				dat += "<A href='?src=\ref[src];vmode=1'>Begin restart vote.</A><BR>"
				dat += "<A href='?src=\ref[src];vmode=2'>Begin change mode vote.</A><BR>"
				dat += "<A href='?src=\ref[src];votekill=1'>Abort current vote.</A><BR>"

			if(lvl>=3)
				dat += "<A href='?src=\ref[src];vt_rst=1'>Toggle restart voting [config.allow_vote_restart].</A><BR>"
				dat += "<A href='?src=\ref[src];vt_mode=1'>Toggle mode voting [config.allow_vote_mode].</A><BR>"

			dat += "<BR>"

			if(lvl >=3 )
				dat += "<A href='?src=\ref[src];secrets=1'>Activate Secrets</A><br>"
				dat += "<A href='?src=\ref[src];m_item=1'>Make Item</A><br>"
				dat += "<A href='?src=\ref[src];m_obj=1'>Make Object</A><br>"

			dat += "<BR>"
			if(lvl >=3 )

				dat += "<A href='?src=\ref[src];dna=1'>List DNA</A><br>"
				dat += "<A href='?src=\ref[src];l_keys=1'>List Keys</A><br>"
				dat += "<A href='?src=\ref[src];l_players=1'>List Players/Keys</A><br>"

			dat += "<A href='?src=\ref[src];g_send=1'>Send Global Message</A><br>"
			dat += "<A href='?src=\ref[src];p_send=1'>Send Private Message</A><br>"


		else
			dat = text("<center><B>Admin Control Center</B></center><hr>\n<A href='?src=\ref[];access=1'>Access Admin Commands</A><br>\n<A href='?src=\ref[];contact=1'>Contact Admins</A><br>\n<A href='?src=\ref[];message=1'>Access Messageboard</A><br>\n<br>\n<A href='?src=\ref[];l_keys=1'>List Keys</A><br>\n<A href='?src=\ref[];l_players=1'>List Players/Keys</A><br>\n<A href='?src=\ref[];g_send=1'>Send Global Message</A><br>\n<A href='?src=\ref[];p_send=1'>Send Private Message</A><br>", src, src, src, src, src, src, src)
	usr << browse(dat, "window=admin")
	return

/world/proc/update_stat()
	src.status = "Goon Station 13 [SS13_version]"

	var/list/features = list()

	if (config && config.enable_authentication)
		features += "goon only"

	if (!enter_allowed)
		features += "closed"

	if (abandon_allowed)
		features += "respawn"

	if (config && config.allow_vote_mode)
		features += "vote"

	if (features)
		src.status += ": [dd_list2text(features, ", ")]"

	src.status += "<br>"

	if (ticker && master_mode)
		src.status += "Mode: <b>[capitalize(master_mode)]</b>"
	else if (!ticker)
		features += "<b>STARTING</b>"

	if (host)
		src.status += ", Host: <b>[host]</b>"
	else if (config && config.hostedby)
		src.status += ", Host: <b>[config.hostedby]</b>"




/world/New()
	src.update_stat()

	for (var/turf/T in world)
		T.updatelinks()

	makepipelines()
	makepowernets()

	sun = new /datum/sun()

	// ****stuff for presistent mode picking
	var/newmode = null

	var/modefile = file2text(persistent_file)

	if(modefile)			// stuff to fix trailing NL problems
		var/list/ML = dd_text2list(modefile, "\n")

		newmode = ML[1]

		//world << "Savefile: [SF] ([SF["newmode"]])"

		if(newmode)
			master_mode = newmode
			world.log << "Read default mode '[newmode]' from [persistent_file]"


	// *****

	var/motd = file2text("motd.txt")
	if (motd)
		world_message = motd
	var/ad_text = file2text("admins.txt")
	var/list/L = dd_text2list(ad_text, "\n")
	for(var/t in L)
		if (t)
			if (copytext(t, 1, 2) == ";")
				continue //goto(64)
			var/t1 = findtext(t, " - ", 1, null)
			if (t1)
				var/m_key = copytext(t, 1, t1)
				var/a_lev = text("[]", copytext(t, t1 + 3, length(t) + 1))
				admins[text("[]", m_key)] = text("[]", a_lev)
		//Foreach goto(64)

	config = new /datum/configuration()
	config.load("config.txt")

	// apply some settings from config..
	abandon_allowed = config.respawn

	vote = new /datum/vote()

	SS13_airtunnel = new /datum/air_tunnel/air_tunnel1(  )

	..()

	sleep(50)

	nuke_code = text("[]", rand(10000, 99999.0))
	for(var/obj/machinery/nuclearbomb/N in world)
		if (N.r_code == "ADMIN")
			N.r_code = nuke_code
	sleep(50)

	plmaster = new /obj/overlay(  )
	plmaster.icon = 'plasma.dmi'
	plmaster.icon_state = "onturf"
	plmaster.layer = FLY_LAYER

	slmaster = new /obj/overlay(  )
	slmaster.icon = 'plasma.dmi'
	slmaster.icon_state = "sl_gas"
	slmaster.layer = FLY_LAYER

	cellcontrol = new /datum/control/cellular()
	spawn (0)
		cellcontrol.process()
		return

	src.update_stat()

	spawn (0)
		sleep(900)		//*****RM was 900
		Label_482:
		if (going && (!ticker))
			ticker = new /datum/control/gameticker(  )
			spawn( 0 )
				ticker.process()
				return
			data_core = new /obj/datacore(  )
		else
			sleep(100)
			goto Label_482
		return
	return

/world/Topic(T, addr, master, key)
	world.log << "TOPIC: \"[T]\", from:[addr], master:[master], key:[key]"

	if(T == "ping")
		var/x = 1
		for (var/client/C)
			x++
		return x
	else if (T == "reboot" && master)
		world.log << "TOPIC: Remote reboot from master ([addr])"
		world.Reboot()
	else if(T == "players")
		var/n = 0
		for(var/mob/M in world)
			if(M.client)
				n++
		return n

/mob/proc/CanAdmin()
	if (world.address == src.client.address)
		return 1
	if (src.client.address == "127.0.0.1")
		return 1
	if (!( src.client.address ))
		return 1
	return 0


/atom/proc/check_eye(user as mob)
	if (istype(user, /mob/silicon/ai))
		return 1
	return

/atom/proc/Bumped(AM as mob|obj)

	return

/atom/proc/hear_message()
	return

/atom/movable/Bump(var/atom/A as mob|obj|turf|area, yes)

	spawn( 0 )
		if ((A && yes))
			A.Bumped(src)
		return
	..()
	return

// **** Note in 40.93.4, split into obj/mob/turf point verbs, no area

/atom/verb/point()
	set src in oview()

	if ((!( usr ) || !( isturf(usr.loc) )) || isarea(src))		// can't point to areas anymore
		return
	if (usr.can_use_hands())
		var/P = new /obj/point( (isturf(src) ? src : src.loc) )
		spawn( 20 )
			//P = null
			del(P)
			return
		usr.show_viewers(text("<B>[]</B> points to []", usr, src))
			//Foreach goto(102)
	return

/turf/proc/updatecell()

	return

/turf/proc/conduction()
	return

/turf/proc/cachecell()

	return

/datum/control/proc/process()

	return

/datum/control/gameticker/proc/meteor_process()

	do
		if (!( shuttle_frozen ))
			if (src.timing == 1)
				src.timeleft -= 10
			else
				if (src.timing == -1.0)
					src.timeleft += 10
					if (src.timeleft >= shuttle_time_to_arrive)
						src.timeleft = null
						src.timing = 0
		spawn_meteors()
		if ((src.timeleft <= 0 && src.timing && !( prison_entered )))
			src.timeup()

		sleep(10)
	while(src.processing)
	return


/datum/control/gameticker/proc/megamonkey_process()

	do
		if (prob(2))
			spawn_meteors()

		world << "megamonkey_process check_win"
		check_win()

		sleep(50)
	while(src.processing)
	return

/datum/control/gameticker/proc/extend_process()

	do
		if (!( shuttle_frozen ))
			if (src.timing == 1)
				src.timeleft -= 10
			else
				if (src.timing == -1.0)
					src.timeleft += 10
					if (src.timeleft >= shuttle_time_to_arrive)
						src.timeleft = null
						src.timing = 0
		if (prob(0.5))
			spawn_meteors()
		if ((src.timeleft <= 0 && (src.timing && (!( prison_entered ) || src.shuttle_location == 1))))
			src.timeup()

		sleep(10)
	while(src.processing)
	return

/datum/control/gameticker/proc/nuclear(z_level)

	if (src.mode != "nuclear")
		return
	if (z_level != 1)
		return
	spawn( 0 )
		src.objective = "Success"
		world << "<B>The Syndicate Operatives have destroyed Space Station 13!</B>"
		for(var/mob/carbon/H in world)
			if ((H.client && findtext(H.spawn_name, "Syndicate ", 1, null)))
				if (!H.is_dead)
					world << text("<B>[] was []</B>", H.key, H.spawn_name)
				else
					world << text("[] was [] (Dead)", H.key, H.spawn_name)
		src.timing = 0
		sleep(300)
		world.log_game("Syndicate success")
		world.Reboot()
		return
	return

/datum/control/gameticker/proc/timeup()


	var/area/A = locate(/area/shuttle)
	if (src.shuttle_location == shuttle_z)

		var/list/srcturfs = list()
		var/list/dstturfs = list()
		var/throwx = 0

		for(var/turf/T in A)
			if (T.z == shuttle_z)
				srcturfs += T
			else
				dstturfs += T
			if(T.x > throwx)
				throwx = T.x

		// hey you, get out of the way!
		for(var/turf/T in dstturfs)
			// find the turf to move things to
			var/turf/D = locate(throwx, T.y, 1)
			var/turf/E = get_step(D, EAST)
			for(var/atom/movable/AM as mob|obj in T)
				// east! the mobs go east!
				AM.Move(D)
				spawn(0)
					AM.throw_at(E, 1, 1)
					return
		for(var/turf/T in srcturfs)
			for(var/atom/movable/AM as mob|obj in T)
				// first of all, erase any non-space turfs in the zone in
				var/turf/U = locate(T.x, T.y, 1)
				if(!istype(U, /turf/space))
					var/turf/space/S = new /turf/space( locate(U.x, U.y, U.z) )
					A.contents -= S
					A.contents += S
				AM.z = 1
			var/turf/U = locate(T.x, T.y, shuttle_z)
			U.oxygen = T.oxygen
			U.oldoxy = T.oldoxy
			U.tmpoxy = T.tmpoxy
			U.poison = T.poison
			U.oldpoison = T.oldpoison
			U.tmppoison = T.tmppoison
			U.co2 = T.co2
			U.oldco2 = T.oldco2
			U.tmpco2 = T.tmpco2

			U.buildlinks()
			del(T)
		src.timeleft = shuttle_time_in_station
		src.shuttle_location = 1
		world << "<B>The emergency shuttle has docked with the station! You have [ticker.timeleft/600] minutes to board the shuttle.</B>"
	else
		world << "<B>The emergency shuttle is leaving!</B>"
		check_win()
	return

/datum/control/gameticker/proc/check_win()
	if (!mode.check_win())
		return 0

	for (var/mob/silicon/ai/aiPlayer in world)
		if (!aiPlayer.is_dead)
			world << "<b>The AI's laws at the end of the game were:</b>"
		else
			world << "<b>The AI's laws when it was deactivated were:</b>"
		aiPlayer.showLaws(1)

	var/area/A = locate(/area/shuttle)
	if (src.shuttle_location != shuttle_z)
		for(var/turf/T in A)
			if (T.z == 1)
				for(var/atom/movable/AM as mob|obj in T)
					AM.z = shuttle_z
					//Foreach goto(2483)
				var/turf/U = locate(T.x, T.y, shuttle_z)
				U.oxygen = T.oxygen
				U.oldoxy = T.oldoxy
				U.tmpoxy = T.tmpoxy
				U.poison = T.poison
				U.oldpoison = T.oldpoison
				U.tmppoison = T.tmppoison
				U.co2 = T.co2
				U.oldco2 = T.oldco2
				U.tmpco2 = T.tmpco2

				U.buildlinks()
				//T = null
				del(T)
			//Foreach goto(2449)
	sleep(300)
	world.log_game("Rebooting due to end of game")
	world.Reboot()
	return 1

/datum/control/gameticker/process()

	shuttle_location = shuttle_z

	world.update_stat()
	world << "<B>Welcome to the Space Station 13!</B>\n\n"

	switch (master_mode)
		if("secret")
			src.mode = config.pick_random_mode()
			world << "<B>The current game mode is - Secret!</B>"
			world << "<B>The game will pick between meteor, traitor, blob, or monkey mode!</B>"
		if("random")
			src.mode = config.pick_random_mode()
			world << "<B>The current game mode is - Random</B>"
			world << "<B>The game has picked mode: \red [src.mode.name]</B>"
		else
			src.mode = config.pick_mode(master_mode)
			src.mode.announce()

	src.mode.pre_setup()

	world << "<B>Now dispensing all identification cards.</B>"

	world.log_game("GAME: starting game of [src.mode.name]")

	DivideOccupations()

	for (var/obj/manifest/M in world)
		M.manifest()


	data_core.manifest()

	src.mode.post_setup()

	for(var/obj/start/S in world)
		del(S)

// *****
// MAIN LOOP OF PROGRAM
// *****

/datum/control/cellular/process()
	set invisibility = 0
	set background =1
	do

		//world << "World.contents.len [world.contents.len]"

		time = (++time %10)

		sun.calc_position()

		//if(Debug)
		//	world.log << "*** SoT ***"
		//	Air()

		for(var/turf/station/T in world)
			if (T.updatecell)
				T.updatecell()
				if(!time)
					T.conduction()
		//if(Debug)
		//	world.log << "*** EoT ***"
		//	Air()

			//Foreach goto(73)
		sleep(3)
		for(var/mob/M in world)
			spawn( 0 )
				M.Life()
				return
			//Foreach goto(126)
		sleep(3)
		for(var/obj/move/S in world)
			S.process()
			//Foreach goto(167)
		sleep(2)

		//if(Debug)
		//	world.log << "*** SoP ***"
		//	Air()


		for(var/obj/machinery/M in machines)
			M.process()

		for(var/obj/machinery/M in gasflowlist)
			M.gas_flow()

		for(var/datum/powernet/P in powernets)
			P.reset()

		//if(Debug)
		//	world.log << "*** EoP ***"
		//	Air()

			//Foreach goto(213)
		src.var_swap = !( src.var_swap )

		sleep(2)
	while (src.processing)
