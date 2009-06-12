/datum/admin_power/start_now
	panel_type = PANEL_TYPE_GAME

	New(adminlevel)
		return

	Topic(href, href_list)
		if (!game_started)
			world << "<B>The game will now start immediately thanks to [usr.key]!</B>"
			going = 1
			spawn (0)
				world.log_admin("[usr.key] used start_now")
				start_game()
			data_core = new /obj/datacore()
		return ..()

	get_desc()
		if(!game_started)
			return "<a href='?src=\ref[src]'>Start round now</a>"
		else
			return null