/mob/carbon/var/max_air_breathed = 650 //max amount of air breathed per second
/mob/carbon/var/oxygen_needed = 67
/mob/carbon/var/co2_breathed = 0
/mob/carbon/var/taking_tox_damage = 0
/mob/carbon/var/taking_suff_damage = 0

/mob/carbon/proc/aircheck(datum/substance/gas/G as obj)
	return // lol who needs to breathe DO NOT MERGE INTO UNSTABLE

	if(!G)
		return
	src.taking_tox_damage = 0
	src.taking_suff_damage = 0

	var/a_oxygen = G.oxygen * 0.7
	var/a_plasma = G.plasma
	var/a_no2_gas = G.no2 * 0.7

	G.oxygen -= a_oxygen
	G.plasma = 0
	G.no2 -= a_no2_gas

	if(a_oxygen < oxygen_needed)
		src.take_damage(suffocation = round((oxygen_needed - a_oxygen) / 5) + 1)
		src.taking_suff_damage = 1
	if(a_plasma > 5)
		var/plasma_dam = round(a_plasma/10) + 1
		if(src.mask && src.mask.a_filter >= 4)
			plasma_dam = max(plasma_dam - 40, 0)
		if(plasma_dam > 0)
			src.take_damage(toxin = plasma_dam)
			src.taking_tox_damage = 1
	src.co2_breathed = max(0, src.co2_breathed - 5) + G.co2
	if(src.co2_breathed > 50)
		src.co2_breathed -= 50
		src.knockdown_until(3)
		src.take_damage(suffocation = 2)

	src.no2_breathed = max(0, src.no2_breathed - 5) + a_no2_gas
	if (src.no2_breathed > 50)
		src.knockdown_until(3)

	G.co2 += a_oxygen //breathe out!

/mob/carbon/proc/get_breathed_air(turf/T)
	// aircheck uses oxygen * 70%, factor is 1/70%
	var/oxy_required = oxygen_needed * 1.43	// = 95.81	-	require 15% oxygen at STP
	var/max_breathed = max_air_breathed
	if(src.get_damage()+25 > src.death_threshold)
		max_breathed *= 0.55 // require 27% oxygen
	else if(src.get_damage()+50 > src.death_threshold)
		max_breathed *= 0.75 // require 20% oxygen
	var/datum/substance/gas/G = new()
	G.maximum = 10000

	if(!T.gas.oxygen) // No air? Take a deep, deep breath
		G.turf_take(T, max_breathed)
		return G

	var/turf_total = T.gas.total()
	var/oxygen_rate = turf_total / T.gas.oxygen

	if(!src.internal)
		G.turf_take(T, max(max_breathed,oxy_required*oxygen_rate))
		if(src.hud && src.hud.internal)
			src.hud.internal.icon_state = "internal0"
	else
		src.internal.process(src, G)	//	transfer gasses from internals to G
		if(src.hud && src.hud.internal)
			src.hud.internal.icon_state = "internal1"
		if(src.mask.flags & HALFMASK)
			if(!istype(src.helmet, /obj/item/weapon/clothing/head) || !(src.helmet.flags & HEADSPACE))
			//half the air from internals is wasted
				G.turf_add(T, G.total() * 0.5)

				//	pull the rest required from the room
				if(G.oxygen < oxy_required)
					if(max_breathed > G.total())
						G.turf_take(T, max_breathed - G.total())

	if(G.total() > max_breathed)
		G.turf_add(T, G.total() - max_breathed)
	return G

/mob/carbon/proc/breathe()
	if(src.internal && !src.contents.Find(src.internal))
		src.internal = null
	if(!src.mask || ! (src.mask.flags | MASKINTERNALS))
		src.internal = null

	if (src.losebreath > 0)
		src.losebreath--
		if(prob(5))
			src.gasp()
		src.take_damage(suffocation = 5)
		return

	var/T = src.loc
	if(isobj(T))
		var/obj/O = T
		T = O.alter_health(src) // returns O.loc for most things, just alters their health for sleeper etc
	if(isturf(T))
		if(locate(/obj/move, T))
			T = locate(/obj/move, T)

		//breathe in
		var/datum/substance/gas/G = src.get_breathed_air(T)
		//process air
		src.aircheck(G)
		//breathe out
		G.turf_add(T)

