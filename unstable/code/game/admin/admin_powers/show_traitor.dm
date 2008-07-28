/datum/admin_power/toggle_ooc
	panel_type = PANEL_TYPE_GAME

	New(adminlevel)
		return

	Topic(href, href_list)
		if(ticker && ticker.killer)
			if(ticker.killer.last_known_ckey)
				alert("The traitor's spawn name is [ticker.killer.spawn_name] and his key is [ticker.killer.last_known_ckey]")
			else
				alert("The traitor's spawn name is [ticker.killer.spawn_name].")

	get_desc()
		if(ticker && ticker.killer)
			return "<a href='?src=\ref[src]'>Show traitor identity</a>"
		else
			return null
