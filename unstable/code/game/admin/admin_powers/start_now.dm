/datum/admin_power/start_now
	panel_type = PANEL_TYPE_GAME

	New(adminlevel)
		return

	Topic(href, href_list)
		world << "<B>The game will now start immediately thanks to [usr.key]!</B>"
		going = 1
		if (!ticker)
			ticker = new /datum/control/gameticker()
			spawn (0)
				world.log_admin("[usr.key] used start_now")
				ticker.process()
			data_core = new /obj/datacore()

	get_desc()
		if(!ticker)
			return "<a href='?src=\ref[src]'>Start round now</a>"
		else
			return null