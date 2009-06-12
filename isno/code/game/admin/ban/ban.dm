/datum/ban
	var/id = "0"
	var/origckey = ""
	var/reason = ""
	var/adminckey = ""
	var/bantime = 0

	New(id, origckey, reason, adminckey)
		src.id = id
		src.origckey = origckey
		src.reason = reason
		src.adminckey = adminckey
		bantime = world.realtime

	proc/is_banned()
		// returns 1 if the person this ban applies to is banned, 0 if they aren't
		// if 0, ban is deleted
		// TODO: make bans never 100% deleted, there should still be a log somewhere that isn't autoloaded at game start
		return 0

	proc/ban_message()
		return {"<html><font color='red'>You have been banned [get_duration_desc()] by [adminckey].<br>
				 The reason given was: [reason].<br>
				 You were banned on [time2text(bantime, "Day, Month DD, YYYY, at hh:mm")].<br>
				 The original key banned was [origckey].<br></font>"}
	proc/get_duration_desc()
		return "for an extremely short amount of time"

/var/const/BANFILE_LOC_CKEY = "bans/ckey.ban"
/var/const/BANFILE_LOC_IP = "bans/ip.ban"
/var/const/BANFILE_LOC = "bans/bans.ban"

/client/New()
	// Note: Only the first still-valid ban encountered is updated to also hit the banned guy's new IP, key, or
	// whatever if he evades the ban updater.
	// This is not a huge issue, as they only time it'd matter would be if he did something like get banned for
	// five rounds, then while not on the server get permabanned, then come back after changing his IP and clearing
	// his cookies but with the same key and BYOND cache, then come back with that same IP without clearing his
	// cookies but with a new key and BYOND cache.
	// This is not a likely scenario.

	// check if his ckey or IP are banned
	for(var/list/L in list(list(src.ckey, BANFILE_LOC_CKEY), list(src.address, BANFILE_LOC_IP)))
		var/id = L[1]
		var/savefile/F = new(L[2])
		if(id && F[id])
			var/list/banids = F[id]
			for(var/banid in banids)
				var/savefile/bans_by_banid = new(BANFILE_LOC)
				var/datum/ban/B = bans_by_banid[banid]
				if(B)
					if(!B.is_banned())
						remove_ban(B)
					else
						src << B.ban_message()
						ban(ckey, address, src, B)
						del src
						return
				F.dir -= id

	// check for BYOND cache ban
	var/savefile/S = src.Import()
	if(world.url in S)
		var/key = "world:" + world.url
		var/savefile/banids = new(S[key])
		for(var/banid in banids)
			var/savefile/bans_by_banid = new(BANFILE_LOC)
			var/datum/ban/B = bans_by_banid[banid]
			if(B)
				if(!B.is_banned())
					remove_ban(B)
				else
					src << B.ban_message()
					ban(ckey, address, src, B)
					del src
					return
			banids -= banid
			src.Export(S)

	// check if he's cookiebanned
	return ..()

/proc/remove_ban(datum/ban/B)
	var/savefile/F = new(BANFILE_LOC)
	F.dir -= B.id

/proc/ban(ckey, ip, client/C, datum/ban/B)
	if(!B)
		return
	var/banid = B.id

	// add to master ban list
	var/savefile/F = new(BANFILE_LOC)
	if(!F[banid])
		F[banid] = B

	// ipban and ckeyban
	for(var/list/L in list(list(ckey, BANFILE_LOC_CKEY), list(ip, BANFILE_LOC_IP)))
		var/id = L[1]
		var/savefile/banidlists = new(L[2])
		if(!id)
			continue
		if(banidlists[id])
			if(banid in banidlists[id])
				continue
			else
				banidlists[id] += banid
		else
			banidlists[id] = list(banid)

	//BYOND cache ban
	if(C)
		var/savefile/S = new(C.Import())
		var/key = "world:" + world.url // add something so it's not null, which it is if you play locally.
		if(key in S)
			var/bans = S[key]
			if(!(banid in bans))
				bans += banid
				C.Export(S)
		else
			S[key] = list(banid)
			C.Export(S)

	// cookieban