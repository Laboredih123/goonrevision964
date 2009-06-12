/obj/machinery/computer/shuttle
	name = "Shuttle"
	icon = 'shuttle.dmi'
	icon_state = "shuttlecom"

	var/list/authorized = list()
	var/leaving = 0

	var/datum/shuttle/shuttle = null

	New()
		var/area/A = get_area(src)
		shuttle = shuttles_by_area_type[A.type]

	attackby(obj/item/weapon/card/id/W, mob/user)
		if (!istype(W, /obj/item/weapon/card/id) || shuttle.status != shuttle.STATE_DOCKED || !user )
			return
		if (!W.access) //no access
			user << "The access level of [W.registered]\'s card is not high enough. "
			return
		if(W.assignment == "Death Commando")
			user << "Why on earth would you want the shuttle to leave? You're just getting started!"
			return
		if (leaving)
			user << "The shuttle is already leaving!"
			return
		var/list/cardaccess = W.access
		if(!istype(cardaccess, /list) || !cardaccess.len) //no access
			user << "The access level of [W.registered]\'s card is not high enough. "
			return
		var/txt = "Would you like to (un)authorize a shortened launch time? [shuttle.auth_need - src.authorized.len] authorization\s are still needed. Use abort to cancel all authorizations."
		var/choice = alert(user, txt, "Shuttle Launch", "Authorize", "Repeal", "Abort")
		if(leaving)
			return //they might have taken a long time to answer that alert
		switch(choice)
			if("Authorize")
				src.authorized -= W.registered
				src.authorized += W.registered
				if (shuttle.auth_need - src.authorized.len > 0)
					station_announce("<B>Alert: [shuttle.auth_need - src.authorized.len] authorizations needed until shuttle is launched early</B>")
				else
					shuttle.speed_up()
					leaving = 1
			if("Repeal")
				src.authorized -= W.registered
				station_announce("<B>Alert: [shuttle.auth_need - src.authorized.len] authorizations needed until shuttle is launched early</B>")
			if("Abort")
				station_announce("<B>All authorizations to shorting time for shuttle launch have been revoked!</B>")
				src.authorized.len = 0
				src.authorized = list(  )
			else
		return