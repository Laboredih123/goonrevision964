/datum/game_mode/spyvsspy
	name = "spyvsspy"
	var/list/spyteams // list of lists of mobs
	var/const/SPIES_PER_TEAM = 3
	var/const/NUM_TEAMS = 2
	min_players = NUM_TEAMS * SPIES_PER_TEAM + 1 // 1 for AI

	announce()
		world << "LOOK OUT, THERE'S A BUNCH OF SPIES ON BOARD!"

	setup()
		termination_conditions += new/datum/termination_condition/shuttle()

	execute()
		var/list/spies
		while (1)
			spies = list()
			var/success = 1
			for(var/i = 1; i <= NUM_TEAMS && success; i++)
				spies[i] = list()
				for(var/j = 1; j < SPIES_PER_TEAM && success; i++)
					var/mob/carbon/synd = pick_carbon_synd_except(spies)
					if(!synd)
						success = 0
					else
						spies[i] += synd
			if(success)
				break
			sleep(30)
		src.spyteams = spies

		var/x = 1 // TODO: real spy team names
		for(var/team in src.spyteams)
			var/datum/mission/steal = new(team, "Spy Team Number [x]", NUKE_DISK)
			x++
			missions += steal

			for(var/mob/carbon/spy in team)
				spy << "\red<h2>You are a spy!</h2>"
				spy << "\red Your fellow spies are:"
				for(var/mob/carbon/otherspy in team)
					if(otherspy != spy)
						spy << "\ref [otherspy.spawn_name]"
				var/datum/mission/escape/escape = new(list(spy), "[spy.client.key] ([spy.spawn_name])")
				missions += escape
				spy.tell_mission(steal)
				spy.tell_mission(escape)
				new /datum/effect/traitor_radio(spy)

		new /datum/effect/death_commandos()

		..()

	get_traitors()
		var/list/L = list()
		for(var/list/team in spyteams)
			L += team
		return L

/proc/pick_carbon_synd_except(list/exceptions)
	var/list/synd_list = get_carbon_synd_list()
	synd_list -= exceptions
	if(synd_list.len)
		synd_list = get_cliented_carbon_list()
		synd_list -= exceptions
	if(synd_list.len)
		return pick(synd_list)
	return null

/proc/get_carbon_synd_list()
	var/list/L = list()
	for(var/mob/M in world)
		if (M.client && istype(M, /mob/carbon) && M.client.prefs && M.client.prefs.be_syndicate)
			L += M
	return L

/proc/get_cliented_carbon_list()
	var/list/L = list()
	for(var/mob/M in world)
		if(M.client && istype(M, /mob/carbon))
			L += M
	return L