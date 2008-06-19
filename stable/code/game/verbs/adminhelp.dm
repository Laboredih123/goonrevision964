/mob/verb/adminhelp(msg as text)
	if (config.logooc)
		world.log << "HELP: [src.name]/[src.key] : [msg]"
	
	msg = cleanstring(msg)
	msg = html_encode(copytext(msg, 1, 128))
	
	if (!msg)
		return
	
	var/yep = 0
	if (!src.muted)
		for(var/mob/M in world)
			if (M.client && M.client.holder)
				M << "<B>HELP: [src.key]</B>: [msg]"
				yep = 1
	
	if (yep)
		src << "Your message has been broadcast to administrators."
	else
		src << "Sorry, no administrators are on to hear your plea for help."
