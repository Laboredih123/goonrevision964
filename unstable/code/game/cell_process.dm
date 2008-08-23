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

/turf/space/interact(mob/user as mob)

	if ((user.is_handcuffed() || !( user.pulling )))
		return
	if (user.pulling.anchored)
		return
	if ((user.pulling.loc != user.loc && get_dist(user, user.pulling) > 1))
		return
	if (ismob(user.pulling))
		var/mob/M = user.pulling
		var/t = M.pulling
		M.pulling = null
		step(user.pulling, get_dir(user.pulling.loc, src))
		M.pulling = t
	else
		step(user.pulling, get_dir(user.pulling.loc, src))
	return

/turf/space/attackby(obj/item/weapon/tile/T as obj, mob/user as mob)

	if (istype(T, /obj/item/weapon/tile))
		T.build(src)
		T.amount--
		T.add_fingerprint(user)
		if (T.amount < 1)
			user.u_equip(T)
			//SN src = null
			del(T)
			return
	return

/turf/space/updatecell()
	return
/turf/space/conduction()
	return

/turf/space/Entered(atom/movable/A as mob|obj)

	..()
	if ((!(A) || src != A.loc || istype(null, /obj/beam)))
		return

	if (!(A.last_move))
		return

	if (locate(/obj/move, src))
		return 1

	if ((istype(A, /mob/carbon) && src.x > 2 && src.x < (world.maxx - 1)))
		var/mob/carbon/M = A

		if ((!( M.is_handcuffed()) && M.canmove))
			var/prob_slip = 5

			if (locate(/obj/grille, oview(1, M)))
				if (!( M.l_hand ))
					prob_slip -= 2
				else if (M.l_hand.w_class <= 2)
					prob_slip -= 1

				if (!( M.r_hand ))
					prob_slip -= 2
				else if (M.r_hand.w_class <= 2)
					prob_slip -= 1
			else if (locate(/obj/move/wall, oview(1, M)) || locate(/turf/station, oview(1, M)))
				if (!( M.l_hand ))
					prob_slip -= 1
				else if (M.l_hand.w_class <= 2)
					prob_slip -= 0.5

				if (!( M.r_hand ))
					prob_slip -= 1
				else if (M.r_hand.w_class <= 2)
					prob_slip -= 0.5
			prob_slip = round(prob_slip)
			if (prob_slip < 5) //next to something, but they might slip off
				if (prob(prob_slip))
					M << "\blue <B>You slipped!</B>"
					M.inertia_dir = M.last_move
					step(M, M.inertia_dir)
					return
				else
					M.inertia_dir = 0 //no inertia
			else //not by a wall or anything, they just keep going
				spawn(5)
					if ((A && !( A.anchored ) && A.loc == src))
						if(M.inertia_dir) //they keep moving the same direction
							step(M, M.inertia_dir)
						else
							M.inertia_dir = M.last_move
							step(M, M.inertia_dir)
		else //can't move, they just keep going (COPY PASTED CODE WOO)
			spawn(5)
				if ((A && !( A.anchored ) && A.loc == src))
					if(M.inertia_dir) //they keep moving the same direction
						step(M, M.inertia_dir)
					else
						M.inertia_dir = M.last_move
						step(M, M.inertia_dir)
	if (src.x <= 2)
		if(istype(A, /obj/meteor))
			del(A)
			return
		A.z = 3
		A.x = world.maxx - 2
		spawn (0)
			if ((A && A.loc))
				A.loc.Entered(A)
	else if (A.x >= (world.maxx - 1))
		if(istype(A, /obj/meteor))
			del(A)
			return
		A.z = 3
		A.x = 3
		spawn (0)
			if ((A && A.loc))
				A.loc.Entered(A)
	else if (src.y <= 2)
		if(istype(A, /obj/meteor))
			del(A)
			return
		A.z = 3
		A.y = world.maxy - 2
		spawn (0)
			if ((A && A.loc))
				A.loc.Entered(A)
	else if (A.y >= (world.maxy - 1))
		if(istype(A, /obj/meteor))
			del(A)
			return
		A.z = 3
		A.y = 3
		spawn (0)
			if ((A && A.loc))
				A.loc.Entered(A)
