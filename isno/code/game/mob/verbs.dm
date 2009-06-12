/mob/verb/respawn()
	if (!abandon_allowed)
		return
	if (!src.is_dead)
		usr << "\blue <B>You must be dead to use this!</B>"
		return
	world.log_game("[usr.name]/[usr.key] respawned.")
	usr << "\blue <B>Please roleplay correctly!</B>"

	var/mob/prespawn/M = new()

	if(!src.client)
		world.log_game("[usr.key] respawn failed due to disconnect.")
		return
	else
		M.client = src.client

	return

/mob/verb/help()

	ss13_browse(src, 'help.html', "window=help")
	return

/mob/verb/changes()
	set name = "Changelog"
	ss13_browse(src, text("[]", changes), "window=changes")
	return

/mob/verb/observe()
	set name = "Observe"
	var/is_admin = 0

	//TODO: Make this only show up for dead people and admins
	if (src.client.powers)
		is_admin = 1
	else if (!src.is_dead)
		usr << "\blue You must be dead to use this!"
		return

	if (is_admin && src.is_dead)
		is_admin = 0

	var/list/names = list()
	var/list/namecounts = list()
	var/list/creatures = list()
	for (var/obj/item/weapon/disk/nuclear/D in world)
		var/name = "Nuclear Disk"
		if (name in names)
			namecounts[name]++
			name = "[name] ([namecounts[name]])"
		else
			names.Add(name)
			namecounts[name] = 1
		creatures[name] = D
	for (var/mob/M in world)
		if(!istype(M, /mob/carbon) && !istype(M, /mob/silicon)) //don't show prespawn people, etc
			continue
		var/name = M.name

		if (name in names)
			namecounts[name]++
			name = "[name] ([namecounts[name]])"
		else
			names.Add(name)
			namecounts[name] = 1

		if (M.spawn_name && M.spawn_name != M.name) //they're in disguise!
			name += " \[[M.spawn_name]\]"

		if (M.is_dead)
			name += " \[dead\]"

		creatures[name] = M

	src.client.perspective = EYE_PERSPECTIVE

	var/eye_name = null

	if (is_admin)
		eye_name = input("Please select a player!", "Admin Observe") as null|anything in creatures
	else
		eye_name = input("Please select a player!", "Observe") as null|anything in creatures

	if (!eye_name)
		return

	var/mob/eye = creatures[eye_name]
	if (eye && eye != src.client.mob)
		src.reset_view(eye)
		src.client.is_observing = 1
	else
		src.reset_view(null)
		src.client.is_observing = 0

	if (src.is_dead)
		src.sight |= SEE_TURFS
		src.sight |= SEE_MOBS
		src.sight |= SEE_INFRA
		src.sight |= SEE_OBJS
		src.see_in_dark = 8
		src.see_invisible = 2
		src.see_infrared = 8

/mob/verb/cancel_camera()
	set name = "Cancel Camera View"
	src.reset_view(null)
	src.client.is_observing = 0
	src.machine = null
	src:cameraFollow = null

/mob/verb/character_setup()
	set name = "Character Setup"
	client.prefs.setup(client)
