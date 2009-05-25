/datum/admin_power/boot
	name = "Boot"
	panel_type = PANEL_TYPE_PLAYER

	New(adminlevel)
		return

	Topic(href, href_list)
		if(href_list["mob"]) //show the window
			var/mob/M = locate(href_list["mob"])
			if(M.client)
				del(M.client)

	get_desc(mob/M)
		return "<a href='?src=\ref[src];mob=\ref[M]'>Boot</a>"
