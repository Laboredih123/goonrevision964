/obj/item/weapon/prox_sensor
	name = "Proximity Sensor"
	icon_state = "motion0"
	var/state = 0.0
	flags = FPRINT|TABLEPASS|SENDSRSIGNAL
	w_class = 2.0
	s_istate = "prox"
	is_signaller = 1
	assembly_name = "proximity"

/obj/item/weapon/prox_sensor/dropped()
	spawn( 0 )
		src.sense()

/obj/item/weapon/prox_sensor/proc/sense()
	if (src.state)
		if(istype(src.loc, /obj/item/weapon/assembly))
			var/obj/item/weapon/assembly/A = src.loc
			A.signal()
		for(var/mob/O in hearers(get_turf(src)))
			O.hear(text("\icon[] *beep* *beep*", src))

/obj/item/weapon/prox_sensor/HasProximity(atom/movable/AM as mob|obj) // TODO: redo in non-retarded way

	if (istype(AM, /obj/beam))
		return
	if (AM.move_speed < 12)
		src.sense()

/obj/item/weapon/prox_sensor/attack_self(mob/user as mob)
	user.machine = src
	var/dat = text("<TT><B>Proximity Sensor</B>\n<B>Status</B>: []<BR>\n[]\n</TT>", (src.state ? text("<A href='?src=\ref[];state=0'>On</A>", src) : text("<A href='?src=\ref[];state=1'>Off</A>", src)), (src.state ? "<b>\red Time On (30)</b>" : text("<A href='?src=\ref[];time=1'>Time On (30)</A>", src)))
	ss13_browse(user, dat, "window=prox")

/obj/item/weapon/prox_sensor/Topic(href, href_list)
	..()
	if (!usr.can_use_hands())
		return
	if ((usr.contents.Find(src) || (usr.contents.Find(src.loc) && istype(src.loc, /obj/item/weapon/assembly)) || get_dist(src, usr) <= 1 && istype(src.loc, /turf)))
		usr.machine = src
		if (href_list["state"])
			src.state = !( src.state )
			src.c_state(src.state)
		if (href_list["time"])
			src.c_state(2)

			spawn( 300 )
				if (src.state == 0)
					src.state = !( src.state )
					src.c_state(src.state)
				return
		if (istype(src.loc, /mob))
			attack_self(src.loc)
		else if(istype(src.loc, /obj/item/weapon/assembly) && istype(src.loc.loc, /mob))
			attack_self(src.loc.loc)
		else
			for(var/mob/M in viewers(1, src))
				if (M.client)
					src.attack_self(M)
	else
		ss13_browse(usr, null, "window=prox")

/obj/item/weapon/prox_sensor/Move()
	..()
	src.sense()

/obj/item/weapon/prox_sensor/proc/c_state(n)
	icon_state = "motion[n]"
	if(istype(src.loc, /obj/item/weapon/assembly))
		var/obj/item/weapon/assembly/A = src.loc
		if(n)
			A.c_state(n)
		else
			A.c_state("")