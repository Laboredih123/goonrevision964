/client
	var/datum/preferences/prefs = new()

/client/Del()
	world.log_access("Logout: [src.key]")
	..()

/client/New()
	//TODO: get rid of mob/prespawn in favor of doing everything with clients
	world.log_access("Login: [src.key] from [src.address]")

	src << "\blue <B>[join_motd]</B>"

	src.authorize()

	if (config.log_access)
		for (var/mob/M in world)
			if(M.client == src)
				continue
			if(M.client && M.client.address == src.address)
				world.log_access("Notice: [src.key] has same IP address as [M.key]")
			else if (M.last_known_ip && M.last_known_ip == src.address && M.ckey != src.ckey)
				world.log_access("Notice: [src.key] has same IP address as [M.key] did (M.key is no longer logged in).")
				if (M.ckey in banned)
					world.log_access("Further notice: [M.key] was banned.")
	if (((world.address == src.address || !(src.address)) && !(host)))
		host = src.key
		world.update_stat()

	winset(src,"mainwindow.saybutton","is-checked = true")
	winset(src,"mainwindow.input","command=\"!say \\\"\"")

	..()

/client/proc/reset_view(atom/A)
	if (istype(A, /atom/movable))
		src.perspective = EYE_PERSPECTIVE
		src.eye = A
	else if (isturf(src.mob.loc))
		src.eye = src.mob
		src.perspective = MOB_PERSPECTIVE
	else
		src.perspective = EYE_PERSPECTIVE
		src.eye = src.mob.loc
	return

/client/Northeast()
	if(istype(src.mob, /mob/carbon))
		var/mob/carbon/M = src.mob
		M.swap_hand()
	return

/client/Southeast()
	if(istype(src.mob, /mob/carbon))
		var/mob/carbon/M = src.mob
		var/obj/item/weapon/W = M.equipped()
		if (W)
			W.attack_self(M)
	return

/client/Northwest()
	if(istype(src.mob, /mob/carbon))
		var/mob/carbon/M = src.mob
		M.drop_item_v()
	return

/client/Center()

	if (isobj(src.mob.loc))
		var/obj/O = src.mob.loc
		if (src.mob.canmove)
			return O.relaymove(src.mob, 16)
	return

/client/Move(n, direct)
	if(src.moving)
		return 0
	if(!src.mob)
		return
	if(src.mob.is_dead)
		return
	if(world.time < src.move_delay)
		return

	if(istype(src.mob, /mob/silicon))
		return AIMove(n, direct, src.mob)
	if(istype(src.mob, /mob/carbon))
		var/mob/carbon/M = src.mob
		if (locate(/obj/item/weapon/grab, M.grabbed_by))
			var/list/grabbing = list()
			if (istype(M.l_hand, /obj/item/weapon/grab))
				var/obj/item/weapon/grab/G = M.l_hand
				grabbing += G.affecting
			if (istype(M.r_hand, /obj/item/weapon/grab))
				var/obj/item/weapon/grab/G = M.r_hand
				grabbing += G.affecting
			for(var/obj/item/weapon/grab/G in M.grabbed_by)
				if (G.state == 1)
					if (!( grabbing.Find(G.assailant) ))
						//G = null
						del(G)
				else
					if (G.state == 2)
						src.move_delay = world.time + 10
						if (prob(10))
							M.show_viewers(text("\red [] has broken free of []'s grip!", M, G.assailant))
							del(G)
						else
							return
					else
						if (G.state == 3)
							src.move_delay = world.time + 10
							if (prob(5))
								M.show_viewers(text("\red [] has broken free of []'s headlock!", M, G.assailant))
								del(G)
							else
								return
		if (M.canmove)
			var/j_pack = 0
			if ((istype(M.loc, /turf/space) && !( locate(/obj/move, M.loc) )))
				if (!( M.is_handcuffed() ))
					if (!( (locate(/obj/grille, oview(1, M)) || locate(/turf/station, oview(1, M))) ))
						if (istype(M.back, /obj/item/weapon/tank/jetpack))
							var/obj/item/weapon/tank/jetpack/J = M.back
							j_pack = J.allow_thrust(100, M)
							if(j_pack)
								var/obj/effects/sparks/ion_trails/I = new /obj/effects/sparks/ion_trails( M.loc )
								flick("ion_fade", I)
								I.icon_state = "blank"
								M.inertia_dir = 0
								spawn( 20 )
									//I = null
									del(I)
									return
							if (!( j_pack ))
								return 0
						else
							return 0
				else
					return 0


			if (isturf(M.loc))
				src.move_delay = world.time
				if ((j_pack && j_pack < 1))
					src.move_delay += 5
				if (M.drowsyness > 0)
					src.move_delay += 6
				src.move_delay += 1

				src.move_delay += M.m_delay()

				src.move_delay += round(M.get_damage() / 20)

				if (M.is_handcuffed())
					for(var/mob/carbon/N in range(M, 1))
						if (((N.pulling == M && N.can_use_hands()) || locate(/obj/item/weapon/grab, M.grabbed_by.len)))
							src << "\blue You're restrained! You can't move!"
							return 0
						//Foreach goto(853)
				src.moving = 1
				if (locate(/obj/item/weapon/grab, M))
					src.move_delay = max(src.move_delay, world.time + 7)
					var/list/L = M.get_members_of_grab_chain()
					if (istype(L, /list))
						if (L.len == 2)
							L -= M
							var/mob/N = L[1]
							if ((get_dist(M, N) <= 1 || N.loc == M.loc))
								var/turf/T = M.loc
								. = ..()
								if (isturf(M.loc))
									var/diag = get_dir(M, N)
									if ((diag - 1) & diag)
									else
										diag = null
									if ((get_dist(M, N) > 1 || diag))
										step(N, get_dir(N.loc, T))
						else
							for(var/mob/N in L)
								N.other_mobs = 1
								if (M != N)
									N.animate_movement = 3
								//Foreach goto(1163)
							for(var/mob/N in L)
								spawn( 0 )
									step(N, direct)
									return
								spawn( 1 )
									N.other_mobs = null
									N.animate_movement = 1
									return
								//Foreach goto(1214)
				else
					. = ..()
				src.moving = null
				return .
			else
				if (isobj(M.loc))
					var/obj/O = M.loc
					if (M.canmove)
						return O.relaymove(M, direct)

/var/const/SHARED_TYPES_WEIGHT = 5
/var/const/CAMERA_PROXIMITY_PREFERENCE = 0.2
// the smaller this is, the more a straight line will be preferred over a closer camera when changing cameras
// if you set this to 0 the game will crash. don't do that.
// if you set it to be negative the algorithm will do completely nonsensical things (like choosing the camera that's
// the farthest away). don't do that.

/client/proc/AIMove(n,direct,var/mob/silicon/ai/user)
	if(!user.current)
		return	//	current camera selected (terrible name)

	var/min_dist = 1e8
	var/obj/machinery/camera/closest = null
	var/obj/machinery/camera/old = user.current

	var/dx = 0
	var/dy = 0
	if(direct & NORTH)
		dy = 1
	else if(direct & SOUTH)
		dy = -1
	if(direct & EAST)
		dx = 1
	else if(direct & WEST)
		dx = -1


	var/area/A = get_area(old)
	var/list/old_types = dd_text2list("[A.type]", "/")

	for(var/obj/machinery/camera/current in world)
		if(user.network != current.network)
			continue	//	different network (syndicate)
		if(current.z != user.z)
			continue	//	different viewing plane
		if(!current.status)
			continue	//	ignore disabled cameras

		//make sure it's the right direction
		if(dx && (current.x * dx <= old.x * dx))
			continue
		if(dy && (current.y * dy <= old.y * dy))
			continue

		var/shared_types = 0 //how many levels deep the old camera and the closest camera's areas share
		//for instance, /area/A and /area/B would have shared_types = 2 (because of how dd_text2list works)
		//whereas area/A/B and /area/A/C would have it as 3

		var/area/cur_area = get_area(current)
		var/list/new_types = dd_text2list("[cur_area.type]", "/")
		for(var/i = 1; i <= old_types.len && i <= new_types.len; i++)
			if(old_types[i] == new_types[i])
				shared_types++
			else
				break

		//don't let it be too far from the current one in the axis perpindicular to the direction of travel,
		//but let it be farther from that if it's in the same area
		//something in the same hallway but farther away beats something in the same hallway

		var/distance = abs((current.y - old.y)/(CAMERA_PROXIMITY_PREFERENCE + abs(dy))) + abs((current.x - old.x)/(CAMERA_PROXIMITY_PREFERENCE + abs(dx)))
		distance -= SHARED_TYPES_WEIGHT * shared_types
		//weight things in the same area as this so they count as being closer - makes you stay in the same area
		//when possible

		if(distance < min_dist)
			//closer, or this is in the same area and the current closest isn't
			min_dist = distance
			closest = current

	if(!closest)
		return
	user.switchCamera(closest)
