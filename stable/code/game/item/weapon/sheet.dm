/obj/item/weapon/sheet
	name = "sheet"
	var/amount = 1.0
	var/length = 2.5
	var/width = 1.5
	var/height = 0.01
	flags = 322.0
	throwforce = 7.0
	throw_speed = 1
	throw_range = 4
	w_class = 4.0
/obj/item/weapon/sheet/glass
	name = "glass"
	icon_state = "sheet-glass"
	force = 5.0
/obj/item/weapon/sheet/rglass
	name = "reinforced glass"
	icon_state = "sheet-rglass"
	s_istate = "sheet-rglass"
	force = 6.0
/obj/item/weapon/sheet/metal
	name = "metal"
	icon_state = "sheet-metal"
	throwforce = 14.0
/obj/item/weapon/sheet/r_metal
	name = "reinforced metal"
	icon_state = "sheet-r_metal"
	force = 5.0
	throwforce = 14.0
	s_istate = "sheet-metal"



/obj/item/weapon/sheet/New(loc, amount)
	..(loc)
	if(amount)
		src.amount = amount


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
	ss13_browse(user, t1, "window=met_sheet")
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
				world.log_construct("[usr] ([usr.ckey]) constructed a stool at [usr.x], [usr.y], [usr.z].")
			if("chair")
				src.amount--
				var/obj/stool/chair/C = new /obj/stool/chair( usr.loc )
				world.log_construct("[usr] ([usr.ckey]) constructed a chair at [usr.x], [usr.y], [usr.z].")
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
				world.log_construct("[usr] ([usr.ckey]) constructed an oxygen canister at [usr.x], [usr.y], [usr.z].")
			if("plcan")
				if (src.amount < 2)
					return
				src.amount -= 2
				var/obj/machinery/atmoalter/canister/poisoncanister/C = new /obj/machinery/atmoalter/canister/poisoncanister( usr.loc )
				world.log_construct("[usr] ([usr.ckey]) constructed a plasma canister at [usr.x], [usr.y], [usr.z].")
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
				world.log_construct("[usr] ([usr.ckey]) constructed a closet at [usr.x], [usr.y], [usr.z].")
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
				world.log_construct("[usr] ([usr.ckey]) constructed a wall at [usr.x], [usr.y], [usr.z].")

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
			ss13_browse(user, null, "window=met_sheet")
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
			world.log_construct("[usr] ([usr.ckey]) constructed a window at [usr.x], [usr.y], [usr.z].")
			W.anchored = 0
			if (src.amount < 1)
				return
			src.amount--
		if("full (2 sheets)")
			if (src.amount < 2)
				return
			src.amount -= 2
			var/obj/window/W = new /obj/window( usr.loc )
			world.log_construct("[usr] ([usr.ckey]) constructed a window at [usr.x], [usr.y], [usr.z].")
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
			world.log_construct("[usr] ([usr.ckey]) constructed a reinforced window at [usr.x], [usr.y], [usr.z].")
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
			world.log_construct("[usr] ([usr.ckey]) constructed a reinforced window at [usr.x], [usr.y], [usr.z].")
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
