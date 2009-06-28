/var/list/frozen_ckeys = list()

/datum/admin_power/freeze
	name = "Freeze"
	panel_type = PANEL_TYPE_PLAYER
	allowed_for = ADMIN_GM

	get_desc(mob/M)
		if(M.client)
			return "<A href='?src=\ref[usr];freeze=\ref[M]'>[M.client.frozen ? "Unfreeze" : "Freeze"]</A>"

/client/proc/toggle_frozen(mob/M in world)
	if(!M.client)
		var/change = "froze"
		if(M.last_known_ckey in frozen_ckeys)
			frozen_ckeys -= M.last_known_ckey
			change = "unfroze"
		else
			frozen_ckeys += M.last_known_ckey
		usr << "You [change] [M]"
		world.log_admin("[usr] ([usr.ckey]) [change] [M] ([M.last_known_ckey])")
		return
	var/change = M.client.frozen ? "unfroze" : "froze"
	if(M.client.frozen)
		M.client.frozen = 0
		frozen_ckeys -= M.ckey
	else
		M.client.frozen = 1
		frozen_ckeys += M.ckey
	M << "[usr] [change] you."
	usr << "You [change] [M]"
	world.log_admin("[usr] ([usr.ckey]) [change] [M] ([M.ckey])")

/client/New()
	if(src.ckey in frozen_ckeys)
		src.frozen = 1
	return ..()