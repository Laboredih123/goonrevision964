/var/const/PANEL_TYPE_PLAYER = 1
/var/const/PANEL_TYPE_GAME = 2

/datum/admin_power
	var/name = "Nondescript admin power"
	var/panel_type = null

	New(adminlevel)
		del(src)

	Topic(href, href_list)
		return

	proc/get_desc()
		return