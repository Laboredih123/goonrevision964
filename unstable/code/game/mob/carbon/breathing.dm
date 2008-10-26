/mob/carbon
	var/max_air_breathed = 650 //max amount of air breathed per second
	var/oxygen_needed = 67
	var/co2_breathed = 0
	var/no2_breathed = 0
	var/taking_tox_damage = 0
	var/taking_suff_damage = 0
	var/co2_metabolize_rate = 20
	var/co2_knockdown_threshold = 100
	var/no2_metabolize_rate = 10
	var/no2_knockdown_threshold = 20
	var/plasma_damage_threshold = 5
/mob/carbon/var/temperature_resistance = T0C+75

/mob/carbon/proc/breathe()
	if(src.internal)
		if(!src.mask)								src.internal = null
		else if(!src.contents.Find(src.internal))	src.internal = null
		else if(!(src.mask.flags | MASKINTERNALS))	src.internal = null

	if(src.losebreath > 0)
		--src.losebreath
		if(prob(5))	src.gasp()
		src.take_damage(suffocation = 5)
		return

	var/T = src.loc
	if(isobj(T)) T = T:alter_health(src) 	// returns O.loc for most things, just alters their health for sleeper etc
	if(!isturf(T)) return					//	things don't breath in null locations? sure

	var/datum/substance/gas/G = src.get_breathed_air(T)	//	breath in
	src.aircheck(G)										//	process air
	G.turf_add(T)										//	breath out

/mob/carbon/proc/aircheck(datum/substance/gas/G as obj)
	if(!G) return
	src.taking_tox_damage = 0
	src.taking_suff_damage = 0
	var/o2_breathed = G.oxygen * 0.7

	if(o2_breathed < oxygen_needed)
		var/oxygen_dam = round((oxygen_needed - o2_breathed)/5)+1
		src.take_damage(suffocation = oxygen_dam)
		src.taking_suff_damage = 1

	if(G.plasma > plasma_damage_threshold)
		var/plasma_dam = round(G.plasma/8) + 1
		if(src.mask && src.mask.a_filter >= 4)
			plasma_dam = max(0,plasma_dam - 20)
		if(plasma_dam > 0)
			src.take_damage(toxin = plasma_dam)
			src.taking_tox_damage = 1
	if(G.temp > temperature_resistance)
		var/lung_damage = round((G.temp - temperature_resistance)/20+1)
		if(src.mask && src.mask.a_filter >= 4) lung_damage /= 5
		src.take_damage(burn = lung_damage)

	src.co2_breathed = max(0, src.co2_breathed - src.co2_metabolize_rate) + G.co2
	if(src.co2_breathed > src.co2_knockdown_threshold)
		src.co2_breathed -= src.co2_knockdown_threshold
		src.take_damage(suffocation = 2)
		src.knockdown_until(3)

	src.no2_breathed = max(0, src.no2_breathed - src.no2_metabolize_rate) + G.no2
	if(src.no2_breathed > src.no2_knockdown_threshold)
		src.no2_breathed -= src.no2_knockdown_threshold
		src.knockdown_until(3)

	G.no2 = 0
	G.plasma = 0
	G.oxygen -= o2_breathed
	G.co2 += o2_breathed

/mob/carbon/proc/get_breathed_air(turf/T)
	var/oxy_required = oxygen_needed * 1.43				// aircheck uses oxygen * 70% => 67 * 100/70 = 95.81
	var/max_breathed = max_air_breathed					//	require 15% oxygen at STP
	if(src.get_damage()+25 > src.death_threshold)		max_breathed *= 0.55 // require 27% oxygen
	else if(src.get_damage()+50 > src.death_threshold)	max_breathed *= 0.75 // require 20% oxygen
	var/datum/substance/gas/G = new()
	G.maximum = round(max_breathed,1)+1

	var/turf_total = T.gas.total()

	if(!src.internal)
		if(!T.gas.oxygen) // No air? Take a deep, deep breath
			G.turf_take(T, max_breathed)
			return G

		var/oxy_rate = T.gas.oxygen / turf_total 	//	(21%)^-1 * 67 = 456
		G.turf_take(T, max(max_breathed, round(oxy_required * oxy_rate,1)))
		if(src.hud && src.hud.internal) src.hud.internal.icon_state = "internal0"
		return G

	src.internal.process(src, G)	//	transfer gasses from internals to G
	if(G.total() > max_breathed) G.turf_add(T, G.total() - max_breathed)
	if(src.hud && src.hud.internal)	src.hud.internal.icon_state = "internal1"
	if(src.mask)	//	assumed for internals, but lets check anyhow
		if(!(src.mask.flags & HALFMASK)) return G

	if(src.helmet)
		if(src.helmet.flags & HEADSPACE) return G
		if(istype(src.helmet, /obj/item/weapon/clothing/head)) return G

	//	half the air from internals is wasted
	G.turf_add(T, G.total() * 0.5)

	//	pull the rest required from the room
	if(!T.gas.oxygen)	//	No air, again! Take a deeper breath
		G.turf_take(T, max_breathed - G.total())
		return G

	var/oxy_need = oxy_required - G.oxygen
	var/oxy_rate = turf_total / T.gas.oxygen
	if(oxy_need > 0)	G.turf_take(T,max(max_breathed-G.total(),round(oxy_need*oxy_rate,1)))
	else				G.turf_take(T,max(max_breathed-G.total(),round(max(max_breathed/G.total(),15),1)))
	return G

