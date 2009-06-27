/client/proc/adminsay(msg as text)
	set name = "asay"
	//	All admins should be authenticated, but... what if?
	if(!src.authenticated || !src.powers)
		src << "Only administrators may use this command."
		return

	if(!src.mob)
		return

	var/name = ((src.mob)?(src.mob.name):("No Mob"))

	msg = sanitize(msg)
	if(!msg) return
	world.log << "ADMIN: [src.key]/[name] : [msg]"

	for(var/mob/M in world)
		if (M.client && M.client.powers)
			M << "\blue <b>ADMIN: <a href='?src=\ref[usr];priv_msg=\ref[usr]'>[src.key]</a>/([name]):</b> [msg]"
