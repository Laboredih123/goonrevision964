/mob/prespawn/Login()
	src.client.eye = null

	src.savefile_loc = "savefiles/[savefile_ver]/[src.ckey].[SAVEFILE_EXTENSION]"
	src.savefile_load()

	if(!src.char_last_version || src.char_last_version != md5(changes)) //they havent seen this changelog
		src.changes()

	src.char_setup()

