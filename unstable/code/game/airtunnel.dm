obj/machinery/door_control/attackby(obj/item/weapon/W, mob/user as mob)
	if(istype(W, /obj/item/weapon/f_print_scanner))
		return
	return src.interact(user)

obj/machinery/door_control/interact(mob/user as mob)
	if(stat & (BROKEN|NOPOWER)) return
	use_power(5)
	icon_state = "doorctrl1"

	for(var/obj/machinery/door/poddoor/M in machines)
		if(M.id != src.id) continue
		if(M.density)
			spawn(0)
				M.openpod()
		else
			spawn(0)
				M.closepod()

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
							src.d1.open()
							return
					else
						spawn( 0 )
							src.d1.close()
							return
		if (href_list["door2"])
			if (src.scan)
				if (src.check_access(src.scan))
					if (src.d2.density)
						spawn( 0 )
							src.d2.open()
							return
					else
						spawn( 0 )
							src.d2.close()
							return
		if (href_list["em_cl"])
			if (src.scan)
				if (src.check_access(src.scan))
					if (!( src.d1.density ))
						src.d1.close()
						return
					sleep(1)
					spawn( 0 )
						if (!( src.d2.density ))
							src.d2.close()
						return
		if (href_list["em_op"])
			if (src.scan)
				if (src.check_access(src.scan))
					spawn( 0 )
						if (src.d1.density)
							src.d1.open()
						return
					sleep(1)
					spawn( 0 )
						if (src.d2.density)
							src.d2.open()
						return
		src.add_fingerprint(usr)
		src.updateUsrDialog()

			//Foreach goto(737)
	return

/obj/machinery/autolathe/attackby(var/obj/item/weapon/O as obj, var/mob/user as mob)

	if (istype(O, /obj/item/weapon/sheet/metal))
		if (src.m_amount < 150000.0)
			src.m_amount += O:height * O:width * O:length * 1000000.0
			O:amount--
			if (O:amount < 1)
				//O = null
				del(O)
	else
		if (istype(O, /obj/item/weapon/sheet/glass))
			if (src.g_amount < 75000.0)
				src.g_amount += O:height * O:width * O:length * 1000000.0
				O:amount--
				if (O:amount < 1)
					//O = null
					del(O)
		else
			if (istype(O, /obj/item/weapon/screwdriver))
				if (!( src.operating ))
					src.opened = !( src.opened )
					src.icon_state = text("autolathe[]", (src.opened ? "f" : null))
				else
					user << "\red The machine is in use. You can not maintain it now."
			else
				spawn( 0 )
					src.interact(user)
					return
	return


/obj/machinery/autolathe/interact(user as mob)

	var/dat
	if (src.temp)
		dat = text("<TT>[]</TT><BR><BR><A href='?src=\ref[];temp=1'>Clear Screen</A>", src.temp, src)
	else
		dat = text("<B>Metal Amount:</B> [] cm<sup>3</sup> (MAX: 150,000)<BR>\n<FONT color = blue><B>Glass Amount:</B></FONT> [] cm<sup>3</sup> (MAX: 75,000)<HR>", src.m_amount, src.g_amount)
		var/list/L = list(  )
/*		L["screwdriver"] = "Make Screwdriver {40 cc}"
		L["wirecutters"] = "Make Wirecutters {80 cc}"
		L["wrench"] = "Make Wrench {150 cc}"
		L["crowbar"] = "Make Crowbar {150 cc}"
		L["screw"] = "Make Screw (1) {3 cc}"
		L["5screws"] = "Make Screws (5) {14 cc}"
		L["rod_t"] = "Make Rod (1x20) {20 cc}"
		L["rod_l"] = "Make Rod (5x250) {1250 cc}"
		L["grille_1"] = "Make Grille (250x250x1) {27345 cc}"
		L["sheet_1"] = "Make Sheet (20x10x.01) {2 cc}"
		L["sheet_2"] = "Make Sheet (30x10x.01) {3 cc}"
		L["sheet_3"] = "Make Sheet (30x20x.01) {6 cc}"
		L["sheet_4"] = "Make Sheet (30x30x.01) {9 cc}"
		L["sheet_5"] = "Make Sheet (62.5x62.5x4) {15625 cc}" */


		for(var/t in L)
			dat += "<A href='?src=\ref[src];make=[t]'>[L["[t]"]]<BR>"
			//Foreach goto(230)
	ss13_browse(user, "<HEAD><TITLE>Autolathe Control Panel</TITLE></HEAD><TT>[dat]</TT>", "window=autolathe")
	return

/obj/machinery/autolathe/Topic(href, href_list)
	..()
	if ((!usr.can_use_hands()))
		return
	if ((usr.contents.Find(src) || (get_dist(src, usr) <= 1 && istype(src.loc, /turf))))
		usr.machine = src
		src.add_fingerprint(usr)

		if (href_list["temp"])
			src.temp = null

	for(var/mob/M in viewers(1, src))
		if ((M.client && M.machine == src))
			src.interact(M)
		//Foreach goto(108)
	return

/obj/machinery/injector/attackby(var/obj/item/weapon/tank/W as obj, var/mob/user as mob)

	if(stat & NOPOWER)
		return
	use_power(25)

	var/obj/item/weapon/tank/ptank = W
	if (!( istype(ptank, /obj/item/weapon/tank) ))
		return
	var/turf/T = get_step(src.loc, get_dir(user, src))
	ptank.gas.turf_add(T, -1.0)
	src.add_fingerprint(user)
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

/obj/machinery/alarm/indicator/process()

	if(stat & NOPOWER)
		icon_state = "indicator-p"
		return

	var/safe = 1
	var/turf/T = src.loc
	if(!istype(T, /turf)) return

	var/turf_total = max(T.gas.total(), 1)
	var/air_pressure = turf_total / CELLSTANDARD * 100
	var/oxygen_press = T.gas.oxygen / turf_total * 100

	if(!InRange(air_pressure, 90, 110))	safe = 0
	if(!InRange(oxygen_press, 20,  30)) safe = 0

	src.icon_state = text("indicator[]", safe)
	SS13_airtunnel.air_stat = safe
	return
