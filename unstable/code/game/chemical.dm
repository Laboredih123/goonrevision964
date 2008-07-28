#define REGULATE_RATE 5

/obj/substance/proc/leak(turf)

	return

/obj/substance/chemical/proc/volume()

	var/amount = 0
	for(var/item in src.chemicals)
		var/datum/chemical/C = src.chemicals[item]
		if (istype(C, /datum/chemical))
			amount += C.return_property("volume")
		//Foreach goto(24)
	return amount
	return

/obj/substance/chemical/proc/split(amount)

	var/obj/substance/chemical/S = new /obj/substance/chemical( null )
	var/tot_volume = src.volume()
	if (amount > tot_volume)
		amount = tot_volume
		for(var/item in src.chemicals)
			var/C = src.chemicals[item]
			if (istype(C, /datum/chemical))
				S.chemicals[item] = C
				src.chemicals[item] = null
			//Foreach goto(60)
		return S
	else
		if (tot_volume <= 0)
			return S
		else
			for(var/item in src.chemicals)
				var/datum/chemical/C = src.chemicals[item]
				if (istype(C, /datum/chemical))
					var/datum/chemical/N = new C.type( null )
					C.copy_data(N)
					var/amt = C.return_property("volume") * amount / tot_volume
					C.moles -= amt * C.density / C.molarmass
					if (C.moles == 0)
						//C = null
						del(C)
					N.moles += amt * N.density / N.molarmass
					S.chemicals[text("[]", N.name)] = N
				//Foreach goto(161)
			return S
	return

/obj/substance/chemical/proc/transfer_from(var/obj/substance/chemical/S as obj, amount)

	var/volume = src.volume()
	var/s_volume = S.volume()
	if (amount > s_volume)
		amount = s_volume
	if (src.maximum)
		if (amount > (src.maximum - volume))
			amount = src.maximum - volume
	if (amount >= s_volume)
		for(var/item in S.chemicals)
			var/datum/chemical/C = S.chemicals[item]
			if (istype(C, /datum/chemical))
				var/datum/chemical/N = null
				N = src.chemicals[item]
				if (!( N ))
					N = new C.type( null )
					C.copy_data(N)
				N.moles += C.moles
				//C = null
				del(C)
			//Foreach goto(106)
	else
		var/obj/substance/chemical/U = S.split(amount)
		for(var/item in U.chemicals)
			var/datum/chemical/C = U.chemicals[item]
			if (istype(C, /datum/chemical))
				var/datum/chemical/N = src.chemicals[item]
				if (!( N ))
					N = new C.type( null )
					C.copy_data(N)
					src.chemicals[item] = N
				N.moles += C.moles
				//C = null
				del(C)
			//Foreach goto(251)
		//U = null
		del(U)
	var/datum/chemical/C = null
	for(var/t in src.chemicals)
		C = src.chemicals[text("[]", t)]
		if (istype(C, /datum/chemical))
			C.react(src)
		//Foreach goto(403)
	return amount
	return

/obj/substance/chemical/proc/transfer_mob(var/mob/M as mob, amount)

	if (!( ismob(M) ))
		return
	var/obj/substance/chemical/S = src.split(amount)
	for(var/item in S.chemicals)
		var/datum/chemical/C = S.chemicals[item]
		if (istype(C, /datum/chemical))
			C.injected(M)
		//Foreach goto(44)
	//S = null
	del(S)
	return

/obj/substance/chemical/proc/dropper_mob(M as mob, amount)

	if (!( ismob(M) ))
		return
	var/obj/substance/chemical/S = src.split(amount)
	. = S.volume()
	for(var/item in S.chemicals)
		var/datum/chemical/C = S.chemicals[item]
		if (istype(C, /datum/chemical))
			C.injected(M, "eye")
		//Foreach goto(44)
	//S = null
	del(S)
	return

/obj/substance/chemical/Del()

	for(var/item in src.chemicals)
		//src.chemicals[item] = null
		del(src.chemicals[item])
		//Foreach goto(17)
	..()
	return

#define TURF_ADD_FRAC 0.95		//cooling due to release of gas into tile
#define TURF_TAKE_FRAC 1.06		//heating due to pressurization into pipework

/datum/substance/gas/proc/clear()
	src.oxygen = 0
	src.plasma = 0
	src.no2 = 0
	src.co2 = 0
	src.nitrogen = 0

/datum/substance/gas/proc/total()
	return (src.co2 + src.oxygen + src.plasma + src.no2 + src.nitrogen)

/datum/substance/gas/proc/add_gas(C,N,O,P,S)
	src.co2 += C
	src.nitrogen += N
	src.oxygen += O
	src.plasma += P
	src.no2 += S

/datum/substance/gas/proc/rem_gas(C,N,O,P,S)
	src.co2 -= C
	src.nitrogen -= N
	src.oxygen -= O
	src.plasma -= P
	src.no2 -= S

/datum/substance/gas/proc/set_gas(C,N,O,P,S)
	src.co2 = C
	src.nitrogen = N
	src.oxygen = O
	src.plasma = P
	src.no2 = S

/datum/substance/gas/proc/multiply_gas(F)
	src.co2 *= F
	src.nitrogen *= F
	src.oxygen *= F
	src.plasma *= F
	src.no2 *= F

/datum/substance/gas/proc/multiply_all(F)
	src.co2 *= F
	src.nitrogen *= F
	src.oxygen *= F
	src.plasma *= F
	src.no2 *= F
	temp *= F

/datum/substance/gas/proc/gain_gas(var/datum/substance/gas/T)
	src.co2 += T.co2
	src.nitrogen += T.nitrogen
	src.oxygen += T.oxygen
	src.plasma += T.plasma
	src.no2 += T.no2

/datum/substance/gas/proc/lose_gas(var/datum/substance/gas/T)
	src.co2 -= T.co2
	src.nitrogen -= T.nitrogen
	src.oxygen -= T.oxygen
	src.plasma -= T.plasma
	src.no2 -= T.no2

/datum/substance/gas/proc/copy_gas(var/datum/substance/gas/T)
	src.co2 = T.co2
	src.nitrogen = T.nitrogen
	src.oxygen = T.oxygen
	src.plasma = T.plasma
	src.no2 = T.no2

/datum/substance/gas/proc/copy_cop(var/datum/substance/gas/T)
	src.co2 = T.co2
	src.oxygen = T.oxygen
	src.plasma = T.plasma

/datum/substance/gas/proc/gain_all(var/datum/substance/gas/T)
	src.co2 += T.co2
	src.nitrogen += T.nitrogen
	src.oxygen += T.oxygen
	src.plasma += T.plasma
	src.no2 += T.no2
	src.temp += T.temp

/datum/substance/gas/proc/copy_all(var/datum/substance/gas/T)
	src.co2 = T.co2
	src.nitrogen = T.nitrogen
	src.oxygen = T.oxygen
	src.plasma = T.plasma
	src.no2 = T.no2
	src.temp  = T.temp

/datum/substance/gas/proc/tostring()
	return "O2 ([oxygen]), N2 ([nitrogen]), NO2 ([no2]), CO2 ([co2]), Plasma ([plasma]), Temp ([temp])"

/datum/substance/gas/proc/add_delta(var/datum/substance/gas/T)
	var/source = src.total()
	if(source <  0)
		return

	var/target = T.total()
	if(target <= 0)
		return

	src.temp = (source*src.temp + target*T.temp) / (source+target)
	src.gain_gas(T)

/datum/substance/gas/proc/sub_delta(var/datum/substance/gas/T)
	src.lose_gas(T)

/datum/substance/gas/proc/transfer(var/datum/substance/gas/target, var/amount)
	// transfers [amount] from [src] to [target]
	if(!amount)
		return 0
	if(!istype(target,/datum/substance/gas))
		return 0

	var/sTotal = src.total()
	if(sTotal<=0)
		return 0
	var/nTotal = target.total()

	//	transfer, at most, all the gas in target
	if(amount < 0 || amount > sTotal)
		amount = sTotal

	//	don't overfill the container
	if(target.maximum > 0)
		if(target.maximum < (amount + nTotal))
			amount = target.maximum - nTotal

	//	all gasses are transferred at the same rate
	var/datum/substance/gas/tmp = new/datum/substance/gas()
	tmp.gain_all(src)
	tmp.multiply_gas(amount/sTotal)

	//	energy is preserved during the transfer
	if(target.temp != src.temp)
		if(!nTotal)	//	need to do this due to bugginess with this var
			target.temp = src.temp
		else
			target.temp = (nTotal*target.temp + amount*src.temp)/(amount + nTotal)
	target.gain_gas(tmp)
	src.lose_gas(tmp)

/datum/substance/gas/proc/transfer_from(var/datum/substance/gas/target as obj, amount)
	//	transfers [amount] from [target] to [src]
	return target.transfer(src,amount)

/datum/substance/gas/proc/merge_into(var/datum/substance/gas/target as obj)
	return target.transfer(src,target.total())

/datum/substance/gas/proc/turf_add(var/turf/target as turf, amount = -1)
	if(!amount)
		return
	if(!istype(target, /turf) && !istype(target, /obj/move))
		return
	if(locate(/obj/move, target))
		target = locate(/obj/move, target)
	src.transfer(target.gas,amount) // might need TURF_ADD_FRAC
	target.reset_phases()

/datum/substance/gas/proc/turf_take(var/turf/target as turf, amount)
	if(!amount)
		return
	if(!istype(target, /turf) && !istype(target, /obj/move))
		return
	if(locate(/obj/move, target))
		target = locate(/obj/move, target)
	target.gas.transfer(src,amount)	// might need TURF_ADD_FRAC
	target.reset_phases()

/datum/substance/gas/proc/turf_add_all_oxy(var/turf/target as turf)
	var/t_gas = src.total()
	var/t_turf = target.gas.total()

	if(t_gas <= 0)
		return
	if(src.oxygen <= 0)
		return

	target.gas.temp = (target.gas.temp * t_turf + src.oxygen*src.temp) / (t_turf + src.oxygen)
	target.gas.oxygen += src.oxygen
	target.reset_phases()
	src.oxygen = 0

// replaces gas values of src with n - updates during gas_flow step
/datum/substance/gas/proc/replace_by(var/datum/substance/gas/n)
	src.co2 = n.co2
	src.nitrogen = n.nitrogen
	src.oxygen = n.oxygen
	src.plasma = n.plasma
	src.no2 = n.no2
	src.temp  = n.temp

/datum/substance/gas/proc/is_equal(var/datum/substance/gas/T)
	return ((co2==T.co2) && (no2==T.no2) && (oxygen==T.oxygen) && (plasma==T.plasma) && (nitrogen==T.nitrogen) && (temp==T.temp))

// relative "specific heat capacity" of gas contents
/datum/substance/gas/proc/shc()
	return 2*co2 + 1.5*nitrogen + oxygen + 0.5*no2 + 1.2*plasma

/datum/substance/gas/proc/extract_toxs(var/turf/target as turf)
	if(!istype(target,/turf) && !istype(target,/obj/move))
		return
	if(locate(/obj/move, target))
		target = locate(/obj/move, target)

	var/datum/substance/gas/air = new();
	air.co2	= max(0, target.gas.co2)
	air.oxygen = max(0, target.gas.oxygen - O2STANDARD)
	air.no2	= max(0, target.gas.no2)
	air.nitrogen = max(0, target.gas.nitrogen - N2STANDARD)
	air.plasma = max(0, target.gas.plasma)

	var/air_total = air.total()
	var/src_total = src.total()

	if(!air_total)
		return	//	no air to clean
	src.temp = (src_total*src.temp + air_total*target.gas.temp)/(src_total+air_total)
	target.gas.lose_gas(air)
	target.reset_phases()
	src.gain_gas(air)

	//make stored temp closer to nominal (20C)
	src.temp += (T20C - src.temp) / REGULATE_RATE

/datum/chemical/pathogen/proc/process(source as obj)

	return

/datum/chemical/proc/react(S as obj)

	return

/datum/chemical/proc/react_organ(O as obj)

	return

/datum/chemical/proc/injected(M as mob, zone)

	if (zone == null)
		zone = "body"
	return

/datum/chemical/proc/copy_data(var/datum/chemical/C)

	C.molarmass = src.molarmass
	C.density = src.density
	C.chem_formula = src.chem_formula
	return

/datum/chemical/proc/return_property(property)

	switch(property)
		if("moles")
			return src.moles
		if("mass")
			return src.moles * src.molarmass
		if("density")
			return src.density
		if("volume")
			return src.moles * src.molarmass / src.density
		else
	return

/datum/chemical/pl_coag/react(obj/substance/chemical/S as obj)

	var/datum/chemical/l_plas/C = S.chemicals["plasma-l"]
	if (istype(C, /datum/chemical/l_plas))
		if (C.moles < src.moles)
			src.moles -= C.moles
			var/datum/chemical/waste/W = S.chemicals["waste-l"]
			if (istype(W, /datum/chemical/waste))
				W.moles += C.moles
			else
				W = new /datum/chemical/waste(  )
				S.chemicals["waste-l"] = W
				W.moles += C.moles
			//C = null
			del(C)
		else
			C.moles -= src.moles
			var/datum/chemical/waste/W = S.chemicals["waste-l"]
			if (istype(W, /datum/chemical/waste))
				W.moles += src.moles
			else
				W = new /datum/chemical/waste(  )
				S.chemicals["waste-l"] = W
				W.moles += src.moles
			src.moles = 0
		if (src.moles <= 0)
			//SN src = null
			del(src)
			return
	return

/datum/chemical/pl_coag/injected(mob/carbon/M as mob, zone)

	var/volume = src.return_property("volume")
	switch(zone)
		if("eye")
			M.take_eye_damage(volume * 2)
		else
			M.antitoxs += volume * 180
	return

/datum/chemical/l_plas/injected(mob/carbon/M as mob, zone)

	var/volume = src.return_property("volume")
	switch(zone)
		if("eye")
			M.take_eye_damage(volume * 5)
		else
			M.plasma += volume * 6
			for(var/obj/item/weapon/implant/tracking/T in M)
				M.plasma += 1
				//T = null
				del(T)
				//Foreach goto(133)
	return

/datum/chemical/s_tox/injected(mob/carbon/M as mob, zone)

	var/volume = src.return_property("volume")
	switch(zone)
		if("eye")
			M.take_eye_damage(volume * 3)
		else
			M.knockdown_until(volume)
	return

/datum/chemical/epil/injected(mob/carbon/M as mob, zone)
	var/volume = src.return_property("volume")
	switch(zone)
		if("eye")
			M.take_eye_damage(volume * 2)
		else
			//TODO: Make this do something
	return

/datum/chemical/ch_cou/injected(mob/carbon/M as mob, zone)

	var/volume = src.return_property("volume")
	switch(zone)
		if("eye")
			M.take_eye_damage(volume * 2)
		else
			//TODO: Make this do something
	return

/datum/chemical/rejuv/injected(mob/carbon/M as mob, zone)

	var/volume = src.return_property("volume")
	switch(zone)
		if("eye")
			M.heal_eye_damage(volume * 5)
		else
			M.rejuv += volume * 3
			M.knockdown_until(3)
	return
