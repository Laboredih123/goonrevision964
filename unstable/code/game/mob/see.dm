/mob/proc/see(message)
	if(!src.is_conscious())
		return 0
	if(src.is_blind)
		return 0
	src << message
	return 1

/mob/proc/show_viewers(message)
	for(var/mob/M in viewers())
		M.see(message)