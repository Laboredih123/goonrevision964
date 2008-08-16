/client/proc/adminsay(msg as text)
	//	All admins should be authenticated, but... what if?
	if(!src.authenticated || !src.powers)
		src << "Only administrators may use this command."
		return

	if(!src.mob)
		return

	var/name = ((src.mob)?(src.mob.name):("No Mob"))

	//	Seems silly to log the message without sanitizing, but other *.dm do...
	world.log << "ADMIN: [src.key]/[name] : [msg]"
	msg = html_encode(copytext(sanitize(msg), 1, 1024))

	if (!msg)
		return

	for(var/mob/M in world)
		if (M.client && M.client.powers)
			M << "\blue <b>ADMIN: <a href='?src=\ref[usr];priv_msg=\ref[usr]'>[src.key]</a>/([name]):</b> [msg]"
