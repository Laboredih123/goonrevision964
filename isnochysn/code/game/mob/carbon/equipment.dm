/mob/carbon/u_equip(obj/item/weapon/W as obj)
	if (W == src.suit)
		src.suit = null
	else if (W == src.jumpsuit)
		for(var/x in list(slot_r_store, slot_l_store, slot_id, slot_belt))
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
	/obj/item/weapon/W
	switch(slot)
		if(slot_back)
			W = src.back
			src.back = null
		if(slot_mask)
			W = src.mask
			src.mask = null
		if(slot_handcuffs)
			W = src.handcuffs
			src.handcuffs = null
		if(slot_l_hand)
			W = src.l_hand
			src.l_hand = null
		if(slot_r_hand)
			W = src.r_hand
			src.r_hand = null
		if(slot_belt)
			W = src.belt
			src.belt = null
		if(slot_id)
			W = src.id
			src.id = null
		if(slot_glasses)
			W = src.glasses
			src.glasses = null
		if(slot_gloves)
			W = src.gloves
			src.gloves = null
		if(slot_helmet)
			W = src.helmet
			src.helmet = null
		if(slot_shoes)
			W = src.shoes
			src.shoes = null
		if(slot_suit)
			W = src.suit
			src.suit = null
		if(slot_jumpsuit)
			W = src.jumpsuit
			src.jumpsuit = null
			for(var/x in list(slot_r_store, slot_l_store, slot_id, slot_belt))
				src.drop(x)
		if(slot_l_store)
			W = src.l_store
			src.l_store = null
		if(slot_r_store)
			W = src.r_store
			src.r_store = null
		if(slot_headset)
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

/mob/human/proc/update_clothing()
	src.update_clothing_functions()
	src.update_clothing_icons()

/mob/human/proc/update_clothing_functions()
	src.update_vision()


/mob/human/proc/update_clothing_icons()
	if (!( src.jumpsuit ))
		for(var/x in list(slot_r_store, slot_l_store, slot_id, slot_belt))
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

	if (src.jumpsuit)
		if (istype(src.jumpsuit, /obj/item/weapon/clothing/under))
			var/color = src.jumpsuit.color
			if (!color)
				color = src.icon_state
			src.overlays += image("icon" = 'uniforms.dmi', "icon_state" = "[color][suffix]", "layer" = MOB_LAYER)
		src.jumpsuit.screen_loc = "2,2"
	if (src.id)
		src.overlays += image("icon" = 'mob.dmi', "icon_state" = "id[suffix]"), "layer" = MOB_LAYER)
	if (src.client)
		src.client.screen -= src.hud_used.other
		src.client.screen -= src.hud_used.intents
		src.client.screen -= src.hud_used.mov_int

		src.client.screen += src.hud_used.other

		var/icons = list()
		icons[src.gloves] = "4,2"
		icons[src.shoes] = "5,2"
		icons[src.glasses] = "6,2"
		icons[src.helmet] = "7,2"
		icons[src.belt] = "8,2"

		icons[src.suit] = "2,1"
		icons[src.mask] = "2,3"
		icons[src.headset] = "3,1"

		for(var/atom/W in icons)
			var/type = W.s_istate
			if (!type)
				type = W.icon_state
			src.overlays += image("icon" = 'mob.dmi', "icon_state" = "[type][src.lying ? "2" : null]"), "layer" = MOB_LAYER)
			W.screen_loc = icons[W]

	if (src.client)
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
	if (src.suit && istype(src.suit, /obj/item/weapon/clothing/suit/straight_jacket))
		//can't hold things if you're wearing a straitjacket!
		src.drop_item(slot_l_hand)
		src.drop_item(slot_r_hand)
	if ((src.mask && !(src.mask.see_face)) || (src.head && !(src.head.see_face))) // can't see the face
		if(src.id && src.id.registered)
			src.name = src.id.registered
		else
			src.name = "Unknown"
	else
		if (src.id && src.id.registered != src.rname)
			src.name = text("[] (as [])", src.rname, src.id.registered)
		else
			src.name = text("[]", src.rname)
	if(src.id)
		src.id.screen_loc = "1,1"
	if (src.l_store)
		src.l_store.screen_loc = "4,1"
	if (src.r_store)
		src.r_store.screen_loc = "5,1"
	if (src.r_hand)

		var/t1 = src.r_hand.s_istate
		if (!( t1 ))
			t1 = src.r_hand.icon_state
		src.overlays += image("icon" = 'r_items.dmi', "icon_state" = t1, "layer" = MOB_LAYER)



		src.r_hand.screen_loc = "1,2"
	if (src.l_hand)
		var/t1 = src.l_hand.s_istate
		if (!( t1 ))
			t1 = src.l_hand.icon_state
		src.overlays += image("icon" = 'l_items.dmi', "icon_state" = t1, "layer" = MOB_LAYER)



		src.l_hand.screen_loc = "3,2"
	if (src.back)
		if (istype(src.back, /obj/item/weapon/radio/electropack))
			if (!( src.lying ))
				src.overlays += image("icon" = 'mob.dmi', "icon_state" = "backe", "layer" = MOB_LAYER)
			else
				src.overlays += image("icon" = 'mob.dmi', "icon_state" = "backe2", "layer" = MOB_LAYER)
		else
			if (!( src.lying ))
				src.overlays += image("icon" = 'mob.dmi', "icon_state" = "back", "layer" = MOB_LAYER)
			else
				src.overlays += image("icon" = 'mob.dmi', "icon_state" = "back2", "layer" = MOB_LAYER)
		src.back.screen_loc = "3,3"
	if (src.handcuffed)
		src.pulling = null
		if (!( src.lying ))
			src.overlays += image("icon" = 'mob.dmi', "icon_state" = "handcuff1", "layer" = MOB_LAYER)
		else
			src.overlays += image("icon" = 'mob.dmi', "icon_state" = "handcuff2", "layer" = MOB_LAYER)
	if (src.client)
		src.client.screen -= src.contents
		src.client.screen += src.contents
	src.invisibility = 0
	for(var/obj/item/weapon/cloaking_device/S in src)
		if (S.active)
			src.invisibility = 2
			src.overlays += image("icon" = 'mob.dmi', "icon_state" = "shield", "layer" = MOB_LAYER)
			break
	for(var/mob/M in viewers(1, src))
		if ((M.client && M.machine == src))
			spawn( 0 )
				src.show_inv(M)
				return
		//Foreach goto(3088)
	src.last_b_state = src.stat

	return