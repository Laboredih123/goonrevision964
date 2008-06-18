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
		src.affecting.stunned = max(5, src.affecting.stunned)
		src.affecting.paralysis = max(3, src.affecting.paralysis)
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
					for(var/mob/O in viewers(src.assailant, null))
						O.show_message(text("\red [] has temporarily tightened his grip on []!", src.assailant, src.affecting), 1)
						//Foreach goto(97)
					src.assailant.next_move = world.time + 10
					src.affecting.stunned = max(2, src.affecting.stunned)
					src.affecting.paralysis = max(1, src.affecting.paralysis)
					src.affecting.losebreath = min(src.affecting.losebreath + 1, 3)
					src.last_suffocate = world.time
					flick("disarm/killf", S)
		else
	return

/obj/item/weapon/grab/proc/s_dbclick(obj/screen/S as obj)
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
					for(var/mob/O in viewers(src.assailant, null))
						O.show_message(text("\red [] has grabbed [] aggressively (now hands)!", src.assailant, src.affecting), 1)
						//Foreach goto(121)
					src.state = 2
					src.icon_state = "grabbed1"
				else
					for(var/mob/O in viewers(src.assailant, null))
						O.show_message(text("\red [] has failed to grab [] aggressively!", src.assailant, src.affecting), 1)
						//Foreach goto(186)
					//SN src = null
					del(src)
					return
			else
				if (src.state < 3)
					for(var/mob/O in viewers(src.assailant, null))
						O.show_message(text("\red [] has reinforced his grip on [] (now neck)!", src.assailant, src.affecting), 1)
						//Foreach goto(257)
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
							for(var/mob/O in viewers(src.assailant, null))
								O.show_message(text("\red [] has tightened his grip on []'s neck!", src.assailant, src.affecting), 1)
								//Foreach goto(392)
							src.assailant.next_move = world.time + 10
							src.affecting.stunned = max(2, src.affecting.stunned)
							src.affecting.paralysis = max(1, src.affecting.paralysis)
							src.affecting.losebreath += 1
							src.hud1.icon_state = "disarm/kill1"
						else
							src.hud1.icon_state = "disarm/kill"
							for(var/mob/O in viewers(src.assailant, null))
								O.show_message(text("\red [] has loosened the grip on []'s neck!", src.assailant, src.affecting), 1)
								//Foreach goto(517)
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
	..()
	return

/obj/screen/grab/Click()
	src.master:s_click(src)
	return

/obj/screen/grab/DblClick()
	src.master:s_dbclick(src)
	return

/obj/screen/grab/attack_hand()
	return

/obj/screen/grab/attackby()
	return

/obj/screen/Click()
	//world << "o/s/Click: [src.name]"

	switch(src.name)
		if("map")

			usr.clearmap()
		if("maprefresh")
			var/obj/machinery/computer/security/seccomp = usr.machine

			if(seccomp!=null)
				seccomp.drawmap(usr)
			else

				usr.clearmap()

		if("other")
			usr.other = !( usr.other )
		if("intent")
			if (!( usr.intent ))
				switch(usr.a_intent)
					if("help")
						usr.intent = "12,15"
					if("disarm")
						usr.intent = "13,15"
					if("hurt")
						usr.intent = "14,15"
					if("grab")
						usr.intent = "11,15"
					else
			else
				usr.intent = null
		if("m_intent")
			if (!( usr.m_int ))
				switch(usr.m_intent)
					if("run")
						usr.m_int = "12,14"
					if("walk")
						usr.m_int = "13,14"
					if("face")
						usr.m_int = "14,14"
					else
			else
				usr.m_int = null
		if("walk")
			usr.m_intent = "walk"
			usr.m_int = "13,14"
		if("face")
			usr.m_intent = "face"
			usr.m_int = "14,14"
		if("run")
			usr.m_intent = "run"
			usr.m_int = "12,14"
		if("hurt")
			usr.a_intent = "hurt"
			usr.intent = "14,15"
		if("grab")
			usr.a_intent = "grab"
			usr.intent = "11,15"
		if("disarm")
			if (istype(usr, /mob/human))
				var/mob/M = usr
				M.a_intent = "disarm"
				M.intent = "13,15"
		if("help")
			usr.a_intent = "help"
			usr.intent = "12,15"
		if("Reset Machine")
			usr.machine = null
		if("internal")
			if ((!( usr.stat ) && usr.canmove && !( usr.restrained() )))
				usr.internal = null
		if("pull")
			usr.pulling = null
		if("sleep")
			usr.sleeping = !( usr.sleeping )
		if("rest")
			usr.resting = !( usr.resting )
		if("throw")
			if (!usr.stat && isturf(usr.loc) && !usr.restrained())
				usr.toggle_throw_mode()
		if("drop")
			usr.drop_item_v()
		if("swap")
			usr.swap_hand()
		if("resist")
			if (usr.next_move < world.time)
				return
			usr.next_move = world.time + 20
			if ((!( usr.stat ) && usr.canmove && !( usr.restrained() )))
				for(var/obj/O in usr.requests)
					//O = null
					del(O)
					//Foreach goto(557)
				for(var/obj/item/weapon/grab/G in usr.grabbed_by)
					if (G.state == 1)
						//G = null
						del(G)
					else
						if (G.state == 2)
							if (prob(25))
								for(var/mob/O in viewers(usr, null))
									O.show_message(text("\red [] has broken free of []'s grip!", usr, G.assailant), 1)
									//Foreach goto(681)
								//G = null
								del(G)
						else
							if (G.state == 2)
								if (prob(5))
									for(var/mob/O in viewers(usr, null))
										O.show_message(text("\red [] has broken free of []'s headlock!", usr, G.assailant), 1)
										//Foreach goto(762)
									//G = null
									del(G)
					//Foreach goto(602)
				for(var/mob/O in viewers(usr, null))
					O.show_message(text("\red <B>[] resists!</B>", usr), 1)
					//Foreach goto(824)
		else
			src.DblClick()
	return
