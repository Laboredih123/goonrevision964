/datum/game_mode/traitor
	name = "traitor"
	var/mob/traitor

	announce()
		return

	setup()
		termination_conditions += new/datum/termination_condition/shuttle()

	execute()
		traitor = pick_synd()

		var/mission = pick_mission(traitor)
		missions += new mission(traitor)
		if(istype(traitor, /mob/carbon))
			new /datum/effect/traitor_radio(traitor)
		else
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
			else
				world << "OH NO THERE IS NOBODY HERE"

	proc/pick_mission(mob/traitor)
		var/list/targets = get_cliented_mob_list()
		if(targets.len < 2)
			if(istype(traitor, /mob/silicon/ai))
				return /datum/mission/evacuate
			else
				return pick(/datum/mission/steal, /datum/mission/sabotage)
		else
			if(istype(traitor, /mob/silicon/ai))
				return pick(/datum/mission/evacuate, /datum/mission/murder)
			else
				return pick(/datum/mission/steal, /datum/mission/sabotage, /datum/mission/murder)

	proc/get_synd_list()
		var/list/L = list()
		for(var/mob/M in world)
			if (M.client && (!istype(M, /mob/prespawn) || M:ready) && M.client.prefs && M.client.prefs.be_syndicate)
				L += M
		return L

	proc/get_cliented_mob_list()
		var/list/L = list()
		for(var/mob/M in world)
			if(M.client && (!istype(M, /mob/prespawn) || M:ready))
				L += M
		return L

