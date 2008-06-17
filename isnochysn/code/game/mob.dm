/mob/verb/cancel_camera()
	set name = "Cancel Camera View"
	src.reset_view(null)
	src.machine = null
	src:cameraFollow = null

/mob/ai/cancel_camera()
	set category = "AI Commands"
	set name = "Cancel Camera View"
	src.reset_view(null)
	src.machine = null
	src:cameraFollow = null

/mob/verb/switch_hud()
	set name = "Switch HUD"

	if (istype(src, /mob/ai))
		return
	src.client.screen -= main_hud1.contents
	src.client.screen -= main_hud2.contents
	if (src.hud_used == main_hud1)
		src.hud_used = main_hud2
		src.throw_icon.icon = 'screen.dmi'
		src.oxygen.icon = 'screen.dmi'
		src.toxin.icon = 'screen.dmi'
		src.internals.icon = 'screen.dmi'
		src.mach.icon = 'screen.dmi'
		src.fire.icon = 'screen.dmi'
		src.healths.icon = 'screen.dmi'
		src.pullin.icon = 'screen.dmi'
		src.blind.icon = 'screen.dmi'
		src.hands.icon = 'screen.dmi'
		src.flash.icon = 'screen.dmi'
		src.sleep.icon = 'screen.dmi'
		src.rest.icon = 'screen.dmi'
	else
		src.hud_used = main_hud1
		src.throw_icon.icon = 'screen1.dmi'
		src.oxygen.icon = 'screen1.dmi'
		src.toxin.icon = 'screen1.dmi'
		src.internals.icon = 'screen1.dmi'
		src.mach.icon = 'screen1.dmi'
		src.fire.icon = 'screen1.dmi'
		src.healths.icon = 'screen1.dmi'
		src.pullin.icon = 'screen1.dmi'
		src.blind.icon = 'screen1.dmi'
		src.hands.icon = 'screen1.dmi'
		src.flash.icon = 'screen1.dmi'
		src.sleep.icon = 'screen1.dmi'
		src.rest.icon = 'screen1.dmi'
	src.client.screen -= src.hud_used.adding
	src.client.screen += src.hud_used.adding
	return

/mob/Login()

	src.sight |= SEE_SELF
	..()
	return

/mob/CheckPass(mob/M as mob)

	if ((src.other_mobs && ismob(M) && M.other_mobs))
		return 1
	else
		return (!( M.density ) || !( src.density ) || src.lying)
	return

/mob/burn(fi_amount)

	for(var/atom/movable/A in src)
		A.burn(fi_amount)
		//Foreach goto(15)
	return

/mob/Topic(href, href_list)
	if (href_list["mach_close"])
		var/t1 = text("window=[]", href_list["mach_close"])
		src.machine = null
		src << browse(null, t1)


	if(href_list["priv_msg"])
		var/mob/M = locate(href_list["priv_msg"])
		if(M)
			if (!( ismob(M) ))
				return
			var/t = input("Message:", text("Private message to []", M.key), null, null)  as text
			if (!( t ))
				return
			if (usr.client && usr.client.holder)
				M << "\blue Admin PM from-<B><A href='?src=\ref[M];priv_msg=\ref[usr]'>[usr.key]</A></B>: [t]"
				usr << "\blue Admin PM to-<B><A href='?src=\ref[usr];priv_msg=\ref[M]'>[M.key]</A></B>: [t]"
			else
				M << "\blue Reply PM from-<B><A href='?src=\ref[M];priv_msg=\ref[usr]'>[usr.key]</A></B>: [t]"
				usr << "\blue Reply PM to-<B><A href='?src=\ref[usr];priv_msg=\ref[M]'>[M.key]</A></B>: [t]"

			world.log_admin("PM: [usr.key]->[M.key] : [t]")

	..()
	return

/mob/MouseDrop(mob/M as mob)

	..()
	if ((M != usr || usr == src || get_dist(usr, src) > 1))
		return
	src.show_inv(usr)
	return

/mob/las_act(flag)

	if (flag == "bullet")
		if (src.stat != 2)
			if (istype(src, /mob/human))
				var/mob/human/H = src
				var/dam_zone = pick("chest", "chest", "chest", "diaper", "head")
				if (H.organs[text("[]", dam_zone)])
					var/atom/organ/affecting = H.organs[text("[]", dam_zone)]
					if (affecting.take_damage(51, 0))
						H.UpdateDamageIcon()
					else
						H.UpdateDamage()
			else
				src.bruteloss += 51
			src.health = 100 - src.oxyloss - src.toxloss - src.fireloss - src.bruteloss
			if (prob(80))
				src.weakened = 2
	if (flag)
		if (prob(75))
			src.stunned = 10
		else
			src.weakened = 10
	else
		if (src.stat != 2)
			if (istype(src, /mob/human))
				var/mob/human/H = src
				var/dam_zone = pick("chest", "chest", "chest", "diaper", "head")
				if (H.organs[text("[]", dam_zone)])
					var/atom/organ/affecting = H.organs[text("[]", dam_zone)]
					if (affecting.take_damage(20, 0))
						H.UpdateDamageIcon()
					else
						H.UpdateDamage()
			else
				src.bruteloss += 20
			src.health = 100 - src.oxyloss - src.toxloss - src.fireloss - src.bruteloss
			if (prob(25))
				src.stunned = 2
	return

/mob/ghost/proc/infest()

	return

/mob/ghost/Move()

	if (src.stunned)
		return
	. = ..()
	return

/mob/ghost/show_inv()

	return
	return

/mob/ghost/Bump()

	return
	return

/mob/ghost/UpdateClothing()

	for(var/i in src.overlays)
		src.overlays -= i
		//Foreach goto(17)
	if (src.mask)
		if (istype(src.mask, /obj/item/weapon/clothing/mask))
			var/t1 = src.mask.s_istate
			if (!( t1 ))
				t1 = src.icon_state
			src.overlays += image("icon" = 'ghost.dmi', "icon_state" = text("[][]", t1, (!( src.lying ) ? null : "2")), "layer" = src.layer)
		src.mask.screen_loc = "2,3"
	if (src.r_hand)
		var/t1 = src.r_hand.s_istate
		if (!( t1 ))
			t1 = src.icon_state
		src.overlays += image("icon" = 'r_items.dmi', "icon_state" = t1, "layer" = src.layer)
		src.r_hand.screen_loc = "1,2"
	if (src.l_hand)
		var/t1 = src.l_hand.s_istate
		if (!( t1 ))
			t1 = src.icon_state
		src.overlays += image("icon" = 'l_items.dmi', "icon_state" = t1, "layer" = src.layer)
		src.l_hand.screen_loc = "3,2"
	if (src.client)
		src.client.screen -= src.contents
		src.client.screen += src.contents
	return

/mob/ghost/Life()

	if (src.stat == 2)
		src.death()
		return
	src.canmove = 1
	src.lying = 1
	src.stat = 0
	if (src.weakened > 0)
		src.weakened--
		src.icon_state = "ghost"
	else
		src.icon_state = "blank"
	if (src.stunned > 0)
		src.stunned--
		src.canmove = 0
		for(var/obj/item/O in src)
			O.loc = src.loc
			O.layer = initial(O.layer)
			src.u_equip(O)
			//Foreach goto(109)
	if (src.health < 0)
		src.stat = 2
	return
	return

/mob/ghost/db_click()

	return
	return

/mob/ghost/equipped()

	return null
	return

/mob/ghost/m_delay()

	return -100.0
	return

/mob/ghost/reset_view()

	if (src.client)
		src.client.eye = src
	else
		return ..()
	return

/mob/ghost/las_act()

	return
	return

/mob/ghost/ex_act()

	return
	return

/mob/ghost/attack_hand(mob/M as mob)

	src.infest(M)
	return

/mob/ghost/attack_paw(mob/M as mob)

	src.infest(M)
	return

/mob/ghost/death()

	src.stunned = 1
	..()
	return

/mob/ghost/meteorhit()

	return
	return

/mob/ghost/restrained()

	return 0
	return

/mob/ghost/attackby(nothing, mob/M as mob)

	src.infest(M)
	return 0
	return

/mob/ghost/say(msg as text)

	if (!( msg ))
		return
	msg = stutter(msg)
	if (prob(25))
		msg = stars(msg)
	for(var/mob/M in hearers(null, null))
		M.show_message(msg, 2)
		//Foreach goto(58)
	return

/mob/monkey/New()

	spawn( 50 )
		if (!( src.primary ))
			var/t1 = rand(1000, 1500)
			dna_ident += t1
			if (dna_ident > 65536.0)
				dna_ident = rand(1, 1500)
			src.primary = new /obj/dna( null )
			src.primary.uni_identity = text("[]", dna_ident)
			while(length(src.primary.uni_identity) < 4)
				src.primary.uni_identity = text("0[]", src.primary.uni_identity)
			var/t2 = text("[]", rand(1, 256))
			if (length(t2) < 2)
				src.primary.uni_identity = text("[]0[]", src.primary.uni_identity, t2)
			else
				src.primary.uni_identity = text("[][]", src.primary.uni_identity, t2)
			t2 = text("[]", rand(1, 256))
			if (length(t2) < 2)
				src.primary.uni_identity = text("[]0[]", src.primary.uni_identity, t2)
			else
				src.primary.uni_identity = text("[][]", src.primary.uni_identity, t2)
			t2 = text("[]", rand(1, 256))
			if (length(t2) < 2)
				src.primary.uni_identity = text("[]0[]", src.primary.uni_identity, t2)
			else
				src.primary.uni_identity = text("[][]", src.primary.uni_identity, t2)
			t2 = text("[]", rand(1, 256))
			if (length(t2) < 2)
				src.primary.uni_identity = text("[]0[]", src.primary.uni_identity, t2)
			else
				src.primary.uni_identity = text("[][]", src.primary.uni_identity, t2)
			t2 = (src.gender == "male" ? text("[]", rand(1, 124)) : text("[]", rand(127, 250)))
			if (length(t2) < 2)
				src.primary.uni_identity = text("[]0[]", src.primary.uni_identity, t2)
			else
				src.primary.uni_identity = text("[][]", src.primary.uni_identity, t2)
			src.primary.spec_identity = "2B6696D2B127E5A4"
			src.primary.struc_enzyme = "CDEAF5B90AADBC6BA8033DB0A7FD613FA"
			src.primary.use_enzyme = "C8FFFE7EC09D80AEDEDB9A5A0B4085B61"
			src.primary.n_chromo = 16
			src.name = text("monkey ([])", copytext(md5(src.primary.uni_identity), 2, 6))
		return
	..()
	return

/mob/monkey/Bump(atom/movable/AM as mob|obj, yes)

	spawn( 0 )
		if ((!( yes ) || src.now_pushing))
			return
		..()
		if (!( istype(AM, /atom/movable) ))
			return
		if (!( src.now_pushing ))
			src.now_pushing = 1
			if (!( AM.anchored ))
				var/t = get_dir(src, AM)
				step(AM, t)
			src.now_pushing = null
		return
	return

/mob/monkey/Topic(href, href_list)
	..()
	if (href_list["mach_close"])
		var/t1 = text("window=[]", href_list["mach_close"])
		src.machine = null
		src << browse(null, t1)
	if ((href_list["item"] && !( usr.stat ) && !( usr.restrained() ) && get_dist(src, usr) <= 1))
		var/obj/equip_e/monkey/O = new /obj/equip_e/monkey(  )
		O.source = usr
		O.target = src
		O.item = usr.equipped()
		O.s_loc = usr.loc
		O.t_loc = src.loc
		O.place = href_list["item"]
		src.requests += O
		spawn( 0 )
			O.process()
			return
	..()
	return

/mob/ai/Topic(href, href_list)
	..()
	if (href_list["mach_close"])
		var/t1 = text("window=[]", href_list["mach_close"])
		src.machine = null
		src << browse(null, t1)
	//if ((href_list["item"] && !( usr.stat ) && !( usr.restrained() ) && get_dist(src, usr) <= 1))
		/*var/obj/equip_e/monkey/O = new /obj/equip_e/monkey(  )
		O.source = usr
		O.target = src
		O.item = usr.equipped()
		O.s_loc = usr.loc
		O.t_loc = src.loc
		O.place = href_list["item"]
		src.requests += O
		spawn( 0 )
			O.process()
			return
		*/
	..()
	return

/mob/monkey/meteorhit(obj/O as obj)

	for(var/mob/M in viewers(src, null))
		M.show_message(text("\red [] has been hit by []", src, O), 1)
		//Foreach goto(19)
	if (src.health > 0)
		src.bruteloss += 30
		if (O.icon_state == "flaming")
			src.fireloss += 40
		src.health = 100 - src.oxyloss - src.toxloss - src.fireloss - src.bruteloss
	return

/mob/ai/meteorhit(obj/O as obj)

	for(var/mob/M in viewers(src, null))
		M.show_message(text("\red [] has been hit by []", src, O), 1)
		//Foreach goto(19)
	if (src.health > 0)
		src.bruteloss += 30
		if ((O.icon_state == "flaming"))
			src.fireloss += 40
		src.health = 100 - src.oxyloss - src.toxloss - src.fireloss - src.bruteloss
	return

/mob/monkey/las_act(flag)

	if (flag == "bullet")
		if (src.stat != 2)
			src.bruteloss += 60
			src.health = 100 - src.oxyloss - src.toxloss - src.fireloss - src.bruteloss
			src.weakened = 10
	if (flag)
		if (prob(75))
			src.stunned = 15
		else
			src.weakened = 15
	else
		if (src.stat != 2)
			src.bruteloss += 20
			src.health = 100 - src.oxyloss - src.toxloss - src.fireloss - src.bruteloss
			if (prob(25))
				src.stunned = 1
	return

/mob/ai/las_act(flag)

	if (flag == "bullet")
		if (src.stat != 2)
			src.bruteloss += 60
			src.health = 100 - src.oxyloss - src.toxloss - src.fireloss - src.bruteloss
			src.weakened = 10
	if (flag)
		if (prob(75))
			src.stunned = 15
		else
			src.weakened = 15
	else
		if (src.stat != 2)
			src.bruteloss += 20
			src.health = 100 - src.oxyloss - src.toxloss - src.fireloss - src.bruteloss
			if (prob(25))
				src.stunned = 1
	return

/mob/monkey/hand_p(mob/M as mob)

	if ((M.a_intent == "hurt" && !( istype(src.mask, /obj/item/weapon/clothing/mask/muzzle) )))
		if ((prob(75) && src.health > 0))
			for(var/mob/O in viewers(src, null))
				O.show_message(text("\red <B>The monkey has bit []!</B>", src), 1)
				//Foreach goto(63)
			var/damage = rand(1, 5)
			src.bruteloss += damage
			src.health = 100 - src.oxyloss - src.toxloss - src.fireloss - src.bruteloss
		else
			for(var/mob/O in viewers(src, null))
				O.show_message(text("\red <B>The monkey has attempted to bite []!</B>", src), 1)
				//Foreach goto(144)
	return

/mob/monkey/attack_paw(mob/M as mob)

	if (M.a_intent == "help")
		src.sleeping = 0
		src.resting = 0
		for(var/mob/O in viewers(src, null))
			O.show_message("\blue The monkey shakes the monkey trying to wake him up!", 1)
			//Foreach goto(47)
	else
		if ((M.a_intent == "hurt" && !( istype(src.mask, /obj/item/weapon/clothing/mask/muzzle) )))
			if ((prob(75) && src.health > 0))
				for(var/mob/O in viewers(src, null))
					O.show_message("\red <B>The monkey has bit the monkey!</B>", 1)
					//Foreach goto(130)
				var/damage = rand(1, 5)
				src.bruteloss += damage
				src.health = 100 - src.oxyloss - src.toxloss - src.fireloss - src.bruteloss
			else
				for(var/mob/O in viewers(src, null))
					O.show_message("\red <B>The monkey has attempted to bite the monkey!</B>", 1)
					//Foreach goto(209)
	return

/mob/monkey/attack_hand(mob/M as mob)

	if (M.a_intent == "help")
		src.sleeping = 0
		src.resting = 0
		for(var/mob/O in viewers(src, null))
			if ((O.client && !( O.blinded )))
				O.show_message(text("\blue [] shakes the monkey trying to wake him up!", M), 1)
			//Foreach goto(47)
	else
		if (M.a_intent == "hurt")
			if ((prob(75) && src.health > 0))
				for(var/mob/O in viewers(src, null))
					if ((O.client && !( O.blinded )))
						O.show_message(text("\red <B>[] has punched the monkey!</B>", M), 1)
					//Foreach goto(135)
				var/damage = rand(5, 10)
				if (prob(40))
					damage = rand(10, 15)
					if (src.paralysis < 5)
						src.paralysis = rand(10, 15)
						spawn( 0 )
							for(var/mob/O in viewers(src, null))
								if ((O.client && !( O.blinded )))
									O.show_message(text("\red <B>[] has knocked out the monkey!</B>", M), 1)
								//Foreach goto(248)
							return
				src.bruteloss += damage
				src.health = 100 - src.oxyloss - src.toxloss - src.fireloss - src.bruteloss
			else
				for(var/mob/O in viewers(src, null))
					if ((O.client && !( O.blinded )))
						O.show_message(text("\red <B>[] has attempted to punch the monkey!</B>", M), 1)
					//Foreach goto(336)
		else
			if (M.a_intent == "grab")
				if (M == src)
					return
				var/obj/item/weapon/grab/G = new /obj/item/weapon/grab( M )
				G.assailant = M
				if (M.hand)
					M.l_hand = G
				else
					M.r_hand = G
				G.layer = 20
				G.affecting = src
				src.grabbed_by += G
				G.synch()
				for(var/mob/O in viewers(src, null))
					O.show_message(text("\red [] has grabbed the monkey passively!", M), 1)
					//Foreach goto(502)
			else
				if (!( src.paralysis ))
					if (prob(25))
						src.paralysis = 2
						for(var/mob/O in viewers(src, null))
							if ((O.client && !( O.blinded )))
								O.show_message(text("\red <B>[] has pushed down the monkey!</B>", M), 1)
							//Foreach goto(571)
					else
						drop_item()
						for(var/mob/O in viewers(src, null))
							if ((O.client && !( O.blinded )))
								O.show_message(text("\red <B>[] has disarmed the monkey!</B>", M), 1)
							//Foreach goto(638)
	return


/mob/monkey/Stat()

	..()
	statpanel("Status")
	stat(null, text("Intent: []", src.a_intent))
	stat(null, text("Move Mode: []", src.m_intent))
	return

/mob/monkey/UpdateClothing()

	..()
	for(var/i in src.overlays)
		src.overlays -= i
		//Foreach goto(21)
	if (!( src.lying ))
		src.icon_state = "monkey1"
	else
		src.icon_state = "monkey0"
	if (src.mask)
		if (istype(src.mask, /obj/item/weapon/clothing/mask))
			var/t1 = src.mask.s_istate
			if (!( t1 ))
				t1 = src.mask.icon_state
			src.overlays += image("icon" = 'monkey.dmi', "icon_state" = text("[][]", t1, (!( src.lying ) ? null : "2")), "layer" = src.layer)
		src.mask.screen_loc = "2,3"
	if (src.r_hand)
		var/t1 = src.r_hand.s_istate
		if (!( t1 ))
			t1 = src.r_hand.icon_state
		src.overlays += image("icon" = 'r_items.dmi', "icon_state" = t1, "layer" = src.layer)
		src.r_hand.screen_loc = "1,2"
	if (src.l_hand)
		var/t1 = src.l_hand.s_istate
		if (!( t1 ))
			t1 = src.l_hand.icon_state
		src.overlays += image("icon" = 'l_items.dmi', "icon_state" = t1, "layer" = src.layer)
		src.l_hand.screen_loc = "3,2"
	if (src.back)
		if (!( src.lying ))
			src.overlays += image("icon" = 'monkey.dmi', "icon_state" = "back", "layer" = src.layer)
		else
			src.overlays += image("icon" = 'monkey.dmi', "icon_state" = "back2", "layer" = src.layer)
		src.back.screen_loc = "3,3"
	if (src.handcuffed)
		src.pulling = null
		if (!( src.lying ))
			src.overlays += image("icon" = 'monkey.dmi', "icon_state" = "handcuff1", "layer" = src.layer)
		else
			src.overlays += image("icon" = 'monkey.dmi', "icon_state" = "handcuff2", "layer" = src.layer)
	if (src.client)
		src.client.screen -= src.contents
		src.client.screen += src.contents
		src.client.screen -= src.hud_used.m_ints
		src.client.screen -= src.hud_used.mov_int
		if (src.i_select)
			if (src.intent)
				src.client.screen += src.hud_used.m_ints
				src.i_select.screen_loc = src.intent
			else
				src.i_select.screen_loc = null
		if (src.m_select)
			if (src.m_int)
				src.client.screen += src.hud_used.mov_int
				src.m_select.screen_loc = src.m_int
			else
				src.m_select.screen_loc = null
	for(var/mob/M in viewers(1, src))
		if ((M.client && M.machine == src))
			spawn( 0 )
				src.show_inv(M)
				return
		//Foreach goto(662)
	return

/mob/monkey/Login()

	if (banned.Find(src.ckey))
		//src.client = null
		del(src.client)
	src.client.screen -= main_hud1.contents
	src.client.screen -= main_hud2.contents
	if (!( src.hud_used ))
		src.hud_used = main_hud1
	src.next_move = 1
	if (!( src.rname ))
		src.rname = src.key
	src.throw_icon = new /obj/screen(null)
	src.oxygen = new /obj/screen( null )
	src.i_select = new /obj/screen( null )
	src.m_select = new /obj/screen( null )
	src.toxin = new /obj/screen( null )
	src.internals = new /obj/screen( null )
	src.mach = new /obj/screen( null )
	src.fire = new /obj/screen( null )
	src.healths = new /obj/screen( null )
	src.pullin = new /obj/screen( null )
	src.blind = new /obj/screen( null )
	src.flash = new /obj/screen( null )
	src.hands = new /obj/screen( null )
	src.sleep = new /obj/screen( null )
	src.rest = new /obj/screen( null )
	..()
	UpdateClothing()
	src.throw_icon.icon_state = "act_throw_off"
	src.oxygen.icon_state = "oxy0"
	src.i_select.icon_state = "selector"
	src.m_select.icon_state = "selector"
	src.toxin.icon_state = "toxin0"
	src.internals.icon_state = "internal0"
	src.mach.icon_state = null
	src.fire.icon_state = "fire0"
	src.healths.icon_state = "health0"
	src.pullin.icon_state = "pull0"
	src.blind.icon_state = "black"
	src.hands.icon_state = "hand"
	src.flash.icon_state = "blank"
	src.sleep.icon_state = "sleep0"
	src.rest.icon_state = "rest0"
	src.hands.dir = NORTH
	src.throw_icon.name = "throw"
	src.oxygen.name = "oxygen"
	src.i_select.name = "intent"
	src.m_select.name = "move"
	src.toxin.name = "toxin"
	src.internals.name = "internal"
	src.mach.name = "Reset Machine"
	src.fire.name = "fire"
	src.healths.name = "health"
	src.pullin.name = "pull"
	src.blind.name = " "
	src.hands.name = "hand"
	src.flash.name = "flash"
	src.sleep.name = "sleep"
	src.rest.name = "rest"
	src.throw_icon.screen_loc = "9,1"
	src.oxygen.screen_loc = "15,12"
	src.i_select.screen_loc = "14,15"
	src.m_select.screen_loc = "14,14"
	src.toxin.screen_loc = "15,10"
	src.internals.screen_loc = "15,14"
	src.mach.screen_loc = "14,1"
	src.fire.screen_loc = "15,8"
	src.healths.screen_loc = "15,5"
	src.sleep.screen_loc = "15,3"
	src.rest.screen_loc = "15,2"
	src.pullin.screen_loc = "15,1"
	src.hands.screen_loc = "1,3"
	src.blind.screen_loc = "1,1 to 15,15"
	src.flash.screen_loc = "1,1 to 15,15"
	src.blind.layer = 0
	src.flash.layer = 17
	src.sleep.layer = 20
	src.rest.layer = 20
	src.client.screen.len = null
	src.client.screen -= list( src.throw_icon, src.oxygen, src.i_select, src.m_select, src.toxin, src.internals, src.fire, src.hands, src.healths, src.pullin, src.blind, src.flash, src.rest, src.sleep, src.mach )
	src.client.screen += list( src.throw_icon, src.oxygen, src.i_select, src.m_select, src.toxin, src.internals, src.fire, src.hands, src.healths, src.pullin, src.blind, src.flash, src.rest, src.sleep, src.mach )
	src.client.screen -= src.hud_used.adding
	src.client.screen += src.hud_used.adding
	src.client.screen -= src.hud_used.mon_blo
	src.client.screen += src.hud_used.mon_blo
	if (!( src.primary ))
		var/t1 = rand(1000, 1500)
		dna_ident += t1
		if (dna_ident > 65536.0)
			dna_ident = rand(1, 1500)
		src.primary = new /obj/dna( null )
		src.primary.uni_identity = text("[]", dna_ident)
		while(length(src.primary.uni_identity) < 4)
			src.primary.uni_identity = text("0[]", src.primary.uni_identity)
		var/t2 = text("[]", rand(1, 256))
		if (length(t2) < 2)
			src.primary.uni_identity = text("[]0[]", src.primary.uni_identity, t2)
		else
			src.primary.uni_identity = text("[][]", src.primary.uni_identity, t2)
		t2 = text("[]", rand(1, 256))
		if (length(t2) < 2)
			src.primary.uni_identity = text("[]0[]", src.primary.uni_identity, t2)
		else
			src.primary.uni_identity = text("[][]", src.primary.uni_identity, t2)
		t2 = text("[]", rand(1, 256))
		if (length(t2) < 2)
			src.primary.uni_identity = text("[]0[]", src.primary.uni_identity, t2)
		else
			src.primary.uni_identity = text("[][]", src.primary.uni_identity, t2)
		t2 = text("[]", rand(1, 256))
		if (length(t2) < 2)
			src.primary.uni_identity = text("[]0[]", src.primary.uni_identity, t2)
		else
			src.primary.uni_identity = text("[][]", src.primary.uni_identity, t2)
		t2 = (src.gender == "male" ? text("[]", rand(1, 124)) : text("[]", rand(127, 250)))
		if (length(t2) < 2)
			src.primary.uni_identity = text("[]0[]", src.primary.uni_identity, t2)
		else
			src.primary.uni_identity = text("[][]", src.primary.uni_identity, t2)
		src.primary.spec_identity = "2B6696D2B127E5A4"
		src.primary.struc_enzyme = "CDEAF5B90AADBC6BA8033DB0A7FD613FA"
		src.primary.use_enzyme = "C8FFFE7EC09D80AEDEDB9A5A0B4085B61"
		src.primary.n_chromo = 16
	if (!( src.start ))
		src.start = 1
		var/A = locate(/area/start)
		var/list/L = list(  )
		for(var/turf/T in A)
			if(T.isempty() )
				L += T
			//Foreach goto(1473)
		src.loc = pick(L)
	//src << browse('help.htm', "window=help")
	if (CanAdmin())
		src << text("\blue The game ip is byond://[]:[] !", world.internet_address, world.port)
		src.verbs += /mob/proc/show_ctf
		src.verbs += /proc/variables
	src << text("\blue <B>[]</B>", world_message)
	if (!( isturf(src.loc) ))
		src.client.eye = src.loc
		src.client.perspective = EYE_PERSPECTIVE
	src.name = text("monkey ([])", copytext(md5(src.primary.uni_identity), 2, 6))
	return

/mob/monkey/Move()

	if ((!( src.buckled ) || src.buckled.loc != src.loc))
		src.buckled = null
	if (src.buckled)
		return
	if (src.restrained())
		src.pulling = null
	var/t7 = 1
	if (src.restrained())
		for(var/mob/M in range(src, 1))
			if ((M.pulling == src && M.stat == 0 && !( M.restrained() )))
				return 0
			//Foreach goto(93)
	if ((t7 && src.pulling && get_dist(src, src.pulling) <= 1))
		if (src.pulling.anchored)
			src.pulling = null
		var/T = src.loc
		. = ..()
		if (!( isturf(src.pulling.loc) ))
			src.pulling = null
			return
		if (!( src.restrained() ))
			var/diag = get_dir(src, src.pulling)
			if ((diag - 1) & diag)
			else
				diag = null
			if ((ismob(src.pulling) && (get_dist(src, src.pulling) > 1 || diag)))
				if (istype(src.pulling, src.type))
					var/mob/M = src.pulling
					var/mob/t = M.pulling
					M.pulling = null
					step(src.pulling, get_dir(src.pulling.loc, T))
					M.pulling = t
			else
				step(src.pulling, get_dir(src.pulling.loc, T))
	else
		src.pulling = null
		. = ..()
	if ((src.s_active && !( src.contents.Find(src.s_active) )))
		src.s_active.close(src)
	return

/mob/monkey/death()

	var/cancel
	if (src.healths)
		src.healths.icon_state = "health5"
	src.stat = 2
	src.canmove = 0
	if (src.blind)
		src.blind.layer = 0
	src.lying = 1
	//src.icon_state = "dead"
	for(var/mob/M in world)
		if ((M.client && !( M.stat )))
			cancel = 1
		//Foreach goto(79)
	if (!( cancel ))
		world << "<B>Everyone is dead! Resetting in 30 seconds!</B>"
		if ((ticker && ticker.timing))
			ticker.check_win()
		else
			spawn( 300 )
				world.log_game("Rebooting because of no live players")
				world.Reboot()
				return
	return ..()
	return

/mob/monkey/verb/removeinternal()

	src.internal = null
	return

/mob/monkey/proc/aircheck(obj/substance/gas/G as obj)

	src.t_oxygen = 0
	src.t_plasma = 0
	if (G)
		var/a_oxygen = G.oxygen * 0.7
		var/a_plasma = G.plasma
		var/a_sl_gas = G.sl_gas * 0.7
		G.oxygen -= a_oxygen
		G.plasma -= a_plasma
		G.sl_gas -= a_sl_gas
		if (a_oxygen < 67.032)
			src.t_oxygen = round((67.032 - a_oxygen) / 5)
		if (G.co2 > 5)
			var/t = round((G.co2 - 5) / 5)
			if (G.co2 > 25)
				src.paralysis = max(src.paralysis, 3)
				if (G.co2 > 50)
					t = 50
			src.t_oxygen = max(src.t_oxygen, t)
		if (a_plasma > 5)
			src.t_plasma = round((src.t_plasma - 5) / 10) + 1
		if (a_sl_gas > 10)
			src.weakened = max(src.weakened, 3)
			if (G.co2 > 40)
				src.paralysis = max(src.paralysis, 3)
		G.co2 += a_oxygen * 0.6
	return

/mob/monkey/proc/firecheck(turf/T as turf)

	if (T.firelevel < 900000.0)
		return 0
	var/total = 0
	if (src.mask)
		if (T.firelevel > src.mask.s_fire)
			total += 0.25
	else
		total += 0.25
	return total
	return

/mob/ai/proc/getLaw(var/index)
	if (src.laws.len < index+1)
		src << text("Error: Invalid law index [] for getLaw. Writing out list of laws for debug purposes.", index)
		showLaws(0)
	else
		return src.laws[index+1]


/mob/ai/proc/show_laws()
	set category = "AI Commands"
	set name = "Show Laws"
	src.showLaws(0)

/mob/ai/proc/showLaws(var/toAll=0)
	var/showTo = src
	if (toAll)
		showTo = world

	else
		src << "<b>Obey these laws:</b>"
	var/lawIndex = 0
	for (var/index=1, index<=src.laws.len, index++)
		var/law = src.laws[index]
		if (length(law)>0)
			if (index==2 && lawIndex==0)
				lawIndex = 1
			showTo << text("[]. []", lawIndex, law)
			lawIndex += 1

/mob/ai/proc/addLaw(var/number, var/law)
	while (src.laws.len < number+1)
		src.laws += ""
	src.laws[number+1] = law

/mob/ai/proc/firecheck(turf/T as turf)

	if (T.firelevel < 900000.0)
		return 0
	var/total = 0
	total += 0.25
	return total
	return

/mob/monkey/proc/emote(act)

	var/param = null
	if (findtext(act, "-", 1, null))
		var/t1 = findtext(act, "-", 1, null)
		param = copytext(act, t1 + 1, length(act) + 1)
		act = copytext(act, 1, t1)
	var/muzzled = istype(src.mask, /obj/item/weapon/clothing/mask/muzzle)
	var/m_type = 1
	var/message

	switch(act)
		if("sign")
			if (!( src.restrained() ))
				message = text("<B>The monkey</B> signs[].", (text2num(param) ? text(" the number []", text2num(param)) : null))
				m_type = 1
		if("scratch")
			if (!( src.restrained() ))
				message = "<B>The monkey</B> scratches."
				m_type = 1
		if("whimper")
			if (!( muzzled ))
				message = "<B>The monkey</B> whimpers."
				m_type = 2
		if("roar")
			if (!( muzzled ))
				message = "<B>The monkey</B> roars."
				m_type = 2
		if("tail")
			message = "<B>The monkey</B> waves his tail."
			m_type = 1
		if("gasp")
			message = "<B>The monkey</B> gasps."
			m_type = 2
		if("drool")
			message = "<B>The monkey</B> drools."
			m_type = 1
		if("paw")
			if (!( src.restrained() ))
				message = "<B>The monkey</B> flails his paw."
				m_type = 1
		if("scretch")
			if (!( muzzled ))
				message = "<B>The monkey</B> scretches."
				m_type = 2
		if("choke")
			message = "<B>The monkey</B> chokes."
			m_type = 2
		if("moan")
			message = "<B>The monkey</B> moans!"
			m_type = 2
		if("nod")
			message = "<B>The monkey</B> nods his head."
			m_type = 1
		if("sit")
			message = "<B>The monkey</B> sits down."
			m_type = 1
		if("sway")
			message = "<B>The monkey</B> sways around dizzily."
			m_type = 1
		if("sulk")
			message = "<B>The monkey</B> sulks down sadly."
			m_type = 1
		if("twitch")
			message = "<B>The monkey</B> twitches violently."
			m_type = 1
		if("dance")
			if (!( src.restrained() ))
				message = "<B>The monkey</B> dances around happily."
				m_type = 1
		if("roll")
			if (!( src.restrained() ))
				message = "<B>The monkey</B> rolls."
				m_type = 1
		if("shake")
			message = "<B>The monkey</B> shakes his head."
			m_type = 1
		if("gnarl")
			if (!( muzzled ))
				message = "<B>The monkey</B> gnarls and shows his teeth.."
				m_type = 2
		if("jump")
			message = "<B>The monkey</B> jumps!"
			m_type = 1
		if("help")
			src << "choke, dance, drool, gasp, gnarl, jump, paw, moan, nod, roar, roll, scratch,\nscretch, shake, sign-#, sit, sulk, sway, tail, twitch, whimper"
		else
			src << text("Invalid Emote: []", act)
	if ((message && src.stat == 0))
		if (m_type & 1)
			for(var/mob/O in viewers(src, null))
				O.show_message(message, m_type)
				//Foreach goto(703)
		else
			for(var/mob/O in hearers(src, null))
				O.show_message(message, m_type)
				//Foreach goto(746)
	return

/mob/monkey/say(message as text)

	if (src.muted)
		return
	message = copytext(message, 1, 128)

	message = sanitize(message)

	if (src.stat == 2)
		for(var/mob/M in world)
			if (M.stat == 2)
				M << text("<B>[]</B> []: []", src, (src.stat > 1 ? "\[<I>dead</I> \]" : ""), message)
			//Foreach goto(50)
		return
	if ((copytext(message, 1, 2) == "*" && !( src.stat )))
		src.emote(copytext(message, 2, length(message) + 1))
		return
	if ((!( message ) || istype(src.mask, /obj/item/weapon/clothing/mask/muzzle)))
		return
	if (src.stat < 2)
		var/list/L = list(  )
		var/italics = 0
		var/obj_range = null
		if (findtext(message, ":r") == 1)
			message = copytext(message, 3, length(message) + 1)
			if (src.r_hand)
				src.r_hand.talk_into(usr, message)
			L += hearers(1, null)
			italics = 1
			obj_range = 1
		else if (findtext(message, ":l") == 1)
			message = copytext(message, 3, length(message) + 1)
			if (src.l_hand)
				src.l_hand.talk_into(usr, message)
			L += hearers(1, null)
			italics = 1
			obj_range = 1
		else if (findtext(message, ":w") == 1)
			message = copytext(message, 4, length(message) + 1)
			L += hearers(1, null)
			italics = 1
			obj_range = 1
		else if (findtext(message, ":i") == 1)
			message = copytext(message, 3, length(message) + 1)
			for(var/obj/item/weapon/radio/intercom/I in view(1, null))
				I.talk_into(usr, message)
			L += hearers(1, null)
			obj_range = 1
			italics = 1
		else
			L += hearers(null, null)
		L -= src
		L += src
		if (italics)
			message = text("<I>[]</I>", message)
		for(var/mob/M in L)
			if (istype(M, src.type))
				M.show_message(text("<B>[]</B>: []", src, message), 2)
			else
				M.show_message(text("<B>[]</B> chimpers.", src), 2)
			//Foreach goto(503)
		for(var/obj/O in view(obj_range, null))
			spawn( 0 )
				if (O)
					O.hear_talk(usr, message)
				return
			//Foreach goto(580)
	for(var/mob/M in world)
		if (M.stat > 1)
			M << text("<B>[]</B> []: []", src, (src.stat > 1 ? "\[<I>dead</I> \]" : ""), message)
		//Foreach goto(637)
	return

/mob/monkey/examine()
	set src in oview()

	usr << "\blue *---------*"
	usr << text("\blue This is \icon[] <B>[]</B>!", src, src.name)
	if (src.handcuffed)
		usr << text("\blue \t[] is handcuffed! \icon[]", src.name, src.handcuffed)
	if (src.mask)
		usr << text("\blue \t[] has a \icon[] [] on \his[] head!", src.name, src.mask, src.mask.name, src)
	if (src.l_hand)
		usr << text("\blue \t[] has a \icon[] [] in \his[] left hand!", src.name, src.l_hand, src.l_hand.name, src)
	if (src.r_hand)
		usr << text("\blue [] has a \icon[] [] in \his[] right hand!", src.name, src.r_hand, src.r_hand.name, src)
	if (src.back)
		usr << text("\blue [] has a \icon[] [] on \his[] back!", src.name, src.back, src.back.name, src)
	if (src.bruteloss)
		if (src.bruteloss < 30)
			usr << text("\red [] looks slightly bruised!", src.name)
		else
			usr << text("\red <B>[] looks severely bruised!</B>", src.name)
	if (src.fireloss)
		if (src.fireloss < 30)
			usr << text("\red [] looks slightly burnt!", src.name)
		else
			usr << text("\red <B>[] looks severely burnt!</B>", src.name)
	return

/mob/monkey/ex_act(severity)

	flick("flash", src.flash)
	switch(severity)
		if(1.0)
			if (src.stat != 2)
				src.bruteloss += 200
				src.health = 100 - src.oxyloss - src.toxloss - src.fireloss - src.bruteloss
		if(2.0)
			if (src.stat != 2)
				src.bruteloss += 60
				src.fireloss += 60
				src.health = 100 - src.oxyloss - src.toxloss - src.fireloss - src.bruteloss
		if(3.0)
			if (src.stat != 2)
				src.bruteloss += 30
				src.health = 100 - src.oxyloss - src.toxloss - src.fireloss - src.bruteloss
			if (prob(50))
				src.paralysis += 10
		else
	return

/mob/monkey/blob_act()
	if (src.stat != 2)
		src.bruteloss += 30
		src.health = 100 - src.oxyloss - src.toxloss - src.fireloss - src.bruteloss
	if (prob(50))
		src.paralysis += 10


/atom/movable/Move(NewLoc, direct)

	if (direct & direct - 1)
		if (direct & 1)
			if (direct & 4)
				if (step(src, NORTH))
					step(src, EAST)
				else
					if (step(src, EAST))
						step(src, NORTH)
			else
				if (direct & 8)
					if (step(src, NORTH))
						step(src, WEST)
					else
						if (step(src, WEST))
							step(src, NORTH)
		else
			if (direct & 2)
				if (direct & 4)
					if (step(src, SOUTH))
						step(src, EAST)
					else
						if (step(src, EAST))
							step(src, SOUTH)
				else
					if (direct & 8)
						if (step(src, SOUTH))
							step(src, WEST)
						else
							if (step(src, WEST))
								step(src, SOUTH)
	else
		..()
	return

/atom/movable/verb/pull()
	set src in oview(1)

	if (!( usr ))
		return
	if (!( src.anchored ))
		usr.pulling = src
	return

/atom/verb/examine()
	set src in oview(12)	//make it work from farther away

	if (!( usr ))
		return
	usr << src.desc
	// *****RM
	//usr << "[src.name]: Dn:[density] dir:[dir] cont:[contents] icon:[icon] is:[icon_state] loc:[loc]"
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

			if (src.mob.restrained())
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

/client/New()
	if (banned.Find(src.ckey))
		del(src)
		return

	if (((world.address == src.address || !(src.address)) && !(host)))
		host = src.key
		world.update_stat()

	..()

	src.authorize()

	spawn (50)
		if (mob.CanAdmin())
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
			mob.CanBuild()
			if (src.holder && src.holder.level == 5)
				src.verbs += /proc/variables
				src.verbs += /mob/proc/Delete

/client/Del()
	if (banned.Find(src.ckey))
		..()
		return
	..()
	del(src.holder)
	return
