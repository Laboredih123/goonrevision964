/datum/admin_power/check_traitor
	name = "Traitor?"
	panel_type = PANEL_TYPE_PLAYER

	New(adminlevel)
		return

	Topic(href, href_list)
		if(href_list["mob"])
			var/mob/M = locate(href_list["mob"])
			if(game_started && current_mode && istype(current_mode, /datum/game_mode/traitor))
				if(M.client && current_mode:traitor == M.client)
					alert("This person is the traitor.")
				else
					alert("This person is not the traitor.")
			else
				alert("There is no traitor!!!")

	get_desc(mob/M)
		if(game_started && current_mode && istype(current_mode, /datum/game_mode/traitor))
			return "<a href='?src=\ref[src];mob=\ref[M]'>Traitor?</a>"
		else
			return null