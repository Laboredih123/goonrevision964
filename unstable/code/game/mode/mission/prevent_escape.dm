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
		for(var/mob/M in (victims - outcasts))
			if(on_shuttle(M) && !M.is_dead)
				return MISSION_FAILURE
		return MISSION_SUCCESS