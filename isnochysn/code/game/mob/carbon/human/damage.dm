/mob/carbon/human/take_damage(datum/damage/dam)
	var/atom/organ/O = src.choose_organ()
	if (istype(O, /atom/organ))
		O.take_damage(dam)
		src.update_damage()

/mob/carbon/human/heal_damage(datum/damage/dam)
	for(var/atom/organ/O in src.organs)
		dam = O.heal_damage(dam) //returns a smaller damage, or null if it's all used up
		if(!dam) //all done!
			break
	src.update_damage()

/mob/carbon/human/proc/update_damage()
	src.dam = new damage()
	for(var/atom/organ/O in src.organs)
		src.dam.add(x.dam)

	src.update_damage_icon()

/mob/carbon/human/proc/update_damage_icon()
	src.body_standing = list()
	src.body_lying = list()
	var/icon/dam_icon
	for(var/atom/organ/O in src.organs)
		body_standing += O.dam_icon_standing
		body_lying += O.dam_icon_lying

/mob/carbon/human/proc/choose_organ()
	return pick(src.organs)