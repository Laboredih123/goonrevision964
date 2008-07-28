/mob/verb/adminhelp(msg as text)
	if(!usr.client.authenticated)
		src << "Please authorize before sending these messages."
		return

	msg = sanitize(msg)
	msg = html_encode(copytext(msg, 1, MAX_MESSAGE_LEN))

	if (!msg)
		return

	var/yep = 0
	for(var/mob/M in world)
		if (M.client && M.client.powers)
			M << "\blue <b>HELP: <a href='?src=\ref[usr];priv_msg=\ref[usr]'>[src.name]</a>/([src.key]):</b> [msg]"
			yep = 1

	if (yep)
		src << "Your message has been broadcast to administrators."
		world.log_ooc("ADMINHELP: RECIPIENTS: [src.name] ([src.key]): [msg]")
	else
		src << "Sorry, no administrators are on to hear your plea for help. The notice was logged."
		world.log_game("ADMINHELP: NO RECIPIENTS: [src.name] ([src.key]): [msg]")
