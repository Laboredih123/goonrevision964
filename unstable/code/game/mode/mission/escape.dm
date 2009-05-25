/datum/mission/escape
	description()
		return "escape on the shuttle"

	check_success()
		for(var/mob/M in group)
			if(!M.client)		continue
			if(M in outcasts)	continue
			if(!M.is_dead)		return 1
		return 0