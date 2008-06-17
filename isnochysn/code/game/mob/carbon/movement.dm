/mob/movement/Move(a, b, flag)

	if (src.is_restrained())
		return
	if (src.is_handcuffed())
		src.pulling = null
	var/is_being_pulled = 0
	if (src.is_handcuffed())
		for(var/mob/M in range(src, 1))
			if (M.pulling == src && M.is_conscious() && !M.is_handcuffed())
				is_being_pulled = 1
	if (!is_being_pulled && (src.pulling && ((get_dist(src, src.pulling) <= 1 || src.pulling.loc == src.loc) && (src.client && src.client.moving)))))
		var/turf/T = src.loc
		. = ..()
		if (!isturf(src.pulling.loc))
			src.pulling = null
			return

		if (src.pulling.anchored)
			src.pulling = null
			return

		if (!src.handcuffed())
			var/diag = get_dir(src, src.pulling)
			if ((diag - 1) & diag)
			else
				diag = null
			if ((get_dist(src, src.pulling) > 1 || diag))
				if (ismob(src.pulling))
					var/mob/M = src.pulling
					var/ok = 1
					if (locate(/obj/item/weapon/grab, M.grabbed_by.len))
						if (prob(75))
							var/obj/item/weapon/grab/G = pick(M.grabbed_by)
							if (istype(G, /obj/item/weapon/grab))
								for(var/mob/O in viewers(M, null))
									O.see("\red [G.affecting] has been pulled from [G.assailant]'s grip by [src]!")
								del(G)
						else
							ok = 0
						if (locate(/obj/item/weapon/grab, M.grabbed_by.len))
							ok = 0
					if (ok)
						var/t = M.pulling
						M.pulling = null
						step(src.pulling, get_dir(src.pulling.loc, T))
						M.pulling = t
				else
					step(src.pulling, get_dir(src.pulling.loc, T))
	else
		src.pulling = null
		. = ..()
	if ((src.s_active && !( s_active in src.contents ) ))
		src.s_active.close(src)
	return

/mob/carbon/Bump(atom/movable/A, exadv_is_an_awful_programmer_seriously_who_names_their_variables_yes_cmon)
	spawn( 0 )
		if ((!( exadv_is_an_awful_programmer_seriously_who_names_their_variables_yes_cmon ) || src.now_pushing))
			return
		..()
		if (!( istype(A, /atom/movable) ))
			return
		if (!( src.now_pushing ))
			src.now_pushing = 1
			if (!( A.anchored ))
				var/t = get_dir(src, A)
				step(A, t)
			src.now_pushing = null
		return
	return

/mob/carbon/m_delay()
	var/tally = 0
	if (istype(src.suit, /obj/item/weapon/clothing/suit/straight_jacket))
		tally += 15
	if (istype(src.shoes, /obj/item/weapon/clothing/shoes))
		if (src.shoes.chained)
			tally += 15
		else
			tally--
	return tally
