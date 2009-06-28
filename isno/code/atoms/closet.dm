/obj/closet
	desc = "It's a closet!"
	name = "Closet"
	icon = 'stationobjs.dmi'
	icon_state = "closet"
	density = 1
	var/icon_closed = "closet"
	var/icon_opened = "closet1"
	var/opened = 0.0
	var/welded = 0.0
	flags = FPRINT
	weight = 1.0E8

/obj/closet/coffin
	desc = "A burial receptacle for the dearly departed."
	name = "coffin"
	icon_state = "premium_coffin_closed"
	icon_closed = "premium_coffin_closed"
	icon_opened = "premium_coffin_opened"

/obj/closet/l3closet
	desc = "A bulky (yet mobile) closet. Comes prestocked with level 3 biohazard gear for emergencies."
	name = "Level 3 Biohazard Suit"
	icon_state = "l3closet0"
	icon_closed = "l3closet0"
	icon_opened = "l3closet1"

/obj/closet/wardrobe
	desc = "A bulky (yet mobile) wardrobe closet. Comes prestocked with 6 changes of clothes."
	name = "Wardrobe"
	icon_state = "wardrobe-b"
	icon_closed = "wardrobe-b"

/obj/closet/wardrobe/black
	name = "Black Wardrobe"
	icon_state = "wardrobe-bl"
	icon_closed = "wardrobe-bl"

/obj/closet/wardrobe/green
	name = "Green Wardrobe"
	icon_state = "wardrobe-g"
	icon_closed = "wardrobe-g"

/obj/closet/wardrobe/mixed
	name = "Mixed Wardrobe"
	icon_state = "wardrobe-bp"
	icon_closed = "wardrobe-bp"

/obj/closet/wardrobe/orange
	name = "Prisoners Wardrobe"
	icon_state = "wardrobe-o"
	icon_closed = "wardrobe-o"

/obj/closet/wardrobe/pink
	name = "Pink Wardrobe"
	icon_state = "wardrobe-p"
	icon_closed = "wardrobe-p"

/obj/closet/wardrobe/red
	name = "Red Wardrobe"
	icon_state = "wardrobe-r"
	icon_closed = "wardrobe-r"

/obj/closet/wardrobe/white
	name = "Medical Wardrobe"
	icon_state = "wardrobe-w"
	icon_closed = "wardrobe-w"

/obj/closet/wardrobe/yellow
	name = "Technician Wardrobe"
	icon_state = "wardrobe-y"
	icon_closed = "wardrobe-y"



/obj/closet/alter_health()

	return src.loc
	return

/obj/closet/CheckPass(O as mob|obj, target as turf)

	if (!src.opened)
		return 0
	else
		return 1
	return

/obj/closet/l3closet/New()

	..()
	sleep(2)
	new /obj/item/weapon/clothing/suit/bio_suit( src )
	new /obj/item/weapon/clothing/under/white( src )
	new /obj/item/weapon/clothing/shoes/white( src )
	new /obj/item/weapon/clothing/head/bio_hood( src )

	return

/obj/closet/wardrobe/New()

	new /obj/item/weapon/clothing/under/blue( src )
	new /obj/item/weapon/clothing/under/blue( src )
	new /obj/item/weapon/clothing/under/blue( src )
	new /obj/item/weapon/clothing/under/blue( src )
	new /obj/item/weapon/clothing/under/blue( src )
	new /obj/item/weapon/clothing/under/blue( src )
	new /obj/item/weapon/clothing/shoes/brown( src )
	new /obj/item/weapon/clothing/shoes/brown( src )
	new /obj/item/weapon/clothing/shoes/brown( src )
	new /obj/item/weapon/clothing/shoes/brown( src )
	new /obj/item/weapon/clothing/shoes/brown( src )
	new /obj/item/weapon/clothing/shoes/brown( src )
	return

/obj/closet/wardrobe/red/New()

	new /obj/item/weapon/clothing/under/red( src )
	new /obj/item/weapon/clothing/under/red( src )
	new /obj/item/weapon/clothing/under/red( src )
	new /obj/item/weapon/clothing/under/red( src )
	new /obj/item/weapon/clothing/under/red( src )
	new /obj/item/weapon/clothing/under/red( src )
	new /obj/item/weapon/clothing/shoes/brown( src )
	new /obj/item/weapon/clothing/shoes/brown( src )
	new /obj/item/weapon/clothing/shoes/brown( src )
	new /obj/item/weapon/clothing/shoes/brown( src )
	new /obj/item/weapon/clothing/shoes/brown( src )
	new /obj/item/weapon/clothing/shoes/brown( src )
	return

/obj/closet/wardrobe/pink/New()

	new /obj/item/weapon/clothing/under/pink( src )
	new /obj/item/weapon/clothing/under/pink( src )
	new /obj/item/weapon/clothing/under/pink( src )
	new /obj/item/weapon/clothing/under/pink( src )
	new /obj/item/weapon/clothing/under/pink( src )
	new /obj/item/weapon/clothing/under/pink( src )
	new /obj/item/weapon/clothing/shoes/brown( src )
	new /obj/item/weapon/clothing/shoes/brown( src )
	new /obj/item/weapon/clothing/shoes/brown( src )
	new /obj/item/weapon/clothing/shoes/brown( src )
	new /obj/item/weapon/clothing/shoes/brown( src )
	new /obj/item/weapon/clothing/shoes/brown( src )
	return

/obj/closet/wardrobe/black/New()

	new /obj/item/weapon/clothing/under/black( src )
	new /obj/item/weapon/clothing/under/black( src )
	new /obj/item/weapon/clothing/under/black( src )
	new /obj/item/weapon/clothing/under/black( src )
	new /obj/item/weapon/clothing/under/black( src )
	new /obj/item/weapon/clothing/under/black( src )
	new /obj/item/weapon/clothing/shoes/black( src )
	new /obj/item/weapon/clothing/shoes/black( src )
	new /obj/item/weapon/clothing/shoes/black( src )
	new /obj/item/weapon/clothing/shoes/black( src )
	new /obj/item/weapon/clothing/shoes/black( src )
	new /obj/item/weapon/clothing/shoes/black( src )
	return

/obj/closet/wardrobe/green/New()

	new /obj/item/weapon/clothing/under/green( src )
	new /obj/item/weapon/clothing/under/green( src )
	new /obj/item/weapon/clothing/under/green( src )
	new /obj/item/weapon/clothing/under/green( src )
	new /obj/item/weapon/clothing/under/green( src )
	new /obj/item/weapon/clothing/under/green( src )
	new /obj/item/weapon/clothing/shoes/black( src )
	new /obj/item/weapon/clothing/shoes/black( src )
	new /obj/item/weapon/clothing/shoes/black( src )
	new /obj/item/weapon/clothing/shoes/black( src )
	new /obj/item/weapon/clothing/shoes/black( src )
	new /obj/item/weapon/clothing/shoes/black( src )
	return

/obj/closet/wardrobe/orange/New()

	new /obj/item/weapon/clothing/under/orange( src )
	new /obj/item/weapon/clothing/under/orange( src )
	new /obj/item/weapon/clothing/under/orange( src )
	new /obj/item/weapon/clothing/under/orange( src )
	new /obj/item/weapon/clothing/under/orange( src )
	new /obj/item/weapon/clothing/under/orange( src )
	new /obj/item/weapon/clothing/shoes/orange( src )
	new /obj/item/weapon/clothing/shoes/orange( src )
	new /obj/item/weapon/clothing/shoes/orange( src )
	new /obj/item/weapon/clothing/shoes/orange( src )
	new /obj/item/weapon/clothing/shoes/orange( src )
	new /obj/item/weapon/clothing/shoes/orange( src )
	return

/obj/closet/wardrobe/yellow/New()

	new /obj/item/weapon/clothing/under/yellow( src )
	new /obj/item/weapon/clothing/under/yellow( src )
	new /obj/item/weapon/clothing/under/yellow( src )
	new /obj/item/weapon/clothing/under/yellow( src )
	new /obj/item/weapon/clothing/under/yellow( src )
	new /obj/item/weapon/clothing/under/yellow( src )
	new /obj/item/weapon/clothing/shoes/orange( src )
	new /obj/item/weapon/clothing/shoes/orange( src )
	new /obj/item/weapon/clothing/shoes/orange( src )
	new /obj/item/weapon/clothing/shoes/orange( src )
	new /obj/item/weapon/clothing/shoes/orange( src )
	new /obj/item/weapon/clothing/shoes/orange( src )
	return

/obj/closet/wardrobe/mixed/New()

	new /obj/item/weapon/clothing/under/blue( src )
	new /obj/item/weapon/clothing/under/blue( src )
	new /obj/item/weapon/clothing/under/blue( src )
	new /obj/item/weapon/clothing/under/pink( src )
	new /obj/item/weapon/clothing/under/pink( src )
	new /obj/item/weapon/clothing/under/pink( src )
	new /obj/item/weapon/clothing/shoes/brown( src )
	new /obj/item/weapon/clothing/shoes/brown( src )
	new /obj/item/weapon/clothing/shoes/brown( src )
	new /obj/item/weapon/clothing/shoes/brown( src )
	new /obj/item/weapon/clothing/shoes/brown( src )
	new /obj/item/weapon/clothing/shoes/brown( src )
	return

/obj/closet/wardrobe/white/New()

	new /obj/item/weapon/clothing/under/white( src )
	new /obj/item/weapon/clothing/under/white( src )
	new /obj/item/weapon/clothing/under/white( src )
	new /obj/item/weapon/clothing/under/white( src )
	new /obj/item/weapon/clothing/under/white( src )
	new /obj/item/weapon/clothing/shoes/white( src )
	new /obj/item/weapon/clothing/shoes/white( src )
	new /obj/item/weapon/clothing/shoes/white( src )
	new /obj/item/weapon/clothing/shoes/white( src )
	new /obj/item/weapon/clothing/shoes/white( src )
	new /obj/item/weapon/storage/stma_kit( src )
	new /obj/item/weapon/clothing/suit/labcoat(src)
	new /obj/item/weapon/clothing/suit/labcoat(src)
	new /obj/item/weapon/clothing/suit/labcoat(src)
	return

/obj/closet/ex_act(severity)

	switch(severity)
		if(1.0)
			for(var/atom/movable/A as mob|obj in src)
				A.loc = src.loc
				ex_act(severity)
				//Foreach goto(35)
			//SN src = null
			del(src)
			return
		if(2.0)
			if (prob(50))
				for(var/atom/movable/A as mob|obj in src)
					A.loc = src.loc
					ex_act(severity)
					//Foreach goto(108)
				//SN src = null
				del(src)
				return
		if(3.0)
			if (prob(5))
				for(var/atom/movable/A as mob|obj in src)
					A.loc = src.loc
					ex_act(severity)
					//Foreach goto(181)
				//SN src = null
				del(src)
				return
		else
	return


/obj/closet/secure/blob_act()

	if (prob(50))
		for(var/atom/movable/A as mob|obj in src)
			A.loc = src.loc
		del(src)

/obj/closet/meteorhit(obj/O as obj)

	if (O.icon_state == "flaming")
		for(var/obj/item/I in src)
			I.loc = src.loc
			//Foreach goto(29)
		for(var/mob/M in src)
			M.loc = src.loc
			if (M.client)
				M.client.eye = M.client.mob
				M.client.perspective = MOB_PERSPECTIVE
			//Foreach goto(71)
		src.icon_state = src.icon_opened
		//SN src = null
		del(src)
		return
	return

/obj/closet/attackby(obj/item/weapon/W as obj, mob/carbon/user as mob)

	if (src.opened)
		if (istype(W, /obj/item/weapon/grab))
			src.MouseDrop_T(W:affecting, user)      //act like they were dragged onto the closet
		user.drop_item()
		if (W)
			W.loc = src.loc
	else if(W.damtype == "fire" && istype(W, /obj/item/weapon/weldingtool))
		src.welded = !( src.welded )
		user.show_viewers(text("\red [] has been [] by [].", src, (src.welded ? "welded shut" : "unwelded"), user))
	else
		src.interact(user)

/obj/closet/relaymove(mob/user as mob)

	if (!user.is_active())
		return
	if (!( src.welded ))
		src.open()
	else
		user << "\blue It's welded shut!"
		if(user.can_use_hands()) //handcuffed folks can't bang
			for(var/mob/M in hearers(null, src))
				M.hear(text("<FONT size=[]>BANG, bang!</FONT>", max(0, 5 - get_dist(src, M))))
	return

/obj/closet/MouseDrop_T(atom/movable/O as mob|obj, mob/user as mob)

	if (!user.can_use_hands())
		return
	if ((!( istype(O, /atom/movable) ) || O.anchored || get_dist(user, src) > 1 || get_dist(user, O) > 1 || user.contents.Find(src)))
		return
	if (user.loc==null) // just in case someone manages to get a closet into the blue light dimension, as unlikely as that seems
		return
	if (!istype(user.loc, /turf)) // are you in a container/closet/pod/etc?
		return
	if(!src.opened)
		return
	step_towards(O, src.loc)
	user.show_viewers(text("\red [] stuffs [] into []!", user, O, src))
	src.add_fingerprint(user)
	return

/obj/closet/interact(mob/user as mob)

	src.add_fingerprint(user)
	if (!( src.opened ))
		if (!( src.welded ))
			src.open()
		else
			usr << "\blue It's welded shut!"
	else
		src.close()

/obj/closet/hear_message(datum/message/M, atom/source)
	for(var/atom/A in src)
		A.hear_message(M, source)

/obj/closet/CheckPass(O as mob|obj, target as turf)

	if (!( src.opened ))
		return 0
	else
		return 1
	return

/obj/closet/proc/open()
	for(var/obj/item/I in src)
		I.loc = src.loc
	for(var/mob/carbon/M in src)
		M.loc = src.loc
		if (M.client)
			M.client.eye = M.client.mob
			M.client.perspective = MOB_PERSPECTIVE
	src.icon_state = src.get_open_icon_state()
	src.opened = 1

/obj/closet/proc/close()
	for(var/obj/item/I in src.loc)
		if (!( I.anchored ))
			I.loc = src
	for(var/mob/carbon/M in src.loc)
		if (M.buckled)
			continue
		if (M.client)
			M.client.perspective = EYE_PERSPECTIVE
			M.client.eye = src
		M.loc = src
	src.icon_state = src.get_closed_icon_state()
	src.opened = 0

/obj/closet/proc/get_open_icon_state()
	return src.icon_opened

/obj/closet/proc/get_closed_icon_state()
	return src.icon_closed