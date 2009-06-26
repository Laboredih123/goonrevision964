/datum/mission/murders
	var/list/victims = null
	var/vdesc = "your victim"

	New(list/group, gname, list/victims, vname)
		src.group = group
		src.gname = gname
		if(victims)
			src.victims = victims
			src.vdesc = vname
		else
			var/mob/carbon/V = pick_cliented_human_except(group)
			victims = list(V)
			vdesc = V.spawn_name

	description()
		return "murder [vdesc]"

	check_success()
		for(var/mob/carbon/V in victims)
			if(!V)
				continue
			if(istype(V, /mob) && !V.is_dead)
				return MISSION_FAILURE
		return MISSION_SUCCESS

/proc/pick_cliented_human_except(list/exceptions)
	var/list/L = new()
	for(var/mob/carbon/human/M in world)
		if(!(M in exceptions) && M.client)
			L += M
	return pick(L)