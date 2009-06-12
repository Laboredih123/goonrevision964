/datum/admin_power/observer_mode
	name = "Observer Mode"
	panel_type = PANEL_TYPE_GAME

	New(adminlevel)
		return

	Topic(href, href_list)
		if(istype(usr,/mob/observer))
			src << "Exiting observer mode"
			usr.client.mob = usr:corpse
			del(usr)
			return
		usr.client.mob = new/mob/observer(usr)
		usr << "Entering observer mode."
		return ..()

	get_desc()
		if(!istype(usr,/mob/observer))
			return "<a href='?src=\ref[src]'>Observer Mode</a>"
		else
			return "<a href='?src=\ref[src]'>Player Mode</a>"

