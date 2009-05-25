/datum/mission/rand_murder
	var/datum/mission/murders/murder

	New(list/group, gname)
		var/mob/carbon/V = pick_cliented_human_except(group)
		var/vname = V.spawn_name
		murder = new /datum/mission/murders(group, gname, list(V), vname)

	description()
		return murder.description()

	check_success()
		return murder.check_success()