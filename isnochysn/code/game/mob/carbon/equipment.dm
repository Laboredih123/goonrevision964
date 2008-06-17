/mob/carbon/u_equip(obj/item/weapon/W as obj)
	if (W == src.suit)
		src.suit = null
	else if (W == src.jumpsuit)
		for(var/item/weapon/x in list(src.r_store, src.l_store, src.id, src.belt))
			if (W)
				u_equip(W)
				if (src.client)
					src.client.screen -= W
				if (W)
					W.loc = src.loc
					W.dropped(src)
					W.layer = initial(W.layer)
		else if (W == src.gloves)
			src.gloves = null
		else if (W == src.glasses)
			src.glasses = null
		else if (W == src.head)
			src.head = null
		else if (W == src.ears)
			src.ears = null
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
		if(slot_ears)
			W = src.ears
			src.ears = null
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
		if("ears" && src.can_wear_ears)
			if (src.ears)
				if (emptyHand)
					src.ears.DblClick()
				return
			if (!( istype(W, /obj/item/weapon/clothing/ears) ))
				return
			src.u_equip(W)
			src.ears = W
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
	src.update_vision


/mob/human/proc/update_clothing_icons()