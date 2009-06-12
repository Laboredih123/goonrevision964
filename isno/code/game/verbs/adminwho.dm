/mob/verb/adminwho()
	usr << "<b>Current Admins:</b>"

	for (var/mob/M in world)
		if (!M.client)
			continue

		if (M.client.powers && M.client.powers.len > 0)
			usr << "\t[M.client]"
