/datum/admin_power/custom_ban
	name = "Custom Ban"
	panel_type = PANEL_TYPE_GAME
	allowed_for = ADMIN_MOD | ADMIN_ADMIN | ADMIN_SUPERADMIN

	Topic(href, href_list)
		..()
		if(href_list["custom-ban"]) //show the window
			var/dat = "<html><head><title>Custom Ban</title></head><body>"
			dat += "<form action='byond://' method='get'>"
			dat += "<input type='hidden' name='src' value='\ref[src]'>"
			dat += "Key of user to ban: <input type='text' name='key'><br><br>"
			dat += "<input type='radio' name='type' value='round' checked='1'> Rounds: <input type='text' name='rounds' value='1'><br>"
			dat += "<input type='radio' name='type' value='hours'> Hours: <input type='text' name='hours' value='1'><br>"
			if(can_permaban(usr.client.adminlevel))
				dat += "<input type='radio' name='type' value='permanent'>Permanent<br>"
			dat += "Reason for banning (please be specific)<br>"
			dat += "<textarea name='reason' rows=5></textarea><br>"
			dat += "<input type='submit' value='Submit'>"
			dat += "</form>"
			ss13_browse(usr, dat, "window=ban")
		else if(href_list["key"])
			var/ckey = ckey(href_list["key"])
			if(!ckey)
				ss13_browse(usr, null, "window=ban")
				return
			var/type = href_list["type"]
			var/reason = href_list["reason"]
			var/datum/ban/B
			if(type == "permanent" && can_permaban(usr.client.adminlevel))
				B = new /datum/ban/perma(new_ban_id(), ckey, reason, usr.ckey)
			else if(type == "hours")
				var/hours = min(text2num(href_list["hours"]), get_max_hours(usr.client.adminlevel))
				if(hours) // must convert to 1/10 sec
					B = new /datum/ban/time(new_ban_id(), ckey, reason, usr.ckey, hours * 60 * 60 * 10)
			else if(type == "round")
				var/rounds = min(text2num(href_list["rounds"]), get_max_rounds(usr.client.adminlevel))
				if(rounds)
					B = new /datum/ban/round(new_ban_id(), ckey, reason, usr.ckey, rounds)
			ban(ckey, null, null, null, B)
			world.log_admin("[ckey] has been custom banned [B.get_duration_desc()] by [usr.ckey]. The reason given for this ban was: [reason].")
			ss13_browse(usr, null, "window=ban")

	get_desc()
		return "<a href='?src=\ref[src];custom-ban=1'>Custom Ban</a>"