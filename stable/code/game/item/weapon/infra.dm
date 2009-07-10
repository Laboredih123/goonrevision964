/obj/item/weapon/infra
	name = "infrared beam"
	desc = "Emits a visible or invisible beam and is triggered when the beam is interrupted."
	icon_state = "infrared0"
	var/obj/beam/i_beam/first = null
	var/state = 0
	var/visible = 0
	flags = FPRINT|TABLEPASS|SENDSRSIGNAL
	w_class = 2
	s_istate = "infra"
	is_signaller = 1
	assembly_name = "infrared"


/obj/item/weapon/infra/proc/hit()
	if(istype(src.loc, /obj/item/weapon/assembly))
		var/obj/item/weapon/assembly/A = src.loc
		A.signal()
	for(var/mob/O in hearers(get_turf(src)))
		O.hear(text("\icon[] *beep* *beep*", src))

/obj/item/weapon/infra/proc/process()
	if (!src.first && src.state)
		var/loc = src.loc
		if(istype(src.loc, /obj/item/weapon/assembly))
			loc = src.loc.loc
		if(istype(loc, /turf))
			var/obj/beam/i_beam/I = new /obj/beam/i_beam(loc)
			I.master = src
			I.density = 1
			I.dir = src.dir
			step(I, I.dir)
			if (I)
				I.density = 0
				src.first = I
				I.vis_spread(src.visible)
				spawn( 0 )
					if (I)
						I.limit = 20
						I.process()
					return
	if (!( src.state ))
		del(src.first)
	spawn( 10 )
		src.process()
		return
	return

/obj/item/weapon/infra/New()

	spawn( 0 )
		src.process()
		return
	..()
	return

/obj/item/weapon/infra/attack_self(mob/user as mob)

	user.machine = src
	var/dat = text("<TT><B>Infrared Laser</B>\n<B>Status</B>: []<BR>\n<B>Visibility</B>: []<BR>\n</TT>", (src.state ? text("<A href='?src=\ref[];state=0'>On</A>", src) : text("<A href='?src=\ref[];state=1'>Off</A>", src)), (src.visible ? text("<A href='?src=\ref[];visible=0'>Visible</A>", src) : text("<A href='?src=\ref[];visible=1'>Invisible</A>", src)))
	ss13_browse(user, dat, "window=infra")
	return

/obj/item/weapon/infra/Topic(href, href_list)
	..()
	if (!usr.can_use_hands())
		return
	if ((usr.contents.Find(src) || (usr.contents.Find(src.loc) && istype(src.loc, /obj/item/weapon/assembly)) || get_dist(src, usr) <= 1 && istype(src.loc, /turf)))
		usr.machine = src
		if (href_list["state"])
			src.state = !( src.state )
			src.c_state(src.state)
		if (href_list["visible"])
			src.visible = !( src.visible )
			spawn( 0 )
				if (src.first)
					src.first.vis_spread(src.visible)
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
		ss13_browse(usr, null, "window=infra")
		return
	return

/obj/item/weapon/infra/proc/c_state(n)
	icon_state = "infrared[n]"
	if(istype(src.loc, /obj/item/weapon/assembly))
		var/obj/item/weapon/assembly/A = src.loc
		if(n)
			A.c_state(n)
		else
			A.c_state("")

/obj/item/weapon/infra/interact()
	del(src.first)
	..()
	return

/obj/item/weapon/infra/Move()

	var/t = src.dir
	..()
	src.dir = t
	//src.first = null
	del(src.first)
	return

/obj/item/weapon/infra/verb/rotate()
	set src in usr
	src.dir = turn(src.dir, 90)
	return