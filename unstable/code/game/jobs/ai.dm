/datum/job/ai
	priority = 5
	can_join_late = 0
	max = 1
	switchable_to = 0
	name = "AI"

	process_name(name, mob/M)
		if(config.random_ai_names)
			var/randomname = "HAL"	//	default name
			if(ai_names)
				randomname = pick(ai_names)
			var/newname = input(M,"You are the AI. Would you like to change your name?", "Character Creation", randomname)
			if(!length(newname)) newname = randomname
			newname = strip_html(newname,30)
			return newname

	create(mob/prespawn/P, joined_late)
		var/name = src.process_name(P.client.prefs.name)
		var/loc = src.find_spawnpoint()
		var/mob/silicon/ai/A = new(loc, name)
		A.client = P.client
		A.spawn_job = src
		src.announce(A, joined_late)
		del(P)

	announce(mob/M)
		..()
		world << "<b>[M.name] is the AI!</b>"