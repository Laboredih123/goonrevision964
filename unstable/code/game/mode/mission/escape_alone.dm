/datum/mission/escape_alone
	description()
		return "escape alone (apart from other traitors) on a shuttle"

	check_success()
		var/someone_escaped = 0
		for(var/mob/M in world)
			if(!on_shuttle(M))
				continue
			if(M.is_dead)
				continue
			if(!(M in group) || (M in outcasts))
				return MISSION_FAILURE
			someone_escaped = 1
		if(someone_escaped)
			return MISSION_SUCCESS
		return MISSION_FAILURE

/proc/on_shuttle(atom/M) // TODO: Make this work properly with the multiple escape-on-able shuttles.
	return istype(get_area(M), /area/shuttle) && M.z == SHUTTLE_Z