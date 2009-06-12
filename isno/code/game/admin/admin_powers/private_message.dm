/datum/admin_power/private_message
	name = "PM"
	panel_type = PANEL_TYPE_PLAYER

	New(adminlevel)
		return

	get_desc(mob/M)
		return "<A href='?src=\ref[usr];priv_msg=\ref[M]'>PM</A>"
