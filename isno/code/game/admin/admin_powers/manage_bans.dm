/datum/admin_power/manage_bans
	panel_type = PANEL_TYPE_GAME
	allowed_for = ADMIN_MOD | ADMIN_ADMIN | ADMIN_SUPERADMIN

	Topic(href, href_list)
		if(href_list["banid"])
			var/banid = href_list["banid"]
			var/savefile/bans_by_id = new(BANFILE_LOC)
			var/datum/ban/B = bans_by_id[banid]
			world.log_admin("[usr.key] removed ban [banid] on [B.origckey]. It was originally a ban [B.get_banclass_desc()] [B.get_duration_desc()] by [B.adminckey]. The original reason was: [B.reason].")
			bans_by_id.dir -= banid

		var/dat = "<table border=1><tr><th>Key</th><th>Type</th><th>Lasts</th><th>Banned by</th><th>Banned at</th><th>Reason</th><th>Remove</th></tr>"
		var/savefile/bans_by_id = new(BANFILE_LOC)
		for(var/banid in bans_by_id)
			var/datum/ban/B = bans_by_id[banid]
			if(B.still_applicable())
				dat += "<tr>"
				dat += "<td>[B.origckey]</td>"
				dat += "<td>[B.get_banclass_desc()]</td>"
				dat += "<td>[B.get_duration_desc()]</td>"
				dat += "<td>[B.adminckey]</td>"
				dat += "<td>[time2text(B.bantime, "YYYY-MM-DD hh:mm ")]</td>"
				dat += "<td>[B.reason]</td>"
				dat += "<td><a href='?src=\ref[src];banid=[banid]'>Remove</a></td>"
				dat += "</tr>"
		dat += "</table>"
		ss13_browse(usr, dat, "window=banpanel;size=800x600")

	get_desc()
		return "<a href='?src=\ref[src];action=list'>Manage bans</a>"
