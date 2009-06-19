/datum/admin_power/observer_mode
	name = "Observer Mode"
	panel_type = PANEL_TYPE_GAME
	allowed_for = ADMIN_ALL

	Topic(href, href_list)
		if(istype(usr,/mob/observer))
			src << "Exiting observer mode"
			usr.client.mob = usr:corpse
			del(usr)
			world.log_admin("[usr.key] left observer mode.")
		else
			usr.client.mob = new/mob/observer(usr)
			usr << "Entering observer mode."
			world.log_admin("[usr.key] entered observer mode.")
		return ..()

	get_desc()
		if(!istype(usr,/mob/observer))
			return "<a href='?src=\ref[src]'>Observer Mode</a>"
		else
			return "<a href='?src=\ref[src]'>Player Mode</a>"

