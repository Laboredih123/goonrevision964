/mob/carbon/Login()
	//add the HUD
	world.update_stat()
	src.next_move = 1

	if (CanAdmin())
		src << text("\blue The game ip is byond://[]:[] !", world.address, world.port)
		src.verbs += /mob/proc/show_ctf
		src.verbs += /proc/variables


	var/area/A = locate(/area/start)
	var/list/L = list()
	for(var/turf/T in A)
		if(T.isempty())
			L += T
	var/turf/Trand = pick(L)
	src.loc = Trand

	if (ticker && master_mode =="sandbox" && src.client.authenticated)
		src.CanBuild()

	return

/mob/carbon/Logout()
	//clear the HUD
	src.hud.del()