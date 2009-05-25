/datum/mission/rand_murder
	var/datum/mission/murders/murder

	New(mob/A)
		var/mob/carbon/V = pick_cliented_human_except(A)
		var/aname = A.spawn_name
		var/vname = V.spawn_name
		murder = new /datum/mission/murders(list(A), aname, list(V), vname)

		group = list(A)
		gname = "[A.client.key] ([A.spawn_name])"

	description()
		return murder.description()

	check_success()
		return murder.check_success()