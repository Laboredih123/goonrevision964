/obj/landmark/New()

	..()
	src.tag = text("landmark*[]", src.name)
	src.invisibility = 101

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
	src.invisibility = 101
	return

/obj/sp_start/New()

	src.tag = text("spstart[]", src.name)
	src.invisibility = 101
	return

/world/proc/update_stat()
	src.status = "[SS13_version]\]<BR>"

	if(!game_started)
		src.status += "<b>STARTING</b>"
	else if(config.current_mode)
		src.status += "Mode: <b>[config.current_mode.long_name]</b>"

	if(host)
		src.status += ", Host: <b>[host]</b>"
	else if(config && config.hostedby)
		src.status += ", Host: <b>[config.hostedby]</b>"

	src.status += "<br>"

	var/list/features = list()

	if(config)
		switch(config.enable_authentication)
			if(0)	features += "public mode"
			if(1)	features += "limited mode"
			if(2)	features += "private mode"
		if(config.allow_vote_mode)
			features += "voting"

	if(!enter_allowed)		features += "closed"
	if(abandon_allowed)	features += "respawning"
	if(features)			src.status += "\[[dd_list2text(features, ", ")]"


/world/New()
	shuttles_by_area_type = list(/area/shuttle/emergency = emergency_shuttle, /area/shuttle/commando = commando_shuttle)
	src.update_stat()

	makepipelines()
	makepowernets()

	sun = new /datum/sun()

	// *****

	var/motd = file2text("motd.txt")
	auth_motd = file2text("motd-auth.txt")
	no_auth_motd = file2text("motd-noauth.txt")
	if (motd)
		join_motd = motd

	var/f = file2text(CURROUND_FILENAME)
	if(f)
		curround = text2num(f)

	//	Setup Configurations
	config = new /datum/configuration()
	config.load("config.txt")

	// ****stuff for persistent mode picking
	var/newmode = null

	var/modefile = file2text(persistent_file)

	if(modefile)			// stuff to fix trailing NL problems
		var/list/ML = dd_text2list(modefile, "\n")

		newmode = ML[1]

		if(newmode)
			config.master_mode = get_mode(newmode)
			world.log << "Read default mode '[newmode]' from [persistent_file]"
		else
			config.master_mode = get_mode("secret")



	//	Load Default Names
	first_names_male = dd_file2list("first_names_male.txt")
	first_names_female = dd_file2list("first_names_female.txt")
	last_names = dd_file2list("last_names.txt")

	ai_names = dd_file2list("ai_names.txt")
	// apply some settings from config..
	abandon_allowed = config.respawn

	..()

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
		if (going && (!game_started))
			spawn( 0 )
				start_game()
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
	if(!usr)		return
	if(isarea(src))		return
	if(!isturf(usr.loc))	return
	if(!usr.can_use_hands())	return

	var/P = new /obj/point( (isturf(src) ? src : src.loc) )
	spawn( 20 )
		del(P)
		return
	usr.show_viewers(text("<B>[]</B> points to []", usr, src))
	return

/turf/proc/updatecell()			return
/turf/proc/conduction()			return
/turf/proc/cachecell()			return
/datum/control/proc/process()	return

/proc/start_game()
	game_started = 1
	curround++
	var/F = file(CURROUND_FILENAME)
	fdel(F)
	F << curround
	world.update_stat()
	world << "<B>Welcome to the station!</B>\n\n"

	config.current_mode = config.master_mode
	config.current_mode.announce()
	config.current_mode.setup()

	world << "<B>Now dispensing all identification cards.</B>"

	world.log_game("[config.current_mode.long_name] round starting")

	divide_jobs()
	for(var/obj/manifest/M in world)
		M.manifest()
	data_core.manifest()

	config.current_mode.execute()
	for(var/obj/start/S in world)
		del(S)

// *****
// MAIN LOOP OF PROGRAM
// *****

/datum/control/cellular/process()
	set invisibility = 0
	set background =1
	do
		time = (++time %10)
		sun.calc_position()

		for(var/turf/station/T in world)
			if (T.updatecell)
				T.updatecell()
				if(!time) T.conduction()

		sleep(3)
		for(var/mob/M in world)
			spawn( 0 )
				M.Life()
				return

		sleep(3)
		for(var/obj/machinery/M in machines)		M.process()
		for(var/obj/machinery/M in gasflowlist)		M.gas_flow()
		for(var/datum/powernet/P in powernets)		P.reset()
		src.var_swap = !(src.var_swap)
		sleep(2)
	while (src.processing)

/proc/set_default_mode(datum/game_mode/mode)
	var/F = file(persistent_file)
	fdel(F)
	F << mode.config_name