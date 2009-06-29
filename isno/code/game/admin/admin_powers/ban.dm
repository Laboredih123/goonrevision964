/datum/admin_power/ban
	name = "Ban"
	panel_type = PANEL_TYPE_PLAYER
	allowed_for = ADMIN_MOD | ADMIN_ADMIN | ADMIN_SUPERADMIN

	Topic(href, href_list)
		..()

	get_desc(mob/M)
		if(M && M.client)
			var/targ_adminlevel = M.client.adminlevel
			var/usr_adminlevel = usr.client.adminlevel
			if(targ_adminlevel && !(usr_adminlevel & ADMIN_SUPERADMIN)) // only superadmins can ban other admins
				return
			if((targ_adminlevel & ADMIN_SUPERADMIN) && !(usr_adminlevel == ADMIN_ALL)) // only hosts can ban superadmins
				return
			if(targ_adminlevel == ADMIN_ALL) // nobody can ban hosts
				return
		return "<a href='?src=\ref[usr];mob-ban=\ref[M]'>Ban</a>"

/proc/new_ban_id()
	// ban IDs have to be strings, and should be sequential. This is a fairly simple way to achieve that.
	// add a random number on the end in case two people get banned within 1/10 second of each other.
	// it's unlikely, but better safe than sorry.
	// note that around 2030 an extra digit will be added, and ban IDs will no longer be completely sequential.
	// if it is 2030 and your bans are all out of order, I'm sorry.
	// on the upside, it'll give you some practice for the year 2038 bug.
	return "[num2text(world.realtime, 10)][world.timeofday][num2text(rand(0, 999))]"

/proc/get_max_hours(adminlevel)
	if(adminlevel & ADMIN_SUPERADMIN)
		return INFINITY
	else if(adminlevel & ADMIN_ADMIN)
		return 24*7
	else if(adminlevel & ADMIN_MOD)
		return 24

/proc/get_max_rounds(adminlevel)
	if(adminlevel & ADMIN_SUPERADMIN)
		return INFINITY
	else if(adminlevel & ADMIN_ADMIN)
		return 200
	else if(adminlevel & ADMIN_MOD)
		return 25

/proc/can_permaban(adminlevel)
	if(adminlevel & ADMIN_SUPERADMIN)
		return 1

/var/const/CUSTOM_BAN = "CUSTOMBAN"

/client/Topic(href, href_list)
	if(href_list["mob-ban"]) //show the window
		var/dat = "<html><head><title>Ban</title></head><body>"
		dat += "<form action='byond://' method='get'>"
		dat += "<input type='hidden' name='src' value='\ref[src]'>"
		dat += "<input type='hidden' name='mob-ban2' value='[href_list["mob-ban"]]'>"
		if(href_list["mob-ban"] == CUSTOM_BAN)
			dat += "Key of user to ban: <input type='text' name='key'><br><br>"
		dat += "<input type='radio' name='type' value='round' checked='1'> Rounds: <input type='text' name='rounds' value='1'>"
		dat += "<br><input type='radio' name='type' value='hours'> Hours: <input type='text' name='hours' value='1'>"
		dat += "<br><input type='radio' name='type' value='days'> Days: <input type='text' name='days' value='1'>"
		if(can_permaban(src.adminlevel))
			dat += "<br><input type='radio' name='type' value='permanent'>Permanent"
		dat += "<hr>"
		dat += "Type of ban:"
		dat += "<br><input type='radio' name='bantype' value='server' checked='1'> Game"
		dat += "<br><input type='radio' name='bantype' value='job'> Job: "
		dat += "<select name='job'>"
		for(var/datum/job/job in get_all_job_instances())
			if(job.max > 0)
				dat += "<option value='\ref[job]'>[job.name]</option>"
		dat += "</select>"
		dat += "<hr>"
		dat += "Reason for banning (please be specific)"
		dat += "<br><textarea name='reason' rows=5></textarea>"
		dat += "<br><input type='submit' value='Submit'>"
		dat += "</form>"
		ss13_browse(src, dat, "window=ban")
	else if(href_list["mob-ban2"])
		var/type = href_list["type"]
		var/mobban = href_list["mob-ban2"]
		var/ckey
		var/client/C = null
		if(mobban == CUSTOM_BAN)
			ckey = sanitize(ckey(href_list["key"]))
		else
			var/mob/M = locate(mobban)
			ckey = M.ckey
			C = M.client
		var/reason = sanitize(href_list["reason"])

		var/banclass
		var/datum/job/banfrom
		if(href_list["bantype"] == "server")
			banclass = BAN_SERVER
		else
			banclass = BAN_JOB
			banfrom = locate(href_list["job"])

		var/datum/ban/B
		if(type == "permanent" && can_permaban(src.adminlevel))
			B = new /datum/ban/perma(banclass, banfrom, new_ban_id(), ckey, reason, src.ckey)
		else if(type == "hours")
			var/hours = min(text2num(href_list["hours"]), get_max_hours(src.adminlevel))
			if(hours) // must convert to 1/10 sec
				B = new /datum/ban/time(banclass, banfrom, new_ban_id(), ckey, reason, src.ckey, hours * 60 * 60 * 10)
		else if(type == "days")
			var/hours = min(24 * text2num(href_list["hours"]), get_max_hours(src.adminlevel))
			if(hours) // must convert to 1/10 sec
				B = new /datum/ban/time(banclass, banfrom, new_ban_id(), ckey, reason, src.ckey, hours * 60 * 60 * 10)
		else if(type == "round")
			var/rounds = min(text2num(href_list["rounds"]), get_max_rounds(src.adminlevel))
			if(rounds)
				B = new /datum/ban/round(banclass, banfrom, new_ban_id(), ckey, reason, src.ckey, rounds)

		var/desc = "[ckey] has been banned [B.get_banclass_desc()] [B.get_duration_desc()] by [src.ckey]. The reason given was: [reason]"
		world.log_admin(desc)
		world << "<b><font color='red'>[desc]</font></b>"
		B.apply(C)
		ss13_browse(usr, null, "window=ban")
	else
		..()