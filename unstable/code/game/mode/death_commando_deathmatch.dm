/datum/game_mode/death_commando_deathmatch
	config_name = "deathmatch"
	long_name = "Death Commando Deathmatch"

	announce()
		world << "<b>Death commando deathmatch! Kill everyone else! But watch out, they might come back!</b>"
		world << "Respawning is enabled."

	setup()
		termination_conditions += new /datum/termination_condition/time_limit(15 * 600, "That's enough killing, boys.")
		abandon_allowed = 1

	execute()
		var/list/mobs = list()
		for(var/mob/carbon/M in world)
			mobs += M
		for(var/mob/carbon/M in mobs)
			if(M.client)
				new /datum/effect/death_commandoize(M)

	give_newcomer_job(mob/M)
		var/datum/job/death_commando/j = get_job_instance_by_type(/datum/job/death_commando)
		j.create(M, JOINED_LATE)