/datum/mission/survival/New(var/gname, var/group, var/outcasts)
	src.gname = gname
	src.group = group
	src.outcasts = outcasts

/datum/mission/survival/state()
	var/survivors = group
	if(!group) survivors = world
	for(var/mob/M in survivors)
		if(!M.client)		continue
		if(M in outcasts)	continue
		if(!M.is_dead)		return MISSION_ACTIVE
	return MISSION_FAILURE

/datum/mission/survival/conclude()
	if(!group)				world << "<font color='blue'>Everyone has died!</font>"
	else if(group.len == 1)	world << "<font color='blue'>The [gname] has died!</font>"
	else					world << "<font color='blue'>The [gname] have died!</font>"