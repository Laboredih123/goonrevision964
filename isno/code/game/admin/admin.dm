/var/const
	ADMIN_GM         = 1 << 0
	ADMIN_MOD        = 1 << 1
	ADMIN_ADMIN      = 1 << 2
	ADMIN_SUPERADMIN = 1 << 3
	ADMIN_DEVELOPER  = 1 << 4
	ADMIN_ALL        = ~0 // all one bits

/proc/get_power(name)
	switch(name)
		if("GM")
			return ADMIN_GM
		if("Mod")
			return ADMIN_MOD
		if("Admin")
			return ADMIN_ADMIN
		if("Superadmin")
			return ADMIN_SUPERADMIN
		if("Developer")
			return ADMIN_DEVELOPER
		if("Host")
			return ADMIN_ALL
		else
			return 0

/world/New()
	var/ad_text = file2text("admins.txt")
	var/list/L = dd_text2list(ad_text, "\n")
	for(var/t in L)
		if (t)
			if (copytext(t, 1, 2) == "#")
				continue
			var/list/x = dd_text2list(t, " ")
			if(x.len >= 3)
				var/key = ckey(x[1])
				var/powers = 0
				for(var/i = 3; i <= x.len; i++)
					powers |= get_power(x[i])
				admins[key] = powers
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
		ss13_browse(src, dat, "window=gamepanel")

/client/proc/mob_panel()
	set name = "Player Panel"

	if (!src.powers)
		return

	var/list/player_powers = list()
	for(var/datum/admin_power/P in src.powers)
		if(P.panel_type == PANEL_TYPE_PLAYER)
			player_powers += P
	var/dat = "<html><head><title>Player Panel</title></head><body><table border=1>"
	dat += "<tr><th>Name</th><th>Spawn name</th><th>Logged in?</th><th>Key</th><th>IP</th>"
	for(var/datum/admin_power/P in player_powers)
		dat += "<th>[P.name]</th>"
	dat += "</tr>"
	var/mobs_by_ckey = list()
	for(var/mob/M in world)
		if(!M.last_known_ckey) //they're a monkey
			continue
		if((M.last_known_ckey in mobs_by_ckey) && !M.client)
			continue
		mobs_by_ckey[M.last_known_ckey] = M
	for(var/ckey in mobs_by_ckey)
		var/mob/M = mobs_by_ckey[ckey]
		dat += "<tr>"
		dat += "<td>[M.name]</td>"
		dat += "<td>[M.spawn_name]</td>"
		dat += "<td>[M.client ? "Yes" : "No"]</td>"
		dat += "<td>[M.last_known_ckey]</td>"
		dat += "<td>[M.last_known_ip]</td>"
		for(var/datum/admin_power/P in player_powers)
			dat += "<td>[P.get_desc(M)]</td>"
		dat += "</tr>"
	dat += "</table></body></html>"
	ss13_browse(src, dat, "window=mobpanel;size=800x400")

/client/New()
	..()

	spawn (50) //TODO: Try removing this spawn, see if it still works
		if (src.is_host())
			admins[src.ckey] = ADMIN_ALL
		if(src.ckey in admins)
			src.verbs += /client/proc/adminsay

			src.adminlevel = admins[src.ckey]
			src.powers = list()
			for(var/datum/admin_power/P in get_admin_power_instances())
				if(P.is_applicable(src.adminlevel))
					src.powers += P

			if(world.url)
				src << "\blue The game ip is [world.url]!"
			else
				src << "\blue The world is running locally!"

			src.verbs += /client/proc/game_panel
			src.verbs += /client/proc/mob_panel
			src.verbs += /client/proc/adminsay
			src.verbs += /client/proc/private_message

			if(src.adminlevel & ADMIN_GM)
				src.verbs += /client/proc/toggle_frozen

			if(src.adminlevel & ADMIN_DEVELOPER)
				src.verbs += /proc/variables
				src.verbs += /proc/delete

/var/list/admin_power_instances = null
/proc/get_admin_power_instances()
	if(!admin_power_instances)
		admin_power_instances = list()
		for(var/T in typesof(/datum/admin_power))
			var/datum/admin_power/P = new T()
			admin_power_instances += P
	return admin_power_instances