/datum/mission/murders
	var/list/victims = null
	var/vdesc = "your victim"

	New(list/group, gname, list/victims, vname)
		src.group = group
		src.gname = gname
		src.victims = victims
		src.vdesc = vname

	description()
		return "Murder [vdesc]."

	check_success()
		for(var/mob/carbon/V in victims)
			if(!V)
				continue
			if(istype(V, /mob) && !V.is_dead)
				return 0
		return 1

/proc/pick_cliented_human_except(mob/E)
	var/list/L = new()
	for(var/mob/carbon/human/M in world)
		if(M != E && M.client)
			L += M
	return pick(L)