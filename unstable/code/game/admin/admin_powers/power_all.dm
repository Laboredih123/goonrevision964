/datum/admin_power/power_all
	panel_type = PANEL_TYPE_GAME

	New(adminlevel)
		if(adminlevel == ADMIN_MOD)
			del(src)

	Topic(href, href_list)
		world.log_admin("[usr.key] used power_all.")
		for(var/area/A in world)
			A.requires_power = 0
			A.power_light = 1
			A.power_equip = 1
			A.power_environ = 1

			A.power_change()

	get_desc()
		return "<a href='?src=\ref[src]'>Power all areas</a>"
