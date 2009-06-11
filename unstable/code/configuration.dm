/var/list/mode_instances = null

/proc/get_mode_instances()
	if(!mode_instances)
		mode_instances = list()
		for(var/T in typesof(/datum/game_mode))
			mode_instances += new T()
	return mode_instances


/datum/configuration/New()
	for(var/datum/game_mode/M in get_mode_instances())
		if(M.config_name)
			src.probabilities[M.config_name] = 0

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
				config.log_file = dd_replacetext(value, "ROUNDNUM", "[curround + 1]")
				fdel(value);

			if("allow_vote_restart")	config.allow_vote_restart = 1
			if("allow_vote_mode")		config.allow_vote_mode = 1
			if("no_dead_vote")			config.vote_no_dead = 1
			if("default_no_vote")		config.vote_no_default = 1
			if("vote_delay")			config.vote_delay = text2num(value)
			if("vote_period")			config.vote_period = text2num(value)
			if("allow_ai")				config.allow_ai = 1
			if("no_respawn")			config.respawn = 0

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
					var/success = 0
					for(var/datum/game_mode/M in get_mode_instances())
						if(M.config_name == prob_name)
							config.probabilities[M] = text2num(prob_value)
							success = 1
							break
					if(!success)
						world.log_game("Unknown game mode probability configuration definition: [prob_name]")
				else
					world.log_game("Incorrect probability configuration definition: [prob_name]  [prob_value]")
			else
				world.log_game("Unknown setting in configuration: '[name]'")

/datum/configuration/proc/parse_authentication(option)
	config.enable_authentication = 1

/proc/get_mode(mode_config_name)
	for(var/datum/game_mode/M in get_mode_instances())
		if(M.config_name == mode_config_name)
			return M

	world.log_game("Invalid Mode ([mode_config_name]): Selecting new mode at random")
	return pick(get_mode_instances())

/datum/configuration/proc/pick_random_mode()
	var/num_clients = 0
	for(var/mob/prespawn/P in world)
		//theoretically there should be nothing but /prespawns with clients, but you never know with SS13 admins
		if(P.client)
			num_clients++

	var/total = 0
	var/list/accum = list()

	for(var/datum/game_mode/M in get_mode_instances())
		if(num_clients < M.min_players)
			continue
		total += src.probabilities[M]
		accum[M] = total

	var/r = total - (rand() * total)

	for (var/datum/game_mode/M in get_mode_instances())
		if(src.probabilities[M] > 0 && accum[M] >= r)
			return M

	return new /datum/game_mode() //freeform