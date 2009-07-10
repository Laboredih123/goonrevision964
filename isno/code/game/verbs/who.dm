/mob/verb/who()
	set name = "Who"

	var/list/mobs = list()
	for (var/mob/M in world)
		if (!M.client)
			continue
		mobs += M

	usr << "<b>Current Players:</b>"
	for(var/mob/M in sortList(mobs))
		if (M.client.authenticated && M.client.authenticated != 1)
			usr << "\t[M.client] ([html_encode(M.client.authenticated)])"
		else
			usr << "\t[M.client]"
	usr << "<b>Total Players: [mobs.len]</b>"