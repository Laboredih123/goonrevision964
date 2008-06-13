/mob/carbon/human/take_damage(damage)
	var/atom/organ/O = src.choose_organ()
	if (istype(O, /atom/organ))
		O.take_damage(damage)
		src.update_damage()

/mob/carbon/human/heal_damage(damage)
	for(var/atom/organ/O in src.organs)
		damage = O.heal_damage(damage) //returns a smaller damage, or null if it's all used up
		if(!damage) //all done!
			break
	src.update_damage()

/mob/carbon/human/proc/update_damage()
	src.damage = new damage()
	for(var/atom/organ/O in src.organs)
		src.damage.add(x.damage)

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

/atom/organ/proc/take_damage(dam)
	src.damage.add(dam)
	src.update_damage_icon()

/atom/organ/proc/heal_damage(dam)
	var/damage = src.damage.subtract(dam)
	src.update_damage_icon()
	if(damage.brute > 0 || damage.burn > 0)
		return damage
	else
		return null

/atom/organ/proc/d_i_text()
	var/tburn = 0
	var/tbrute = 0

	if(src.damage.burn == 0)
		tburn = 0
	else if (src.damage.burn < 20)
		tburn = 1
	else if (src.damage.burn < 40)
		tburn = 2
	else
		tburn = 3

	if (src.damage.brute == 0)
		tbrute = 0
	else if (src.damage.brute < 20)
		tbrute = 1
	else if (src.damage.brute < 40)
		tbrute = 2
	else
		tbrute = 3

	return "[tbrute][tburn]"

/atom/organ/proc/update_icon()
	var/new_icon_state = dam_icon_text()
	if (new_icon_state != src.dam_icon_state) //it's changed!
		src.dam_icon_state = n_is

		src.dam_icon_standing = new /icon('dam_human.dmi', src.dam_icon_state) // the damage icon for whole human
		src.dam_icon_standing.Blend(new /icon('dam_mask.dmi', O.r_name), ICON_MULTIPLY) // mask with this organ's pixels

		src.dam_icon_lying = new /icon('dam_human.dmi', "[src.dam_icon_state]-2") // and for lying down
		src.dam_icon_lying.Blend(new /icon('dam_mask.dmi', "[O.r_name]-2"), ICON_MULTIPLY)