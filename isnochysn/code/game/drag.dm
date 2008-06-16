/obj/equip_e/proc/process()

	return

/obj/equip_e/proc/done()

	return

/obj/equip_e/New()

	if (!( ticker ))
		//SN src = null
		del(src)
		return
	spawn( 100 )
		//SN src = null
		del(src)
		return
		return
	..()
	return

/obj/equip_e/monkey/process()

	if (src.item)
		src.item.add_fingerprint(src.source)
	if (!( src.item ))
		switch(src.place)
			if("head")
				if (!( src.target.wear_mask ))
					//SN src = null
					del(src)
					return
			if("l_hand")
				if (!( src.target.l_hand ))
					//SN src = null
					del(src)
					return
			if("r_hand")
				if (!( src.target.r_hand ))
					//SN src = null
					del(src)
					return
			if("back")
				if (!( src.target.back ))
					//SN src = null
					del(src)
					return
			if("handcuff")
				if (!( src.target.handcuffed ))
					//SN src = null
					del(src)
					return
			if("internal")
				if ((!( (istype(src.target.wear_mask, /obj/item/weapon/clothing/mask) && istype(src.target.back, /obj/item/weapon/tank) && !( src.target.internal )) ) && !( src.target.internal )))
					//SN src = null
					del(src)
					return

	if (src.item)
		for(var/mob/O in viewers(src.target, null))
			if ((O.client && !( O.blinded )))
				O.show_message(text("\red <B>[] is trying to put a [] on []</B>", src.source, src.item, src.target), 1)
			//Foreach goto(251)
	else
		var/message = null
		switch(src.place)
			if("l_hand")
				message = text("\red <B>[] is trying to take off a [] from []'s left hand!</B>", src.source, src.target.l_hand, src.target)
			if("r_hand")
				message = text("\red <B>[] is trying to take off a [] from []'s right hand!</B>", src.source, src.target.r_hand, src.target)
			if("back")
				message = text("\red <B>[] is trying to take off a [] from []'s back!</B>", src.source, src.target.back, src.target)
			if("handcuff")
				message = text("\red <B>[] is trying to unhandcuff []!</B>", src.source, src.target)
			if("internal")
				if (src.target.internal)
					message = text("\red <B>[] is trying to remove []'s internals</B>", src.source, src.target)
				else
					message = text("\red <B>[] is trying to set on []'s internals.</B>", src.source, src.target)
			else
		for(var/mob/M in viewers(src.target, null))
			M.show_message(message, 1)
			//Foreach goto(469)
	spawn( 30 )
		src.done()
		return
	return

/obj/equip_e/monkey/done()

	if ((!( src.source ) || !( src.target )))
		return
	if (src.source.loc != src.s_loc)
		return
	if (src.target.loc != src.t_loc)
		return
	if ((src.item && src.source.equipped() != src.item))
		return
	if ((src.source.restrained() || src.source.stat))
		return
	switch(src.place)
		if("mask")
			if (src.target.wear_mask)
				var/obj/item/weapon/W = src.target.wear_mask
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
					src.target.wear_mask = src.item
					src.item.loc = src.target
		if("l_hand")
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
		if("r_hand")
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
		if("back")
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
		if("handcuff")
			if (src.target.handcuffed)
				var/obj/item/weapon/W = src.target.handcuffed
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
					src.target.handcuffed = src.item
					src.item.loc = src.target
		if("internal")
			if (src.target.internal)
				src.target.internal.add_fingerprint(src.source)
				src.target.internal = null
			else
				if (src.target.internal)
					src.target.internal = null
				if (!( istype(src.target.wear_mask, /obj/item/weapon/clothing/mask) ))
					return
				else
					if (istype(src.target.back, /obj/item/weapon/tank))
						src.target.internal = src.target.back
						src.target.internal.add_fingerprint(src.source)
						for(var/mob/M in viewers(src.target, 1))
							if ((M.client && !( M.blinded )))
								M.show_message(text("[] is now running on internals.", src.target), 1)
							//Foreach goto(1097)
		else
	src.source.UpdateClothing()
	src.target.UpdateClothing()
	//SN src = null
	del(src)
	return
	return

/obj/equip_e/human/process()

	if (src.item)
		src.item.add_fingerprint(src.source)
	if (!( src.item ))
		switch(src.place)
			if("mask")
				if (!( src.target.wear_mask ))
					//SN src = null
					del(src)
					return
			if("headset")
				if (!( src.target.w_radio ))
					//SN src = null
					del(src)
					return
			if("l_hand")
				if (!( src.target.l_hand ))
					//SN src = null
					del(src)
					return
			if("r_hand")
				if (!( src.target.r_hand ))
					//SN src = null
					del(src)
					return
			if("suit")
				if (!( src.target.wear_suit ))
					//SN src = null
					del(src)
					return
			if("uniform")
				if (!( src.target.w_uniform ))
					//SN src = null
					del(src)
					return
			if("back")
				if (!( src.target.back ))
					//SN src = null
					del(src)
					return
			if("syringe")
				return
			if("pill")
				return
			if("handcuff")
				if (!( src.target.handcuffed ))
					//SN src = null
					del(src)
					return
			if("id")
				if ((!( src.target.wear_id ) || !( src.target.w_uniform )))
					//SN src = null
					del(src)
					return
			if("internal")
				if ((!( (istype(src.target.wear_mask, /obj/item/weapon/clothing/mask) && istype(src.target.back, /obj/item/weapon/tank) && !( src.target.internal )) ) && !( src.target.internal )))
					//SN src = null
					del(src)
					return

	var/list/L = list( "syringe", "pill" )
	if ((src.item && !( L.Find(src.place) )))
		for(var/mob/O in viewers(src.target, null))
			O.show_message(text("\red <B>[] is trying to put \a [] on []</B>", src.source, src.item, src.target), 1)
			//Foreach goto(401)
	else
		if (src.place == "syringe")
			for(var/mob/O in viewers(src.target, null))
				O.show_message(text("\red <B>[] is trying to inject []!</B>", src.source, src.target), 1)
				//Foreach goto(466)
		else
			if (src.place == "pill")
				for(var/mob/O in viewers(src.target, null))
					O.show_message(text("\red <B>[] is trying to force [] to swallow []!</B>", src.source, src.target, src.item), 1)
					//Foreach goto(527)
			else
				var/message = null
				switch(src.place)
					if("mask")
						message = text("\red <B>[] is trying to take off \a [] from []'s head!</B>", src.source, src.target.wear_mask, src.target)
					if("headset")
						message = text("\red <B>[] is trying to take off \a [] from []'s face!</B>", src.source, src.target.w_radio, src.target)
					if("l_hand")
						message = text("\red <B>[] is trying to take off \a [] from []'s left hand!</B>", src.source, src.target.l_hand, src.target)
					if("r_hand")
						message = text("\red <B>[] is trying to take off \a [] from []'s right hand!</B>", src.source, src.target.r_hand, src.target)
					if("gloves")
						message = text("\red <B>[] is trying to take off the [] from []'s hands!</B>", src.source, src.target.gloves, src.target)
					if("eyes")
						message = text("\red <B>[] is trying to take off the [] from []'s eyes!</B>", src.source, src.target.glasses, src.target)
					if("ears")
						message = text("\red <B>[] is trying to take off the [] from []'s ears!</B>", src.source, src.target.ears, src.target)
					if("head")
						message = text("\red <B>[] is trying to take off the [] from []'s head!</B>", src.source, src.target.head, src.target)
					if("shoes")
						message = text("\red <B>[] is trying to take off the [] from []'s feet!</B>", src.source, src.target.shoes, src.target)
					if("belt")
						message = text("\red <B>[] is trying to take off the [] from []'s belt!</B>", src.source, src.target.belt, src.target)
					if("suit")
						message = text("\red <B>[] is trying to take off \a [] from []'s body!</B>", src.source, src.target.wear_suit, src.target)
					if("back")
						message = text("\red <B>[] is trying to take off \a [] from []'s back!</B>", src.source, src.target.back, src.target)
					if("handcuff")
						message = text("\red <B>[] is trying to unhandcuff []!</B>", src.source, src.target)
					if("uniform")
						message = text("\red <B>[] is trying to take off \a [] from []'s body!</B>", src.source, src.target.w_uniform, src.target)
					if("pockets")
						message = text("\red <B>[] is trying to empty []'s pockets!!</B>", src.source, src.target)
					if("CPR")
						if (src.target.cpr_time >= world.time + 3)
							//SN src = null
							del(src)
							return
						message = text("\red <B>[] is trying perform CPR on []!</B>", src.source, src.target)
					if("id")
						message = text("\red <B>[] is trying to take off [] from []'s uniform!</B>", src.source, src.target.wear_id, src.target)
					if("internal")
						if (src.target.internal)
							message = text("\red <B>[] is trying to remove []'s internals</B>", src.source, src.target)
						else
							message = text("\red <B>[] is trying to set on []'s internals.</B>", src.source, src.target)
					else
				for(var/mob/M in viewers(src.target, null))
					M.show_message(message, 1)
					//Foreach goto(1069)
	spawn( 30 )
		src.done()
		return
	return

/obj/equip_e/human/done()

	if ((!( src.source ) || !( src.target )))
		return
	if (src.source.loc != src.s_loc)
		return
	if (src.target.loc != src.t_loc)
		return
	if ((src.item && src.source.equipped() != src.item))
		return
	if ((src.source.restrained() || src.source.stat))
		return
	switch(src.place)
		if("mask")
			if (src.target.wear_mask)
				var/obj/item/weapon/W = src.target.wear_mask
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
					src.target.wear_mask = src.item
					src.item.loc = src.target
		if("headset")
			if (src.target.w_radio)
				var/obj/item/weapon/W = src.target.w_radio
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
					src.target.w_radio = src.item
					src.item.loc = src.target
		if("gloves")
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
		if("eyes")
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
		if("belt")
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
				if ((istype(src.item, /obj) && src.item.flags & 128 && src.target.w_uniform))
					src.source.drop_item()
					src.loc = src.target
					src.item.layer = 20
					src.target.belt = src.item
					src.item.loc = src.target
		if("head")
			if (src.target.head)
				var/obj/item/weapon/W = src.target.head
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
					src.target.head = src.item
					src.item.loc = src.target
		if("ears")
			if (src.target.ears)
				var/obj/item/weapon/W = src.target.ears
				src.target.u_equip(W)
				if (src.target.client)
					src.target.client.screen -= W
				if (W)
					W.loc = src.target.loc
					W.dropped(src.target)
					W.layer = initial(W.layer)
				W.add_fingerprint(src.source)
			else
				if (istype(src.item, /obj/item/weapon/clothing/ears))
					src.source.drop_item()
					src.loc = src.target
					src.item.layer = 20
					src.target.ears = src.item
					src.item.loc = src.target
		if("shoes")
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
		if("l_hand")
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
		if("r_hand")
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
		if("uniform")
			if (src.target.w_uniform)
				var/obj/item/weapon/W = src.target.w_uniform
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
				W = src.target.wear_id
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
					src.target.w_uniform = src.item
					src.item.loc = src.target
		if("suit")
			if (src.target.wear_suit)
				var/obj/item/weapon/W = src.target.wear_suit
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
					src.target.wear_suit = src.item
					src.item.loc = src.target
		if("id")
			if (src.target.wear_id)
				var/obj/item/weapon/W = src.target.wear_id
				src.target.u_equip(W)
				if (src.target.client)
					src.target.client.screen -= W
				if (W)
					W.loc = src.target.loc
					W.dropped(src.target)
					W.layer = initial(W.layer)
				W.add_fingerprint(src.source)
			else
				if ((istype(src.item, /obj/item/weapon/card/id) && src.target.w_uniform))
					src.source.drop_item()
					src.loc = src.target
					src.item.layer = 20
					src.target.wear_id = src.item
					src.item.loc = src.target
		if("back")
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
		if("handcuff")
			if (src.target.handcuffed)
				var/obj/item/weapon/W = src.target.handcuffed
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
					src.target.handcuffed = src.item
					src.item.loc = src.target
		if("CPR")
			if (src.target.cpr_time >= world.time + 30)
				//SN src = null
				del(src)
				return
			if ((src.target.health >= -75.0 && src.target.health < 0))
				src.target.cpr_time = world.time
				if (src.target.health >= -40.0)
					var/suff = min(src.target.oxyloss, 5)
					src.target.oxyloss -= suff
					src.target.health = 100 - src.target.oxyloss - src.target.toxloss - src.target.fireloss - src.target.bruteloss
				src.target.chemicals.rejuv = max(src.target.chemicals.rejuv, 10)
				for(var/mob/O in viewers(src.source, null))
					O.show_message(text("\red [] performs CPR on []!", src.source, src.target), 1)
					//Foreach goto(3251)
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
			for(var/mob/O in viewers(src.source, null))
				O.show_message(text("\red [] injects [] with the syringe!", src.source, src.target), 1)
				//Foreach goto(3407)
			src.source << text("\red You inject [] units into []. The syringe contains [] units.", a, src.target, S.chem.volume())
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
			for(var/mob/O in viewers(src.source, null))
				O.show_message(text("\red [] forces [] to swallow \a []!", src.source, src.target, a), 1)
				//Foreach goto(3568)
		if("pockets")
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
		if("internal")
			if (src.target.internal)
				src.target.internal.add_fingerprint(src.source)
				src.target.internal = null
			else
				if (src.target.internal)
					src.target.internal = null
				if (!( istype(src.target.wear_mask, /obj/item/weapon/clothing/mask) ))
					return
				else
					if (istype(src.target.back, /obj/item/weapon/tank))
						src.target.internal = src.target.back
						for(var/mob/M in viewers(src.target, 1))
							M.show_message(text("[] is now running on internals.", src.target), 1)
							//Foreach goto(3913)
						src.target.internal.add_fingerprint(src.source)
		else
	src.source.UpdateClothing()
	src.target.UpdateClothing()
	//SN src = null
	del(src)
	return