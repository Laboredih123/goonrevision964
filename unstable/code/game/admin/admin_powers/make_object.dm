/datum/admin_power/make_object
	panel_type = PANEL_TYPE_GAME

	New(adminlevel)
		if(adminlevel == ADMIN_MOD)
			del(src)

	Topic(href, href_list)
		var/X = typesof(/obj/)
		var/Q = input("What object?", null, null, null)  as null|anything in X
		if (!( Q ))
			return
		new Q( usr.loc )
		world.log_admin("[usr.key] created a [Q]")

	get_desc()
		return "<a href='?src=\ref[src]'>Make object</a>"