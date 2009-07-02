obj/machinery/door_control/attackby(obj/item/weapon/W, mob/user as mob)
	if(istype(W, /obj/item/weapon/f_print_scanner))
		return
	return src.interact(user)

obj/machinery/door_control/interact(mob/user as mob)
	if(stat & (BROKEN|NOPOWER)) return
	use_power(5)
	icon_state = "doorctrl1"

	for(var/obj/machinery/door/M in machines)
		if(M.id != src.id) continue
		if(M.density)
			spawn(0)
				M.do_open()
		else
			spawn(0)
				M.do_close()

	spawn(15)
		if(!(stat & NOPOWER))
			icon_state = "doorctrl0"
	src.add_fingerprint(usr)

/obj/machinery/door_control/power_change()
	..()
	if(stat & NOPOWER)
		icon_state = "doorctrl-p"
	else
		icon_state = "doorctrl0"

/obj/machinery/sec_lock/interact(var/mob/user as mob)

	if(stat & NOPOWER)
		return
	use_power(10)

	if (src.loc == user.loc)
		var/dat = text("<B>Security Pad:</B><BR>\nKeycard: []<BR>\n<A href='?src=\ref[];door1=1'>Toggle Outer Door</A><BR>\n<A href='?src=\ref[];door2=1'>Toggle Inner Door</A><BR>\n<BR>\n<A href='?src=\ref[];em_cl=1'>Emergency Close</A><BR>\n<A href='?src=\ref[];em_op=1'>Emergency Open</A><BR>", (src.scan ? text("<A href='?src=\ref[];card=1'>[]</A>", src, src.scan.name) : text("<A href='?src=\ref[];card=1'>-----</A>", src)), src, src, src, src)
		ss13_browse(user, dat, "window=sec_lock")
	return

/obj/machinery/sec_lock/attackby(nothing, user as mob)
	return src.interact(user)


/obj/machinery/sec_lock/New()

	..()
	spawn( 2 )
		if (src.a_type == 1)
			src.d2 = locate(/obj/machinery/door, locate(src.x - 2, src.y - 1, src.z))
			src.d1 = locate(/obj/machinery/door, get_step(src, SOUTHWEST))
		else
			if (src.a_type == 2)
				src.d2 = locate(/obj/machinery/door, locate(src.x - 2, src.y + 1, src.z))
				src.d1 = locate(/obj/machinery/door, get_step(src, NORTHWEST))
			else
				src.d1 = locate(/obj/machinery/door, get_step(src, SOUTH))
				src.d2 = locate(/obj/machinery/door, get_step(src, SOUTHEAST))
		return
	return

/obj/machinery/sec_lock/Topic(href, href_list)
	..()


	if (!usr.check_intelligence())
		return
	if ((!usr.can_use_hands()))
		return
	if ((!( src.d1 ) || !( src.d2 )))
		usr << "\red Error: Cannot interface with door security!"
		return
	if ((usr.contents.Find(src) || (get_dist(src, usr) <= 1 && istype(src.loc, /turf)) || (istype(usr, /mob/silicon/ai))))
		usr.machine = src
		if (href_list["card"])
			if (src.scan)
				src.scan.loc = src.loc
				src.scan = null
			else
				if(istype(usr, /mob/carbon))
					var/mob/carbon/M = usr
					var/obj/item/weapon/card/id/I = M.equipped()
					if (istype(I, /obj/item/weapon/card/id))
						M.drop_item()
						I.loc = src
						src.scan = I
		if (href_list["door1"])
			if (src.scan)
				if (src.check_access(src.scan))
					if (src.d1.density)
						spawn( 0 )
							src.d1.try_open()
							return
					else
						spawn( 0 )
							src.d1.try_close()
							return
		if (href_list["door2"])
			if (src.scan)
				if (src.check_access(src.scan))
					if (src.d2.density)
						spawn( 0 )
							src.d2.try_open()
							return
					else
						spawn( 0 )
							src.d2.try_close()
							return
		if (href_list["em_cl"])
			if (src.scan)
				if (src.check_access(src.scan))
					if (!( src.d1.density ))
						src.d1.try_close()
						return
					sleep(1)
					spawn( 0 )
						if (!( src.d2.density ))
							src.d2.try_close()
						return
		if (href_list["em_op"])
			if (src.scan)
				if (src.check_access(src.scan))
					spawn( 0 )
						if (src.d1.density)
							src.d1.try_open()
						return
					sleep(1)
					spawn( 0 )
						if (src.d2.density)
							src.d2.try_open()
						return
		src.add_fingerprint(usr)
		src.updateUsrDialog()

			//Foreach goto(737)
	return

/obj/machinery/alarm/process()
	if(stat & (NOPOWER|BROKEN))
		icon_state = "alarm-p"
		return

	var/turf/T = src.loc
	var/area/A = T.loc

	use_power(5, ENVIRON)

	var/safe = 2

	if(!isturf(T))	return

	var/turf_total = max(T.gas.total(), 1)
	var/pressure = turf_total / CELLSTANDARD // pressure in bar
	var/ppOxygen = T.gas.oxygen / turf_total
	var/ppPlasma = T.gas.plasma / turf_total
	var/ppCarbon = T.gas.co2 / turf_total

	if(0.90 > pressure || pressure > 1.10)		safe = 0
	else if(0.19 > ppOxygen || ppOxygen > 0.23)	safe = 0
	else if(ppPlasma > 0.05)					safe = 0
	else if(ppCarbon > 0.05)					safe = 0

	A.atmosalert(safe, src)
	if(!safe)	src.icon_state = "alarm:1"
	else		src.icon_state = "alarm:0"

/obj/machinery/alarm/attackby(W as obj, user as mob)
	if (istype(W, /obj/item/weapon/wirecutters))
		stat ^= BROKEN
		for(var/mob/O in viewers(null, user))
			O.see(text("\red [] has []activated []!", user, (stat&BROKEN) ? "de" : "re", src))
		return
	return ..()

/obj/machinery/alarm/power_change()
	if( powered(ENVIRON) )
		stat &= ~NOPOWER
	else
		stat |= NOPOWER


/obj/machinery/alarm/examine()
	set src in oview(1)

	if (!usr.is_conscious() || stat & NOPOWER)
		return
	if (!usr.check_dexterity())
		return
	var/turf/T = src.loc
	if (!( istype(T, /turf) ))
		return

	var/turf_total = max(T.gas.total(), 1) / 100
	usr.see("\blue <B>Results:</B>")
	var/t = ""

	var/t1 = turf_total / CELLSTANDARD * 10000
	t += text("\blue Air Pressure [(!InRange(t1,90,110)) ? "\red" : ""] [t1]% ")

	t1 = round(T.gas.nitrogen / turf_total,0.0010)
	t += text("\blue Nitrogen [(!InRange(t1,60,80)) ? "\red" : ""] [t1]% ")

	t1 = round(T.gas.oxygen / turf_total, 0.0010)
	t += text("\blue Oxygen [(!InRange(t1,20,24)) ? "\red" : ""] [t1]% ")

	t1 = round(T.gas.plasma / turf_total, 0.0010)
	t += text("\blue Plasma [(!InRange(t1,0,0.5)) ? "\red" : ""] [t1]% ")

	t1 = round(T.gas.co2 / turf_total, 0.0010)
	t += text("\blue CO2 [(!InRange(t1,0,1)) ? "\red" : ""] [t1]% ")

	t1 = round(T.gas.no2 / turf_total, 0.0010)
	t += text("\blue NO2 [(!InRange(t1,0,5)) ? "\red" : ""] [t1]% ")

	usr.see(t, 1)
	usr.see(text("\blue \t Temperature: []&deg;C", T.gas.temp - T0C))
	src.add_fingerprint(usr)
	return