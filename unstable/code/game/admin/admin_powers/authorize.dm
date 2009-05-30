/datum/admin_power/authorize
	name = "Authorize"
	panel_type = PANEL_TYPE_PLAYER

	New(adminlevel)
		return

	Topic(href, href_list)
		if(href_list["mob"]) //show the window
			var/mob/M = locate(href_list["mob"])
			if(!M.client)
				return ..()
			M.client.verbs -= /client/proc/authorize
			M.client.authenticated = text("admin/[]", usr.client.authenticated)
			world.log_admin(text("ADMIN: [] authorized []", usr.key, M.spawn_name))
			M.client << text("You have been authorized by []", usr.key)
		return ..()

	get_desc(mob/M)
		if(M.client.authenticated)
			return "Authorized"
		else if(M.client.authenticating)
			return "Authorizing"
		else
			return "<a href='?src=\ref[src];mob=\ref[M]'>Authorize</a>"