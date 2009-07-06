/client/proc/jump()
	var/list/namecounts = list()
	var/list/creatures = list()
	for (var/mob/M in world)
		if(!M.last_known_ckey) // don't show monkeys, who needs em
			continue
		if(istype(M, /mob/observer))
			continue
		var/name = M.name

		if (name in creatures)
			namecounts[name]++
			name = "[name] ([namecounts[name]])"
		else
			namecounts[name] = 1

		if (M.spawn_name && M.spawn_name != M.name) //they're in disguise!
			name += " \[[M.spawn_name]\]"

		if (M.is_dead && !istype(M, /mob/prespawn))
			name += " \[dead\]"

		creatures[name] = M

	var/name = input("Please select a mob to jump to.", "jump") as null|anything in creatures

	if (!name)
		return

	var/mob/M = creatures[name]
	if(src.mob)
		src.mob.loc = get_turf(M)
		world.log_admin("[usr] ([usr.ckey]) jumped to [M] ([M.ckey])")
