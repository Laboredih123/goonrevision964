/var/const
	SLOT_BACK = 1
	SLOT_MASK = 2
	SLOT_HANDCUFFS = 3
	SLOT_L_HAND = 4
	SLOT_R_HAND = 5
	SLOT_BELT = 6
	SLOT_ID = 7
	SLOT_GLASSES = 9
	SLOT_GLOVES = 10
	SLOT_HELMET = 11
	SLOT_SHOES = 12
	SLOT_SUIT = 13
	SLOT_JUMPSUIT = 14
	SLOT_L_STORE = 15
	SLOT_R_STORE = 16
	SLOT_HEADSET = 17
	SLOT_IN_BACKPACK = 18
	SLOT_INTERNAL = 19
	SLOT_IN_POCKETS = 20

/mob/carbon/u_equip(obj/item/weapon/W as obj)
	if (W == src.suit)
		src.suit = null
	else if (W == src.jumpsuit && !src.changingjumpsuit)
		for(var/x in list(SLOT_R_STORE, SLOT_L_STORE, SLOT_ID, SLOT_BELT))
			src.drop(x)
		src.jumpsuit = null
	else if (W == src.gloves)
		src.gloves = null
	else if (W == src.glasses)
		src.glasses = null
	else if (W == src.helmet)
		src.helmet = null
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
	src.update_clothing()
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
	src.update_clothing()

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
		if(W) //dropping can destroy grabs
			W.layer = initial(W.layer)
		src.update_clothing()

/mob/carbon/proc/reset_db_click()
	usr.next_move = usr.prev_move
	usr:nextDblClick = world.time

/mob/carbon/proc/db_click(text, t1)
	var/obj/item/weapon/W = src.equipped()
	var/emptyHand = (W == null)

	if (emptyHand)
		reset_db_click()

	if(text == "mask" && src.can_wear_mask)
		if (W && !( istype(W, /obj/item/weapon/clothing/mask) ))
			return 0
		if (src.mask)
			if (emptyHand)
				src.mask.interact(src)
			else
				src.u_equip(W)
				reset_db_click()
				src.mask.interact(src)
				src.mask = W
		else
			src.u_equip(W)
			src.mask = W
		src.update_clothing()
		return 1
	if(text == "back" && src.can_wear_back)
		if (src.back)
			if (emptyHand)
				src.back.interact(src)
			src.update_clothing()
			return 1
		if (!istype(W, /obj/item/weapon))
			return 0
		if (!( W.flags & 1 ))
			return 0
		src.u_equip(W)
		src.back = W
		src.update_clothing()
		return 1
	if(text == "headset" && src.can_wear_headset)
		if (W && !( istype(W, /obj/item/weapon/radio/headset) ))
			return 0
		if (src.headset)
			if (emptyHand)
				src.headset.interact(src)
			else
				src.u_equip(W)
				reset_db_click()
				src.headset.interact(src)
				src.headset = W
		else
			src.u_equip(W)
			src.headset = W
		src.update_clothing()
		return 1
	if(text == "suit" && src.can_wear_suit)
		if (W && !( istype(W, /obj/item/weapon/clothing/suit) ))
			return 0
		if (src.suit)
			if (emptyHand)
				src.suit.interact(src)
			else
				src.u_equip(W)
				reset_db_click()
				src.suit.interact(src)
				src.suit = W
		else
			src.u_equip(W)
			src.suit = W
		src.update_clothing()
		return 1
	if(text == "gloves" && src.can_wear_gloves)
		if (W && !( istype(W, /obj/item/weapon/clothing/gloves) ))
			return 0
		if (src.gloves)
			if (emptyHand)
				src.gloves.interact(src)
			else
				src.u_equip(W)
				reset_db_click()
				src.gloves.interact(src)
				src.gloves = W
		else
			src.u_equip(W)
			src.gloves = W
		src.update_clothing()
		return 1
	if(text == "shoes" && src.can_wear_shoes)
		if (W && !( istype(W, /obj/item/weapon/clothing/shoes) ))
			return 0
		if (src.shoes)
			if (emptyHand)
				src.shoes.interact(src)
			else
				src.u_equip(W)
				reset_db_click()
				src.shoes.interact(src)
				src.shoes = W
		else
			src.u_equip(W)
			src.shoes = W
		src.update_clothing()
		return 1
	if(text == "belt" && src.can_wear_belt)
		if (src.belt)
			if (emptyHand)
				src.belt.interact(src)
			else
				if (!W || !W.flags || !( W.flags & ONBELT ) || !( src.jumpsuit ))
					return 0
				src.u_equip(W)
				reset_db_click()
				src.belt.interact(src)
				src.belt = W
		else if (!W || !W.flags || !( W.flags & ONBELT ) || !( src.jumpsuit ))
			return 0
		else
			src.u_equip(W)
			src.belt = W
		src.update_clothing()
		return 1
	if(text == "glasses" && src.can_wear_glasses)
		if (W && !( istype(W, /obj/item/weapon/clothing/glasses) ))
			return 0
		if (src.glasses)
			if (emptyHand)
				src.glasses.interact(src)
			else
				src.u_equip(W)
				reset_db_click()
				src.glasses.interact(src)
				src.glasses = W
		else
			src.u_equip(W)
			src.glasses = W
		src.update_clothing()
		return 1
	if(text == "head" && src.can_wear_helmet)
		if (W && !( istype(W, /obj/item/weapon/clothing/head) ))
			return 0
		if (src.helmet)
			if (emptyHand)
				src.helmet.interact(src)
			else
				src.u_equip(W)
				reset_db_click()
				src.helmet.interact(src)
				src.helmet = W
		else
			src.u_equip(W)
			src.helmet = W
		src.update_clothing()
		return 1
	if(text == "jumpsuit" && src.can_wear_jumpsuit)
		if (W && !( istype(W, /obj/item/weapon/clothing/under) ))
			return 0
		if (src.jumpsuit)
			if (emptyHand)
				src.jumpsuit.interact(src)
			else
				src.u_equip(W)
				reset_db_click()
				src.changingjumpsuit = 1
				src.jumpsuit.interact(src)
				src.changingjumpsuit = 0
				src.jumpsuit = W
		else
			src.u_equip(W)
			src.jumpsuit = W
		src.update_clothing()
		return 1
	if(text == "id" && src.can_wear_id)
		if (W && !( istype(W, /obj/item/weapon/card/id) ))
			return 0
		if (!src.jumpsuit)
			return 0
		if (src.id)
			if (emptyHand)
				src.id.interact(src)
			else
				src.u_equip(W)
				reset_db_click()
				src.id.interact(src)
				src.id = W
		else
			src.u_equip(W)
			src.id = W
		src.update_clothing()
		return 1
	if(text == "storage1" && src.can_wear_l_store)
		if (src.l_store)
			if (emptyHand)
				src.l_store.interact(src)
			else
				if ((!( istype(W, /obj/item/weapon) ) || W.w_class >= 3 || !( src.jumpsuit )))
					return 0
				src.u_equip(W)
				reset_db_click()
				src.l_store.interact(src)
				src.l_store = W
		else if ((!( istype(W, /obj/item/weapon) ) || W.w_class >= 3 || !( src.jumpsuit )))
			return 0
		else
			src.u_equip(W)
			src.l_store = W
		src.update_clothing()
		return 1
	if(text == "storage2" && src.can_wear_r_store)
		if (src.r_store)
			if (emptyHand)
				src.r_store.interact(src)
			else
				if ((!( istype(W, /obj/item/weapon) ) || W.w_class >= 3 || !( src.jumpsuit )))
					return 0
				src.u_equip(W)
				reset_db_click()
				src.r_store.interact(src)
				src.r_store = W
		else if ((!( istype(W, /obj/item/weapon) ) || W.w_class >= 3 || !( src.jumpsuit )))
			return 0
		else
			src.u_equip(W)
			src.r_store = W
		src.update_clothing()
		return 1
	return 0

/mob/carbon/proc/update_clothing()
	src.update_clothing_functions()
	src.update_clothing_icons()

/mob/carbon/proc/update_clothing_functions()
	if (!( src.jumpsuit ))
		if(src.belt)
			src.drop(SLOT_BELT)
		if(src.id)
			src.drop(SLOT_ID)
		if(src.l_store)
			src.drop(SLOT_L_STORE)
		if(src.r_store)
			src.drop(SLOT_R_STORE)

	if(!src.can_use_hands())
		src.pulling = null
		src.drop(SLOT_L_HAND)
		src.drop(SLOT_R_HAND)

	if(src.mask && istype(src.mask, /obj/item/weapon/clothing/mask/gasmask/voice_changer))
		// if they have no identification, their voice is "Unknown", just like their body
		var/voice = "Unknown"
		if(src.id && src.id.registered && voice == "Unknown")
			voice = src.id.registered
		else if (istype(src.l_hand, /obj/item/weapon/card/id)  && voice == "Unknown")
			var/obj/item/weapon/card/id/C = src.l_hand
			if (C.registered)
				voice = C.registered
		else if (istype(src.r_hand, /obj/item/weapon/card/id)  && voice == "Unknown")
			var/obj/item/weapon/card/id/C = src.r_hand
			if (C.registered)
				voice = C.registered
		src.voice = voice
	else
		src.voice = src.body_name

	src.update_invisibility()
	src.update_vision()
	src.update_name()

/mob/carbon/proc/update_clothing_icons()
	src.overlays = null

	if (src.lying)
		src.overlays += src.body_lying
	else
		src.overlays += src.body_standing

	var/suffix = src.lying ? "2" : null

	if (src.jumpsuit && istype(src.jumpsuit, /obj/item/weapon/clothing/under))
		var/color = src.jumpsuit.color
		if (!color)
			color = src.icon_state
		src.overlays += image("icon" = 'uniforms.dmi', "icon_state" = "[color][suffix]", "layer" = MOB_LAYER)
		src.jumpsuit.screen_loc = "2,2"
	var/icons = list()
	icons[src.suit] = "2,1"
	icons[src.headset] = "3,1"
	icons[src.mask] = "2,3"

	icons[src.gloves] = "4,2"
	icons[src.shoes] = "5,2"
	icons[src.glasses] = "6,2"
	icons[src.helmet] = "7,2"

	var/iconsource = src.appearance == APPEARANCE_MONKEY ? 'monkey.dmi' : 'mob.dmi'
	for(var/obj/item/weapon/W in icons)
		var/w_type = W.s_istate
		if (!w_type)
			w_type = W.icon_state
		src.overlays += image("icon" = 'mob.dmi', "icon_state" = "[w_type][suffix]", "layer" = MOB_LAYER)
		W.screen_loc = (src.is_dead) ? null : icons[W]
	if (src.id)
		src.overlays += image("icon" = 'mob.dmi', "icon_state" = "id[suffix]", "layer" = MOB_LAYER)
		src.id.screen_loc = (src.is_dead) ? null : "1,1"
	if (src.l_hand)
		var/w_type = src.l_hand.s_istate
		if (!w_type)
			w_type = src.l_hand.icon_state
		src.overlays += image("icon" = 'items_in_hand.dmi', "dir" = EAST, "icon_state" = "[w_type]", "layer" = MOB_LAYER)
		src.l_hand.screen_loc = (src.is_dead) ? null : "3,2"
	if (src.r_hand)
		var/w_type = src.r_hand.s_istate
		if (!w_type)
			w_type = src.r_hand.icon_state
		src.overlays += image("icon" = 'items_in_hand.dmi', "dir" = WEST, "icon_state" = "[w_type]", "layer" = MOB_LAYER)
		src.r_hand.screen_loc = (src.is_dead) ? null : "1,2"
	if (src.belt)
		var/w_type = src.belt.s_istate
		if (!w_type)
			w_type = src.belt.icon_state
		src.overlays += image("icon" = 'belt.dmi', "icon_state" = "[w_type]", "layer" = MOB_LAYER)
		src.belt.screen_loc = (src.is_dead) ? null : "8,2"
	if (src.l_store)
		src.l_store.screen_loc = (src.is_dead) ? null : "4,1"
	if (src.r_store)
		src.r_store.screen_loc = (src.is_dead) ? null : "5,1"

	if (src.back)
		var/elect = ""
		if (istype(src.back, /obj/item/weapon/radio/electropack))
			elect = "e"
		src.overlays += image("icon" = iconsource, "icon_state" = "back[elect][suffix]", "layer" = MOB_LAYER)
		src.back.screen_loc = (src.is_dead) ? null : "3,3"

	if (src.handcuffs)
		src.overlays += image("icon" = iconsource, "icon_state" = "handcuff[suffix ? suffix : 1]", "layer" = MOB_LAYER)
	if (src.client)
		src.client.screen -= src.contents
		if (!src.is_dead)
			src.client.screen += src.contents

	for(var/mob/M in viewers(1, src))
		if ((M.client && M.machine == src))
			spawn( 0 )
				src.show_inv(M)
				return
	for(var/obj/item/weapon/cloaking_device/S in src)
		if (S.active)
			src.overlays += image("icon" = 'mob.dmi', "icon_state" = "shield", "layer" = MOB_LAYER)
	return

/mob/carbon/proc/update_name()
	if ((src.mask && !(src.mask.see_face)) || (src.helmet && !(src.helmet.see_face))) // can't see the face
		src.name = "Unknown"
		if(src.id && src.id.registered)
			src.name = src.id.registered
			return
		if (istype(src.l_hand, /obj/item/weapon/card/id))
			var/obj/item/weapon/card/id/C = src.l_hand
			if (C.registered)
				src.name = C.registered
				return
		else if (istype(src.r_hand, /obj/item/weapon/card/id))
			var/obj/item/weapon/card/id/C = src.r_hand
			if (C.registered)
				src.name = C.registered
				return
	else
		if (src.id && src.id.registered != src.body_name)
			src.name = "[src.body_name] (as [src.id.registered])"
		else if(!src.id && src.get_damage() > 500)
			src.name = "Unknown" //so damaged that they can't be identified
		else
			src.name = src.body_name

/mob/carbon/proc/update_invisibility()
	src.invisibility = 0
	for(var/obj/item/weapon/cloaking_device/S in src)
		if (S.active)
			src.invisibility = 2
			return

/mob/carbon/proc/CameraInvisible()
	for(var/obj/item/weapon/camera_jammer/S in src)
		if(S.on)
			return 1
	if(istype(src.id, /obj/item/weapon/card/id/syndicate))
		return 1
	return 0

/mob/carbon/proc/drop_item_v()
	if (src.is_active())
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
		if(src.hand == LEFT)
			src.l_hand = null
		else
			src.r_hand = null
	src.update_clothing()
	return

/mob/carbon/proc/swap_hand()
	src.hand = !( src.hand )
	if(src.hud && src.hud.hand)
		if (!( src.hand ))
			src.hud.hand.dir = NORTH
		else
			src.hud.hand.dir = SOUTH

/mob/carbon/equipped()

	if (src.hand)
		return src.l_hand
	else
		return src.r_hand
	return

/mob/carbon/MouseDrop(mob/carbon/M as mob)
	..()
	if(M != usr) return
	if(usr == src) return
	if(get_dist(usr,src) > 1) return
	if(!istype(M,/mob/carbon)) return
	if(LinkBlocked(usr.loc,src.loc)) return
	src.show_inv(usr)

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
			if(!src.helmet && src.can_wear_helmet)
				src.helmet = W
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
		if(SLOT_HEADSET)
			if(!src.headset && src.can_wear_headset)
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

	src.update_clothing()