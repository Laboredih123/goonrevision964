/obj/item/weapon/hand_tele
	name = "hand tele"
	icon_state = "hand_tele"
	s_istate = "electronic"
	w_class = 2.0

	attack_self(mob/carbon/user as mob)
		var/list/L = list(  )
		for(var/obj/machinery/teleport/hub/R in world)
			var/obj/machinery/computer/teleporter/com = locate(/obj/machinery/computer/teleporter, locate(R.x - 2, R.y, R.z))
			if (istype(com, /obj/machinery/computer/teleporter))
				if(R.icon_state == "tele1")
					L["[com.id] (Active)"] = com.locked
				else
					L["[com.id] (Inactive)"] = com.locked
		var/t1 = input(user, "Please select a teleporter to lock in on.", "Hand Teleporter") in L
		if (user.equipped() != src || !user.can_use_hands())
			return
		var/T = L[t1]
		for(var/mob/O in hearers(user))
			O.hear("\blue Locked In")
		var/obj/portal/P = new /obj/portal( get_turf(src) )
		P.target = T
		src.add_fingerprint(user)