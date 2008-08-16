/mob/carbon/Login()
	//add the HUD
	src.hud = new(src)

	world.update_stat()
	src.next_move = 1

	if (ticker && master_mode =="sandbox" && src.client.authenticated)
		src.CanBuild()

	return ..()

/mob/carbon/Logout()
	//clear the HUD
	if(src.hud)
		del(src.hud)