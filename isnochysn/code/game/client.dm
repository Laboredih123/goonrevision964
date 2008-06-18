/client/Del()
	world.log_access("Logout: [src.key]")
	..()

/client/New()
	if (banned.Find(src.ckey))
		del(src)
	src.lastKnownIP = src.address
	world.log_access("Login: [src.key] from [src.address]")

	src.authorize()

	src << "\blue <B>[world.message]</B>"

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

		if (banned.Find(src.ckey))
		del(src)
		return

	if (((world.address == src.address || !(src.address)) && !(host)))
		host = src.key
		world.update_stat()

	spawn (50)
		if (src.CanAdmin())
			src.holder = new /obj/admins(src)
			src.holder.rank = "Primary Administrator"
			src.holder.level = 5
			src.holder.owner = src
			src.verbs += /client/proc/show_panel

		else if (admins.Find(src.ckey))
			src.holder = new /obj/admins(src)
			src.holder.rank = admins[src.ckey]

			switch (admins[src.ckey])
				if ("Primary Administrator")
					src.holder.level = 5
					src.verbs += /proc/variables
				if ("Major Administrator")
					src.holder.level = 4
				if ("Administrator")
					src.holder.level = 3
				if ("Supervisor")
					src.holder.level = 2
				if ("Game Master")
					src.holder.level = 1
				if ("Moderator")
					src.holder.level = 0
				if ("Banned")
					//SN src = null
					del(src)
					return
				else
					//src.holder = null
					del(src.holder)

			if (src.holder)
				src.holder.owner = src
				src.verbs += /client/proc/show_panel

		if (ticker && master_mode =="sandbox" && src.authenticated)
			if (src.holder && src.holder.level == 5)
				src.verbs += /proc/variables
				src.verbs += /mob/proc/Delete

	..()

/client/proc/reset_view(atom/A)

	if (src.client)
		if (istype(A, /atom/movable))
			src.client.perspective = EYE_PERSPECTIVE
			src.client.eye = A
		else if (isturf(src.loc))
			src.client.eye = src.client.mob
			src.client.perspective = MOB_PERSPECTIVE
		else
			src.client.perspective = EYE_PERSPECTIVE
			src.client.eye = src.loc
	return

/client/Northeast()

	src.mob.swap_hand()
	return

/client/Southeast()

	var/obj/item/weapon/W = src.mob.equipped()
	if (W)
		W.attack_self(src.mob)
	return

/client/Northwest()

	src.mob.drop_item_v()
	return

/client/Center()

	if (isobj(src.mob.loc))
		var/obj/O = src.mob.loc
		if (src.mob.canmove)
			return O.relaymove(src.mob, 16)
	return

/client/Move(n, direct)

	if (src.moving)
		return 0
	if (world.time < src.move_delay)
		return
	if (!( src.mob ))
		return
	if (src.mob.stat == 2)
		return
	if (src.mob.monkeyizing)
		return
	var/is_monkey = istype(src.mob, /mob/monkey)
	if (locate(/obj/item/weapon/grab, locate(/obj/item/weapon/grab, src.mob.grabbed_by.len)))
		var/list/grabbing = list(  )
		if (istype(src.mob.l_hand, /obj/item/weapon/grab))
			var/obj/item/weapon/grab/G = src.mob.l_hand
			grabbing += G.affecting
		if (istype(src.mob.r_hand, /obj/item/weapon/grab))
			var/obj/item/weapon/grab/G = src.mob.r_hand
			grabbing += G.affecting
		for(var/obj/item/weapon/grab/G in src.mob.grabbed_by)
			if (G.state == 1)
				if (!( grabbing.Find(G.assailant) ))
					//G = null
					del(G)
			else
				if (G.state == 2)
					src.move_delay = world.time + 10
					if ((prob(25) && (!( is_monkey ) || prob(25))))
						for(var/mob/O in viewers(src.mob, null))
							O.show_message(text("\red [] has broken free of []'s grip!", src.mob, G.assailant), 1)
							//Foreach goto(309)
						//G = null
						del(G)
					else
						return
				else
					if (G.state == 2)
						src.move_delay = world.time + 10
						if ((prob(5) && !( is_monkey ) || prob(25)))
							for(var/mob/O in viewers(src.mob, null))
								O.show_message(text("\red [] has broken free of []'s headlock!", src.mob, G.assailant), 1)
								//Foreach goto(423)
							//G = null
							del(G)
						else
							return
			//Foreach goto(189)
	if (src.mob.canmove)

		if(src.mob.m_intent == "face")
			src.mob.dir = direct

		var/j_pack = 0
		if ((istype(src.mob.loc, /turf/space) && !( locate(/obj/move, src.mob.loc) )))
			if (!( src.mob.restrained() ))
				if (!( (locate(/obj/grille, oview(1, src.mob)) || locate(/turf/station, oview(1, src.mob))) ))
					if (istype(src.mob.back, /obj/item/weapon/tank/jetpack))
						var/obj/item/weapon/tank/jetpack/J = src.mob.back
						j_pack = J.allow_thrust(100, src.mob)
						if(j_pack)
							var/obj/effects/sparks/ion_trails/I = new /obj/effects/sparks/ion_trails( src.mob.loc )
							flick("ion_fade", I)
							I.icon_state = "blank"
							src.mob.inertia_dir = 0
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


		if (isturf(src.mob.loc))
			src.move_delay = world.time
			if ((j_pack && j_pack < 1))
				src.move_delay += 5
			switch(src.mob.m_intent)
				if("run")
					if (src.mob.drowsyness > 0)
						src.move_delay += 6
					src.move_delay += 1
				if("face")
					src.mob.dir = direct
					return
				if("walk")
					src.move_delay += 7


			src.move_delay += src.mob.m_delay()

			src.move_delay += round((100 - src.mob.health) / 20)		//*****RM fix

			if (src.mob.handcuffed())
				for(var/mob/M in range(src.mob, 1))
					if (((M.pulling == src.mob && (!( M.restrained() ) && M.stat == 0)) || locate(/obj/item/weapon/grab, src.mob.grabbed_by.len)))
						src << "\blue You're restrained! You can't move!"
						return 0
					//Foreach goto(853)
			src.moving = 1
			if (locate(/obj/item/weapon/grab, src.mob))
				src.move_delay = max(src.move_delay, world.time + 7)
				var/list/L = src.mob.get_members_of_grab_chain()
				if (istype(L, /list))
					if (L.len == 2)
						L -= src.mob
						var/mob/M = L[1]
						if ((get_dist(src.mob, M) <= 1 || M.loc == src.mob.loc))
							var/turf/T = src.mob.loc
							. = ..()
							if (isturf(M.loc))
								var/diag = get_dir(src.mob, M)
								if ((diag - 1) & diag)
								else
									diag = null
								if ((get_dist(src.mob, M) > 1 || diag))
									step(M, get_dir(M.loc, T))
					else
						for(var/mob/M in L)
							M.other_mobs = 1
							if (src.mob != M)
								M.animate_movement = 3
							//Foreach goto(1163)
						for(var/mob/M in L)
							spawn( 0 )
								step(M, direct)
								return
							spawn( 1 )
								M.other_mobs = null
								M.animate_movement = 1
								return
							//Foreach goto(1214)
			else
				. = ..()
			src.moving = null
			return .
		else
			if (isobj(src.mob.loc))
				var/obj/O = src.mob.loc
				if (src.mob.canmove)
					return O.relaymove(src.mob, direct)
	else
		return
	return

/client/proc/show_panel()
	set name = "Administrator Panel"

	if (src.holder)
		src.holder.update()
	return