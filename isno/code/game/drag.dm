/obj/equip_e/New()
	spawn( 100 )
		del(src)
	..()

/obj/equip_e/proc/process()
	var/x = text2num(src.place)
	if(x)			src.place = x
	if(src.item)	src.item.add_fingerprint(src.source)
	else
		switch(src.place)
			if(SLOT_IN_POCKETS)		if(!src.target.jumpsuit)						del(src)
			if(SLOT_MASK)			if(!src.target.mask)							del(src)
			if(SLOT_HEADSET)		if(!src.target.headset)							del(src)
			if(SLOT_L_HAND)			if(!src.target.l_hand)							del(src)
			if(SLOT_R_HAND)			if(!src.target.r_hand)							del(src)
			if(SLOT_GLOVES)			if(!src.target.gloves)							del(src)
			if(SLOT_GLASSES)		if(!src.target.glasses)							del(src)
			if(SLOT_HELMET)			if(!src.target.helmet)							del(src)
			if(SLOT_SHOES)			if(!src.target.shoes)							del(src)
			if(SLOT_BELT)			if(!src.target.belt)							del(src)
			if(SLOT_SUIT)			if(!src.target.suit)							del(src)
			if(SLOT_BACK)			if(!src.target.back)							del(src)
			if(SLOT_SUIT)			if(!src.target.suit)							del(src)
			if(SLOT_JUMPSUIT)		if(!src.target.jumpsuit)						del(src)
			if(SLOT_BACK)			if(!src.target.back)							del(src)
			if(SLOT_HANDCUFFS)		if(!src.target.handcuffs)						del(src)
			if(SLOT_ID)				if(!src.target.id || !src.target.jumpsuit)		del(src)
			if("syringe")			return
			if("pill")				return
			if(SLOT_INTERNAL)
				if (!(istype(src.target.mask, /obj/item/weapon/clothing/mask) && istype(src.target.back, /obj/item/weapon/tank)) && !src.target.internal)
					del(src)
					return

	var/list/L = list( "syringe", "pill")
	if(src.item && !(src.place in L))	src.target.show_viewers(text("\red <B>[] is trying to put \a [] on []</B>", src.source, src.item, src.target))
	else if(src.place == "syringe")		src.target.show_viewers(text("\red <B>[] is trying to inject []!</B>", src.source, src.target))
	else if(src.place == "pill")		src.target.show_viewers(text("\red <B>[] is trying to force [] to swallow []!</B>", src.source, src.target, src.item))
	else
		var/message = null
		switch(src.place)
			if(SLOT_MASK)		message = text("\red <B>[] is trying to take off \a [] from []'s head!</B>", src.source, src.target.mask, src.target)
			if(SLOT_HEADSET)	message = text("\red <B>[] is trying to take off \a [] from []'s face!</B>", src.source, src.target.headset, src.target)
			if(SLOT_L_HAND)		message = text("\red <B>[] is trying to take off \a [] from []'s left hand!</B>", src.source, src.target.l_hand, src.target)
			if(SLOT_R_HAND)		message = text("\red <B>[] is trying to take off \a [] from []'s right hand!</B>", src.source, src.target.r_hand, src.target)
			if(SLOT_GLOVES)		message = text("\red <B>[] is trying to take off the [] from []'s hands!</B>", src.source, src.target.gloves, src.target)
			if(SLOT_GLASSES)	message = text("\red <B>[] is trying to take off the [] from []'s eyes!</B>", src.source, src.target.glasses, src.target)
			if(SLOT_HELMET)		message = text("\red <B>[] is trying to take off the [] from []'s head!</B>", src.source, src.target.helmet, src.target)
			if(SLOT_SHOES)		message = text("\red <B>[] is trying to take off the [] from []'s feet!</B>", src.source, src.target.shoes, src.target)
			if(SLOT_BELT)		message = text("\red <B>[] is trying to take off the [] from []'s belt!</B>", src.source, src.target.belt, src.target)
			if(SLOT_SUIT)		message = text("\red <B>[] is trying to take off \a [] from []'s body!</B>", src.source, src.target.suit, src.target)
			if(SLOT_BACK)		message = text("\red <B>[] is trying to take off \a [] from []'s back!</B>", src.source, src.target.back, src.target)
			if(SLOT_HANDCUFFS)	message = text("\red <B>[] is trying to unhandcuff []!</B>", src.source, src.target)
			if(SLOT_JUMPSUIT)	message = text("\red <B>[] is trying to take off \a [] from []'s body!</B>", src.source, src.target.jumpsuit, src.target)
			if(SLOT_IN_POCKETS)	message = text("\red <B>[] is trying to empty []'s pockets!!</B>", src.source, src.target)
			if(SLOT_ID)			message = text("\red <B>[] is trying to take off [] from []'s uniform!</B>", src.source, src.target.id, src.target)
			if("CPR")
				if (src.target.cpr_time >= world.time + 3)
					del(src)
					return
				message = text("\red <B>[] is trying perform CPR on []!</B>", src.source, src.target)
			if(SLOT_INTERNAL)
				if(src.target.internal)
					message = text("\red <B>[] is trying to remove []'s internals</B>", src.source, src.target)
				else
					message = text("\red <B>[] is trying to set on []'s internals.</B>", src.source, src.target)
			else
		src.target.show_viewers(message)
	spawn(30)
		src.done()
		return
	return

/obj/equip_e/proc/done()
	if(!src.source || !src.target)						return
	if(src.source.loc != src.s_loc)						return
	if(src.target.loc != src.t_loc)						return
	if(LinkBlocked(src.s_loc,src.t_loc))				return
	if(src.item && src.source.equipped() != src.item)	return
	if(!src.source.can_use_hands())						return
	switch(src.place)
		if(SLOT_MASK)
			if (src.target.mask)
				var/obj/item/weapon/W = src.target.mask
				src.target.u_equip(W)
				if (src.target.client)
					src.target.client.screen -= W
				if (W)
					W.loc = src.target.loc
					W.dropped(src.target)
					W.layer = initial(W.layer)
				W.add_fingerprint(src.source)
			else
				if (istype(src.item, /obj/item/weapon/clothing/mask))
					src.source.drop_item()
					src.loc = src.target
					src.item.layer = 20
					src.target.mask = src.item
					src.item.loc = src.target
		if(SLOT_HEADSET)
			if (src.target.headset)
				var/obj/item/weapon/W = src.target.headset
				src.target.u_equip(W)
				if (src.target.client)
					src.target.client.screen -= W
				if (W)
					W.loc = src.target.loc
					W.dropped(src.target)
					W.layer = initial(W.layer)
			else
				if (istype(src.item, /obj/item/weapon/radio/headset))
					src.source.drop_item()
					src.loc = src.target
					src.item.layer = 20
					src.target.headset = src.item
					src.item.loc = src.target
		if(SLOT_GLOVES)
			if (src.target.gloves)
				var/obj/item/weapon/W = src.target.gloves
				src.target.u_equip(W)
				if (src.target.client)
					src.target.client.screen -= W
				if (W)
					W.loc = src.target.loc
					W.dropped(src.target)
					W.layer = initial(W.layer)
				W.add_fingerprint(src.source)
			else
				if (istype(src.item, /obj/item/weapon/clothing/gloves))
					src.source.drop_item()
					src.loc = src.target
					src.item.layer = 20
					src.target.gloves = src.item
					src.item.loc = src.target
		if(SLOT_GLASSES)
			if (src.target.glasses)
				var/obj/item/weapon/W = src.target.glasses
				src.target.u_equip(W)
				if (src.target.client)
					src.target.client.screen -= W
				if (W)
					W.loc = src.target.loc
					W.dropped(src.target)
					W.layer = initial(W.layer)
				W.add_fingerprint(src.source)
			else
				if (istype(src.item, /obj/item/weapon/clothing/glasses))
					src.source.drop_item()
					src.loc = src.target
					src.item.layer = 20
					src.target.glasses = src.item
					src.item.loc = src.target
		if(SLOT_BELT)
			if (src.target.belt)
				var/obj/item/weapon/W = src.target.belt
				src.target.u_equip(W)
				if (src.target.client)
					src.target.client.screen -= W
				if (W)
					W.loc = src.target.loc
					W.dropped(src.target)
					W.layer = initial(W.layer)
				W.add_fingerprint(src.source)
			else
				if ((istype(src.item, /obj) && src.item.flags & 128 && src.target.jumpsuit))
					src.source.drop_item()
					src.loc = src.target
					src.item.layer = 20
					src.target.belt = src.item
					src.item.loc = src.target
		if(SLOT_HELMET)
			if (src.target.helmet)
				var/obj/item/weapon/W = src.target.helmet
				src.target.u_equip(W)
				if (src.target.client)
					src.target.client.screen -= W
				if (W)
					W.loc = src.target.loc
					W.dropped(src.target)
					W.layer = initial(W.layer)
				W.add_fingerprint(src.source)
			else
				if (istype(src.item, /obj/item/weapon/clothing/head))
					src.source.drop_item()
					src.loc = src.target
					src.item.layer = 20
					src.target.helmet = src.item
					src.item.loc = src.target
		if(SLOT_SHOES)
			if (src.target.shoes)
				var/obj/item/weapon/W = src.target.shoes
				src.target.u_equip(W)
				if (src.target.client)
					src.target.client.screen -= W
				if (W)
					W.loc = src.target.loc
					W.dropped(src.target)
					W.layer = initial(W.layer)
				W.add_fingerprint(src.source)
			else
				if (istype(src.item, /obj/item/weapon/clothing/shoes))
					src.source.drop_item()
					src.loc = src.target
					src.item.layer = 20
					src.target.shoes = src.item
					src.item.loc = src.target
		if(SLOT_L_HAND)
			if (istype(src.target, /obj/item/weapon/clothing/suit/straight_jacket))
				//SN src = null
				del(src)
				return
			if (src.target.l_hand)
				var/obj/item/weapon/W = src.target.l_hand
				src.target.u_equip(W)
				if (src.target.client)
					src.target.client.screen -= W
				if (W)
					W.loc = src.target.loc
					W.dropped(src.target)
					W.layer = initial(W.layer)
				W.add_fingerprint(src.source)
			else
				if (istype(src.item, /obj/item/weapon))
					src.source.drop_item()
					src.loc = src.target
					src.item.layer = 20
					src.target.l_hand = src.item
					src.item.loc = src.target
					src.item.add_fingerprint(src.target)
		if(SLOT_R_HAND)
			if (istype(src.target, /obj/item/weapon/clothing/suit/straight_jacket))
				//SN src = null
				del(src)
				return
			if (src.target.r_hand)
				var/obj/item/weapon/W = src.target.r_hand
				src.target.u_equip(W)
				if (src.target.client)
					src.target.client.screen -= W
				if (W)
					W.loc = src.target.loc
					W.dropped(src.target)
					W.layer = initial(W.layer)
				W.add_fingerprint(src.source)
			else
				if (istype(src.item, /obj/item/weapon))
					src.source.drop_item()
					src.loc = src.target
					src.item.layer = 20
					src.target.r_hand = src.item
					src.item.loc = src.target
					src.item.add_fingerprint(src.target)
		if(SLOT_JUMPSUIT)
			if (src.target.jumpsuit)
				var/obj/item/weapon/W = src.target.jumpsuit
				src.target.u_equip(W)
				if (src.target.client)
					src.target.client.screen -= W
				if (W)
					W.loc = src.target.loc
					W.dropped(src.target)
					W.layer = initial(W.layer)
				W.add_fingerprint(src.source)
				W = src.target.l_store
				if (W)
					src.target.u_equip(W)
					if (src.target.client)
						src.target.client.screen -= W
					if (W)
						W.loc = src.target.loc
						W.dropped(src.target)
						W.layer = initial(W.layer)
				W = src.target.r_store
				if (W)
					src.target.u_equip(W)
					if (src.target.client)
						src.target.client.screen -= W
					if (W)
						W.loc = src.target.loc
						W.dropped(src.target)
						W.layer = initial(W.layer)
				W = src.target.id
				if (W)
					src.target.u_equip(W)
					if (src.target.client)
						src.target.client.screen -= W
					if (W)
						W.loc = src.target.loc
						W.dropped(src.target)
						W.layer = initial(W.layer)
			else
				if (istype(src.item, /obj/item/weapon/clothing/under))
					src.source.drop_item()
					src.loc = src.target
					src.item.layer = 20
					src.target.jumpsuit = src.item
					src.item.loc = src.target
		if(SLOT_SUIT)
			if (src.target.suit)
				var/obj/item/weapon/W = src.target.suit
				src.target.u_equip(W)
				if (src.target.client)
					src.target.client.screen -= W
				if (W)
					W.loc = src.target.loc
					W.dropped(src.target)
					W.layer = initial(W.layer)
				W.add_fingerprint(src.source)
			else
				if (istype(src.item, /obj/item/weapon/clothing/suit))
					src.source.drop_item()
					src.loc = src.target
					src.item.layer = 20
					src.target.suit = src.item
					src.item.loc = src.target
		if(SLOT_ID)
			if (src.target.id)
				var/obj/item/weapon/W = src.target.id
				src.target.u_equip(W)
				if (src.target.client)
					src.target.client.screen -= W
				if (W)
					W.loc = src.target.loc
					W.dropped(src.target)
					W.layer = initial(W.layer)
				W.add_fingerprint(src.source)
			else
				if ((istype(src.item, /obj/item/weapon/card/id) && src.target.jumpsuit))
					src.source.drop_item()
					src.loc = src.target
					src.item.layer = 20
					src.target.id = src.item
					src.item.loc = src.target
		if(SLOT_BACK)
			if (src.target.back)
				var/obj/item/weapon/W = src.target.back
				src.target.u_equip(W)
				if (src.target.client)
					src.target.client.screen -= W
				if (W)
					W.loc = src.target.loc
					W.dropped(src.target)
					W.layer = initial(W.layer)
				W.add_fingerprint(src.source)
			else
				if ((istype(src.item, /obj/item/weapon) && src.item.flags & 1))
					src.source.drop_item()
					src.loc = src.target
					src.item.layer = 20
					src.target.back = src.item
					src.item.loc = src.target
		if(SLOT_HANDCUFFS)
			if (src.target.handcuffs)
				var/obj/item/weapon/W = src.target.handcuffs
				src.target.u_equip(W)
				if (src.target.client)
					src.target.client.screen -= W
				if (W)
					W.loc = src.target.loc
					W.dropped(src.target)
					W.layer = initial(W.layer)
				W.add_fingerprint(src.source)
			else
				if (istype(src.item, /obj/item/weapon/handcuffs))
					src.source.drop_item()
					src.target.handcuffs = src.item
					src.item.loc = src.target
		if("CPR")
			if (src.target.cpr_time >= world.time + 30)
				//SN src = null
				del(src)
				return
			if ((src.target.get_damage() >= src.target.unconsciousness_threshold && src.target.get_damage() < (src.target.death_threshold - 25)))
				src.target.cpr_time = world.time
				if (src.target.get_damage() >= -40.0)
					src.target.heal_damage(suff = 5)
				src.target.rejuv = max(src.target.rejuv, 10)
				src.source.show_viewers(text("\red [] performs CPR on []!", src.source, src.target))
				src.source << "\red Repeat every 7 seconds AT LEAST."
		if("syringe")
			var/obj/item/weapon/syringe/S = src.item
			src.item.add_fingerprint(src.source)
			if (!( istype(S, /obj/item/weapon/syringe) ))
				//SN src = null
				del(src)
				return
			if (S.s_time >= world.time + 30)
				//SN src = null
				del(src)
				return
			S.s_time = world.time
			var/a = S.inject(src.target)
			src.source.show_viewers(text("\red [] injects [] with the syringe!", src.source, src.target))
			src.source << text("\red You inject [] units into []. The syringe contains [] units.", a, src.target, round(S.chem.volume(), 0.1))
		if("pill")
			var/obj/item/weapon/m_pill/S = src.item
			if (!( istype(S, /obj/item/weapon/m_pill) ))
				//SN src = null
				del(src)
				return
			if (S.s_time >= world.time + 30)
				//SN src = null
				del(src)
				return
			S.s_time = world.time
			var/a = S.name
			S.ingest(src.target)
			src.target.show_viewers(text("\red [] forces [] to swallow \a []!", src.source, src.target, a))
				//Foreach goto(3568)
		if(SLOT_IN_POCKETS)
			if (src.target.l_store)
				var/obj/item/weapon/W = src.target.l_store
				src.target.u_equip(W)
				if (src.target.client)
					src.target.client.screen -= W
				if (W)
					W.loc = src.target.loc
					W.dropped(src.target)
					W.layer = initial(W.layer)
				W.add_fingerprint(src.source)
			if (src.target.r_store)
				var/obj/item/weapon/W = src.target.r_store
				src.target.u_equip(W)
				if (src.target.client)
					src.target.client.screen -= W
				if (W)
					W.loc = src.target.loc
					W.dropped(src.target)
					W.layer = initial(W.layer)
				W.add_fingerprint(src.source)
		if(SLOT_INTERNAL)
			if (src.target.internal)
				src.target.internal.add_fingerprint(src.source)
				src.target.internal = null
				src.target.show_viewers(text("[] is no longer running on internals.", src.target))
			else if (!src.target.mask || !(src.target.mask.flags & MASKINTERNALS))
				return
			else if (istype(src.target.back, /obj/item/weapon/tank))
				src.target.internal = src.target.back
				src.target.show_viewers(text("[] is now running on internals.", src.target))
				src.target.internal.add_fingerprint(src.source)
	src.source.update_clothing()
	src.target.update_clothing()
	del(src)
	return
