/obj/item/weapon/prox_sensor
	name = "Proximity Sensor"
	icon_state = "motion0"
	var/state = 0.0
	flags = FPRINT|TABLEPASS|SENDSRSIGNAL
	w_class = 2.0
	s_istate = "prox"

/obj/item/weapon/prox_sensor/dropped()

	spawn( 0 )
		src.sense()
		return
	return

/obj/item/weapon/prox_sensor/proc/sense()

	if (src.state)
		for(var/mob/O in hearers(null, src))
			O.hear(text("\icon[] *beep* *beep*", src))
	return

/obj/item/weapon/prox_sensor/HasProximity(atom/movable/AM as mob|obj)

	if (istype(AM, /obj/beam))
		return
	if (AM.move_speed < 12)

		src.sense()
	return

/obj/item/weapon/prox_sensor/attack_self(mob/user as mob)

	user.machine = src
	var/dat = text("<TT><B>Proximity Sensor</B>\n<B>Status</B>: []<BR>\n[]\n</TT>", (src.state ? text("<A href='?src=\ref[];state=0'>On</A>", src) : text("<A href='?src=\ref[];state=1'>Off</A>", src)), (src.state ? "<b>\red Time On (30)</b>" : text("<A href='?src=\ref[];time=1'>Time On (30)</A>", src)))
	ss13_browse(user, dat, "window=prox")
	return




/obj/item/weapon/prox_sensor/Topic(href, href_list)
	..()
	if (!usr.can_use_hands())
		return
	if ((usr.contents.Find(src) || get_dist(src, usr) <= 1 && istype(src.loc, /turf)))
		usr.machine = src
		if (href_list["state"])
			src.state = !( src.state )
			src.icon_state = text("motion[]", src.state)
		if (href_list["time"])
			src.icon_state = "motion2"

			spawn( 300 )
				if (src.state == 0)
					src.state = !( src.state )
					src.icon_state = text("motion[]", src.state)
				return
		if (istype(src.loc, /mob))
			attack_self(src.loc)
		else
			for(var/mob/M in viewers(1, src))
				if (M.client)
					src.attack_self(M)
	else
		ss13_browse(usr, null, "window=prox")
		return
	return

/obj/item/weapon/prox_sensor/Move()

	..()
	src.sense()
	return