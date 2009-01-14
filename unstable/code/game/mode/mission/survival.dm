/datum/mission/survival
	New(var/gname, var/group, var/outcasts)
		src.gname = gname
		src.group = group
		src.outcasts = outcasts

	proc/check()
		var/survivors = group
		if(!group) survivors = world
		for(var/mob/M in survivors)
			if(!M.client)		continue
			if(M in outcasts)	continue
			if(!M.is_dead)		return 1
		return 0

	conclude()

		if(check())
			world << "<font color='blue'>Not everyone has died!</font>"
		else
			world << "<font color='blue'>Everyone has died!</font>"