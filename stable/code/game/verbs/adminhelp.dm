/mob/verb/adminhelp(msg as text)
	if(!usr.client.authenticated)
		src << "Please authorize before sending these messages."
		return

	world.log_ooc("HELP: [src.name]/[src.key] : [msg]")

	msg = sanitize(msg)
	msg = html_encode(copytext(msg, 1, 1024))

	if (!msg)
		return

	var/yep = 0
	if (!src.muted)
		for(var/mob/M in world)
			if (M.client && M.client.holder)
				M << "\blue <b>HELP: <a href='?src=\ref[usr];priv_msg=\ref[usr]'>[src.name]</a>/([src.key]):</b> [msg]"
				yep = 1

	if (yep)
		src << "Your message has been broadcast to administrators."
	else
		src << "Sorry, no administrators are on to hear your plea for help."
