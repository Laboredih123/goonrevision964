/datum/admin_power/boot
	name = "Boot"
	panel_type = PANEL_TYPE_PLAYER
	allowed_for = ADMIN_MOD | ADMIN_ADMIN | ADMIN_SUPERADMIN

	Topic(href, href_list)
		if(href_list["mob"]) //show the window
			var/mob/M = locate(href_list["mob"])
			if(M.client)
				world.log_admin("[M.key] has been booted by [usr.key].")
				del(M.client)
		return ..()

	get_desc(mob/M)
		return "<a href='?src=\ref[src];mob=\ref[M]'>Boot</a>"
