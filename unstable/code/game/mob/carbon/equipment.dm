/mob/carbon/u_equip(obj/item/weapon/W as obj)
	if (W == src.suit)
		src.suit = null
	else if (W == src.jumpsuit)
		for(var/x in list(SLOT_R_STORE, SLOT_L_STORE, SLOT_ID, SLOT_BELT))
			src.drop(x)
	else if (W == src.gloves)
		src.gloves = null
	else if (W == src.glasses)
		src.glasses = null
	else if (W == src.head)
		src.head = null
	else if (W == src.shoes)
		src.shoes = null
	else if (W == src.belt)
		src.belt = null
	else if (W == src.mask)
		src.mask = null
	else if (W == src.headset)
		src.headset = null
	else if (W == src.id)
		src.id = null
	else if (W == src.r_store)
		src.r_store = null
	else if (W == src.l_store)
		src.l_store = null
	else if (W == src.back)
		src.back = null
	else if (W == src.handcuffs)
		src.handcuffs = null
	else if (W == src.r_hand)
		src.r_hand = null
	else if (W == src.l_hand)
		src.l_hand = null
	return

/mob/carbon/proc/drop_all()
	for(var/obj/item/weapon/W in src)
		src.u_equip(W)
		if (src.client)
			src.client.screen -= W
		if (W)
			W.loc = src.loc
			W.dropped(src)
			W.layer = initial(W.layer)
	src.UpdateClothing()

/mob/carbon/proc/drop(slot)
	var/obj/item/weapon/W
	switch(slot)
		if(SLOT_BACK)
			W = src.back
			src.back = null
		if(SLOT_MASK)
			W = src.mask
			src.mask = null
		if(SLOT_HANDCUFFS)
			W = src.handcuffs
			src.handcuffs = null
		if(SLOT_L_HAND)
			W = src.l_hand
			src.l_hand = null
		if(SLOT_R_HAND)
			W = src.r_hand
			src.r_hand = null
		if(SLOT_BELT)
			W = src.belt
			src.belt = null
		if(SLOT_ID)
			W = src.id
			src.id = null
		if(SLOT_GLASSES)
			W = src.glasses
			src.glasses = null
		if(SLOT_GLOVES)
			W = src.gloves
			src.gloves = null
		if(SLOT_HELMET)
			W = src.helmet
			src.helmet = null
		if(SLOT_SHOES)
			W = src.shoes
			src.shoes = null
		if(SLOT_SUIT)
			W = src.suit
			src.suit = null
		if(SLOT_JUMPSUIT)
			W = src.jumpsuit
			src.jumpsuit = null
			for(var/x in list(SLOT_R_STORE, SLOT_L_STORE, SLOT_ID, SLOT_BELT))
				src.drop(x)
		if(SLOT_L_STORE)
			W = src.l_store
			src.l_store = null
		if(SLOT_R_STORE)
			W = src.r_store
			src.r_store = null
		if(SLOT_HEADSET)
			W = src.headset
			src.headset = null
	if (W)
		if (src.client)
			src.client.screen -= W
		W.loc = src.loc
		W.dropped(src)
		W.layer = initial(W.layer)

/mob/carbon/db_click(text, t1)
	var/obj/item/weapon/W = src.equipped()
	var/emptyHand = (W == null)
	if ((!emptyHand) && (!istype(W, /obj/item/weapon)))
		return
	if (emptyHand)
		usr.next_move = usr.prev_move
		usr:lastDblClick -= 3	//permit the double-click redirection to proceed.
	switch(text)
		if("mask" && src.can_wear_mask)
			if (src.mask)
				if (emptyHand)
					src.mask.DblClick()
				return
			if (!( istype(W, /obj/item/weapon/clothing/mask) ))
				return
			src.u_equip(W)
			src.mask = W
		if("back" && src.can_wear_back)
			if (src.back)
				if (emptyHand)
					src.back.DblClick()
				return
			if (!istype(W, /obj/item/weapon))
				return
			if (!( W.flags & 1 ))
				return
			src.u_equip(W)
			src.back = W
		if("headset" && src.can_wear_headset)
			if (src.headset)
				if (emptyHand)
					src.headset.DblClick()
				return
			if (!( istype(W, /obj/item/weapon/radio/headset) ))
				return
			src.u_equip(W)
			src.headset = W
		if("o_clothing" && src.can_wear_suit)
			if (src.suit)
				if (emptyHand)
					src.suit.DblClick()
				return
			if (!( istype(W, /obj/item/weapon/clothing/suit) ))
				return
			src.u_equip(W)
			src.suit = W
		if("gloves" && src.can_wear_gloves)
			if (src.gloves)
				if (emptyHand)
					src.gloves.DblClick()
				return
			if (!( istype(W, /obj/item/weapon/clothing/gloves) ))
				return
			src.u_equip(W)
			src.gloves = W
		if("shoes" && src.can_wear_shoes)
			if (src.shoes)
				if (emptyHand)
					src.shoes.DblClick()
				return
			if (!( istype(W, /obj/item/weapon/clothing/shoes) ))
				return
			src.u_equip(W)
			src.shoes = W
		if("belt" && src.can_wear_belt)
			if ((src.belt || !( istype(W, /obj/item/weapon) )))
				if (emptyHand)
					src.belt.DblClick()
				return
			if (!( W.flags & ONBELT ))
				return
			src.u_equip(W)
			src.belt = W
		if("eyes" && src.can_wear_glasses)
			if (src.glasses)
				if (emptyHand)
					src.glasses.DblClick()
				return
			if (!( istype(W, /obj/item/weapon/clothing/glasses) ))
				return
			src.u_equip(W)
			src.glasses = W
		if("head" && src.can_wear_helmet)
			if (src.helmet)
				if (emptyHand)
					src.helmet.DblClick()
				return
			if (!( istype(W, /obj/item/weapon/clothing/head) ))
				return
			src.u_equip(W)
			src.helmet = W
		if("i_clothing" && src.can_wear_jumpsuit)
			if (src.jumpsuit)
				if (emptyHand)
					src.jumpsuit.DblClick()
				return
			if (!( istype(W, /obj/item/weapon/clothing/under) ))
				return
			src.u_equip(W)
			src.jumpsuit = W
		if("id" && src.can_wear_id)
			if (src.id)
				if (emptyHand)
					src.id.DblClick()
				return
			if (!src.jumpsuit)
				return
			if (!( istype(W, /obj/item/weapon/card/id) ))
				return
			src.u_equip(W)
			src.id = W
		if("storage1" && src.can_wear_l_store)
			if (src.l_store)
				if (emptyHand)
					src.l_store.DblClick()
				return
			if ((!( istype(W, /obj/item/weapon) ) || W.w_class >= 3 || !( src.jumpsuit )))
				return
			src.u_equip(W)
			src.l_store = W
		if("storage2" && src.can_wear_r_store)
			if (src.r_store)
				if (emptyHand)
					src.r_store.DblClick()
				return
			if ((!( istype(W, /obj/item/weapon) ) || W.w_class >= 3 || !( src.jumpsuit )))
				return
			src.u_equip(W)
			src.r_store = W

	src.update_clothing()
	return

/mob/carbon/proc/update_clothing()
	src.update_clothing_functions()
	src.update_clothing_icons()

/mob/carbon/proc/update_clothing_functions()
	src.update_vision()


/mob/carbon/proc/update_clothing_icons()
	if (!( src.jumpsuit ))
		for(var/x in list(SLOT_R_STORE, SLOT_L_STORE, SLOT_ID, SLOT_BELT))
			src.drop(x)
	src.overlays = null

	if (src.lying)
		src.icon = src.lying_icon
		if (src.face2)
			src.overlays += src.face2
		src.overlays += src.body_lying
	else
		src.icon = src.stand_icon
		if (src.face)
			src.overlays += src.face
		src.overlays += src.body_standing

	if (src.client)
		src.client.screen -= src.hud_used.other
		src.client.screen -= src.hud_used.intents
		src.client.screen -= src.hud_used.mov_int
		src.client.screen += src.hud_used.other
		if (src.i_select)
			if (src.intent)
				src.client.screen += src.hud_used.intents
				src.i_select.screen_loc = src.intent
			else
				src.i_select.screen_loc = null
		if (src.m_select)
			if (src.m_int)
				src.client.screen += src.hud_used.mov_int
				src.m_select.screen_loc = src.m_int
			else
				src.m_select.screen_loc = null


	var/suffix = src.lying ? "2" : null
	var/icons = list()
	icons[src.gloves] = "4,2"
	icons[src.shoes] = "5,2"
	icons[src.glasses] = "6,2"
	icons[src.helmet] = "7,2"
	icons[src.belt] = "8,2"

	icons[src.suit] = "2,1"
	icons[src.mask] = "2,3"
	icons[src.headset] = "3,1"
	icons[src.r_hand] = "1,2"
	icons[src.l_hand] = "3,2"

	var/iconsource = src.appearance == APPEARANCE_MONKEY ? 'monkey.dmi' : 'mob.dmi'

	for(var/obj/item/weapon/W in icons)
		var/type = W.s_istate
		if (!type)
			type = W.icon_state
		src.overlays += image("icon" = iconsource, "icon_state" = "[type][suffix]", "layer" = MOB_LAYER)
		W.screen_loc = icons[W]

	if (src.jumpsuit && istype(src.jumpsuit, /obj/item/weapon/clothing/under))
		var/color = src.jumpsuit.color
		if (!color)
			color = src.icon_state
		src.overlays += image("icon" = 'uniforms.dmi', "icon_state" = "[color][suffix]", "layer" = MOB_LAYER)
		src.jumpsuit.screen_loc = "2,2"
	if (src.id)
		src.overlays += image("icon" = iconsource, "icon_state" = "id[suffix]", "layer" = MOB_LAYER)
		src.id.screen_loc = "1,1"
	if (src.l_hand)
		var/type = src.l_hand.s_istate
		if (!type)
			type = src.l_hand.icon_state
		src.overlays += image("icon" = 'l_items.dmi', "icon_state" = "[type]", "layer" = MOB_LAYER)
		src.l_hand.screen_loc = "3,2"
	if (src.r_hand)
		var/type = src.r_hand.s_istate
		if (!type)
			type = src.r_hand.icon_state
		src.overlays += image("icon" = 'r_items.dmi', "icon_state" = "[type]", "layer" = MOB_LAYER)
		src.r_hand.screen_loc = "3,2"

	if (src.l_store)
		src.l_store.screen_loc = "4,1"
	if (src.r_store)
		src.r_store.screen_loc = "5,1"


	if (src.suit && istype(src.suit, /obj/item/weapon/clothing/suit/straight_jacket))
		//can't hold things if you're wearing a straitjacket!
		src.drop_item(SLOT_L_HAND)
		src.drop_item(SLOT_R_HAND)

	src.update_name()

	if (src.back)
		var/elect = ""
		if (istype(src.back, /obj/item/weapon/radio/electropack))
			elect = "e"
		src.overlays += image("icon" = iconsource, "icon_state" = "back[elect][suffix]", "layer" = MOB_LAYER)
		src.back.screen_loc = "3,3"

	if (src.handcuffs)
		src.pulling = null
		src.overlays += image("icon" = iconsource, "icon_state" = "handcuff[suffix]", "layer" = MOB_LAYER)
	if (src.client)
		src.client.screen -= src.contents
		src.client.screen += src.contents

	src.update_invisibility()

	for(var/mob/M in viewers(1, src))
		if ((M.client && M.machine == src))
			spawn( 0 )
				src.show_inv(M)
				return

	return

/mob/carbon/update_name()
	if ((src.mask && !(src.mask.see_face)) || (src.head && !(src.head.see_face))) // can't see the face
		if(src.id && src.id.registered)
			src.name = src.id.registered
		else
			src.name = "Unknown"
	else
		if (src.id && src.id.registered != src.rname)
			src.name = "[src.rname] (as [src.id.registered])"
		else
			src.name = src.rname

/mob/carbon/update_invisibility()
	src.invisibility = 0
	for(var/obj/item/weapon/cloaking_device/S in src)
		if (S.active)
			src.invisibility = 2
			src.overlays += image("icon" = 'mob.dmi', "icon_state" = "shield", "layer" = MOB_LAYER)
			return

/mob/carbon/show_inv(mob/user as mob)

	user.machine = src
	var/dat = "<PRE>\n<B><FONT size=3>[src.name]</FONT></B>"
	var/L = list(
		list(src.can_wear_helmet, "Helmet", SLOT_HELMET, src.helmet),
		list(src.can_wear_mask, "Mask", SLOT_MASK, src.mask),
		list(src.can_wear_glasses, "Glasses", SLOT_GLASSES, src.glasses),
		list(src.can_wear_headset, "Headset", SLOT_HEADSET, src.headset),
		list(src.can_wear_gloves, "Gloves", SLOT_GLOVES, src.gloves),
		list(src.can_wear_l_hand, "Left Hand", SLOT_L_HAND, src.l_hand),
		list(src.can_wear_r_hand, "Right Hand", SLOT_R_HAND, src.r_hand),
		list(src.can_wear_suit, "Suit", SLOT_SUIT, src.suit),
		list(src.can_wear_jumpsuit, "Jumpsuit", SLOT_JUMPSUIT, src.jumpsuit),
		list(src.can_wear_belt, "Belt", SLOT_BELT, src.belt),
		list(src.can_wear_id, "ID", SLOT_ID, src.id)
	)
	for(var/x in L)
		var/can_wear = x[1]
		if(can_wear)
			var/desc = x[2]
			var/link = x[3]
			var/contents = x[4] ? x[4] : "Nothing"
			dat += "<b>[desc]</b> <a href='?src=\ref[src];item=[link]'>[contents]</a>"
	dat += "<a href='?src=\ref[src];item=[SLOT_HANDCUFFS]'>[src.handcuffed ? "" : "Not "]Handcuffed</A>"
	dat += "<a href='?src=\ref[src];item=pockets'>Empty Pockets</A>"
	dat += "<a href='?src=\ref[src];mach_close=mob[src]'>Close</A>\n</PRE>"
	user << browse(dat, text("window=mob[];size=300x600", src.key))
	return

/mob/carbon/proc/drop_item_v()
	if (src.is_conscious && !src.knockdown)
		drop_item()
	return

/mob/carbon/proc/drop_item()

	var/obj/item/weapon/W = src.equipped()
	if (W)
		u_equip(W)
		if (src.client)
			src.client.screen -= W
		if (W)
			W.loc = src.loc
			W.dropped(src)
			if (W)
				W.layer = initial(W.layer)
	return

/mob/carbon/proc/swap_hand()

	src.hand = !( src.hand )
	if (!( src.hand ))
		src.hands.dir = NORTH
	else
		src.hands.dir = SOUTH
	return

/mob/carbon/proc/equipped()

	if (src.hand)
		return src.l_hand
	else
		return src.r_hand
	return

/mob/carbon/MouseDrop(mob/carbon/M as mob)

	..()
	if (M != usr || usr == src || get_dist(usr, src) > 1 || !istype(M, /mob/carbon))
		return
	src.show_inv(usr)
	return

/mob/carbon/proc/equip_if_possible(obj/item/weapon/W, slot) // since byond doesn't seem to have pointers, this seems like the best way to do this :/
	//warning: icky code
	var/equipped = 0
	if((slot == SLOT_L_STORE || slot == SLOT_R_STORE || slot == SLOT_BELT || slot == SLOT_ID) && !src.jumpsuit)
		del(W)
		return
	switch(slot)
		if(SLOT_BACK)
			if(!src.back && src.can_wear_back)
				src.back = W
				equipped = 1
		if(SLOT_MASK)
			if(!src.mask && src.can_wear_mask)
				src.mask = W
				equipped = 1
		if(SLOT_HANDCUFFS)
			if(!src.handcuffs && src.can_wear_handcuffs)
				src.handcuffs = W
				equipped = 1
		if(SLOT_L_HAND)
			if(!src.l_hand && src.can_wear_l_hand)
				src.l_hand = W
				equipped = 1
		if(SLOT_R_HAND)
			if(!src.r_hand && src.can_wear_r_hand)
				src.r_hand = W
				equipped = 1
		if(SLOT_BELT)
			if(!src.belt && src.can_wear_belt && src.jumpsuit)
				src.belt = W
				equipped = 1
		if(SLOT_ID)
			if(!src.id && src.can_wear_id && src.jumpsuit)
				src.id = W
				equipped = 1
		if(SLOT_GLASSES)
			if(!src.glasses && src.can_wear_glasses)
				src.glasses = W
				equipped = 1
		if(SLOT_GLOVES)
			if(!src.gloves && src.can_wear_gloves)
				src.gloves = W
				equipped = 1
		if(SLOT_HELMET)
			if(!src.head && src.can_wear_helmet)
				src.head = W
				equipped = 1
		if(SLOT_SHOES)
			if(!src.shoes && src.can_wear_shoes)
				src.shoes = W
				equipped = 1
		if(SLOT_SUIT)
			if(!src.suit && src.can_wear_suit)
				src.suit = W
				equipped = 1
		if(SLOT_JUMPSUIT)
			if(!src.jumpsuit && src.can_wear_back)
				src.jumpsuit = W
				equipped = 1
		if(SLOT_L_STORE)
			if(!src.l_store && src.can_wear_l_store && src.jumpsuit)
				src.l_store = W
				equipped = 1
		if(SLOT_R_STORE)
			if(!src.r_store && src.can_wear_r_store && src.jumpsuit)
				src.r_store = W
				equipped = 1
		if(SLOT_HEADSET && src.can_wear_headset)
			if(!src.headset)
				src.headset = W
				equipped = 1
		if(SLOT_IN_BACKPACK)
			if (src.back && istype(src.back, /obj/item/weapon/storage/backpack))
				var/obj/item/weapon/storage/backpack/B = src.back
				if(B.contents.len < 7 && W.w_class <= 3)
					W.loc = B
					equipped = 1
	if(equipped)
		W.layer = 20
	else
		del(W)