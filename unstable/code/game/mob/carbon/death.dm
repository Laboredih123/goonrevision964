/mob/carbon/death()
	if(src.hud)
		del(src.hud)
	src.lying = 1

	src.timeofdeath = world.time

	return ..()