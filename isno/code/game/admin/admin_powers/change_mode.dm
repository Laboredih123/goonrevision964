/datum/admin_power/change_mode
	panel_type = PANEL_TYPE_GAME
	allowed_for = ADMIN_GM

	Topic(href, href_list)
		..()
		if(href_list["c_mode"])
			config.master_mode = locate(href_list["c_mode"])
			world.log_admin("[usr.key] set the mode as [config.master_mode.long_name].")
			if(!game_started)
				world << "\blue <B>The mode is now: [config.master_mode.long_name]</B>"
			else
				world << "\blue <B>The mode next round will be: [config.master_mode.long_name]</B>"

			set_default_mode(config.master_mode)
		var/dat = "<B>What mode do you wish to play?</B><HR>"
		for(var/datum/game_mode/M in get_mode_instances())
			dat += "<A href='?src=\ref[src];c_mode=\ref[M]'>[M.long_name]</A><br>"
		dat += "Now: [config.master_mode.long_name]"
		ss13_browse(usr, dat, "window=c_mode")

	get_desc()
		return "<a href='?src=\ref[src];action=list'>Change mode</a>"
