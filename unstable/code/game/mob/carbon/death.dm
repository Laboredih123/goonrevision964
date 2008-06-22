/mob/carbon/death()
	if(src.client && src.hud && src.hud.blind)
		src.hud.blind.layer = 0
	if(src.hud && src.hud.health)
		src.hud.health.icon_state = "health5"
	src.lying = 1
	return ..()