/datum/mission/survival
	description()
		return "survive"

	check_success()
		for(var/mob/M in group)
			if(!M.client)		continue
			if(M in outcasts)	continue
			if(!M.is_dead)		return MISSION_SUCCESS
		return MISSION_FAILURE