/datum/admin_power/toggle_mode_voting
	panel_type = PANEL_TYPE_GAME

	New(adminlevel)
		return

	Topic(href, href_list)
		config.allow_vote_mode = !config.allow_vote_mode
		world << "<B>Player mode voting toggled to [config.allow_vote_mode ? "On" : "Off"]</B>."
		world.log_admin("Mode voting toggled to [config.allow_vote_mode ? "On" : "Off"] by [usr.key].")
		if(config.allow_vote_mode)
			vote.nextvotetime = world.timeofday

	get_desc()
		if(!config.allow_vote_mode)
			return "<a href='?src=\ref[src]'>Enable mode voting</a>"
		else
			return "<a href='?src=\ref[src]'>Disable mode voting</a>"