/world/proc/log_admin(text)
	notify_admins("ADMIN: [text]")
	if(config.log_admin)
		world.log_file("[time2text(world.realtime)] - ADMIN: [text]", config.log_file_admin)
		world.log << "ADMIN: [text]"

/world/proc/log_game(text)
	notify_admins("GAME: [text]")
	if(config.log_game)
		world.log_file("[time2text(world.realtime)] - GAME: [text]", config.log_file_game)
		world.log << "GAME: [text]"

/world/proc/log_bug(text)
	if(config.log_game)
		world.log_file("[time2text(world.realtime)] - BUG: [text]", config.log_file_bug)
		world.log << "BUG: [text]"

/world/proc/log_vote(text)
	if(config.log_vote)
		world.log_file("[time2text(world.realtime)] - VOTE: [text]", config.log_file_vote)
		world.log << "VOTE: [text]"

/world/proc/log_access(text)
	notify_admins("ACCESS: [text]")
	if(config.log_access)
		world.log_file("[time2text(world.realtime)] - ACCESS: [text]", config.log_file_access)
		world.log << "ACCESS: [text]"

/world/proc/log_say(text)
	if(config.log_say)
		world.log_file("[time2text(world.realtime)] - SAY: [text]", config.log_file_say)
		world.log << "SAY: [text]"

/world/proc/log_ooc(text)
	if(config.log_ooc)
		world.log_file("[time2text(world.realtime)] - OOC: [text]", config.log_file_ooc)
		world.log << "OOC: [text]"

/world/proc/log_file(text, file)
	if(config.log_file)
		text2file(text, config.log_file)
	if(file)
		text2file(text, file)

/proc/notify_admins(text) // returns true if any admins were notified
	var/notified = 0
	for(var/mob/M in world)
		if(M.client && M.client.powers)
			M << text
			notified = 1
	return notified