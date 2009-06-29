/datum/mission/prevent_escapes
	description()
		return "prevent any nontraitors from escaping"

	check_success()
		for(var/mob/M in world)
			if(!on_shuttle(M))
				continue
			if(M.is_dead)
				continue
			if(!(M in group))
				return MISSION_FAILURE
		return MISSION_SUCCESS

/proc/on_shuttle(atom/M) // TODO: Make this work properly with the multiple escape-on-able shuttles.
	return istype(get_area(M), /area/shuttle) && M.z == SHUTTLE_Z