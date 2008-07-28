/datum/admin_power/check_traitor
	name = "Traitor?"
	panel_type = PANEL_TYPE_PLAYER

	New(adminlevel)
		return

	Topic(href, href_list)
		if(href_list["mob"])
			var/mob/M = locate(href_list["mob"])
			if(ticker && ticker.killer && ticker.killer == M)
				alert("This person is the traitor.")
			else
				alert("This person is not the traitor.")

	get_desc(mob/M)
		if(ticker && ticker.killer)
			return "<a href='?src=\ref[src];mob=\ref[M]'>Traitor?</a>"
		else
			return null