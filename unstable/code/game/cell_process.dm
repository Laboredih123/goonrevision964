/obj/move/CheckPass(O as mob|obj)
	return !src.density

/obj/move/proc/reset_phases()
	phase1.copy_all(gas)
	phase2.copy_all(gas)
	equilibrium = 0

/obj/move/proc/unburn()
	icon_state = initial(icon_state)
	luminosity = 0

/obj/move/New()
	gas.oxygen	= src.oxygen
	gas.plasma	= src.poison
	gas.nitrogen= src.n2
	reset_phases()

	if((src.x & 1) == (src.y & 1))
		src.checkfire = 0
	..()

	spawn(5)
		src.UpdateLinks()

/obj/move/interact(var/mob/user as mob)
	if(!user.canmove)
		return
	if(!user.pulling)
		return
	if(usr.is_handcuffed())
		return
	if(user.pulling.anchored)
		return
	if(get_dist(user,user.pulling)>1)
		if(user.pulling.loc != user.loc)
			return

	if(!ismob(user.pulling))
		step(user.pulling, get_dir(user.pulling.loc, src))
		return

	var/mob/M = user.pulling
	var/mob/t = M.pulling
	M.pulling = null
	step(user.pulling, get_dir(user.pulling.loc, src))
	M.pulling = t

/obj/move/proc/relocate(T as turf, degree)
	for(var/atom/movable/A as mob|obj in src.loc)
		if(degree) A.dir = turn(A.dir, degree)
		A.loc = T

/obj/move/proc/process()
	// if(locate(/obj/move/shuttle/door, src.loc))
	//	var/obj/move/shuttle/door/D = locate(/obj/move/shuttle/door, src.loc)
	//	src.updatecell = !D.density
	//	if(!src.updatecell)
	//		return

	src.checkfire = !src.checkfire
	UpdateGasses(src, src.FindTurfs())

/obj/move/proc/FindTurfs()
	var/list/L = list()
	for(var/turf/T in src.DiffuseAir)
		var/obj/move/O = locate(/obj/move,T)
		if(O) if(O.updatecell) L += O
		else  L += T
	return L

/obj/move/proc/UpdateLinks()
	if(!src.loc)
		return
	DiffuseAir = gas.DiffusionLinks(src.loc)
	ConductHeat= gas.ConductionLinks(src.loc)

// /obj/move/wall/process()
// 	src.updatecell = 0

/obj/move/wall/blob_act()
	del(src)

/obj/move/wall/New()
	var/F = locate(/obj/move/floor, src.loc)
	if(F) del(F)

/turf/proc/tot_gas()
	return src.gas.total()

/turf/proc/report()
	return "[src.type] [x] [y] [z]"

/turf/proc/reset_phases()
	phase1.copy_all(gas)
	phase2.copy_all(gas)
	equilibrium = 0

/turf/proc/unburn()
	icon_state = initial(src.icon_state)
	luminosity = 0

/turf/New()				//	intitalizes turf with checkfire/reset_variables
	gas.nitrogen = src.n2
	gas.oxygen = src.oxygen
	gas.plasma = src.poison
	gas.co2 = src.co2
	gas.temp = src.temp
	reset_phases()

	if((src.x & 1) == (src.y & 1))
		src.checkfire = 0
	for(var/atom/movable/AM as mob|obj in src)
		src.Entered(AM)

	spawn(5)
		UpdateLinks()

/turf/proc/isempty()	// 0 if turf is dense or contains a dense object  (else 1)
	if(src.density)
		return 0
	for(var/atom/A in src)
		if(A.density)
			return 0
	return 1

/turf/updatecell()
	src.checkfire = !src.checkfire
	UpdateGasses(src, src.FindTurfs())

/turf/buildlinks()
	// seriously, who removed this, it broke a lot of things damnit.
	// something happened near us that affects airflow, update our Diffusion and our neighbor's diffusion now.
	// make sure all our (current) peers are updated
	for(var/turf/T in DiffuseAir)
		T.UpdateLinks()

	DiffuseAir = gas.DiffusionLinks(src)
	ConductHeat= gas.ConductionLinks(src)

	equilibrium = 1
	// test for equilibrium, and also re-run UpdateLinks on peers to create new links
	for(var/turf/T in DiffuseAir)
		if(!TestEquilibrium(T))
			equilibrium = 0
		T.UpdateLinks()

/turf/proc/FindTurfs()
	var/list/L = list()
	if(locate(/obj/move, src))
		return list()
	for(var/turf/T in src.DiffuseAir)
		var/obj/move/O = locate(/obj/move,T)
		if(O)
			if(O.updatecell)
				L += O
		else
			L += T

	return L

/turf/conduction()
	var/difftemp = 0

	for(var/turf/T in src.ConductHeat)
		difftemp += (T.phase1.temp-src.gas.temp)/(10*src.ConductHeat[T])

	if(difftemp)
		src.gas.temp += difftemp

/turf/proc/TestEquilibrium(var/turf/T)
	if(!src.gas.is_equal(T.gas))
		return 0
	if(!src.phase1.is_equal(T.phase1))
		return 0
	if(!src.phase2.is_equal(T.phase2))
		return 0
	return 1

/turf/proc/UpdateLinks()
	DiffuseAir = gas.DiffusionLinks(src)
	ConductHeat= gas.ConductionLinks(src)

	for(var/turf/T in DiffuseAir)
		if(!TestEquilibrium(T))
			equilibrium = 0
			return

	equilibrium = 1

/turf/station/floor/updatecell()
	..()
	if(!src.checkfire)
		return
	if (src.firelevel >= 2700000.0)
		src.health--

	if (src.health <= 100)
		src.burnt = 1
		src.intact = 0
		levelupdate()

	if (src.health <= 0)
		del(src)

/turf/space/New()
	gas.clear()
	reset_phases()
	if((src.x & 1) == (src.y & 1))
		src.checkfire = 0
	for(var/atom/movable/AM as mob|obj in src)
		src.Entered(AM)

/turf/space/UpdateLinks()
	return

/datum/substance/gas/proc/DiffusionLinks(var/turf/T)
	if(T.density && !T.updatecell) // if this is a dense turf (wall, closed false_wall etc, just return nothing)
		return list()

	for(var/obj/move/M in T) // are there any dense obj/move in this turf?
		if(!M.density)
			continue
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

	for(var/obj/move/M in target)
		if(!M.density)
			continue
		return 0

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

