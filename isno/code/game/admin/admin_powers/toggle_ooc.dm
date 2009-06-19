/datum/admin_power/toggle_ooc
	panel_type = PANEL_TYPE_GAME
	allowed_for = ADMIN_GM

	Topic(href, href_list)
		ooc_allowed = !( ooc_allowed )
		if (ooc_allowed)
			world << "<B>The OOC channel has been globally enabled!</B>"
		else
			world << "<B>The OOC channel has been globally disabled!</B>"
		world.log_admin("[usr.key] toggled OOC.")
		return ..()

	get_desc()
		if(ooc_allowed)
			return "<a href='?src=\ref[src]'>Disable OOC</a>"
		else
			return "<a href='?src=\ref[src]'>Enable OOC</a>"
