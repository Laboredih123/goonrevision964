/datum/admin_power/meteor_wave
	panel_type = PANEL_TYPE_GAME

	New(adminlevel)
		if(adminlevel != ADMIN_HOST)
			del(src)

	Topic(href, href_list)
		world.log_admin("[usr.key] spawned a meteor wave.")
		meteor_wave()

	get_desc()
		return "<a href='?src=\ref[src]'>Meteor wave</a>"
