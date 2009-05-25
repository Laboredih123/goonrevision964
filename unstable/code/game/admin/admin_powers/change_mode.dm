/datum/admin_power/change_mode
	panel_type = PANEL_TYPE_GAME

	New(adminlevel)
		return

	Topic(href, href_list)
		if(href_list["action"] == "list")
			if (!game_started)
				var/dat = "<B>What mode do you wish to play?</B><HR>"
				dat += "<A href='?src=\ref[src];c_mode=secret'>Secret</A><br>"
				dat += "<A href='?src=\ref[src];c_mode=random'>Random</A><br>"
				dat += "<A href='?src=\ref[src];c_mode=traitor'>Traitor</A><br>"
				dat += "<A href='?src=\ref[src];c_mode=meteor'>Meteor</A><br>"
				dat += "<A href='?src=\ref[src];c_mode=freeform'>Freeform</A><br>"
				dat += "<A href='?src=\ref[src];c_mode=blob'>Blob</A><br>"
				dat += "Now: [master_mode]"
				ss13_browse(usr, dat, "window=c_mode")
		else if(href_list["c_mode"])
			if(!game_started)
				switch(href_list["c_mode"])
					if("secret")
						master_mode = "secret"
					if("random")
						master_mode = "random"
					if("traitor")
						master_mode = "traitor"
					if("meteor")
						master_mode = "meteor"
					if("freeform")
						master_mode = "freeform"
					if("blob")
						master_mode = "blob"
				world.log_admin("[usr.key] set the mode as [master_mode].")
				world << text("\blue <B>The mode is now: []</B>", master_mode)

				var/F = file(persistent_file)
				fdel(F)
				F << master_mode


	get_desc()
		if(game_started)
			return "<a href='?src=\ref[src];action=list'>Change mode</a>"
		else
			return null
