/datum/admin_power/restart
	panel_type = PANEL_TYPE_GAME

	New(adminlevel)
		return

	Topic(href, href_list)
		if(alert("Restart?","Restart","Yes","No") == "No")
			return
		world << "\red <B> Restarting!</B> \blue Initiated by [usr.key]!"
		world.log_admin("[usr.key] initiated a restart.")
		world.Reboot()
		return ..()

	get_desc()
		return "<a href='?src=\ref[src]'>Restart</a>"