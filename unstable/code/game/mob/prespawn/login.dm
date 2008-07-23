/mob/prespawn/Login()
	client.eye = null

	client.prefs.savefile_loc = "savefiles/[savefile_ver]/[src.ckey].sav"
	client.prefs.load()

	if(!client.prefs.last_version || client.prefs.last_version != md5(changes)) //they havent seen this changelog
		src.changes()

	client.prefs.setup(client)

