/obj/machinery/sleeper/verb/enter_sleeper()
	set src in oview(1)
	if(!usr.can_use_hands())	return
	if(stat & (BROKEN|NOPOWER))	return
	if(src.occupant)
		usr << "<font color='blue'><B>The cell is already occupied!</B></font>"
		return
	if(usr.abiotic())
		usr << "Subject may not have abiotic items on."
		return
	src.add_fingerprint(usr)
	usr.pulling = null
	add_occupant(usr)
	return

/obj/machinery/sleeper/verb/empty_sleeper()
	set src in oview(1)
	if(!usr.can_use_hands()) return
	if(!src.occupant)
		usr << "<font color='blue'>There is no one inside!</font>"
		return
	add_fingerprint(usr)
	src.eject_occupant()

/obj/machinery/sleeper/proc/add_occupant(var/mob/carbon/user)
	if(stat & (BROKEN|NOPOWER))	return 0
	if(user.abiotic())	return 0
	if(src.occupant)	return 0

	if(user.client)
		user.client.eye = src
		user.client.perspective = EYE_PERSPECTIVE

	for(var/obj/O in src)	O.loc = src.loc
	src.icon_state = "sleeper_1"
	src.occupant = user
	occupant.loc = src
	return 1

/obj/machinery/sleeper/proc/eject_occupant()
	if(!src.occupant)		return 0
	for(var/obj/O in src)	O.loc = src.loc

	if(src.occupant.client)
		src.occupant.client.eye = src.occupant.client.mob
		src.occupant.client.perspective = MOB_PERSPECTIVE
	src.add_fingerprint(src.occupant)
	src.occupant.loc = src.loc
	src.icon_state = "sleeper_0"
	src.occupant = null
	return 1

/obj/machinery/sleeper/allow_drop()		{	return 0				}
/obj/machinery/sleeper/process()		{	src.updateDialog()		}

/obj/machinery/sleeper/ex_act(severity)
	if(severity == 2 && prob(50)) return
	if(severity != 1 && severity != 2) return
	for(var/atom/movable/A as mob|obj in src)
		A.loc = src.loc
		ex_act(severity)
	del(src)

/obj/machinery/sleeper/blob_act()
	for(var/atom/movable/A as mob|obj in src)
		A.loc = src.loc
	del(src)

/obj/machinery/sleeper/attackby(obj/item/weapon/grab/G as obj, mob/user as mob)
	if(stat & (BROKEN|NOPOWER))				return
	if(!istype(G, /obj/item/weapon/grab))	return
	if(!ismob(G.affecting))					return
	if(G.affecting.abiotic())
		user << "Subject may not have abiotic items on."
		return
	if(src.occupant)
		user << "<font color='blue'><B>The cell is already occupied!</B></font>"
		return
	src.add_occupant(G.affecting)
	src.add_fingerprint(user)
	del(G)

/obj/machinery/sleeper/proc/inject(mob/carbon/user)
	if(!src.occupant)
		user << "<font color='blue'>There is no one inside!</font>"
		return
	src.occupant.rejuv = max(src.occupant.rejuv,60)
	user << text("Occupant now has [] units of rejuvenation in \his bloodstream.", src.occupant.rejuv)

/obj/machinery/sleeper/ex_act(severity)
	switch(severity)
		if(2) if(!prob(50)) return
		if(3) if(!prob(25)) return
	for(var/atom/movable/A as mob|obj in src)
		A.loc = src.loc
		ex_act(severity)
	del(src)

/obj/machinery/sleeper/alter_health(mob/carbon/M as mob)
	if(M.get_damage() < M.unconsciousness_threshold)
		M.heal_damage(suffocation = 1)
	M.knockout_until(2)
