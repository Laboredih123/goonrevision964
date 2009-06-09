/obj/item/weapon/tank/plasmatank
	name = "plasmatank"
	icon_state = "plasma"
	maximum = 1600000.0


/obj/item/weapon/tank/plasmatank/proc/release()
	var/turf/T = get_turf(src.loc)
	src.gas.multiply_gas(src.gas.temp/25.0)
	T.firelevel = src.gas.temp * 3600.0
	T.gas.copy_gas(src.gas)
	T.reset_phases()
	src.gas.clear()

/obj/item/weapon/tank/plasmatank/proc/ignite()

	var/strength = ((src.gas.plasma + src.gas.oxygen/2.0) / 1600000.0) * src.gas.temp

	var/turf/T = get_turf(src)

	for(var/mob/carbon/M in range(T))
		if(M.hud && M.hud.flash)
			flick("flash", M.hud.flash)

	for(var/obj/machinery/atmoalter/canister/C in range(1, T))
		if (!( C.destroyed ))
			if (C.gas.plasma >= 35000)
				C.destroyed = 1
				strength += 500

	if(strength < 250) // can't be taking the square root of a negative number, now
		del(src)
		return

	// strength of 773 (500C pure plasma) gives m_range around 2, same as in old system
	var/m_range = min(sqrt(strength/250 - 1), MAX_BOMB_RADIUS)

	var/min = round(m_range)
	var/med = round(m_range * 2)
	var/max = round(m_range * 3)
	var/u_max = round(m_range * 4)

	var/turf/sw = locate(max(T.x - u_max, 1), max(T.y - u_max, 1), T.z)
	var/turf/ne = locate(min(T.x + u_max, world.maxx), min(T.y + u_max, world.maxy), T.z)

	defer_powernet_rebuild = 1

	for(var/turf/U in block(sw, ne))


		var/zone = 4
		if ((U.y <= (T.y + max) && U.y >= (T.y - max) && U.x <= (T.x + max) && U.x >= (T.x - max) ))
			zone = 3
		if ((U.y <= (T.y + med) && U.y >= (T.y - med) && U.x <= (T.x + med) && U.x >= (T.x - med) ))
			zone = 2
		if ((U.y <= (T.y + min) && U.y >= (T.y - min) && U.x <= (T.x + min) && U.x >= (T.x - min) ))
			zone = 1
		for(var/atom/A in U)
			A.ex_act(zone)
		U.ex_act(zone)
		U.buildlinks()
	defer_powernet_rebuild = 0
	makepowernets()

	del(src)

/obj/item/weapon/tank/plasmatank/New()
	..()
	src.gas.plasma = src.maximum
	return