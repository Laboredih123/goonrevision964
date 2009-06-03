/datum/mission/escape
	description()
		return "escape on a shuttle"

	check_success()
		for(var/mob/M in group)
			if(M in outcasts)
				continue
			if(M.is_dead)
				continue
			if(!istype(get_area(M), /area/shuttle))
				continue
			return MISSION_SUCCESS
		return MISSION_FAILURE