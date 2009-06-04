/datum/mission/kidnap
	var/vname
	var/victims

	New(list/group, gname, list/victims, vname)
		src.group = group
		src.gname = gname
		if(victims)
			src.victims = victims
			src.vname = vname
		else
			var/mob/carbon/V = pick_cliented_human_except(group)
			victims = list(V)
			vname = V.spawn_name

	description()
		return "kidnap [vname], dead or alive, by ending the game alone on a shuttle with them"

	check_success()
		var/someone_escaped = 0
		for(var/mob/M in world)
			if(!on_shuttle(M))
				if(M in victims)
					return MISSION_FAILURE
				else
					continue
			if(M.is_dead) // victims can be dead, otherwise you'll get abductees suiciding just to be dicks
				continue
			if(!(M in group) || M in outcasts)
				return MISSION_FAILURE
			someone_escaped = 1
		if(someone_escaped)
			return MISSION_SUCCESS
		return MISSION_FAILURE