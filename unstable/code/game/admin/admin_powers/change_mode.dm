//TODO: auto-generate

/datum/admin_power/change_mode
	panel_type = PANEL_TYPE_GAME

	New(adminlevel)
		return

	Topic(href, href_list)
		..()
		if(href_list["c_mode"])
			master_mode = href_list["c_mode"]
			world.log_admin("[usr.key] set the mode as [master_mode].")
			if(!game_started)
				world << "\blue <B>The mode is now: [master_mode]</B>"
			else
				world << "\blue <B>The mode next round will be: [master_mode]</B>"

			set_default_mode(master_mode)
		var/dat = "<B>What mode do you wish to play?</B><HR>"
		dat += "<A href='?src=\ref[src];c_mode=secret'>Secret</A><br>"
		dat += "<A href='?src=\ref[src];c_mode=random'>Random</A><br>"
		dat += "<A href='?src=\ref[src];c_mode=traitor'>Traitor</A><br>"
		dat += "<A href='?src=\ref[src];c_mode=meteor'>Meteor</A><br>"
		dat += "<A href='?src=\ref[src];c_mode=freeform'>Freeform</A><br>"
		dat += "<A href='?src=\ref[src];c_mode=blob'>Blob</A><br>"
		dat += "<A href='?src=\ref[src];c_mode=spyvsspy'>Spy Vs Spy</A><br>"
		dat += "Now: [master_mode]"
		ss13_browse(usr, dat, "window=c_mode")

	get_desc()
		return "<a href='?src=\ref[src];action=list'>Change mode</a>"
