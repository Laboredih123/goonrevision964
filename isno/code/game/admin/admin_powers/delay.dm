/datum/admin_power/delay
	panel_type = PANEL_TYPE_GAME
	allowed_for = ADMIN_GM

	Topic(href, href_list)
		if(game_started)
			return
		going = !going
		if (going)
			world << text("<B>The game will start soon thanks to [] (Administrator to SS13)</B>", usr.key)
			world.log_admin("[usr.key] removed the delay.")
		else
			world << text("<B>The game start has been delayed by [] (Administrator to SS13)</B>", usr.key)
			world.log_admin("[usr.key] delayed the game.")
		return ..()

	get_desc()
		if(game_started)
			return null
		if(going)
			return "<a href='?src=\ref[src]'>Delay game</a>"
		else
			return "<a href='?src=\ref[src]'>Undelay game</a>"

