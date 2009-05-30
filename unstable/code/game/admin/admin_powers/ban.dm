/datum/admin_power/ban
	name = "Ban"
	panel_type = PANEL_TYPE_PLAYER

	var/max_hours = 0
	var/max_rounds = 0
	var/can_permaban = 0

	New(adminlevel)
		if(adminlevel == ADMIN_MOD)
			src.max_hours = 3
			src.max_rounds = 3
		else if(adminlevel == ADMIN_ADMIN)
			src.max_hours = 24*7 //1 week
			src.max_rounds = 100
		else if(adminlevel == ADMIN_HOST)
			src.max_hours = INFINITY
			src.max_rounds = INFINITY
			src.can_permaban = 1
		else
			del(src)

	Topic(href, href_list)
		..()
		if(href_list["mob"]) //show the window
			var/dat = "<html><head><title>Ban</title></head><body>"
			dat += "<form action='byond://' method='get'>"
			dat += "<input type='hidden' name='src' value='\ref[src]'>"
			dat += "<input type='hidden' name='mob-ban' value='[href_list["mob"]]'>"
			dat += "<input type='radio' name='type' value='round' checked='1'> Rounds: <input type='text' name='rounds' value='1'><br>"
			dat += "<input type='radio' name='type' value='hours'> Hours: <input type='text' name='hours' value='1'><br>"
			if(src.can_permaban)
				dat += "<input type='radio' name='type' value='permanent'>Permanent<br>"
			dat += "Reason for banning (please be specific)<br>"
			dat += "<textarea name='reason' rows=5></textarea><br>"
			dat += "<input type='submit' value='Submit'>"
			dat += "</form>"
			ss13_browse(usr, dat, "window=ban")
		else if(href_list["mob-ban"])
			var/type = href_list["type"]
			var/mob/M = locate(href_list["mob-ban"])
			var/reason = href_list["reason"]
			var/datum/ban/B
			if(type == "permanent" && src.can_permaban)
				B = new /datum/ban/perma(new_ban_id(), M.ckey, reason, usr.ckey)
			else if(type == "hours")
				var/hours = min(text2num(href_list["hours"]), src.max_hours)
				if(hours) // must convert to 1/10 sec
					B = new /datum/ban/time(new_ban_id(), M.ckey, reason, usr.ckey, hours * 60 * 60 * 10)
			else if(type == "round")
				var/rounds = min(text2num(href_list["rounds"]), src.max_rounds)
				if(rounds)
					B = new /datum/ban/round(new_ban_id(), M.ckey, reason, usr.ckey, rounds)
			ban(M.last_known_ckey, M.last_known_ip, M.client, B)
			world << "\red [M.last_known_ckey] has been banned [B.get_duration_desc()] by [usr.ckey]. The reason given for this ban was: [reason]."
			if(M.client)
				del(M.client)
			ss13_browse(usr, null, "window=ban")

	get_desc(mob/M)
		return "<a href='?src=\ref[src];mob=\ref[M]'>Ban</a>"

	proc/new_ban_id()
		// ban IDs have to be strings, and should be sequential. This is a fairly simple way to achieve that.
		// add a random number on the end in case two people get banned within 1/10 second of each other.
		// it's unlikely, but better safe than sorry.
		// note that around 2030 an extra digit will be added, and ban IDs will no longer be completely sequential.
		// if it is 2030 and your bans are all out of order, I'm sorry.
		// on the upside, it'll give you some practice for the year 2038 bug.
		return "[num2text(world.realtime, 10)][world.timeofday][num2text(rand(0, 999))]"
