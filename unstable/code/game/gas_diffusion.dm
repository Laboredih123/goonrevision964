
#define TURF_ADD_FRAC 0.95		//cooling due to release of gas into tile
#define TURF_TAKE_FRAC 1.06		//heating due to pressurization into pipework

/datum/substance/gas/proc/clear()
	src.nitrogen = 0
	src.oxygen = 0
	src.plasma = 0
	src.no2 = 0
	src.co2 = 0

/datum/substance/gas/proc/total()
	return (src.co2 + src.oxygen + src.plasma + src.no2 + src.nitrogen)

/datum/substance/gas/proc/add_gas(C,N,O,P,S)
	src.nitrogen += N
	src.oxygen += O
	src.plasma += P
	src.no2 += S
	src.co2 += C

/datum/substance/gas/proc/rem_gas(C,N,O,P,S)
	src.nitrogen -= N
	src.oxygen -= O
	src.plasma -= P
	src.no2 -= S
	src.co2 -= C

/datum/substance/gas/proc/set_gas(C,N,O,P,S)
	src.nitrogen = N
	src.oxygen = O
	src.plasma = P
	src.no2 = S
	src.co2 = C

/datum/substance/gas/proc/multiply_gas(F)
	src.nitrogen *= F
	src.oxygen *= F
	src.plasma *= F
	src.no2 *= F
	src.co2 *= F

/datum/substance/gas/proc/multiply_all(F)
	src.nitrogen *= F
	src.oxygen *= F
	src.plasma *= F
	src.no2 *= F
	src.co2 *= F
	temp *= F

/datum/substance/gas/proc/gain_gas(var/datum/substance/gas/T)
	src.nitrogen += T.nitrogen
	src.oxygen += T.oxygen
	src.plasma += T.plasma
	src.no2 += T.no2
	src.co2 += T.co2

/datum/substance/gas/proc/lose_gas(var/datum/substance/gas/T)
	src.nitrogen -= T.nitrogen
	src.oxygen -= T.oxygen
	src.plasma -= T.plasma
	src.no2 -= T.no2
	src.co2 -= T.co2

/datum/substance/gas/proc/copy_gas(var/datum/substance/gas/T, amount)
	src.nitrogen = T.nitrogen
	src.oxygen = T.oxygen
	src.plasma = T.plasma
	src.no2 = T.no2
	src.co2 = T.co2

/datum/substance/gas/proc/copy_cop(var/datum/substance/gas/T)
	src.oxygen = T.oxygen
	src.plasma = T.plasma
	src.co2 = T.co2

/datum/substance/gas/proc/gain_all(var/datum/substance/gas/T)
	src.nitrogen += T.nitrogen
	src.oxygen += T.oxygen
	src.plasma += T.plasma
	src.no2 += T.no2
	src.co2 += T.co2
	src.temp += T.temp

/datum/substance/gas/proc/copy_all(var/datum/substance/gas/T)
	src.nitrogen = T.nitrogen
	src.oxygen = T.oxygen
	src.plasma = T.plasma
	src.no2 = T.no2
	src.co2 = T.co2
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
	if(!istype(target, /turf))
		return
	src.transfer(target.gas,amount) // might need TURF_ADD_FRAC
	target.reset_phases()

/datum/substance/gas/proc/turf_copy(var/turf/target as turf, amount = -1) //copies amount from target into this
	if(!amount)
		return
	if(!istype(target, /turf))
		return
	var/datum/substance/gas/T = target.gas
	var/frac = 0
	if(T.total() != 0)
		frac = amount / T.total()
	src.nitrogen += T.nitrogen * frac
	src.oxygen += T.oxygen * frac
	src.plasma += T.plasma * frac
	src.no2 += T.no2 * frac
	src.co2 += T.co2 * frac

/datum/substance/gas/proc/turf_take(var/turf/target as turf, amount)
	if(!amount)
		return
	if(!istype(target, /turf))
		return
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
	src.nitrogen = n.nitrogen
	src.oxygen = n.oxygen
	src.plasma = n.plasma
	src.no2 = n.no2
	src.co2 = n.co2
	src.temp  = n.temp

/datum/substance/gas/proc/is_equal(var/datum/substance/gas/T)
	return ((co2==T.co2) && (no2==T.no2) && (oxygen==T.oxygen) && (plasma==T.plasma) && (nitrogen==T.nitrogen) && (temp==T.temp))

// relative "specific heat capacity" of gas contents
/datum/substance/gas/proc/shc()
	return 2*co2 + 1.5*nitrogen + oxygen + 0.5*no2 + 1.2*plasma

/datum/substance/gas/proc/extract_toxs(var/turf/target as turf)
	if(!istype(target,/turf))
		return

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

/datum/substance/gas/proc/DiffusionLinks(var/turf/T)
	if(T.density && !T.updatecell) // if this is a dense turf (wall, closed false_wall etc, just return nothing)
		return list()

	var/list/L = cardinal.Copy()
	for(var/obj/window/D in T)
		if(!D.density)
			continue
		if(D.dir == SOUTHWEST)
			return list()
		L -= D.dir

	for(var/obj/machinery/door/D in T)
		if(!D.density)
			continue
		if(istype(D, /obj/machinery/door/window))
			if(D.dir & (EAST|WEST))
				L -= istype(D, /obj/machinery/door/window/alt) ? NORTH : SOUTH
			if(D.dir & (NORTH|SOUTH))
				L -= istype(D, /obj/machinery/door/window/alt) ? WEST : EAST
		else
			// it's another door, such as a pod/fire/airlock, no airflow is possible
			return list()

	var/list/links = list()
	for(var/dir in L)
		var/turf/N = get_step(T,dir)
		if(N && CheckAirflow(dir,N) == 1)
			links += N
	return links

/datum/substance/gas/proc/ConductionLinks(var/turf/T)
	var/list/cond = new()
	for(var/obj/window/D in T)
		if(!D.density)
			continue
		if(D.dir == SOUTHWEST)
			return list()
		cond[get_step(T,D.dir)] += 1+D.reinf

	for(var/obj/machinery/door/window/D in T)
		if(!D.density)
			continue
		if(D.dir & (EAST|WEST))
			cond[get_step(T,D.dir)] += 1
		if(D.dir & (NORTH|SOUTH))
			cond[get_step(T,D.dir)]  += 1

	for(var/obj/machinery/door/window/alt/D in T)
		if(!D.density)
			continue
		if(D.dir & (EAST|WEST))
			cond[get_step(T,D.dir)] += 1
		if(D.dir & (NORTH|SOUTH))
			cond[get_step(T,D.dir)]  += 1

	cond -= 0 // we inserted possibly null get_step(T,D.dir)
	return cond

/datum/substance/gas/proc/CheckAirflow(var/srcDir, var/turf/target)
	if(!target)
		return 0
	if(!target.updatecell)
		return 0

	srcDir = turn(srcDir, 180)

	for(var/obj/window/D in target)
		if(!D.density)
			continue
		if(D.dir == SOUTHWEST)
			return 0
		if(D.dir == srcDir)
			return 0

	for(var/obj/machinery/door/D in target)
		if(!D.density)
			continue
		if(istype(D, /obj/machinery/door/window))
			if(istype(D, /obj/machinery/door/window/alt))
				if((srcDir & NORTH) && (D.dir & (EAST|WEST)))
					return 0
				if((srcDir & WEST ) && (D.dir & (NORTH|SOUTH)))
					return 0
			else
				if((srcDir & SOUTH) && (D.dir & (EAST|WEST)))
					return 0
				if((srcDir & EAST ) && (D.dir & (NORTH|SOUTH)))
					return 0
		else
			// it's a real, air blocking door
			return 0
	return 1

/proc/UpdateGasses(var/turf/loc as turf, var/list/neighbors)
	if(!loc)
		return
	if(!neighbors.len)
		return

	if(loc.equilibrium)
		for(var/turf/T in neighbors)
			if(!T.equilibrium)
				loc.equilibrium = 0
		if(loc.equilibrium)
			return	// no need for updates!

	var/divisor = 1
	var/datum/substance/gas/TPhase	= null
	var/datum/substance/gas/SPhase	= ((cellcontrol.var_swap)?loc.phase1 : loc.phase2)

	var/space = 0
	var/burn = loc.firelevel >= 10
	var/adiff = null

	var/airdir = null
	var/airforce= 0

	for(var/turf/T in neighbors)
		if(istype(T, /turf/space))
			if(!loc.checkfire)
				airforce = T.gas.total() + 25000
				airdir = get_dir(loc, T)
			space = 1;
			break

		divisor++
		if(T.firelevel >= 900000.0)
			burn = 1
		TPhase = (cellcontrol.var_swap) ? T.phase1 : T.phase2
		loc.gas.gain_all(TPhase)

		if(loc.checkfire)
			continue

		adiff = SPhase.total() - TPhase.total()
		if(airforce > adiff)
			continue
		airdir = get_dir(loc,T)
		airforce = adiff;

	if(!loc.checkfire && airforce > 25000)
		for(var/atom/movable/AM in loc)
			if(!AM.anchored && AM.weight <= airforce)
				step(AM, airdir)

	if(space)
		loc.gas.clear()
		loc.firelevel = 0
		loc.overlays = null
		if(loc.icon_state == "burning")
			loc.unburn()
		if(loc.gas.temp > TCMB)
			loc.gas.temp /= 2
		SPhase.copy_all(loc.gas)
		return

	loc.gas.multiply_all(1/divisor)

	if(loc.gas.plasma > 100000.0)
		loc.overlays = list(plmaster)
	else if(loc.gas.no2 > 101000.0)
		loc.overlays = list(slmaster)
	else
		loc.overlays = null
	if(burn)
		loc.firelevel = loc.gas.oxygen + loc.gas.plasma

	if(!loc.checkfire)
		//	Why does plasma annihilate carbon?
		var/PlasmaConverter = min(loc.gas.co2,loc.gas.plasma)
		loc.gas.co2		-= PlasmaConverter
		loc.gas.oxygen	+= PlasmaConverter
		loc.gas.plasma	-= PlasmaConverter
	else if(loc.firelevel > 900000)
		var/OxygenBurned = min(loc.gas.oxygen,5000)
		loc.gas.co2		+= OxygenBurned
		loc.gas.oxygen	-= OxygenBurned

	if(loc.firelevel < 900000)
		if(loc.icon_state == "burning")
			loc.firelevel = 0
			loc.unburn()
	else
		loc.luminosity = 2
		loc.icon_state = "burning"

		// heating from fire
		loc.gas.temp += (loc.firelevel/FIREQUOT+FIREOFFSET - loc.gas.temp) / FIRERATE

		if(locate(/obj/effects/water, loc))
			loc.firelevel = 0
		for(var/atom/movable/A in loc)
			A.burn(loc.firelevel)

	SPhase.copy_all(loc.gas)

	if((locate(/obj/effects/water, loc) || loc.firelevel < 900000.0))
		//	water soothes the burning
		loc.gas.temp += (T20C - loc.gas.temp) / FIRERATE

