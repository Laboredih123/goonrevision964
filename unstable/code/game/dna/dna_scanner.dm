/obj/machinery/dna_scanner
	name = "DNA Scanner/Implanter"
	icon = 'Cryogenic2.dmi'
	icon_state = "scanner_0"
	density = 1
	var/locked = 0
	var/mob/carbon/occupant = null
	anchored = 1

/obj/machinery/dna_scanner/allow_drop()
	return 0

/obj/machinery/dna_scanner/relaymove(mob/user as mob)
	if (!user.is_conscious())
		return
	src.go_out()
	return

/obj/machinery/dna_scanner/verb/eject()
	set src in oview(1)

	if (!usr.is_conscious())
		return
	src.go_out()
	add_fingerprint(usr)
	return

/obj/machinery/dna_scanner/verb/move_inside()
	set src in oview(1)
	if(src.locked)
		return
	if (!usr.is_active())
		return
	if (src.occupant)
		usr << "\blue <B>The scanner is already occupied!</B>"
		return
	if (usr.abiotic())
		usr << "\blue <B>Subject cannot have abiotic items on.</B>"
		return
	usr.pulling = null
	usr.client.perspective = EYE_PERSPECTIVE
	usr.client.eye = src
	usr.loc = src
	src.occupant = usr
	src.icon_state = "scanner_1"
	for(var/obj/O in src)
		del(O)
	src.add_fingerprint(usr)
	return

/obj/machinery/dna_scanner/attackby(obj/item/weapon/grab/G as obj, user as mob)
	if (!istype(G, /obj/item/weapon/grab) || !istype(G.affecting, /mob/carbon))
		return
	if (src.occupant)
		user << "\blue <B>The scanner is already occupied!</B>"
		return
	if (G.affecting.abiotic())
		user << "\blue <B>Subject cannot have abiotic items on.</B>"
		return
	var/mob/M = G.affecting
	if (M.client)
		M.client.perspective = EYE_PERSPECTIVE
		M.client.eye = src
	M.loc = src
	src.occupant = M
	src.icon_state = "scanner_1"
	for(var/obj/O in src)
		O.loc = src.loc
	src.add_fingerprint(user)
	del(G)
	return

/obj/machinery/dna_scanner/proc/go_out()
	if ((!( src.occupant ) || src.locked))
		return
	for(var/obj/O in src)
		O.loc = src.loc
	if (src.occupant.client)
		src.occupant.client.eye = src.occupant.client.mob
		src.occupant.client.perspective = MOB_PERSPECTIVE
	src.occupant.loc = src.loc
	src.occupant = null
	src.icon_state = "scanner_0"
	return

/obj/machinery/dna_scanner/ex_act(severity)

	switch(severity)
		if(1.0)
			for(var/atom/movable/A in src)
				A.loc = src.loc
				A.ex_act(severity)
			del(src)
		if(2.0)
			if (prob(50))
				for(var/atom/movable/A in src)
					A.loc = src.loc
					A.ex_act(severity)
				del(src)
		if(3.0)
			if (prob(25))
				for(var/atom/movable/A in src)
					A.loc = src.loc
					A.ex_act(severity)
				del(src)


/obj/machinery/dna_scanner/blob_act()
	if(prob(50))
		for(var/atom/movable/A as mob|obj in src)
			A.loc = src.loc
		del(src)