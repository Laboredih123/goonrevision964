/obj/move/CheckPass(O as mob|obj)
	return !src.density

/obj/move/proc/reset_phases()
	phase1.copy_all(gas)
	phase2.copy_all(gas)

/obj/move/proc/unburn()
	icon_state = initial(icon_state)
	luminosity = 0

/obj/move/New()
	gas.oxygen = src.oxygen;
	gas.plasma = src.poison;
	gas.nitrogen = src.n2
	reset_phases()

	if((src.x & 1) == (src.y & 1))
		src.checkfire = 0
	..()

/obj/move/interact(var/mob/user as mob)
	if(!user.canmove) return
	if(!user.pulling) return
	if(usr.is_handcuffed()) return
	if(user.pulling.anchored) return
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
	if(locate(/obj/shuttle/door, src.loc))
		var/obj/shuttle/door/D = locate(/obj/shuttle/door, src.loc)
		src.updatecell = !D.density
		if(!src.updatecell)
			return

	src.checkfire = !src.checkfire
	UpdateGasses(src, src.FindTurfs())

/obj/move/proc/FindTurfs()
	var/list/L = list()
	for(var/MyDir in gas.Neighbors())
		var/turf/T = get_step(src.loc, MyDir)
		if(!gas.CheckAirflow(MyDir,T)) continue

		var/obj/move/O = locate(/obj/move,T)
		if(O) if(O.updatecell) L += O
		else  L += T

	return L

/obj/move/wall/process()
	src.updatecell = 0
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

/turf/proc/unburn()
	icon_state = initial(icon_state)
	luminosity = 0

/turf/New()				//	intitalizes turf with checkfire/reset_variables
	gas.nitrogen = src.n2
	gas.oxygen = src.oxygen;
	gas.plasma = src.poison;
	gas.temp = src.temp
	reset_phases()

	if((src.x & 1) == (src.y & 1))
		src.checkfire = 0
	for(var/atom/movable/AM as mob|obj in src)
		src.Entered(AM)
	return ..()

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

/turf/proc/FindTurfs()
	var/list/L = list()
	if(locate(/obj/move, src))
		return list()
	for(var/dir in gas.Neighbors(src))
		var/turf/T = get_step(src, dir)
		if(!gas.CheckAirflow(dir,T))
			continue
		var/obj/move/O = locate(/obj/move,T)
		if(O)
			if(O.updatecell)
				L += O
		else
			L += T
	return L

/turf/conduction()
	var/difftemp = 0
	var/list/L = gas.ConductionLinks(src)

	for(var/dir in L)
		var/turf/T = get_step(src,text2num(dir));
		if(T)
			difftemp += (T.phase1.temp-src.gas.temp)/(10*L[dir])
	if(difftemp)
		src.gas.temp += difftemp

/datum/substance/gas/proc/Neighbors(var/turf/T)
	var/list/L = cardinal.Copy()
	for(var/obj/window/D in T)
		if(!D.density)
			continue
		if(D.dir == SOUTHWEST)
			return list()
		L -= D.dir

	for(var/obj/machinery/door/window/D in T)
		if(!D.density)
			continue
		if(D.dir & (EAST|WEST))
			L -= SOUTH	//	door blocks south travel
		if(D.dir & (NORTH|SOUTH))
			L -= EAST	//	door block east travel

	for(var/obj/machinery/door/window/alt/D in T)
		if(!D.density)
			continue
		if(D.dir & (EAST|WEST))
			L -= NORTH	//	door blocks north travel
		if(D.dir & (NORTH|SOUTH))
			L -= WEST	//	door block west travel

	return L

/datum/substance/gas/proc/ConductionLinks(var/turf/T)
	var/list/cond = new()
	for(var/obj/window/D in T)
		if(!D.density)
			continue
		if(D.dir == SOUTHWEST)
			return list()
		cond[num2text(D.dir)] += 1 + D.reinf

	for(var/obj/machinery/door/window/D in T)
		if(!D.density)
			continue
		if(D.dir & (EAST|WEST))
			cond[num2text(SOUTH)] += 1;
		if(D.dir & (NORTH|SOUTH))
			cond[num2text(EAST)] += 1;

	for(var/obj/machinery/door/window/alt/D in T)
		if(!D.density)
			continue
		if(D.dir & (EAST|WEST))
			cond[num2text(NORTH)] += 1;
		if(D.dir & (NORTH|SOUTH))
			cond[num2text(WEST)] += 1;

	return cond

/datum/substance/gas/proc/CheckAirflow(var/srcDir, var/turf/target)
	if(!target)
		return 0
	if(!target.updatecell)
		return 0

	srcDir = turn(srcDir, 180)
	if(srcDir & SOUTH || srcDir & WEST)
		for(var/obj/machinery/door/window/D in target)
			if(!D.density)
				continue
			if(srcDir & SOUTH && D.dir & (EAST|WEST))
				return 0
			if(srcDir & WEST  && D.dir & (NORTH|SOUTH))
				return 0

	if(srcDir & NORTH || srcDir & EAST)
		for(var/obj/machinery/door/window/alt/D in target)
			if(!D.density)
				continue
			if(srcDir & NORTH && D.dir & (EAST|WEST))
				return 0
			if(srcDir & EAST  && D.dir & (NORTH|SOUTH))
				return 0

	for(var/obj/window/D in target)
		if(!D.density) continue;
		if(D.dir == SOUTHWEST)
			return 0
		if(D.dir == srcDir)
			return 0
	return 1

/proc/UpdateGasses(var/turf/loc as turf, var/list/neighbors)
	var/divisor = 1
	var/datum/substance/gas/TPhase	= null
	var/datum/substance/gas/SPhase	= ((cellcontrol.var_swap)?loc.phase1 : loc.phase2)

	var/space = 0
	var/burn = loc.firelevel >= 10
	var/adiff = null

	var/airdir = null
	var/airforce = 0

	for(var/turf/T in neighbors)
		if(istype(T, /turf/space))
			if(!loc.checkfire)
				airforce = T.gas.total() + 25000
				airdir = get_dir(loc, T)
			space = 1;	break
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
		var/PlasmaConverter = min(loc.gas.co2,loc.gas.plasma)
		loc.gas.co2		-= PlasmaConverter
		loc.gas.oxygen	+= PlasmaConverter
		loc.gas.plasma	-= PlasmaConverter
	else
		var/BurnedOxygen = min(loc.gas.oxygen,5000)
		loc.gas.co2		+= BurnedOxygen
		loc.gas.oxygen	-= BurnedOxygen

	if(loc.firelevel < 900000)
		loc.firelevel = 0
		if(loc.icon_state == "burning")
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
		loc.gas.temp += (T20C - loc.gas.temp) / FIRERATE
		loc.firelevel = 0
