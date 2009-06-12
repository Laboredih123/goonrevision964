/obj/item/weapon/weldingtool
	name = "weldingtool"
	icon_state = "welder"
	s_istate = "welder"
	var/welding = 0.0
	var/weldfuel = 20.0
	flags = 322.0
	force = 3.0
	throwforce = 5.0
	throw_speed = 1
	throw_range = 5
	w_class = 2.0

/obj/item/weapon/weldingtool/examine()
	set src in usr

	usr << text("\icon[] [] contains [] units of fuel left!", src, src.name, src.weldfuel)
	return

/obj/item/weapon/weldingtool/afterattack(O as obj, mob/user as mob)

	if (src.welding)
		src.weldfuel--
		if (src.weldfuel <= 0)
			usr << "\blue Need more fuel!"
			src.welding = 0
			src.force = 3
			src.damtype = "brute"
			src.icon_state = "welder"
		var/turf/location = user.loc
		if (!( istype(location, /turf) ))
			return
		location.firelevel = location.gas.plasma + 1
	return

/obj/item/weapon/weldingtool/attack_self(mob/user as mob)

	src.welding = !( src.welding )
	if (src.welding)
		if (src.weldfuel <= 0)
			user << "\blue Need more fuel!"
			src.welding = 0
			return 0
		user << "\blue You will now weld when you attack."
		src.force = 15
		src.damtype = "fire"
		src.icon_state = "welder1"
		spawn() //start fires while it's lit
			src.process()
	else
		user << "\blue Not welding anymore."
		src.force = 3
		src.damtype = "brute"
		src.icon_state = "welder"
	return

/obj/item/weapon/weldingtool/var/processing = 0

/obj/item/weapon/weldingtool/proc/process()
	if(src.processing) //already doing this
		return
	src.processing = 1

	while(src.welding)
		var/turf/location = src.loc
		if(istype(location, /mob/carbon))
			var/mob/carbon/M = location
			if(M.l_hand == src || M.r_hand == src)
				location = M.loc

		if(isturf(location)) //start a fire if possible
			location.firelevel = max(location.firelevel, location.gas.plasma + 1)

		sleep(10)
	processing = 0	//we're done
