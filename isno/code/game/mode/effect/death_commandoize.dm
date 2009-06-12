/datum/effect/death_commandoize/New(mob/M)
	// This is really hacky. TODO: make it less so.
	spawn(20)
		var/datum/job/death_commando/j = get_job_instance_by_type(/datum/job/death_commando)
		j.create(M, JOINED_ALREADY)