/datum/admin_power/announce
	panel_type = PANEL_TYPE_GAME

	New(adminlevel)
		return

	Topic(href, href_list)
		var/t = input("Global message to send:", "Admin Announce", null, null)  as message
		if (t)
			world << "\blue <B>[usr.key] Announces:</B>\n \t [t]"
			world.log_admin("Announce: [usr.key] : [t]")
		return ..()

	get_desc()
		return "<a href='?src=\ref[src]'>Announce</a>"
