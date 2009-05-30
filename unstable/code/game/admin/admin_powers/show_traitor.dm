/datum/admin_power/show_traitor
	panel_type = PANEL_TYPE_GAME

	New(adminlevel)
		return

	Topic(href, href_list)
		if(game_started && current_mode && istype(current_mode, /datum/game_mode/traitor))
			var/mob/t = current_mode:traitor
			if(t && t.client)
				alert("The traitor's spawn name is [t.spawn_name] and his key is [t.last_known_ckey]")
			else if(t)
				alert("The traitor's spawn name is [t.spawn_name].")
			else
				alert("There doesn't seem to be a traitor. (Perhaps he was banned?)")
		return ..()

	get_desc()
		if(game_started && current_mode && istype(current_mode, /datum/game_mode/traitor))
			return "<a href='?src=\ref[src]'>Show traitor identity</a>"
		else
			return null
