/obj/item/weapon/infra_sensor/New()

	..()
	spawn( 0 )
		src.process()
		return
	return

/obj/item/weapon/infra_sensor/proc/process()

	if (src.passive)
		for(var/obj/beam/i_beam/I in range(2, src.loc))
			I.left = 2
			//Foreach goto(30)
	spawn( 10 )
		src.process()
		return
	return

/obj/item/weapon/infra_sensor/proc/burst()

	for(var/obj/beam/i_beam/I in range(src.loc))
		I.left = 10
		//Foreach goto(22)
	for(var/obj/item/weapon/infra/I in range(src.loc))
		I.visible = 1
		spawn( 0 )
			if ((I && I.first))
				I.first.vis_spread(1)
			return

/obj/item/weapon/infra_sensor/attack_self(mob/user as mob)

	user.machine = src
	var/dat = text("<TT><B>Infrared Sensor</B><BR>\n<B>Passive Emitter</B>: []<BR>\n<B>Active Emitter</B>: <A href='?src=\ref[];active=0'>Burst Fire</A>\n</TT>", (src.passive ? text("<A href='?src=\ref[];passive=0'>On</A>", src) : text("<A href='?src=\ref[];passive=1'>Off</A>", src)), src)
	ss13_browse(user, dat, "window=infra_sensor")
	return

/obj/item/weapon/infra_sensor/Topic(href, href_list)
	..()
	if (!usr.can_use_hands())
		return
	if ((usr.contents.Find(src) || ((get_dist(src, usr) <= 1 && istype(src.loc, /turf)))))
		usr.machine = src
		if (href_list["passive"])
			src.passive = !( src.passive )
		if (href_list["active"])
			spawn( 0 )
				src.burst()
				return
		if (istype(src.loc, /mob))
			attack_self(src.loc)
		else
			for(var/mob/M in viewers(1, src))
				if (M.client)
					src.attack_self(M)
		src.add_fingerprint(usr)
	else
		ss13_browse(usr, null, "window=infra_sensor")
		return
	return

/obj/item/weapon/shock_kit/Del()

	//src.part1 = null
	del(src.helmet)
	//src.part2 = null
	del(src.electropack)
	..()
	return

/obj/item/weapon/shock_kit/attackby(obj/item/weapon/W as obj, mob/user as mob)

	if ((istype(W, /obj/item/weapon/wrench) && !( src.status )))
		var/turf/T = src.loc
		if (ismob(T))
			T = T.loc
		src.helmet.loc = T
		src.electropack.loc = T
		src.electropack.shockkit = null
		src.helmet = null
		src.electropack = null
		//SN src = null
		del(src)
		return
	if (!( istype(W, /obj/item/weapon/screwdriver) ))
		return
	src.status = !( src.status )
	if (src.status)
		user.see("\blue The shock pack is now secured!")
	else
		user.see("\blue The shock pack is now unsecured!")
	src.add_fingerprint(user)
	return

/obj/item/weapon/shock_kit/attack_self(mob/user as mob)

	src.helmet.attack_self(user, src.status)
	src.electropack.attack_self(user, src.status)
	src.add_fingerprint(user)
	return

/obj/item/weapon/shock_kit/proc/r_signal(n, source)
	if (istype(src.loc, /obj/stool/chair/e_chair))
		var/obj/stool/chair/e_chair/C = src.loc
		C.shock()
	return

/obj/bullet/Bump(atom/A as mob|obj|turf|area)

	spawn( 0 )
		if (A)
			A.las_act(PROJECTILE_BULLET, src)
		//SN src = null
		del(src)
		return
		return
	return

/obj/bullet/CheckPass(B as obj)

	if (istype(B, /obj/bullet))
		return prob(95)
	else
		return 1
	return

/obj/bullet/proc/process()

	if ((!( src.current ) || src.loc == src.current))
		src.current = locate(min(max(src.x + src.xo, 1), world.maxx), min(max(src.y + src.yo, 1), world.maxy), src.z)
	if ((src.x == 1 || src.x == world.maxx || src.y == 1 || src.y == world.maxy))
		//SN src = null
		del(src)
		return
	step_towards(src, src.current)
	spawn( 1 )
		process()
		return
	return

/obj/beam/a_laser/Bump(atom/A as mob|obj|turf|area)

	spawn( 0 )
		if (A)
			A.las_act(PROJECTILE_LASER, src)
		//SN src = null
		del(src)

/obj/beam/a_laser/proc/process()
	if ((!( src.current ) || src.loc == src.current))
		src.current = locate(min(max(src.x + src.xo, 1), world.maxx), min(max(src.y + src.yo, 1), world.maxy), src.z)
	if ((src.x == 1 || src.x == world.maxx || src.y == 1 || src.y == world.maxy))
		//SN src = null
		del(src)
		return
	step_towards(src, src.current)
	// make it able to hit lying-down folk
	var/list/dudes = list()
	for(var/mob/M in src.loc)
		dudes += M
	if(dudes.len)
		src.Bump(pick(dudes))
	src.life--
	if (src.life <= 0)
		//SN src = null
		del(src)
		return
	spawn( 1 )
		src.process()
		return
	return

/obj/beam/a_laser/s_laser/Bump(atom/A as mob|obj|turf|area)

	spawn( 0 )
		if(A)
			A.las_act(PROJECTILE_TASER)
		//SN src = null
		del(src)

/obj/beam/i_beam/proc/hit()
	if (src.master)
		src.master.hit()
	del(src)

/obj/beam/i_beam/proc/vis_spread(v)
	src.visible = v
	spawn( 0 )
		if (src.next)
			src.next.vis_spread(v)
		return
	return

/obj/beam/i_beam/proc/process()
	if (src.loc.density || !src.master)
		del(src)
		return

	if (src.left > 0)
		src.left--
	if (src.left < 1)
		if (!( src.visible ))
			src.invisibility = 100
		else
			src.invisibility = 0
	else
		src.invisibility = 0


	var/obj/beam/i_beam/I = new /obj/beam/i_beam( src.loc )
	I.master = src.master
	I.density = 1
	I.dir = src.dir
	step(I, I.dir)

	if (I)
		if (!( src.next ))
			I.density = 0
			I.vis_spread(src.visible)
			src.next = I
			spawn( 0 )
				if ((I && src.limit > 0))
					I.limit = src.limit - 1
					I.process()
				return
		else
			//I = null
			del(I)
	else
		del(src.next)
	spawn( 10 )
		src.process()
		return
	return

/obj/beam/i_beam/Bump()
	del(src)

/obj/beam/i_beam/Bumped()
	src.hit()

/obj/beam/i_beam/HasEntered(atom/movable/AM as mob|obj)

	if (istype(AM, /obj/beam))
		return
	spawn( 0 )
		src.hit()
		return
	return

/obj/beam/i_beam/Del()

	//src.next = null
	del(src.next)
	..()
	return

/atom/proc/ex_act()
	return

/atom/proc/blob_act()
	return

/atom/proc/las_act(flag)
	if(flag == PROJECTILE_PULSE)
		src.ex_act(2)
	return

/turf/Entered(atom/A as mob|obj)

	..()
	if(!A)
		return
	if(!A.density)
		return

	src.updatelinks()

	if(!istype(A, /obj/beam))
		spawn(0)
			for(var/obj/beam/i_beam/I in src)
				if(I)
					I.hit()
