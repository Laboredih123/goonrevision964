/mob/carbon/proc/is_muzzled()
	return istype(src.mask, /obj/item/weapon/clothing/mask/muzzle)

/mob/carbon/proc/is_blindfolded()
	return istype(src.glasses, /obj/item/weapon/clothing/glasses/blindfold)

/mob/carbon/proc/is_handcuffed() //in cuffs or straitjacket
	return istype(src.handcuffs, /obj/item/weapon/handcuffs) || istype(src.suit, /obj/item/weapon/clothing/suit/straight_jacket)

/mob/carbon/proc/is_restrained()
	if(src.buckled)
		return 1
	return 0