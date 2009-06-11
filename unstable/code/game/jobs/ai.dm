/datum/job/ai
	priority = 5
	can_join_late = 0
	max = 1
	switchable_to = 0
	name = "AI"
	responsibilities = "Try to keep the station in one piece, while following your laws (FOLLOW YOUR LAWS DAMMIT)."

	process_name(name, mob/M)
		if(config.random_ai_names)
			var/randomname = "HAL"	//	default name
			if(ai_names)
				randomname = pick(ai_names)
			var/newname = input(M,"You are the AI. Would you like to change your name?", "Character Creation", randomname)
			if(!length(newname)) newname = randomname
			newname = strip_html(newname,30)
			return newname

	create(mob/M, join_status)
		var/name = src.process_name(M.client.prefs.name, M)
		var/loc = src.find_spawnpoint(join_status, M)
		var/mob/silicon/ai/A = new(loc, name)
		A.client = M.client
		A.spawn_job = src
		src.announce(A, join_status)
		del(M)
		return A

	announce(mob/M)
		..()
		world << "<b>[M.name] is the AI!</b>"