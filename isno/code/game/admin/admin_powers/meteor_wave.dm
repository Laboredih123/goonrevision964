/datum/admin_power/meteor_wave
	panel_type = PANEL_TYPE_GAME
	allowed_for = ADMIN_GM

	Topic(href, href_list)
		world.log_admin("[usr.key] spawned a meteor wave.")
		meteor_wave()
		return ..()

	get_desc()
		return "<a href='?src=\ref[src]'>Meteor wave</a>"
