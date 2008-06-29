/mob/carbon/var/max_air_breathed = 650 //max amount of air breathed per second
/mob/carbon/var/oxygen_needed = 67
/mob/carbon/var/co2_breathed
/mob/carbon/var/taking_tox_damage = 0
/mob/carbon/var/taking_suff_damage = 0


/mob/carbon/proc/aircheck(obj/substance/gas/G as obj)
	if (G)
		taking_tox_damage = 0
		taking_suff_damage = 0
		var/a_oxygen = G.oxygen * 0.7
		var/a_plasma = G.plasma
		var/a_sl_gas = G.sl_gas * 0.7
		G.oxygen -= a_oxygen
		G.plasma -= a_plasma
		G.sl_gas -= a_sl_gas
		if (a_oxygen < oxygen_needed)
			src.take_damage(suffocation = round( (oxygen_needed - a_oxygen) / 5 ) + 1)
			src.taking_suff_damage = 1
		if (a_plasma > 5)
			var/plasma_dam = round(a_plasma / 10) + 1
			if ((src.mask && src.mask.a_filter >= 4))
				plasma_dam = max(plasma_dam - 40, 0)
			if(plasma_dam > 0)
				src.take_damage(toxin = plasma_dam)
				src.taking_tox_damage = 1

		src.co2_breathed = min(0, src.co2_breathed - 5)
		src.co2_breathed += G.co2
		if(src.co2_breathed > 50)
			src.co2_breathed -= 50
			src.knockdown_until(3)
			src.take_damage(suffocation = 2)

		src.sl_gas_breathed = max(0, src.sl_gas_breathed - 5)
		src.sl_gas_breathed += a_sl_gas
		if (src.sl_gas_breathed > 50)
			src.knockdown_until(3)

		G.co2 += a_oxygen //breathe out!

	return

/mob/carbon/proc/get_breathed_air(turf/T)
	var/frac_air_taken = 1.4E-4 //fraction of air in tile taken
	if (src.get_damage() + 25 > src.death_threshold)
		frac_air_taken = 5.0E-5
	else if (src.get_damage() + 50 > src.death_threshold)
		frac_air_taken = 1.0E-4

	var/turf_total = T.oxygen + T.poison + T.sl_gas + T.co2 + T.n2
	var/obj/substance/gas/G = new /obj/substance/gas(  )
	G.maximum = 10000
	if (src.internal)
		src.internal.process(src, G)
		if (src.hud && src.hud.internal)
			src.hud.internal.icon_state = "internal1"

		if (src.mask.flags & HALFMASK && (!istype(src.helmet, /obj/item/weapon/clothing/head) || !( src.helmet.flags & HEADSPACE )))
			//only get half of air from internals
			G.turf_add(T, G.tot_gas() * 0.5)
			G.turf_take(T, frac_air_taken / 2 * turf_total - G.tot_gas())
	else
		if (src.hud && src.hud.internal)
			src.hud.internal.icon_state = "internal0"
		G.turf_take(T, frac_air_taken * turf_total)

	if (G.tot_gas() > max_air_breathed)
		G.turf_add(T, G.tot_gas() - max_air_breathed)
	return G

/mob/carbon/proc/breathe()
	if (src.internal && !src.contents.Find(src.internal))
		src.internal = null
	if (!src.mask || ! (src.mask.flags | MASKINTERNALS))
		src.internal = null

	if (src.losebreath > 0)
		src.losebreath--
		if (prob(5))
			src.gasp()
		src.take_damage(suffocation = 5)
		return

	var/T = src.loc
	if (isobj(T))
		var/obj/O = T
		T = O.alter_health(src) // returns O.loc for most things, just alters their health for sleeper etc
	if (isturf(T))
		if (locate(/obj/move, T))
			T = locate(/obj/move, T)

		//breathe in
		var/obj/substance/gas/G = src.get_breathed_air(T)
		//process air
		src.aircheck(G)
		//breathe out
		G.turf_add(T, G.tot_gas())