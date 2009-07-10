/var/const
	JOINED_ON_TIME = 1
	JOINED_LATE = 2
	JOINED_ALREADY = 3

/datum/job
	var/priority = 1 // default priority. higher priority jobs must all be filled before lower priority ones are.
	// note that after the first instance of a job is taken, all further instances are of priority 1 (unless the
	// initial priority was lower than 1).
	var/max = 0 // maximum number of people spawning with it - should be at least 1 generally
	var/can_join_late = 1 // most jobs can join late
	var/switchable_to = 1 // it makes sense to switch to it in the middle of the game. currently true for
	// everything but AI
	var/speaker_color = COLOR_DEFAULT
	var/name = "Custom"
	var/responsibilities = "Do what you want broski."

	proc/find_spawnpoint(join_status, mob/M)
		if(join_status == JOINED_LATE)
			return null
		for(var/obj/start/sloc in world)
			if (ckey(sloc.name) != ckey(src.name))
				continue
			if (locate(/mob) in sloc.loc)
				continue
			return sloc.loc
		world.log_bug("No spawnpoint found for [src.name].")

	proc/process_name(name, mob/M)
		return name

	proc/create(mob/M, join_status, give_backpack = 1, has_hair = 1)
		if(!M.client)
			return
		var/startloc = src.find_spawnpoint(join_status, M)
		var/datum/preferences/prefs = M.client.prefs
		var/name = src.process_name(prefs.name)
		var/hair_style = prefs.hair_style
		if(!has_hair)
			hair_style = HAIR_STYLE_BALD
		var/mob/carbon/human/H = new(startloc, name, prefs.hair_color, hair_style, prefs.skin_color, prefs.gender, job = src)
		if(give_backpack)
			H.equip_if_possible(new /obj/item/weapon/storage/backpack(H), SLOT_BACK)
		src.give_equipment(H)
		H.client = M.client
		H.update_clothing()
		src.announce(H, join_status)
		del(M)
		return H

	proc/give_equipment(mob/carbon/M)
		// gives the mob its equipment after it has been created.
		var/obj/item/weapon/card/id/C = new /obj/item/weapon/card/id(M)
		C.registered = M.spawn_name
		C.assignment = src.name
		C.name = "[C.registered]'s ID Card ([C.assignment])"
		C.access = src.get_access()
		M.equip_if_possible(C, SLOT_ID)
		M.equip_if_possible(new /obj/item/weapon/pen(M), SLOT_R_STORE)
		M.equip_if_possible(new /obj/item/weapon/radio/signaller(M), SLOT_BELT)
		M.equip_if_possible(new /obj/item/weapon/radio/headset(M), SLOT_HEADSET)

	proc/announce(mob/M, join_status)
		world.log_game("[M] has joined the game.")

		M << "<B>Game mode is [config.current_mode.long_name]</B>."
		M << "<B>You are the [src.name].</B>"
		M << "<b>Your responsibilities are:</b> [src.responsibilities]<br>"
		if(join_status == JOINED_LATE)
			for(var/mob/silicon/ai/ai in world)
				if(!ai.is_dead)
					ai.say("[M] has arrived on the station. \He is the [src.name].")
					break

	proc/get_access()
		return null

/var/list/job_instances = null

/proc/get_all_job_instances()
	if(!job_instances)
		job_instances = list()
		for(var/x in typesof(/datum/job))
			job_instances += new x()
	return job_instances

/proc/get_job_instance_by_type(type)
	for(var/datum/job/j in get_all_job_instances())
		if(istype(j, type))
			return j
	return null

/proc/get_job_instance_by_name(name)
	for(var/datum/job/j in get_all_job_instances())
		if(j.name == name)
			return j
	return null