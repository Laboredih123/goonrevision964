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

/world/proc/update_stat()
	src.status = "Goon Station 13 [SS13_version]\]"

	src.status += "<br>"

	if (ticker && master_mode)
		src.status += "Mode: <b>[capitalize(master_mode)]</b>"
	else if (!ticker)
		src.status += "<b>STARTING</b>"

	if (host)
		src.status += ", Host: <b>[host]</b>"
	else if (config && config.hostedby)
		src.status += ", Host: <b>[config.hostedby]</b>"

	src.status += "<br>"

	var/list/features = list()

	if (config && config.enable_authentication)
		features += "goon only"

	if (!enter_allowed)
		features += "closed"

	if (abandon_allowed)
		features += "respawning"

	if (config && config.allow_vote_mode)
		features += "voting"

	if (features)
		src.status += "\[[dd_list2text(features, ", ")]"




/world/New()
	src.update_stat()

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
	auth_motd = file2text("motd-auth.txt")
	no_auth_motd = file2text("motd-noauth.txt")
	if (motd)
		join_motd = motd

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
				for(var/atom/movable/AM as mob|obj in T)
					AM.z = 1
				var/turf/U = locate(T.x, T.y, shuttle_z)
				U.phase1.copy_cop(T.phase1)
				U.phase2.copy_cop(T.phase2)
				U.gas.copy_cop(T.gas)
				srcturfs += T
			else
				dstturfs += T
			throwx = max(throwx,T.x)

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
			U.phase1.copy_cop(T.phase1)
			U.phase2.copy_cop(T.phase2)
			U.gas.copy_cop(T.gas)
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
				U.match_gasses(T)
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
