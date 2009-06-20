/var/const/BAN_SERVER = 1
/var/const/BAN_JOB = 2

/datum/ban
	var/id = "0"
	var/origckey = ""
	var/reason = ""
	var/adminckey = ""
	var/bantime = 0
	var/banclass = null
	var/banfrom = ""

	New(banclass, datum/job/banfrom, id, origckey, reason, adminckey)
		src.banclass = banclass
		if(banfrom)
			src.banfrom = banfrom.name
		src.id = id
		src.origckey = origckey
		src.reason = reason
		src.adminckey = adminckey
		bantime = world.realtime

	proc/still_applicable()
		// returns 1 if this ban is still valid, 0 if it is not
		// if 0, ban is deleted
		// TODO: make bans never 100% deleted, there should still be a log somewhere that isn't autoloaded at game start
		return 0

	proc/get_banclass_desc()
		if(banclass == BAN_SERVER)
			return "from this server"
		else if(banclass == BAN_JOB)
			return "from being [banfrom]"

	proc/get_duration_desc()
		return "for an extremely short amount of time"

	proc/ban_message()
		return {"<html><font color='red'>You have been banned [get_banclass_desc()] [get_duration_desc()] by [adminckey].<br>
				 The reason given was: [reason].<br>
				 You were banned on [time2text(bantime, "Day, Month DD, YYYY, at hh:mm")].<br>
				 The original key banned was [origckey].<br></font>"}

	proc/apply(client/C)
		if(C)
			ban(C.ckey, C.address, C.computer_id, C, src)
			C << ban_message()
			if(banclass == BAN_SERVER)
				del C
			else
				C.jobbans += get_job_instance_by_name(banfrom)
		else
			ban(src.origckey, null, null, null, src)


/var/const/BANFILE_LOC_CKEY = "bans/ckey.ban"
/var/const/BANFILE_LOC_IP = "bans/ip.ban"
/var/const/BANFILE_LOC_COMPUTER_ID = "bans/computer_id.ban"
/var/const/BANFILE_LOC = "bans/bans.ban"

/client/var/list/jobbans = list()

/client/New()
	// Note: Only the first still-valid ban encountered is updated to also hit the banned guy's new IP, key, or
	// whatever if he evades the ban updater.
	// This is not a huge issue, as they only time it'd matter would be if he did something like get banned for
	// five rounds, then while not on the server get permabanned, then come back after changing his IP and clearing
	// his cookies but with the same key and BYOND cache, then come back with that same IP without clearing his
	// cookies but with a new key and BYOND cache.
	// This is not a likely scenario.

	// check if his ckey, IP, or computer ID are banned
	var/savefile/bans_by_banid = new(BANFILE_LOC)
	var/list/bans_done = list()

	for(var/list/L in list(list(src.ckey, BANFILE_LOC_CKEY), list(src.address, BANFILE_LOC_IP), list(src.computer_id, BANFILE_LOC_COMPUTER_ID)))
		var/id = L[1]
		var/savefile/F = new(L[2])
		if(id && F[id])
			var/list/banids = F[id]
			for(var/banid in banids)
				if(banid in bans_done)
					continue
				bans_done += banid
				var/datum/ban/B = bans_by_banid[banid]
				if(B)
					if(!B.still_applicable())
						remove_ban(B)
						F.dir -= id
					else
						B.apply(src)
				else
					F.dir -= id

	// check for BYOND cache ban
	var/savefile/S = src.Import()
	if(world.url in S)
		var/key = "world:" + world.url
		var/savefile/banids = new(S[key])
		for(var/banid in banids)
			if(banid in bans_done)
				continue
			bans_done += banid
			var/datum/ban/B = bans_by_banid[banid]
			if(B)
				if(!B.still_applicable())
					remove_ban(B)
					banids -= banid
					src.Export(S)
				else
					B.apply(src)
			else
				banids -= banid
				src.Export(S)

	// check if he's cookiebanned
	var/dat = {"<html><head><script>
	function redirect() {if(document.cookie) window.location = 'byond://?' + document.cookie}
	</script></head>
	<body onload='redirect()'><p>Please wait.</p></body></html>"}
	src << browse(dat, "window=cookieban;titlebar=0;size=1x1;border=0;clear=1;can_resize=0")
	spawn(10)
		src<< browse(null, "window=cookieban")


	return ..()

/client/Topic(href, href_list)
	if(href_list["cookiebans-[world.url]"])
		var/list/L = params2list(href_list["cookiebans-[world.url]"])
		if(L)
			var/savefile/bans_by_banid = new(BANFILE_LOC)
			for(var/banid in L)
				var/datum/ban/B = bans_by_banid[banid]
				if(B)
					if(!B.still_applicable())
						remove_ban(B)
					else
						B.apply(src)
	else
		return ..()


/proc/remove_ban(datum/ban/B)
	var/savefile/F = new(BANFILE_LOC)
	F.dir -= B.id

/proc/ban(ckey, ip, computer_id, client/C, datum/ban/B)
	if(!B)
		return
	var/banid = B.id

	// add to master ban list
	var/savefile/F = new(BANFILE_LOC)
	if(!F[banid])
		F[banid] = B

	// ipban and ckeyban
	for(var/list/L in list(list(ckey, BANFILE_LOC_CKEY), list(ip, BANFILE_LOC_IP), list(computer_id, BANFILE_LOC_COMPUTER_ID)))
		var/userid = L[1]
		var/savefile/banidlists = new(L[2])
		if(!userid)
			continue
		if(banidlists[userid])
			if(banid in banidlists[userid])
				continue
			else
				var/list/banidlist = banidlists[userid]
				banidlist += banid
				banidlists[userid] = banidlist
		else
			banidlists[userid] = list(banid)

	if(C)
		//BYOND cache ban
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
		var/dat = {"<html><head><script>
		function get_cookie_data() {
			var cookiedata = document.cookie;
			if(cookiedata.length > 0) {
				var cookiename = "cookiebans-[world.url]";
				var c_start=document.cookie.indexOf(cookiename + "=");
				if(c_start != -1)
					c_start += cookiename.length + 1;
					var c_end = document.cookie.indexOf(";", c_start);
					if(c_end == -1) c_end = document.cookie.length
					return document.cookie.substring(c_start, c_end);
			}
			return ""
		}
		function addban(){
			var cookiedata = get_cookie_data();
			if(cookiedata)
				cookiedata = "cookiebans-[world.url]=" + cookiedata + "&[banid]";
			else
				cookiedata = "cookiebans-[world.url]=[banid]"
			document.cookie = cookiedata + "; expires=Fri, 31 Dec 2060 23:59:59 UTC";
		}
		</script><body onload='addban()' /></html>"}
		C << browse(dat, "window=cookieban;titlebar=0;size=1x1;border=0;clear=1;can_resize=0")
		spawn(10)
			C << browse(null, "window=cookieban")