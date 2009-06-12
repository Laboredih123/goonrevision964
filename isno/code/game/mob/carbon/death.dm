/mob/carbon/death()
	src.lying = 1
	src.timeofdeath = world.time
	del src.hud
	return ..()
