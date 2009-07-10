/datum/admin_power/custom_ban
	name = "Custom Ban"
	panel_type = PANEL_TYPE_GAME
	allowed_for = ADMIN_MOD | ADMIN_ADMIN | ADMIN_SUPERADMIN

	get_desc()
		return "<a href='?src=\ref[usr];mob-ban=[CUSTOM_BAN]'>Custom Ban</a>"