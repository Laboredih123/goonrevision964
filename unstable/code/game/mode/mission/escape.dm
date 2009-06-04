/datum/mission/escape
	description()
		return "escape on a shuttle"

	check_success()
		for(var/mob/M in (group - outcasts))
			if(!on_shuttle(M))
				continue
			if(M.is_dead)
				continue
			return MISSION_SUCCESS
		return MISSION_FAILURE