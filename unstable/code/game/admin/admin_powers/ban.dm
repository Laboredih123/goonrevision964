/datum/admin_power/ban
	name = "Ban"
	panel_type = PANEL_TYPE_PLAYER

	var/max_hours = 0
	var/can_permaban = 0

	New(adminlevel)
		if(adminlevel == ADMIN_MOD)
			src.max_hours = 3
		else if(adminlevel == ADMIN_ADMIN)
			src.max_hours = 24*7 //1 week
		else if(adminlevel == ADMIN_HOST)
			src.max_hours = INFINITY
			src.can_permaban = 1
		else
			del(src)

	Topic(href, href_list)
		if(href_list["mob"]) //show the window
			var/dat = "<html><head><title>Ban</title></head><body>"
			dat += "<form action='byond://' method='get'>"
			dat += "<input type='hidden' name='src' value='\ref[src]'>"
			dat += "<input type='hidden' name='mob-ban' value='[href_list["mob"]]'>"
			dat += "<input type='radio' name='type' value='round' checked='1'> Round ban<br>"
			dat += "<input type='radio' name='type' value='hours'> Hours: <input type='text' name='hours' value='1'><br>"
			if(src.can_permaban)
				dat += "<input type='radio' name='type' value='permanent'>Permanent<br>"
			dat += "Reason for banning (please be specific)<br>"
			dat += "<textarea name='reason' rows=5></textarea><br>"
			dat += "<input type='submit' value='Submit'>"
			dat += "</form>"
			usr << browse(dat, "window=ban")
		else if(href_list["mob-ban"])
			var/type = href_list["type"]
			var/mob/M = locate(href_list["mob-ban"])
			var/reason = href_list["reason"]
			if(type == "permanent")
				permaban(M, reason)
			else if(type == "hours")
				var/hours = text2num(href_list["hours"])
				if(hours)
					hourban(M, reason, hours)
			else //roundban
				banned += M.last_known_ckey
				M << "You have been banned for the rest of the round."
				M << "The reason given for the ban is:"
				M << reason
				if(M.client)
					del(M.client)

	get_desc(mob/M)
		return "<a href='?src=\ref[src];mob=\ref[M]'>Ban</a>"