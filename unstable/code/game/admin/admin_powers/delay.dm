/datum/admin_power/restart
	panel_type = PANEL_TYPE_GAME

	New(adminlevel)
		return

	Topic(href, href_list)
		if(ticker)
			return
		going = !going
		if (going)
			world << text("<B>The game will start soon thanks to [] (Administrator to SS13)</B>", usr.key)
			world.log_admin("[usr.key] removed the delay.")
		else
			world << text("<B>The game start has been delayed by [] (Administrator to SS13)</B>", usr.key)
			world.log_admin("[usr.key] delayed the game.")

	get_desc()
		if(ticker)
			return null
		if(going)
			return "<a href='?src=\ref[src]'>Delay game</a>"
		else
			return "<a href='?src=\ref[src]'>Undelay game</a>"

