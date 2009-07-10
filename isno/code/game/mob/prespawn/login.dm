/mob/prespawn/Login()
	. = ..()

	spawn()
		var/area/prespawn/A = locate(/area/prespawn)
		var/turf/T = pick(A.contents)
		while(T.contents.len > 0)
			T = pick(A.contents)
			sleep(10)
		src.loc = T

	if(!src.client.prefs.savefile_loc)
		src.client.prefs.savefile_loc = "savefiles/[savefile_ver]/[src.ckey].sav"
		src.client.prefs.load()

	if(!src.client.prefs.last_version || src.client.prefs.last_version != md5(changes)) //they havent seen this changelog
		src.changes()

	if(src.client.authenticated)
		// give them the verb now, since we didn't in Authorize
		src.verbs += /mob/verb/character_setup
