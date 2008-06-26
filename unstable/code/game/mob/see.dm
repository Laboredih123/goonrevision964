/mob/proc/see(message)
	if(!src.is_conscious())
		return
	src << message
	return 1

/mob/proc/show_viewers(message)
	for(var/mob/M in viewers())
		M.see(message)