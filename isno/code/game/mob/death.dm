/mob/proc/death()
	src.is_dead = 1
	src.canmove = 0

	//let dead people see anything, there's no resurrection any more anyways
	if(src.client)
		spawn(50)
			if(src.client && src.is_dead)
				src << "<br><br>[config.current_mode.get_desc()]"
				src.client.mob = new/mob/observer(src)
	return ..()