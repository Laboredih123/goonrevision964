/var/const/PANEL_TYPE_PLAYER = 1
/var/const/PANEL_TYPE_GAME = 2

/datum/admin_power
	var/name = "Nondescript admin power"
	var/panel_type = null
	var/allowed_for = 0 // all admin levels which get this, ORed together.

	proc/is_applicable(adminlevel)
		if(adminlevel & allowed_for)
			return 1
		return 0

	Topic(href, href_list)
		var/client/C = usr.client
		if(panel_type == PANEL_TYPE_PLAYER)
			C.mob_panel()
		else
			C.game_panel()
		return

	proc/get_desc()
		return