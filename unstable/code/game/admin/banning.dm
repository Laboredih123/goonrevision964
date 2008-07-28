/datum/ban
	var/is_permanent = 0
	var/expire_time = 0
	var/reason = ""
	var/banner = null

/proc/permaban(mob/M, reason, banner)
	var/datum/ban/B = new()
	B.is_permanent = 1
	B.reason = reason
	B.banner = banner
	ban(M, B)

/proc/hourban(mob/M, reason, hours, banner)
	var/datum/ban/B = new()
	B.expire_time = world.realtime + hours*36000 //convert to seconds
	B.reason = reason
	B.banner = banner
	ban(M, B)

/proc/ban(mob/M, datum/ban/B)
	//doesn't IP ban - that's what authentication is for
	//if pubbies are getting in then we're doomed anyways
	if(M.last_known_ckey)
		add_ban("bans/[M.last_known_ckey].ban", B)

	M << "You have been banned."
	if(B.is_permanent)
		M << "The ban is permanent."
	else
		M << "You will be unbanned in [round((B.expire_time - world.realtime) / 36000)] hours and [round(((B.expire_time - world.realtime) % 36000) / 60)] minutes."
	M << "The reason given for the ban is:"
	M << B.reason
	if(M.client)
		del(M.client)

/client/New()
	//check if they're banned
	var/list/bans = get_bans("bans/[ckey].ban")
	if(bans)
		for(var/datum/ban/B in bans)
			if(B.is_permanent || B.expire_time > world.realtime)
				src << "You have been banned."
				if(B.is_permanent)
					src << "The ban is permanent."
				else
					src << "You will be unbanned in [round((B.expire_time - world.realtime) / 36000)] hours and [round(((B.expire_time - world.realtime) % 36000) / 600, 1)] minutes."
				src << "The reason given for the ban is:"
				src << B.reason
				del(src)
				return
	if(src.ckey in banned)
		src << "You have been roundbanned."
		del(src)
		return
	..()

/proc/load_bans(filename)
	var/savefile/F = new(filename)
	if(!F)
		return null
	if(!F["bans"])
		return null
	var/list/bans = list()
	F["bans"] >> bans
	return bans

/proc/update_bans(list/bans)
	//discard invalid or expired bans
	if(!bans || !bans.len)
		return null
	for(var/datum/ban/B in bans)
		if(!B.is_permanent && B.expire_time < world.realtime)
			bans -= B
	return bans

/proc/write_bans(filename, list/bans)
	if(!bans || !bans.len)
		return
	var/savefile/F = new(filename)
	if(!F)
		return
	F["bans"] << bans

/proc/get_bans(filename)
	var/list/bans = load_bans(filename)
	bans = update_bans(bans)
	write_bans(filename, bans)
	return bans

/proc/add_ban(filename, datum/ban/B)
	var/list/bans = load_bans(filename)
	bans += B
	bans = update_bans(bans)
	write_bans(filename, bans)