/mob/carbon/proc/show_inv(mob/user as mob)

	user.machine = src
	var/dat = "<B><FONT size=3>[src.name]</FONT></B><br>"
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
		list(src.can_wear_id, "ID", SLOT_ID, src.id),
		list(src.can_wear_shoes, "Shoes", SLOT_SHOES, src.shoes),
		list(src.can_wear_headset, "Headset", SLOT_HEADSET, src.headset),
		list(src.can_wear_back, "Back", SLOT_BACK, src.back)
	)
	for(var/x in L)
		var/can_wear = x[1]
		if(can_wear)
			var/desc = x[2]
			var/slot = x[3]
			var/contents = x[4] ? x[4] : "Nothing"
			dat += "<b>[desc]</b>: <a href='?src=\ref[src];item=[slot]'>[contents]</a><br>"
	dat += "<br><a href='?src=\ref[src];item=[SLOT_HANDCUFFS]'>[src.handcuffs ? "" : "Not "]Handcuffed</A><br>"
	if(src.can_wear_jumpsuit)
		dat += "<a href='?src=\ref[src];item=[SLOT_IN_POCKETS]'>Empty Pockets</A><br>"
	dat += "<a href='?src=\ref[user];mach_close=mob[html_encode(src.spawn_name)]'>Close</A>"
	user << browse(dat, "window=mob[html_encode(src.spawn_name)];size=300x600")
	return

/mob/carbon/Topic(href, href_list)
	..()
	if (href_list["item"] && usr.can_use_hands() && get_dist(src, usr) <= 1)
		var/obj/equip_e/O = new()
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