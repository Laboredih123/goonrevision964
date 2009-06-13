/mob/Login()
	src.next_move = 1
	if (!( isturf(src.loc) ))
		src.client.eye = src.loc
		src.client.perspective = EYE_PERSPECTIVE
	src.sight |= SEE_SELF

	. = ..()

	src.last_known_ip = src.client.address
	src.last_known_ckey = src.client.ckey
	src.last_known_computer_id = src.client.computer_id

/mob/Logout()
	if(src.client)
		for(var/obj/screen/s in src.client.screen)
			del(s)