/mob/carbon/var/max_air_breathed = 650 //max amount of air breathed per second
/mob/carbon/var/oxygen_needed = 67
/mob/carbon/var/co2_breathed

/mob/carbon/proc/aircheck(obj/substance/gas/G as obj)
	if (G)
		var/a_oxygen = G.oxygen * 0.7
		var/a_plasma = G.plasma
		var/a_sl_gas = G.sl_gas * 0.7
		G.oxygen -= a_oxygen
		G.plasma -= a_plasma
		G.sl_gas -= a_sl_gas
		if (a_oxygen < oxygen_needed) //wtf
			src.take_damage(new datum/damage(suffocation = round( (oxygen_needed - a_oxygen) / 5 + 1))

		if (a_plasma > 5)
			src.t_plasma = round(a_plasma / 10) + 1
			if ((src.mask && src.mask.a_filter >= 4))
				src.t_plasma = max(src.t_plasma - 40, 0)

		src.co2_breathed = min(0, src.co2_breathed - 5)
		src.co2_breathed += G.co2
		if(src.co2_breathed > 50)
			src.co2_breathed -= 50
			src.paralysis = max(src.paralysis, 3)
			src.take_damage(new datum/damage(suffocation = 2))

		src.sl_gas_breathed = min(0, src.sl_gas_breathed - 5)
		src.sl_gas_breathed += a_sl_gas
		if (src.sl_gas_breathed > 50)
			src.weakened = max(src.weakened, 3)
			src.paralysis = max(src.paralysis, 3)

		G.co2 += a_oxygen //breathe out!

	return

/mob/carbon/get_breathed_air(/turf/T)
	var/frac_air_taken = 1.4E-4 //fraction of air in tile taken
	if (src.health < -75.0)
		frac_air_taken = 5.0E-5
	else if (src.health < -50.0)
		frac_air_taken = 1.0E-4

	var/turf_total = T.oxygen + T.poison + T.sl_gas + T.co2 + T.n2
	var/obj/substance/gas/G = new /obj/substance/gas(  )
	G.maximum = 10000
	if (src.internal)
		src.internal.process(src, G)
		if (src.internal_icon)
			src.internal_icon.icon_state = "internal1"

		if (src.mask.flags & HALFMASK && (!istype(src.head, /obj/item/weapon/clothing/head) || !( src.head.flags & HEADSPACE )))
			//only get half of air from internals
			G.turf_add(T, G.tot_gas() * 0.5)
			G.turf_take(T, frac_air_taken / 2 * turf_total - G.tot_gas())
	else
		if (src.internal_icon)
			src.internal_icon.icon_state = "internal0"
		G.turf_take(T, frac_air_taken * turf_total)

	if (G.tot_gas() > max_air_breathed)
		G.turf_add(T, G.tot_gas() - max_air_breathed)
	return G

/mob/carbon/breathe()
	if (src.internal && !src.contents.Find(src.internal))
		src.internal = null
	if (!src.mask || ! (src.mask.flags | MASKINTERNALS))
		src.internal = null

	if (src.losebreath > 0)
		src.losebreath--
		if (prob(5))
			src.gasp()
		src.take_damage(new datum/damage(suffocation = 5))
		return
	if (isobj(T))
		var/obj/O = T
		T = O.alter_health(src) // returns O.loc for most things, just alters their health for sleeper etc
	if (isturf(T))
		if (locate(/obj/move, T))
			T = locate(/obj/move, T)

		//breathe in
		/obj/substance/gas/G = src.get_breathing_gas(T)
		//process air
		src.aircheck(G)
		//breathe out
		G.turf_add(T, G.tot_gas())