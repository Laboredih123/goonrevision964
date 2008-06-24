/mob/carbon/is_muzzled()
	return istype(src.mask, /obj/item/weapon/clothing/mask/muzzle)

/mob/carbon/is_blindfolded()
	return istype(src.glasses, /obj/item/weapon/clothing/glasses/blindfold)

/mob/carbon/is_handcuffed()
	if (istype(src.handcuffs, /obj/item/weapon/handcuffs))
		return 1
	if(istype(src.suit, /obj/item/weapon/clothing/suit/straight_jacket))
		return 1
	return ..()

/mob/carbon/can_use_hands()
	if(src.is_handcuffed())
		return 0
	if(src.buckled)
		return 0
	return ..()

/mob/carbon/is_active()
	if(src.knockdown > 0)
		return 0
	return ..()

/mob/carbon/proc/swap_hand()
	src.hand = !( src.hand )
	if(src.hud && src.hud.hand)
		if (!( src.hand ))
			src.hud.hand.dir = NORTH
		else
			src.hud.hand.dir = SOUTH

/mob/carbon/is_conscious()
	if(src.knockout > 0)
		return 0
	return ..()

/mob/carbon/abiotic()
	if (src.l_hand && !( src.l_hand.abstract ))
		return 1
	if (src.r_hand && !( src.r_hand.abstract ))
		return 1
	if (src.back)
		return 1
	if (src.mask)
		return 1
	if (src.helmet)
		return 1
	if (src.shoes)
		return 1
	if (src.jumpsuit)
		return 1
	if (src.suit)
		return 1
	if (src.headset)
		return 1
	if (src.glasses)
		return 1
	if (src.gloves)
		return 1