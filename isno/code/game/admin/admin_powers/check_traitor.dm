// TODO: make this work with random and secret etc

/datum/admin_power/check_traitor
	name = "Traitor?"
	panel_type = PANEL_TYPE_PLAYER

	New(adminlevel)
		return

	Topic(href, href_list)
		..()
		if(href_list["mob"])
			var/mob/M = locate(href_list["mob"])
			if(!M)
				return
			world.log_admin("[usr.key] checked whether [M.key] was a traitor.")
			if(game_started && current_mode && current_mode.get_traitors())
				if(M in current_mode.get_traitors())
					alert("This person is a traitor.")
				else
					alert("This person is not a traitor.")
			else
				alert("There is no traitor!")

	get_desc(mob/M)
		if(game_started && current_mode && current_mode.get_traitors())
			return "<a href='?src=\ref[src];mob=\ref[M]'>Traitor?</a>"
		else
			return null