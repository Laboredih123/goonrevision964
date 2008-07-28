/datum/admin_power/toggle_restart_voting
	panel_type = PANEL_TYPE_GAME

	New(adminlevel)
		return

	Topic(href, href_list)
		config.allow_vote_restart = !config.allow_vote_restart
		world << "<B>Player restart voting toggled to [config.allow_vote_restart ? "On" : "Off"]</B>."
		world.log_admin("Restart voting toggled to [config.allow_vote_restart ? "On" : "Off"] by [usr.key].")
		if(config.allow_vote_restart)
			vote.nextvotetime = world.timeofday

	get_desc()
		if(!config.allow_vote_restart)
			return "<a href='?src=\ref[src]'>Enable restart voting</a>"
		else
			return "<a href='?src=\ref[src]'>Disable restart voting</a>"