/datum/admin_power/list_bomb_makers
	panel_type = PANEL_TYPE_GAME

	New(adminlevel)
		return

	Topic(href, href_list)
		..()
		var/dat = "<B>Don't be insane about this list</B> Get the facts. They also could have disarmed one.<HR>"
		for(var/ckey in bombers)
			dat += "[ckey] 'made' a bomb.<BR>"
		ss13_browse(usr, dat, "window=bombers")

	get_desc()
		return "<a href='?src=\ref[src]'>List bomb makers</a>"
