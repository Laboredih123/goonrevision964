/datum/admin_power/toggle_respawn
	panel_type = PANEL_TYPE_GAME

	New(adminlevel)
		return

	Topic(href, href_list)
		abandon_allowed = !( abandon_allowed )
		if (abandon_allowed)
			world << "<B>You may now respawn.</B>"
		else
			world << "<B>You may no longer respawn.</B>"
		world.log_admin("[usr.key] toggled respawning to [abandon_allowed ? "On" : "Off"].")
		world.update_stat()
		return ..()

	get_desc()
		if(abandon_allowed)
			return "<a href='?src=\ref[src]'>Disable respawning</a>"
		else
			return "<a href='?src=\ref[src]'>Enable respawning</a>"



