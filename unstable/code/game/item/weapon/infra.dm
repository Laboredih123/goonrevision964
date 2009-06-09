/obj/item/weapon/infra
	name = "Infrared Beam (Security)"
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
	for(var/mob/O in hearers(null, src))
		O.hear(text("\icon[] *beep* *beep*", src))

/obj/item/weapon/infra/proc/process()


	if ((!( src.first ) && (src.state && (istype(src.loc, /turf) ))))

		var/obj/beam/i_beam/I = new /obj/beam/i_beam(src.loc)
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
	if ((usr.contents.Find(src) || get_dist(src, usr) <= 1 && istype(src.loc, /turf)))
		usr.machine = src
		if (href_list["state"])
			src.state = !( src.state )
			src.icon_state = text("infrared[]", src.state)
		if (href_list["visible"])
			src.visible = !( src.visible )
			spawn( 0 )
				if (src.first)
					src.first.vis_spread(src.visible)
				return
		if (istype(src.loc, /mob))
			attack_self(src.loc)
		else
			for(var/mob/M in viewers(1, src))
				if (M.client)
					src.attack_self(M)
	else
		ss13_browse(usr, null, "window=infra")
		return
	return

/obj/item/weapon/infra/interact()

	//src.first = null
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