/mob/Login()
	if (CanAdmin())
		src << text("\blue The game ip is byond://[]:[] !", world.address, world.port)
		src.verbs += /mob/proc/show_ctf
		src.verbs += /proc/variables
	src.next_move = 1
	if (!( isturf(src.loc) ))
		src.client.eye = src.loc
		src.client.perspective = EYE_PERSPECTIVE
	src.last_known_ip = client.address
	src.sight |= SEE_SELF

	if (ticker && master_mode =="sandbox" && src.client.authenticated)
		mob.CanBuild()

	return ..()