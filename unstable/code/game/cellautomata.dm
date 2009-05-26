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
	src.status = "Goonstation [SS13_version]\]<BR>"

	if(!game_started)
		src.status += "<b>STARTING</b>"
	else if(master_mode)
		src.status += "Mode: <b>[capitalize(master_mode)]</b>"

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
			world.log_game("Read default mode '[newmode]' from [persistent_file]")


	// *****

	var/motd = file2text("motd.txt")
	auth_motd = file2text("motd-auth.txt")
	no_auth_motd = file2text("motd-noauth.txt")
	if (motd)
		join_motd = motd

	//	Setup Configurations
	config = new /datum/configuration()
	config.load("config.txt")

	//	Load Default Names
	if(config.random_names)
		first_names = dd_file2list("first_names.txt")
		last_names = dd_file2list("last_names.txt")

	if(config.random_ai_names)
		ai_names = dd_file2list("ai_names.txt")

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
	world.update_stat()
	world << "<B>Welcome to Space Station 13!</B>\n\n"

	if(!master_mode) master_mode = "random"
	current_mode = config.pick_mode(master_mode)
	current_mode.announce()
	current_mode.setup()

	world << "<B>Now dispensing all identification cards.</B>"

	world.log_game("[current_mode.name] round starting")

	DivideOccupations()
	for(var/obj/manifest/M in world)
		M.manifest()
	data_core.manifest()
	current_mode.execute()
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
