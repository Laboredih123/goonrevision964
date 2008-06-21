/mob/carbon/proc/is_muzzled()
	return istype(src.mask, /obj/item/weapon/clothing/mask/muzzle)

/mob/carbon/proc/is_blindfolded()
	return istype(src.glasses, /obj/item/weapon/clothing/glasses/blindfold)

/mob/proc/is_handcuffed()
	if (istype(src.handcuffs, /obj/item/weapon/handcuffs))
		return 1
	if(istype(src.suit, /obj/item/weapon/clothing/suit/straight_jacket))
		return 1
	return 0

/mob/carbon/proc/can_use_hands()
	if(src.is_handcuffed())
		return 0
	if(src.buckled)
		return 0
	if(!src.is_active())
		return 0
	return 1

/mob/carbon/is_active()
	if(src.is_dead)
		return
	if(!src.is_conscious())
		return
	if(src.knockdown > 0)
		return