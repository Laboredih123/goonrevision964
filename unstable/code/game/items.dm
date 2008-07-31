/obj/point/point()
	set src in oview()

	return

/obj/examine/examine()
	set src in oview()

	return

/obj/proc/alter_health()
	return 1

/obj/proc/relaymove()
	return

/obj/proc/hide(h)
	return



/proc/text2dir(direction)

	switch(uppertext(direction))
		if("NORTH")
			return 1
		if("SOUTH")
			return 2
		if("EAST")
			return 4
		if("WEST")
			return 8
		if("NORTHEAST")
			return 5
		if("NORTHWEST")
			return 9
		if("SOUTHEAST")
			return 6
		if("SOUTHWEST")
			return 10
		else
	return

/proc/get_turf(turf/T as turf)

	while((!( istype(T, /turf) ) && T))
		T = T.loc
	return T
	return

/proc/get_area(area/A)
	while(!istype(A, /area) && A)
		A = A.loc
	return A

/proc/dir2text(direction)

	switch(direction)
		if(1.0)
			return "north"
		if(2.0)
			return "south"
		if(4.0)
			return "east"
		if(8.0)
			return "west"
		if(5.0)
			return "northeast"
		if(6.0)
			return "southeast"
		if(9.0)
			return "northwest"
		if(10.0)
			return "southwest"
		else
	return

/atom/proc/hear(datum/message/M, source)
	return

/obj/item/weapon/table_parts/attackby(obj/item/weapon/W as obj, mob/user as mob)

	if (istype(W, /obj/item/weapon/wrench))
		new /obj/item/weapon/sheet/metal( src.loc )
		//SN src = null
		del(src)

/obj/item/weapon/table_parts/attack_self(mob/user as mob)

	var/state = input(user, "What type of table?", "Assembling Table", null) in list( "sides", "corners", "alone" )
	var/direct = SOUTH
	if (state == "corners")
		direct = input(user, "Direction?", "Assembling Table", null) in list( "northwest", "northeast", "southwest", "southeast" )
	else
		if (state == "sides")
			direct = input(user, "Direction?", "Assembling Table", null) in list( "north", "east", "south", "west" )
	var/obj/table/T = new /obj/table( user.loc )
	T.icon_state = state
	T.dir = text2dir(direct)
	T.add_fingerprint(user)
	//SN src = null
	del(src)
	return
	return

/obj/item/weapon/rack_parts/attackby(obj/item/weapon/W as obj, mob/user as mob)

	if (istype(W, /obj/item/weapon/wrench))
		new /obj/item/weapon/sheet/metal( src.loc )
		//SN src = null
		del(src)
		return
		return
	return

/obj/item/weapon/rack_parts/attack_self(mob/user as mob)

	var/obj/rack/R = new /obj/rack( user.loc )
	R.add_fingerprint(user)
	//SN src = null
	del(src)
	return
	return

/obj/item/weapon/paper_bin/proc/update()

	src.icon_state = text("paper_bin[]", ((src.amount || locate(/obj/item/weapon/paper, src)) ? "1" : null))
	return

/obj/item/weapon/paper_bin/attackby(obj/item/weapon/W as obj, mob/carbon/user as mob)
	if(!istype(user, /mob/carbon))
		return
	if (istype(W, /obj/item/weapon/paper))
		user.drop_item()
		W.loc = src
	else
		if (istype(W, /obj/item/weapon/weldingtool))
			var/obj/item/weapon/weldingtool/T = W
			if ((T.welding && T.weldfuel > 0))
				viewers(user, null) << text("[] burns the paper with the welding tool!", user)
				spawn( 0 )
					src.burn(1800000.0)
					return
		else
			if (istype(W, /obj/item/weapon/igniter))
				viewers(user, null) << text("[] burns the paper with the igniter!", user)
				spawn( 0 )
					src.burn(1800000.0)
					return
	src.update()
	return

/obj/item/weapon/paper_bin/burn(fi_amount)

	flick("paper_binb", src)
	for(var/atom/movable/A as mob|obj in src)
		A.burn(fi_amount)
		//Foreach goto(23)
	if (fi_amount >= 900000.0)
		src.amount = 0
	src.update()
	return

/obj/item/weapon/paper_bin/MouseDrop(mob/carbon/user as mob)
	if(!istype(user, /mob/carbon))
		return
	if (user == usr && (!usr.can_use_hands() && (usr.contents.Find(src) || get_dist(src, usr) <= 1)))
		if (user.hand)
			if (!( user.l_hand ))
				spawn( 0 )
					src.interact(user, 1, 1)
					return
		else
			if (!( user.r_hand ))
				spawn( 0 )
					src.interact(user, 0, 1)
					return
	return

/obj/item/weapon/paper_bin/interact(mob/carbon/user as mob, unused, flag)
	if(!istype(user, /mob/carbon))
		return
	if (flag)
		return ..()
	src.add_fingerprint(user)
	if (locate(/obj/item/weapon/paper, src))
		for(var/obj/item/weapon/paper/P in src)
			if ((user.hand && !( user.l_hand )))
				user.l_hand = P
				P.loc = usr
				P.layer = 20
				P = null
				user.update_clothing()
				break////
			else
				if (!( user.r_hand ))
					user.r_hand = P
					P.loc = user
					P.layer = 20
					P = null
					user.update_clothing()
					break////
			////else
			//Foreach goto(48)
	else
		if (src.amount >= 1)
			src.amount--
			new /obj/item/weapon/paper( usr.loc )
	src.update()
	return

/obj/item/weapon/paper_bin/examine()
	set src in oview(1)

	src.amount = round(src.amount)
	var/n = src.amount
	for(var/obj/item/weapon/paper/P in src)
		n++
		//Foreach goto(33)
	if (n <= 0)
		n = 0
		usr << "There are no papers in the bin."
	else
		if (n == 1)
			usr << "There is one paper in the bin."
		else
			usr << text("There are [] papers in the bin.", n)
	return

/obj/item/weapon/dummy/ex_act()

	return

/obj/item/weapon/dummy/blob_act()

	return

/obj/item/weapon/attackby(obj/item/weapon/W as obj, mob/user)
	// handle putting things into pockets/belt
	var/mob/carbon/MC = user
	if(src.loc == MC && MC.equipped() == W)
		// so the user's holding the target and the attacker
		var/loc = null
		if(MC.belt == src) loc = "belt"
		if(MC.l_store == src) loc = "storage1"
		if(MC.r_store == src) loc = "storage2"

		if(loc)
			. = null
			. = MC.db_click(loc, null)
			if(.)
				return
	return ..()

/obj/item/weapon/ex_act(severity)

	switch(severity)
		if(1.0)
			//SN src = null
			del(src)
			return
		if(2.0)
			if (prob(50))
				//SN src = null
				del(src)
				return
		if(3.0)
			if (prob(5))
				//SN src = null
				del(src)
				return
		else
	return

/obj/item/weapon/blob_act()
	return


//*****RM

/obj/item/weapon/verb/move_to_top()
	set src in oview(1)

	if(!istype(src.loc, /turf) || !usr.can_use_hands())
		return

	var/turf/T = src.loc

	src.loc = null

	src.loc = T


//*****


/obj/item/weapon/proc/attack_self()

	return

/obj/item/weapon/proc/talk_into(datum/message/M, atom/source)

	return

/obj/item/weapon/proc/moved(mob/user as mob, old_loc as turf)

	return

/obj/item/weapon/proc/dropped(mob/user as mob)

	return

/obj/item/weapon/proc/afterattack()

	return
	return

/obj/item/weapon/proc/attack(mob/carbon/M as mob, mob/carbon/attacker as mob, def_zone)
	if(!src.force)
		return
	M.show_viewers("\red <B>[M] has been attacked with [src][attacker ? " by [attacker]." : "."] </B>")
	var/dam = src.force
	if(!istype(M, /mob/carbon))
		M.take_damage(brute = dam)
		return
	if ((M.helmet && M.helmet.brute_protect & 1) || (M.mask && M.mask.brute_protect & 1) && prob(5))
		M.think("\red Your helmet softened the blow.")
		dam /= 2
	else if((M.suit && M.suit.brute_protect & 2) || (M.jumpsuit && M.jumpsuit.brute_protect & 2) && prob(20))
		M.think("\red Your armor softened the blow.")
		dam /= 2

	if (prob(dam + M.dam.brute/5)) //knock 'em out
		if(M.is_conscious())
			M.show_viewers("\red <B>[M] has been knocked unconscious!</B>")
		var/time = rand(1, 12)
		M.knockout_until(time)

	M.take_damage(brute = dam)
	src.add_fingerprint(attacker)
	return

/obj/item/weapon/bedsheet/ex_act(severity)

	if (severity <= 2)
		//SN src = null
		del(src)
		return
	return

/obj/item/weapon/bedsheet/attack_self(mob/carbon/user as mob)

	user.drop_item()
	src.layer = 5
	add_fingerprint(user)
	return

/obj/item/weapon/bedsheet/burn(fi_amount)

	if (fi_amount > 3.0E7)
		spawn( 0 )
			var/t = src.icon_state
			src.icon_state = ""
			src.icon = 'b_items.dmi'
			flick(text("[]", t), src)
			spawn( 14 )
				//SN src = null
				del(src)
				return
				return
			return
	return

/obj/item/weapon/wrapping_paper/examine()
	set src in oview(1)

	..()
	usr << text("There is about [] square units of paper left!", src.amount)
	return

/obj/item/weapon/wrapping_paper/attackby(obj/item/weapon/W as obj, mob/carbon/user as mob)
	if(!istype(user, /mob/carbon))
		return
	if (!( locate(/obj/table, src.loc) ))
		user << "\blue You MUST put the paper on a table!"
	if (W.w_class < 4)
		if ((istype(user.l_hand, /obj/item/weapon/wirecutters) || istype(user.r_hand, /obj/item/weapon/wirecutters)))
			var/a_used = 2 ** (src.w_class - 1)
			if (src.amount < a_used)
				user << "\blue You need more paper!"
				return
			else
				src.amount -= a_used
				user.drop_item()
				var/obj/item/weapon/gift/G = new /obj/item/weapon/gift( src.loc )
				G.size = W.w_class
				G.w_class = G.size + 1
				G.icon_state = text("gift[]", G.size)
				G.gift = W
				W.loc = G
				G.add_fingerprint(user)
				W.add_fingerprint(user)
				src.add_fingerprint(user)
			if (src.amount <= 0)
				new /obj/item/weapon/c_tube( src.loc )
				//SN src = null
				del(src)
				return
		else
			user << "\blue You need scissors!"
	else
		user << "\blue The object is FAR too large!"
	return

/obj/item/weapon/gift/attack_self(mob/carbon/user as mob)

	src.gift.loc = user
	if (user.hand)
		user.l_hand = src.gift
	else
		user.r_hand = src.gift
	src.gift.layer = 20
	src.gift.add_fingerprint(user)
	//SN src = null
	del(src)
	return
	return


/obj/item/weapon/flashbang/attackby(obj/item/weapon/W as obj, mob/user as mob)

	if (istype(W, /obj/item/weapon/screwdriver))
		if (src.det_time == 30)
			src.det_time = 30
			user.think("\blue You set the flashbang for 3 second detonation time.")
			src.desc = "It is set to detonate in 3 seconds."
		else
			src.det_time = 100
			user.think("\blue You set the flashbang for 10 second detonation time.")
			src.desc = "It is set to detonate in 10 seconds."
		src.add_fingerprint(user)
	return

/obj/item/weapon/flashbang/afterattack(atom/target as mob|obj|turf|area, mob/carbon/user as mob)

	if (user.equipped() == src)
		if (!( src.state ))
			user << "\red You prime the flashbang! [det_time/10] seconds!"
			src.state = 1
			src.icon_state = "flashbang1"
			spawn( src.det_time )
				prime()
				return
		user.dir = get_dir(user, target)
		user.drop_item()
		var/t = (isturf(target) ? target : target.loc)
		walk_towards(src, t, 3)
		src.add_fingerprint(user)
	return

/obj/item/weapon/flashbang/interact()

	walk(src, null, null)
	..()
	return

/obj/item/weapon/flashbang/proc/prime()
	//TODO: handle flashbangs in closets properly
	var/turf/T = get_turf(src)
	T.firelevel = T.gas.plasma
	for(var/mob/carbon/M in viewers(T))
		if (locate(/obj/item/weapon/cloaking_device, M))
			for(var/obj/item/weapon/cloaking_device/S in M)
				S.active = 0
				S.icon_state = "shield0"
				//Foreach goto(72)
			M.update_clothing()
		if ((get_dist(M, T) <= 2 || src.loc == M.loc || src.loc == M))
			if(M.hud && M.hud.flash)
				flick("e_flash", M.hud.flash)
			M.knockdown_until(2)
			M << "\red <B>BANG</B>"
			if ((prob(14) || (M == src.loc && prob(70))))
				M.take_ear_damage(15)
			else if (prob(30))
				M.take_ear_damage(10)
			M.take_eye_damage(5)
			if (M == src.loc)
				M.take_eye_damage(5)
				M.take_ear_damage(5)
		else
			if (get_dist(M, T) <= 5)
				if(M.hud && M.hud.flash)
					flick("e_flash", M.hud.flash)

				M.ear_damage += 10
				if (!istype(M.glasses, /obj/item/weapon/clothing/glasses/sunglasses))
					M.knockdown_until(5)
					M.knockout_until(2)
				M << "\red <B>BANG</B>"
			else
				if (istype(M.glasses, /obj/item/weapon/clothing/glasses/sunglasses))
					if(M.hud && M.hud.flash)
						flick("flash", M.hud.flash)
				M.take_eye_damage(2)
				M.take_ear_damage(5)
				M << "\red <B>BANG</B>"
		//Foreach goto(39)
	//SN src = null

	for(var/obj/blob/B in view(8,T))
		var/damage = round(30/(get_dist(B,T)+1))
		B.health -= damage
		B.update()


	del(src)
	return
	return

/obj/item/weapon/flashbang/attack_self(mob/user)

	if (!( src.state ))
		user << "\red You prime the flashbang! [det_time/10] seconds!"
		src.state = 1
		src.icon_state = "flashbang1"
		add_fingerprint(user)
		spawn( src.det_time )
			prime()
			return
	return

/obj/item/weapon/flash/attack(mob/carbon/M, mob/carbon/user)
	if(!istype(M, /mob/carbon))
		return ..()
	if (src.shots > 0)
		var/safety = null
		if (istype(M.glasses, /obj/item/weapon/clothing/glasses/sunglasses))
			safety = 1
		if (!( safety ))
			M.knockdown_until(10)
			if (M.client)
				M.take_eye_damage(1)
				if (M.get_eye_damage() > 10)
					if(M.hud && M.hud.flash)
						flick("e_flash", M.hud.flash)
				else
					if(M.hud && M.hud.flash)
						flick("flash", M.hud.flash)
		user.show_viewers(text("\red [] blinds [] with the flash!", user, M))

	src.attack_self(user, 1)
	return

/obj/item/weapon/flash/attack_self(mob/carbon/user as mob, flag)
	if(!user.check_dexterity())
		return
	if ( (world.time + 600) > src.l_time)
		src.shots = 5
	if (src.shots < 1)
		user.hear("\red *click* *click*", 2)
		return
	src.l_time = world.time
	add_fingerprint(user)
	src.shots--
	flick("flash2", src)
	if (!( flag ))
		for(var/mob/carbon/M in oviewers(3))
			if (prob(50))
				if (locate(/obj/item/weapon/cloaking_device, M))
					for(var/obj/item/weapon/cloaking_device/S in M)
						S.active = 0
						S.icon_state = "shield0"
						//Foreach goto(201)
					M.update_clothing()
			if (M.client)
				var/safety = null
				if (istype(M, /mob/carbon))
					var/mob/carbon/H = M
					if (istype(H.glasses, /obj/item/weapon/clothing/glasses/sunglasses))
						safety = 1
				if (!( safety ))
					if(M.hud && M.hud.flash)
						flick("flash", M.hud.flash)
			//Foreach goto(160)
	return

/obj/item/weapon/syndicate_uplink/proc/explode()

	var/turf/T = get_turf(src.loc)
	T.firelevel = T.gas.plasma
	T.reset_phases()
	var/sw = locate(max(T.x - 4, 1), max(T.y - 4, 1), T.z)
	var/ne = locate(min(T.x + 4, world.maxx), min(T.y + 4, world.maxy), T.z)
	for(var/turf/U in block(sw, ne))
		var/zone = 4
		if ((U.y <= T.y + 2 && U.y >= T.y - 2 && U.x <= T.x + 2 && U.x >= T.x - 2))
			zone = 3
		for(var/atom/A as mob|obj|turf|area in U)
			A.ex_act(zone)
			//Foreach goto(209)
		U.ex_act(zone)
		U.buildlinks()
		//Foreach goto(109)
	//src.master = null
	del(src.master)
	//SN src = null
	del(src)
	return
	return

/obj/item/weapon/syndicate_uplink/attack_self(mob/user as mob)

	user.machine = src
	var/dat
	if (src.selfdestruct)
		dat = "Self Destructing..."
	else
		if (src.temp)
			dat = text("[]<BR><BR><A href='?src=\ref[];temp=1'>Clear</A>", src.temp, src)
		else
			var/dat2 = ""
			if (src.origradio)
				dat2 = text("\n<A href='?src=\ref[];lock=1'>Lock</A><BR>\n<HR>", src)
			dat = text("<B>Syndicate Uplink Console:</B>\n<HR>\nTele-Crystals left: []<BR>\n<B>Request item:</B> (uses 1 tele-crystal)<BR>\n<A href='?src=\ref[];item_emag=1'>Electromagnet Card</A><BR>\n<A href='?src=\ref[];item_sleepypen=1'>Sleepy Pen</A><BR>\n<A href='?src=\ref[];item_cyanide=1'>Cyanide Pill</A><BR>\n<A href='?src=\ref[];item_cloak=1'>Cloaking Device</A><BR>\n<A href='?src=\ref[];item_revolver=1'>Revolver</A><BR>\n<A href='?src=\ref[];item_imp_freedom=1'>Implant- Freedom (with injector)</A><BR>\n<A href='?src=\ref[];item_ai_module=1'>'OxygenIsToxicToHumans' AI Module</A><BR>\n<HR>[]\n<A href='?src=\ref[];selfdestruct=1'>Self-Destruct</A>", src.uses, src, src, src, src, src, src, src, dat2, src)
	user << browse(dat, "window=radio")
	return

/obj/item/weapon/syndicate_uplink/Topic(href, href_list)
	..()
	if (!usr.can_use_hands())
		return
	if(!istype(usr, /mob/carbon))
		return
	var/mob/carbon/H = usr
	if ((usr.contents.Find(src) || (get_dist(src, usr) <= 1 && istype(src.loc, /turf))))
		usr.machine = src
		if (href_list["item_emag"])
			if (src.uses > 0)
				src.uses--
				new /obj/item/weapon/card/emag( H.loc )
		else if (href_list["item_sleepypen"])
			if (src.uses > 0)
				src.uses--
				new /obj/item/weapon/pen/sleepypen( H.loc )
		else if (href_list["item_cyanide"])
			if (src.uses > 0)
				src.uses--
				new /obj/item/weapon/m_pill/cyanide( H.loc )
		else if (href_list["item_cloak"])
			if (src.uses > 0)
				src.uses--
				new /obj/item/weapon/cloaking_device( H.loc )
		else if (href_list["item_revolver"])
			if (src.uses > 0)
				src.uses--
				var/obj/item/weapon/gun/revolver/O = new /obj/item/weapon/gun/revolver( H.loc )
				O.bullets = 7
		else if (href_list["item_imp_freedom"])
			if (src.uses > 0)
				src.uses--
				var/obj/item/weapon/implanter/O = new /obj/item/weapon/implanter( H.loc )
				O.imp = new /obj/item/weapon/implant/freedom( O )
				src.temp = "The implant is triggered by chuckling and has a random amount of uses."
		else if (href_list["item_ai_module"])
			if (src.uses > 0)
				src.uses--
				new /obj/item/weapon/aiModule/oxygen( H.loc )
		else if (href_list["lock"])
			// presto chango, a regular radio again! (reset the freq too...)
			usr.machine = null
			usr << browse(null, "window=radio")
			var/obj/item/weapon/radio/T = src.origradio
			var/obj/item/weapon/syndicate_uplink/R = src
			R.loc = T
			T.loc = usr
			// R.layer = initial(R.layer)
			R.layer = 0
			if(!istype(usr, /mob/carbon))
				return
			var/mob/carbon/user = usr
			if (usr.client)
				usr.client.screen -= R
			if (user.r_hand == R)
				user.u_equip(R)
				user.r_hand = T
			else
				user.u_equip(R)
				user.l_hand = T
			R.loc = T
			T.layer = 20
			T.freq = initial(T.freq)
			T.attack_self(usr)
			return
		else if (href_list["selfdestruct"])
			src.temp = text("<A href='?src=\ref[];selfdestruct2=1'>Self-Destruct</A>", src)
		else if (href_list["selfdestruct2"])
			src.selfdestruct = 1
			spawn( 100 )
				explode()
				return
		else
			if (href_list["temp"])
				src.temp = null
		if (istype(src.loc, /mob))
			attack_self(src.loc)
		else
			for(var/mob/M in viewers(1, src))
				if (M.client)
					src.attack_self(M)
				//Foreach goto(488)
	return

/obj/item/weapon/sword/attack(target as mob, mob/user as mob)
	..()

/obj/item/weapon/sword/attack_self(mob/user as mob)

	src.active = !( src.active )
	if (src.active)
		user << "\blue The sword is now active."
		src.force = 40
		src.icon_state = "sword1"
		src.w_class = 4
	else
		user << "\blue The sword can now be concealed."
		src.force = 3
		src.icon_state = "sword0"
		src.w_class = 2
	src.add_fingerprint(user)
	return

/obj/item/weapon/cloaking_device/attack_self(mob/carbon/user as mob)

	src.active = !( src.active )
	if (src.active)
		user << "\blue The cloaking device is now active."
		src.force = 40
		src.icon_state = "shield1"
	else
		user << "\blue The cloaking device is now inactive."
		src.force = 3
		src.icon_state = "shield0"
	src.add_fingerprint(user)
	user.update_clothing()
	return

/obj/item/weapon/ammo/proc/update_icon()

	return

/obj/item/weapon/ammo/a357/update_icon()

	src.icon_state = text("357-[]", src.amount_left)
	src.desc = text("There are [] bullet\s left!", src.amount_left)
	return

/obj/item/weapon/gun/revolver/examine()
	set src in usr

	src.desc = text("There are [] bullet\s left! Uses 357.", src.bullets)
	..()
	return

/obj/item/weapon/gun/revolver/attackby(obj/item/weapon/ammo/a357/A as obj, mob/user as mob)

	if (istype(A, /obj/item/weapon/ammo/a357))
		if (src.bullets >= 7)
			user << "\blue It's already fully loaded!"
			return 1
		if (A.amount_left <= 0)
			user << "\red There is no more bullets!"
			return 1
		if (A.amount_left < (7 - src.bullets))
			src.bullets += A.amount_left
			user << text("\red You reload [] bullet\s!", A.amount_left)
			A.amount_left = 0
		else
			user << text("\red You reload [] bullet\s!", 7 - src.bullets)
			A.amount_left -= 7 - src.bullets
			src.bullets = 7
		A.update_icon()
		return 1
	return

/obj/item/weapon/gun/revolver/afterattack(atom/target as mob|obj|turf|area, mob/user as mob, flag)

	if (flag)
		return
	if (!user.check_dexterity())
		return
	src.add_fingerprint(user)
	if (src.bullets < 1)
		user.hear("\red *click* *click*", 2)
		return
	src.bullets--
	user.show_viewers(text("\red <B>[] fires a revolver at []!</B>", user, target))
	var/turf/T = user.loc
	var/turf/U = (istype(target, /atom/movable) ? target.loc : target)
	if ((!( U ) || !( T )))
		return
	while(!( istype(U, /turf) ))
		U = U.loc
	if (!( istype(T, /turf) ))
		return
	if (U == T)
		user.las_act()
		return
	var/obj/bullet/A = new /obj/bullet( user.loc )
	if (!( istype(U, /turf) ))
		//A = null
		del(A)
		return
	A.current = U
	A.yo = U.y - T.y
	A.xo = U.x - T.x
	user.next_move = world.time + 4
	spawn( 0 )
		A.process()
		return
	return

/obj/item/weapon/gun/revolver/attack(mob/M as mob, mob/carbon/user as mob)

	src.add_fingerprint(user)
	if(!istype(M, /mob/carbon))
		return ..()
	var/mob/carbon/H = M

	if ((istype(H, /mob/carbon) && istype(H, /obj/item/weapon/clothing/head) && H.flags & 8 && prob(80)))
		M << "\red The helmet protects you from being hit hard in the head!"
		return
	if ((user.intent == "hurt" && src.bullets > 0))
		if (prob(20))
			H.knockout_until(5)
		else
			H.knockdown_until(5)
		src.bullets--
		src.force = 75
		..()
		src.force = 60
		M.show_viewers(text("\red <B>[] has been shot point-blank by []!</B>", M, user), 1, "\red You hear someone fall", 2)
	else
		H.knockdown_until(5)
		src.force = 30
		..()
		M.show_viewers(text("\red <B>[] has been pistol whipped []!</B>", M, user))
			//Foreach goto(315)
	return

/obj/item/weapon/gun/energy/proc/update_icon()

	var/ratio = src.charges / 10
	ratio = round(ratio, 0.25) * 100
	src.icon_state = text("gun[]", ratio)
	return

/obj/item/weapon/gun/energy/laser_gun/afterattack(atom/target as mob|obj|turf|area, mob/user as mob, flag)

	if (flag)
		return
	if (!user.check_dexterity())
		return
	src.add_fingerprint(user)
	if (src.charges < 1)
		user.hear("\red *click* *click*", 2)
		return
	src.charges--
	update_icon()
	var/turf/T = user.loc
	var/atom/U = (istype(target, /atom/movable) ? target.loc : target)
	if ((!( U ) || !( T )))
		return
	while(!( istype(U, /turf) ))
		U = U.loc
	if (!( istype(T, /turf) ))
		return
	if (U == T)
		user.las_act()
		return
	var/obj/beam/a_laser/A = new /obj/beam/a_laser( user.loc )
	if (!( istype(U, /turf) ))
		//A = null
		del(A)
		return
	A.current = U
	A.yo = U.y - T.y
	A.xo = U.x - T.x
	user.next_move = world.time + 4
	spawn( 0 )
		A.process()
		return
	return

/obj/item/weapon/gun/energy/laser_gun/attack(mob/carbon/M as mob, mob/user as mob)

	..()
	src.add_fingerprint(user)
	if(!istype(M, /mob/carbon))
		return
	if ((prob(30) && !M.is_dead))
		var/mob/carbon/H = M
		if (istype(H, /obj/item/weapon/clothing/head) && H.flags & 8 && prob(80))
			H.think("\red The helmet protects you from being hit hard in the head!")
			return
		H.knockdown_until(rand(1,12))
		H.show_viewers(text("\red <B>[] has been knocked unconscious!</B>", M))
	return

/obj/item/weapon/gun/energy/taser_gun/update_icon()

	var/ratio = src.charges / maximum_charges
	ratio = round(ratio, 0.25) * 100
	src.icon_state = text("t_gun[]", ratio)
	return

/obj/item/weapon/gun/energy/taser_gun/afterattack(atom/target as mob|obj|turf|area, mob/user as mob, flag)

	if (flag)
		return
	if (!user.check_dexterity())
		return
	src.add_fingerprint(user)
	if (src.charges < 1)
		user.hear("\red *click* *click*")
		return
	src.charges--
	update_icon()
	var/turf/T = user.loc
	var/turf/U = (istype(target, /atom/movable) ? target.loc : target)
	if ((!( U ) || !( T )))
		return
	while((!( istype(U, /turf) ) && U))
		U = U.loc
	if (!( istype(T, /turf) ))
		return
	if (U == T)
		user.las_act(1)
		return
	var/obj/beam/a_laser/s_laser/A = new /obj/beam/a_laser/s_laser( user.loc )
	if (!( istype(U, /turf) ))
		//A = null
		del(A)
		return
	A.current = U
	A.yo = U.y - T.y
	A.xo = U.x - T.x
	spawn( 0 )
		A.process()
		return
	return

/obj/item/weapon/gun/energy/taser_gun/attack(mob/M as mob, mob/carbon/user as mob)

	src.add_fingerprint(user)
	if(!istype(M, /mob/carbon))
		return ..()
	var/mob/carbon/H = M
	if ((istype(H, /mob/carbon) && istype(H, /obj/item/weapon/clothing/head) && H.flags & 8 && prob(80)))
		H << "\red The helmet protects you from being hit hard in the head!"
		return
	if(src.charges >= 1)
		if (user.intent == "hurt")
			if (prob(20))
				H.knockout_until(5)
			H.knockdown_until(10)
			..()
			H.show_viewers("\red <B>[H] has been knocked unconscious!</B>")
		else
			if (prob(50))
				H.knockout_until(5)
			else
				H.knockdown_until(5)
			M.show_viewers("\red <B>[M] has been stunned with the taser gun by [user]!</B>")
		src.charges--
		update_icon()
	else // no charges in the gun, so they just wallop the target with it
		..()

/obj/item/weapon/baton/attack(mob/carbon/M as mob, mob/carbon/user as mob)
	src.add_fingerprint(user)
	if (istype(M.helmet, /obj/item/weapon/clothing/head/helmet) && M.helmet.flags & 8 && prob(80))
		M << "\red The helmet protects you from being hit hard in the head!"
		return
	flick("baton_active", src)
	if (user.intent == "hurt")
		M.knockdown_until(5)
		..()
	else
		M.knockdown_until(20)
	M.show_viewers("\red <B>[M] has been stunned with the stun baton by [user]!</B>")

/obj/item/weapon/pill_canister/New()

	..()
	src.pixel_x = rand(-10.0, 10)
	src.pixel_y = rand(-10.0, 10)
	return

/obj/item/weapon/pill_canister/placebo/New()

	..()
	spawn( 2 )
		var/obj/item/weapon/m_pill/P = new /obj/item/weapon/m_pill( src )
		P.amount = 30
		return
	return

/obj/item/weapon/pill_canister/antitoxin/New()

	..()
	spawn( 2 )
		var/obj/item/weapon/m_pill/antitoxin/P = new /obj/item/weapon/m_pill/antitoxin( src )
		P.amount = 30
		return
	return

/obj/item/weapon/pill_canister/Tourette/New()

	..()
	spawn( 2 )
		var/obj/item/weapon/m_pill/Tourette/P = new /obj/item/weapon/m_pill/Tourette( src )
		P.amount = 30
		return
	return

/obj/item/weapon/pill_canister/sleep/New()

	..()
	spawn( 2 )
		var/obj/item/weapon/m_pill/sleep/P = new /obj/item/weapon/m_pill/sleep( src )
		P.amount = 30
		return
	return

/obj/item/weapon/pill_canister/epilepsy/New()

	..()
	spawn( 2 )
		var/obj/item/weapon/m_pill/epilepsy/P = new /obj/item/weapon/m_pill/epilepsy( src )
		P.amount = 30
		return
	return

/obj/item/weapon/pill_canister/cough/New()

	..()
	spawn( 2 )
		var/obj/item/weapon/m_pill/cough/P = new /obj/item/weapon/m_pill/cough( src )
		P.amount = 30
		return
	return

/obj/item/weapon/pill_canister/examine()
	set src in view(1)

	..()
	if (src.contents.len)
		var/pills = 0
		for(var/obj/item/weapon/m_pill/M in src)
			pills += M.amount
			//Foreach goto(39)
		usr << text("\blue There are [] pills inside!", pills)
	else
		usr << "\blue It looks empty!"
	return

/obj/item/weapon/pill_canister/interact(mob/carbon/user as mob)
	if(!istype(user, /mob/carbon))
		return
	if(!user.check_intelligence())
		return
	if ((user.r_hand == src || user.l_hand == src) && src.contents && src.contents.len)
		var/obj/item/weapon/m_pill/P = pick(src.contents)
		if (P)
			P.amount--
			var/obj/item/weapon/m_pill/W = new P.type( user )
			if (user.hand)
				user.l_hand = W
			else
				user.r_hand = W
			W.layer = 20
			if (P.amount <= 0)
				//P = null
				del(P)
			W.add_fingerprint(user)
			src.add_fingerprint(user)
			user.update_clothing()
	else
		return ..()
	return

/obj/item/weapon/pill_canister/attackby(obj/item/weapon/W as obj, mob/carbon/user as mob)
	if(!istype(user, /mob/carbon))
		return
	if (istype(W, /obj/item/weapon/m_pill))
		var/pills = 0
		for(var/obj/item/weapon/m_pill/M in src)
			pills += M.amount
			//Foreach goto(34)
		if (pills > 30)
			usr << "\blue There are too many pills inside!"
			return
		for(var/obj/item/weapon/m_pill/M in src)
			if (M.type == W.type)
				M.amount += W:amount
				//W = null
				del(W)
				return
			//Foreach goto(97)
		if (W)
			user.drop_item()
			W.loc = src
			src.add_fingerprint(user)
			W.add_fingerprint(user)
	if (istype(W, /obj/item/weapon/pen))
		var/t = input(user, "What would you like the label to be?", text("[]", src.name), null)  as text
		if (user.equipped() != W)
			return
		if (src.loc != user)
			return
		t = html_encode(t)
		if (t)
			src.name = text("Pill Canister- '[]'", t)
		else
			src.name = "Pill Canister"
	return

/obj/item/weapon/m_pill/proc/ingest(mob/M as mob)

	src.amount--
	if (src.amount <= 0)
		//SN src = null
		del(src)
		return
	return

/obj/item/weapon/m_pill/interact(mob/carbon/user as mob)
	if(!istype(user, /mob/carbon))
		return
	if ((user.r_hand == src || user.l_hand == src))
		src.add_fingerprint(user)
		var/obj/item/weapon/m_pill/F = new src.type( user )
		F.amount = 1
		src.amount--
		if (user.hand)
			user.l_hand = F
		else
			user.r_hand = F
		F.layer = 20
		F.add_fingerprint(user)
		if (src.amount < 1)
			//SN src = null
			del(src)
			return
	else
		..()
	return

/obj/item/weapon/m_pill/attack(mob/carbon/M as mob, mob/user as mob)
	if(!istype(M, /mob/carbon))
		return
	if ((M.helmet && M.helmet.flags & HEADCOVERSMOUTH) || (M.mask && M.mask.flags & MASKCOVERSMOUTH))
		user.think("\blue You're going to need to remove [(user == M) ? "your" : "their"] mask/helmet first.")
		return
	if (user != M )
		M.show_viewers(text("\red [] is forcing [] to swallow the []", user, M, src), 1)
		var/obj/equip_e/O = new /obj/equip_e(  )
		O.source = user
		O.target = M
		O.item = src
		O.s_loc = user.loc
		O.t_loc = M.loc
		O.place = "pill"
		M.requests += O
		spawn( 0 )
			O.process()
			return
	else
		src.add_fingerprint(user)
		src.ingest(M)
	return

/obj/item/weapon/m_pill/superpill/ingest(mob/carbon/M as mob)
	var/dam = M.get_damage()
	M.heal_damage(brute = dam, burn = dam, suffocation = dam, toxin = dam, electric = dam)
	M.knockout_until(5)
	M.knockdown_until(10)
	..()
	return

/obj/item/weapon/m_pill/sleep/ingest(mob/carbon/M as mob)

	if (M.drowsyness < 600)
		M.drowsyness += 600
	M.drowsyness = min(M.drowsyness, 1800)
	if (prob(50))
		M.knockdown_until(10)
	..()
	return

/obj/item/weapon/m_pill/cyanide/ingest(mob/carbon/M as mob)

	M.take_damage(toxin = ((M.death_threshold - M.get_damage()) - 50))
	..()
	return

/obj/item/weapon/m_pill/antitoxin/ingest(mob/carbon/M as mob)
	M.drowsyness = min(M.drowsyness + 60, 600)
	if(M.get_damage() < M.unconsciousness_threshold)
		M.heal_damage(toxin = 20)
	M.antitoxs += 600
	..()
	return

/obj/item/weapon/m_pill/cough/ingest(mob/carbon/M as mob)

	if ((prob(75) && M.drowsyness < 600))
		M.drowsyness += 60
	M.drowsyness = min(M.drowsyness, 600)
	..()
	return

/obj/item/weapon/m_pill/epilepsy/ingest(mob/carbon/M as mob)

	if (M.drowsyness < 600)
		M.drowsyness += rand(2, 3) * 60
	M.drowsyness = min(M.drowsyness, 600)
	..()
	return

/obj/item/weapon/m_pill/Tourette/ingest(mob/carbon/M as mob)

	if (M.drowsyness < 600)
		M.drowsyness += rand(3, 5) * 60
	M.drowsyness = min(M.drowsyness, 600)
	//TODO: Add better pill effects
	..()
	return

/obj/item/weapon/m_pill/examine()
	set src in view(1)

	..()
	usr << text("\blue There are [] pills left on the stack!", src.amount)
	return

/obj/item/weapon/m_pill/attackby(obj/item/weapon/m_pill/W as obj, mob/user as mob)

	if (!( istype(W, src.type) ))
		return
	if (W.amount == 5)
		return
	if (W.amount + src.amount > 5)
		src.amount = W.amount + src.amount - 5
		W.amount = 5
	else
		W.amount += W.amount
		//SN src = null
		del(src)
		return
	return

/obj/item/weapon/handcuffs/attack(mob/carbon/M as mob, mob/carbon/user as mob)
	if (!user.check_dexterity())
		return
	var/obj/equip_e/O = new /obj/equip_e()
	O.source = user
	O.target = M
	O.item = user.equipped()
	O.s_loc = user.loc
	O.t_loc = M.loc
	O.place = SLOT_HANDCUFFS
	M.requests += O
	spawn( 0 )
		O.process()
		return
	return

/obj/item/weapon/examine()
	set src in view()

	var/t
	switch(src.w_class)
		if(1.0)
			t = "tiny"
		if(2.0)
			t = "small"
		if(3.0)
			t = "normal-sized"
		if(4.0)
			t = "bulky"
		if(5.0)
			t = "huge"
		else
	usr << text("This is a \icon[][]. It is a [] item.", src, src.name, t)
	..()
	return

/obj/item/weapon/interact(mob/carbon/user as mob)
	if(!istype(user, /mob/carbon))
		return
	if (istype(src.loc, /obj/item/weapon/storage))
		for(var/mob/carbon/M in range(1, src.loc))
			if (M.s_active == src.loc)
				if (M.client)
					M.client.screen -= src
			//Foreach goto(34)
	src.throwing = 0
	if (src.loc == user)
		user.u_equip(src)
	if (user.hand)
		user.l_hand = src
	else
		user.r_hand = src
	src.loc = user
	src.layer = 20
	add_fingerprint(user)
	user.update_clothing()
	return

/obj/item/weapon/wire/proc/update()

	if (src.amount > 1)
		src.icon_state = "spool_wire"
		src.desc = text("This is just spool of regular insulated wire. It consists of about [] unit\s of wire.", src.amount)
	else
		src.icon_state = "item_wire"
		src.desc = "This is just a simple piece of regular insulated wire."
	return

/obj/item/weapon/wire/attack_self(mob/user as mob)

	if (src.laying)
		src.laying = 0
		user << "\blue Your done laying wire!"
	else
		user << "\blue You are not using this to lay wire..."
	return

/obj/item/weapon/card/data/verb/label(t as text)
	set src in usr

	if (t)
		src.name = text("Data Disk- '[]'", t)
	else
		src.name = "Data Disk"
	src.add_fingerprint(usr)
	return

/obj/item/weapon/card/id/attack_self(mob/user as mob)
	user.show_viewers(text("[] shows you: \icon[] []: assignment: []", user, src, src.name, src.assignment))
	src.add_fingerprint(user)
	return

/obj/item/weapon/card/id/verb/read()
	set src in usr

	usr << text("\icon[] []: The current assignment on the card is [].", src, src.name, src.assignment)
	return

/obj/item/weapon/rods/interact(mob/carbon/user as mob)
	if(!istype(user, /mob/carbon))
		return
	if ((user.r_hand == src || user.l_hand == src))
		src.add_fingerprint(user)
		var/obj/item/weapon/rods/F = new /obj/item/weapon/rods( user )
		F.amount = 1
		src.amount--
		if (user.hand)
			user.l_hand = F
		else
			user.r_hand = F
		F.layer = 20
		F.add_fingerprint(user)
		if (src.amount < 1)
			//SN src = null
			del(src)
			return
	else
		..()
	return

/obj/item/weapon/rods/attackby(obj/item/weapon/rods/W as obj, mob/user as mob)

	if (!( istype(W, /obj/item/weapon/rods) ))
		return
	if (W.amount == 6)
		return
	if (W.amount + src.amount > 6)
		src.amount = W.amount + src.amount - 6
		W.amount = 6
	else
		W.amount += src.amount
		//SN src = null
		del(src)
		return
	return

/obj/item/weapon/rods/examine()
	set src in view(1)

	..()
	usr << text("There are [] rod\s left on the stack.", src.amount)
	return

/obj/item/weapon/rods/attack_self(mob/user as mob)

	if (locate(/obj/grille, usr.loc))
		for(var/obj/grille/G in usr.loc)
			if (G.destroyed)
				G.health = 10
				G.density = 1
				G.destroyed = 0
				G.icon_state = "grille"
				src.amount--
			else
				//Foreach continue //goto(30)
	else
		if (src.amount < 2)
			return
		src.amount -= 2
		new /obj/grille( usr.loc )
	if (src.amount < 1)
		//SN src = null
		del(src)
		return
	src.add_fingerprint(user)
	return

/obj/item/weapon/sheet/metal/interact(mob/carbon/user as mob)
	if(!istype(user, /mob/carbon))
		return
	if ((user.r_hand == src || user.l_hand == src))
		src.add_fingerprint(user)
		var/obj/item/weapon/sheet/metal/F = new /obj/item/weapon/sheet/metal( user )
		F.amount = 1
		src.amount--
		if (user.hand)
			user.l_hand = F
		else
			user.r_hand = F
		F.layer = 20
		F.add_fingerprint(user)
		if (src.amount < 1)
			//SN src = null
			user.u_equip(src)
			user.update_clothing()
			del(src)
			return
	else
		..()
	src.force = 5
	return

/obj/item/weapon/sheet/metal/attackby(obj/item/weapon/sheet/metal/W as obj, mob/carbon/user as mob)

	if (!( istype(W, /obj/item/weapon/sheet/metal) ))
		return
	if (W.amount >= 5)
		return
	if (W.amount + src.amount > 5)
		src.amount = W.amount + src.amount - 5
		W.amount = 5
	else
		W.amount += src.amount
		//SN src = null
		user.u_equip(src)
		user.update_clothing()
		del(src)
		return
	return

/obj/item/weapon/sheet/metal/examine()
	set src in view(1)

	..()
	usr << text("There are [] metal sheet\s on the stack.", src.amount)
	return

/obj/item/weapon/sheet/metal/attack_self(mob/user as mob)

	var/t1 = text("<HTML><HEAD></HEAD><TT>Amount Left: [] <BR>", src.amount)
	var/counter = 1
	var/list/L = list(  )
	L["rods"] = "metal rods (makes 2)"
	L["stool"] = "stool"
	L["chair"] = "chair"
	L["table"] = "table parts (2)"
	L["rack"] = "rack parts"
	L["o2can"] = "o2 canister (2)"
	L["plcan"] = "pl canister (2)"
	L["closet"] = "closet (2)"
	L["fl_tiles"] = "floor tiles (makes 4)"
	L["reinforced"] = "reinforced sheet (2) (Doesn't stack)"
	L["construct"] = "construct wall"
	for(var/t in L)
		counter++
		t1 += text("<A href='?src=\ref[];make=[]'>[]</A>  ", src, t, L[t])
		if (counter > 2)
			counter = 1
			t1 += "<BR>"
		//Foreach goto(186)
	t1 += "</TT></HTML>"
	user << browse(t1, "window=met_sheet")
	return

/obj/item/weapon/sheet/metal/Topic(href, href_list)
	..()
	if(!istype(usr, /mob/carbon))
		return
	var/mob/carbon/user = usr
	if ((!user.can_use_hands() || user.equipped() != src))
		return
	if (href_list["make"])
		if (src.amount < 1)
			//SN src = null
			del(src)
			return
		switch(href_list["make"])
			if("rods")
				src.amount--
				var/obj/item/weapon/rods/R = new /obj/item/weapon/rods( usr.loc )
				R.amount = 2
			if("table")
				if (src.amount < 2)
					return
				src.amount -= 2
				new /obj/item/weapon/table_parts( usr.loc )
			if("stool")
				src.amount--
				new /obj/stool( usr.loc )
			if("chair")
				src.amount--
				var/obj/stool/chair/C = new /obj/stool/chair( usr.loc )
				C.dir = usr.dir
				if (C.dir == NORTH)
					C.layer = 5
			if("rack")
				src.amount--
				new /obj/item/weapon/rack_parts( usr.loc )
			if("o2can")
				if (src.amount < 2)
					return
				src.amount -= 2
				var/obj/machinery/atmoalter/canister/oxygencanister/C = new /obj/machinery/atmoalter/canister/oxygencanister( usr.loc )
				C.gas.oxygen = 0
			if("plcan")
				if (src.amount < 2)
					return
				src.amount -= 2
				var/obj/machinery/atmoalter/canister/poisoncanister/C = new /obj/machinery/atmoalter/canister/poisoncanister( usr.loc )
				C.gas.plasma = 0
			if("reinforced")
				if (src.amount < 2)
					return
				src.amount -= 2
				var/obj/item/weapon/sheet/r_metal/C = new /obj/item/weapon/sheet/r_metal( usr.loc )
				C.amount = 1
			if("closet")
				if (src.amount < 2)
					return
				src.amount -= 2
				new /obj/closet( usr.loc )
			if("fl_tiles")
				src.amount--
				var/obj/item/weapon/tile/R = new /obj/item/weapon/tile( usr.loc )
				R.amount = 4
			if("construct")
				if (src.amount < 2)
					return
				src.amount -= 2
				var/turf/F = usr.loc
				if (!( istype(F, /turf/station/floor) ))
					return
				var/turf/station/wall/W = F.ReplaceWithWall()

				W.icon_state = "girder"
				W.updatecell = 1
				W.opacity = 0
				W.state = 1
				W.density = 1
				W.levelupdate()
		if (src.amount <= 0)
			//SN src = null
			user.u_equip(src)
			user.update_clothing()
			del(src)
			user << browse(null, "window=met_sheet")
			return
	spawn( 0 )
		src.attack_self(usr)
		return
	return

/obj/item/weapon/sheet/glass/interact(mob/carbon/user as mob)
	if(!istype(user, /mob/carbon))
		return
	if ((user.r_hand == src || user.l_hand == src))
		src.add_fingerprint(user)
		var/obj/item/weapon/sheet/glass/F = new /obj/item/weapon/sheet/glass( user )
		F.amount = 1
		src.amount--
		if (user.hand)
			user.l_hand = F
		else
			user.r_hand = F
		F.layer = 20
		F.add_fingerprint(user)
		if (src.amount < 1)
			//SN src = null
			del(src)
			return
	else
		..()
	src.force = 5
	return

/obj/item/weapon/sheet/glass/attackby(obj/item/weapon/W, mob/user)

	if ( istype(W, /obj/item/weapon/sheet/glass) )
		var/obj/item/weapon/sheet/glass/G = W
		if (G.amount >= 5)
			return
		if (G.amount + src.amount > 5)
			src.amount = G.amount + src.amount - 5
			G.amount = 5
		else
			G.amount += src.amount
			//SN src = null
			del(src)
			return
		return
	else if( istype(W, /obj/item/weapon/rods) )

		var/obj/item/weapon/rods/V  = W
		var/obj/item/weapon/sheet/rglass/R = new /obj/item/weapon/sheet/rglass(user.loc)
		R.loc = user.loc
		R.add_fingerprint(user)


		if(V.amount == 1)

			if(user.client)
				user.client.screen -= V

			user.u_equip(W)
			del(W)
		else
			V.amount--


		if(src.amount == 1)

			if(user.client)
				user.client.screen -= src

			user.u_equip(src)
			del(src)
		else
			src.amount--
			return



/obj/item/weapon/sheet/glass/examine()
	set src in view(1)

	..()
	usr << text("There are [] glass sheet\s on the stack.", src.amount)
	return

/obj/item/weapon/sheet/glass/attack_self(mob/user as mob)

	if (!( istype(usr.loc, /turf/station) ))
		return
	if (!user.check_dexterity())
		return
	switch(alert("Sheet-Glass", "Would you like full tile glass or one direction?", "one direct", "full (2 sheets)", "cancel", null))
		if("one direct")
			var/obj/window/W = new /obj/window( usr.loc )
			W.anchored = 0
			if (src.amount < 1)
				return
			src.amount--
		if("full (2 sheets)")
			if (src.amount < 2)
				return
			src.amount -= 2
			var/obj/window/W = new /obj/window( usr.loc )
			W.dir = SOUTHWEST
			W.ini_dir = SOUTHWEST
			W.anchored = 0
		else
	if (src.amount <= 0)
		user.u_equip(src)
		//SN src = null
		del(src)
		return
	return

/obj/item/weapon/sheet/rglass/interact(mob/carbon/user as mob)
	if(!istype(user, /mob/carbon))
		return
	if ((user.r_hand == src || user.l_hand == src))
		src.add_fingerprint(user)
		var/obj/item/weapon/sheet/rglass/F = new /obj/item/weapon/sheet/rglass( user )
		F.amount = 1
		src.amount--
		if (user.hand)
			user.l_hand = F
		else
			user.r_hand = F
		F.layer = 20
		F.add_fingerprint(user)
		if (src.amount < 1)
			//SN src = null
			del(src)
			return
	else
		..()
	src.force = 5
	return

/obj/item/weapon/sheet/rglass/attackby(obj/item/weapon/sheet/rglass/W as obj, mob/user as mob)

	if (!( istype(W, /obj/item/weapon/sheet/rglass) ))
		return
	if (W.amount >= 5)
		return
	if (W.amount + src.amount > 5)
		src.amount = W.amount + src.amount - 5
		W.amount = 5
	else
		W.amount += src.amount
		//SN src = null
		del(src)
		return
	return

/obj/item/weapon/sheet/rglass/examine()
	set src in view(1)

	..()
	usr << text("There are [] reinforced glass sheet\s on the stack.", src.amount)
	return

/obj/item/weapon/sheet/rglass/attack_self(mob/user as mob)

	if (!( istype(usr.loc, /turf/station) ))
		return
	if (!user.check_dexterity())
		return
	switch(alert("Sheet Reinf. Glass", "Would you like full tile glass or one direction?", "one direct", "full (2 sheets)", "cancel", null))
		if("one direct")
			var/obj/window/W = new /obj/window( usr.loc, 1 )
			W.anchored = 0
			W.state = 0
			if (src.amount < 1)
				return
			src.amount--
		if("full (2 sheets)")
			if (src.amount < 2)
				return
			src.amount -= 2
			var/obj/window/W = new /obj/window( usr.loc, 1 )
			W.dir = SOUTHWEST
			W.ini_dir = SOUTHWEST
			W.anchored = 0
			W.state = 0
		else
	if (src.amount <= 0)
		user.u_equip(src)
		//SN src = null
		del(src)
		return
	return


/obj/item/weapon/clipboard/attack_self(mob/user as mob)

	var/dat = "<B>Clipboard</B><BR>"
	if (src.pen)
		dat += text("<A href='?src=\ref[];pen=1'>Remove Pen</A><BR><HR>", src)
	for(var/obj/item/weapon/paper/P in src)
		dat += text("<A href='?src=\ref[];read=\ref[]'>[]</A> <A href='?src=\ref[];write=\ref[]'>Write</A> <A href='?src=\ref[];remove=\ref[]'>Remove</A><BR>", src, P, P.name, src, P, src, P)
		//Foreach goto(42)
	user << browse(dat, "window=clipboard")
	return

/obj/item/weapon/clipboard/Topic(href, href_list)
	..()
	if (!usr.can_use_hands())
		return
	if(!istype(usr, /mob/carbon))
		return
	var/mob/carbon/N = usr
	if (N.contents.Find(src))
		N.machine = src
		if (href_list["pen"])
			if (src.pen)
				if ((N.hand && !( N.l_hand )))
					N.l_hand = src.pen
					src.pen.loc = N
					src.pen.layer = 20
					src.pen = null
					N.update_clothing()
				else
					if (!( N.r_hand ))
						N.r_hand = src.pen
						src.pen.loc = N
						src.pen.layer = 20
						src.pen = null
						N.update_clothing()
				if (src.pen)
					src.pen.add_fingerprint(N)
				src.add_fingerprint(N)
		if (href_list["remove"])
			var/obj/item/P = locate(href_list["remove"])
			if ((P && P.loc == src))
				if ((N.hand && !( N.l_hand )))
					N.l_hand = P
					P.loc = N
					P.layer = 20
					N.update_clothing()
				else
					if (!( N.r_hand ))
						N.r_hand = P
						P.loc = N
						P.layer = 20
						N.update_clothing()
				P.add_fingerprint(N)
				src.add_fingerprint(N)
		if (href_list["write"])
			var/obj/item/P = locate(href_list["write"])
			if ((P && P.loc == src))
				if (istype(N.r_hand, /obj/item/weapon/pen))
					P.attackby(N.r_hand, N)
				else
					if (istype(N.l_hand, /obj/item/weapon/pen))
						P.attackby(N.l_hand, N)
					else
						if (istype(src.pen, /obj/item/weapon/pen))
							P.attackby(src.pen, N)
			src.add_fingerprint(N)
		if (href_list["read"])
			var/obj/item/weapon/paper/P = locate(href_list["read"])
			if ((P && P.loc == src))
				N << browse(text("<HTML><HEAD><TITLE>[]</TITLE></HEAD><BODY><TT>[]</TT></BODY></HTML>", P.name, P.info), text("window=[]", P.name))
		if (ismob(src.loc))
			var/mob/M = src.loc
			if (M.machine == src)
				spawn( 0 )
					src.attack_self(M)
					return
	return

/obj/item/weapon/clipboard/interact(mob/carbon/user as mob)
	if(!istype(user, /mob/carbon))
		return
	if ((locate(/obj/item/weapon/paper, src) && (!( user.equipped() ) && (user.l_hand == src || user.r_hand == src))))
		var/obj/item/weapon/paper/P
		for(P in src)
			break
			//Foreach goto(50)
		if (P)
			if (user.hand)
				user.l_hand = P
			else
				user.r_hand = P
			P.loc = user
			P.layer = 20
			P.add_fingerprint(user)
			user.update_clothing()
		src.add_fingerprint(user)
	else
		if (user.contents.Find(src))
			spawn( 0 )
				src.attack_self(user)
				return
		else
			return ..()
	return

/obj/item/weapon/clipboard/attackby(obj/item/weapon/P as obj, mob/carbon/user as mob)

	if (istype(P, /obj/item/weapon/paper))
		if (src.contents.len < 15)
			user.drop_item()
			P.loc = src
		else
			user << "\blue Not enough space!!!"
	else
		if (istype(P, /obj/item/weapon/pen))
			if (!( src.pen ))
				user.drop_item()
				P.loc = src
				src.pen = P
		else
			return ..()
	src.update()
	spawn( 0 )
		attack_self(user)
		return ..()
	return ..()

/obj/item/weapon/clipboard/proc/update()

	src.icon_state = text("clipboard[][]", (locate(/obj/item/weapon/paper, src) ? "1" : "0"), (locate(/obj/item/weapon/pen, src) ? "1" : "0"))
	return

/obj/item/weapon/fcardholder/attack_self(mob/user as mob)

	var/dat = "<B>Clipboard</B><BR>"
	for(var/obj/item/weapon/f_card/P in src)
		dat += text("<A href='?src=\ref[];read=\ref[]'>[]</A> <A href='?src=\ref[];remove=\ref[]'>Remove</A><BR>", src, P, P.name, src, P)
		//Foreach goto(23)
	user << browse(dat, "window=fcardholder")
	return

/obj/item/weapon/fcardholder/Topic(href, href_list)
	..()
	if (!usr.can_use_hands())
		return
	if(!istype(usr, /mob/carbon))
		return
	var/mob/carbon/user = usr
	if (user.contents.Find(src))
		usr.machine = src
		if (href_list["remove"])
			var/obj/item/P = locate(href_list["remove"])
			if ((P && P.loc == src))
				if ((user.hand && !( user.l_hand )))
					user.l_hand = P
					P.loc = usr
					P.layer = 20
					user.update_clothing()
				else
					if (!( user.r_hand ))
						user.r_hand = P
						P.loc = user
						P.layer = 20
						user.update_clothing()
				src.add_fingerprint(user)
				P.add_fingerprint(user)
			src.update()
		if (href_list["read"])
			var/obj/item/weapon/f_card/P = locate(href_list["read"])
			if ((P && P.loc == src))
				usr << browse(text("<HTML><HEAD><TITLE>[]</TITLE></HEAD><BODY><TT>[]</TT></BODY></HTML>", P.name, P.display()), text("window=[]", P.name))
			src.add_fingerprint(usr)
		if (ismob(src.loc))
			var/mob/M = src.loc
			if (M.machine == src)
				spawn( 0 )
					src.attack_self(M)
					return
	return

/obj/item/weapon/fcardholder/interact(mob/user as mob)

	if (user.contents.Find(src))
		spawn( 0 )
			src.attack_self(user)
			return
		src.add_fingerprint(user)
	else
		return ..()
	return

/obj/item/weapon/fcardholder/attackby(obj/item/weapon/P as obj, mob/carbon/user as mob)

	if (istype(P, /obj/item/weapon/f_card))
		if (src.contents.len < 30)
			user.drop_item()
			P.loc = src
			add_fingerprint(user)
			src.add_fingerprint(user)
		else
			user << "\blue Not enough space!!!"
	else
		if (istype(P, /obj/item/weapon/pen))
			var/t = input(user, "Holder Label:", text("[]", src.name), null)  as text
			if (user.equipped() != P)
				return
			if ((get_dist(src, usr) > 1 && src.loc != user))
				return
			t = html_encode(t)
			if (t)
				src.name = text("FPCase- '[]'", t)
			else
				src.name = "Finger Print Case"
		else
			return
	src.update()
	spawn( 0 )
		attack_self(user)
		return
	return

/obj/item/weapon/fcardholder/proc/update()

	var/i = 0
	for(var/obj/item/weapon/f_card/F in src)
		i = 1
		break
		//else
		//Foreach goto(22)
	src.icon_state = text("fcardholder[]", (i ? "1" : "0"))
	return

/obj/item/weapon/extinguisher/examine()
	set src in usr

	usr << text("\icon[] [] contains [] units of water left!", src, src.name, src.waterleft)
	..()
	return

/obj/item/weapon/extinguisher/afterattack(atom/target, mob/user , flag)

	if (src.icon_state == "fire_extinguisher1")
		if (src.waterleft < 1)
			return
		if (world.time < src.last_use + 20)
			return
		src.last_use = world.time
		if (istype(target, /area))
			return
		var/cur_loc = get_turf(user)
		var/tar_loc = (isturf(target) ? target : get_turf(target))


		if (get_dist(tar_loc, cur_loc) > 1)
			var/list/close = list(  )
			var/list/far = list(  )
			for(var/T in oview(2, tar_loc))
				if (get_dist(T, tar_loc) <= 1)
					close += T
				else
					far += T
				//Foreach goto(147)
			close += tar_loc
			var/t = null
			t = 1
			while(t <= 14)
				var/obj/effects/water/W = new /obj/effects/water( cur_loc )
				if (rand(1, 3) != 1)
					walk_towards(W, pick(close), null)
				else
					walk_towards(W, pick(far), null)
				sleep(1)
				t++
			src.waterleft--
			src.last_use = world.time
		else
			if (cur_loc == tar_loc)
				new /obj/effects/water( cur_loc )
				src.waterleft -= 0.25
				src.last_use = 1
			else
				var/list/possible = list(  )
				for(var/T in oview(1, tar_loc))
					possible += T
					//Foreach goto(366)
				possible += tar_loc
				var/t = null
				t = 1
				while(t <= 7)
					var/obj/effects/water/W = new /obj/effects/water( cur_loc )
					walk_towards(W, pick(possible), null)
					sleep(1)
					t++
				src.waterleft -= 0.5
				src.last_use = world.time

					// propulsion
		if(istype(cur_loc, /turf/space))
			user.Move(get_step(user, get_dir(target, user) ))
		//

	else
		return ..()
	return

/obj/item/weapon/extinguisher/attack_self(mob/user as mob)

	if (src.icon_state == "fire_extinguisher0")
		src.icon_state = "fire_extinguisher1"
		src.desc = "The safety is off."
	else
		src.icon_state = "fire_extinguisher0"
		src.desc = "The safety is on."
	return

/obj/item/weapon/pen/sleepypen/New()

	src.chem = new /obj/substance/chemical(  )
	src.chem.maximum = 5
	var/datum/chemical/s_tox/C = new /datum/chemical/s_tox( null )
	C.moles = C.density * 5 / C.molarmass
	src.chem.chemicals[text("[]", C.name)] = C
	..()
	return

/obj/item/weapon/pen/sleepypen/attack(mob/M as mob, mob/user as mob)

	if (!( istype(M, /mob) ))
		return
	if (src.desc == "It's a normal black ink pen.")
		return ..()
	if (user)
		M.show_viewers(text("\red [] has been stabbed with [] by [].", M, src, user))
		var/amount = src.chem.transfer_mob(M, src.chem.maximum)
		user.think(text("\red You inject [] units into the [].", amount, M))
		src.desc = "It's a normal black ink pen."
	return

/obj/item/weapon/paint/attack_self(mob/carbon/user as mob)
	if(!istype(user, /mob/carbon))
		return
	var/t1 = input(user, "Please select a color:", "Locking Computer", null) in list( "red", "blue", "green", "yellow", "black", "white", "neutral" )
	if (user.equipped() != src || !user.can_use_hands())
		return
	src.color = t1
	src.icon_state = text("paint_[]", t1)
	add_fingerprint(user)
	return

/obj/item/weapon/paper/burn(fi_amount)

	spawn( 0 )
		var/t = src.icon_state
		src.icon_state = ""
		src.icon = 'b_items.dmi'
		flick(text("[]", t), src)
		spawn( 14 )
			//SN src = null
			del(src)
			return
			return
		return
	return

/obj/item/weapon/paper/photograph/New()

	..()
	src.pixel_y = 0
	src.pixel_x = 0
	return

/obj/item/weapon/paper/photograph/attack_self(mob/user as mob)

	var/n_name = input(user, "What would you like to label the photo?", "Paper Labelling", null)  as text
	n_name = copytext(n_name, 1, 32)
	if ((src.loc == user && user.is_active()))
		src.name = text("photo[]", (n_name ? text("- '[]'", n_name) : null))
	src.add_fingerprint(user)
	return

/obj/item/weapon/paper/photograph/examine()
	set src in view()

	..()
	return

/obj/item/weapon/paper/New()

	..()
	src.pixel_y = rand(1, 16)
	src.pixel_x = rand(1, 16)
	return

/obj/item/weapon/paper/attack_self(mob/user as mob)

	var/n_name = input(user, "What would you like to label the paper?", "Paper Labelling", null)  as text
	n_name = copytext(n_name, 1, 32)
	if ((src.loc == user && user.is_active()))
		src.name = text("paper[]", (n_name ? text("- '[]'", n_name) : null))
	src.add_fingerprint(user)
	return

/obj/item/weapon/paper/attackby(obj/item/weapon/P as obj, mob/carbon/user as mob)
	if(!istype(user, /mob/carbon))
		return
	if (istype(P, /obj/item/weapon/pen) && user.check_intelligence())
		var/t = input(user, "What text do you wish to add?", text("[]", src.name), null)  as message
		if ((get_dist(src, usr) > 1 && src.loc != user && !( istype(src.loc, /obj/item/weapon/clipboard) ) && src.loc.loc != user && user.equipped() != P))
			return
		t = html_encode(t)
		t = dd_replacetext(t, "\n", "<BR>")
		t = dd_replacetext(t, "\[b\]", "<B>")
		t = dd_replacetext(t, "\[/b\]", "</B>")
		t = dd_replacetext(t, "\[i\]", "<I>")
		t = dd_replacetext(t, "\[/i\]", "</I>")
		t = dd_replacetext(t, "\[u\]", "<U>")
		t = dd_replacetext(t, "\[/u\]", "</U>")
		t = dd_replacetext(t, "\[sign\]", text("<font face=vivaldi>[]</font>", user.body_name))
		t = text("<font face=calligrapher>[]</font>", t)
		src.info += t
	else
		if (istype(P, /obj/item/weapon/weldingtool))
			var/obj/item/weapon/weldingtool/W = P
			if ((W.welding && W.weldfuel > 0))
				user.show_viewers(text("\red [] burns [] with the welding tool!", user, src))
				spawn( 0 )
					src.burn(1800000.0)
					return
		else
			if (istype(P, /obj/item/weapon/igniter))
				usr.show_viewers(text("\red [] burns [] with the igniter!", user, src))
				spawn( 0 )
					src.burn(1800000.0)
					return
			else
				if (istype(P, /obj/item/weapon/wirecutters))
					user.show_viewers(text("\red [] starts cutting []!", user, src))
					sleep(50)
					if (((src.loc == src || get_dist(src, user) <= 1) && (user.can_use_hands())))
						user.show_viewers(text("\red [] cuts [] to pieces!", user, src))
						del(src)
						return
	src.add_fingerprint(user)
	return

/obj/item/weapon/paper/examine()
	set src in view()

	..()
	usr << browse(text("<HTML><HEAD><TITLE>[]</TITLE></HEAD><BODY><TT>[]</TT></BODY></HTML>", src.name, src.info), text("window=[]", src.name))
	return

/obj/item/weapon/paper/interact(var/mob/silicon/ai/user)
	if(!istype(user, /mob/silicon/ai))
		return ..()
	if (get_dist(src, user.current) < 2)
		usr << browse(text("<HTML><HEAD><TITLE>[]</TITLE></HEAD><BODY><TT>[]</TT></BODY></HTML>", src.name, src.info), text("window=[]", src.name))

/obj/item/weapon/paper/Map/examine()
	set src in view()

	..()

	usr << browse_rsc(map_graphic)
	usr << browse(text("<HTML><HEAD><TITLE>[]</TITLE></HEAD><BODY><TT>[]</TT></BODY></HTML>", src.name, src.info), text("window=[]", src.name))
	return


/obj/item/weapon/f_card/examine()
	set src in view(2)

	..()
	usr << text("\blue There are [] on the stack!", src.amount)
	usr << browse(text("<HTML><HEAD><TITLE>[]</TITLE></HEAD><BODY><TT>[]</TT></BODY></HTML>", src.name, display()), text("window=[]", src.name))
	return

/obj/item/weapon/f_card/proc/display()

	if (src.fingerprints)
		var/dat = "<B>Fingerprints on Card</B><HR>"
		for(var/i in src.fingerprints)
			dat += text("[]<BR>", i)
		return dat
	else
		return "<B>There are no fingerprints on this card.</B>"
	return

/obj/item/weapon/f_card/interact(mob/carbon/user as mob)
	if(!istype(user, /mob/carbon))
		return
	if ((user.r_hand == src || user.l_hand == src))
		src.add_fingerprint(user)
		var/obj/item/weapon/f_card/F = new /obj/item/weapon/f_card( user )
		F.amount = 1
		src.amount--
		if (user.hand)
			user.l_hand = F
		else
			user.r_hand = F
		F.layer = 20
		F.add_fingerprint(user)
		if (src.amount < 1)
			//SN src = null
			del(src)
			return
	else
		..()
	return

/obj/item/weapon/f_card/attackby(obj/item/weapon/W as obj, mob/carbon/user as mob)

	if (istype(W, /obj/item/weapon/f_card))
		if ((src.fingerprints || W.fingerprints))
			return
		if (src.amount == 10)
			return
		if (W:amount + src.amount > 10)
			src.amount = 10
			W:amount = W:amount + src.amount - 10
		else
			src.amount += W:amount
			//W = null
			del(W)
		src.add_fingerprint(user)
		if (W)
			W.add_fingerprint(user)
	else
		if (istype(W, /obj/item/weapon/pen))
			var/t = input(user, "Card Label:", text("[]", src.name), null)  as text
			if (user.equipped() != W)
				return
			if ((get_dist(src, usr) > 1 && src.loc != user))
				return
			t = html_encode(t)
			if (t)
				src.name = text("FPrintC- '[]'", t)
			else
				src.name = "Finger Print Card"
			W.add_fingerprint(user)
			src.add_fingerprint(user)
	return

/obj/item/weapon/f_card/add_fingerprint()

	..()
	if (!istype(usr, /mob/silicon/ai))
		if (src.fingerprints)
			if (src.amount > 1)
				var/obj/item/weapon/f_card/F = new /obj/item/weapon/f_card( (ismob(src.loc) ? src.loc.loc : src.loc) )
				F.amount = --src.amount
				src.amount = 1
			src.icon_state = "f_print_card1"
	return

/obj/item/weapon/f_print_scanner/attackby(obj/item/weapon/f_card/W as obj, mob/user as mob)

	if (istype(W, /obj/item/weapon/f_card))
		if (W.fingerprints)
			return
		if (src.amount == 20)
			return
		if (W.amount + src.amount > 20)
			src.amount = 20
			W.amount = W.amount + src.amount - 20
		else
			src.amount += W.amount
			//W = null
			del(W)
		src.add_fingerprint(user)
		if (W)
			W.add_fingerprint(user)
	return

/obj/item/weapon/f_print_scanner/attack_self(mob/user as mob)

	src.printing = !( src.printing )
	src.icon_state = text("f_print_scanner[]", src.printing)
	add_fingerprint(user)
	return

/obj/item/weapon/f_print_scanner/attack(mob/carbon/M as mob, mob/user as mob)

	if (!istype(M, /mob/carbon) || !istype(M.dna, /datum/dna) ||  M.gloves)
		user << text("\blue Unable to locate any fingerprints on []!", M)
		return 0
	else
		if ((src.amount < 1 && src.printing))
			user << text("\blue Fingerprints scanned on []. Need more cards to print.", M)
			src.printing = 0
	src.icon_state = text("f_print_scanner[]", src.printing)
	if (src.printing)
		src.amount--
		var/obj/item/weapon/f_card/F = new /obj/item/weapon/f_card( user.loc )
		F.amount = 1
		F.fingerprints = M.fingerprint
		F.icon_state = "f_print_card1"
		F.name = text("FPrintC- '[]'", M.name)
		user << "\blue Done printing."
	user << text("\blue []'s Fingerprints: []", M, M.fingerprint)
	return

/obj/item/weapon/f_print_scanner/afterattack(atom/A as mob|obj|turf|area, mob/user as mob)

	src.add_fingerprint(user)
	if (!( A.fingerprints ))
		user << "\blue Unable to locate any fingerprints!"
		return 0
	else
		if ((src.amount < 1 && src.printing))
			user << "\blue Fingerprints found. Need more cards to print."
			src.printing = 0
	src.icon_state = text("f_print_scanner[]", src.printing)
	if (src.printing)
		src.amount--
		var/obj/item/weapon/f_card/F = new /obj/item/weapon/f_card( user.loc )
		F.amount = 1
		F.fingerprints = A.fingerprints
		F.icon_state = "f_print_card1"
		user << "\blue Done printing."
	user << text("\blue Isolated [] fingerprints.", A.fingerprints.len)
	for(var/i in A.fingerprints)
		user << text("\blue \t []", i)
		//Foreach goto(186)
	return

/obj/item/weapon/healthanalyzer/attack(mob/carbon/M as mob, mob/carbon/user as mob)
	if(!istype(M, /mob/carbon))
		return
	if (!user.check_dexterity())
		return
	M.show_viewers(text("\red [] has analyzed []'s vitals!", user, M))
	user.see(text("\blue Analyzing Results for []:\n\t Overall Status: []", M, (M.is_dead ? "dead" : text("[]% healthy", (M.death_threshold - M.get_damage())/M.death_threshold * 100))))
	user.see(text("\blue \t Damage Specifics:"))
	user.see("\blue Suffocation: [M.dam.suffocation]")
	user.see("\blue Toxin: [M.dam.toxin]")
	user.see("\blue Burn: [M.dam.burn]")
	user.see("\blue Brute: [M.dam.brute]")
	if (M.rejuv)
		user.see(text("\blue Bloodstream Analysis located [] units of rejuvenation chemicals.", M.rejuv))
	src.add_fingerprint(user)
	return
	return

/obj/item/weapon/analyzer/attack_self(mob/carbon/user as mob)

	if (!user.is_active())
		return
	if(!user.check_dexterity())
		return
	var/turf/T = user.loc
	if (!( istype(T, /turf) ))
		return
	if (locate(/obj/move, T))
		T = locate(/obj/move, T)
	var/turf_total = max(T.gas.total(), 1) / 100
	usr.see("\blue <B>Results:</B>")
	var/t = ""
	var/t1 = turf_total / CELLSTANDARD * 10000
	if(90 > t1 || t1 > 110)
		t += text("\blue Air Pressure: []%", t1)
	else
		t += text("\blue Air Pressure:\red []%", t1)

	t1 = round(T.gas.nitrogen / turf_total,0.0010)
	if(60 > t1 || t1 >  80)
		t += text("<font color=blue>Nitrogen: []</font> ", t1)
	else
		t += text("<font color=red>Nitrogen: []</font> ", t1)

	t1 = round(T.gas.oxygen / turf_total, 0.0010)
	if(20 > t1 || t1 > 24)
		t += text("<font color=blue>Oxygen: []</font> ", t1)
	else
		t += text("<font color=red>Oxygen: []</font> ", t1)

	t1 = round(T.gas.plasma / turf_total, 0.0010)
	if(t1 > 0.5)
		t += text("<font color=blue>Plasma: []</font> ", t1)
	else
		t += text("<font color=red>Plasma: []</font> ", t1)

	t1 = round(T.gas.co2 / turf_total, 0.0010)
	if(t1 > 1)
		t += text("<font color=blue>CO2: []</font> ", t1)
	else
		t += text("<font color=red>CO2: []</font> ", t1)

	t1 = round(T.gas.no2 / turf_total, 0.0010)
	if(t1 > 5)
		t += text("<font color=blue>NO2: []</font>", t1)
	else
		t += text("<font color=red>NO2: []</font>", t1)
	user.see(t)
	user.see(text("\blue \t Temperature: []&deg;C", (T.gas.temp-T0C) ))
	src.add_fingerprint(user)
	return

/obj/item/weapon/storage/proc/return_inv()

	var/list/L = list(  )

	L += src.contents

	for(var/obj/item/weapon/storage/S in src)
		L += S.return_inv()
	for(var/obj/item/weapon/gift/G in ticker.killer.contents)
		L += G.gift
		if (istype(G.gift, /obj/item/weapon/storage))
			L += G.gift:return_inv()
	return L

/obj/item/weapon/storage/proc/show_to(mob/carbon/user as mob)

	user.client.screen -= src.boxes
	user.client.screen -= src.closer
	user.client.screen -= src.contents
	user.client.screen += src.boxes
	user.client.screen += src.closer
	user.client.screen += src.contents
	user.s_active = src
	return

/obj/item/weapon/storage/proc/hide_from(mob/user as mob)

	if(!user.client)
		return
	user.client.screen -= src.boxes
	user.client.screen -= src.closer
	user.client.screen -= src.contents
	return

/obj/item/weapon/storage/proc/close(mob/carbon/user as mob)

	src.hide_from(user)
	user.s_active = null
	return

/obj/item/weapon/storage/proc/orient_objs(tx, ty, mx, my)

	var/cx = tx
	var/cy = ty
	src.boxes.screen_loc = text("[],[] to [],[]", tx, ty, mx, my)
	for(var/obj/O in src.contents)
		O.screen_loc = text("[],[]", cx, cy)
		O.layer = 20
		cx++
		if (cx > mx)
			cx = tx
			cy--
		//Foreach goto(56)
	src.closer.screen_loc = text("[],[]", mx, my)
	return

/obj/item/weapon/storage/proc/orient2hud(mob/carbon/user as mob)

	if (src == user.l_hand)
		src.orient_objs(3, 11, 3, 4)
	else
		if (src == user.r_hand)
			src.orient_objs(1, 11, 1, 4)
		else
			if (src == user.back)
				src.orient_objs(4, 10, 4, 3)
			else
				src.orient_objs(7, 8, 10, 7)
	return

/obj/item/weapon/storage/lglo_kit/New()

	new /obj/item/weapon/clothing/gloves/latex( src )
	new /obj/item/weapon/clothing/gloves/latex( src )
	new /obj/item/weapon/clothing/gloves/latex( src )
	new /obj/item/weapon/clothing/gloves/latex( src )
	new /obj/item/weapon/clothing/gloves/latex( src )
	new /obj/item/weapon/clothing/gloves/latex( src )
	new /obj/item/weapon/clothing/gloves/latex( src )
	..()
	return

/obj/item/weapon/storage/flashbang_kit/New()

	new /obj/item/weapon/flashbang( src )
	new /obj/item/weapon/flashbang( src )
	new /obj/item/weapon/flashbang( src )
	new /obj/item/weapon/flashbang( src )
	new /obj/item/weapon/flashbang( src )
	new /obj/item/weapon/flashbang( src )
	new /obj/item/weapon/flashbang( src )
	..()
	return

/obj/item/weapon/storage/stma_kit/New()

	new /obj/item/weapon/clothing/mask/surgical( src )
	new /obj/item/weapon/clothing/mask/surgical( src )
	new /obj/item/weapon/clothing/mask/surgical( src )
	new /obj/item/weapon/clothing/mask/surgical( src )
	new /obj/item/weapon/clothing/mask/surgical( src )
	new /obj/item/weapon/clothing/mask/surgical( src )
	new /obj/item/weapon/clothing/mask/surgical( src )
	..()
	return

/obj/item/weapon/storage/gl_kit/New()

	new /obj/item/weapon/clothing/glasses/regular( src )
	new /obj/item/weapon/clothing/glasses/regular( src )
	new /obj/item/weapon/clothing/glasses/regular( src )
	new /obj/item/weapon/clothing/glasses/regular( src )
	new /obj/item/weapon/clothing/glasses/regular( src )
	new /obj/item/weapon/clothing/glasses/regular( src )
	new /obj/item/weapon/clothing/glasses/regular( src )
	..()
	return

/obj/item/weapon/storage/trackimp_kit/New()

	new /obj/item/weapon/implantcase/tracking( src )
	new /obj/item/weapon/implantcase/tracking( src )
	new /obj/item/weapon/implantcase/tracking( src )
	new /obj/item/weapon/implantcase/tracking( src )
	new /obj/item/weapon/implanter( src )
	new /obj/item/weapon/implantpad( src )
	new /obj/item/weapon/locator( src )
	..()
	return

/obj/item/weapon/storage/fcard_kit/New()

	new /obj/item/weapon/f_card( src )
	new /obj/item/weapon/f_card( src )
	new /obj/item/weapon/f_card( src )
	new /obj/item/weapon/f_card( src )
	new /obj/item/weapon/f_card( src )
	new /obj/item/weapon/f_card( src )
	new /obj/item/weapon/f_card( src )
	..()
	return

/obj/item/weapon/storage/id_kit/New()

	new /obj/item/weapon/card/id( src )
	new /obj/item/weapon/card/id( src )
	new /obj/item/weapon/card/id( src )
	new /obj/item/weapon/card/id( src )
	new /obj/item/weapon/card/id( src )
	new /obj/item/weapon/card/id( src )
	new /obj/item/weapon/card/id( src )
	..()
	return

/obj/item/weapon/storage/handcuff_kit/New()

	new /obj/item/weapon/handcuffs( src )
	new /obj/item/weapon/handcuffs( src )
	new /obj/item/weapon/handcuffs( src )
	new /obj/item/weapon/handcuffs( src )
	new /obj/item/weapon/handcuffs( src )
	new /obj/item/weapon/handcuffs( src )
	new /obj/item/weapon/handcuffs( src )
	..()
	return

/obj/item/weapon/storage/disk_kit/disks/New()

	new /obj/item/weapon/card/data( src )
	new /obj/item/weapon/card/data( src )
	new /obj/item/weapon/card/data( src )
	new /obj/item/weapon/card/data( src )
	new /obj/item/weapon/card/data( src )
	new /obj/item/weapon/card/data( src )
	new /obj/item/weapon/card/data( src )
	..()
	return

/obj/item/weapon/storage/disk_kit/disks2/New()

	spawn( 2 )
		for(var/obj/item/weapon/card/data/D in src.loc)
			D.loc = src
			//Foreach goto(23)
		return
	..()
	return

/obj/item/weapon/storage/backpack/New()

	new /obj/item/weapon/storage/box( src )
	..()
	return

/obj/item/weapon/storage/backpack/MouseDrop(obj/over_object as obj)

	if (src.loc != usr)
		return
	if (usr.check_dexterity())
		var/mob/carbon/M = usr
		if(!istype(usr, /mob/carbon))
			return
		if (!( istype(over_object, /obj/screen) ))
			return ..()
		if ((M.can_use_hands() && M.back == src))
			if (over_object.name == "r_hand")
				if (!( M.r_hand ))
					M.u_equip(src)
					M.r_hand = src
			else
				if (over_object.name == "l_hand")
					if (!( M.l_hand ))
						M.u_equip(src)
						M.l_hand = src
			M.update_clothing()
			src.add_fingerprint(usr)
	return

/obj/item/weapon/storage/backpack/attackby(obj/item/weapon/W as obj, mob/carbon/user as mob)

	if (src.contents.len >= 7)
		return
	if (W.w_class > 3)
		return
	var/t
	for(var/obj/item/weapon/O in src)
		t += O.w_class
		//Foreach goto(46)
	t += W.w_class
	if (t > 20)
		user << "You cannot fit the item inside. (Remove larger classed items)"
		return
	user.u_equip(W)
	W.loc = src
	if ((user.client && user.s_active != src))
		user.client.screen -= W
	src.orient2hud(user)
	W.dropped()
	add_fingerprint(user)
	user.show_viewers(text("\blue [] has added [] to []!", user, W, src))
	return

/obj/item/weapon/storage/attackby(obj/item/weapon/W as obj, mob/carbon/user as mob)

	if (src.contents.len >= 7)
		return
	if ((W.w_class >= 3 || istype(W, /obj/item/weapon/storage)))
		return
	user.u_equip(W)
	W.loc = src
	if ((user.client && user.s_active != src))
		user.client.screen -= W
	src.orient2hud(user)
	W.dropped()
	add_fingerprint(user)
	user.show_viewers(text("\blue [] has added [] to []!", user, W, src))
	return

/obj/item/weapon/storage/dropped(mob/user as mob)

	src.orient_objs(7, 8, 10, 7)
	return

/obj/item/weapon/storage/MouseDrop(over_object, src_location, over_location)

	..()
	if(!istype(usr, /mob/carbon))
		return
	var/mob/carbon/user = usr
	if ((over_object == user && (get_dist(src, user) <= 1 || user.contents.Find(src))))
		if (user.s_active)
			user.s_active.close(user)
		src.show_to(user)
	return

/obj/item/weapon/storage/interact(mob/carbon/user as mob)
	if(!istype(user, /mob/carbon))
		return
	if (src.loc == user)
		if (user.s_active)
			user.s_active.close(user)
		src.show_to(user)
	else
		..()
		for(var/mob/carbon/M in range(1))
			if (M.s_active == src)
				src.close(M)
			//Foreach goto(76)
		src.orient2hud(user)
	src.add_fingerprint(user)
	return

/obj/item/weapon/storage/New()

	src.boxes = new /obj/screen/storage(  )
	src.boxes.name = "storage"
	src.boxes.master = src
	src.boxes.icon_state = "block"
	src.boxes.screen_loc = "7,7 to 10,8"
	src.boxes.layer = 19
	src.closer = new /obj/screen/close(  )
	src.closer.master = src
	src.closer.icon_state = "x"
	src.closer.layer = 20
	spawn( 5 )
		src.orient_objs(7, 8, 10, 7)
		return
	return

/obj/item/weapon/storage/toolbox/New()

	new /obj/item/weapon/screwdriver( src )
	new /obj/item/weapon/wrench( src )
	new /obj/item/weapon/weldingtool( src )
	new /obj/item/weapon/radio( src )
	new /obj/item/weapon/analyzer( src )
	new /obj/item/weapon/extinguisher( src )
	new /obj/item/weapon/wirecutters( src )
	..()
	return

/obj/item/weapon/storage/toolbox/electrical/New()
	..()
	src.contents = null
	new /obj/item/weapon/screwdriver( src )
	new /obj/item/weapon/wirecutters( src )
	new /obj/item/weapon/t_scanner( src )
	new /obj/item/weapon/crowbar( src )
	new /obj/item/weapon/cable_coil( src )
	new /obj/item/weapon/cable_coil( src )
	new /obj/item/weapon/cable_coil( src )

	return

/obj/item/weapon/storage/toolbox/attack(mob/carbon/M as mob, mob/carbon/user as mob)

	..()
	if ((prob(30) && !M.is_dead))
		var/mob/carbon/H = M

		// ******* Check

		if ((istype(H, /mob/carbon) && istype(H, /obj/item/weapon/clothing/head) && H.flags & 8 && prob(80)))
			M << "\red The helmet protects you from being hit hard in the head!"
			return
		var/time = rand(1, 5)
		if (prob(90))
			M.knockout_until(time)
		else
			M.knockdown_until(time)
		user.show_viewers(text("\red <B>[] has been knocked unconscious!</B>", M))
	return

/obj/item/weapon/storage/firstaid/fire/New()

	..()
	new /obj/item/weapon/ointment( src )
	new /obj/item/weapon/ointment( src )
	new /obj/item/weapon/ointment( src )
	new /obj/item/weapon/ointment( src )
	new /obj/item/weapon/healthanalyzer( src )
	var/obj/item/weapon/syringe/S = new /obj/item/weapon/syringe( src )
	var/datum/chemical/rejuv/C = new /datum/chemical/rejuv( null )
	C.moles = C.density * 15 / C.molarmass
	S.chem.chemicals[text("[]", C.name)] = C
	S.icon_state = "syringe_15"
	return

/obj/item/weapon/storage/firstaid/syringes/New()

	..()
	new /obj/item/weapon/syringe( src )
	new /obj/item/weapon/syringe( src )
	new /obj/item/weapon/syringe( src )
	new /obj/item/weapon/syringe( src )
	new /obj/item/weapon/syringe( src )
	new /obj/item/weapon/syringe( src )
	new /obj/item/weapon/syringe( src )
	return

/obj/item/weapon/storage/firstaid/regular/New()

	..()
	new /obj/item/weapon/brutepack( src )
	new /obj/item/weapon/brutepack( src )
	new /obj/item/weapon/brutepack( src )
	new /obj/item/weapon/ointment( src )
	new /obj/item/weapon/ointment( src )
	new /obj/item/weapon/healthanalyzer( src )
	var/obj/item/weapon/syringe/S = new /obj/item/weapon/syringe( src )
	var/datum/chemical/rejuv/C = new /datum/chemical/rejuv( null )
	C.moles = C.density * 15 / C.molarmass
	S.chem.chemicals[text("[]", C.name)] = C
	S.icon_state = "syringe_15"
	return

/obj/item/weapon/storage/firstaid/toxin/New()

	..()
	new /obj/item/weapon/pill_canister/antitoxin( src )
	new /obj/item/weapon/pill_canister/antitoxin( src )
	var/t = null
	t = 1
	while(t <= 4)
		var/obj/item/weapon/syringe/S = new /obj/item/weapon/syringe( src )
		var/datum/chemical/pl_coag/C = new /datum/chemical/pl_coag( null )
		C.moles = C.density * 15 / C.molarmass
		S.chem.chemicals[text("[]", C.name)] = C
		S.icon_state = "syringe_15"
		t++
	new /obj/item/weapon/healthanalyzer( src )
	return

/obj/item/weapon/storage/firstaid/attackby(obj/item/weapon/W as obj, mob/user as mob)

	if (src.contents.len >= 7)
		return
	if ((W.w_class >= 2 || istype(W, /obj/item/weapon/storage)))
		return
	..()
	return

/obj/item/weapon/tile/New()

	src.pixel_x = rand(1, 14)
	src.pixel_y = rand(1, 14)
	return

/obj/item/weapon/tile/interact(mob/carbon/user as mob)
	if(!istype(user, /mob/carbon))
		return
	if ((user.r_hand == src || user.l_hand == src))
		src.add_fingerprint(user)
		var/obj/item/weapon/tile/F = new /obj/item/weapon/tile( user )
		F.amount = 1
		src.amount--
		if (user.hand)
			user.l_hand = F
		else
			user.r_hand = F
		F.layer = 20
		F.add_fingerprint(user)
		if (src.amount < 1)
			//SN src = null
			del(src)
			return
	else
		..()
	return

/obj/item/weapon/tile/proc/build(turf/S as turf)
	var/turf/station/floor/W = S.ReplaceWithFloor()

	W.burnt = 1
	W.intact = 0
	W.gas.oxygen = 0
	W.gas.nitrogen = 0
	W.levelupdate()
	W.icon_state = "Floor1"
	W.health = 100
	return

/obj/item/weapon/tile/attack_self(mob/carbon/user as mob)
	if(!istype(user, /mob/carbon))
		return
	if (!user.can_use_hands())
		return
	var/T = user.loc
	if (!( istype(T, /turf) ))
		user << "\blue You must be on the ground!"
		return
	else
		var/S = T
		if (!( istype(S, /turf/space) ))
			user << "You cannot build on or repair this turf!"
			return
		else
			src.build(S)
			src.amount--
	if (src.amount < 1)
		user.u_equip(src)
		//SN src = null
		del(src)
		return
	src.add_fingerprint(user)
	return

/obj/item/weapon/tile/attackby(obj/item/weapon/tile/W as obj, mob/user as mob)

	if (!( istype(W, /obj/item/weapon/tile) ))
		return
	if (W.amount == 10)
		return
	W.add_fingerprint(user)
	if (W.amount + src.amount > 10)
		src.amount = W.amount + src.amount - 10
		W.amount = 10
	else
		W.amount += src.amount
		//SN src = null
		del(src)
		return
	return

/obj/item/weapon/tile/examine()
	set src in view(1)

	..()
	usr << text("There are [] tile\s left on the stack.", src.amount)
	return

/obj/item/weapon/igniter/attackby(obj/item/weapon/W as obj, mob/carbon/user as mob)

	if ((istype(W, /obj/item/weapon/radio/signaler) && !( src.status )))
		var/obj/item/weapon/radio/signaler/S = W
		if (!( S.b_stat ))
			return
		var/obj/item/weapon/assembly/rad_ignite/R = new /obj/item/weapon/assembly/rad_ignite( user )
		S.loc = R
		R.part1 = S
		S.layer = initial(S.layer)
		if (user.client)
			user.client.screen -= S
		if (user.r_hand == S)
			user.u_equip(S)
			user.r_hand = R
		else
			user.u_equip(S)
			user.l_hand = R
		S.master = R
		src.master = R
		src.layer = initial(src.layer)
		user.u_equip(src)
		if (user.client)
			user.client.screen -= src
		src.loc = R
		R.part2 = src
		R.layer = 20
		R.loc = user
		src.add_fingerprint(user)

	else if ((istype(W, /obj/item/weapon/prox_sensor) && !( src.status )))

		var/obj/item/weapon/assembly/prox_ignite/R = new /obj/item/weapon/assembly/prox_ignite( user )
		W.loc = R
		R.part1 = W
		W.layer = initial(W.layer)
		if (user.client)
			user.client.screen -= W
		if (user.r_hand == W)
			user.u_equip(W)
			user.r_hand = R
		else
			user.u_equip(W)
			user.l_hand = R
		W.master = R
		src.master = R
		src.layer = initial(src.layer)
		user.u_equip(src)
		if (user.client)
			user.client.screen -= src
		src.loc = R
		R.part2 = src
		R.layer = 20
		R.loc = user
		src.add_fingerprint(user)

	else if ((istype(W, /obj/item/weapon/timer) && !( src.status )))

		var/obj/item/weapon/assembly/time_ignite/R = new /obj/item/weapon/assembly/time_ignite( user )
		W.loc = R
		R.part1 = W
		W.layer = initial(W.layer)
		if (user.client)
			user.client.screen -= W
		if (user.r_hand == W)
			user.u_equip(W)
			user.r_hand = R
		else
			user.u_equip(W)
			user.l_hand = R
		W.master = R
		src.master = R
		src.layer = initial(src.layer)
		user.u_equip(src)
		if (user.client)
			user.client.screen -= src
		src.loc = R
		R.part2 = src
		R.layer = 20
		R.loc = user
		src.add_fingerprint(user)


	if (!( istype(W, /obj/item/weapon/screwdriver) ))
		return
	src.status = !( src.status )
	if (src.status)
		user.see("\blue The igniter is ready!")
	else
		user.see("\blue The igniter can now be attached!")
	src.add_fingerprint(user)
	return

/obj/item/weapon/igniter/attack_self(mob/user as mob)

	src.add_fingerprint(user)
	spawn( 5 )
		ignite()
		return
	return

/obj/item/weapon/igniter/proc/ignite()

	if (src.status)
		var/turf/T = src.loc
		if (src.master)
			T = src.master.loc
		if (!( istype(T, /turf) ))
			T = T.loc
		if (!( istype(T, /turf) ))
			T = T.loc
		if (locate(/obj/move, T))
			T = locate(/obj/move, T)
		else
			if (!( istype(T, /turf) ))
				return
		if (T.firelevel < 900000.0)
			T.firelevel = T.gas.plasma
	return

/obj/item/weapon/igniter/examine()
	set src in view()

	..()
	if ((get_dist(src, usr) <= 1 || src.loc == usr))
		if (src.status)
			usr.see("The igniter is ready!")
		else
			usr.see("The igniter can be attached!")
	return

/obj/item/weapon/shard/Bump()

	spawn( 0 )
		if (prob(20))
			src.force = 15
		else
			src.force = 4
		..()
		return
	return

/obj/item/weapon/shard/New()

	//****RM
	//world<<"New shard at [x],[y],[z]"

	src.icon_state = pick("large", "medium", "small")
	switch(src.icon_state)
		if("small")
			src.pixel_x = rand(1, 18)
			src.pixel_y = rand(1, 18)
		if("medium")
			src.pixel_x = rand(1, 16)
			src.pixel_y = rand(1, 16)
		if("large")
			src.pixel_x = rand(1, 10)
			src.pixel_y = rand(1, 5)
		else
	return

/obj/item/weapon/shard/attackby(obj/item/weapon/W as obj, mob/user as mob)

	..()
	if (!( istype(W, /obj/item/weapon/weldingtool) ))
		return
	new /obj/item/weapon/sheet/glass( user.loc )
	//SN src = null
	del(src)
	return
	return

/obj/item/weapon/Bump(mob/M as mob)

	spawn( 0 )
		..()
		if (src.throwing)
			src.throwing = 0
			src.density = 0
			if (istype(M, /obj))
				var/obj/O = M
				M.show_viewers(text("\red [] has been hit by [].", M, src))
					//Foreach goto(71)
				O.hitby(src)
			if (!( istype(M, /mob) ))
				return
			M.show_viewers("\red [M] has been hit by [src].")
			M.take_damage(brute = src.throwforce)
		return
	return

/obj/item/weapon/wrench/New()

	if (prob(75))
		src.pixel_x = rand(0, 16)
	return

/obj/item/weapon/screwdriver/New()

	if (prob(75))
		src.pixel_y = rand(0, 16)
	return

/obj/item/weapon/dropper/interact()

	..()
	src.update_is()
	return

/obj/item/weapon/dropper/proc/update_is()

	var/t1 = round(src.chem.volume())
	if (istype(src.loc, /mob))
		if (src.mode == "inject")
			src.icon_state = text("dropper_[]_I", t1)
		else
			src.icon_state = text("dropper_[]_d", t1)
	else
		src.icon_state = text("dropper_[]", t1)
	src.s_istate = "dropper"
	return

/obj/item/weapon/dropper/dropped()

	..()
	src.update_is()
	return

/obj/item/weapon/dropper/attack_self()

	if (src.mode == "inject")
		src.mode = "draw"
	else
		src.mode = "inject"
	src.update_is()
	return

/obj/item/weapon/dropper/New()

	src.chem = new /obj/substance/chemical(  )
	src.chem.maximum = 5
	..()
	return

/obj/item/weapon/dropper/attack(mob/carbon/M as mob, mob/user as mob)
	if(!user.check_dexterity())
		return
	if ((M.helmet && M.helmet.flags & HEADCOVERSEYES) || (M.mask && M.mask.flags & MASKCOVERSEYES) || (M.glasses && M.glasses.flags & GLASSESCOVERSEYES))
		user.think("\blue You're going to need to remove [(user == M) ? "your" : "their"] glasses/mask/helmet first.")
		return
	if (user)
		M.show_viewers(text("\red [] has been eyedropped with [] by [].", M, src, user))
		var/amount = src.chem.dropper_mob(M, 1)
		src.update_is()
		user.see("\red You drop [amount] units into [M]'s eyes. The dropper contains [src.chem.volume()] units.")
		src.add_fingerprint(user)
	return

/obj/item/weapon/implantcase/proc/update()

	if (src.imp)
		src.icon_state = text("implantcase-[]", src.imp.color)
	else
		src.icon_state = "implantcase-0"
	return

/obj/item/weapon/implantcase/attackby(obj/item/weapon/I as obj, mob/carbon/user as mob)

	if (istype(I, /obj/item/weapon/pen))
		var/t = input(user, "What would you like the label to be?", text("[]", src.name), null)  as text
		if (user.equipped() != I)
			return
		if ((get_dist(src, usr) > 1 && src.loc != user))
			return
		t = html_encode(t)
		if (t)
			src.name = text("Glass Case- '[]'", t)
		else
			src.name = "Glass Case"
	else
		if (!( istype(I, /obj/item/weapon/implanter) ))
			return
	if (I:imp)
		if ((src.imp || I:imp.implanted))
			return
		I:imp.loc = src
		src.imp = I:imp
		I:imp = null
		src.update()
		I:update()
	else
		if (src.imp)
			if (I:imp)
				return
			src.imp.loc = I
			I:imp = src.imp
			src.imp = null
			update()
			I:update()
	return

/obj/item/weapon/implantcase/tracking/New()

	src.imp = new /obj/item/weapon/implant/tracking( src )
	..()
	return

/obj/item/weapon/implant/proc/trigger(emote, source as mob)

	return

/obj/item/weapon/implant/freedom/New()

	src.uses = rand(1, 5)
	..()
	return

/obj/item/weapon/implant/freedom/trigger(mob/carbon/source as mob)

	if (src.uses < 1)
		return 0
	if (source.handcuffs)
		src.uses--
		var/obj/item/weapon/W = source.handcuffs
		source.handcuffs = null
		if (source.client)
			source.client.screen -= W
		if (W)
			W.loc = source.loc
			dropped(source)
			if (W)
				W.layer = initial(W.layer)
	return

/obj/item/weapon/implanter/proc/update()

	if (src.imp)
		src.icon_state = "implanter1"
	else
		src.icon_state = "implanter0"
	return

/obj/item/weapon/implanter/attack(mob/M as mob, mob/user as mob)

	if (!( istype(M, /mob) ))
		return
	if ((user && src.imp))
		M.show_viewers(text("\red [] has been implanted by [].", M, user))
			//Foreach goto(48)
		src.imp.loc = M
		src.imp.implanted = 1
		src.imp = null
		user.see(text("\red You implanted the implant into the [].", M))
		src.icon_state = "implanter0"
	return

/obj/item/weapon/syringe/interact()

	..()
	src.update_is()
	return

/obj/item/weapon/syringe/proc/update_is()

	var/t1 = round(src.chem.volume(), 5)
	if (istype(src.loc, /mob))
		if (src.mode == "inject")
			src.icon_state = text("syringe_[]_I", t1)
		else
			src.icon_state = text("syringe_[]_d", t1)
	else
		src.icon_state = text("syringe_[]", t1)
	src.s_istate = text("syringe_[]", t1)
	return

/obj/item/weapon/syringe/proc/inject(mob/M as mob)

	var/amount = 5
	var/volume = src.chem.volume()
	if (volume < 0.1)
		return
	else
		if (volume < 5.01)
			amount = volume - 0.01
	src.chem.transfer_mob(M, amount)
	src.update_is()
	return amount

/obj/item/weapon/syringe/dropped()

	..()
	src.update_is()
	return

/obj/item/weapon/syringe/attack_self()

	if (src.mode == "inject")
		src.mode = "draw"
	else
		src.mode = "inject"
	src.update_is()
	return

/obj/item/weapon/syringe/New()

	src.chem = new /obj/substance/chemical(  )
	src.chem.maximum = 15
	..()
	return

/obj/item/weapon/syringe/attack(mob/carbon/M as mob, mob/carbon/user as mob)
	if (!user.check_dexterity())
		return
	if (user)
		if (istype(M, /mob/carbon))
			var/obj/equip_e/O = new /obj/equip_e(  )
			O.source = user
			O.target = M
			O.item = src
			O.s_loc = user.loc
			O.t_loc = M.loc
			O.place = "syringe"
			M.requests += O
			spawn( 0 )
				O.process()
				return
		else
			for(var/mob/O in viewers(M, null))
				O.see(text("\red [] has been injected with [] by [].", M, src, user))
				//Foreach goto(192)
			var/amount = src.chem.transfer_mob(M, 5)
			src.update_is()
			user.see(text("\red You inject [] units into the []. The syringe contains [] units.", amount, M, round(src.chem.volume(), 0.1)))
	return

/obj/item/weapon/brutepack/interact(mob/user as mob)
	if(istype(user, /mob/carbon))
		var/mob/carbon/M = user
		if (M.r_hand == src || M.l_hand == src)
			src.add_fingerprint(M)
			var/obj/item/weapon/brutepack/F = new /obj/item/weapon/brutepack(M)
			F.amount = 1
			src.amount--
			if (M.hand)
				M.l_hand = F
			else
				M.r_hand = F
			F.layer = 20
			F.add_fingerprint(M)
			if (src.amount < 1)
				del(src)
	return ..()

/obj/item/weapon/brutepack/attack(mob/carbon/M as mob, mob/carbon/user as mob)

	if (M.is_dead)
		return
	if(!user.check_dexterity())
		return
	M.show_viewers("\red [user] has applied the [src] to [M]")
	M.heal_damage(brute = 60)
	src.amount--
	return

/obj/item/weapon/brutepack/examine()
	set src in view(1)

	..()
	usr << text("\blue there are [] bruise pack\s left on the stack!", src.amount)
	if (src.amount <= 0)
		//SN src = null
		del(src)
		return
	return

/obj/item/weapon/brutepack/attackby(obj/item/weapon/brutepack/W as obj, mob/user as mob)

	if (!( istype(W, /obj/item/weapon/brutepack) ))
		return
	if (src.amount == 5)
		return
	if (W.amount + src.amount > 5)
		src.amount = 5
		W.amount = W.amount + src.amount - 5
	else
		src.amount += W.amount
		//W = null
		del(W)
	return

/obj/item/weapon/hand_tele/attack_self(mob/carbon/user as mob)

	var/list/L = list(  )
	for(var/obj/machinery/teleport/hub/R in world)
		var/obj/machinery/computer/teleporter/com = locate(/obj/machinery/computer/teleporter, locate(R.x - 2, R.y, R.z))
		if (istype(com, /obj/machinery/computer/teleporter))
			if(R.icon_state == "tele1")
				L["[com.id] (Active)"] = com.locked
			else
				L["[com.id] (Inactive)"] = com.locked
	var/t1 = input(user, "Please select a teleporter to lock in on.", "Hand Teleporter") in L
	if (user.equipped() != src || !user.can_use_hands())
		return
	var/T = L[t1]
	for(var/mob/O in hearers(user))
		O.hear("\blue Locked In")
	var/obj/portal/P = new /obj/portal( get_turf(src) )
	P.target = T
	src.add_fingerprint(user)
	return

/obj/item/weapon/ointment/interact(mob/carbon/user as mob)
	if(!istype(user, /mob/carbon))
		return
	if ((user.r_hand == src || user.l_hand == src))
		src.add_fingerprint(user)
		var/obj/item/weapon/ointment/F = new /obj/item/weapon/ointment( user )
		F.amount = 1
		src.amount--
		if (user.hand)
			user.l_hand = F
		else
			user.r_hand = F
		F.layer = 20
		F.add_fingerprint(user)
		if (src.amount < 1)
			//SN src = null
			del(src)
			return
	else
		..()
	return

/obj/item/weapon/ointment/attack(mob/M as mob, mob/user as mob)
	if (!user.check_dexterity())
		return
	if (istype(M, /mob/carbon))
		if (user)
			M.show_viewers(text("\red [] has been applied with [] by []", M, src, user))
		M.heal_damage(burn = 40)
		src.amount--
		if (src.amount <= 0)
			del(src)


/obj/item/weapon/ointment/examine()
	set src in view(1)

	usr << text("\blue there are [] ointment pack\s left on the stack!", src.amount)
	return

/obj/item/weapon/ointment/attackby(obj/item/weapon/ointment/W as obj, mob/user as mob)

	if (!( istype(W, /obj/item/weapon/ointment) ))
		return
	if (W.amount == 5)
		return
	if (W.amount + src.amount > 5)
		src.amount = W.amount + src.amount - 5
		W.amount = 5
	else
		W.amount += W.amount
		//SN src = null
		del(src)
		return
	return

/obj/item/weapon/bottle/examine()
	set src in usr

	usr << text("\blue The bottle \icon[] contains [] millimeters of chemicals", src, round(src.chem.volume(), 0.1))
	return

/obj/item/weapon/bottle/New()

	src.chem = new /obj/substance/chemical(  )
	..()
	return

/obj/item/weapon/bottle/attackby(obj/item/weapon/B as obj, mob/user as mob)

	if (istype(B, /obj/item/weapon/bottle))
		var/t1 = src.chem.maximum
		var/volume = src.chem.volume()
		if (volume < 0.1)
			return
		else
			t1 = volume - 0.1
		t1 = src.chem.transfer_from(B:chem, t1)
		if (t1)
			user.see(text("\blue You pour [] unit\s into the bottle. The bottle now contains [] millimeters.", round(t1, 0.1), round(src.chem.volume(), 0.1)))
	if (istype(B, /obj/item/weapon/syringe))
		if (B:mode == "inject")
			var/t1 = 5
			var/volume = src.chem.volume()
			if (volume < 0.01)
				return
			else
				if (volume < 5.01)
					t1 = volume - 0.01
			t1 = src.chem.transfer_from(B:chem, t1)
			B:update_is()
			if (t1)
				user.see(text("\blue You inject [] unit\s into the bottle. The syringe contains [] units.", round(t1, 0.1), round(B:chem.volume(), 0.1)))
		else
			var/t1 = 5
			var/volume = src.chem.volume()
			if (volume < 0.05)
				return
			else
				if (volume < 5.05)
					t1 = volume - 0.05
			t1 = B:chem.transfer_from(src.chem, t1)
			B:update_is()
			if (t1)
				user.see(text("\blue You draw [] unit\s from the bottle. The syringe contains [] units.", round(t1, 0.1), round(B:chem.volume(), 0.1)))
		src.add_fingerprint(user)
	else
		if (istype(B, /obj/item/weapon/dropper))
			if (B:mode == "inject")
				var/t1 = 1
				var/volume = src.chem.volume()
				if (volume < 0.0050)
					return
				else
					if (volume < 1.005)
						t1 = volume - 0.0050
				t1 = src.chem.transfer_from(B:chem, t1)
				B:update_is()
				if (t1)
					user.see(text("\blue You deposit [] unit\s into the bottle. The dropper contains [] units.", round(t1, 0.1), round(B:chem.volume(), 0.1)))
			else
				var/t1 = 1
				var/volume = src.chem.volume()
				if (volume < 0.0050)
					return
				else
					if (volume < 1.005)
						t1 = volume - 0.0050
				t1 = B:chem.transfer_from(src.chem, t1)
				B:update_is()
				if (t1)
					user.see(text("\blue You extract [] unit\s from the bottle. The dropper contains [] units.", round(t1, 0.1), round(B:chem.volume(), 0.1)))
	return

/obj/item/weapon/bottle/toxins/New()

	..()
	src.chem.maximum = 60
	var/datum/chemical/l_plas/C = new /datum/chemical/l_plas( null )
	C.moles = C.density * 50 / C.molarmass
	src.chem.chemicals[text("[]", C.name)] = C
	return

/obj/item/weapon/bottle/antitoxins/New()

	..()
	src.chem.maximum = 60
	var/datum/chemical/pl_coag/C = new /datum/chemical/pl_coag( null )
	C.moles = C.density * 50 / C.molarmass
	src.chem.chemicals[text("[]", C.name)] = C
	return

/obj/item/weapon/bottle/r_epil/New()

	..()
	src.chem.maximum = 60
	var/datum/chemical/epil/C = new /datum/chemical/epil( null )
	C.moles = C.density * 50 / C.molarmass
	src.chem.chemicals[text("[]", C.name)] = C
	return

/obj/item/weapon/bottle/r_ch_cough/New()

	..()
	src.chem.maximum = 60
	var/datum/chemical/ch_cou/C = new /datum/chemical/ch_cou( null )
	C.moles = C.density * 50 / C.molarmass
	src.chem.chemicals[text("[]", C.name)] = C
	return

/obj/item/weapon/bottle/rejuvenators/New()

	..()
	src.chem.maximum = 60
	var/datum/chemical/rejuv/C = new /datum/chemical/rejuv( null )
	C.moles = C.density * 50 / C.molarmass
	src.chem.chemicals[text("[]", C.name)] = C
	return

/obj/item/weapon/bottle/s_tox/New()

	..()
	src.chem.maximum = 60
	var/datum/chemical/s_tox/C = new /datum/chemical/s_tox( null )
	C.moles = C.density * 50 / C.molarmass
	src.chem.chemicals[text("[]", C.name)] = C
	return

/obj/item/weapon/bottle/New()

	..()
	src.pixel_y = rand(-8.0, 8)
	src.pixel_x = rand(-8.0, 8)
	return

/obj/item/weapon/weldingtool/examine()
	set src in usr

	usr << text("\icon[] [] contains [] units of fuel left!", src, src.name, src.weldfuel)
	return

/obj/item/weapon/weldingtool/afterattack(O as obj, mob/user as mob)

	if (src.welding)
		src.weldfuel--
		if (src.weldfuel <= 0)
			usr << "\blue Need more fuel!"
			src.welding = 0
			src.force = 3
			src.damtype = "brute"
			src.icon_state = "welder"
		var/turf/location = user.loc
		if (!( istype(location, /turf) ))
			return
		location.firelevel = location.gas.plasma + 1
	return

/obj/item/weapon/weldingtool/attack_self(mob/user as mob)

	src.welding = !( src.welding )
	if (src.welding)
		if (src.weldfuel <= 0)
			user << "\blue Need more fuel!"
			src.welding = 0
			return 0
		user << "\blue You will now weld when you attack."
		src.force = 15
		src.damtype = "fire"
		src.icon_state = "welder1"
		spawn() //start fires while it's lit
			src.process()
	else
		user << "\blue Not welding anymore."
		src.force = 3
		src.damtype = "brute"
		src.icon_state = "welder"
	return

/obj/item/weapon/weldingtool/var/processing = 0

/obj/item/weapon/weldingtool/proc/process()
	if(src.processing) //already doing this
		return
	src.processing = 1

	while(src.welding)
		var/turf/location = src.loc
		if(istype(location, /mob/carbon))
			var/mob/carbon/M = location
			if(M.l_hand == src || M.r_hand == src)
				location = M.loc

		if(isturf(location)) //start a fire if possible
			location.firelevel = max(location.firelevel, location.gas.plasma + 1)

		sleep(10)
	processing = 0	//we're done

/obj/item/weapon/card/id/attackby(obj/item/weapon/W as obj, mob/user)
	. = null
	if (W.loc == user && src.loc == user && istype(src, /obj/item/weapon/card/id) && istype(W, /obj/item/weapon/card/id) && istype(user, /mob/carbon))
		var/mob/carbon/MC = user
		. = MC.db_click("id", null)
		if (.)
			return
	return ..()


/obj/manifest/New()

	src.invisibility = 100
	return

/obj/manifest/proc/manifest()

	var/dat = "<B>Crew Manifest</B>:<BR>"
	for(var/mob/carbon/M in world)
		dat += text("    <B>[]</B> -  []<BR>", M.spawn_name, (istype(M.id, /obj/item/weapon/card/id) ? text("[]", M.id.assignment) : "Unknown Position"))
	var/obj/item/weapon/paper/P = new /obj/item/weapon/paper( src.loc )
	P.info = dat
	P.name = "paper- 'Crew Manifest'"
	//SN src = null
	del(src)
	return
	return

/obj/screen/close/DblClick()

	if (src.master)
		src.master:close(usr)
	return

/obj/screen/storage/attackby(W, mob/user as mob)

	src.master.attackby(W, user)
	return

/obj/bedsheetbin/attackby(obj/item/weapon/W as obj, mob/user as mob)

	if (istype(W, /obj/item/weapon/bedsheet))
		//W = null
		del(W)
		src.amount++
	return

/obj/bedsheetbin/interact(mob/user as mob)

	if (src.amount >= 1)
		src.amount--
		new /obj/item/weapon/bedsheet( src.loc )
		add_fingerprint(user)
	return

/obj/bedsheetbin/examine()
	set src in oview(1)

	src.amount = round(src.amount)
	if (src.amount <= 0)
		src.amount = 0
		usr << "There are no bed sheets in the bin."
	else
		if (src.amount == 1)
			usr << "There is one bed sheet in the bin."
		else
			usr << text("There are [] bed sheets in the bin.", src.amount)
	return

/obj/table/ex_act(severity)

	switch(severity)
		if(1.0)
			//SN src = null
			del(src)
			return
		if(2.0)
			if (prob(50))
				//SN src = null
				del(src)
				return
		if(3.0)
			if (prob(25))
				src.density = 0
		else
	return

/obj/table/blob_act()

	if(prob(50))
		new /obj/item/weapon/table_parts( src.loc )
		del(src)

/obj/table/interact_cuffed(mob/carbon/user as mob)
	if(user.appearance == APPEARANCE_MONKEY)
		return src.interact(user)
	return

/obj/table/interact(mob/carbon/user as mob)
	if(istype(user, /mob/carbon) && user.appearance == APPEARANCE_MONKEY)
		if (!( locate(/obj/table, user.loc) ))
			step(user, get_dir(user, src))
			if (user.loc == src.loc)
				user.layer = TURF_LAYER
				user.show_viewers("[src] hides under the table!")
	return ..()

/obj/table/CheckPass(atom/movable/O as mob|obj, target as turf)

	if ((O.flags & 2 || istype(O, /obj/meteor)))
		return 1
	else
		return 0
	return

/obj/table/MouseDrop_T(obj/O as obj, mob/carbon/user as mob)
	if(!istype(user, /mob/carbon))
		return
	if ((!( istype(O, /obj/item/weapon) ) || user.equipped() != O))
		return
	user.drop_item()
	if (O.loc != src.loc)
		step(O, get_dir(O, src))
	return

/obj/table/attackby(obj/item/weapon/W as obj, mob/carbon/user as mob)

	if (istype(W, /obj/item/weapon/wrench))
		new /obj/item/weapon/table_parts( src.loc )
		//SN src = null
		del(src)
		return
		return
	user.drop_item()
	if (W.loc != src.loc)
		step(W, get_dir(W, src))
	return

/obj/rack/ex_act(severity)

	switch(severity)
		if(1.0)
			//SN src = null
			del(src)
			return
		if(2.0)
			if (prob(50))
				//SN src = null
				del(src)
				return
		if(3.0)
			if (prob(25))
				src.icon_state = "rackbroken"
				src.density = 0
		else
	return

/obj/rack/blob_act()
	if(prob(50))
		src.icon_state = "rackbroken"
		src.density = 0


/obj/rack/CheckPass(atom/movable/O as mob|obj, target as turf)

	if (O.flags & 2)
		return 1
	else
		return 0
	return

/obj/rack/MouseDrop_T(obj/O as obj, mob/carbon/user as mob)
	if(!istype(user, /mob/carbon))
		return
	if ((!( istype(O, /obj/item/weapon) ) || user.equipped() != O))
		return
	user.drop_item()
	if (O.loc != src.loc)
		step(O, get_dir(O, src))
	return

/obj/rack/attackby(obj/item/weapon/W as obj, mob/carbon/user as mob)

	if (istype(W, /obj/item/weapon/wrench))
		new /obj/item/weapon/rack_parts( src.loc )
		//SN src = null
		del(src)
		return
		return
	user.drop_item()
	if (W.loc != src.loc)
		step(W, get_dir(W, src))
	return

/obj/rack/meteorhit(obj/O as obj)
	src.icon_state = "rackbroken"
	src.density = 0
	return

/obj/weldfueltank/attackby(obj/item/weapon/weldingtool/W as obj, mob/user as mob)

	if (!( istype(W, /obj/item/weapon/weldingtool) ))
		return
	W.weldfuel = 20
	W.suffix = text("[][]", (W == src ? "equipped " : ""), W.weldfuel)
	user << "\blue Welder refueled"
	return

/obj/weldfueltank/ex_act(severity)

	switch(severity)
		if(1.0)
			//SN src = null
			del(src)
			return
		if(2.0)
			if(prob(25))
				var/turf/T = src.loc
				T.gas.plasma += 1600000
				T.gas.oxygen += 1600000
			del(src)
		if(3.0)
			if(prob(5))
				var/turf/T = src.loc
				T.gas.plasma += 1600000
				T.gas.oxygen += 1600000
				//SN src = null
				del(src)
				return
		else
	return

/obj/weldfueltank/blob_act()
	if(prob(25))
		var/turf/T = src.loc
		T.gas.plasma += 1600000
		T.gas.oxygen += 1600000
		del(src)

/obj/watertank/attackby(obj/item/weapon/extinguisher/W as obj, mob/user as mob)

	if (!( istype(W, /obj/item/weapon/extinguisher) ))
		return
	W.waterleft = 20
	W.suffix = text("[][]", (user.equipped() == src ? "equipped " : ""), W.waterleft)
	user << "\blue Extinguisher refueled"
	return

/obj/watertank/ex_act(severity)

	switch(severity)
		if(1.0)
			//SN src = null
			del(src)
			return
		if(2.0)
			if (prob(50))
				//SN src = null
				new /obj/effects/water(src.loc)
				del(src)
				return
		if(3.0)
			if (prob(5))
				//SN src = null
				new /obj/effects/water(src.loc)
				del(src)
				return
		else
	return

/obj/watertank/blob_act()
	if(prob(25))
		new /obj/effects/water(src.loc)

		del(src)

/obj/d_girders/attackby(obj/item/weapon/W as obj, mob/user as mob)

	if (istype(W, /obj/item/weapon/sheet/metal))
		if (W:amount < 1)
			//W = null
			del(W)
			return
		var/turf/station/wall/false_wall/fwall = new /turf/station/wall/false_wall( src.loc )
		fwall.known_by += user
		user << "False wall constructed."
		W:amount--
		if (W:amount < 1)
			del(W)
		del(src)
		return
	else
		if (istype(W, /obj/item/weapon/screwdriver))
			new /obj/item/weapon/sheet/metal( src.loc )
			//SN src = null
			del(src)
			return
	return

/obj/barrier/New()

	var/t = 1800
	spawn( t )
		//SN src = null
		del(src)
		return
		return
	return

/obj/portal/Bumped(mob/M as mob|obj)

	spawn( 0 )
		src.teleport(M)
		return
	return

/obj/portal/HasEntered(AM as mob|obj)

	spawn( 0 )
		src.teleport(AM)
		return
	return

/obj/portal/New()

	spawn( 300 )
		//SN src = null
		del(src)
		return
		return
	return

/obj/portal/proc/teleport(atom/movable/M as mob|obj)
	if(istype(M, /obj/effects)) //sparks don't teleport
		return
	if (M.anchored)
		return
	if (src.icon_state == "portal1")
		return
	if (!( src.target ))
		del(src)
		return
	if (istype(M, /atom/movable))
		if (prob(10)) //oh dear something has gone wrong, put em in deep space
			do_teleport(M, locate(rand(5, world.maxx - 5), rand(5, world.maxy - 5), 3), 5)
		else
			do_teleport(M, src.target, 5)

/obj/effects/water/New()

	..()
	var/turf/T = src.loc
	if (istype(T, /turf))
		T.firelevel = 0
	spawn( 70 )
		//SN src = null
		del(src)
		return

	return

/obj/effects/water/Del()

	var/turf/T = src.loc
	if (istype(T, /turf))
		T.firelevel = 0
	..()
	return

/obj/effects/water/Move(turf/newloc)

	var/turf/T = src.loc
	if (istype(T, /turf))
		T.firelevel = 0
	if (--src.life < 1)
		//SN src = null
		del(src)
	if(newloc.density)
		return 0


	.=..()

/atom/proc/MouseDrop_T()

	return

/atom/proc/interact(mob/user as mob)
	return 1

/atom/proc/interact_cuffed(mob/user as mob)
	return 1

/atom/proc/hitby(obj/item/weapon/W as obj)

	return

/atom/proc/attackby(obj/item/weapon/W as obj, mob/user as mob)

	if (istype(W, /obj/item/weapon/f_print_scanner))
		user.show_viewers(text("\red [] has been scanned by [] with the []", src, user, W))
	else if (!( istype(W, /obj/item/weapon/grab) ))
		user.show_viewers(text("\red <B>[] has been hit by [] with []</B>", src, user, W))
	return

/atom/proc/add_fingerprint(mob/carbon/M as mob)
	if (!istype(M, /mob/carbon) || !istype(M.dna, /datum/dna))
		return 0
	if (!(src.flags & FPRINT))
		return
	if (M.gloves)
		return 0
	if(!src.fingerprints)
		src.fingerprints = list()
	src.fingerprints -= M.fingerprint
	while(src.fingerprints.len >= 3)
		src.fingerprints -= src.fingerprints[1]
	src.fingerprints += M.fingerprint
	return

/atom/MouseDrop(atom/over_object as mob|obj|turf|area)

	spawn( 0 )
		if (istype(over_object, /atom))
			over_object.MouseDrop_T(src, usr)
		return
	..()
	return

/atom/Click()
	//world << "atom.Click() on [src] by [usr] : src.type is [src.type]"
	return DblClick()

/atom/DblClick()
	if(!usr.is_active())
		return
	if (world.time <= usr:lastDblClick+2)
		return
	usr:lastDblClick = world.time

	..()
	if(usr.ui_mode == UI_MODE_THROW && istype(usr, /mob/carbon))
		var/mob/carbon/M = usr
		return M.throw_item(src)
	var/obj/item/weapon/W = null
	if(istype(usr, /mob/carbon))
		var/mob/carbon/M = usr
		W = M.equipped()
	if (W == src)
		spawn( 0 )
			W.attack_self(usr)
			return
		return
	if (((!usr.canmove) && (!istype(usr, /mob/silicon/ai))))
		return

	var/turf/targetturf = get_turf(src)

	if ((!( src in usr.contents ) && (((!( isturf(src) ) && (!( isturf(src.loc) ) && (src.loc && !( isturf(src.loc.loc) )))) || !( isturf(usr.loc) )) && (src.loc != usr.loc && (!( istype(src, /obj/screen) ) && !( usr.contents.Find(src.loc) ))))))
		return
	var/t5 = (get_dist(src, usr) <= 1 || src.loc == usr)
	if (istype(usr, /mob/silicon/ai))
		t5 = 1

	if (((t5 || (W && (W.flags & 16))) && !( istype(src, /obj/screen) )))
		if (usr.next_move < world.time)
			usr.prev_move = usr.next_move
			usr.next_move = world.time + 10
		else
			return
		if ((src.loc && (get_dist(src, usr) < 2 || src.loc == usr.loc)))
			var/direct = get_dir(usr, src)
			var/obj/item/weapon/dummy/D = new /obj/item/weapon/dummy( usr.loc )
			var/ok = 0
			if ( (direct - 1) & direct)
				var/turf/T
				switch(direct)
					if(NORTHEAST)
						T = get_step(usr, NORTH)
						if (T.Enter(D, src))
							D.loc = T
							T = targetturf
							if (T.Enter(D, src))
								ok = 1
						if(!ok)
							T = get_step(usr, EAST)
							if (T.Enter(D, src))
								D.loc = T
								T = targetturf
								if (T.Enter(D, src))
									ok = 1
					if(SOUTHEAST)
						T = get_step(usr, SOUTH)
						if (T.Enter(D, src))
							D.loc = T
							T = targetturf
							if (T.Enter(D, src))
								ok = 1
						if(!ok)
							T = get_step(usr, EAST)
							if (T.Enter(D, src))
								D.loc = T
								T = targetturf
								if (T.Enter(D, src))
									ok = 1
					if(NORTHWEST)
						T = get_step(usr, NORTH)
						if (T.Enter(D, src))
							D.loc = T
							T = targetturf
							if (T.Enter(D, src))
								ok = 1
						if(!ok)
							T = get_step(usr, WEST)
							if (T.Enter(D, src))
								D.loc = T
								T = targetturf
								if (T.Enter(D, src))
									ok = 1
					if(SOUTHWEST)
						T = get_step(usr, SOUTH)
						if (T.Enter(D, src))
							D.loc = T
							T = targetturf
							if (T.Enter(D, src))
								ok = 1
						if(!ok)
							T = get_step(usr, WEST)
							if (T.Enter(D, src))
								D.loc = T
								T = targetturf
								if (T.Enter(D, src))
									ok = 1
			else
				if (targetturf.Enter(D, src))
					ok = 1
				else
					if ((src.flags & 512 && get_dir(src, usr) & src.dir))
						ok = 1
						if (usr.loc != targetturf)
							for(var/atom/A as mob|obj|turf|area in usr.loc)
								if ((!( A.CheckExit(usr, targetturf) ) && A != usr))
									ok = 0
			del(D)
			if (!( ok ))
				return 0

		if (!usr.is_handcuffed())
			if (W)
				if (t5)
					src.attackby(W, usr)
				if (W)
					W.afterattack(src, usr, (t5 ? 1 : 0))
			else
				if(src.is_ai_interactable || istype(usr, /mob/carbon))
					src.interact(usr)
		else
			if(istype(usr, /mob/carbon))
				src.interact_cuffed(usr)

	else
		if (istype(src, /obj/screen))
			usr.prev_move = usr.next_move
			if (usr.next_move < world.time)
				usr.next_move = world.time + 10
			else
				return
			if (!( usr.is_handcuffed() ))
				if ((W && !( istype(src, /obj/screen) )))
					src.attackby(W, usr)

					if (W)
						W.afterattack(src, usr)
				else
					if(!istype(src, /obj/item) || istype(usr, /mob/carbon))
						src.interact(usr)
			else
				if(!istype(src, /obj/item) || istype(usr, /mob/carbon))
					src.interact_cuffed(usr)
	return


/obj/proc/updateUsrDialog()
	var/list/nearby = viewers(1, src)
	for(var/mob/M in nearby)
		if ((M.client && M.machine == src))
			src.interact(M)
	if (istype(usr, /mob/silicon/ai))
		if (!(usr in nearby))
			if (usr.client && usr.machine==src) // && M.machine == src is omitted because if we triggered this by using the dialog, it doesn't matter if our machine changed in between triggering it and this - the dialog is probably still supposed to refresh.
				src.interact(usr)

/obj/proc/updateDialog()
	var/list/nearby = viewers(1, src)
	for(var/mob/M in nearby)
		if ((M.client && M.machine == src))
			src.interact(M)
	AutoUpdateAI(src)
