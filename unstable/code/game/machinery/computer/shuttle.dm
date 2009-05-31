/obj/machinery/computer/shuttle
	name = "Shuttle"
	icon = 'shuttle.dmi'
	icon_state = "shuttlecom"
	var/auth_need = 3.0

	var/list/authorized = list()
	var/leaving = 0

	attackby(obj/item/weapon/card/id/W, mob/user)
		if (!istype(W, /obj/item/weapon/card/id) || shuttle_status != SHUTTLE_DOCKED || !user )
			return
		if (!W.access) //no access
			user << "The access level of [W.registered]\'s card is not high enough. "
			return
		if (leaving)
			user << "The shuttle is already leaving!"
			return
		var/list/cardaccess = W.access
		if(!istype(cardaccess, /list) || !cardaccess.len) //no access
			user << "The access level of [W.registered]\'s card is not high enough. "
			return
		var/choice = alert(user, text("Would you like to (un)authorize a shortened launch time? [] authorization\s are still needed. Use abort to cancel all authorizations.", src.auth_need - src.authorized.len), "Shuttle Launch", "Authorize", "Repeal", "Abort")
		if(leaving)
			return //they might have taken a long time to answer that alert
		switch(choice)
			if("Authorize")
				src.authorized -= W.registered
				src.authorized += W.registered
				if (src.auth_need - src.authorized.len > 0)
					station_announce("<B>Alert: [src.auth_need - src.authorized.len] authorizations needed until shuttle is launched early</B>")
				else
					station_announce("<B>Alert: Shuttle launch time shortened to 10 seconds!</B>")
					shuttle_time_left = 100
					last_shuttle_update = ss13time()
					leaving = 1
			if("Repeal")
				src.authorized -= W.registered
				station_announce("<B>Alert: [src.auth_need - src.authorized.len] authorizations needed until shuttle is launched early</B>")
			if("Abort")
				station_announce("<B>All authorizations to shorting time for shuttle launch have been revoked!</B>")
				src.authorized.len = 0
				src.authorized = list(  )
			else
		return