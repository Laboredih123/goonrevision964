/datum/game_mode/multitraitor
	// a mode where multiple traitors are working together to achieve a set of common goals.
	name = "multitraitor"
	min_players = 1

	var/mob/list/traitors = list()
	var/num_traitors = 0
	var/const/MOBS_PER_TRAITOR = 10 // every 10 people means another traitor
	// 1-9 people: 1 traitor, 10-19 people: 2 traitors, etc
	// do NOT set this lower than 2. If you want a mode where everyone's a traitor, you'll have to make quite a few
	// changes to the code in this.

	New(num_traitors = 0)
		if(num_traitors)
			src.num_traitors = num_traitors

	announce()
		world << "LOOK OUT, THERE ARE TRAITORS ON BOARD!"

	setup()
		termination_conditions += new/datum/termination_condition/shuttle()

	execute()
		while(1)
			var/num_mobs = 0
			for(var/mob/M in world)
				if(!M.client)
					continue
				if(istype(M, /mob/prespawn))
					continue
				num_mobs++
			if(!num_mobs)
				sleep(30)
				continue
			if(!num_traitors)
				src.num_traitors = round(num_mobs / MOBS_PER_TRAITOR) + 1
			break

		// select num_traitors traitors
		for(var/i = 1; i <= num_traitors; i++)
			var/mob/T = pick_synd_except(traitors)
			traitors += T

		// determine the name the group of traitors
		var/mob/first_traitor = traitors[1]
		var/traitor_group_name = "[first_traitor.client.key] ([first_traitor.spawn_name])"
		for(var/i = 2; i <= num_traitors; i++)
			var/mob/T = traitors[i]
			if(i == num_traitors)
				traitor_group_name += " and [T.client.key] ([T.spawn_name])" // Oxford comma? more like LAMEford comma
			else
				traitor_group_name += ", [T.client.key] ([T.spawn_name])"

		for(var/mob/T in traitors)
			if(traitors.len == 1)
				T << "<font color='red'><h2>You are the traitor!</h2></font>"
			else
				T << "<font color='red'><h2>You are a traitor!</h2></font>"
				T << "<font color='red'><h2>Your fellow traitors are [traitor_group_name].</h2></font>"
				T.store_memory("Fellow traitors: [traitor_group_name]")

		// select num_traitors missions
		for(var/i = 1; i <= num_traitors; i++)
			var/mission_type = pick_mission(traitors)
			var/datum/mission/mission = new mission_type(traitors, traitor_group_name)
			missions += mission
			for(var/mob/traitor in traitors)
				traitor.tell_mission(mission)

		for(var/mob/traitor in traitors)
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

			new /datum/effect/report_death(traitor, "\red A traitor, [traitorname], has died.")

		new /datum/effect/death_commandos()

		..()

	get_traitors()
		return traitors

	proc/pick_synd_except(list/synds)
		var/list/synd_list = get_synd_list()
		if(synd_list.len)
			return pick(synd_list - synds)
		else
			var/list/mobs = get_cliented_mob_list()
			if(mobs.len)
				return pick(mobs - synds)

	proc/pick_mission(list/traitors) // TODO: Prevent multiple copies of the same mission from happening
		var/list/targets = get_cliented_mob_list()
		if(targets.len < 2)	// since there's only one mob, there can be only one traitor
			var/traitor = traitors[1]
			if(istype(traitor, /mob/silicon/ai))
				return /datum/mission/evacuate
			else
				return pick(/datum/mission/steal, /datum/mission/sabotage)
		else
			var/missions = list()
			for(var/T in traitors)
				if(istype(T, /mob/silicon/ai))
					missions += list(/datum/mission/evacuate, /datum/mission/rand_murder)
				else
					missions += list(/datum/mission/steal, /datum/mission/sabotage, /datum/mission/rand_murder)
			return pick(missions)
			// could also do pick(uniquelist(missions))
			// this way it's weighted by the ai:human ratio of traitors.

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