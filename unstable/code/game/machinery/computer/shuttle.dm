/obj/machinery/computer/shuttle
	name = "Shuttle"
	icon = 'shuttle.dmi'
	icon_state = "shuttlecom"
	var/auth_need = 3.0

	var/list/authorized = list()

	attackby(obj/item/weapon/card/id/W, mob/user)
		if (!istype(W, /obj/item/weapon/card/id) || shuttle_loc == SHUTTLE_Z || !user )
			return
		if (!W.access) //no access
			user << "The access level of [W.registered]\'s card is not high enough. "
			return
		var/list/cardaccess = W.access
		if(!istype(cardaccess, /list) || !cardaccess.len) //no access
			user << "The access level of [W.registered]\'s card is not high enough. "
			return
		var/choice = alert(user, text("Would you like to (un)authorize a shortened launch time? [] authorization\s are still needed. Use abort to cancel all authorizations.", src.auth_need - src.authorized.len), "Shuttle Launch", "Authorize", "Repeal", "Abort")
		switch(choice)
			if("Authorize")
				src.authorized -= W.registered
				src.authorized += W.registered
				if (src.auth_need - src.authorized.len > 0)
					world << text("\blue <B>Alert: [] authorizations needed until shuttle is launched early</B>", src.auth_need - src.authorized.len)
				else
					world << "\blue <B>Alert: Shuttle launch time shortened to 10 seconds!</B>"
					ticker.timeleft = 100

					del(src.authorized)
					src.authorized = list(  )
			if("Repeal")
				src.authorized -= W.registered
				world << text("\blue <B>Alert: [] authorizations needed until shuttle is launched early</B>", src.auth_need - src.authorized.len)
			if("Abort")
				world << "\blue <B>All authorizations to shorting time for shuttle launch have been revoked!</B>"
				src.authorized.len = 0
				src.authorized = list(  )
			else
		return