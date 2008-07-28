/var/const/ADMIN_MOD = "Mod"
/var/const/ADMIN_ADMIN = "Admin"
/var/const/ADMIN_HOST = "Host"

/world/New()
	var/ad_text = file2text("admins.txt")
	var/list/L = dd_text2list(ad_text, "\n")
	for(var/t in L)
		if (t)
			if (copytext(t, 1, 2) == "#")
				continue
			var/name_loc = findtext(t, " - ")
			if (name_loc)
				var/key = copytext(t, 1, name_loc)
				var/admin_level = copytext(t, name_loc + 3)
				admins[key] = admin_level
	return ..()

/client/proc/is_host()
	if (world.address == src.address)
		return 1
	if (src.address == "127.0.0.1")
		return 1
	if (!( src.address ))
		return 1
	return 0

/client/proc/game_panel()
	set name = "Game Panel"

	if (src.powers)
		var/dat = "<html><head><title>Game Panel</title></head><body>"
		for(var/datum/admin_power/P in src.powers)
			if(P.panel_type == PANEL_TYPE_GAME)
				var/desc = P.get_desc()
				if(desc)
					dat += "[desc]<br>"
		dat += "</body></html>"
		src << browse(dat, "window=gamepanel")

/client/proc/mob_panel()
	set name = "Player Panel"

	if (!src.powers)
		return

	var/list/player_powers = list()
	for(var/datum/admin_power/P in src.powers)
		if(P.panel_type == PANEL_TYPE_PLAYER)
			player_powers += P
	var/dat = "<html><head><title>Player Panel</title></head><body><table>"
	dat += "<tr><th>Name</th><th>Spawn name</th><th>Key</th><th>IP</th>"
	for(var/datum/admin_power/P in player_powers)
		dat += "<th>[P.name]</th>"
	dat += "</tr>"
	for(var/mob/M in world)
		if(!M.last_known_ckey) //they're a monkey
			continue

		dat += "<tr>"
		dat += "<td>[M.name]</td>"
		dat += "<td>[M.spawn_name]</td>"
		dat += "<td>[M.last_known_ckey]</td>"
		dat += "<td>[M.last_known_ip]</td>"
		for(var/datum/admin_power/P in player_powers)
			dat += "<td>[P.get_desc(M)]</td>"
		dat += "</tr>"
	dat += "</table></body></html>"
	src << browse(dat, "window=mobpanel")

/client/New()
	..()

	spawn (50) //TODO: Try removing this spawn, see if it still works
		if (src.is_host())
			admins[src.ckey] = ADMIN_HOST
		if(admins.Find(src.ckey))
			src.verbs += /client/proc/adminsay
			var/admin_level = admins[src.ckey]
			src.powers = list()
			for(var/power_type in typesof(/datum/admin_power))
				var/datum/admin_power/P = new power_type(admin_level)
				if(P) //they delete themselves if they are inapplicable
					//shut up it's totally good design
					powers += P

			src << text("\blue The game ip is byond://[]:[] !", world.address, world.port)

			src.verbs += /client/proc/game_panel
			src.verbs += /client/proc/mob_panel

			src.verbs += /client/proc/adminsay
			src.verbs += /proc/variables

			if (ticker && master_mode =="sandbox" && admin_level == ADMIN_HOST)
				src.verbs += /proc/variables
				src.verbs += /mob/proc/Delete