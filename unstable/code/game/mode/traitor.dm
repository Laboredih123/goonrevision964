/datum/game_mode/traitor
	name = "traitor"
	var/mob/traitor
	min_players = 1

	announce()
		world << "LOOK OUT, THERE'S A TRAITOR ON BOARD!"

	setup()
		termination_conditions += new/datum/termination_condition/shuttle()

	execute()
		while (1)
			traitor = pick_synd()
			if(traitor)
				break
			sleep(30)

		traitor << "\red<h2>You are the traitor!</h2>"
		var/mission_type = pick_mission(traitor)
		var/datum/mission/mission = new mission_type(list(traitor), "[traitor.client.key] ([traitor.spawn_name])")
		missions += mission
		traitor.tell_mission(mission)
		var/traitorname = "[traitor.client.key] ([traitor.spawn_name])"

		if(istype(traitor, /mob/carbon))
			new /datum/effect/traitor_radio(traitor)
			var/datum/mission/escape/e = new(list(traitor), "[traitorname]")
			traitor.tell_mission(e)
			missions += e
		else if(istype(traitor, /mob/silicon/ai))
			new /datum/effect/law_zero(traitor)
			var/datum/mission/survival/s = new(list(traitor), "[traitorname]")
			traitor.tell_mission(s)
			missions += s

		new /datum/effect/report_death(traitor, "\red The traitor, [traitorname], has died.")

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
		if (M.client && !istype(M, /mob/prespawn) && M.client.prefs && M.client.prefs.be_syndicate)
			L += M
	return L

/proc/get_cliented_mob_list()
	var/list/L = list()
	for(var/mob/M in world)
		if(M.client && !istype(M, /mob/prespawn))
			L += M
	return L