/datum/termination_condition/deaths
	var/list/mobs
	var/desc

	New(list/L, description)
		mobs = L
		desc = description

	check()
		for(var/mob/M in mobs)
			if(!M.is_dead)
				return 0
		return 1

	conclude()
		world << "<font color='blue'>All the [desc] are dead!</font>"