/datum/admin_power/manage_bans
	panel_type = PANEL_TYPE_GAME

	New(adminlevel)
		return

	Topic(href, href_list)
		if(href_list["action"] == "list")
			var/dat = "<table border=1><tr><th>Key</th><th>Lasts</th><th>Banned by</th><th>Remove</th></tr>"
			var/savefile/bans_by_id = new(BANFILE_LOC)
			for(var/banid in bans_by_id)
				var/datum/ban/B = bans_by_id[banid]
				if(B.is_banned())
					dat += "<tr>"
					dat += "<td>[B.origckey]</td>"
					dat += "<td>[B.get_duration_desc()]</td>"
					dat += "<td>[B.adminckey]</td>"
					dat += "<td><a href='?src=\ref[src];banid=[banid]'>Remove</a></td>"
					dat += "</tr>"
			dat += "</table>"
			ss13_browse(usr, dat, "window=banpanel;size=600x400")
		else if(href_list["banid"])
			var/banid = text2num(href_list["banid"])
			var/savefile/F = new(BANFILE_LOC)
			F.dir -= banid
			ss13_browse(usr, null, "window=banpanel")

	get_desc()
		return "<a href='?src=\ref[src];action=list'>Manage bans</a>"
