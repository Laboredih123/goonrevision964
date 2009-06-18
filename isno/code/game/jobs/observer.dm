/datum/job/observer
	name = "Observer"
	max = 0
	can_join_late = 1
	responsibilities = "uh watch the show i guess"

	find_spawnpoint()
		return locate(/area/arrival/start)

	create(mob/M, join_status)
		var/startloc = src.find_spawnpoint(join_status, M)
		var/datum/preferences/prefs = M.client.prefs
		var/name = src.process_name(prefs.name)
		var/mob/observer/O = new(M)
		O.loc = startloc
		O.client = M.client
		O.name = name
		O.spawn_name = name
		del M