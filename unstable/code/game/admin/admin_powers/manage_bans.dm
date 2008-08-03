/datum/admin_power/manage_bans
	panel_type = PANEL_TYPE_GAME

	New(adminlevel)
		return

	Topic(href, href_list)
		if(href_list["action"] == "list")
			var/dat = "<table><tr><th>Key</th><th>Permanent?</th><th>Ends in:</th><th>Remove</th></tr>"
			var/list/L = flist("bans/")
			for(var/filename in L)
				var/list/bans = get_bans("bans/[filename]")
				if(!bans)
					continue
				var/list/filename_parts = dd_text2list(filename, "/")
				var/ckey = dd_replacetext(filename_parts[filename_parts.len], ".ban", "") //last part of it, minus .ban
				for(var/i = 1; i <= bans.len; i++)
					var/datum/ban/B = bans[i]
					dat += "<tr>"
					dat += "<td>[ckey]</td>"
					dat += "<td>[B.is_permanent ? "Yes" : "No"]</td>"
					dat += "<td>[max(round((B.expire_time - world.realtime) / 36000),0)]:[max(round(((B.expire_time - world.realtime) % 36000) / 600),0)]</td>"
					dat += "<td><a href='?src=\ref[src];bannum=[i];ckey=[ckey]'>Remove</a></td>"
					dat += "</tr>"
			dat += "</table>"
			ss13_browse(usr, dat, "window=banpanel")
		else if(href_list["bannum"] && href_list["ckey"])
			var/bannum = text2num(href_list["bannum"])
			var/ckey = href_list["ckey"]
			var/list/bans = load_bans("bans/[ckey].ban")
			if(!bans || !bans[bannum])
				return
			bans -= bans[bannum]
			write_bans("bans/[ckey].ban", bans)

	get_desc()
		return "<a href='?src=\ref[src];action=list'>Manage bans</a>"
