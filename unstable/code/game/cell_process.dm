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
		src.updatelinks()

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
	src.checkfire = !src.checkfire
	UpdateGasses(src, src.FindTurfs())

/obj/move/proc/FindTurfs()
	var/list/L = list()
	for(var/turf/T in src.DiffuseAir)
		var/obj/move/O = locate(/obj/move,T)
		if(O) if(O.updatecell) L += O
		else  L += T
	return L

/obj/move/proc/updatelinks()
	if(!src.loc)
		return
	DiffuseAir = gas.DiffusionLinks(src.loc)
	ConductHeat= gas.ConductionLinks(src.loc)

/obj/move/wall/blob_act()
	del(src)

/obj/move/wall/New()
	var/F = locate(/obj/move/floor, src.loc)
	if(F) del(F)

/turf/proc/report()
	return "[src.type] [x] [y] [z]"

/turf/proc/reset_phases()
	phase1.copy_all(gas)
	phase2.copy_all(gas)
	equilibrium = 0

/turf/proc/match_gasses(var/turf/target)
	equilibrium = 0
	gas.copy_all(target.gas)
	phase1.copy_all(target.phase1)
	phase2.copy_all(target.phase2)

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

	..()

	spawn(5)
		src.updatelinks()

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

/turf/proc/updatelinks()	//	update our links
	DiffuseAir = gas.DiffusionLinks(src)
	ConductHeat= gas.ConductionLinks(src)

	for(var/turf/T in DiffuseAir)
		if(!TestEquilibrium(T))
			src.equilibrium = 0
			return
	src.equilibrium = 1

/turf/proc/buildlinks()		//	update our neighbors' links
	src.updatelinks()
	for(var/dir in cardinal.Copy())
		var/turf/N = get_step(src,dir)
		if(N)
			N.updatelinks()

/turf/proc/FindTurfs()
	var/list/L = list()
	if(locate(/obj/move, src))
		return list()
	for(var/turf/T in src.DiffuseAir)
		var/obj/move/O = locate(/obj/move,T)
		if(!O)
			L += T
		else if(O.updatecell)
			L += O
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

/turf/space/updatelinks()
	return

