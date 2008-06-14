/mob/proc/see(message)
	if(src.sdisabilities & blindness)
		return
	if(src.stat == 1 || src.sleeping == 0)
		return
	src << message
	return 1