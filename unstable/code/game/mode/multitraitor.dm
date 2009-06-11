/datum/game_mode/multitraitor
	// a mode where multiple traitors are working together to achieve a set of common goals.
	config_name = "multitraitor"
	long_name = "Multitraitor"
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
		termination_conditions += new/datum/termination_condition/shuttle(emergency_shuttle)
		termination_conditions += new/datum/termination_condition/shuttle(commando_shuttle)

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
				world.log_game("Not enough players for multitraitor, waiting 3 seconds.")
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

		// give each traitor a message and a personal mission
		for(var/mob/T in traitors)
			if(traitors.len == 1)
				T << "<font color='red'><h2>You are the traitor!</h2></font>"
			else
				T << "<font color='red'><h2>You are a traitor!</h2></font>"
				T << "<font color='red'><h2>Your fellow traitors are [traitor_group_name].</h2></font>"
				T.store_memory("Fellow traitors: [traitor_group_name]")
			var/mission_type = pick_individual_mission(T)
			var/datum/mission/mission
			if(mission_type != /datum/mission/murders)
				mission = new mission_type(T, "[T.client.key] ([T.spawn_name])")
			else
				mission = new mission_type(traitors, "[T.client.key] ([T.spawn_name])") // this is a really bad way to do this
			T.tell_mission(mission)
			missions += mission

		if(num_traitors > 1)
			var/group_mission_type = pick_group_mission()
			var/datum/mission/group_mission = new group_mission_type(traitors, traitor_group_name)
			missions += group_mission
			for(var/mob/T in traitors)
				T.tell_mission(group_mission)

		// give them all a mission to escape/survive and a traitor radio/law zero. also, report their deaths.
		for(var/mob/traitor in traitors)
			var/traitorname = "[traitor.client.key] ([traitor.spawn_name])"
			if(istype(traitor, /mob/carbon))
				var/datum/mission/escape/e = new(list(traitor), "[traitorname]")
				traitor.tell_mission(e)
				missions += e
				new /datum/effect/traitor_radio(traitor)
			else if(istype(traitor, /mob/silicon/ai))
				var/datum/mission/survival/s = new(list(traitor), "[traitorname]")
				traitor.tell_mission(s)
				missions += s
				new /datum/effect/law_zero(traitor)

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

	proc/pick_individual_mission(traitor) // TODO: Prevent multiple copies of the same mission from happening
		var/list/targets = get_cliented_mob_list()
		if(targets.len < 2)	// since there's only one mob, there can be only one traitor
			if(istype(traitor, /mob/silicon/ai))
				return /datum/mission/evacuate
			else
				return pick(/datum/mission/steal, /datum/mission/sabotage)
		else
			if(istype(traitor, /mob/silicon/ai))
				return pick(/datum/mission/evacuate, /datum/mission/murders)
			else
				return pick(/datum/mission/steal, /datum/mission/sabotage, /datum/mission/murders)

	proc/pick_group_mission() // TODO: If multiple AIs are ever implemented, make this work properly with only AI traitors.
		return pick(/datum/mission/escape_alone, /datum/mission/frame, /datum/mission/kill_by_method, /datum/mission/steal_canisters)

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