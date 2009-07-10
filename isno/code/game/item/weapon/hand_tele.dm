/obj/item/weapon/hand_tele
	name = "hand tele"
	icon_state = "hand_tele"
	s_istate = "electronic"
	w_class = 2.0

	attack_self(mob/user as mob)
		var/list/L = list(  )
		for(var/obj/machinery/teleport/hub/R in world)
			var/obj/machinery/computer/teleporter/com = locate(/obj/machinery/computer/teleporter, locate(R.x - 2, R.y, R.z))
			if (istype(com, /obj/machinery/computer/teleporter) && com.locked)
				if(R.icon_state == "tele1")
					L["[com.id] (Active)"] = com.locked
				else
					L["[com.id] (Inactive)"] = com.locked
		var/list/turfs = list(	)
		for(var/turf/T in orange(10))
			if(T.x>world.maxx-4 || T.x<4)	continue	//putting them at the edge is dumb
			if(T.y>world.maxy-4 || T.y<4)	continue
			turfs += T
		if(turfs)
			L["None (Dangerous)"] = pick(turfs)
		var/t1 = input(user, "Please select a teleporter to lock in on.", "Hand Teleporter") in L
		if (user.equipped() != src || !user.can_use_hands())
			return
		var/count = 0	//num of portals from this teleport in world
		for(var/obj/portal/PO in world)
			if(PO.creator == src)
				count++
		if(count >= 3)
			user.see("\red The hand teleporter is recharging!")
			return
		var/T = L[t1]
		user.show_viewers("\blue Locked In")
		var/obj/portal/P = new /obj/portal( get_turf(src) )
		P.target = T
		P.creator = src
		src.add_fingerprint(user)