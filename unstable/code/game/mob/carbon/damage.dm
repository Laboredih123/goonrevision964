/mob/carbon/ex_act(severity)

	flick("flash", src.flash)
	var/brute_loss = 0
	var/burn_loss = 0
	var/ear_loss = 0
	switch(severity)
		if(1)
			brute_loss = 100
			burn_loss = 100
			ear_loss = 50
		if(2)
			brute_loss = 60
			burn_loss = 60
			ear_loss = 30
			if (prob(50))
				src.paralysis += 30
		if(3)
			brute_loss = 30
			ear_loss = 15
			if (prob(50))
				src.paralysis += 10
	src.take_damage(brute = brute_loss, burn = burn_loss)
	return

/mob/carbon/take_damage(brute, burn, suffocation, toxin, electric)
	var/datum/damage/dam = new(brute, burn, suffocation, toxin, electric)
	var/atom/organ/O = src.choose_organ()
	if (istype(O, /atom/organ))
		O.take_damage(dam)
		src.update_damage()

/mob/carbon/heal_damage(datum/damage/dam)
	for(var/atom/organ/O in src.organs)
		dam = O.heal_damage(dam) //returns a smaller damage, or null if it's all used up
		if(!dam) //all done!
			break
	src.update_damage()

/mob/carbon/proc/update_damage()
	src.dam = new damage()
	for(var/atom/organ/O in src.organs)
		src.dam.add(x.dam)
	src.update_damage_icon()

/mob/carbon/proc/update_damage_icon()
	if(src.appearance == APPEARANCE_HUMAN)
		src.body_standing = list()
		src.body_lying = list()
		var/icon/dam_icon
		for(var/atom/organ/O in src.organs)
			body_standing += O.dam_icon_standing
			body_lying += O.dam_icon_lying
	else
		return ..()

/mob/carbon/proc/choose_organ()
	return pick(src.organs)

/mob/carbon/blob_act()
	src.showviewers("\red <B>[src] has been attacked by the blob.</B>")
	M.take_damage(brute = rand(5, 25))

/mob/carbon/death()
	if(src.healths)
		src.healths.icon_state = "dead"
	return ..()

/mob/carbon/burn(fi_amount)

	var/ok = 0
	var/atom/organ/temp
	if (src.r_hand)
		src.r_hand.burn(fi_amount)
	if (src.l_hand)
		src.l_hand.burn(fi_amount)
	if (src.back)
		src.back.burn(fi_amount)
	if (src.belt)
		src.belt.burn(fi_amount)
	var/still_burning = 127
	if (src.suit)
		if (src.suit.burn(fi_amount))
			still_burning &=  ~src.suit.fire_protect
	if (still_burning & 46)
		if (src.jumpsuit)
			if (src.jumpsuit.burn(fi_amount))
				still_burning &=  ~src.jumpsuit.fire_protect
	if (still_burning & 16)
		if (src.gloves)
			if (src.gloves.burn(fi_amount))
				still_burning &=  ~src.gloves.fire_protect
	if (still_burning & 64)
		if (src.shoes)
			if (src.shoes.burn(fi_amount))
				still_burning &=  ~src.shoes.fire_protect
	if (still_burning & 1)
		if (src.head)
			if (src.head.burn(fi_amount))
				still_burning &=  ~src.head.fire_protect
	if (still_burning & 1)
		if (src.mask)
			if (src.mask.burn(fi_amount))
				still_burning &=  ~src.mask.fire_protect

	if (still_burning)
		if ((src.fire && src.stat != 2))
			flick("fire1", src.fire)
	if (still_burning & 1)
		if (src.glasses)
			src.glasses.burn(fi_amount)
		if (src.headset)
			src.headset.burn(fi_amount)
		src.take_damage(burn = 5)
	if (still_burning & 2)
		if (src.id)
			src.id.burn(fi_amount)
		src.take_damage(burn = 5)
	if (still_burning & 4)
		src.take_damage(burn = 5)
	if (still_burning & 8)
		src.take_damage(burn = 10)
	if (still_burning & 32)
		src.take_damage(burn = 10)
	if (still_burning & 64)
		src.take_damage(burn = 10)
	if (still_burning & 16)
		src.take_damage(burn = 10)
	return

/mob/carbon/check_decompression()
	if (istype(src.loc, /turf/space) && !locate(/obj/move, src.loc))
		var/layers = 20
		if (((istype(src.head, /obj/item/weapon/clothing/head) && src.head.flags & 4) || (istype(src.mask, /obj/item/weapon/clothing/mask) && (!( src.mask.flags & 4 ) && src.mask.flags & 8))))
			layers -= 5
		if (istype(src.jumpsuit, /obj/item/weapon/clothing/under))
			layers -= 5
		if ((istype(src.suit, /obj/item/weapon/clothing/suit) && src.suit.flags & 8))
			layers -= 10
		src.take_damage(suffocation = layers)

/mob/carbon/handle_knockout()
	src.knockout = max(src.knockout - 1, 0)
	if(src.knockout > 0)
		src.canmove = 0
		src.lying = 1
		src.blinded = 1
		src.drop(SLOT_L_HAND)
		src.drop(SLOT_R_HAND)
	else
		src.canmove = 1
		src.lying = 1

/mob/carbon/knockout_until(time)
	src.knockout = max(time, src.knockout)

/mob/carbon/handle_knockdown()
	src.knockdown = max(src.knockdown - 1, 0)
	if (src.knockdown > 0)
		src.canmove = 0
		src.lying = 1
	else
		src.canmove = 1
		src.lying = 0

/mob/carbon/knockdown_until(time)
	src.knockdown = max(time, src.knockdown)

/mob/carbon/las_act(flag, A as obj) // get hit by a projectile - las = laser

	for(var/obj/item/weapon/cloaking_device/S in src)
		if (S.active)
			S.active = 0
			S.icon_state = "shield0"
	if (locate(/obj/item/weapon/grab, src))
		var/mob/safe = null
		if (istype(src.l_hand, /obj/item/weapon/grab))
			var/obj/item/weapon/grab/G = src.l_hand
			if ((G.state == 3 && get_dir(src, A) == src.dir))
				safe = G.affecting
		if (istype(src.r_hand, /obj/item/weapon/grab))
			var/obj/item/weapon.grab/G = src.r_hand
			if ((G.state == 3 && get_dir(src, A) == src.dir))
				safe = G.affecting
		if (safe)
			return safe.las_act(flag, A)
	if (flag == "bullet")
		var/d = 51
		if (istype(src.suit, /obj/item/weapon/clothing/suit/armor))
			if (prob(70))
				src.think("\red Your armor absorbs the hit!")
				return
			else if (prob(40))
				src.think("\red Your armor only softens the hit!")
				if (prob(20))
					d = d / 2
				d = d / 4
		else if (istype(src.suit, /obj/item/weapon/clothing/suit/swat_suit))
			if (prob(90))
				src.think("\red Your armor absorbs the blow!")
				return
			else if (prob(90))
				src.think("\red Your armor only softens the blow!")
				if (prob(60))
					d = d / 2
				d = d / 5
		src.take_damage(brute = d)
		if (prob(50))
			src.knockdown_until(5)
		return
	else if (flag) //taser
		if (istype(src.suit, /obj/item/weapon/clothing/suit/armor))
			if (prob(5))
				src.think("\red Your armor absorbs the hit!")
				return
		else if (istype(src.suit, /obj/item/weapon/clothing/suit/swat_suit))
			if (prob(70))
				src.think("\red Your armor absorbs the hit!")
				return
			if (prob(75))
				src.knockout_until(10)
			else
				src.knockdown_until(10)
	else //laser
		var/d = 20
		if (istype(src.suit, /obj/item/weapon/clothing/suit/armor))
			if (prob(40))
				src.think("\red Your armor absorbs the hit!")
				return
			else if (prob(40))
				src.think("\red Your armor only softens the hit!")
				if (prob(20))
					d = d / 2
				d = d / 2
		else if (istype(src.suit, /obj/item/weapon/clothing/suit/swat_suit))
			if (prob(70))
				src.think("\red Your armor absorbs the blow!")
				return
			else if (prob(90))
				src.think("\red Your armor only softens the blow!")
				if (prob(60))
					d = d / 2
				d = d / 2
		src.take_damage(brute = d)
		if (prob(25))
			src.knockdown_until(1)
	return