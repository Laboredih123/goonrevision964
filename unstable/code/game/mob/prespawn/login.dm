/mob/prespawn/Login()
	src.client.eye = null

	src.prefs.savefile_loc = "savefiles/[savefile_ver]/[src.ckey].sav"
	src.prefs.load()

	if(!src.prefs.last_version || src.prefs.last_version != md5(changes)) //they havent seen this changelog
		src.changes()

	src.prefs.setup(src.client)

