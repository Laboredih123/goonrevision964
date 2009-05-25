/datum/game_mode/traitor
	name = "traitor"
	var/mob/traitor

	announce()
		return

	setup()
		termination_conditions += new/datum/termination_condition/shuttle()

	execute()
		while (1)
			traitor = pick_synd()
			if(traitor)
				break
			sleep(30)

		traitor << "\red<font size=3><B>You are the traitor!</B>"
		var/mission_type = pick_mission(traitor)
		var/datum/mission/mission = new mission_type(traitor)
		missions += mission
		traitor.tell_mission(mission)

		var/datum/mission/survival/s = new("[traitor.client.key] ([traitor.spawn_name])", list(traitor))
		traitor.tell_mission(s)
		missions += s

		if(istype(traitor, /mob/carbon))
			new /datum/effect/traitor_radio(traitor)
		else if(istype(traitor, /mob/silicon/ai))
			new /datum/effect/law_zero(traitor)
		..()

	proc/pick_synd()
		var/list/synd_list = get_synd_list()
		if(synd_list.len)
			return pick(synd_list)
		else
			var/list/mobs = get_cliented_mob_list()
			if(mobs.len)
				return pick(mobs)

	proc/pick_mission(mob/traitor)
		var/list/targets = get_cliented_mob_list()
		if(targets.len < 2)
			if(istype(traitor, /mob/silicon/ai))
				return /datum/mission/evacuate
			else
				return pick(/datum/mission/steal, /datum/mission/sabotage)
		else
			if(istype(traitor, /mob/silicon/ai))
				return pick(/datum/mission/evacuate, /datum/mission/rand_murder)
			else
				return pick(/datum/mission/steal, /datum/mission/sabotage, /datum/mission/rand_murder)

/proc/get_synd_list()
	var/list/L = list()
	for(var/mob/M in world)
		if (M.client && (!istype(M, /mob/prespawn) || M:ready) && M.client.prefs && M.client.prefs.be_syndicate)
			L += M
	return L

/proc/get_cliented_mob_list()
	var/list/L = list()
	for(var/mob/M in world)
		if(M.client && (!istype(M, /mob/prespawn) || M:ready))
			L += M
	return L