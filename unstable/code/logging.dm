/world/proc/log_admin(text)
	if(config.log_admin)
		world.log_file("ADMIN: [text]")
		world.log << "ADMIN: [text]"

/world/proc/log_game(text)
	if(config.log_game)
		world.log_file("GAME: [text]")
		world.log << "GAME: [text]"

/world/proc/log_vote(text)
	if(config.log_vote)
		world.log_file("VOTE: [text]")
		world.log << "VOTE: [text]"

/world/proc/log_access(text)
	if(config.log_access)
		world.log_file("ACCESS: [text]")
		world.log << "ACCESS: [text]"

/world/proc/log_say(text)
	if(config.log_say)
		world.log_file("SAY: [text]")
		world.log << "SAY: [text]"

/world/proc/log_ooc(text)
	if(config.log_ooc)
		world.log_file("OOC: [text]")
		world.log << "OOC: [text]"

/world/proc/log_file(text)
	if(config.log_file)
		text2file(text,config.log_file)

