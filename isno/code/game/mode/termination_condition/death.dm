/datum/termination_condition/death
	var/mob/M
	var/desc

	New(mob/M, desc)
		src.M = M
		src.desc = desc

	check()
		return M.is_dead

	conclude()
		world << "<font color='blue'>[desc] is dead!</font>"