/datum/admin_power/ai_laws
	panel_type = PANEL_TYPE_GAME
	allowed_for = ADMIN_GM

	Topic(href, href_list)
		world.log_admin("[usr.key] viewed the AI laws.")
		var/dat = "<html><head><title>AI Laws</title><body>"
		for(var/mob/silicon/ai/A in world)
			dat += "<h3>[A.name]</h3>[A.laws_to_text()]"
		ss13_browse(usr, dat, "window=ailaws")
		return ..()

	get_desc()
		for(var/mob/silicon/ai/A in world)
			return "<a href='?src=\ref[src]'>Show AI laws</a>"
		return null
