/datum/mission/prevent_escape
	description()
		return "prevent [vdesc] from escaping on a shuttle"

	var/list/victims = null
	var/vdesc = "your victim"

	New(list/group, gname, list/victims, vname)
		src.group = group
		src.gname = gname
		src.victims = victims
		src.vdesc = vname


	check_success()
		for(var/mob/M in victims)
			if(M in outcasts)
				continue
			if(M.is_dead)
				continue
			if(M.z != SHUTTLE_Z)
				continue
			if(!istype(get_area(M), /area/shuttle))
				continue
			return MISSION_FAILURE
		return MISSION_SUCCESS