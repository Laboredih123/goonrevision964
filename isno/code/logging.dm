/world/proc/log_access(text)
	world.log_generic(text, "access", 1)

/world/proc/log_admin(text)
	world.log_generic(text, "admin", 1)

/world/proc/log_attack(text)
	world.log_generic(text, "attack", 1)

/world/proc/log_bomb(text)
	world.log_generic(text, "bomb", 1)

/world/proc/log_bug(text)
	world.log_generic(text, "bug")

/world/proc/log_construct(text)
	world.log_generic(text, "construct", 1)

/world/proc/log_game(text)
	world.log_generic(text, "game", 1)

/world/proc/log_ooc(text)
	world.log_generic(text, "ooc")

/world/proc/log_say(text)
	world.log_generic(text, "say")

/world/proc/log_vote(text)
	world.log_generic(text, "vote")


/world/proc/log_generic(text, type, notify)
	world.log << "[uppertext(type)]: [text]"
	world.log_file("[time2text(world.realtime)] - [uppertext(type)]: [text]", type)
	if(notify)
		notify_admins("[uppertext(type)]: [text]")


/world/proc/log_file(text, file)
	if(config.log_file)
		text2file(text, "[config.log_file].txt")
		if(file)
			text2file(text, "[config.log_file][file].txt")

/proc/notify_admins(text) // returns true if any admins were notified
	var/notified = 0
	for(var/mob/M in world)
		if(M.client && M.client.powers)
			M << text
			notified = 1
	return notified