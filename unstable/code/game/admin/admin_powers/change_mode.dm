/datum/admin_power/change_mode
	panel_type = PANEL_TYPE_GAME

	New(adminlevel)
		return

	Topic(href, href_list)
		if(href_list["action"] == "list")
			if (!ticker)
				var/dat = "<B>What mode do you wish to play?</B><HR>"
				dat += "<A href='?src=\ref[src];c_mode=secret'>Secret</A><br>"
				dat += "<A href='?src=\ref[src];c_mode=random'>Random</A><br>"
				dat += "<A href='?src=\ref[src];c_modetraitor'>Traitor</A><br>"
				dat += "<A href='?src=\ref[src];c_mode=meteor'>Meteor</A><br>"
				dat += "<A href='?src=\ref[src];c_mode=extended'>Extended</A><br>"
				dat += "<A href='?src=\ref[src];c_mode=monkey'>Monkey</A><br>"
				dat += "<A href='?src=\ref[src];c_mode=nuclear'>Nuke</A><br>"
				dat += "<A href='?src=\ref[src];c_mode=blob'>Blob</A><br>"
				dat += "<A href='?src=\ref[src];c_mode=sandbox'>Sandbox</A><br>"
				dat += "Now: [master_mode]"
				usr << browse(dat, "window=c_mode")
		else if(href_list["c_mode"])
			if(!ticker)
				switch(href_list["c_mode"])
					if("secret")
						master_mode = "secret"
					if("random")
						master_mode = "random"
					if("traitor")
						master_mode = "traitor"
					if("meteor")
						master_mode = "meteor"
					if("extended")
						master_mode = "extended"
					if("monkey")
						master_mode = "monkey"
					if("nuclear")
						master_mode = "nuclear"
					if("megamonkey")
						master_mode = "megamonkey"
					if("blob")
						master_mode = "blob"
					if("sandbox")
						master_mode = "sandbox"
					else
				world.log_admin("[usr.key] set the mode as [master_mode].")
				world << text("\blue <B>The mode is now: []</B>", master_mode)

				var/F = file(persistent_file)
				fdel(F)
				F << master_mode


	get_desc()
		if(ticker)
			return "<a href='?src=\ref[src];action=list'>Change mode</a>"
		else
			return null