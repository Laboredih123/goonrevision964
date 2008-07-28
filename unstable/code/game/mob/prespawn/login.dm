/mob/prespawn/Login()
	. = ..()

	src.client.eye = null

	src.client.prefs.savefile_loc = "savefiles/[savefile_ver]/[src.ckey].sav"
	src.client.prefs.load()

	if(!src.client.prefs.last_version || src.client.prefs.last_version != md5(changes)) //they havent seen this changelog
		src.changes()

	src.client.prefs.setup(client)

