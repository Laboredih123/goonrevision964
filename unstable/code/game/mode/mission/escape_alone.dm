/datum/mission/escape_alone
	description()
		return "escape alone (apart from other traitors) on the shuttle"

	check_success()
		var/someone_escaped = 0
		for(var/mob/M in world)
			if(M.is_dead)
				continue
			if(!istype(get_area(M), /area/shuttle))
				continue
			if(!(M in group) || M in outcasts)
				return MISSION_FAILURE
			someone_escaped = 1
		if(someone_escaped)
			return MISSION_SUCCESS
		return MISSION_FAILURE