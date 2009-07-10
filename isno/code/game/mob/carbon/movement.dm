/mob/carbon/Move(NewLoc, Dir, flag)
	if(src.buckled)							{	src.pulling = null;		return 0		}
	if(src.is_handcuffed())
		for(var/mob/M in range(src, 1))
			if(M.pulling == src && M.can_use_hands())
				if(prob(75))				{	src.pulling = null;		return 0		}

	if(src.s_active && !(s_active in src.contents)) src.s_active.close(src)
	if(!src.pulling)						{	src.pulling = null;		return ..()		}
	if(!src.can_use_hands())				{	src.pulling = null;		return ..()		}
	if(src.pulling.anchored)				{	src.pulling = null;		return ..()		}
	if(!isturf(src.pulling.loc))			{	src.pulling = null;		return ..()		}
	if(get_dist(src,src.pulling) > 1)		{	src.pulling = null;		return ..()		}
	if(!src.client || !src.client.moving)	{	src.pulling = null;		return ..()		}

	var/turf/oldloc = src.loc
	. = ..()
	var/dir = get_dir(src, src.pulling)
	if(get_dist(src, src.pulling) <= 1 && !(dir & dir - 1)) return // dir & dir - 1 is true iff it's a cardinal dir
	if(!istype(src.pulling, /mob/carbon))
		step(src.pulling, get_dir(src.pulling,oldloc))
		return

	var/mob/carbon/M = src.pulling
	if(locate(/obj/item/weapon/grab, M.grabbed_by))
		if(!prob(75)) return
		var/obj/item/weapon/grab/G = pick(M.grabbed_by)
		for(var/mob/O in viewers(null, M))
			O.see("<font color='red'>[G.affecting] has been pulled from [G.assailant]'s grip by [src]!</font>")
		del(G)

	var/t = M.pulling
	M.pulling = null
	step(src.pulling, get_dir(src.pulling,oldloc))
	M.pulling = t

/mob/carbon/Bump(atom/movable/A, can_bump)
	if(!can_bump)		return
	if(src.now_pushing)	return

	..()
	if(!istype(A, /atom/movable)) return
	spawn(0)
		if(!src.now_pushing)
			src.now_pushing = 1
			if(A && !A.anchored)
				var/t = get_dir(src, A)
				step(A, t)
			src.now_pushing = null

/mob/carbon/CheckPass(mob/carbon/M as mob)
	if(istype(M,/mob/carbon))
		if(src.other_mobs)
			if(M.other_mobs)
				return 1
	return (!M.density || !src.density || src.lying)

/mob/carbon/proc/m_delay()
	var/tally = 0
	if(src.appearance == APPEARANCE_QUIVERING_MASS)	 //	blobs are very slow
		tally += 100
	if(istype(src.suit, /obj/item/weapon/clothing/suit/firesuit))	//	firesuits slow you down a bit
		tally += 5
	if(istype(src.suit, /obj/item/weapon/clothing/suit/sp_suit))		//	space suits slow you down a bit
		tally += 5
	if(istype(src.suit, /obj/item/weapon/clothing/suit/straight_jacket))
		tally += 15
	if(istype(src.shoes, /obj/item/weapon/clothing/shoes))
		if(src.shoes.chained)	tally += 15
		else					tally--
	return tally
