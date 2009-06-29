/datum/admin_power/show_traitor
	panel_type = PANEL_TYPE_GAME
	allowed_for = ADMIN_GM

	Topic(href, href_list)
		if(game_started && config.current_mode)
			world.log_admin("[usr.key] viewed the traitor list.")
			var/list/traitors = config.current_mode.get_traitors()
			var/dat = "<html><head><title>Traitor(s)</title><body><table><tr><th>Spawn Name</th><th>Key</th></tr>"
			for(var/mob/T in traitors)
				dat += "<tr><td>[T.spawn_name]</td>"
				dat += "<td><a href='?src=\ref[usr];priv_msg=\ref[T]'>[T.last_known_ckey]</a></td></tr>"
			ss13_browse(usr, dat, "window=traitorlist")
		return ..()

	get_desc()
		if(game_started && config.current_mode && config.current_mode.get_traitors())
			return "<a href='?src=\ref[src]'>Show traitor(s)</a>"
		else
			return null
