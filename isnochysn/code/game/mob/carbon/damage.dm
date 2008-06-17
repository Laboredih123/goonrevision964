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
	src.take_damage(new damage(brute = brute_loss, burn = burn_loss))
	return

/mob/carbon/take_damage(datum/damage/dam)
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
	if(src.appearance == HUMAN)
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
	for(var/mob/O in viewers(M, null))
		O.see("\red <B>[M] has been attacked by the blob.</B>")
	var/datum/damage/dam = new /datum/damage(brute = rand(5,25))
	if(!istype(/mob/carbon/, M))
		M.take_damage(dam)
		return
	if ((M.helmet && M.helmet.brute_protect & 1) || (M.mask && M.mask.brute_protect & 1) && prob(5))
		M.think("\red Your helmet softened the blow.")
		dam.brute /= 2
	else if((M.suit && M.suit.brute_protect & 2) || (M.jumpsuit && M.jumpsuit.brute_protect & 2) && prob(20))
		M.think("\red Your armor softened the blow.")
		dam.brute /= 2

	if (prob(dam.brute + M.dam.brute/5)) //knock 'em out
		if(M.conscious())
			for(var/mob/O in oviewers(M))
				O.see("\red <B>[M] has been knocked unconscious!</B>")
		var/time = rand(10, 120)
		if (H.paralysis < time)
			H.paralysis = time
		else if (H.weakened < time)
			H.weakened = time
			H.stat = 1

	src.take_damage(dam)

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
		if (src.ears)
			src.ears.burn(fi_amount)
		if (src.headset)
			src.headset.burn(fi_amount)
		temp = null
		if (src.organs["head"])
			temp = src.organs["head"]
			if (istype(temp, /atom/organ))
				ok += temp.take_damage(0, 5)
	if (still_burning & 2)
		if (src.id)
			src.id.burn(fi_amount)
		temp = null
		if (src.organs["chest"])
			temp = src.organs["chest"]
			if (istype(temp, /atom/organ))
				ok += temp.take_damage(0, 5)
	if (still_burning & 4)
		temp = null
		if (src.organs["diaper"])
			temp = src.organs["diaper"]
			if (istype(temp, /atom/organ))
				ok += temp.take_damage(0, 5)
	if (still_burning & 8)
		temp = null
		if (src.organs["l_arm"])
			temp = src.organs["l_arm"]
			if (istype(temp, /atom/organ))
				ok += temp.take_damage(0, 5)
		temp = null
		if (src.organs["r_arm"])
			temp = src.organs["r_arm"]
			if (istype(temp, /atom/organ))
				ok += temp.take_damage(0, 5)
	if (still_burning & 32)
		temp = null
		if (src.organs["l_leg"])
			temp = src.organs["l_leg"]
			if (istype(temp, /atom/organ))
				ok += temp.take_damage(0, 5)
		temp = null
		if (src.organs["r_leg"])
			temp = src.organs["r_leg"]
			if (istype(temp, /atom/organ))
				ok += temp.take_damage(0, 5)
	if (still_burning & 64)
		temp = null
		if (src.organs["l_foot"])
			temp = src.organs["l_foot"]
			if (istype(temp, /atom/organ))
				ok += temp.take_damage(0, 5)
		temp = null
		if (src.organs["r_foot"])
			temp = src.organs["r_foot"]
			if (istype(temp, /atom/organ))
				ok += temp.take_damage(0, 5)
	if (still_burning & 16)
		temp = null
		if (src.organs["l_hand"])
			temp = src.organs["l_hand"]
			if (istype(temp, /atom/organ))
				ok += temp.take_damage(0, 5)
		temp = null
		if (src.organs["r_hand"])
			temp = src.organs["r_hand"]
			if (istype(temp, /atom/organ))
				ok += temp.take_damage(0, 5)
	if (ok)
		src.UpdateDamageIcon()
	else
		src.UpdateDamage()
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
		src.take_damage(new datum/damage(suffocation = layers))

/mob/carbon/handle_knockout()
	src.knockout = max(src.knockout - 1, 0)
	if(src.knockout > 0)
		src.canmove = 0
		src.lying = 1
		src.blinded = 1
		src.drop(slot_l_hand)
		src.drop(slot_r_hand)
	else
		src.canmove = 1
		src.lying = 1

/mob/carbon/handle_knockdown()
	src.knockdown = max(src.knockdown - 1, 0)
	if (src.knockdown > 0)
		src.canmove = 0
		src.lying = 1
	else
		src.canmove = 1
		src.lying = 0
