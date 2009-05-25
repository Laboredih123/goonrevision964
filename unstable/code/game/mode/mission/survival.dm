/datum/mission/survival
	New(gname, group, outcasts)
		if(gname) //defaults to "everyone"
			src.gname = gname
		if(group) //defaults to world
			src.group = group
		src.outcasts = outcasts //defaults to null, so don't bother checking

	description()
		return "survive"

	check_success()
		for(var/mob/M in group)
			if(!M.client)		continue
			if(M in outcasts)	continue
			if(!M.is_dead)		return 1
		return 0