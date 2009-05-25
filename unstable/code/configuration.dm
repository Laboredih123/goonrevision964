/datum/configuration/New()
	var/list/L = typesof(/datum/game_mode)
	for (var/T in L)
		// instantiate all the modes once at the start of the round.
		// somewhat wasteful, but probably the easiest way and its really not much overhead.
		var/datum/game_mode/M = new T()
		if(M.name)
			src.modes += M
			src.mode_names += M.name
			src.probabilities[M.name] = 0
			if(M.votable) src.votable_modes += M.name

/datum/configuration/proc/load(filename)
	var/text = file2text(filename)

	if(!text)
		world.log_game("No config.txt file found, setting defaults")
		src = new /datum/configuration()
		return

	world.log_game("Reading configuration file [filename]")

	var/list/CL = dd_text2list(text, "\n")

	for (var/t in CL)
		if(!t)	continue

		t = trim(t)
		if(length(t) == 0)					continue
		else if(copytext(t, 1, 2) == "#")	continue

		var/pos = findtext(t, " ")
		var/name = null
		var/value = null

		if(pos)
			name = lowertext(copytext(t, 1, pos))
			value = copytext(t, pos + 1)
		else
			name = lowertext(t)

		if(!name)	continue

		switch (name)
			if("log_ooc")		config.log_ooc = 1
			if("log_access")	config.log_access = 1
			if("log_say")		config.log_say = 1
			if("log_admin")		config.log_admin = 1
			if("log_game")		config.log_game = 1
			if("log_vote")		config.log_vote = 1
			if("log_file")
				config.log_file = value
				fdel(value);

			if("allow_vote_restart")	config.allow_vote_restart = 1
			if("allow_vote_mode")		config.allow_vote_mode = 1
			if("no_dead_vote")			config.vote_no_dead = 1
			if("default_no_vote")		config.vote_no_default = 1
			if("vote_delay")			config.vote_delay = text2num(value)
			if("vote_period")			config.vote_period = text2num(value)
			if("allow_ai")				config.allow_ai = 1

			if("authentication")
				switch(lowertext(dd_limittext(value,8)))
					if("disabled")	config.enable_authentication = 0
					if("required")	config.enable_authentication = 2
					if("optional")	parse_authentication(value)
				if(!value) config.enable_authentication = 2

			if("rate_limit")			config.rate_limit = text2num(value)
			if("random_names")			config.random_names = text2num(value)
			if("random_ai_names")		config.random_ai_names  = text2num(value)

			if("probability")
				var/prob_pos = findtext(value, " ")
				var/prob_name = null
				var/prob_value = null

				if(prob_pos)
					prob_name = lowertext(copytext(value, 1, prob_pos))
					prob_value = copytext(value, prob_pos + 1)
					if(prob_name in config.mode_names)
						config.probabilities[prob_name] = text2num(prob_value)
					else
						world.log_game("Unknown game mode probability configuration definition: [prob_name]")
				else
					world.log_game("Incorrect probability configuration definition: [prob_name]  [prob_value]")
			else
				world.log_game("Unknown setting in configuration: '[name]'")

/datum/configuration/proc/parse_authentication(option)
	config.enable_authentication = 1
	if(dd_hasprefix(option,"optional restrict("))
		option = copytext(option,19,findtext(option,")",19))
		config.require_authentication = dd_text2list(option,",",get_all_jobs()+"AI")

	else if(dd_hasprefix(option,"optional permit("))
		config.require_authentication = get_all_jobs()+"AI"
		option = copytext(option,17,findtext(option,")",17))
		config.require_authentication.Remove(dd_text2list(option,","))

/datum/configuration/proc/pick_mode(mode_name)
	for(var/datum/game_mode/M in modes)
		if(M.name == mode_name) return M

	world.log_game("Invalid Mode ([mode_name]): Selecting new mode at random")
	return pick_random_mode()

/datum/configuration/proc/pick_random_mode()
	var/num_clients = 0
	for(var/mob/prespawn/P in world) //theoretically there should be nothing but /prespawns with clients,
		// but you never know with SS13 admins
		if(P.client)
			num_clients++

	var/total = 0
	var/list/accum = list()

	if(!src.modes || !src.modes.len)
		src.modes = list()
		var/modetypes = typesof(/datum/game_mode)
		for(var/m in modetypes)
			src.modes += new m()

	for(var/datum/game_mode/M in src.modes)
		if(num_clients < M.min_players)
			continue
		total += src.probabilities[M.name]
		accum[M.name] = total

	var/r = total - (rand() * total)

	for (var/datum/game_mode/M in modes)
		if(src.probabilities[M.name] > 0 && accum[M.name] >= r)
			return M

	return new /datum/game_mode() //freeform