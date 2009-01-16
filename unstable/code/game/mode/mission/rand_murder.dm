/datum/mission/rand_murder
	var/datum/mission/murders/murder

	New(mob/A)
		var/mob/carbon/V = pick_cliented_human_except(A)
		var/Aname = "a killer"
		var/Vname = "a victim"
		if(A)
			Aname = A.spawn_name
		if(V)
			Vname = V.spawn_name
		murder = new /datum/mission/murders(list(A), Aname, 0, list(V), Vname, 0)

	conclude()
		return murder.conclude()