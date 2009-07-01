/obj/item/weapon/grab/proc/throw()
	if(src.affecting)
		var/grabee = src.affecting
		spawn(0)
			del(src)
		return grabee
	return null

/obj/item/weapon/grab/proc/synch()
	if (src.assailant.r_hand == src)
		src.hud1.screen_loc = "1,4"
	else
		src.hud1.screen_loc = "3,4"
	return

/obj/item/weapon/grab/proc/process()
	if ((!( isturf(src.assailant.loc) ) || (!( isturf(src.affecting.loc) ) || (src.assailant.loc != src.affecting.loc && get_dist(src.assailant, src.affecting) > 1))))
		//SN src = null
		del(src)
		return
	if (src.assailant.client)
		src.assailant.client.screen -= src.hud1
		src.assailant.client.screen += src.hud1
	if (src.assailant.pulling == src.affecting)
		src.assailant.pulling = null
	if (src.state <= 2)
		src.allow_upgrade = 1
		if ((src.assailant.l_hand && src.assailant.l_hand != src && istype(src.assailant.l_hand, /obj/item/weapon/grab)))
			var/obj/item/weapon/grab/G = src.assailant.l_hand
			if (G.affecting != src.affecting)
				src.allow_upgrade = 0
		if ((src.assailant.r_hand && src.assailant.r_hand != src && istype(src.assailant.r_hand, /obj/item/weapon/grab)))
			var/obj/item/weapon/grab/G = src.assailant.r_hand
			if (G.affecting != src.affecting)
				src.allow_upgrade = 0
		if (src.state == 2)
			var/h = src.affecting.hand
			src.affecting.hand = 0
			src.affecting.drop_item()
			src.affecting.hand = 1
			src.affecting.drop_item()
			src.affecting.hand = h
			for(var/obj/item/weapon/grab/G in src.affecting.grabbed_by)
				if (G.state == 2)
					src.allow_upgrade = 0
				//Foreach goto(341)
		if (src.allow_upgrade)
			src.hud1.icon_state = "reinforce"
		else
			src.hud1.icon_state = "!reinforce"
	else
		if (!( src.affecting.buckled ))
			src.affecting.loc = src.assailant.loc
	if ((src.killing && src.state == 3))
		src.affecting.knockdown_until(5)
		src.affecting.losebreath = min(src.affecting.losebreath + 2, 3)
	return

/obj/item/weapon/grab/proc/s_click(obj/screen/S as obj)
	if (src.assailant.next_move > world.time)
		return
	if ((!( src.assailant.canmove ) || src.assailant.lying))
		//SN src = null
		del(src)
		return
	switch(S.id)
		if(1.0)
			if (src.state >= 3)
				if (!( src.killing ))
					src.assailant.show_viewers(text("\red [] has temporarily tightened his grip on []!", src.assailant, src.affecting))
					src.assailant.next_move = world.time + 10
					src.affecting.knockdown_until(2)
					src.affecting.losebreath = min(src.affecting.losebreath + 1, 3)
					src.last_suffocate = world.time
					flick("disarm/killf", S)
		else
	return

/obj/item/weapon/grab/proc/s_dbclick(obj/screen/S as obj)
	if(src.affecting.last_known_ckey)
		world.log_attack("[src.assailant] ([src.assailant.ckey]) attempted to tighten \his grab on [src.affecting] ([src.affecting.ckey]).")
	if ((src.assailant.next_move > world.time && !( src.last_suffocate < world.time + 2 )))
		return
	if ((!( src.assailant.canmove ) || src.assailant.lying))
		//SN src = null
		del(src)
		return
	switch(S.id)
		if(1.0)
			if (src.state < 2)
				if (!( src.allow_upgrade ))
					return
				if (prob(75))
					src.assailant.show_viewers(text("\red [] has grabbed [] aggressively (now hands)!", src.assailant, src.affecting))
					src.state = 2
					src.icon_state = "grabbed1"
				else
					src.assailant.show_viewers(text("\red [] has failed to grab [] aggressively!", src.assailant, src.affecting))
					del(src)
					return
			else
				if (src.state < 3)
					src.assailant.show_viewers(text("\red [] has reinforced his grip on [] (now neck)!", src.assailant, src.affecting))
					src.state = 3
					src.icon_state = "grabbed+1"
					if (!( src.affecting.buckled ))
						src.affecting.loc = src.assailant.loc
					src.hud1.icon_state = "disarm/kill"
					src.hud1.name = "disarm/kill"
				else
					if (src.state >= 3)
						src.killing = !( src.killing )
						if (src.killing)
							src.assailant.show_viewers(text("\red [] has tightened his grip on []'s neck!", src.assailant, src.affecting))
							src.assailant.next_move = world.time + 10
							src.affecting.knockdown_until(1)
							src.affecting.losebreath += 1
							src.hud1.icon_state = "disarm/kill1"
						else
							src.hud1.icon_state = "disarm/kill"
							src.assailant.show_viewers(text("\red [] has loosened the grip on []'s neck!", src.assailant, src.affecting))
		else
	return

/obj/item/weapon/grab/New()
	..()
	src.hud1 = new /obj/screen/grab( src )
	src.hud1.icon_state = "reinforce"
	src.hud1.name = "Reinforce Grab"
	src.hud1.id = 1
	src.hud1.master = src
	return

/obj/item/weapon/grab/attack(mob/M as mob, user as mob)
	if (M == src.affecting)
		if (src.state < 3)
			s_dbclick(src.hud1)
		else
			s_click(src.hud1)
	return 0
	return

/obj/item/weapon/grab/dropped()
	del(src)
	return
	return

/obj/item/weapon/grab/Del()
	del(src.hud1)
	if(src.affecting)
		src.affecting.grabbed_by -= src
	..()
	return

/obj/screen/grab/Click()
	src.master:s_click(src)
	return

/obj/screen/grab/DblClick()
	src.master:s_dbclick(src)
	return

/obj/screen/grab/interact()
	return

/obj/screen/grab/attackby()
	return

/obj/screen/Click()
	if(!istype(usr, /mob/carbon))
		return
	var/mob/carbon/user = usr
	switch(src.name)
		if("map")

			user.clearmap()
		if("maprefresh")
			var/obj/machinery/computer/security/seccomp = user.machine

			if(seccomp!=null)
				seccomp.drawmap(user)
			else

				user.clearmap()

		if("hurt")
			user.intent = "hurt"
			user.hud.intent.screen_loc = "14,15"
		if("grab")
			user.intent = "grab"
			user.hud.intent.screen_loc = "11,15"
		if("disarm")
			user.intent = "disarm"
			user.hud.intent.screen_loc = "13,15"
		if("help")
			user.intent = "help"
			user.hud.intent.screen_loc = "12,15"
		if("Reset Machine")
			user.machine = null
		if("internal")
			if (user.can_use_hands())
				user.internal = null
		if("pull")
			user.pulling = null
		if("sleep")
			user.sleeping = !( user.sleeping )
		if("rest")
			user.resting = !( user.resting )
		if("throw")
			if (isturf(user.loc) && user.can_use_hands())
				user.toggle_throw_mode()
		if("drop")
			user.drop_item_v()
		if("swap")
			user.swap_hand()
		else
			src.DblClick()
	return
