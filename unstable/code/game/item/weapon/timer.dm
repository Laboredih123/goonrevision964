/obj/item/weapon/timer
	name = "timer"
	icon_state = "timer0"
	var/timing = 0.0
	var/time = null
	flags = FPRINT|TABLEPASS|SENDSRSIGNAL
	w_class = 2.0
	s_istate = "timer"


/obj/item/weapon/timer/proc/time()


	src.c_state(0)

	for(var/mob/O in hearers(null, src))
		O.hear(text("\icon[] *beep* *beep*", src))


/obj/item/weapon/timer/proc/c_state(n)
	src.icon_state = text("timer[]", n)

/obj/item/weapon/timer/proc/process()

	if (src.timing)
		if (src.time > 0)
			src.time = round(src.time) - 1
			if(time<5)
				src.c_state(2)
			else
				// they might increase the time while it is timing
				src.c_state(1)
		else
			time()
			src.time = 0
			src.timing = 0
		if (istype(src.loc, /mob))
			attack_self(src.loc)
		else
			for(var/mob/M in viewers(1, src))
				if (M.client)
					src.attack_self(M)
	else
		// If it's not timing, reset the icon so it doesn't look like it's still about to go off.
		src.c_state(0)
	spawn( 10 )
		src.process()
		return
	return

/obj/item/weapon/timer/New()

	spawn( 0 )
		src.process()
		return
	..()
	return

/obj/item/weapon/timer/attack_self(mob/user as mob)

	if ((user.contents.Find(src) || get_dist(src, user) <= 1 && istype(src.loc, /turf)))

		user.machine = src
		var/second = src.time % 60
		var/minute = (src.time - second) / 60
		var/dat = text("<TT><B>Timing Unit</B>\n[] []:[]\n<A href='?src=\ref[];tp=-30'>-</A> <A href='?src=\ref[];tp=-1'>-</A> <A href='?src=\ref[];tp=1'>+</A> <A href='?src=\ref[];tp=30'>+</A>\n</TT>", (src.timing ? text("<A href='?src=\ref[];time=0'>Timing</A>", src) : text("<A href='?src=\ref[];time=1'>Not Timing</A>", src)), minute, second, src, src, src, src)
		ss13_browse(user, dat, "window=timer")
	else
		ss13_browse(user, null, "window=timer")
		user.machine = null

	return

/obj/item/weapon/timer/Topic(href, href_list)
	..()

	if (!usr.can_use_hands())
		return
	if ((usr.contents.Find(src) || get_dist(src, usr) <= 1 && istype(src.loc, /turf)))
		usr.machine = src
		if (href_list["time"])
			src.timing = text2num(href_list["time"])
			if(timing)
				src.c_state(1)

		if (href_list["tp"])
			var/tp = text2num(href_list["tp"])
			src.time += tp
			src.time = min(max(round(src.time), 0), 600)

		if (istype(src.loc, /mob))
			attack_self(src.loc)
		else
			for(var/mob/M in viewers(1, src))
				if (M.client)
					src.attack_self(M)
		src.add_fingerprint(usr)
	else
		ss13_browse(usr, null, "window=timer")
		return
	return
